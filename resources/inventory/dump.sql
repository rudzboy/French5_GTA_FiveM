# ************************************************************
# Database : gta5_gamemode_essential
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Affichage de la table items
# ------------------------------------------------------------

DROP TABLE IF EXISTS `items`;
--
-- Structure de la table `items`
--

CREATE TABLE `items` (
  `id` smallint(6) UNSIGNED NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `libelle` varchar(255) DEFAULT NULL,
  `legal` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `items`
--

INSERT INTO `items` (`id`, `identifier`, `libelle`, `legal`) VALUES
(1, 'water', 'Bouteille d\'eau', 1),
(2, 'hamburger', 'Hamburger', 1),
(3, 'sandwich', 'Sandwich', 1),
(4, 'weed', 'Weed', 0),
(5, 'shit', 'Barrette de shit', 0),
(6, 'opium', 'Opium', 0),
(7, 'heroin', 'Héroïne', 0),
(8, 'garbage', 'Déchets', 1),
(9, 'recycled_materials', 'Matériaux recyclés', 1),
(10, 'oil_raw', 'Pétrole brut', 1),
(11, 'oil_fuel', 'Pétrole raffiné', 1),
(12, 'wooden_board', 'Planche de bois', 1),
(13, 'fish', 'Poisson', 1),
(14, 'aggregate', 'Granulats', 1),
(15, 'concrete', 'Béton', 1),
(16, 'organ', 'Organe frais', 1),
(17, 'frozen_organ', 'Organe congelé', 1),
(18, 'helicopter_cargo', 'Cargaison Hélicoptère', 0),
(19, 'helicopter_receipt', 'Reçu de livraison Hélicoptère', 0),
(20, 'plane_cargo', 'Cargaison Avion', 0),
(21, 'plane_receipt', 'Reçu de livraison Avion', 0);

--
-- Index pour les tables exportées
--

--
-- Index pour la table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identifier` (`identifier`),
  ADD KEY `id` (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `items`
--
ALTER TABLE `items`
  MODIFY `id` smallint(6) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


# Affichage de la table user_inventory
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user_inventory`;

CREATE TABLE `user_inventory` (
  `user_id` varchar(127) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `item_id` smallint(6) unsigned NOT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`item_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `user_inventory_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;