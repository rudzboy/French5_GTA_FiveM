CREATE TABLE IF NOT EXISTS `safes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NULL,
  `solde` varchar(10) NOT NULL DEFAULT '0',
  `lasttransfert` varchar(10) NULL,
  `safe_job` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `safes` (`id`, `identifier`, `solde`, `lasttransfert`, `safe_job`) VALUES
(1, NULL, '0', NULL, '2');

