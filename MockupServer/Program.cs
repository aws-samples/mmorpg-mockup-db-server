/*
  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
  
  Licensed under the Apache License, Version 2.0 (the "License").
  You may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
      http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

using Amazon.CloudWatch;
using Amazon.CloudWatch.Model;
using MockupServer;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System.Data.Common;
using System.Data.SqlClient;
using System.Diagnostics;

static void DebugWriteLine(string message)
{
#if DEBUG
    Console.WriteLine(message);
#endif
}

DbConnection GetDBConnection(ConnectDBType connectDB, string connectString)
{
    if (connectDB == ConnectDBType.MSSQL)
    {
        return new SqlConnection(connectString);
    }

    return new MySqlConnection(connectString);
}
IDBTestRunner? GetTestRunner(DBConfig conf, TextWriter writer, DbConnection connection, long k, long process_index)
{
    if (conf.ConnectDB == ConnectDBType.MSSQL)
    {
        SqlConnection? sqlConnection = connection as SqlConnection;
        if (sqlConnection == null)
        {
            return null;
        }

        return new DBSPTestRunner(sqlConnection, writer, conf.Script, k, process_index);
    }

    MySqlConnection? mySqlConnection = connection as MySqlConnection;
    if (mySqlConnection == null)
    {
        return null;
    }

    if (conf.Method == MethodType.JSON)
    {
        return new DBJsonTestRunner(mySqlConnection, writer, conf.Script, k, process_index);
    }

    return new DBTempTableTestRunner(mySqlConnection, writer, conf.Script, k, process_index);
}

long totalElapsedMilliSeconds = 0;
long totalPeriodMilliSeconds = 0;
var rand = new Random();

string jsonFilePath = Path.Combine(AppContext.BaseDirectory, "config.json");
string jsonString = File.ReadAllText(jsonFilePath);

DBConfig? conf = JsonConvert.DeserializeObject<DBConfig>(jsonString);
if (conf is null)
{
    DebugWriteLine("Need configuration in json string - config.json");
    return;
}
if (conf.MaxThreadCount <= 0 || conf.TestTimeMS <= 0)
{
    throw new ArgumentException("Invalid configuration values");
}


DebugWriteLine(JsonConvert.SerializeObject(conf, Formatting.Indented));

// 로그 파일 기록
string logFilePath = conf.LogFile;
using var writer = System.IO.TextWriter.Synchronized(new StreamWriter(logFilePath, true));

// 호출 시간 기록
Stopwatch stopwatchPeriod = Stopwatch.StartNew();
bool isTesting = true;
// 호출 횟수 기록
long total_call_cnt = 0, prev_call_cnt = 0;
long total_elapsed_msec = 0, prev_elapsed_msec = 0;
long total_thread_cnt = 0;
long process_index = 0;

// DB identity
long item_index = 0;

if (args.Length >= 1)
{
    long.TryParse(args[0], out process_index);
    // Can overwrite ConnectDB and ConnectString with commandline arguments(Is Needed when test from Systems Manager)
    if (args.Length == 3)
    {
        if (args[1] == "MySQL")
        {
            conf.ConnectDB = ConnectDBType.MySQL;
        }
        else
        {
            conf.ConnectDB = ConnectDBType.MSSQL;
        }

        conf.ConnectString = args[2];
    }
}

// pre-define inventory identity value
item_index = process_index * conf.GuidProcessIndex;

writer.WriteLine($"{DateTime.Now} {JsonConvert.SerializeObject(conf, Formatting.Indented)}");
writer.Flush();

using var cloudWatchClient = new AmazonCloudWatchClient();

void PutMetricData(string metricNamespace, string metricName, long metricValue)
{
    var putMetricDataRequest = new PutMetricDataRequest
    {
        Namespace = metricNamespace,
        MetricData = new List<MetricDatum>
            {
                new MetricDatum
                {
                    MetricName = metricName,
                    Value = metricValue,
                    Unit = StandardUnit.None,
                    StorageResolution = 1,
                }
            }
    };
    cloudWatchClient.PutMetricDataAsync(putMetricDataRequest);
}

void CheckMetricsPerSecond()
{
    do
    {
        Thread.Sleep(1000); // wait 1 sec
        long curr_call_cnt = total_call_cnt;
        long calls_per_second = curr_call_cnt - prev_call_cnt;
        prev_call_cnt = curr_call_cnt;
        DebugWriteLine($"Batch per Second: {calls_per_second}");
        //writer.WriteLine($"{DateTime.Now} Batch per Second: {calls_per_second}");
        PutMetricData("DBTestMetric", "TotalBatchPerSecond-" + conf.ConnectDB.ToString() , calls_per_second);

        long curr_elapsed_msec = total_elapsed_msec;
        long curr_elapsed_sum_per_second = curr_elapsed_msec - prev_elapsed_msec;
        prev_elapsed_msec = curr_elapsed_msec;
        long avr_latency = (calls_per_second <= 0) ? 0 : curr_elapsed_sum_per_second / Math.Max(calls_per_second, 1);
        DebugWriteLine($"Avr latency per Second: {avr_latency}");
        //writer.WriteLine($"{DateTime.Now} Avr latency per Second: {avr_latency}");
        PutMetricData("DBTestMetric", "AvrLatencyPerSecond-" + conf.ConnectDB.ToString(), avr_latency);

        DebugWriteLine($"Total active thread cnt: {total_thread_cnt}");
        //writer.WriteLine($"{DateTime.Now} Total active thread cnt: {total_thread_cnt}");
        PutMetricData("DBTestMetric", "TotalActiveThreadCnt-" + conf.ConnectDB.ToString(), total_thread_cnt);
    } while (isTesting);
}

Thread checkMetricsPerSecondThread = new Thread(CheckMetricsPerSecond);
checkMetricsPerSecondThread.Start();

Parallel.For(0, conf.MaxThreadCount, k =>
{
    using (DbConnection connection = GetDBConnection(conf.ConnectDB, conf.ConnectString))
    {
        try
        {
            System.Threading.Interlocked.Increment(ref total_thread_cnt);
            int call_cnt = 0;

            // 연결 열기
            connection.Open();

            // 호출 시간 기록
            Stopwatch stopwatch = Stopwatch.StartNew();

            IDBTestRunner? runner = GetTestRunner(conf, writer, connection, k, process_index);
            if (runner == null)
            {
                return;
            }

            Stopwatch stopwatch_duration = Stopwatch.StartNew();
            do
            {
                runner.Run(ref total_call_cnt, ref total_elapsed_msec, ref total_thread_cnt, ref item_index, call_cnt, process_index);
                ++call_cnt;
            } while (stopwatch_duration.ElapsedMilliseconds < conf.TestTimeMS);

            // 응답 시간 기록
            stopwatch.Stop();

            long elapsedMilliseconds = stopwatch.ElapsedMilliseconds;
            DebugWriteLine($"procedure call completed. elapsed: {elapsedMilliseconds} ms, call count: {call_cnt}");
            System.Threading.Interlocked.Add(ref totalElapsedMilliSeconds, elapsedMilliseconds);
        }
        catch (Exception ex)
        {
            DebugWriteLine($"Exception has occurredin program: {ex.Message}");
            writer.WriteLine($"{DateTime.Now} Exception has occurred in program: {ex.Message}");
            return;
        }
        finally
        {
            connection.Close();
            System.Threading.Interlocked.Decrement(ref total_thread_cnt);
        }
    }
});

isTesting = false;
checkMetricsPerSecondThread.Join();

stopwatchPeriod.Stop();
totalPeriodMilliSeconds = stopwatchPeriod.ElapsedMilliseconds;

long averagyElapsedMilliSeconds = totalElapsedMilliSeconds / total_call_cnt, averageBps = total_call_cnt / (totalPeriodMilliSeconds / 1000);
DebugWriteLine($"Test Total({conf.MaxThreadCount} conn,{conf.TestTimeMS} ms) call completed. total spend: {totalPeriodMilliSeconds}, total elapsed: {totalElapsedMilliSeconds} ms, total call count: {total_call_cnt}, average elapsed: {averagyElapsedMilliSeconds} ms, average bps: {averageBps}");
writer.WriteLine($"{DateTime.Now} {conf.ConnectDB.ToString()} Test Total({conf.MaxThreadCount} conn,{conf.TestTimeMS} ms) call completed. total spend: {totalPeriodMilliSeconds}, total elapsed: {totalElapsedMilliSeconds} ms, total call count: {total_call_cnt}, average elapsed: {averagyElapsedMilliSeconds} ms, average bps: {averageBps}");

writer.Close();
