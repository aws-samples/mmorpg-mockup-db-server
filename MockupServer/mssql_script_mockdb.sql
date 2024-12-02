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

USE [master]
GO
/****** Object:  Database [MockDB]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE DATABASE [MockDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MockDB', FILENAME = N'D:\rdsdbdata\DATA\MockDB.mdf' , SIZE = 1728384KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'MockDB_log', FILENAME = N'D:\rdsdbdata\DATA\MockDB_log.ldf' , SIZE = 4603264KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [MockDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MockDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MockDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MockDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MockDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MockDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MockDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [MockDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [MockDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MockDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MockDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MockDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MockDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MockDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MockDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MockDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MockDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [MockDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MockDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MockDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MockDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MockDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MockDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MockDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MockDB] SET RECOVERY FULL 
GO
ALTER DATABASE [MockDB] SET  MULTI_USER 
GO
ALTER DATABASE [MockDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MockDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MockDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MockDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MockDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MockDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [MockDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [MockDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [MockDB]
GO
/****** Object:  User [admin]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
/****** Object:  UserDefinedTableType [dbo].[CreateHeroType]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE TYPE [dbo].[CreateHeroType] AS TABLE(
	[CharUid] [bigint] NULL,
	[HeroTid] [bigint] NULL,
	[Grade] [tinyint] NULL,
	[Level] [int] NULL,
	[Exp] [bigint] NULL,
	[Enchant] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[CreateItemBundleType]    Script Date: 2024-10-07 ¿ÀÀü 12:32:44 ******/
CREATE TYPE [dbo].[CreateItemBundleType] AS TABLE(
	[ItemUid] [bigint] NULL,
	[CharUid] [bigint] NULL,
	[ItemTid] [bigint] NULL,
	[Type] [tinyint] NULL,
	[Level] [int] NULL,
	[Exp] [bigint] NULL,
	[Count] [int] NULL,
	[ExpireDate] [datetime] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UpdateAchievementType]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE TYPE [dbo].[UpdateAchievementType] AS TABLE(
	[CharUid] [bigint] NULL,
	[AchieveTid] [bigint] NULL,
	[Category1] [smallint] NULL,
	[Category2] [smallint] NULL,
	[Value1] [bigint] NULL,
	[Value2] [bigint] NULL,
	[State] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UpdateCurrencyType]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE TYPE [dbo].[UpdateCurrencyType] AS TABLE(
	[CharUid] [bigint] NULL,
	[CurrencyTid] [bigint] NULL,
	[Value] [bigint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UpdateQuestType]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE TYPE [dbo].[UpdateQuestType] AS TABLE(
	[CharUid] [bigint] NULL,
	[QuestTid] [bigint] NULL,
	[Category1] [smallint] NULL,
	[Category2] [smallint] NULL,
	[Value1] [bigint] NULL,
	[Value2] [bigint] NULL,
	[State] [tinyint] NULL
)
GO
/****** Object:  Table [dbo].[Account]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[AccountUid] [bigint] NOT NULL,
	[ChannelType] [tinyint] NOT NULL,
	[ChannelId] [bigint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LoginDate] [datetime] NOT NULL,
	[LogoutDate] [datetime] NULL,
	[CharUid] [bigint] NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY NONCLUSTERED 
(
	[AccountUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Achievement]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Achievement](
	[AchieveUid] [bigint] IDENTITY(1,1) NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[AchieveTid] [bigint] NOT NULL,
	[Category1] [smallint] NOT NULL,
	[Category2] [smallint] NOT NULL,
	[Value1] [bigint] NOT NULL,
	[Value2] [bigint] NOT NULL,
	[State] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Achievement] PRIMARY KEY NONCLUSTERED 
(
	[AchieveUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Character]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Character](
	[CharUid] [bigint] NOT NULL,
	[AccountUid] [bigint] NOT NULL,
	[CharName] [nvarchar](20) NOT NULL,
	[CharType] [tinyint] NOT NULL,
	[Level] [int] NOT NULL,
	[Exp] [bigint] NOT NULL,
	[LoginDate] [datetime] NULL,
	[LogoutDate] [datetime] NULL,
 CONSTRAINT [PK_Character] PRIMARY KEY NONCLUSTERED 
(
	[CharUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Collection]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Collection](
	[CollectionUid] [bigint] NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[CollectionTid] [bigint] NOT NULL,
	[Type] [smallint] NOT NULL,
	[State] [tinyint] NOT NULL,
	[Value1] [bigint] NOT NULL,
	[Value2] [bigint] NOT NULL,
	[Value3] [bigint] NOT NULL,
	[Value4] [bigint] NOT NULL,
	[Value5] [bigint] NOT NULL,
	[Value6] [bigint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Collection] PRIMARY KEY CLUSTERED 
(
	[CollectionUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[CurrencyUid] [bigint] IDENTITY(1,1) NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[CurrencyTid] [bigint] NOT NULL,
	[Value] [bigint] NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Goods] PRIMARY KEY NONCLUSTERED 
(
	[CurrencyUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Equipment]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Equipment](
	[ItemUid] [bigint] NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[Slot] [smallint] NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[CharUid] ASC,
	[Slot] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hero]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hero](
	[HeroUid] [bigint] IDENTITY(1,1) NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[HeroTid] [bigint] NOT NULL,
	[Grade] [tinyint] NOT NULL,
	[Level] [int] NOT NULL,
	[Exp] [bigint] NOT NULL,
	[Enchant] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteReason] [smallint] NULL,
 CONSTRAINT [PK_Hero] PRIMARY KEY NONCLUSTERED 
(
	[HeroUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inventory](
	[ItemUid] [bigint] NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[ItemTid] [bigint] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Level] [int] NOT NULL,
	[Exp] [bigint] NOT NULL,
	[Count] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[ExpireDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL,
	[DeleteReason] [smallint] NULL,
 CONSTRAINT [PK_Inventory] PRIMARY KEY NONCLUSTERED 
(
	[ItemUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Post]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[PostUid] [bigint] NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[PostTid] [bigint] NOT NULL,
	[RewardTid] [bigint] NOT NULL,
	[RewardValue] [bigint] NOT NULL,
	[IsReaded] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[ExpireDate] [datetime] NOT NULL,
	[ReadDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Quest]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quest](
	[QuestUid] [bigint] IDENTITY(1,1) NOT NULL,
	[CharUid] [bigint] NOT NULL,
	[QuestTid] [bigint] NOT NULL,
	[Category1] [smallint] NOT NULL,
	[Category2] [smallint] NOT NULL,
	[Value1] [bigint] NOT NULL,
	[Value2] [bigint] NOT NULL,
	[State] [tinyint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Quest] PRIMARY KEY NONCLUSTERED 
(
	[QuestUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Account]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Account] ON [dbo].[Account]
(
	[ChannelType] ASC,
	[ChannelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Achievement]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Achievement] ON [dbo].[Achievement]
(
	[CharUid] ASC,
	[AchieveTid] ASC,
	[Category1] ASC,
	[Category2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Character]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Character] ON [dbo].[Character]
(
	[AccountUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Currency]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Currency] ON [dbo].[Currency]
(
	[CharUid] ASC,
	[CurrencyTid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Hero]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Hero] ON [dbo].[Hero]
(
	[CharUid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Inventory]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Inventory] ON [dbo].[Inventory]
(
	[CharUid] ASC,
	[ItemTid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Quest]    Script Date: 9/22/2024 4:41:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Quest] ON [dbo].[Quest]
(
	[CharUid] ASC,
	[QuestTid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_ChannelType]  DEFAULT ((0)) FOR [ChannelType]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Account] ADD  CONSTRAINT [DF_Account_LoginDate]  DEFAULT (getdate()) FOR [LoginDate]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_Category1]  DEFAULT ((0)) FOR [Category1]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_Category2]  DEFAULT ((0)) FOR [Category2]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_Value1]  DEFAULT ((0)) FOR [Value1]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_Value2]  DEFAULT ((0)) FOR [Value2]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_State]  DEFAULT ((0)) FOR [State]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Achievement] ADD  CONSTRAINT [DF_Achievement_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_CharType]  DEFAULT ((0)) FOR [CharType]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_Level]  DEFAULT ((1)) FOR [Level]
GO
ALTER TABLE [dbo].[Character] ADD  CONSTRAINT [DF_Character_Exp]  DEFAULT ((0)) FOR [Exp]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_State]  DEFAULT ((0)) FOR [State]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_Value1]  DEFAULT ((0)) FOR [Value1]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_Value2]  DEFAULT ((0)) FOR [Value2]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_Value3]  DEFAULT ((0)) FOR [Value3]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_Value4]  DEFAULT ((0)) FOR [Value4]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_Value5]  DEFAULT ((0)) FOR [Value5]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_Value6]  DEFAULT ((0)) FOR [Value6]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Collection] ADD  CONSTRAINT [DF_Collection_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Goods_Value]  DEFAULT ((0)) FOR [Value]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Goods_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Equipment] ADD  CONSTRAINT [DF_Equipment_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Hero] ADD  CONSTRAINT [DF_Hero_Grade]  DEFAULT ((0)) FOR [Grade]
GO
ALTER TABLE [dbo].[Hero] ADD  CONSTRAINT [DF_Hero_Level]  DEFAULT ((1)) FOR [Level]
GO
ALTER TABLE [dbo].[Hero] ADD  CONSTRAINT [DF_Hero_Exp]  DEFAULT ((0)) FOR [Exp]
GO
ALTER TABLE [dbo].[Hero] ADD  CONSTRAINT [DF_Hero_Enchant]  DEFAULT ((0)) FOR [Enchant]
GO
ALTER TABLE [dbo].[Hero] ADD  CONSTRAINT [DF_Hero_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Inventory] ADD  CONSTRAINT [DF_Inventory_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_RewardValue]  DEFAULT ((0)) FOR [RewardValue]
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_IsReaded]  DEFAULT ((0)) FOR [IsReaded]
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Post] ADD  CONSTRAINT [DF_Post_ExpireDate]  DEFAULT (dateadd(day,(30),getdate())) FOR [ExpireDate]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_Category1]  DEFAULT ((0)) FOR [Category1]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_Category2]  DEFAULT ((0)) FOR [Category2]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_Value1]  DEFAULT ((0)) FOR [Value1]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_Value2]  DEFAULT ((0)) FOR [Value2]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_State]  DEFAULT ((0)) FOR [State]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[Quest] ADD  CONSTRAINT [DF_Quest_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
GO
/****** Object:  StoredProcedure [dbo].[spAccountLogin]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.17>
-- Description:	<Account Login Procedure>
-- =============================================
CREATE PROCEDURE [dbo].[spAccountLogin]
	-- Add the parameters for the stored procedure here
	@ChannelType tinyint,
	@ChannelId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AccountUid BIGINT = 0
	DECLARE @CharUid BIGINT = 0

	SELECT @AccountUid = AccountUid 
		FROM dbo.Account 
		WHERE ChannelType = @ChannelType AND ChannelId = @ChannelId

    -- Insert statements for procedure here
	IF @AccountUid != 0
	BEGIN
		SELECT @AccountUid, CharUid
		FROM dbo.Character
		WHERE AccountUid = @AccountUid

		SELECT CharUid, CharName, CharType, [Level], [Exp]
		FROM Character 
		WHERE AccountUid = @AccountUid
	END
	ELSE
	BEGIN
		INSERT INTO dbo.Account (AccountUid, ChannelType, ChannelId)
		VALUES (@ChannelId, @ChannelType, @ChannelId)

		IF @@ROWCOUNT = 0
		BEGIN
			SELECT @AccountUid, @CharUid
			RETURN @@ERROR
		END
		SELECT @AccountUid = @ChannelId

		SELECT @AccountUid, @CharUid
	END

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spAccountLogout]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.30>
-- Description:	<Check logout>
-- =============================================
CREATE PROCEDURE [dbo].[spAccountLogout]
	-- Add the parameters for the stored procedure here
	@AccountUid bigint,
	@CharUid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS( SELECT 1 FROM Account WHERE AccountUid = @AccountUid )
	BEGIN
		UPDATE Account SET LogoutDate = GETDATE() WHERE AccountUid = @AccountUid
		UPDATE Character SET LogoutDate = GETDATE() WHERE CharUid = @CharUid
	END
	ELSE
	BEGIN
		RETURN -1
	END

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spAchievementComplete]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Complete Achievement and add rewards>
-- =============================================
CREATE PROCEDURE [dbo].[spAchievementComplete]
	-- Add the parameters for the stored procedure here
	@AchieveUid bigint,
	@CharUid bigint,
	@CurrentLevel int,								--Rewards
	@CurrentExp bigint,
	@DeltaExp	bigint,
	@HeroType AS dbo.CreateHeroType Readonly,
	@ItemType AS dbo.CreateItemBundleType Readonly,
	@CurrencyType AS dbo.UpdateCurrencyType Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ReturnVal INT

	BEGIN TRAN

    -- Insert statements for procedure here
	UPDATE Achievement SET [State] = 255 WHERE AchieveUid = @AchieveUid AND CharUid = @CharUid

	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	DECLARE @QuestType AS dbo.UpdateQuestType
	DECLARE @AchieveType AS dbo.UpdateAchievementType

	EXEC @ReturnVal = spRewardsRecv @CharUid, @CurrentLevel, @CurrentExp, @DeltaExp, @HeroType, @ItemType, @CurrencyType, @QuestType, @AchieveType

	IF @ReturnVal <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	COMMIT TRAN
	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spAchievementUpdateProgress]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2014.05.02>
-- Description:	<Update Achievement progress>
-- =============================================
CREATE PROCEDURE [dbo].[spAchievementUpdateProgress]
	-- Add the parameters for the stored procedure here
	@AchieveTid bigint, 
	@CharUid bigint,
	@Category1 smallint,
	@Category2 smallint,
	@Value1 bigint,
	@Value2 bigint,
	@State tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 FROM Achievement WHERE AchieveTid = @AchieveTid AND CharUid = @CharUid AND [State] = @State AND Category1 = @Category1 AND Category2 = @Category2 AND Value1 = @Value1 AND Value2 = @Value2)
	BEGIN
		RETURN -1
	END

	DECLARE @AchieveUid bigint = 0

	BEGIN TRAN

	SELECT @AchieveUid = AchieveUid FROM Achievement WHERE AchieveTid = @AchieveTid AND CharUid = @CharUid AND Category1 = @Category1 AND Category2 = @Category2
	IF @AchieveUid = 0
	BEGIN
		INSERT INTO Achievement (CharUid, AchieveTid, Category1, Category2, Value1, Value2, [State])
		VALUES (@CharUid, @AchieveTid, @Category1, @Category2, @Value1, @Value2, @State)

		SET @AchieveUid = @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE Achievement SET Value1 = @Value1, Value2 = @Value2, [State] = @State WHERE AchieveUid = @AchieveUid

		IF @@ERROR != 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
	END

	COMMIT TRAN

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spCharacterCreate]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.29>
-- Description:	<Create Character>
-- =============================================
CREATE PROCEDURE [dbo].[spCharacterCreate]
	-- Add the parameters for the stored procedure here
	@AccountUid bigint,
	@CharUid bigint,
	@CharName NVARCHAR(20),
	@CharType tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS(SELECT 1 FROM dbo.Character WHERE CharName = @CharName)
	BEGIN
		RETURN -1
	END

	BEGIN TRAN

	INSERT INTO dbo.Character (CharUid, AccountUid, CharName, CharType)
	VALUES (@CharUid, @AccountUid, @CharName, @CharType)

	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END
	--DECLARE @CharUid BIGINT = 0

	--SELECT @CharUid = @@IDENTITY
	--SELECT @CharUid

	SELECT CharName, CharType, [Level], [Exp] FROM Character WHERE AccountUid = @AccountUid AND CharUid = @CharUid

	UPDATE dbo.Account
	SET CharUid = @CharUid
	WHERE AccountUid = @AccountUid

	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN @@ERROR
	END

	COMMIT TRAN

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spCharacterLogin]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.30>
-- Description:	<Login Character and get informations>
-- =============================================
CREATE PROCEDURE [dbo].[spCharacterLogin] 
	-- Add the parameters for the stored procedure here
	@AccountUid bigint,
	@CharUid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS( SELECT 1 FROM Character WHERE AccountUid = @AccountUid AND CharUid = @CharUid )
	BEGIN
		RETURN -9999
	END

	BEGIN TRAN

	UPDATE Character SET LoginDate = GETDATE() WHERE AccountUid = @AccountUid AND CharUid = @CharUid

	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	--Check Time-limit items and remove
	UPDATE Inventory SET DeleteDate = GETDATE(), DeleteReason = 999 WHERE CharUid = @CharUid AND DeleteDate IS NULL AND ([ExpireDate] IS NOT NULL AND [ExpireDate] < GETDATE())
	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	--Check Time-limit post items and remove
	UPDATE Post SET DeleteDate = GETDATE() WHERE CharUid = @CharUid AND DeleteDate IS NULL AND [ExpireDate] IS NOT NULL AND [ExpireDate] < GETDATE()
	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	COMMIT TRAN

	SELECT ItemUid, Slot FROM Equipment WHERE CharUid = @CharUid


	SELECT ItemUid, ItemTid, [Type], [Level], [Exp], [Count] FROM Inventory WHERE CharUid = @CharUid AND DeleteDate IS NULL AND ([ExpireDate] IS NULL OR [ExpireDate] > GETDATE())

	SELECT CurrencyUid, CurrencyTid, [Value] FROM Currency WHERE CharUid = @CharUid

	SELECT HeroUid, HeroTid, Grade, [Level], [Exp], Enchant FROM Hero WHERE CharUid = @CharUid AND DeleteDate IS NULL

	SELECT QuestUid, QuestTid, Category1, Category2, Value1, Value2, [State] FROM Quest WHERE CharUid = @CharUid

	SELECT AchieveUid, AchieveTid, Category1, Category2, Value1, Value2, [State] FROM Achievement WHERE CharUid = @CharUid

	SELECT CollectionUid, CollectionTid, [Type], [State], Value1, Value2, Value3, Value4, Value5, Value6 FROM Collection WHERE CharUid = @CharUid

	SELECT PostUid, PostTid, RewardTid, RewardValue, isReaded, [ExpireDate] FROM Post WHERE CharUid = @CharUid AND DeleteDate is NULL AND ([ExpireDate] IS NOT NULL AND [ExpireDate] > GETDATE())

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spCurrencyUpdate]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.30>
-- Description:	<Update Character Currency>
-- =============================================
CREATE PROCEDURE [dbo].[spCurrencyUpdate]
	-- Add the parameters for the stored procedure here
	@CharUid bigint,
	@CurrencyTid bigint,
	@CurrentValue bigint,
	@DeltaValue bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS( SELECT 1 FROM Currency WHERE CharUid = @CharUid AND CurrencyTid = @CurrencyTid AND [Value] = @CurrentValue )
	BEGIN
		INSERT INTO dbo.Currency (CharUid, CurrencyTid, [Value]) VALUES (@CharUid, @CurrencyTid, @CurrentValue + @DeltaValue)
	END
	ELSE
	BEGIN
		UPDATE Currency SET [Value] = [Value] + @DeltaValue, UpdateDate = GETDATE() WHERE CharUid = @CharUid AND CurrencyTid = @CurrencyTid
	END

	IF @@ERROR != 0
	BEGIN
		RETURN -1
	END

	SELECT @CurrentValue + @DeltaValue

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spEquipChange]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Change Equipment>
-- =============================================
CREATE PROCEDURE [dbo].[spEquipChange]
	-- Add the parameters for the stored procedure here
	@CharUid bigint, 
	@ItemUid bigint,
	@Slot smallint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS( SELECT 1 FROM Inventory WHERE CharUid = @CharUid AND ItemUid = @ItemUid AND DeleteDate IS NULL )
	BEGIN
		RETURN -1
	END

	IF EXISTS ( SELECT 1 FROM Equipment WHERE CharUid = @CharUid AND Slot = @Slot )
	BEGIN
		UPDATE Equipment SET ItemUid = @ItemUid, UpdateDate = GETDATE() WHERE CharUid = @CharUid AND Slot = @Slot
	END
	ELSE
	BEGIN
		INSERT INTO Equipment (ItemUid, CharUid, Slot)
		VALUES (@ItemUid, @CharUid, @Slot)
	END

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spExpUpdate]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[spExpUpdate]
	-- Add the parameters for the stored procedure here
	@CharUid bigint,
	@CurrentLevel int,
	@CurrentExp bigint,
	@DeltaExp bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	/*
	IF NOT EXISTS( SELECT 1 FROM Character WHERE CharUid = @CharUid AND [Level] = @CurrentLevel AND [Exp] = @CurrentExp )
	BEGIN
		RETURN -1
	END
	*/

	IF @CurrentExp + @DeltaExp >= @CurrentLevel * @CurrentLevel * 1000 AND @CurrentLevel < 100
	BEGIN
		UPDATE Character SET [Level] = @CurrentLevel + 1, [Exp] = @CurrentExp + @DeltaExp WHERE CharUid = @CharUid
	END
	ELSE
	BEGIN
		UPDATE Character SET [Exp] = @CurrentExp + @DeltaExp WHERE CharUid = @CharUid
	END

	IF @@ERROR != 0
	BEGIN
		RETURN -1
	END

	SELECT [Level], [Exp] FROM Character WHERE CharUid = @CharUid

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spHeroCreate]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Create Hero>
-- =============================================
CREATE PROCEDURE [dbo].[spHeroCreate] 
	-- Add the parameters for the stored procedure here
	@CharUid bigint,
	@HeroTid bigint, 
	@Grade tinyint,
	@Level int,
	@Exp bigint,
	@Enchant tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	BEGIN TRAN

	INSERT INTO Hero (CharUid, HeroTid, Grade, [Level], [Exp], Enchant)
	VALUES (@CharUid, @HeroTid, @Grade, @Level, @Exp, @Enchant)

	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRAN

		SELECT 0
		RETURN -1
	END

	COMMIT TRAN

	SELECT @@IDENTITY
	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spHeroGacha]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Gacha Heroes>
-- =============================================
CREATE PROCEDURE [dbo].[spHeroGacha] 
	-- Add the parameters for the stored procedure here
	@heroes AS [dbo].[CreateHeroType] Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @HeroUidTable TABLE (HeroUid BIGINT)

--	BEGIN TRY
--		BEGIN TRAN;

		-- Insert statements for procedure here
		INSERT INTO Hero (CharUid, HeroTid, Grade, [Level], [Exp], Enchant)
		OUTPUT INSERTED.HeroUid INTO @HeroUidTable
		SELECT CharUid, HeroTid, Grade, [Level], [Exp], Enchant
		FROM @heroes

		IF @@ERROR != 0
		BEGIN
--			ROLLBACK TRAN;
			RETURN -1
		END

		SELECT HeroUid, HeroTid, Grade, [Level], [Exp], Enchant
		FROM Hero
		WHERE HeroUid IN (SELECT HeroUid FROM @HeroUidTable)

--		COMMIT TRAN;
--	END TRY
--	BEGIN CATCH
--		IF @@TRANCOUNT > 0
--			ROLLBACK TRAN;
--			RETURN -1
--	END CATCH

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spItemCreate]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.30>
-- Description:	<Create Item>
-- =============================================
CREATE PROCEDURE [dbo].[spItemCreate] 
	-- Add the parameters for the stored procedure here
	@CharUid bigint,
	@ItemTid bigint, 
	@Type tinyint,
	@Level int,
	@Exp bigint,
	@Count int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO Inventory (CharUid, ItemTid, [Type], [Level], [Exp], [Count])
	VALUES (@CharUid, @ItemTid, @Type, @Level, @Exp, @Count)

	IF @@ERROR != 0
	BEGIN
		RETURN -1
	END

	SELECT @@IDENTITY

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spItemCreateBundle]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.06.04>
-- Description:	<Create Items>
-- =============================================
CREATE PROCEDURE [dbo].[spItemCreateBundle] 
	-- Add the parameters for the stored procedure here
	@CharUid bigint,
	@Items AS [dbo].[CreateItemBundleType] Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ItemUidTable TABLE (
		ItemUid BIGINT,
		ItemTid BIGINT,
		[Type] TINYINT,
		[Level] INT,
		[Exp] BIGINT,
		[Count] INT,
		[ExpireDate] DATETIME)

	BEGIN TRY
		BEGIN TRAN;

		-- Insert statements for procedure here
		INSERT INTO Inventory (ItemUid, CharUid, ItemTid, [Type], [Level], [Exp], [Count], [ExpireDate])
		SELECT ItemUid, CharUid, ItemTid, Type, [Level], [Exp], [Count], [ExpireDate]
		FROM @Items

		IF @@ERROR != 0
		BEGIN
			ROLLBACK TRAN;
			RETURN -1
		END

--		SELECT i.ItemUid, i.ItemTid, i.[Type], i.[Level], i.[Exp], i.[Count], i.[ExpireDate]
--		FROM Inventory i
--		WHERE ItemUid IN (SELECT ItemUid FROM @ItemUidTable)
		SELECT ItemUid, ItemTid, [Type], [Level], [Exp], [Count], [ExpireDate]
		FROM @Items

		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
			RETURN -1
	END CATCH

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spItemGacha]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.22>
-- Description:	<Gacha Items>
-- =============================================
CREATE PROCEDURE [dbo].[spItemGacha] 
	-- Add the parameters for the stored procedure here
	@Items AS [dbo].[CreateItemType] Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	BEGIN TRY
--		BEGIN TRAN;

		-- Insert statements for procedure here
		INSERT INTO Inventory (ItemUid, CharUid, ItemTid, [Type], [Level], [Exp], [Count], [ExpireDate])
		SELECT ItemUid, CharUid, ItemTid, Type, [Level], [Exp], [Count], [ExpireDate]
		FROM @Items

		IF @@ERROR != 0
		BEGIN
--			ROLLBACK TRAN;
			RETURN -1
		END

--		COMMIT TRAN;
--	END TRY
--	BEGIN CATCH
--		IF @@TRANCOUNT > 0
--			ROLLBACK TRAN;
--			RETURN -1
--	END CATCH

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spItemUpdateExp]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Update exp of Item>
-- =============================================
CREATE PROCEDURE [dbo].[spItemUpdateExp]
	-- Add the parameters for the stored procedure here
	@CharUid bigint, 
	@ItemUid bigint,
	@UpdateLevel int,
	@UpdateExp bigint

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF NOT EXISTS( SELECT 1 FROM Inventory WHERE CharUid = @CharUid AND ItemUid = @ItemUid AND DeleteDate IS NULL )
	BEGIN
		RETURN -1
	END

	UPDATE Inventory SET [Level] = @UpdateLevel, [Exp] = @UpdateExp WHERE CharUid = @CharUid AND ItemUid = @ItemUid

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spPostGetDetail]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.30>
-- Description:	<Get Post Detail>
-- =============================================
CREATE PROCEDURE [dbo].[spPostGetDetail] 
	-- Add the parameters for the stored procedure here
	@CharUid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Check Time-limit post items and remove
	UPDATE Post SET DeleteDate = GETDATE() WHERE CharUid = @CharUid AND DeleteDate IS NULL AND [ExpireDate] < GETDATE()
	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	SELECT PostUid, PostTid, RewardTid, RewardValue, isReaded, [ExpireDate] FROM Post WHERE CharUid = @CharUid AND DeleteDate IS NULL AND [ExpireDate] > GETDATE()

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spPostGetList]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.04.30>
-- Description:	<Get Post list>
-- =============================================
CREATE PROCEDURE [dbo].[spPostGetList] 
	-- Add the parameters for the stored procedure here
	@CharUid bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Check Time-limit post items and remove
	UPDATE Post SET DeleteDate = GETDATE() WHERE CharUid = @CharUid AND DeleteDate IS NULL AND [ExpireDate] < GETDATE()
	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	SELECT PostUid, PostTid, isReaded, [ExpireDate] FROM Post WHERE CharUid = @CharUid AND DeleteDate IS NULL AND [ExpireDate] > GETDATE()

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spQuestComplete]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Complete Quest and add rewards>
-- =============================================
CREATE PROCEDURE [dbo].[spQuestComplete] 
	-- Add the parameters for the stored procedure here
	@QuestUid bigint,
	@CharUid bigint,
	@CurrentLevel int,								--Rewards
	@CurrentExp bigint,
	@DeltaExp	bigint,
	@HeroType AS dbo.CreateHeroType Readonly,
	@ItemType AS dbo.CreateItemBundleType Readonly,
	@CurrencyType AS dbo.UpdateCurrencyType Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ReturnVal INT

	BEGIN TRAN

    -- Insert statements for procedure here
	UPDATE Quest SET [State] = 255 WHERE QuestUid = @QuestUid AND CharUid = @CharUid

	IF @@ROWCOUNT = 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	DECLARE @QuestType AS dbo.UpdateQuestType
	DECLARE @AchieveType AS dbo.UpdateAchievementType

	EXEC @ReturnVal = spRewardsRecv @CharUid, @CurrentLevel, @CurrentExp, @DeltaExp, @HeroType, @ItemType, @CurrencyType, @QuestType, @AchieveType

	IF @ReturnVal <> 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	COMMIT TRAN
	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spQuestUpdateProgress]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2014.05.02>
-- Description:	<Update Quest progress>
-- =============================================
CREATE PROCEDURE [dbo].[spQuestUpdateProgress]
	-- Add the parameters for the stored procedure here
	@QuestTid bigint, 
	@CharUid bigint,
	@Category1 smallint,
	@Category2 smallint,
	@Value1 bigint,
	@Value2 bigint,
	@State tinyint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 FROM Quest WHERE QuestTid = @QuestTid AND CharUid = @CharUid AND [State] = @State AND Category1 = @Category1 AND Category2 = @Category2 AND Value1 = @Value1 AND Value2 = @Value2)
	BEGIN
		RETURN -1
	END

	DECLARE @QuestUid bigint = 0

	BEGIN TRAN

	SELECT @QuestUid = QuestUid FROM Quest WHERE QuestTid = @QuestTid AND CharUid = @CharUid AND Category1 = @Category1 AND Category2 = @Category2
	IF @QuestUid = 0
	BEGIN
		INSERT INTO Quest (CharUid, QuestTid, Category1, Category2, Value1, Value2, [State])
		VALUES (@CharUid, @QuestTid, @Category1, @Category2, @Value1, @Value2, @State)

		SET @QuestUid = @@IDENTITY
	END
	ELSE
	BEGIN
		UPDATE Quest SET Value1 = @Value1, Value2 = @Value2, [State] = @State WHERE QuestUid = @QuestUid

		IF @@ERROR != 0
		BEGIN
			ROLLBACK TRAN
			RETURN -1
		END
	END

	COMMIT TRAN

	RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[spRewardsRecv]    Script Date: 9/22/2024 4:41:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Hyunchang Sung>
-- Create date: <2024.05.03>
-- Description:	<Receive some Rewards>
-- =============================================
CREATE PROCEDURE [dbo].[spRewardsRecv]
	-- Add the parameters for the stored procedure here
	@CharUid bigint, 
	@CurrentLevel int,
	@CurrentExp bigint,
	@DeltaExp	bigint,
	@HeroType AS dbo.CreateHeroType Readonly,
	@ItemType AS dbo.CreateItemBundleType Readonly,
	@CurrencyType AS dbo.UpdateCurrencyType Readonly,
	@QuestType AS dbo.UpdateQuestType Readonly,
	@AchieveType AS dbo.UpdateAchievementType Readonly
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN

    -- Insert statements for procedure here
	IF EXISTS (SELECT 1 FROM @HeroType)
	BEGIN
		INSERT INTO Hero (CharUid, HeroTid, Grade, [Level], [Exp], Enchant)
		SELECT CharUid, HeroTid, Grade, [Level], [Exp], Enchant
		FROM @HeroType
	END

		IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -2
	END

	IF EXISTS (SELECT 1 FROM @ItemType)
	BEGIN
		INSERT INTO Inventory (ItemUid, CharUid, ItemTid, [Type], [Level], [Exp], [Count], [ExpireDate])
		SELECT ItemUid, CharUid, ItemTid, [Type], [Level], [Exp], [Count], [ExpireDate] FROM @ItemType
	END

	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -3
	END

	IF EXISTS (SELECT 1 FROM @CurrencyType)
	BEGIN
		MERGE Currency AS Target
		USING @CurrencyType AS Source
		ON (Target.CharUid = Source.CharUid AND Target.CurrencyTid = Source.CurrencyTid)
		WHEN MATCHED THEN
			UPDATE SET Target.[Value] = Source.[Value], Target.UpdateDate = GETDATE()
		WHEN NOT MATCHED THEN
			INSERT (CharUid, CurrencyTid, [Value])
			VALUES (Source.CharUid, Source.CurrencyTid, Source.[Value]);
	END

	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -4
	END

	IF EXISTS (SELECT 1 FROM @QuestType)
	BEGIN
		MERGE Quest AS Target
		USING @QuestType AS Source
		ON (Target.CharUid = Source.CharUid AND Target.QuestTid = Source.QuestTid)
		WHEN MATCHED THEN
			UPDATE SET Target.Value1 = Source.Value1, Target.Value2 = Source.Value2, Target.[State] = Source.[State], UpdateDate = GETDATE()
		WHEN NOT MATCHED THEN
			INSERT (CharUid, QuestTid, Category1, Category2, Value1, Value2, [State])
			VALUES (Source.CharUid, Source.QuestTid, Source.Category1, Source.Category2, Source.Value1, Source.Value2, Source.[State]);
	END

	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -5
	END

	IF EXISTS (SELECT 1 FROM @AchieveType)
	BEGIN
		MERGE Achievement AS Target
		USING @AchieveType AS Source
		ON (Target.CharUid = Source.CharUid AND Target.AchieveTid = Source.AchieveTid)
		WHEN MATCHED THEN
			UPDATE SET Target.Value1 = Source.Value1, Target.Value2 = Source.Value2, Target.[State] = Source.[State], UpdateDate = GETDATE()
		WHEN NOT MATCHED THEN
			INSERT (CharUid, AchieveTid, Category1, Category2, Value1, Value2, [State])
			VALUES (Source.CharUid, Source.AchieveTid, Source.Category1, Source.Category2, Source.Value1, Source.Value2, Source.[State]);
	END

	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -6
	END

	EXEC dbo.spExpUpdate @CharUid, @CurrentLevel, @CurrentExp, @DeltaExp

	IF @@ERROR != 0
	BEGIN
		ROLLBACK TRAN
		RETURN -1
	END

	COMMIT TRAN
	RETURN 0
END
GO
USE [master]
GO
ALTER DATABASE [MockDB] SET  READ_WRITE 
GO
