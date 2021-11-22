-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server versie:                5.7.31 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Versie:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Databasestructuur van fivem-framework2 wordt geschreven
CREATE DATABASE IF NOT EXISTS `fivem-framework` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `fivem-frame`;

-- Structuur van  tabel fivem-framework2.players wordt geschreven
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT 'None',
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `money` text,
  `charinfo` text,
  `job` tinytext,
  `gang` tinytext,
  `position` text,
  `inventory` varchar(64000) DEFAULT '{}',
  `metadata` text,
  `licenses` text,
  `skills` text,
  `addiction` varchar(50) DEFAULT NULL,
  `tattoos` text,
  `walkingstyle` varchar(50) DEFAULT '{}',
  `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `hudsettings` text,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=MyISAM AUTO_INCREMENT=4016 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.players: 0 rows
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
/*!40000 ALTER TABLE `players` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_accounts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `balance` int(20) DEFAULT '0',
  `authorized` varchar(500) DEFAULT NULL,
  `transactions` varchar(60000) DEFAULT '{}',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=333 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_accounts: 0 rows
/*!40000 ALTER TABLE `player_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_accounts` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_business wordt geschreven
CREATE TABLE IF NOT EXISTS `player_business` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `logo` varchar(150) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `employees` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_business: 0 rows
/*!40000 ALTER TABLE `player_business` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_business` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_contacts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `number` varchar(100) DEFAULT NULL,
  `iban` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_contacts: 0 rows
/*!40000 ALTER TABLE `player_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_contacts` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_houses wordt geschreven
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT '[]',
  `house` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` int(11) DEFAULT NULL,
  `owned` varchar(50) DEFAULT 'true',
  `coords` text,
  `hasgarage` varchar(50) DEFAULT 'false',
  `garage` varchar(200) DEFAULT '[]',
  `keyholders` text,
  `decorations` longtext,
  `stash` text,
  `outfit` text,
  `logout` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=972 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_houses: 0 rows
/*!40000 ALTER TABLE `player_houses` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_houses` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_house_plants wordt geschreven
CREATE TABLE IF NOT EXISTS `player_house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `houseid` varchar(50) DEFAULT '11111',
  `plants` varchar(65000) DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=60 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_house_plants: 0 rows
/*!40000 ALTER TABLE `player_house_plants` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_house_plants` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_inventory-stash wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-stash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(50) NOT NULL,
  `items` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5083 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_inventory-stash: 0 rows
/*!40000 ALTER TABLE `player_inventory-stash` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_inventory-stash` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_inventory-vehicle wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) NOT NULL,
  `trunkitems` longtext,
  `gloveboxitems` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5392 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_inventory-vehicle: 0 rows
/*!40000 ALTER TABLE `player_inventory-vehicle` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_inventory-vehicle` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_mails wordt geschreven
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` longtext,
  `mailid` int(11) DEFAULT NULL,
  `read` varchar(50) DEFAULT NULL,
  `button` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_mails: 0 rows
/*!40000 ALTER TABLE `player_mails` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_mails` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_messages wordt geschreven
CREATE TABLE IF NOT EXISTS `player_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL DEFAULT '0',
  `number` varchar(50) DEFAULT NULL,
  `messages` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_messages: 0 rows
/*!40000 ALTER TABLE `player_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_messages` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_outfits wordt geschreven
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text,
  `outfitId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4705 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_outfits: 0 rows
/*!40000 ALTER TABLE `player_outfits` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_outfits` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_phone_contacts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `contactname` varchar(100) DEFAULT NULL,
  `contactnumber` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=119 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_phone_contacts: 0 rows
/*!40000 ALTER TABLE `player_phone_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_phone_contacts` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_skins wordt geschreven
CREATE TABLE IF NOT EXISTS `player_skins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL DEFAULT '',
  `model` varchar(50) NOT NULL DEFAULT '0',
  `skin` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=21412 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_skins: 0 rows
/*!40000 ALTER TABLE `player_skins` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_skins` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.player_vehicles wordt geschreven
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT 'Blokken Parking',
  `state` varchar(50) DEFAULT 'in',
  `parts` varchar(300) DEFAULT '{"Transmissie":{"Class":"B","Procent":100},"Brandstof Injectoren":{"Class":"B","Procent":100},"Aandrijfas":{"Class":"B","Procent":100},"Koppeling":{"Class":"B","Procent":100},"Motor":{"Class":"B","Procent":100},"Remmen":{"Class":"B","Procent":100}}',
  `mods` text,
  `metadata` varchar(1000) DEFAULT '{"Engine":1000.0,"Body":1000.0,"Fuel":100.0}',
  `selling` varchar(50) NOT NULL DEFAULT 'false',
  `sellprice` int(11) NOT NULL DEFAULT '0',
  `depotprice` int(11) DEFAULT '100',
  `impoundreason` varchar(100) DEFAULT 'Geen Reden.',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4791 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.player_vehicles: 0 rows
/*!40000 ALTER TABLE `player_vehicles` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_vehicles` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.server_bans wordt geschreven
CREATE TABLE IF NOT EXISTS `server_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `reason` varchar(250) DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(50) DEFAULT 'Server PC',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=346 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.server_bans: 0 rows
/*!40000 ALTER TABLE `server_bans` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_bans` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.server_cardealer wordt geschreven
CREATE TABLE IF NOT EXISTS `server_cardealer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` varchar(50) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.server_cardealer: 0 rows
/*!40000 ALTER TABLE `server_cardealer` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_cardealer` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.server_extra wordt geschreven
CREATE TABLE IF NOT EXISTS `server_extra` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(75) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `permission` varchar(50) DEFAULT 'user',
  `priority` int(11) DEFAULT '3',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=116 DEFAULT CHARSET=latin1;

-- Dumpen data van tabel fivem-framework2.server_extra: 0 rows
/*!40000 ALTER TABLE `server_extra` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_extra` ENABLE KEYS */;

-- Structuur van  tabel fivem-framework2.server_lapraces wordt geschreven
CREATE TABLE IF NOT EXISTS `server_lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text,
  `records` text,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4;

-- Dumpen data van tabel fivem-framework2.server_lapraces: ~0 rows (ongeveer)
/*!40000 ALTER TABLE `server_lapraces` DISABLE KEYS */;
/*!40000 ALTER TABLE `server_lapraces` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
