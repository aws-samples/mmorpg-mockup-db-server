/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;

enum ConnectDBType
{
    MSSQL,
    MySQL,
}

enum MethodType
{
    SP,
    Transaction,
    JSON,
    TemporaryTable,
}

internal class DBConfig
{
    /*
    public DBConfig(ConnectDBType connectDB, string connectString, long maxThreadCount, long testTimeMS, MethodType method, long ec2Index)
    {
        ConnectDB = connectDB;
        ConnectString = connectString;
        MaxThreadCount = maxThreadCount;
        TestTimeMS = testTimeMS;
        Method = method;
        EC2Index = ec2Index;
    }
    */
    [JsonConverter(typeof(StringEnumConverter))]
    public ConnectDBType ConnectDB { get; set; }
    public required string ConnectString { get; set; }
    public long MaxThreadCount { get; set; }
    public long TestTimeMS { get; set; }
    public long EC2Index { get; set; }
    public List<Script>? Script { get; set; }
    public MethodType Method { get; set; }
    public string LogFile { get; set; }
    public long GuidProcessIndex { get; set; }
}

public class Script
{
    public int Index { get; set; }
    public int? Count { get; set; }
    public int? DelayMS { get; set; }
    public List<Procedure>? Procedures { get; set; }
}

public class Procedure
{
    public required string Name { get; set; }
    public int? Probability { get; set; }
}

internal class IDBTestRunner : IDisposable
{
    protected void DebugWriteLine(string message)
    {
#if DEBUG
    Console.WriteLine(message);
#endif
    }

    public IDBTestRunner(DbConnection connection, TextWriter writer, List<Script>? scripts, long thread_index = 0, long process_index = 0)
    {
        connection_ = connection;
        thread_index_ = thread_index;
        process_index_ = process_index;
        scripts_ = scripts;
        writer_ = writer;
    }
    public void Dispose() { }
    public virtual int Run(ref long total_call_cnt, ref long total_elapsed_msec, ref long total_thread_cnt, ref long item_index, int i = 0, long process_index = 0)
    {
        long accountUid = 0, charUid = 0, charExp = 0, currencyTid = 145, currencyValue = 0;
        string charName = "";
        byte charType = 0;
        int charLevel = 0;
        List<Equipment> equipments = new List<Equipment>();
        List<Item> items = new List<Item>();
        List<Currency> currencies = new List<Currency>();
        List<Hero> heroes = new List<Hero>();
        List<Quest> quests = new List<Quest>();
        List<Achievement> achievements = new List<Achievement>();
        List<Collection> collections = new List<Collection>();
        List<Post> posts = new List<Post>();

        if (scripts_ == null)
        {
            return 0;
        }

        // 중단할 때까지 무한반복
        //while (mySQLConnection != null)
        try
        {
            //System.Threading.Interlocked.Increment(ref total_thread_cnt);
            foreach (var script in scripts_)
            {
                DebugWriteLine($"Script Index : {script.Index}");
                if (script.Procedures == null)
                {
                    continue;
                }
                if (!script.Count.HasValue)
                {
                    script.Count = 1;
                }
                for (int runCnt = 0; runCnt < script.Count; ++runCnt)
                {
                    if (script.DelayMS.HasValue)
                    {
                        Thread.Sleep((int)script.DelayMS);
                    }
                    // 만분율 중 확률로 구함
                    Random random = new Random();
                    var randVal = random.Next(0, 10000);
                    int? probabilitySum = 0;
                    foreach (var s in script.Procedures)
                    {
                        if (s.Probability.HasValue)
                        {
                            probabilitySum += s.Probability;
                        }
                        else
                        {
                            probabilitySum = 10000;
                        }
                        if (randVal < probabilitySum)
                        {
                            DebugWriteLine($"Procedure : {s.Name}");
                            //writer_.WriteLine($"Procedure : {s.Name}");

                            Stopwatch stopwatch_duration = Stopwatch.StartNew();
                            switch (s.Name)
                            {
                                case "AccountLogin":
                                    {
                                        RunAccountLogin(i, ref accountUid, ref charUid, ref charExp, ref charName, ref charType, ref charLevel);
                                        break;
                                    }
                                case "CharacterCreateOrLogin":
                                    {
                                        if (charUid == 0)
                                        {
                                            RunCharacterCreate(i, accountUid, ref charUid, ref charExp, ref charName, ref charType, ref charLevel);
                                        }
                                        else
                                        {
                                            RunCharacterLogin(accountUid, charUid, ref equipments, ref items, ref currencies, ref heroes, ref quests, ref achievements, ref collections, ref posts);
                                        }
                                        break;
                                    }
                                case "HeroGacha":
                                    {
                                        RunHeroGacha(charUid, ref heroes);
                                        break;
                                    }
                                case "ItemGacha":
                                    {
                                        RunItemCreateBundle(charUid, ref items, ref item_index);
                                        break;
                                    }
                                case "MonsterDrop":
                                    {
                                        RunItemCreateBundle(charUid, ref items, ref item_index);
                                        RunExpUpdate(charUid, ref charLevel, ref charExp);
                                        RunCurrencyUpdate(charUid, ref currencyTid, ref currencyValue);
                                        RunQuestUpdate(charUid, ref quests);
                                        RunAchievementUpdate(charUid, ref achievements);

                                        System.Threading.Interlocked.Increment(ref total_call_cnt);
                                        System.Threading.Interlocked.Increment(ref total_call_cnt);
                                        System.Threading.Interlocked.Increment(ref total_call_cnt);
                                        System.Threading.Interlocked.Increment(ref total_call_cnt);
                                        break;
                                    }
                                case "QuestReward":
                                    {
                                        RunQuestReward(charUid, ref quests, ref item_index, charLevel, charExp);
                                        break;
                                    }
                                case "AchievementReward":
                                    {
                                        RunAchievementReward(charUid, ref achievements, ref item_index, charLevel, charExp);
                                        break;
                                    }
                                case "EquipChange":
                                    {
                                        RunEquipChange(charUid, ref equipments, ref items);
                                        break;
                                    }
                                case "ItemExpChange":
                                    {
                                        RunItemExpChange(charUid, ref items);
                                        break;
                                    }
                                case "AccountLogout":
                                    {
                                        RunAccountLogout(accountUid, charUid);
                                        break;
                                    }
                            }
                            stopwatch_duration.Stop();
                            long elapsed_msec = stopwatch_duration.ElapsedMilliseconds;
                            System.Threading.Interlocked.Add(ref total_elapsed_msec, elapsed_msec);
                            System.Threading.Interlocked.Increment(ref total_call_cnt);
                            break;
                        }
                    }
                }
            }
            //System.Threading.Interlocked.Decrement(ref total_thread_cnt);
        }
        catch (Exception ex)
        {
            DebugWriteLine(ex.Message);
            writer_.WriteLine($"{DateTime.Now} 예외 발생 in Run: {ex.Message}");
            //System.Threading.Interlocked.Decrement(ref total_thread_cnt);
        }

        return 0;
    }

    protected virtual void RunAccountLogout(long accountUid, long charUid) { throw new NotImplementedException(); }
    protected virtual void RunItemExpChange(long charUid, ref List<Item> items) { throw new NotImplementedException(); }
    protected virtual void RunEquipChange(long charUid, ref List<Equipment> equipments, ref List<Item> items) { throw new NotImplementedException(); }
    protected virtual void RunAchievementReward(long charUid, ref List<Achievement> achieves, ref long item_index, int charLevel, long charExp) { throw new NotImplementedException(); }
    protected virtual void RunQuestReward(long charUid, ref List<Quest> quests, ref long item_index, int charLevel, long charExp) { throw new NotImplementedException(); }
    protected virtual void RunAchievementUpdate(long charUid, ref List<Achievement> achievements) { throw new NotImplementedException(); }
    protected virtual void RunQuestUpdate(long charUid, ref List<Quest> quests) {  throw new NotImplementedException(); }
    protected virtual void RunCurrencyUpdate(long charUid, ref long currencyTid, ref long currencyValue) { throw new NotImplementedException(); }
    protected virtual void RunExpUpdate(long charUid, ref int charLevel, ref long charExp) { throw new NotImplementedException(); }
    protected virtual void RunItemCreateBundle(long charUid, ref List<Item> items, ref long item_index) { throw new NotImplementedException(); }
    protected virtual void RunHeroGacha(long charUid, ref List<Hero> heroes) {  throw new NotImplementedException(); }
    protected virtual void RunCharacterLogin(long accountUid, long charUid, ref List<Equipment> equipments, ref List<Item> items, ref List<Currency> currencies, ref List<Hero> heroes, ref List<Quest> quests, ref List<Achievement> achievements, ref List<Collection> collections, ref List<Post> posts)
    { throw new NotImplementedException(); }
    protected virtual void RunCharacterCreate(int i, long accountUid, ref long charUid, ref long charExp, ref string charName, ref byte charType, ref int charLevel)
    { throw new NotImplementedException(); }
    protected virtual void RunAccountLogin(int i, ref long accountUid, ref long charUid, ref long charExp, ref string charName, ref byte charType, ref int charLevel)
    { throw new NotImplementedException(); }

    protected long GetUniqueGuid(int count)
    { return process_index_ * 1000000000000 + thread_index_ * 10000000 + count * 100 + 1; }


    protected DbConnection connection_;
    protected long thread_index_;
    protected long process_index_;
    protected List<Script>? scripts_;
    protected TextWriter writer_;

    protected class Equipment
    {
        public long uid_ { get; set; }
        public short slot_ { get; set; }
    }

    protected struct Item
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public byte type_ { get; set; }
        public int level_ { get; set; }
        public long exp_ { get; set; }
        public int count_ { get; set; }
        public DateTime expireDate_ { get; set; }
    };

    protected class Currency
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public long value_ { get; set; }
    }

    protected class Hero
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public byte grade_ { get; set; }
        public int level_ { get; set; }
        public long exp_ { get; set; }
        public byte enchant_ { get; set; }
    }

    protected class Quest
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public short category1_ { get; set; }
        public short category2_ { get; set; }
        public long value1_ { get; set; }
        public long value2_ { get; set; }
        public byte state_ { get; set; }
    }

    protected class Achievement
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public short category1_ { get; set; }
        public short category2_ { get; set; }
        public long value1_ { get; set; }
        public long value2_ { get; set; }
        public byte state_ { get; set; }
    }

    protected class Collection
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public short type_ { get; set; }
        public byte state_ { get; set; }
        public long value1_ { get; set; }
        public long value2_ { get; set; }
        public long value3_ { get; set; }
        public long value4_ { get; set; }
        public long value5_ { get; set; }
        public long value6_ { get; set; }
    }

    protected class Post
    {
        public long uid_ { get; set; }
        public long tid_ { get; set; }
        public long rewardTid_ { get; set; }
        public long rewardValue_ { get; set; }
        public byte rewardIsReaded_ { get; set; }
        public DateTime rewardExpireDate_ { get; set; }
    }
}
