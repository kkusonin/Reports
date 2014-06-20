DROP DATABASE IF EXISTS `tks`;
CREATE DATABASE `tks` DEFAULT CHARACTER SET utf8;
USE `tks`;

CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lead_id` int(9) unsigned NOT NULL DEFAULT '0',
  `phone_number` varchar(18) NOT NULL DEFAULT '',
  `user` varchar(20) NOT NULL DEFAULT '',
  `full_name` varchar(50) NOT NULL DEFAULT '',
  `uuid` char(32) NOT NULL DEFAULT '',
  `entry_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `uuid_crc` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_uuid_crc` (`uuid_crc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

CREATE TABLE `items` (
  `id` int(9) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` char(32) NOT NULL,
  `sid`  varchar(32) NOT NULL DEFAULT '',
  `wm` varchar(20) DEFAULT '',
  `date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status` char(3) NOT NULL DEFAULT '',
  `reason` varchar(64) NOT NULL DEFAULT '',
  `uuid_crc` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_uuid_crc` (`uuid_crc`),
  KEY `idx_timestamp` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8

DELIMITER $$
CREATE TRIGGER orders_crc_ins 
BEFORE INSERT ON orders 
FOR EACH ROW 
BEGIN
    SET NEW.uuid_crc = CRC32(NEW.uuid);
END;
$$
CREATE TRIGGER orders_crc_upd 
BEFORE UPDATE ON orders 
FOR EACH ROW 
BEGIN
    SET NEW.uuid_crc = CRC32(NEW.uuid);
END;
$$
CREATE TRIGGER items_crc_ins 
BEFORE INSERT ON items 
FOR EACH ROW 
BEGIN
    SET NEW.uuid_crc = CRC32(NEW.uuid);
END;
$$
CREATE TRIGGER items_crc_upd 
BEFORE UPDATE ON items 
FOR EACH ROW 
BEGIN
    SET NEW.uuid_crc = CRC32(NEW.uuid);
END;
$$
DELIMITER ;

GRANT SELECT, INSERT, UPDATE, DELETE ON tks.* TO 'tks'@'localhost' IDENTIFIED BY '12345';