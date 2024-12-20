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

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mockdb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mockdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mockdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mockdb` ;

-- -----------------------------------------------------
-- Table `mockdb`.`account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`account` (
  `AccountUid` BIGINT NOT NULL,
  `ChannelType` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `ChannelId` BIGINT NOT NULL,
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `LoginDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `LogoutDate` DATETIME(3) NULL DEFAULT NULL,
  `CharUid` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`AccountUid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`achievement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`achievement` (
  `AchieveUid` BIGINT NOT NULL AUTO_INCREMENT,
  `CharUid` BIGINT NOT NULL,
  `AchieveTid` BIGINT NOT NULL,
  `Category1` SMALLINT NOT NULL DEFAULT '0',
  `Category2` SMALLINT NOT NULL DEFAULT '0',
  `Value1` BIGINT NOT NULL DEFAULT '0',
  `Value2` BIGINT NOT NULL DEFAULT '0',
  `State` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `UpdateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`AchieveUid`),
  UNIQUE INDEX `uk_achievement_charuid_achievetid` (`CharUid` ASC, `AchieveTid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`character`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`character` (
  `CharUid` BIGINT NOT NULL AUTO_INCREMENT,
  `AccountUid` BIGINT NOT NULL,
  `CharName` VARCHAR(20) NOT NULL,
  `CharType` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `Level` INT NOT NULL DEFAULT '1',
  `Exp` BIGINT NOT NULL DEFAULT '0',
  `LoginDate` DATETIME(3) NULL DEFAULT NULL,
  `LogoutDate` DATETIME(3) NULL DEFAULT NULL,
  PRIMARY KEY (`CharUid`),
  INDEX `idx_character_AccountUid` (`AccountUid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`collection`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`collection` (
  `CollectionUid` BIGINT NOT NULL,
  `CharUid` BIGINT NOT NULL,
  `CollectionTid` BIGINT NOT NULL,
  `Type` SMALLINT NOT NULL,
  `State` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `Value1` BIGINT NOT NULL DEFAULT '0',
  `Value2` BIGINT NOT NULL DEFAULT '0',
  `Value3` BIGINT NOT NULL DEFAULT '0',
  `Value4` BIGINT NOT NULL DEFAULT '0',
  `Value5` BIGINT NOT NULL DEFAULT '0',
  `Value6` BIGINT NOT NULL DEFAULT '0',
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `UpdateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`CollectionUid`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`currency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`currency` (
  `CurrencyUid` BIGINT NOT NULL AUTO_INCREMENT,
  `CharUid` BIGINT NOT NULL,
  `CurrencyTid` BIGINT NOT NULL,
  `Value` BIGINT NOT NULL DEFAULT '0',
  `UpdateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`CurrencyUid`),
  UNIQUE INDEX `uk_charuid_currencytid` (`CharUid` ASC, `CurrencyTid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`equipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`equipment` (
  `ItemUid` BIGINT NOT NULL,
  `CharUid` BIGINT NOT NULL,
  `Slot` SMALLINT NOT NULL,
  `UpdateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`CharUid`, `Slot`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`hero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`hero` (
  `HeroUid` BIGINT NOT NULL AUTO_INCREMENT,
  `CharUid` BIGINT NOT NULL,
  `HeroTid` BIGINT NOT NULL,
  `Grade` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `Level` INT NOT NULL DEFAULT '1',
  `Exp` BIGINT NOT NULL DEFAULT '0',
  `Enchant` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `DeleteDate` DATETIME(3) NULL DEFAULT NULL,
  `DeleteReason` SMALLINT NULL DEFAULT NULL,
  UNIQUE INDEX `HeroUid` (`HeroUid` ASC) VISIBLE,
  INDEX `idx_hero_CharUid` (`CharUid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`inventory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`inventory` (
  `ItemUid` BIGINT NOT NULL AUTO_INCREMENT,
  `CharUid` BIGINT NOT NULL,
  `ItemTid` BIGINT NOT NULL,
  `Type` TINYINT UNSIGNED NOT NULL,
  `Level` INT NOT NULL,
  `Exp` BIGINT NOT NULL,
  `Count` INT NOT NULL,
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `ExpireDate` DATETIME(3) NULL DEFAULT NULL,
  `DeleteDate` DATETIME(3) NULL DEFAULT NULL,
  `DeleteReason` SMALLINT NULL DEFAULT NULL,
  PRIMARY KEY (`ItemUid`),
  INDEX `idx_inventory_CharUid` (`CharUid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`post` (
  `PostUid` BIGINT NOT NULL,
  `CharUid` BIGINT NOT NULL,
  `PostTid` BIGINT NOT NULL,
  `RewardTid` BIGINT NOT NULL,
  `RewardValue` BIGINT NOT NULL DEFAULT '0',
  `IsReaded` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `ExpireDate` DATETIME(3) NOT NULL DEFAULT (now(3) + interval 30 day),
  `ReadDate` DATETIME(3) NULL DEFAULT NULL,
  `DeleteDate` DATETIME(3) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mockdb`.`quest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mockdb`.`quest` (
  `QuestUid` BIGINT NOT NULL AUTO_INCREMENT,
  `CharUid` BIGINT NOT NULL,
  `QuestTid` BIGINT NOT NULL,
  `Category1` SMALLINT NOT NULL DEFAULT '0',
  `Category2` SMALLINT NOT NULL DEFAULT '0',
  `Value1` BIGINT NOT NULL DEFAULT '0',
  `Value2` BIGINT NOT NULL DEFAULT '0',
  `State` TINYINT UNSIGNED NOT NULL DEFAULT '0',
  `CreateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `UpdateDate` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (`QuestUid`),
  UNIQUE INDEX `uk_quest_charuid_questtid` (`CharUid` ASC, `QuestTid` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `mockdb` ;

-- -----------------------------------------------------
-- procedure spAccountLogin
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spAccountLogin`(in par_ChannelType TINYINT UNSIGNED, in par_ChannelId BIGINT, OUT ReturnCode INT)
BEGIN
# /* ============================================= */
# /* Author:		<Hyunchang Sung> */
# /* Create date: <2024.05.17> */
# /* Description:	<Account Login Procedure> */
# /* ============================================= */
# /* Add the parameters for the stored procedure here */
return_label:
BEGIN
   DECLARE var_AccountUid BIGINT DEFAULT 0;
   DECLARE var_CharUid BIGINT DEFAULT 0;
   DECLARE `@@ERROR` INT DEFAULT 0;
   
   SELECT
	   AccountUid
	   INTO var_AccountUid
	   FROM `account`
	   WHERE ChannelType = par_ChannelType AND ChannelId = par_ChannelId AND LoginDate <= LogoutDate;
   /* Insert statements for procedure here */
   IF var_AccountUid != 0 THEN
           SELECT
               var_AccountUid, CharUid
               FROM `character`
               WHERE AccountUid = var_AccountUid;
           SELECT
               CharUid, CharName, CharType, Level, Exp
               FROM `character`
               WHERE AccountUid = var_AccountUid;
   ELSE
           BEGIN
               SET `@@ERROR` := 1;
           END;
       INSERT INTO account
           (AccountUid, ChannelType, ChannelId)
           VALUES (par_ChannelId, par_ChannelType, par_ChannelId);
        IF ROW_COUNT() = 0 THEN
            SELECT @AccountUid, @CharUid;
            LEAVE return_label;
        END IF;       
        
	   SET var_AccountUid = par_channelId;
	   SELECT
		   var_AccountUid, var_CharUid;
   END IF;
   SET ReturnCode := 0;
   LEAVE return_label;
END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spAccountLogout
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spAccountLogout`(in par_AccountUid BIGINT, in par_CharUid BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    
    /*
    [810 - Severity CRITICAL - MySQL doesn't support SET NOCOUNT statements. Revise your code to use another way to send message back to the application, and try again.]
    SET NOCOUNT ON;
    */
    /* Insert statements for procedure here */
    IF EXISTS (SELECT
            1
            FROM account
            WHERE AccountUid = par_AccountUid) THEN
            UPDATE account
            SET LogoutDate = NOW(3)
            WHERE AccountUid = par_AccountUid;
            UPDATE `character`
            SET LogoutDate = NOW(3)
            WHERE CharUid = par_CharUid;
    ELSE
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spAchievementComplete
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spAchievementComplete`(in par_AchieveUid BIGINT, in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, in par_HeroType VARCHAR(255), in par_ItemType VARCHAR(255), in par_CurrencyType VARCHAR(255), OUT ReturnCode INT)
BEGIN
/* ============================================= */
/* Author:		<Hyunchang Sung> */
/* Create date: <2024.05.03> */
/* Description:	<Complete Achievement and add rewards> */
/* ============================================= */
/* Add the parameters for the stored procedure here */
/* Rewards */
return_label:
BEGIN
   DECLARE var_ReturnVal INT;
   /* SET NOCOUNT ON added to prevent extra result sets from */
   /* interfering with SELECT statements. */
   
   START TRANSACTION;
   /* Insert statements for procedure here */
       UPDATE achievement
       SET State = 255
       WHERE AchieveUid = par_AchieveUid AND CharUid = par_CharUid;

   IF row_count() = 0 THEN
       ROLLBACK;
       SET ReturnCode := - 1;
       LEAVE return_label;
   END IF;

   CALL spRewardsRecv (par_CharUid, par_CurrentLevel, par_CurrentExp, par_DeltaExp, var_ReturnVal);

   IF var_ReturnVal <> 0 THEN
       ROLLBACK;
       SET ReturnCode := - 1;
       LEAVE return_label;
   END IF;
   COMMIT;
   SET ReturnCode := 0;
   LEAVE return_label;
END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spAchievementCompleteJSON
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spAchievementCompleteJSON`(in par_AchieveUid BIGINT, in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, in par_HeroType VARCHAR(255), in par_ItemType VARCHAR(255), in par_CurrencyType VARCHAR(255), OUT ReturnCode INT)
BEGIN
/* ============================================= */
/* Author:		<Hyunchang Sung> */
/* Create date: <2024.05.03> */
/* Description:	<Complete Achievement and add rewards> */
/* ============================================= */
/* Add the parameters for the stored procedure here */
/* Rewards */
return_label:
BEGIN
   DECLARE var_ReturnVal INT;
   /* SET NOCOUNT ON added to prevent extra result sets from */
   /* interfering with SELECT statements. */
   
   START TRANSACTION;
   /* Insert statements for procedure here */
       UPDATE achievement
       SET State = 255
       WHERE AchieveUid = par_AchieveUid AND CharUid = par_CharUid;

   IF row_count() = 0 THEN
       ROLLBACK;
       SET ReturnCode := - 1;
       LEAVE return_label;
   END IF;

   CALL spRewardsRecvJSON (par_CharUid, par_CurrentLevel, par_CurrentExp, par_DeltaExp, par_HeroType, par_ItemType, par_CurrencyType, "{}", "{}", @var_ReturnVal);

   IF var_ReturnVal <> 0 THEN
       ROLLBACK;
       SET ReturnCode := - 1;
       LEAVE return_label;
   END IF;
   COMMIT;
   SET ReturnCode := 0;
   LEAVE return_label;
END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spAchievementUpdateProgress
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spAchievementUpdateProgress`(in par_AchieveTid BIGINT, in par_CharUid BIGINT, in par_Category1 SMALLINT, in par_Category2 SMALLINT, in par_Value1 BIGINT, in par_Value2 BIGINT, in par_State TINYINT UNSIGNED, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2014.05.02> */
 /* Description:	<Update Achievement progress> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE var_AchieveUid BIGINT DEFAULT 0;
    DECLARE `@@ERROR` INT DEFAULT 0;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    IF EXISTS (SELECT
            1
            FROM achievement
            WHERE AchieveTid = par_AchieveTid AND CharUid = par_CharUid AND State = par_State AND Category1 = par_Category1 AND Category2 = par_Category2 AND Value1 = par_Value1 AND Value2 = par_Value2) THEN
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    START TRANSACTION;
        SELECT
            AchieveUid
            INTO var_AchieveUid
            FROM achievement
            WHERE AchieveTid = par_AchieveTid AND CharUid = par_CharUid AND Category1 = par_Category1 AND Category2 = par_Category2;

    IF var_AchieveUid = 0 THEN
        INSERT INTO achievement
            (CharUid, AchieveTid, Category1, Category2, Value1, Value2, State)
            VALUES (par_CharUid, par_AchieveTid, par_Category1, par_Category2, par_Value1, par_Value2, par_State);
        SET var_AchieveUid := LAST_INSERT_ID();
    ELSE
		BEGIN
			SET `@@ERROR` := 1;
		END;
		UPDATE achievement
		SET Value1 = par_Value1, Value2 = par_Value2, State = par_State
		WHERE AchieveUid = var_AchieveUid;

        IF `@@ERROR` != 0 THEN
            SET `@@ERROR` := 0;
            ROLLBACK;
            SET ReturnCode := - 1;
            LEAVE return_label;
        END IF;
    END IF;
    COMMIT;
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spCharacterCreate
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spCharacterCreate`(in par_AccountUid BIGINT, in par_CharUid BIGINT, in par_CharName VARCHAR(20), in par_CharType TINYINT UNSIGNED, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE var_CharUid BIGINT DEFAULT 0;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* Insert statements for procedure here */
    IF EXISTS (SELECT
            1
            FROM `character`
            WHERE CharName = par_CharName) THEN
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    INSERT INTO `character`
        (CharUid, AccountUid, CharName, CharType)
        VALUES (par_CharUid, par_AccountUid, par_CharName, par_CharType);
        SET var_CharUid = par_CharUid;
        SELECT
            var_CharUid;
        SELECT
            CharName, CharType, Level, Exp
            FROM `character`
            WHERE AccountUid = par_AccountUid AND CharUid = var_CharUid;
        UPDATE account
        SET CharUid = var_CharUid
        WHERE AccountUid = par_AccountUid;
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spCharacterLogin
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spCharacterLogin`(in par_AccountUid BIGINT, in par_CharUid BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* Insert statements for procedure here */
    IF NOT EXISTS (SELECT
            1
            FROM `character`
            WHERE AccountUid = par_AccountUid AND CharUid = par_CharUid) THEN
        SET ReturnCode := - 9999;
        LEAVE return_label;
    END IF;
    START TRANSACTION;
        UPDATE `character`
        SET LoginDate = NOW(3)
        WHERE AccountUid = par_AccountUid AND CharUid = par_CharUid;

    /* Check Time-limit items and remove */
        UPDATE inventory
        SET DeleteDate = NOW(3), DeleteReason = 999
        WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND (ExpireDate IS NOT NULL AND ExpireDate < NOW(3));

    /* Check Time-limit post items and remove */
        UPDATE post
        SET DeleteDate = NOW(3)
        WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND ExpireDate IS NOT NULL AND ExpireDate < NOW(3);
    COMMIT;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            ItemUid, Slot
            FROM equipment
            WHERE CharUid = par_CharUid;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            ItemUid, ItemTid, Type, Level, Exp, Count
            FROM inventory
            WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND (ExpireDate IS NULL OR ExpireDate > NOW(3));
        SELECT
            CurrencyUid, CurrencyTid, Value
            FROM currency
            WHERE CharUid = par_CharUid;
        SELECT
            HeroUid, HeroTid, Grade, Level, Exp, Enchant
            FROM hero
            WHERE CharUid = par_CharUid AND DeleteDate IS NULL;
        SELECT
            QuestUid, QuestTid, Category1, Category2, Value1, Value2, State
            FROM quest
            WHERE CharUid = par_CharUid;
        SELECT
            AchieveUid, AchieveTid, Category1, Category2, Value1, Value2, State
            FROM achievement
            WHERE CharUid = par_CharUid;
        SELECT
            CollectionUid, CollectionTid, Type, State, Value1, Value2, Value3, Value4, Value5, Value6
            FROM collection
            WHERE CharUid = par_CharUid;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            PostUid, PostTid, RewardTid, RewardValue, IsReaded, ExpireDate
            FROM post
            WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND (ExpireDate IS NOT NULL AND ExpireDate > NOW(3));
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spCurrencyUpdate
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spCurrencyUpdate`(in par_CharUid BIGINT, in par_CurrencyTid BIGINT, in par_CurrentValue BIGINT, in par_DeltaValue BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* Insert statements for procedure here */
	INSERT currency (CharUid, CurrencyTid, Value)
	VALUES (par_CharUid, par_CurrencyTid, par_CurrentValue + par_DeltaValue)
	ON DUPLICATE KEY UPDATE
		`Value` = `Value` + par_DeltaValue;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            par_CurrentValue + par_DeltaValue;
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spEquipChange
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spEquipChange`(in par_CharUid BIGINT, in par_ItemUid BIGINT, in par_Slot SMALLINT, OUT ReturnCode INT)
return_label:
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* Insert statements for procedure here */
    IF NOT EXISTS (SELECT
            1
            FROM inventory
            WHERE CharUid = par_CharUid AND ItemUid = par_ItemUid AND DeleteDate IS NULL) THEN
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;

    IF EXISTS (SELECT
            1
            FROM equipment
            WHERE CharUid = par_CharUid AND Slot = par_Slot) THEN
            UPDATE equipment
            SET ItemUid = par_ItemUid, UpdateDate = NOW(3)
            WHERE CharUid = par_CharUid AND Slot = par_Slot;
    ELSE
        INSERT INTO equipment
            (ItemUid, CharUid, Slot)
            VALUES (par_ItemUid, par_CharUid, par_Slot);
    END IF;
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spExpUpdate
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spExpUpdate`(in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* Insert statements for procedure here */
/*    
    IF NOT EXISTS (SELECT
            1
            FROM `character`
            WHERE CharUid = par_CharUid AND `Level` = par_CurrentLevel AND `Exp` = par_CurrentExp) THEN
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
*/

    IF par_CurrentExp + par_DeltaExp >= par_CurrentLevel * par_CurrentLevel * 1000 AND par_CurrentLevel < 100 THEN
            UPDATE `character`
            SET `Level` = par_CurrentLevel + 1, `Exp` = par_CurrentExp + par_DeltaExp
            WHERE CharUid = par_CharUid;
    ELSE
            UPDATE `character`
            SET `Exp` = par_CurrentExp + par_DeltaExp
            WHERE CharUid = par_CharUid;
    END IF;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            `Level`, `Exp`
            FROM `character`
            WHERE CharUid = par_CharUid;
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spHeroCreate
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spHeroCreate`(in par_CharUid BIGINT, in par_HeroTid BIGINT, in par_Grade TINYINT UNSIGNED, in par_Level INT, in par_Exp BIGINT, in par_Enchant TINYINT UNSIGNED, OUT ReturnCode INT)
return_label:
BEGIN
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* Insert statements for procedure here */
    START TRANSACTION;
    INSERT INTO hero
        (CharUid, HeroTid, Grade, Level, Exp, Enchant)
        VALUES (par_CharUid, par_HeroTid, par_Grade, par_Level, par_Exp, par_Enchant);

    IF row_count() = 0 THEN
        ROLLBACK;
            SELECT
                0;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    COMMIT;
        SELECT
            LAST_INSERT_ID();
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spHeroGacha
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spHeroGacha`(OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.03> */
 /* Description:	<Gacha Heroes> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* BEGIN TRY */
    /* BEGIN TRAN; */
    /* Insert statements for procedure here */
    INSERT INTO hero
        (CharUid, HeroTid, Grade, Level, Exp, Enchant)
            SELECT
                CharUid, HeroTid, Grade, Level, Exp, Enchant
                FROM TempHeroGacha;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        /* ROLLBACK TRAN; */
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;

	SELECT HeroUid, HeroTid, `Grade`, `Level`, `Exp`, Enchant
	FROM hero
	WHERE HeroUid IN (SELECT last_insert_id() FROM Hero);
    
    /* COMMIT TRAN; */
    /* END TRY */
    /* BEGIN CATCH */
    /* IF @@TRANCOUNT > 0 */
    /* ROLLBACK TRAN; */
    /* RETURN -1 */
    /* END CATCH */
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spHeroGachaJson
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spHeroGachaJson`(IN par_HeroDBType JSON, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.03> */
 /* Description:	<Gacha Heroes> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
    DECLARE last_insert_id BIGINT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    /* BEGIN TRY */
    /* BEGIN TRAN; */
    /* Insert statements for procedure here */
	SET @json = JSON_UNQUOTE(par_HeroDBType);
	SET @data_length = JSON_LENGTH(@json);

	CREATE TEMPORARY TABLE IF NOT EXISTS inserted_ids (id BIGINT);

	WHILE i < @data_length DO
		SET @charUid		= JSON_EXTRACT(par_HeroDBType, CONCAT('$[',i,'].CharUid'));
		SET @heroTid		= JSON_EXTRACT(par_HeroDBType, CONCAT('$[',i,'].HeroTid'));
		SET @herograde		= JSON_EXTRACT(par_HeroDBType, CONCAT('$[',i,'].Grade'));
		SET @heroLevel		= JSON_EXTRACT(par_HeroDBType, CONCAT('$[',i,'].Level'));
		SET @heroExp		= JSON_EXTRACT(par_HeroDBType, CONCAT('$[',i,'].Exp'));
		SET @heroEnchant	= JSON_EXTRACT(par_HeroDBType, CONCAT('$[',i,'].Enchant'));
		
		INSERT INTO hero (CharUid, HeroTid, Grade, `Level`, `Exp`, Enchant)
		VALUES (@charUid, @heroTid, @herograde, @heroLevel, @heroExp, @heroEnchant);
	    SET last_insert_id = LAST_INSERT_ID();
        INSERT INTO inserted_ids VALUES (last_insert_id);
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        /* ROLLBACK TRAN; */
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;

    IF last_insert_id > 0 THEN
		SELECT HeroUid, HeroTid, `Grade`, `Level`, `Exp`, Enchant
		FROM Hero
		WHERE HeroUid IN (SELECT id FROM inserted_ids);
    END IF;

    /* COMMIT TRAN; */
    /* END TRY */
    /* BEGIN CATCH */
    /* IF @@TRANCOUNT > 0 */
    /* ROLLBACK TRAN; */
    /* RETURN -1 */
    /* END CATCH */
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spItemCreate
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spItemCreate`(in par_CharUid BIGINT, in par_ItemTid BIGINT, in par_Type TINYINT UNSIGNED, in par_Level INT, in par_Exp BIGINT, in par_Count INT, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* Insert statements for procedure here */
    INSERT INTO inventory
        (CharUid, ItemTid, Type, Level, Exp, Count)
        VALUES (par_CharUid, par_ItemTid, par_Type, par_Level, par_Exp, par_Count);

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            LAST_INSERT_ID();
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spItemCreateBundle
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spItemCreateBundle`(OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.06.04> */
 /* Description:	<Create Items> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* BEGIN TRY */
    /* BEGIN TRAN; */
    /* Insert statements for procedure here */
    INSERT INTO inventory (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
	SELECT
		CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate
		FROM TempItemCreateBundle;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        /* ROLLBACK TRAN; */
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;

	SELECT
		ItemUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate
		FROM inventory
		WHERE ItemUid in (SELECT last_insert_id() FROM inventory);
        
    /* COMMIT TRAN; */
    /* END TRY */
    /* BEGIN CATCH */
    /* IF @@TRANCOUNT > 0 */
    /* ROLLBACK TRAN; */
    /* RETURN -1 */
    /* END CATCH */
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spItemCreateBundleJson
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spItemCreateBundleJson`(in par_ItemType JSON, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.06.04> */
 /* Description:	<Create Items> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
    DECLARE last_insert_id BIGINT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* BEGIN TRY */
    /* BEGIN TRAN; */
    /* Insert statements for procedure here */
	SET @json = JSON_UNQUOTE(par_ItemType);
	SET @data_length = JSON_LENGTH(@json);

    CREATE TEMPORARY TABLE IF NOT EXISTS inserted_ids (id BIGINT);
    
	WHILE i < @data_length DO
		SET @charUid		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].CharUid'));
		SET @itemTid		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].ItemTid'));
		SET @itemType		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Type'));
		SET @itemLevel		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Level'));
		SET @itemExp		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Exp'));
		SET @itemCount		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Count'));
		SET @itemExpireDate	= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].ExpireDate'));
		
		INSERT INTO inventory (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
		VALUES (@charUid, @itemTid, @itemType, @itemLevel, @itemExp, @itemCount, @itemExpireDate);
	    SET last_insert_id = LAST_INSERT_ID();
        INSERT INTO inserted_ids VALUES (last_insert_id);
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        /* ROLLBACK TRAN; */
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;

    IF last_insert_id > 0 THEN
		SELECT ItemUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate
		FROM inventory
		WHERE ItemUid IN (SELECT id FROM inserted_ids);
    END IF;

    /* COMMIT TRAN; */
    /* END TRY */
    /* BEGIN CATCH */
    /* IF @@TRANCOUNT > 0 */
    /* ROLLBACK TRAN; */
    /* RETURN -1 */
    /* END CATCH */
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spItemGacha
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spItemGacha`(in par_Items VARCHAR(255), OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.22> */
 /* Description:	<Gacha Items> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* BEGIN TRY */
    /* BEGIN TRAN; */
    /* Insert statements for procedure here */
    INSERT INTO inventory
        (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
            SELECT
                CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate
                FROM TempItemGacha;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        /* ROLLBACK TRAN; */
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    /* COMMIT TRAN; */
    /* END TRY */
    /* BEGIN CATCH */
    /* IF @@TRANCOUNT > 0 */
    /* ROLLBACK TRAN; */
    /* RETURN -1 */
    /* END CATCH */
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spItemUpdateExp
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spItemUpdateExp`(in par_CharUid BIGINT, in par_ItemUid BIGINT, in par_UpdateLevel INT, in par_UpdateExp BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    /* Insert statements for procedure here */
    IF NOT EXISTS (SELECT
            1
            FROM inventory
            WHERE CharUid = par_CharUid AND ItemUid = par_ItemUid AND DeleteDate IS NULL) THEN
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        UPDATE inventory
        SET Level = par_UpdateLevel, Exp = par_UpdateExp
        WHERE CharUid = par_CharUid AND ItemUid = par_ItemUid;
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spPostGetDetail
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spPostGetDetail`(in par_CharUid BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* Insert statements for procedure here */
    /* Check Time-limit post items and remove */
        UPDATE post
        SET DeleteDate = NOW(3)
        WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND ExpireDate < NOW(3);

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            PostUid, PostTid, RewardTid, RewardValue, IsReaded, ExpireDate
            FROM post
            WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND ExpireDate > NOW(3);
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spPostGetList
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spPostGetList`(in par_CharUid BIGINT, OUT ReturnCode INT)
return_label:
BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* Insert statements for procedure here */
    /* Check Time-limit post items and remove */
        UPDATE post
        SET DeleteDate = NOW(3)
        WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND ExpireDate < NOW(3);

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
        SELECT
            PostUid, PostTid, IsReaded, ExpireDate
            FROM post
            WHERE CharUid = par_CharUid AND DeleteDate IS NULL AND ExpireDate > NOW(3);
    SET ReturnCode := 0;
    LEAVE return_label;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spQuestComplete
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spQuestComplete`(in par_QuestUid BIGINT, in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.03> */
 /* Description:	<Complete Quest and add rewards> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 /* Rewards */
 return_label:
 BEGIN
    DECLARE var_ReturnVal INT;
    START TRANSACTION;
    /* Insert statements for procedure here */
        UPDATE quest
        SET State = 255
        WHERE QuestUid = par_QuestUid AND CharUid = par_CharUid;

    IF row_count() = 0 THEN
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    CALL spRewardsRecv (par_CharUid, par_CurrentLevel, par_CurrentExp, par_DeltaExp, var_ReturnVal);

    IF var_ReturnVal <> 0 THEN
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    COMMIT;
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spQuestCompleteJSON
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spQuestCompleteJSON`(in par_QuestUid BIGINT, in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, in par_HeroType JSON, in par_ItemType JSON, in par_CurrencyType JSON, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.03> */
 /* Description:	<Complete Quest and add rewards> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 /* Rewards */
 return_label:
 BEGIN
    DECLARE var_ReturnVal INT;
	DECLARE i INT DEFAULT 0;
    START TRANSACTION;
    /* Insert statements for procedure here */
        UPDATE quest
        SET State = 255
        WHERE QuestUid = par_QuestUid AND CharUid = par_CharUid;

    IF row_count() = 0 THEN
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    CALL spRewardsRecvJSON (par_CharUid, par_CurrentLevel, par_CurrentExp, par_DeltaExp, par_HeroType, par_ItemType, par_CurrencyType, "{}", "{}", @var_ReturnVal);

    IF var_ReturnVal <> 0 THEN
        ROLLBACK;
        SET ReturnCode := var_ReturnVal;
        LEAVE return_label;
    END IF;
    COMMIT;
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spQuestUpdateProgress
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spQuestUpdateProgress`(in par_QuestTid BIGINT, in par_CharUid BIGINT, in par_Category1 SMALLINT, in par_Category2 SMALLINT, in par_Value1 BIGINT, in par_Value2 BIGINT, in par_State TINYINT UNSIGNED, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2014.05.02> */
 /* Description:	<Update Quest progress> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE var_QuestUid BIGINT DEFAULT 0;
    DECLARE `@@ERROR` INT DEFAULT 0;
    /* Insert statements for procedure here */
    IF EXISTS (SELECT
            1
            FROM quest
            WHERE QuestTid = par_QuestTid AND CharUid = par_CharUid AND State = par_State AND Category1 = par_Category1 AND Category2 = par_Category2 AND Value1 = par_Value1 AND Value2 = par_Value2) THEN
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    START TRANSACTION;
        SELECT
            QuestUid
            INTO var_QuestUid
            FROM quest
            WHERE QuestTid = par_QuestTid AND CharUid = par_CharUid AND Category1 = par_Category1 AND Category2 = par_Category2;

    IF var_QuestUid = 0 THEN
        INSERT INTO quest
            (CharUid, QuestTid, Category1, Category2, Value1, Value2, State)
            VALUES (par_CharUid, par_QuestTid, par_Category1, par_Category2, par_Value1, par_Value2, par_State)
		ON DUPLICATE KEY UPDATE
			Value1 = par_Value1,
            Value2 = par_Value2;
            
        SET var_QuestUid := LAST_INSERT_ID();
    ELSE
		BEGIN
			SET `@@ERROR` := 1;
		END;
		UPDATE quest
		SET Value1 = par_Value1, Value2 = par_Value2, State = par_State
		WHERE QuestUid = var_QuestUid;

        IF `@@ERROR` != 0 THEN
            SET `@@ERROR` := 0;
            ROLLBACK;
            SET ReturnCode := - 1;
            LEAVE return_label;
        END IF;
    END IF;
    COMMIT;
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spRewardsRecv
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spRewardsRecv`(in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.03> */
 /* Description:	<Receive some Rewards> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    
    /*
    [810 - Severity CRITICAL - MySQL doesn't support SET NOCOUNT statements. Revise your code to use another way to send message back to the application, and try again.]
    SET NOCOUNT ON;
    */
    START TRANSACTION;
    IF EXISTS (SELECT
            1
            FROM TempHeroGacha) THEN
        INSERT INTO hero
            (CharUid, HeroTid, Grade, Level, Exp, Enchant)
                SELECT
                    CharUid, HeroTid, Grade, Level, Exp, Enchant
                    FROM TempHeroGacha;
    END IF;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 2;
        LEAVE return_label;
    END IF;

    IF EXISTS (SELECT
            1
            FROM TempItemCreateBundle) THEN
        INSERT INTO inventory
            (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
                SELECT
                    CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate
                    FROM TempItemCreateBundle;
    END IF;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 3;
        LEAVE return_label;
    END IF;

    IF EXISTS (SELECT
            1
            FROM TempCurrency) THEN
        INSERT INTO currency
            (CharUid, CurrencyTid, Value)
                SELECT
                    Source.CharUid, Source.CurrencyTid, Source.Value
                    FROM TempCurrency AS Source
            ON DUPLICATE KEY UPDATE Target.Value = Source.Value, Target.UpdateDate = NOW(3);
    END IF;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 4;
        LEAVE return_label;
    END IF;

    IF EXISTS (SELECT
            1
            FROM TempQuest) THEN
        INSERT INTO quest
            (CharUid, QuestTid, Category1, Category2, Value1, Value2, State)
                SELECT
                    Source.CharUid, Source.QuestTid, Source.Category1, Source.Category2, Source.Value1, Source.Value2, Source.State
                    FROM TempQuest AS Source
            ON DUPLICATE KEY UPDATE Target.Value1 = Source.Value1, Target.Value2 = Source.Value2, Target.State = Source.State, UpdateDate = NOW(3);
    END IF;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 5;
        LEAVE return_label;
    END IF;

    IF EXISTS (SELECT
            1
            FROM TempAchievement) THEN
        INSERT INTO achievement
            (CharUid, AchieveTid, Category1, Category2, Value1, Value2, State)
                SELECT
                    Source.CharUid, Source.AchieveTid, Source.Category1, Source.Category2, Source.Value1, Source.Value2, Source.State
                    FROM TempAchievement AS Source
            ON DUPLICATE KEY UPDATE Target.Value1 = Source.Value1, Target.Value2 = Source.Value2, Target.State = Source.State, UpdateDate = NOW(3);
    END IF;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 6;
        LEAVE return_label;
    END IF;

    CALL spExpUpdate (par_CharUid, par_CurrentLevel, par_CurrentExp, par_DeltaExp, @ReturnCode);

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    /* Insert statements for procedure here */

    COMMIT;

    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure spRewardsRecvJSON
-- -----------------------------------------------------

DELIMITER $$
USE `mockdb`$$
CREATE DEFINER=`admin`@`%` PROCEDURE `spRewardsRecvJSON`(in par_CharUid BIGINT, in par_CurrentLevel INT, in par_CurrentExp BIGINT, in par_DeltaExp BIGINT, in par_HeroType JSON, in par_ItemType JSON, in par_CurrencyType JSON, in par_QuestType JSON, in par_AchieveType JSON, OUT ReturnCode INT)
BEGIN
 /* ============================================= */
 /* Author:		<Hyunchang Sung> */
 /* Create date: <2024.05.03> */
 /* Description:	<Receive some Rewards> */
 /* ============================================= */
 /* Add the parameters for the stored procedure here */
 return_label:
 BEGIN
    DECLARE `@@ERROR` INT DEFAULT 0;
	DECLARE i INT DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION

        BEGIN
            SET `@@ERROR` := 1;
        END;
    /* SET NOCOUNT ON added to prevent extra result sets from */
    /* interfering with SELECT statements. */
    
    /*
    [810 - Severity CRITICAL - MySQL doesn't support SET NOCOUNT statements. Revise your code to use another way to send message back to the application, and try again.]
    SET NOCOUNT ON;
    */
    START TRANSACTION;
    CALL spExpUpdate (par_CharUid, par_CurrentLevel, par_CurrentExp, par_DeltaExp, @ReturnCode);

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 1;
        LEAVE return_label;
    END IF;
    /* Insert statements for procedure here */

	SET @json = JSON_UNQUOTE(par_HeroType);
	SET @data_length = JSON_LENGTH(@json);

    SET i = 0;
	WHILE i < @data_length DO
		SET @charUid		= JSON_EXTRACT(par_HeroType, CONCAT('$[',i,'].CharUid'));
		SET @heroTid		= JSON_EXTRACT(par_HeroType, CONCAT('$[',i,'].HeroTid'));
		SET @herograde		= JSON_EXTRACT(par_HeroType, CONCAT('$[',i,'].Grade'));
		SET @heroLevel		= JSON_EXTRACT(par_HeroType, CONCAT('$[',i,'].Level'));
		SET @heroExp		= JSON_EXTRACT(par_HeroType, CONCAT('$[',i,'].Exp'));
		SET @heroEnchant	= JSON_EXTRACT(par_HeroType, CONCAT('$[',i,'].Enchant'));
		
		INSERT INTO hero (CharUid, HeroTid, Grade, `Level`, `Exp`, Enchant)
		VALUES (@charUid, @heroTid, @herograde, @heroLevel, @heroExp, @heroEnchant);
		SELECT LAST_INSERT_ID();
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 2;
        LEAVE return_label;
    END IF;

	SET @json = JSON_UNQUOTE(par_ItemType);
	SET @data_length = JSON_LENGTH(@json);

    SET i = 0;
	WHILE i < @data_length DO
		SET @charUid		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].CharUid'));
		SET @itemTid		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].ItemTid'));
		SET @itemType		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Type'));
		SET @itemLevel		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Level'));
		SET @itemExp		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Exp'));
		SET @itemCount		= JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].Count'));
		IF JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].ExpireDate')) IS NOT NULL THEN
			SET @itemExpireDate = JSON_EXTRACT(par_ItemType, CONCAT('$[',i,'].ExpireDate'));
		ELSE
			SET @itemExpireDate = NULL; -- 또는 원하는 기본값 설정
		END IF;
		
		INSERT INTO inventory (CharUid, ItemTid, `Type`, `Level`, `Exp`, `Count`, ExpireDate)
		VALUES (@charUid, @itemTid, @itemType, @itemLevel, @itemExp, @itemCount, @itemExpireDate);
		SELECT LAST_INSERT_ID();
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 3;
        LEAVE return_label;
    END IF;

	SET @json = JSON_UNQUOTE(par_CurrencyType);
	SET @data_length = JSON_LENGTH(@json);

    SET i = 0;
	WHILE i < @data_length DO
		SET @charUid		= JSON_EXTRACT(par_CurrencyType, CONCAT('$[',i,'].CharUid'));
		SET @currencyTid	= JSON_EXTRACT(par_CurrencyType, CONCAT('$[',i,'].CurrencyTid'));
		SET @currencyValue	= JSON_EXTRACT(par_CurrencyType, CONCAT('$[',i,'].Value'));
		
		INSERT INTO currency (CharUid, CurrencyTid, `Value`)
		VALUES (@charUid, @currencyTid, @currencyValue);
		SELECT LAST_INSERT_ID();
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 4;
        LEAVE return_label;
    END IF;

	SET @json = JSON_UNQUOTE(par_QuestType);
	SET @data_length = JSON_LENGTH(@json);

    SET i = 0;
	WHILE i < @data_length DO
		SET @charUid		= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].CharUid'));
		SET @questTid		= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].QuestTid'));
		SET @questCategory1	= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].Category1'));
		SET @questCategory2	= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].Category2'));
		SET @questValue1	= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].Value1'));
		SET @questValue2	= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].Value2'));
		SET @questState		= JSON_EXTRACT(par_QuestType, CONCAT('$[',i,'].State'));
		
		INSERT INTO quest (CharUid, QuestTid, Category1, Category2, Value1, Value2, `State`)
		VALUES (@charUid, @questTid, @questCategory1, @questCategory2, @questValue1, @questValue2, @questState)
        ON DUPLICATE KEY UPDATE
			Value1 = @questValue1,
			Value2 = @questValue2,
            `State` = @questState;
			
		SELECT LAST_INSERT_ID();
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 5;
        LEAVE return_label;
    END IF;

	SET @json = JSON_UNQUOTE(par_AchieveType);
	SET @data_length = JSON_LENGTH(@json);

    SET i = 0;
	WHILE i < @data_length DO
		SET @charUid			= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].CharUid'));
		SET @achieveTid			= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].AchieveTid'));
		SET @achiveCategory1	= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].Category1'));
		SET @achieveCategory2	= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].Category2'));
		SET @achieveValue1		= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].Value1'));
		SET @achieveValue2		= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].Value2'));
		SET @achieveState		= JSON_EXTRACT(par_AchieveType, CONCAT('$[',i,'].State'));
		
		INSERT INTO achievement (CharUid, AchieveTid, Category1, Category2, Value1, Value2, `State`)
		VALUES (@charUid, @questTid, @achieveCategory1, @achieveCategory2, @achieveValue1, @achieveValue2, @achieveState)
        ON DUPLICATE KEY UPDATE
			Value1 = @achieveValue1,
			Value2 = @achieveValue2,
            `State` = @achieveState;
			
		SELECT LAST_INSERT_ID();
		SELECT i + 1 INTO i;
	END WHILE;

    IF `@@ERROR` != 0 THEN
        SET `@@ERROR` := 0;
        ROLLBACK;
        SET ReturnCode := - 6;
        LEAVE return_label;
    END IF;
    COMMIT;
    SET ReturnCode := 0;
    LEAVE return_label;
 END;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
