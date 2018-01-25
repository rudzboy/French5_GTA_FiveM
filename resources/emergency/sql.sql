USE gta5_gamemode_essential;


CREATE TABLE IF NOT EXISTS `ems` (
	`identifier` VARCHAR(255) NOT NULL,
	`rank` VARCHAR(255) NOT NULL DEFAULT 'Recrue',
	PRIMARY KEY (`identifier`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

