-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 15 apr 2022 om 15:28
-- Serverversie: 10.4.21-MariaDB
-- PHP-versie: 8.0.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lotus`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `bossmenu`
--

CREATE TABLE `bossmenu` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) NOT NULL,
  `amount` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Gegevens worden geëxporteerd voor tabel `bossmenu`
--

INSERT INTO `bossmenu` (`id`, `job_name`, `amount`) VALUES
(1, 'police', 0),
(2, 'ambulance', 0),
(3, 'realestate', 0),
(4, 'taxi', 0),
(5, 'cardealer', 0),
(6, 'mechanic', 0);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `characters_invoices`
--

CREATE TABLE `characters_invoices` (
  `id` int(50) NOT NULL,
  `receiver_identifier` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `author_identifier` varchar(255) NOT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `society` varchar(255) NOT NULL,
  `society_name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `invoice_value` int(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `notes` varchar(255) DEFAULT ' ',
  `sent_date` varchar(255) NOT NULL,
  `limit_pay_date` varchar(255) DEFAULT NULL,
  `fees_amount` int(50) DEFAULT 0,
  `paid_date` varchar(255) DEFAULT NULL,
  `targetrpname` varchar(255) DEFAULT NULL,
  `sourcerpname` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `daily_free`
--

CREATE TABLE `daily_free` (
  `id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `next_collect` int(15) NOT NULL,
  `times_collected` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `gangmenu`
--

CREATE TABLE `gangmenu` (
  `id` int(11) NOT NULL,
  `job_name` varchar(50) NOT NULL,
  `amount` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Gegevens worden geëxporteerd voor tabel `gangmenu`
--

INSERT INTO `gangmenu` (`id`, `job_name`, `amount`) VALUES
(1, 'thebastards', 0),
(2, 'bloods', 0);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `occasion_vehicles`
--

CREATE TABLE `occasion_vehicles` (
  `id` int(11) NOT NULL,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionId` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `occasion_vehicles`
--

INSERT INTO `occasion_vehicles` (`id`, `seller`, `price`, `description`, `plate`, `model`, `mods`, `occasionId`) VALUES
(106, 'BHJ78670', 232, '', '5FB367JP', 'calico', '{\"modAerials\":-1,\"modSpeakers\":-1,\"modArchCover\":-1,\"color2\":111,\"modFrontBumper\":-1,\"modEngine\":-1,\"modEngineBlock\":-1,\"wheels\":7,\"modSuspension\":-1,\"modSpoilers\":-1,\"modSideSkirt\":-1,\"modVanityPlate\":-1,\"modAPlate\":-1,\"modArmor\":-1,\"modRightFender\":-1,\"modOrnaments\":-1,\"modSmokeEnabled\":false,\"modBrakes\":-1,\"dirtLevel\":7.00955629348754,\"modLivery\":-1,\"tyreSmokeColor\":[255,255,255],\"modSteeringWheel\":-1,\"modFrontWheels\":-1,\"modHood\":-1,\"neonEnabled\":[false,false,false,false],\"windowTint\":-1,\"wheelColor\":111,\"modRoof\":-1,\"modBackWheels\":-1,\"modHydrolic\":-1,\"modDoorSpeaker\":-1,\"modAirFilter\":-1,\"neonColor\":[255,0,255],\"modWindows\":-1,\"plateIndex\":0,\"color1\":111,\"modTrimA\":-1,\"modExhaust\":-1,\"modRearBumper\":-1,\"modPlateHolder\":-1,\"modTransmission\":-1,\"modFender\":-1,\"modTank\":-1,\"modFrame\":-1,\"modDashboard\":-1,\"pearlescentColor\":4,\"modTrimB\":-1,\"modDial\":-1,\"modShifterLeavers\":-1,\"modGrille\":-1,\"modStruts\":-1,\"modTurbo\":false,\"modSeats\":-1,\"modHorns\":-1,\"modTrunk\":-1,\"modXenon\":false}', 'QK6284'),
(108, 'TUB69080', 57854, '', '2XL174JB', 'flashgt', '{\"wheels\":0,\"modAirFilter\":-1,\"color2\":111,\"modTank\":-1,\"modArmor\":-1,\"modHorns\":-1,\"modEngineBlock\":-1,\"modFrame\":-1,\"modFrontBumper\":-1,\"dirtLevel\":5.30649185180664,\"modFrontWheels\":-1,\"modSmokeEnabled\":false,\"modEngine\":-1,\"modGrille\":-1,\"modXenon\":false,\"modDial\":-1,\"modSpoilers\":-1,\"modHood\":-1,\"windowTint\":-1,\"modWindows\":-1,\"modSuspension\":-1,\"wheelColor\":0,\"modSteeringWheel\":-1,\"modTransmission\":-1,\"modSeats\":-1,\"modShifterLeavers\":-1,\"modVanityPlate\":-1,\"modRightFender\":-1,\"modDashboard\":-1,\"neonColor\":[255,0,255],\"modTrunk\":-1,\"modOrnaments\":-1,\"modRearBumper\":-1,\"modTrimB\":-1,\"modTrimA\":-1,\"modExhaust\":-1,\"modStruts\":-1,\"modFender\":-1,\"pearlescentColor\":111,\"modLivery\":-1,\"modSideSkirt\":-1,\"modAerials\":-1,\"neonEnabled\":[false,false,false,false],\"modTurbo\":false,\"modArchCover\":-1,\"modAPlate\":-1,\"color1\":111,\"modHydrolic\":-1,\"modSpeakers\":-1,\"tyreSmokeColor\":[255,255,255],\"modRoof\":-1,\"plateIndex\":0,\"modPlateHolder\":-1,\"modDoorSpeaker\":-1,\"modBrakes\":-1,\"modBackWheels\":-1}', 'QK8696');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `outdoor_plants`
--

CREATE TABLE `outdoor_plants` (
  `id` int(11) NOT NULL,
  `properties` text NOT NULL,
  `plantid` int(11) NOT NULL,
  `citizenid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Gegevens worden geëxporteerd voor tabel `outdoor_plants`
--

INSERT INTO `outdoor_plants` (`id`, `properties`, `plantid`, `citizenid`) VALUES
(3, '{\"id\":864474,\"type\":\"white-widow\",\"x\":-1613.7506103515626,\"stage\":3,\"grace\":false,\"thirst\":0,\"planter\":\"LTA40680\",\"hunger\":0,\"z\":13.01732349395752,\"beingHarvested\":false,\"quality\":23.6,\"y\":-1007.2039184570313,\"growth\":100}', 864474, NULL),
(4, '{\"id\":464165,\"type\":\"white-widow\",\"x\":-1618.5379638671876,\"stage\":3,\"grace\":false,\"thirst\":0,\"planter\":\"LTA40680\",\"hunger\":0,\"z\":13.06889915466308,\"beingHarvested\":false,\"quality\":24.1,\"y\":-1008.8746948242188,\"growth\":100}', 464165, NULL),
(9, '{\"id\":781032,\"type\":\"white-widow\",\"hunger\":0,\"quality\":23.5,\"grace\":false,\"y\":-1937.1741943359376,\"x\":104.06348419189452,\"planter\":\"ZBS28874\",\"z\":20.8036994934082,\"beingHarvested\":false,\"stage\":3,\"thirst\":0,\"growth\":100}', 781032, NULL),
(10, '{\"id\":684299,\"type\":\"white-widow\",\"hunger\":0,\"quality\":24.2,\"grace\":false,\"y\":-1942.0701904296876,\"x\":99.3490982055664,\"planter\":\"ZBS28874\",\"z\":20.8036994934082,\"beingHarvested\":false,\"stage\":3,\"thirst\":0,\"growth\":100}', 684299, NULL),
(11, '{\"id\":190565,\"type\":\"white-widow\",\"hunger\":0,\"quality\":23.6,\"grace\":false,\"y\":-1942.2364501953128,\"x\":105.24312591552736,\"planter\":\"ZBS28874\",\"z\":20.80372428894043,\"beingHarvested\":false,\"stage\":3,\"thirst\":0,\"growth\":100}', 190565, NULL),
(12, '{\"id\":430067,\"type\":\"white-widow\",\"thirst\":0,\"quality\":23.9,\"grace\":false,\"y\":-1937.7025146484376,\"x\":99.12991333007813,\"hunger\":0,\"z\":20.80366897583007,\"beingHarvested\":false,\"stage\":3,\"planter\":\"ZBS28874\",\"growth\":100}', 430067, NULL);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_debt`
--

CREATE TABLE `phone_debt` (
  `id` int(10) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL,
  `reason` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_gallery`
--

CREATE TABLE `phone_gallery` (
  `ID` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `image` varchar(255) NOT NULL,
  `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_invoices`
--

CREATE TABLE `phone_invoices` (
  `id` int(10) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `society` tinytext DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_messages`
--

CREATE TABLE `phone_messages` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_note`
--

CREATE TABLE `phone_note` (
  `id` int(10) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `title` text DEFAULT NULL,
  `text` text DEFAULT NULL,
  `lastupdate` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `phone_tweets`
--

CREATE TABLE `phone_tweets` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `firstName` varchar(25) DEFAULT NULL,
  `lastName` varchar(25) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `url` text DEFAULT NULL,
  `picture` text DEFAULT './img/default.png',
  `tweetId` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT 'None',
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `money` text DEFAULT NULL,
  `charinfo` text DEFAULT NULL,
  `job` tinytext DEFAULT NULL,
  `gang` tinytext DEFAULT NULL,
  `position` text DEFAULT NULL,
  `inventory` varchar(64000) DEFAULT '{}',
  `metadata` text DEFAULT NULL,
  `licenses` text DEFAULT NULL,
  `skills` text DEFAULT NULL,
  `addiction` varchar(50) DEFAULT NULL,
  `tattoos` text DEFAULT NULL,
  `walkingstyle` varchar(50) DEFAULT '{}',
  `last_updated` timestamp NULL DEFAULT current_timestamp(),
  `hudsettings` text DEFAULT NULL,
  `web_pass` varchar(55) NOT NULL,
  `last_login` varchar(80) NOT NULL,
  `lastsearch` int(11) NOT NULL,
  `playtime` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `players_pd_presets`
--

CREATE TABLE `players_pd_presets` (
  `id` int(11) NOT NULL,
  `name` longtext DEFAULT NULL,
  `ped` longtext DEFAULT NULL,
  `components` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_accounts`
--

CREATE TABLE `player_accounts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `bankid` varchar(50) DEFAULT NULL,
  `balance` int(20) DEFAULT 0,
  `authorized` varchar(500) DEFAULT NULL,
  `transactions` varchar(60000) DEFAULT '{}'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_appearance`
--

CREATE TABLE `player_appearance` (
  `citizenid` varchar(50) NOT NULL,
  `skin` longtext DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_business`
--

CREATE TABLE `player_business` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `logo` varchar(150) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `employees` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_contacts`
--

CREATE TABLE `player_contacts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `number` varchar(100) DEFAULT NULL,
  `iban` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_houses`
--

CREATE TABLE `player_houses` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT '[]',
  `house` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` int(11) DEFAULT NULL,
  `owned` varchar(50) DEFAULT 'true',
  `coords` text DEFAULT NULL,
  `hasgarage` varchar(50) DEFAULT 'false',
  `garage` varchar(200) DEFAULT '[]',
  `keyholders` text DEFAULT NULL,
  `decorations` longtext DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_house_plants`
--

CREATE TABLE `player_house_plants` (
  `id` int(11) NOT NULL,
  `houseid` varchar(50) DEFAULT '11111',
  `plants` varchar(65000) DEFAULT '[]'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_inventory-stash`
--

CREATE TABLE `player_inventory-stash` (
  `id` int(11) NOT NULL,
  `stash` varchar(50) NOT NULL,
  `items` longtext DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_inventory-vehicle`
--

CREATE TABLE `player_inventory-vehicle` (
  `id` int(11) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `trunkitems` longtext DEFAULT NULL,
  `gloveboxitems` longtext DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_mails`
--

CREATE TABLE `player_mails` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` longtext DEFAULT NULL,
  `mailid` int(11) DEFAULT NULL,
  `read` varchar(50) DEFAULT NULL,
  `button` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_messages`
--

CREATE TABLE `player_messages` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL DEFAULT '0',
  `number` varchar(50) DEFAULT NULL,
  `messages` longtext DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_outfits`
--

CREATE TABLE `player_outfits` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `ped` longtext NOT NULL,
  `components` longtext NOT NULL,
  `props` longtext NOT NULL,
  `outfitname` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_phone_contacts`
--

CREATE TABLE `player_phone_contacts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `contactname` varchar(100) DEFAULT NULL,
  `contactnumber` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_skins`
--

CREATE TABLE `player_skins` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) NOT NULL DEFAULT '',
  `model` varchar(50) NOT NULL DEFAULT '0',
  `skin` text NOT NULL,
  `active` tinyint(2) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `player_vehicles`
--

CREATE TABLE `player_vehicles` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT 'Blokken Parking',
  `state` varchar(50) DEFAULT 'in',
  `parts` varchar(300) DEFAULT '{"Transmissie":{"Class":"B","Procent":100},"Brandstof Injectoren":{"Class":"B","Procent":100},"Aandrijfas":{"Class":"B","Procent":100},"Koppeling":{"Class":"B","Procent":100},"Motor":{"Class":"B","Procent":100},"Remmen":{"Class":"B","Procent":100}}',
  `mods` text DEFAULT NULL,
  `metadata` varchar(1000) DEFAULT '{"Engine":1000.0,"Body":1000.0,"Fuel":100.0}',
  `selling` varchar(50) NOT NULL DEFAULT 'false',
  `sellprice` int(11) NOT NULL DEFAULT 0,
  `depotprice` int(11) DEFAULT 100,
  `impoundreason` varchar(100) DEFAULT 'Geen Reden.',
  `info` mediumtext NOT NULL DEFAULT '{"note":"","apk":"1","wok":"0","warrant":"0"}'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `renzu_stancer`
--

CREATE TABLE `renzu_stancer` (
  `plate` varchar(64) NOT NULL DEFAULT '',
  `setting` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `server_bans`
--

CREATE TABLE `server_bans` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `reason` varchar(250) DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(50) DEFAULT 'Server PC'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `server_cardealer`
--

CREATE TABLE `server_cardealer` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `server_dealers`
--

CREATE TABLE `server_dealers` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `server_extra`
--

CREATE TABLE `server_extra` (
  `id` int(11) NOT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(75) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `permission` varchar(50) DEFAULT 'user',
  `priority` int(11) DEFAULT 3
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `server_lapraces`
--

CREATE TABLE `server_lapraces` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `traphouses`
--

CREATE TABLE `traphouses` (
  `id` int(50) NOT NULL,
  `coords` text NOT NULL,
  `keyholders` text NOT NULL,
  `pincode` int(4) NOT NULL,
  `inventory` text NOT NULL,
  `opened` tinyint(1) NOT NULL,
  `takingover` tinyint(1) NOT NULL,
  `money` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `bossmenu`
--
ALTER TABLE `bossmenu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `job_name` (`job_name`);

--
-- Indexen voor tabel `characters_invoices`
--
ALTER TABLE `characters_invoices`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `daily_free`
--
ALTER TABLE `daily_free`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `gangmenu`
--
ALTER TABLE `gangmenu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `job_name` (`job_name`);

--
-- Indexen voor tabel `occasion_vehicles`
--
ALTER TABLE `occasion_vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `occasionId` (`occasionId`);

--
-- Indexen voor tabel `outdoor_plants`
--
ALTER TABLE `outdoor_plants`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `phone_debt`
--
ALTER TABLE `phone_debt`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexen voor tabel `phone_gallery`
--
ALTER TABLE `phone_gallery`
  ADD PRIMARY KEY (`ID`);

--
-- Indexen voor tabel `phone_invoices`
--
ALTER TABLE `phone_invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexen voor tabel `phone_messages`
--
ALTER TABLE `phone_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `number` (`number`);

--
-- Indexen voor tabel `phone_note`
--
ALTER TABLE `phone_note`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexen voor tabel `phone_tweets`
--
ALTER TABLE `phone_tweets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexen voor tabel `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexen voor tabel `players_pd_presets`
--
ALTER TABLE `players_pd_presets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_UNIQUE` (`id`);

--
-- Indexen voor tabel `player_accounts`
--
ALTER TABLE `player_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_appearance`
--
ALTER TABLE `player_appearance`
  ADD PRIMARY KEY (`citizenid`),
  ADD UNIQUE KEY `id_UNIQUE` (`citizenid`);

--
-- Indexen voor tabel `player_business`
--
ALTER TABLE `player_business`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_contacts`
--
ALTER TABLE `player_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_houses`
--
ALTER TABLE `player_houses`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_house_plants`
--
ALTER TABLE `player_house_plants`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_inventory-stash`
--
ALTER TABLE `player_inventory-stash`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_inventory-vehicle`
--
ALTER TABLE `player_inventory-vehicle`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_mails`
--
ALTER TABLE `player_mails`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_messages`
--
ALTER TABLE `player_messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_outfits`
--
ALTER TABLE `player_outfits`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_phone_contacts`
--
ALTER TABLE `player_phone_contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_skins`
--
ALTER TABLE `player_skins`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `player_vehicles`
--
ALTER TABLE `player_vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `renzu_stancer`
--
ALTER TABLE `renzu_stancer`
  ADD PRIMARY KEY (`plate`);

--
-- Indexen voor tabel `server_bans`
--
ALTER TABLE `server_bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `server_cardealer`
--
ALTER TABLE `server_cardealer`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `server_dealers`
--
ALTER TABLE `server_dealers`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `server_extra`
--
ALTER TABLE `server_extra`
  ADD PRIMARY KEY (`id`);

--
-- Indexen voor tabel `server_lapraces`
--
ALTER TABLE `server_lapraces`
  ADD PRIMARY KEY (`id`),
  ADD KEY `raceid` (`raceid`);

--
-- Indexen voor tabel `traphouses`
--
ALTER TABLE `traphouses`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `bossmenu`
--
ALTER TABLE `bossmenu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT voor een tabel `characters_invoices`
--
ALTER TABLE `characters_invoices`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT voor een tabel `daily_free`
--
ALTER TABLE `daily_free`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `gangmenu`
--
ALTER TABLE `gangmenu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT voor een tabel `occasion_vehicles`
--
ALTER TABLE `occasion_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT voor een tabel `outdoor_plants`
--
ALTER TABLE `outdoor_plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT voor een tabel `phone_debt`
--
ALTER TABLE `phone_debt`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT voor een tabel `phone_gallery`
--
ALTER TABLE `phone_gallery`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT voor een tabel `phone_invoices`
--
ALTER TABLE `phone_invoices`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `phone_messages`
--
ALTER TABLE `phone_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `phone_note`
--
ALTER TABLE `phone_note`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT voor een tabel `phone_tweets`
--
ALTER TABLE `phone_tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT voor een tabel `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4140;

--
-- AUTO_INCREMENT voor een tabel `player_accounts`
--
ALTER TABLE `player_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=337;

--
-- AUTO_INCREMENT voor een tabel `player_business`
--
ALTER TABLE `player_business`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT voor een tabel `player_contacts`
--
ALTER TABLE `player_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT voor een tabel `player_houses`
--
ALTER TABLE `player_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1009;

--
-- AUTO_INCREMENT voor een tabel `player_house_plants`
--
ALTER TABLE `player_house_plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT voor een tabel `player_inventory-stash`
--
ALTER TABLE `player_inventory-stash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5115;

--
-- AUTO_INCREMENT voor een tabel `player_inventory-vehicle`
--
ALTER TABLE `player_inventory-vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5399;

--
-- AUTO_INCREMENT voor een tabel `player_mails`
--
ALTER TABLE `player_mails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=240;

--
-- AUTO_INCREMENT voor een tabel `player_messages`
--
ALTER TABLE `player_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT voor een tabel `player_outfits`
--
ALTER TABLE `player_outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4755;

--
-- AUTO_INCREMENT voor een tabel `player_phone_contacts`
--
ALTER TABLE `player_phone_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT voor een tabel `player_skins`
--
ALTER TABLE `player_skins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21996;

--
-- AUTO_INCREMENT voor een tabel `player_vehicles`
--
ALTER TABLE `player_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4864;

--
-- AUTO_INCREMENT voor een tabel `server_bans`
--
ALTER TABLE `server_bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=346;

--
-- AUTO_INCREMENT voor een tabel `server_cardealer`
--
ALTER TABLE `server_cardealer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- AUTO_INCREMENT voor een tabel `server_dealers`
--
ALTER TABLE `server_dealers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT voor een tabel `server_extra`
--
ALTER TABLE `server_extra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;

--
-- AUTO_INCREMENT voor een tabel `server_lapraces`
--
ALTER TABLE `server_lapraces`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT voor een tabel `traphouses`
--
ALTER TABLE `traphouses`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
