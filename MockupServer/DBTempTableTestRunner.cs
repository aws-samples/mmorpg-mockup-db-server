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
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MockupServer
{
    internal class DBTempTableTestRunner : IDBTestRunner
    {
        public DBTempTableTestRunner(MySqlConnection connection, TextWriter writer, List<Script>? scripts, long thread_index = 0, long ec2index = 0)
            : base(connection, writer, scripts, thread_index, ec2index) { }

        protected override void RunAccountLogout(long accountUid, long charUid)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdAccountLogout = new MySqlCommand("spAccountLogout", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdAccountLogout.Parameters.AddWithValue("par_AccountUid", accountUid);
            cmdAccountLogout.Parameters.AddWithValue("par_CharUid", charUid);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdAccountLogout.Parameters.Add(outParam);

            cmdAccountLogout.ExecuteNonQuery();
        }

        protected override void RunItemExpChange(long charUid, ref List<Item> items)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            if (items.Count == 0)
            {
                return;
            }

            Random rand = new Random();
            int randIndex = rand.Next(0, items.Count);
            var item = items[randIndex];
            item.level_ += rand.Next(0, 1);
            item.exp_ += rand.Next(0, 100);

            MySqlCommand cmdItemExpChange = new MySqlCommand("spItemUpdateExp", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdItemExpChange.Parameters.AddWithValue("par_CharUid", charUid);
            cmdItemExpChange.Parameters.AddWithValue("par_ItemUid", item.uid_);
            cmdItemExpChange.Parameters.AddWithValue("par_UpdateLevel", item.level_);
            cmdItemExpChange.Parameters.AddWithValue("par_UpdateExp", item.exp_);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdItemExpChange.Parameters.Add(outParam);

            cmdItemExpChange.ExecuteNonQuery();
        }

        protected override void RunEquipChange(long charUid, ref List<Equipment> equipments, ref List<Item> items)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            if (items.Count == 0)
            {
                return;
            }

            Random rand = new Random();
            int randIndex = rand.Next(0, items.Count);
            var item = items[randIndex];
            int randSlotIndex = rand.Next(0, 6);

            MySqlCommand cmdEquipChange = new MySqlCommand("spEquipChange", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdEquipChange.Parameters.AddWithValue("par_CharUid", charUid);
            cmdEquipChange.Parameters.AddWithValue("par_ItemUid", item.uid_);
            cmdEquipChange.Parameters.AddWithValue("par_Slot", randSlotIndex);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdEquipChange.Parameters.Add(outParam);

            cmdEquipChange.ExecuteNonQuery();
        }

        protected override void RunAchievementReward(long charUid, ref List<Achievement> achieves, ref long item_index, int charLevel, long charExp)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            if (achieves.Count == 0)
                return;

            int i = 0;
            for (i = 0; i < achieves.Count; ++i)
            {
                if (achieves[i].state_ != 255)
                {
                    var achieve = achieves[i];
                    Random rand = new Random();
                    int randIndex = rand.Next(0, achieves.Count);
                    MySqlCommand cmdAchieveReward = new MySqlCommand("spAchievementComplete", sqlConnection)
                    {
                        CommandType = System.Data.CommandType.StoredProcedure
                    };

                    cmdAchieveReward.Parameters.AddWithValue("par_AchieveUid", achieve.uid_);
                    cmdAchieveReward.Parameters.AddWithValue("par_CharUid", charUid);
                    cmdAchieveReward.Parameters.AddWithValue("par_CurrentLevel", charLevel);
                    cmdAchieveReward.Parameters.AddWithValue("par_CurrentExp", charExp);
                    cmdAchieveReward.Parameters.AddWithValue("par_DeltaExp", rand.Next(0, 10));

                    // HeroType
                    string insertHeroQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempHeroGacha (
                            CharUid BIGINT NOT NULL,
                            HeroTid BIGINT NOT NULL,
                            Grade TINYINT NOT NULL,
                            Level INT NOT NULL,
                            Exp BIGINT NOT NULL,
                            Enchant TINYINT NOT NULL
                        );

                        INSERT INTO TempHeroGacha (CharUid, HeroTid, Grade, Level, Exp, Enchant)
                        VALUES ";
                    var randGachaCount = rand.Next(1, 3);
                    for (long cnt = 0; cnt < randGachaCount; ++cnt)
                    {
                        insertHeroQuery += String.Format(@"({0},{1},{2},{3},{4},{5})"
                                                    , charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(0, 10));
                        if (cnt + 1 < randGachaCount)
                        {
                            insertHeroQuery += ",";
                        }
                    }
                    insertHeroQuery += ";";

                    MySqlCommand commandHero = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempHeroGacha;", sqlConnection);
                    commandHero.ExecuteNonQuery();

                    commandHero = new MySqlCommand(insertHeroQuery, sqlConnection);
                    commandHero.ExecuteNonQuery();

                    // ItemType
                    string insertItemQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempItemCreateBundle (
                            CharUid BIGINT NOT NULL,
                            ItemTid BIGINT NOT NULL,
                            `Type` TINYINT NOT NULL,
                            `Level` INT NOT NULL,
                            `Exp` BIGINT NOT NULL,
                            `Count` INT NOT NULL,
                            ExpireDate DATETIME NULL
                        );

                        INSERT INTO TempItemCreateBundle (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
                        VALUES ";
                    randGachaCount = rand.Next(1, 3);
                    for (long cnt = 0; cnt < randGachaCount; ++cnt)
                    {
                        insertItemQuery += String.Format(@"({0},{1},{2},{3},{4},{5},NULL)"
                                                    , charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 10), rand.Next(0, 1000), rand.Next(0, 10));
                        if (cnt + 1 < randGachaCount)
                        {
                            insertItemQuery += ",";
                        }
                    }
                    insertItemQuery += ";";

                    MySqlCommand commandItem = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempItemCreateBundle;", sqlConnection);
                    commandItem.ExecuteNonQuery();

                    commandItem = new MySqlCommand(insertItemQuery, sqlConnection);
                    commandItem.ExecuteNonQuery();

                    // CurrencyType
                    string insertCurrencyQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempCurrency (
                            CharUid BIGINT NOT NULL,
                            CurrencyTid BIGINT NOT NULL,
                            Value BIGINT NOT NULL
                        );

                        INSERT INTO temp_currency (CharUid, CurrencyTid, Value)
                        VALUES ";
                    insertCurrencyQuery += String.Format(@"({0},{1},{2});"
                                                , charUid, rand.Next(1, 8), rand.Next(1, 10));

                    MySqlCommand commandCurrency = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS temp_currency;", sqlConnection);
                    commandCurrency.ExecuteNonQuery();

                    commandCurrency = new MySqlCommand(insertItemQuery, sqlConnection);
                    commandCurrency.ExecuteNonQuery();

                    // quest + achievement - 안 사용하지만 생성은 해 두어야 함
                    string insertQuestQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempQuest (
                            CharUid BIGINT NOT NULL,
                            QuestTid BIGINT NOT NULL,
                            Category1 SMALLINT NOT NULL,
                            Category2 SMALLINT NOT NULL,
                            Value1 BIGINT NOT NULL,
                            Value1 BIGINT NOT NULL,
                            State TINYINT NOT NULL
                        );";

                    MySqlCommand commandQuest = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempQuest;", sqlConnection);
                    commandQuest.ExecuteNonQuery();

                    commandQuest = new MySqlCommand(insertQuestQuery, sqlConnection);
                    commandQuest.ExecuteNonQuery();

                    string insertAchievementQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempAchievement (
                            CharUid BIGINT NOT NULL,
                            AchieveTid BIGINT NOT NULL,
                            Category1 SMALLINT NOT NULL,
                            Category2 SMALLINT NOT NULL,
                            Value1 BIGINT NOT NULL,
                            Value1 BIGINT NOT NULL,
                            State TINYINT NOT NULL
                        );";

                    MySqlCommand commandAchieve = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempAchievement;", sqlConnection);
                    commandAchieve.ExecuteNonQuery();

                    commandAchieve = new MySqlCommand(insertAchievementQuery, sqlConnection);
                    commandAchieve.ExecuteNonQuery();

                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    MySqlParameter outParam = new MySqlParameter();
                    outParam.ParameterName = "ReturnCode";
                    outParam.MySqlDbType = MySqlDbType.Int32;
                    outParam.Direction = ParameterDirection.Output;
                    cmdAchieveReward.Parameters.Add(outParam);

                    cmdAchieveReward.ExecuteNonQuery();

                    achieves[i].state_ = 255;
                    break;
                }
            }
        }

        protected override void RunQuestReward(long charUid, ref List<Quest> quests, ref long item_index, int charLevel, long charExp)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            if (quests.Count == 0)
                return;

            for (int i = 0; i < quests.Count; ++i)
            {
                if (quests[i].state_ != 255)
                {
                    var quest = quests[i];
                    Random rand = new Random();
                    int randIndex = rand.Next(0, quests.Count);
                    MySqlCommand cmdQuestReward = new MySqlCommand("spQuestComplete", sqlConnection)
                    {
                        CommandType = System.Data.CommandType.StoredProcedure
                    };

                    cmdQuestReward.Parameters.AddWithValue("par_QuestUid", quest.uid_);
                    cmdQuestReward.Parameters.AddWithValue("par_CharUid", charUid);
                    cmdQuestReward.Parameters.AddWithValue("par_CurrentLevel", charLevel);
                    cmdQuestReward.Parameters.AddWithValue("par_CurrentExp", charExp);
                    cmdQuestReward.Parameters.AddWithValue("par_DeltaExp", rand.Next(0, 10));

                    // HeroType
                    string insertHeroQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempHeroGacha (
                            `CharUid` BIGINT NOT NULL,
                            `HeroTid` BIGINT NOT NULL,
                            `Grade` TINYINT NOT NULL,
                            `Level` INT NOT NULL,
                            `Exp` BIGINT NOT NULL,
                            `Enchant` TINYINT NOT NULL
                        );

                        INSERT INTO TempHeroGacha (`CharUid`, `HeroTid`, `Grade`, `Level`, `Exp`, `Enchant`)
                        VALUES ";
                    var randGachaCount = rand.Next(1, 3);
                    for (long cnt = 0; cnt < randGachaCount; ++cnt)
                    {
                        insertHeroQuery += String.Format(@"({0},{1},{2},{3},{4},{5})"
                                                    , charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(0, 10));
                        if (cnt + 1 < randGachaCount)
                        {
                            insertHeroQuery += ",";
                        }
                    }
                    insertHeroQuery += ";";

                    MySqlCommand commandHero = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempHeroGacha;", sqlConnection);
                    commandHero.ExecuteNonQuery();

                    commandHero = new MySqlCommand(insertHeroQuery, sqlConnection);
                    commandHero.ExecuteNonQuery();

                    // ItemType
                    string insertItemQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS TempItemCreateBundle (
                            CharUid BIGINT NOT NULL,
                            ItemTid BIGINT NOT NULL,
                            `Type` TINYINT NOT NULL,
                            `Level` INT NOT NULL,
                            `Exp` BIGINT NOT NULL,
                            `Count` INT NOT NULL,
                            ExpireDate DATETIME NULL
                        );

                        INSERT INTO TempItemCreateBundle (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
                        VALUES ";
                    randGachaCount = rand.Next(1, 3);
                    for (long cnt = 0; cnt < randGachaCount; ++cnt)
                    {
                        insertItemQuery += String.Format(@"({0},{1},{2},{3},{4},{5},NULL)"
                                                    , charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 10), rand.Next(0, 1000), rand.Next(0, 10));
                        if (cnt + 1 < randGachaCount)
                        {
                            insertItemQuery += ",";
                        }
                    }
                    insertItemQuery += ";";

                    MySqlCommand commandItem = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempItemCreateBundle;", sqlConnection);
                    commandItem.ExecuteNonQuery();

                    commandItem = new MySqlCommand(insertItemQuery, sqlConnection);
                    commandItem.ExecuteNonQuery();

                    // CurrencyType
                    string jsonCurrencyType = "[";
                    jsonCurrencyType += String.Format(@"{{""CharUid"": {0},""CurrencyTid"": {1},""Value"": {2}}}"
                                                , charUid, rand.Next(1, 8), rand.Next(1, 10));
                    jsonCurrencyType += "]";

                    string insertCurrencyQuery = @"
                        CREATE TEMPORARY TABLE IF NOT EXISTS temp_currency (
                            CharUid BIGINT NOT NULL,
                            CurrencyTid BIGINT NOT NULL,
                            Value BIGINT NOT NULL
                        );

                        INSERT INTO temp_currency (CharUid, CurrencyTid, Value)
                        VALUES ";
                    insertCurrencyQuery += String.Format(@"({0},{1},{2});"
                                                , charUid, rand.Next(1, 8), rand.Next(1, 10));

                    MySqlCommand commandCurrency = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS temp_currency;", sqlConnection);
                    commandCurrency.ExecuteNonQuery();

                    commandCurrency = new MySqlCommand(insertItemQuery, sqlConnection);
                    commandCurrency.ExecuteNonQuery();


                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    MySqlParameter outParam = new MySqlParameter();
                    outParam.ParameterName = "ReturnCode";
                    outParam.MySqlDbType = MySqlDbType.Int32;
                    outParam.Direction = ParameterDirection.Output;
                    cmdQuestReward.Parameters.Add(outParam);

                    cmdQuestReward.ExecuteNonQuery();

                    quests[i].state_ = 255;

                    return;
                }
            }
        }

        protected override void RunAchievementUpdate(long charUid, ref List<Achievement> achievements)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdAchievementUpdate = new MySqlCommand("spAchievementUpdateProgress", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            Random rand = new Random();
            long achievementTid = rand.Next(1, 1231435);
            short category1 = (short)rand.Next(1, 100);
            short category2 = (short)rand.Next(1, 50);
            long value1 = rand.Next(10);
            long value2 = rand.Next(50);
            byte state = 1;

            if (achievements.Count > 0 && rand.Next(100) < 50)
            {
                int randIndex = rand.Next(achievements.Count);
                achievementTid = achievements[randIndex].tid_;
                category1 = achievements[randIndex].category1_;
                category2 = achievements[randIndex].category2_;
                value1 = achievements[randIndex].value1_;
                value2 = achievements[randIndex].value2_;
                int intState = achievements[randIndex].state_ + 1;
                state = (byte)intState;
            }
            cmdAchievementUpdate.Parameters.AddWithValue("par_AchieveTid", achievementTid);
            cmdAchievementUpdate.Parameters.AddWithValue("par_CharUid", charUid);
            cmdAchievementUpdate.Parameters.AddWithValue("par_Category1", category1);
            cmdAchievementUpdate.Parameters.AddWithValue("par_Category2", category2);
            cmdAchievementUpdate.Parameters.AddWithValue("par_Value1", value1);
            cmdAchievementUpdate.Parameters.AddWithValue("par_Value2", value2);
            cmdAchievementUpdate.Parameters.AddWithValue("par_State", state);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdAchievementUpdate.Parameters.Add(outParam);

            cmdAchievementUpdate.ExecuteNonQuery();
        }

        protected override void RunQuestUpdate(long charUid, ref List<Quest> quests)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdQuestUpdate = new MySqlCommand("spQuestUpdateProgress", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            Random rand = new Random();
            long questTid = rand.Next(1, 1231435);
            short category1 = (short)rand.Next(1, 100);
            short category2 = (short)rand.Next(1, 50);
            long value1 = rand.Next(10);
            long value2 = rand.Next(50);
            byte state = 1;

            if (quests.Count > 0 && rand.Next(100) < 50)
            {
                int randIndex = rand.Next(quests.Count);
                questTid = quests[randIndex].tid_;
                category1 = quests[randIndex].category1_;
                category2 = quests[randIndex].category2_;
                value1 = quests[randIndex].value1_;
                value2 = quests[randIndex].value2_;
                int intState = quests[randIndex].state_ + 1;
                state = (byte)intState;
            }
            cmdQuestUpdate.Parameters.AddWithValue("par_QuestTid", questTid);
            cmdQuestUpdate.Parameters.AddWithValue("par_CharUid", charUid);
            cmdQuestUpdate.Parameters.AddWithValue("par_Category1", category1);
            cmdQuestUpdate.Parameters.AddWithValue("par_Category2", category2);
            cmdQuestUpdate.Parameters.AddWithValue("par_Value1", value1);
            cmdQuestUpdate.Parameters.AddWithValue("par_Value2", value2);
            cmdQuestUpdate.Parameters.AddWithValue("par_State", state);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdQuestUpdate.Parameters.Add(outParam);

            cmdQuestUpdate.ExecuteNonQuery();
        }

        protected override void RunCurrencyUpdate(long charUid, ref long currencyTid, ref long currencyValue)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdCurrencyUpdate = new MySqlCommand("spCurrencyUpdate", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdCurrencyUpdate.Parameters.AddWithValue("par_CharUid", charUid);
            cmdCurrencyUpdate.Parameters.AddWithValue("par_CurrencyTid", currencyTid);
            cmdCurrencyUpdate.Parameters.AddWithValue("par_CurrentValue", currencyValue);
            Random rand = new Random();
            cmdCurrencyUpdate.Parameters.AddWithValue("par_DeltaValue", rand.Next(100, 10000));
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdCurrencyUpdate.Parameters.Add(outParam);

            MySqlDataReader readerCurrencyUpdate = cmdCurrencyUpdate.ExecuteReader();
            if (readerCurrencyUpdate.Read())
            {
                DebugWriteLine($"CurrencyValue: {currencyValue}");

                currencyValue = readerCurrencyUpdate.GetInt64(0);

                DebugWriteLine($"Updated - CurrencyValue: {currencyValue}");
            }

            readerCurrencyUpdate.Close();
        }

        protected override void RunExpUpdate(long charUid, ref int charLevel, ref long charExp)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdExpUpdate = new MySqlCommand("spExpUpdate", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdExpUpdate.Parameters.AddWithValue("par_CharUid", charUid);
            cmdExpUpdate.Parameters.AddWithValue("par_CurrentLevel", charLevel);
            cmdExpUpdate.Parameters.AddWithValue("par_CurrentExp", charExp);
            Random rand = new Random();
            cmdExpUpdate.Parameters.AddWithValue("par_DeltaExp", rand.Next(1, 100));
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdExpUpdate.Parameters.Add(outParam);

            MySqlDataReader readerExpUpdate = cmdExpUpdate.ExecuteReader();
            if (readerExpUpdate.Read())
            {
                DebugWriteLine($"CharLevel: {charLevel}, CharExp: {charExp}");

                charLevel = readerExpUpdate.GetInt32(0);
                charExp = readerExpUpdate.GetInt64(1);

                DebugWriteLine($"Updated - CharLevel: {charLevel}, CharExp: {charExp}");
            }

            readerExpUpdate.Close();
        }

        protected override void RunItemCreateBundle(long charUid, ref List<Item> items, ref long item_index)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            Random rand = new Random();
            string insertQuery = @"
                CREATE TEMPORARY TABLE IF NOT EXISTS TempItemCreateBundle (
                    CharUid BIGINT NOT NULL,
                    ItemTid BIGINT NOT NULL,
                    `Type` TINYINT NOT NULL,
                    `Level` INT NOT NULL,
                    `Exp` BIGINT NOT NULL,
                    `Count` INT NOT NULL,
                    ExpireDate DATETIME NULL
                );

                INSERT INTO TempItemCreateBundle (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
                VALUES ";
            var randGachaCount = rand.Next(1, 10);
            for (long cnt = 0; cnt < randGachaCount; ++cnt)
            {
                insertQuery += String.Format(@"({0},{1},{2},{3},{4},{5},NULL)"
                                            , charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 10), rand.Next(0, 1000), rand.Next(0, 10));
                if (cnt + 1 < randGachaCount)
                {
                    insertQuery += ",";
                }
            }
            insertQuery += ";";

            MySqlCommand command = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempItemCreateBundle;", sqlConnection);
            command.ExecuteNonQuery();

            command = new MySqlCommand(insertQuery, sqlConnection);
            command.ExecuteNonQuery();

            MySqlCommand cmdItemCreateBundle = new MySqlCommand("spItemCreateBundle", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdItemCreateBundle.Parameters.Add(outParam);

            MySqlDataReader readerItemCreateBundle = cmdItemCreateBundle.ExecuteReader();

            while (readerItemCreateBundle.Read())
            {
                Item readerItem = new Item();
                readerItem.uid_ = readerItemCreateBundle.GetInt64(0);
                readerItem.tid_ = readerItemCreateBundle.GetInt64(1);
                readerItem.type_ = readerItemCreateBundle.GetByte(2);
                readerItem.level_ = readerItemCreateBundle.GetInt32(3);
                readerItem.exp_ = readerItemCreateBundle.GetInt64(4);
                readerItem.count_ = readerItemCreateBundle.GetInt32(5);
                if (!readerItemCreateBundle.IsDBNull(6))
                {
                    readerItem.expireDate_ = readerItemCreateBundle.GetDateTime(6);
                }

                items.Add(readerItem);

                DebugWriteLine($"Added Item - charUid: {charUid}, itemUid: {readerItem.uid_}, ItemTid: {readerItem.tid_}");
            }

            readerItemCreateBundle.Close();
        }

        protected override void RunHeroGacha(long charUid, ref List<Hero> heroes)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            Random rand = new Random();
            string insertQuery = @"
                CREATE TEMPORARY TABLE IF NOT EXISTS TempHeroGacha (
                    `CharUid` BIGINT NOT NULL,
                    `HeroTid` BIGINT NOT NULL,
                    `Grade` TINYINT NOT NULL,
                    `Level` INT NOT NULL,
                    `Exp` BIGINT NOT NULL,
                    `Enchant` TINYINT NOT NULL
                );

                INSERT INTO TempHeroGacha (`CharUid`, `HeroTid`, `Grade`, `Level`, `Exp`, `Enchant`)
                VALUES ";
            var randGachaCount = rand.Next(1, 10);
            for (long cnt = 0; cnt < randGachaCount; ++cnt)
            {
                insertQuery += String.Format(@"({0},{1},{2},{3},{4},{5})"
                                            , charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(0, 10));
                if (cnt + 1 < randGachaCount)
                {
                    insertQuery += ",";
                }
            }
            insertQuery += ";";

            MySqlCommand command = new MySqlCommand("DROP TEMPORARY TABLE IF EXISTS TempHeroGacha;", sqlConnection);
            command.ExecuteNonQuery();

            command = new MySqlCommand(insertQuery, sqlConnection);
            command.ExecuteNonQuery();

            MySqlCommand cmdHeroGacha = new MySqlCommand("spHeroGacha", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdHeroGacha.Parameters.Add(outParam);

            MySqlDataReader readerHeroGacha = cmdHeroGacha.ExecuteReader();

            while (readerHeroGacha.Read())
            {
                Hero readerHero = new Hero();

                readerHero.uid_ = readerHeroGacha.GetInt64(0);
                readerHero.tid_ = readerHeroGacha.GetInt64(1);
                readerHero.grade_ = readerHeroGacha.GetByte(2);
                readerHero.level_ = readerHeroGacha.GetInt32(3);
                readerHero.exp_ = readerHeroGacha.GetInt64(4);
                readerHero.enchant_ = readerHeroGacha.GetByte(5);

                heroes.Add(readerHero);

                DebugWriteLine($"Added hero - charUid: {charUid}, heroUid: {readerHero.uid_}, ItemTid: {readerHero.tid_}");
            }

            readerHeroGacha.Close();
        }

        protected override void RunCharacterLogin(long accountUid, long charUid, ref List<Equipment> equipments, ref List<Item> items, ref List<Currency> currencies, ref List<Hero> heroes, ref List<Quest> quests, ref List<Achievement> achievements, ref List<Collection> collections, ref List<Post> posts)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdCharacterLogin = new MySqlCommand("spCharacterLogin", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdCharacterLogin.Parameters.AddWithValue("par_AccountUid", accountUid);
            cmdCharacterLogin.Parameters.AddWithValue("par_CharUid", charUid);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdCharacterLogin.Parameters.Add(outParam);

            MySqlDataReader readerCharacterLogin = cmdCharacterLogin.ExecuteReader();

            // 첫 번째 SELECT 문의 결과 처리
            while (readerCharacterLogin.Read())
            {
                Equipment equipment = new Equipment();
                equipment.uid_ = readerCharacterLogin.GetInt64(0);
                equipment.slot_ = readerCharacterLogin.GetInt16(1);

                equipments.Add(equipment);

                DebugWriteLine($"ItemUid: {equipment.uid_}, Slot: {equipment.slot_}");
            }

            // 두 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Item readItem = new Item();
                    readItem.uid_ = readerCharacterLogin.GetInt64(0);
                    readItem.tid_ = readerCharacterLogin.GetInt64(1);
                    readItem.type_ = readerCharacterLogin.GetByte(2);
                    readItem.level_ = readerCharacterLogin.GetInt32(3);
                    readItem.exp_ = readerCharacterLogin.GetInt64(4);
                    readItem.count_ = readerCharacterLogin.GetInt32(5);

                    items.Add(readItem);

                    DebugWriteLine($"ItemUid: {readItem.uid_}, ItemTid: {readItem.tid_}, ItemType: {readItem.type_}, Level: {readItem.level_}, Exp: {readItem.exp_}, Count: {readItem.count_}");
                }
            }

            // 세 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Currency readCurrency = new Currency();
                    readCurrency.uid_ = readerCharacterLogin.GetInt64(0);
                    readCurrency.tid_ = readerCharacterLogin.GetInt64(1);
                    readCurrency.value_ = readerCharacterLogin.GetInt64(2);

                    currencies.Add(readCurrency);

                    DebugWriteLine($"CurrencyUid: {readCurrency.uid_}, CurrencyTid: {readCurrency.tid_}, CurrencyValue: {readCurrency.value_}");
                }
            }

            // 네 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Hero readHero = new Hero();
                    readHero.uid_ = readerCharacterLogin.GetInt64(0);
                    readHero.tid_ = readerCharacterLogin.GetInt64(1);
                    readHero.grade_ = readerCharacterLogin.GetByte(2);
                    readHero.level_ = readerCharacterLogin.GetInt32(3);
                    readHero.exp_ = readerCharacterLogin.GetInt64(4);
                    readHero.enchant_ = readerCharacterLogin.GetByte(5);

                    heroes.Add(readHero);

                    DebugWriteLine($"HeroUid: {readHero.uid_}, HeroTid: {readHero.tid_}, Grade: {readHero.grade_}, Level: {readHero.level_}, Exp: {readHero.exp_}, Enchant: {readHero.enchant_}");
                }
            }

            // 다섯 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Quest readQuest = new Quest();
                    readQuest.uid_ = readerCharacterLogin.GetInt64(0);
                    readQuest.tid_ = readerCharacterLogin.GetInt64(1);
                    readQuest.category1_ = readerCharacterLogin.GetInt16(2);
                    readQuest.category2_ = readerCharacterLogin.GetInt16(3);
                    readQuest.value1_ = readerCharacterLogin.GetInt64(4);
                    readQuest.value2_ = readerCharacterLogin.GetInt64(5);
                    readQuest.state_ = readerCharacterLogin.GetByte(6);

                    quests.Add(readQuest);

                    DebugWriteLine($"QuestUid: {readQuest.uid_}, QuestTid: {readQuest.tid_}, Category1: {readQuest.category1_}, Category2: {readQuest.category2_}, Value1: {readQuest.value1_}, Value2: {readQuest.value2_}, State: {readQuest.state_}");
                }
            }

            // 여섯 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Achievement readAchievement = new Achievement();
                    readAchievement.uid_ = readerCharacterLogin.GetInt64(0);
                    readAchievement.tid_ = readerCharacterLogin.GetInt64(1);
                    readAchievement.category1_ = readerCharacterLogin.GetInt16(2);
                    readAchievement.category2_ = readerCharacterLogin.GetInt16(3);
                    readAchievement.value1_ = readerCharacterLogin.GetInt64(4);
                    readAchievement.value2_ = readerCharacterLogin.GetInt64(5);
                    readAchievement.state_ = readerCharacterLogin.GetByte(6);

                    achievements.Add(readAchievement);

                    DebugWriteLine($"AchieveUid: {readAchievement.uid_}, AchieveTid: {readAchievement.tid_}, Category1: {readAchievement.category1_}, Category2: {readAchievement.category2_}, Value1: {readAchievement.value1_}, Value2: {readAchievement.value2_}, State: {readAchievement.state_}");
                }
            }

            // 일곱 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Collection readCollection = new Collection();
                    readCollection.uid_ = readerCharacterLogin.GetInt64(0);
                    readCollection.tid_ = readerCharacterLogin.GetInt64(1);
                    readCollection.type_ = readerCharacterLogin.GetInt16(2);
                    readCollection.state_ = readerCharacterLogin.GetByte(3);
                    readCollection.value1_ = readerCharacterLogin.GetInt64(4);
                    readCollection.value2_ = readerCharacterLogin.GetInt64(5);
                    readCollection.value3_ = readerCharacterLogin.GetInt64(6);
                    readCollection.value4_ = readerCharacterLogin.GetInt64(7);
                    readCollection.value5_ = readerCharacterLogin.GetInt64(8);
                    readCollection.value6_ = readerCharacterLogin.GetInt64(9);

                    collections.Add(readCollection);

                    DebugWriteLine($"CollectionUid: {readCollection.uid_}, CollectionTid: {readCollection.tid_}, Type: {readCollection.type_}, State: {readCollection.state_}, Value1: {readCollection.value1_}, Value2: {readCollection.value2_}, Value3: {readCollection.value3_}, Value4: {readCollection.value4_}, Value5: {readCollection.value5_}, Value6: {readCollection.value6_}");
                }
            }

            // 여덟 번째 SELECT 문의 결과 처리
            if (readerCharacterLogin.NextResult())
            {
                while (readerCharacterLogin.Read())
                {
                    Post readPost = new Post();
                    readPost.uid_ = readerCharacterLogin.GetInt64(0);
                    readPost.tid_ = readerCharacterLogin.GetInt64(1);
                    readPost.rewardTid_ = readerCharacterLogin.GetInt64(2);
                    readPost.rewardValue_ = readerCharacterLogin.GetInt64(3);
                    readPost.rewardIsReaded_ = readerCharacterLogin.GetByte(4);
                    readPost.rewardExpireDate_ = readerCharacterLogin.GetDateTime(5);

                    DebugWriteLine($"PostUid: {readPost.uid_}, PostTid: {readPost.tid_}, RewardTid: {readPost.rewardTid_}, RewardValue: {readPost.rewardValue_}, IsReaded: {readPost.rewardIsReaded_}, ExpireDate: {readPost.rewardExpireDate_}");
                }
            }

            readerCharacterLogin.Close();
        }

        protected override void RunCharacterCreate(int i, long accountUid, ref long charUid, ref long charExp, ref string charName, ref byte charType, ref int charLevel)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdCharacterCreate = new MySqlCommand("spCharacterCreate", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdCharacterCreate.Parameters.AddWithValue("par_AccountUid", accountUid);
            cmdCharacterCreate.Parameters.AddWithValue("par_CharUid", GetUniqueGuid(i));
            cmdCharacterCreate.Parameters.AddWithValue("par_CharName", GetUniqueGuid(i));
            cmdCharacterCreate.Parameters.AddWithValue("par_CharType", 1);
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdCharacterCreate.Parameters.Add(outParam);

            MySqlDataReader readerCharacterCreate = cmdCharacterCreate.ExecuteReader();

            // 첫 번째 SELECT 문의 결과 처리
            if (readerCharacterCreate.Read())
            {
                charUid = readerCharacterCreate.GetInt64(0);

                DebugWriteLine($"charUid: {charUid}");
            }

            if (charUid != 0)
            {
                // 두 번째 SELECT 문의 결과 처리
                while (readerCharacterCreate.NextResult())
                {
                    while (readerCharacterCreate.Read())
                    {
                        charName = readerCharacterCreate.GetString(0);
                        charType = readerCharacterCreate.GetByte(1);
                        charLevel = readerCharacterCreate.GetInt32(2);
                        charExp = readerCharacterCreate.GetInt64(3);

                        DebugWriteLine($"CharUid: {charUid}, CharName: {charName}, CharType: {charType}, Level: {charLevel}, Exp: {charExp}");
                    }
                }
            }

            readerCharacterCreate.Close();
        }

        protected override void RunAccountLogin(int i, ref long accountUid, ref long charUid, ref long charExp, ref string charName, ref byte charType, ref int charLevel)
        {
            MySqlConnection? sqlConnection = connection_ as MySqlConnection;
            if (sqlConnection == null)
                return;

            MySqlCommand cmdAccountLogin = new MySqlCommand("spAccountLogin", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdAccountLogin.Parameters.AddWithValue("par_ChannelType", (byte)1);
            cmdAccountLogin.Parameters.AddWithValue("par_ChannelId", GetUniqueGuid(i));
            MySqlParameter outParam = new MySqlParameter();
            outParam.ParameterName = "ReturnCode";
            outParam.MySqlDbType = MySqlDbType.Int32;
            outParam.Direction = ParameterDirection.Output;
            cmdAccountLogin.Parameters.Add(outParam);

            MySqlDataReader readerAccountLogin = cmdAccountLogin.ExecuteReader();

            // 첫 번째 SELECT 문의 결과 처리
            if (readerAccountLogin.Read())
            {
                accountUid = readerAccountLogin.GetInt64(0);
                charUid = readerAccountLogin.GetInt64(1);

                DebugWriteLine($"AccountUid: {accountUid}, Result: {charUid}");
            }

            if (charUid != 0)
            {
                // 두 번째 SELECT 문의 결과 처리
                while (readerAccountLogin.NextResult())
                {
                    while (readerAccountLogin.Read())
                    {
                        charUid = readerAccountLogin.GetInt64(0);
                        charName = readerAccountLogin.GetString(1);
                        charType = readerAccountLogin.GetByte(2);
                        charLevel = readerAccountLogin.GetInt32(3);
                        charExp = readerAccountLogin.GetInt64(4);

                        DebugWriteLine($"CharUid: {charUid}, CharName: {charName}, CharType: {charType}, Level: {charLevel}, Exp: {charExp}");
                    }
                }
            }

            readerAccountLogin.Close();
        }
    }
}
