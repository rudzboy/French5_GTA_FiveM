CREATE TABLE IF NOT EXISTS `user_boat` (
  `id` int(11) AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `boat_name` varchar(255) DEFAULT NULL,
  `boat_model` varchar(255) DEFAULT NULL,
  `boat_price` int(60) DEFAULT NULL,
  `boat_plate` varchar(255) DEFAULT NULL UNIQUE,
  `boat_state` varchar(255) DEFAULT NULL,
  `boat_colorprimary` varchar(255) DEFAULT NULL,
  `boat_colorsecondary` varchar(255) DEFAULT NULL,
  `boat_pearlescentcolor` varchar(255) DEFAULT NULL,
  `boat_wheelcolor` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
