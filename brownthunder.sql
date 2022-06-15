CREATE TABLE IF NOT EXISTS `scores` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `charid` INT(11) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `round` INT(11) NOT NULL,
  `kills` INT(11) NOT NULL,
  `mission` VARCHAR(50) NOT NULL,
  `vehicle` VARCHAR(50) NOT NULL,
  `time` INT(11) NOT NULL,
  `version` VARCHAR(10) NOT NULL,

  KEY `id` (`id`)
);
