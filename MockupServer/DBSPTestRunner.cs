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

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MockupServer
{
    internal class DBSPTestRunner : IDBTestRunner
    {
        public DBSPTestRunner(SqlConnection connection, TextWriter writer, List<Script>? scripts, long thread_index = 0, long ec2index = 0)
            : base(connection, writer, scripts, thread_index, ec2index) { }

        protected override void RunAccountLogout(long accountUid, long charUid)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdAccountLogout = new SqlCommand("spAccountLogout", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdAccountLogout.Parameters.AddWithValue("@AccountUid", accountUid);
            cmdAccountLogout.Parameters.AddWithValue("@CharUid", charUid);

            cmdAccountLogout.ExecuteNonQuery();
        }

        protected override void RunItemExpChange(long charUid, ref List<Item> items)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            if (items.Count == 0)
            {
                return;
            }

            Random rand = new Random();
            int randIndex = rand.Next(0, items.Count);
            var item = items[randIndex];
            item.level_ += rand.Next(0, 1);
            item.exp_ += rand.Next(0, 100);

            SqlCommand cmdItemExpChange = new SqlCommand("spItemUpdateExp", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdItemExpChange.Parameters.AddWithValue("@CharUid", charUid);
            cmdItemExpChange.Parameters.AddWithValue("@ItemUid", item.uid_);
            cmdItemExpChange.Parameters.AddWithValue("@UpdateLevel", item.level_);
            cmdItemExpChange.Parameters.AddWithValue("@UpdateExp", item.exp_);

            cmdItemExpChange.ExecuteNonQuery();
        }

        protected override void RunEquipChange(long charUid, ref List<Equipment> equipments, ref List<Item> items)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            if (items.Count == 0)
            {
                return;
            }

            Random rand = new Random();
            int randIndex = rand.Next(0, items.Count);
            var item = items[randIndex];
            int randSlotIndex = rand.Next(0, 6);

            SqlCommand cmdEquipChange = new SqlCommand("spEquipChange", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdEquipChange.Parameters.AddWithValue("@CharUid", charUid);
            cmdEquipChange.Parameters.AddWithValue("@ItemUid", item.uid_);
            cmdEquipChange.Parameters.AddWithValue("@Slot", randSlotIndex);

            cmdEquipChange.ExecuteNonQuery();
        }

        protected override void RunAchievementReward(long charUid, ref List<Achievement> achieves, ref long item_index, int charLevel, long charExp)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

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
                    SqlCommand cmdQuestReward = new SqlCommand("spAchievementComplete", sqlConnection)
                    {
                        CommandType = System.Data.CommandType.StoredProcedure
                    };

                    cmdQuestReward.Parameters.AddWithValue("@AchieveUid", achieve.uid_);
                    cmdQuestReward.Parameters.AddWithValue("@CharUid", charUid);
                    cmdQuestReward.Parameters.AddWithValue("@CurrentLevel", charLevel);
                    cmdQuestReward.Parameters.AddWithValue("@CurrentExp", charExp);
                    cmdQuestReward.Parameters.AddWithValue("@DeltaExp", rand.Next(0, 10));

                    // HeroType - TVP 데이터 생성
                    DataTable heroesTable = new DataTable();
                    heroesTable.Columns.Add("CharUid", typeof(long));
                    heroesTable.Columns.Add("HeroTid", typeof(long));
                    heroesTable.Columns.Add("Grade", typeof(byte));
                    heroesTable.Columns.Add("Level", typeof(int));
                    heroesTable.Columns.Add("Exp", typeof(long));
                    heroesTable.Columns.Add("Enchant", typeof(byte));
                    // 행 추가 (예시 데이터)
                    for (long cnt = 0; cnt < rand.Next(0, 2); cnt++)
                    {
                        heroesTable.Rows.Add(charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(0, 10));
                    }
                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    SqlParameter tvpHeroParam = cmdQuestReward.Parameters.AddWithValue("@HeroType", heroesTable);
                    tvpHeroParam.SqlDbType = SqlDbType.Structured;
                    tvpHeroParam.TypeName = "dbo.CreateHeroType";

                    // ItemnType - TVP 데이터 생성
                    DataTable itemsTable = new DataTable();
                    itemsTable.Columns.Add("ItemUid", typeof(long));
                    itemsTable.Columns.Add("CharUid", typeof(long));
                    itemsTable.Columns.Add("ItemTid", typeof(long));
                    itemsTable.Columns.Add("Type", typeof(byte));
                    itemsTable.Columns.Add("Level", typeof(int));
                    itemsTable.Columns.Add("Exp", typeof(long));
                    itemsTable.Columns.Add("Count", typeof(int));
                    itemsTable.Columns.Add("ExpireDate", typeof(DateTime));

                    // 행 추가 (예시 데이터)
                    for (long cnt = 0; cnt < rand.Next(0, 2); cnt++)
                    {
                        long result_item_index = System.Threading.Interlocked.Increment(ref item_index);
                        itemsTable.Rows.Add(result_item_index, charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(1, 10), null);
                    }

                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    SqlParameter tvpItemParam = cmdQuestReward.Parameters.AddWithValue("@ItemType", itemsTable);
                    tvpItemParam.SqlDbType = SqlDbType.Structured;
                    tvpItemParam.TypeName = "dbo.CreateItemBundleType";

                    // CurrencyType - TVP 데이터 생성
                    DataTable currencyTable = new DataTable();
                    currencyTable.Columns.Add("CharUid", typeof(long));
                    currencyTable.Columns.Add("CurrencyTid", typeof(long));
                    currencyTable.Columns.Add("Value", typeof(long));
                    // 행 추가 (예시 데이터)
                    currencyTable.Rows.Add(charUid, 1, rand.Next(0, 100));
                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    SqlParameter tvpCurrencyParam = cmdQuestReward.Parameters.AddWithValue("@CurrencyType", currencyTable);
                    tvpCurrencyParam.SqlDbType = SqlDbType.Structured;
                    tvpCurrencyParam.TypeName = "dbo.UpdateCurrencyType";

                    cmdQuestReward.ExecuteNonQuery();

                    achieves[i].state_ = 255;
                    break;
                }
            }
        }

        protected override void RunQuestReward(long charUid, ref List<Quest> quests, ref long item_index, int charLevel, long charExp)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            if (quests.Count == 0)
                return;

            for (int i = 0; i < quests.Count; ++i)
            {
                if (quests[i].state_ != 255)
                {
                    var quest = quests[i];
                    Random rand = new Random();
                    int randIndex = rand.Next(0, quests.Count);
                    SqlCommand cmdQuestReward = new SqlCommand("spQuestComplete", sqlConnection)
                    {
                        CommandType = System.Data.CommandType.StoredProcedure
                    };

                    cmdQuestReward.Parameters.AddWithValue("@QuestUid", quest.uid_);
                    cmdQuestReward.Parameters.AddWithValue("@CharUid", charUid);
                    cmdQuestReward.Parameters.AddWithValue("@CurrentLevel", charLevel);
                    cmdQuestReward.Parameters.AddWithValue("@CurrentExp", charExp);
                    cmdQuestReward.Parameters.AddWithValue("@DeltaExp", rand.Next(0, 10));

                    // HeroType - TVP 데이터 생성
                    DataTable heroesTable = new DataTable();
                    heroesTable.Columns.Add("CharUid", typeof(long));
                    heroesTable.Columns.Add("HeroTid", typeof(long));
                    heroesTable.Columns.Add("Grade", typeof(byte));
                    heroesTable.Columns.Add("Level", typeof(int));
                    heroesTable.Columns.Add("Exp", typeof(long));
                    heroesTable.Columns.Add("Enchant", typeof(byte));
                    // 행 추가 (예시 데이터)
                    for (long cnt = 0; cnt < rand.Next(0, 2); cnt++)
                    {
                        heroesTable.Rows.Add(charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(0, 10));
                    }
                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    SqlParameter tvpHeroParam = cmdQuestReward.Parameters.AddWithValue("@HeroType", heroesTable);
                    tvpHeroParam.SqlDbType = SqlDbType.Structured;
                    tvpHeroParam.TypeName = "dbo.CreateHeroType";

                    // ItemnType - TVP 데이터 생성
                    DataTable itemsTable = new DataTable();
                    itemsTable.Columns.Add("ItemUid", typeof(long));
                    itemsTable.Columns.Add("CharUid", typeof(long));
                    itemsTable.Columns.Add("ItemTid", typeof(long));
                    itemsTable.Columns.Add("Type", typeof(byte));
                    itemsTable.Columns.Add("Level", typeof(int));
                    itemsTable.Columns.Add("Exp", typeof(long));
                    itemsTable.Columns.Add("Count", typeof(int));
                    itemsTable.Columns.Add("ExpireDate", typeof(DateTime));

                    // 행 추가 (예시 데이터)
                    for (long cnt = 0; cnt < rand.Next(0, 2); cnt++)
                    {
                        long result_item_index = System.Threading.Interlocked.Increment(ref item_index);
                        itemsTable.Rows.Add(result_item_index, charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(1, 10), null);
                    }

                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    SqlParameter tvpItemParam = cmdQuestReward.Parameters.AddWithValue("@ItemType", itemsTable);
                    tvpItemParam.SqlDbType = SqlDbType.Structured;
                    tvpItemParam.TypeName = "dbo.CreateItemBundleType";

                    // CurrencyType - TVP 데이터 생성
                    DataTable currencyTable = new DataTable();
                    currencyTable.Columns.Add("CharUid", typeof(long));
                    currencyTable.Columns.Add("CurrencyTid", typeof(long));
                    currencyTable.Columns.Add("Value", typeof(long));
                    // 행 추가 (예시 데이터)
                    currencyTable.Rows.Add(charUid, 1, rand.Next(0, 100));
                    // 저장 프로시저 매개변수 추가 (필요한 경우)
                    SqlParameter tvpCurrencyParam = cmdQuestReward.Parameters.AddWithValue("@CurrencyType", currencyTable);
                    tvpCurrencyParam.SqlDbType = SqlDbType.Structured;
                    tvpCurrencyParam.TypeName = "dbo.UpdateCurrencyType";

                    cmdQuestReward.ExecuteNonQuery();

                    quests[i].state_ = 255;

                    return;
                }
            }
        }

        protected override void RunAchievementUpdate(long charUid, ref List<Achievement> achievements)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdAchievementUpdate = new SqlCommand("spAchievementUpdateProgress", sqlConnection)
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
            var newAchievement = new Achievement();

            if (achievements.Count > 0 && rand.Next(100) < 50)
            {
                int randIndex = rand.Next(achievements.Count);
                newAchievement = achievements[randIndex];

                achievementTid = newAchievement.tid_;
                category1 = newAchievement.category1_;
                category2 = newAchievement.category2_;
                value1 = newAchievement.value1_;
                value2 = newAchievement.value2_;
                int intState = newAchievement.state_ + 1;
                state = (byte)intState;

                newAchievement.state_ = state;
            }
            else
            {
                bool exists = false;
                foreach (var achievement in achievements)
                {
                    if (achievement.tid_ == achievementTid)
                    {
                        newAchievement = achievement;

                        achievement.tid_ = achievementTid;
                        achievement.category1_ = category1;
                        achievement.category2_ = category2;
                        achievement.value1_ = value1;
                        achievement.value2_ = value2;
                        achievement.state_ = state;
                        exists = true;
                    }
                    break;
                }

                if (!exists)
                {
                    newAchievement.tid_ = achievementTid;
                    newAchievement.category1_ = category1;
                    newAchievement.category2_ = category2;
                    newAchievement.value1_ = value1;
                    newAchievement.value2_ = value2;
                    newAchievement.state_ = state;

                    achievements.Add(newAchievement);
                }
            }
            cmdAchievementUpdate.Parameters.AddWithValue("@AchieveTid", achievementTid);
            cmdAchievementUpdate.Parameters.AddWithValue("@CharUid", charUid);
            cmdAchievementUpdate.Parameters.AddWithValue("@Category1", category1);
            cmdAchievementUpdate.Parameters.AddWithValue("@Category2", category2);
            cmdAchievementUpdate.Parameters.AddWithValue("@Value1", value1);
            cmdAchievementUpdate.Parameters.AddWithValue("@Value2", value2);
            cmdAchievementUpdate.Parameters.AddWithValue("@State", state);

            SqlDataReader readerAchievementUpdate = cmdAchievementUpdate.ExecuteReader();
            if (readerAchievementUpdate.Read())
            {
                newAchievement.uid_ = readerAchievementUpdate.GetInt64(0);
            }
            readerAchievementUpdate.Close();
        }

        protected override void RunQuestUpdate(long charUid, ref List<Quest> quests)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdQuestUpdate = new SqlCommand("spQuestUpdateProgress", sqlConnection)
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
            var newQuest = new Quest();

            if (quests.Count > 0 && rand.Next(100) < 50)
            {
                int randIndex = rand.Next(quests.Count);
                newQuest = quests[randIndex];

                questTid = newQuest.tid_;
                category1 = newQuest.category1_;
                category2 = newQuest.category2_;
                value1 = newQuest.value1_;
                value2 = newQuest.value2_;
                int intState = newQuest.state_ + 1;
                state = (byte)intState;

                newQuest.tid_ = questTid;
                newQuest.category1_ = category1;
                newQuest.category2_ = category2;
                newQuest.value1_ = value1;
                newQuest.value2_ = value2;
                newQuest.state_ = state;
            }
            else
            {
                bool exists = false;
                foreach (var quest in quests)
                {
                    if (quest.tid_ == questTid)
                    {
                        newQuest = quest;
                        quest.tid_ = questTid;
                        quest.category1_ = category1;
                        quest.category2_ = category2;
                        quest.value1_ = value1;
                        quest.value2_ = value2;
                        quest.state_ = state;
                        exists = true;
                    }
                    break;
                }

                if (!exists)
                {
                    newQuest.tid_ = questTid;
                    newQuest.category1_ = category1;
                    newQuest.category2_ = category2;
                    newQuest.value1_ = value1;
                    newQuest.value2_ = value2;
                    newQuest.state_ = state;

                    quests.Add(newQuest);
                }
            }
            cmdQuestUpdate.Parameters.AddWithValue("@QuestTid", questTid);
            cmdQuestUpdate.Parameters.AddWithValue("@CharUid", charUid);
            cmdQuestUpdate.Parameters.AddWithValue("@Category1", category1);
            cmdQuestUpdate.Parameters.AddWithValue("@Category2", category2);
            cmdQuestUpdate.Parameters.AddWithValue("@Value1", value1);
            cmdQuestUpdate.Parameters.AddWithValue("@Value2", value2);
            cmdQuestUpdate.Parameters.AddWithValue("@State", state);

            SqlDataReader readerQuestUpdate = cmdQuestUpdate.ExecuteReader();
            if (readerQuestUpdate.Read())
            {
                newQuest.uid_ = readerQuestUpdate.GetInt64(0);
            }
            readerQuestUpdate.Close();
        }

        protected override void RunCurrencyUpdate(long charUid, ref long currencyTid, ref long currencyValue)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdCurrencyUpdate = new SqlCommand("spCurrencyUpdate", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdCurrencyUpdate.Parameters.AddWithValue("@CharUid", charUid);
            cmdCurrencyUpdate.Parameters.AddWithValue("@CurrencyTid", currencyTid);
            cmdCurrencyUpdate.Parameters.AddWithValue("@CurrentValue", currencyValue);
            Random rand = new Random();
            cmdCurrencyUpdate.Parameters.AddWithValue("@DeltaValue", rand.Next(100, 10000));

            SqlDataReader readerCurrencyUpdate = cmdCurrencyUpdate.ExecuteReader();
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
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdExpUpdate = new SqlCommand("spExpUpdate", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdExpUpdate.Parameters.AddWithValue("@CharUid", charUid);
            cmdExpUpdate.Parameters.AddWithValue("@CurrentLevel", charLevel);
            cmdExpUpdate.Parameters.AddWithValue("@CurrentExp", charExp);
            Random rand = new Random();
            cmdExpUpdate.Parameters.AddWithValue("@DeltaExp", rand.Next(1, 100));

            SqlDataReader readerExpUpdate = cmdExpUpdate.ExecuteReader();
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
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            // TVP 데이터 생성
            DataTable itemsTable = new DataTable();
            itemsTable.Columns.Add("ItemUid", typeof(long));
            itemsTable.Columns.Add("CharUid", typeof(long));
            itemsTable.Columns.Add("ItemTid", typeof(long));
            itemsTable.Columns.Add("Type", typeof(byte));
            itemsTable.Columns.Add("Level", typeof(int));
            itemsTable.Columns.Add("Exp", typeof(long));
            itemsTable.Columns.Add("Count", typeof(int));
            itemsTable.Columns.Add("ExpireDate", typeof(DateTime));

            Random rand = new Random();
            // 행 추가 (예시 데이터)
            for (long cnt = 0; cnt < rand.Next(1, 10); cnt++)
            {
                long result_item_index = System.Threading.Interlocked.Increment(ref item_index);
                itemsTable.Rows.Add(result_item_index, charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(1, 10), null);
            }

            SqlCommand cmdItemGacha = new SqlCommand("spItemCreateBundle", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdItemGacha.Parameters.AddWithValue("CharUid", charUid);
            SqlParameter tvpParam = cmdItemGacha.Parameters.AddWithValue("@Items", itemsTable);
            tvpParam.SqlDbType = SqlDbType.Structured;
            tvpParam.TypeName = "dbo.CreateItemBundleType";

            SqlDataReader readerItemGacha = cmdItemGacha.ExecuteReader();

            while (readerItemGacha.Read())
            {
                Item readItem = new Item();
                readItem.uid_ = readerItemGacha.GetInt64(0);
                readItem.tid_ = readerItemGacha.GetInt64(1);
                readItem.type_ = readerItemGacha.GetByte(2);
                readItem.level_ = readerItemGacha.GetInt32(3);
                readItem.exp_ = readerItemGacha.GetInt64(4);
                readItem.count_ = readerItemGacha.GetInt32(5);
                if (!readerItemGacha.IsDBNull(6))
                {
                    readItem.expireDate_ = readerItemGacha.GetDateTime(6);
                }

                items.Add(readItem);

                DebugWriteLine($"Added Item - charUid: {charUid}, itemUid: {readItem.uid_}, ItemTid: {readItem.tid_}");
            }

            readerItemGacha.Close();
        }

        protected override void RunHeroGacha(long charUid, ref List<Hero> heroes)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            // TVP 데이터 생성
            DataTable heroesTable = new DataTable();
            heroesTable.Columns.Add("CharUid", typeof(long));
            heroesTable.Columns.Add("HeroTid", typeof(long));
            heroesTable.Columns.Add("Grade", typeof(byte));
            heroesTable.Columns.Add("Level", typeof(int));
            heroesTable.Columns.Add("Exp", typeof(long));
            heroesTable.Columns.Add("Enchant", typeof(byte));

            Random rand = new Random();
            // 행 추가 (예시 데이터)
            for (long cnt = 0; cnt < rand.Next(1, 10); cnt++)
            {
                heroesTable.Rows.Add(charUid, cnt + 1, rand.Next(1, 6), rand.Next(0, 100), rand.Next(0, 1000), rand.Next(0, 10));
            }

            SqlCommand cmdHeroGacha = new SqlCommand("spHeroGacha", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            SqlParameter tvpParam = cmdHeroGacha.Parameters.AddWithValue("@heroes", heroesTable);
            tvpParam.SqlDbType = SqlDbType.Structured;
            tvpParam.TypeName = "dbo.CreateHeroType";

            SqlDataReader readerHeroGacha = cmdHeroGacha.ExecuteReader();

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
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdCharacterLogin = new SqlCommand("spCharacterLogin", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdCharacterLogin.Parameters.AddWithValue("@AccountUid", accountUid);
            cmdCharacterLogin.Parameters.AddWithValue("@CharUid", charUid);

            SqlDataReader readerCharacterLogin = cmdCharacterLogin.ExecuteReader();

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
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdCharacterCreate = new SqlCommand("spCharacterCreate", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            charUid = GetUniqueGuid(i);
            cmdCharacterCreate.Parameters.AddWithValue("@AccountUid", accountUid);
            cmdCharacterCreate.Parameters.AddWithValue("@CharUid", charUid);
            cmdCharacterCreate.Parameters.AddWithValue("@CharName", GetUniqueGuid(i));
            cmdCharacterCreate.Parameters.AddWithValue("@CharType", (byte)accountUid);

            SqlDataReader readerCharacterCreate = cmdCharacterCreate.ExecuteReader();

            if (charUid != 0)
            {
                if (readerCharacterCreate.Read())
                {
                    charName = readerCharacterCreate.GetString(0);
                    charType = readerCharacterCreate.GetByte(1);
                    charLevel = readerCharacterCreate.GetInt32(2);
                    charExp = readerCharacterCreate.GetInt64(3);

                    DebugWriteLine($"CharUid: {charUid}, CharName: {charName}, CharType: {charType}, Level: {charLevel}, Exp: {charExp}");
                }
            }

            readerCharacterCreate.Close();
        }

        protected override void RunAccountLogin(int i, ref long accountUid, ref long charUid, ref long charExp, ref string charName, ref byte charType, ref int charLevel)
        {
            SqlConnection? sqlConnection = connection_ as SqlConnection;
            if (sqlConnection == null)
            {
                return;
            }

            SqlCommand cmdAccountLogin = new SqlCommand("spAccountLogin", sqlConnection)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            // 저장 프로시저 매개변수 추가 (필요한 경우)
            cmdAccountLogin.Parameters.AddWithValue("@ChannelType", 1);
            cmdAccountLogin.Parameters.AddWithValue("@ChannelId", GetUniqueGuid(i));

            SqlDataReader readerAccountLogin = cmdAccountLogin.ExecuteReader();

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
