-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.28-log - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL version:             7.0.0.4053
-- Date/time:                    2013-02-08 23:58:43
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping database structure for chat_p2p
CREATE DATABASE IF NOT EXISTS `chat_p2p` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `chat_p2p`;


-- Dumping structure for table chat_p2p.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `timestamp` int(10) DEFAULT NULL,
  `key_broadcaster` text,
  `key_receiver` text,
  `ip` varchar(50) NOT NULL DEFAULT '',
  `blacklist` text,
  PRIMARY KEY (`ip`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- Dumping data for table chat_p2p.users: ~3 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`id`, `timestamp`, `key_broadcaster`, `key_receiver`, `ip`, `blacklist`) VALUES
	(12, 1360353334, 'c856252b2805095acc14c5ef8d7209bc', 'free', '127.0.0.1', NULL),
	(11, 1356532940, '123', 'free', '127.0.0.3', NULL),
	(13, 1356532940, '90f2284a50fbfdaf233a9ca9bcf3e0eb0', 'free', '127.1.2.2', NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
