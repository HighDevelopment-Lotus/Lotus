-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 15 jan 2022 om 00:22
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
-- Database: `fivem-framework`
--

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
  `hudsettings` text DEFAULT NULL
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
  `button` int(11) DEFAULT NULL
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
  `skin` text NOT NULL
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
  `impoundreason` varchar(100) DEFAULT 'Geen Reden.'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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

--
-- Indexen voor geëxporteerde tabellen
--

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
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4016;

--
-- AUTO_INCREMENT voor een tabel `player_accounts`
--
ALTER TABLE `player_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=333;

--
-- AUTO_INCREMENT voor een tabel `player_business`
--
ALTER TABLE `player_business`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT voor een tabel `player_contacts`
--
ALTER TABLE `player_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `player_houses`
--
ALTER TABLE `player_houses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=972;

--
-- AUTO_INCREMENT voor een tabel `player_house_plants`
--
ALTER TABLE `player_house_plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT voor een tabel `player_inventory-stash`
--
ALTER TABLE `player_inventory-stash`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5083;

--
-- AUTO_INCREMENT voor een tabel `player_inventory-vehicle`
--
ALTER TABLE `player_inventory-vehicle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5392;

--
-- AUTO_INCREMENT voor een tabel `player_mails`
--
ALTER TABLE `player_mails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `player_messages`
--
ALTER TABLE `player_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `player_outfits`
--
ALTER TABLE `player_outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4705;

--
-- AUTO_INCREMENT voor een tabel `player_phone_contacts`
--
ALTER TABLE `player_phone_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT voor een tabel `player_skins`
--
ALTER TABLE `player_skins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21412;

--
-- AUTO_INCREMENT voor een tabel `player_vehicles`
--
ALTER TABLE `player_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4791;

--
-- AUTO_INCREMENT voor een tabel `server_bans`
--
ALTER TABLE `server_bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=346;

--
-- AUTO_INCREMENT voor een tabel `server_cardealer`
--
ALTER TABLE `server_cardealer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT voor een tabel `server_extra`
--
ALTER TABLE `server_extra`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;

--
-- AUTO_INCREMENT voor een tabel `server_lapraces`
--
ALTER TABLE `server_lapraces`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
