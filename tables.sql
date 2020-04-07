-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`users` ;

CREATE TABLE IF NOT EXISTS `mydb`.`users` (
                                              `id` INT NOT NULL AUTO_INCREMENT,
                                              `first_name` VARCHAR(128) NOT NULL,
                                              `last_name` VARCHAR(128) NOT NULL,
                                              `email` VARCHAR(255) NOT NULL,
                                              `phone` VARCHAR(64) NOT NULL,
                                              `date_joined` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                              PRIMARY KEY (`id`),
                                              UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`locations` ;

CREATE TABLE IF NOT EXISTS `mydb`.`locations` (
                                                  `id` INT NOT NULL AUTO_INCREMENT,
                                                  `name` VARCHAR(64) NOT NULL,
                                                  `address` VARCHAR(256) NULL,
                                                  `address2` VARCHAR(256) NULL,
                                                  `city` VARCHAR(64) NULL,
                                                  `state` VARCHAR(2) NULL,
                                                  `zip` VARCHAR(15) NULL,
                                                  `latitude` DECIMAL(10,5) NULL,
                                                  `longitude` DECIMAL(10,5) NULL,
                                                  `instructions` VARCHAR(1024) NULL,
                                                  `user_id` INT NOT NULL,
                                                  PRIMARY KEY (`id`),
                                                  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
                                                  CONSTRAINT `locations.fk_user_id`
                                                      FOREIGN KEY (`user_id`)
                                                          REFERENCES `mydb`.`users` (`id`)
                                                          ON DELETE NO ACTION
                                                          ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`restaurants`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`restaurants` ;

CREATE TABLE IF NOT EXISTS `mydb`.`restaurants` (
                                                    `id` INT NOT NULL AUTO_INCREMENT,
                                                    `name` VARCHAR(64) NOT NULL,
                                                    `website` VARCHAR(512) NOT NULL,
                                                    `fee` DECIMAL(5,2) NOT NULL DEFAULT 0,
                                                    `open_time` DATETIME NOT NULL,
                                                    `close_time` DATETIME NOT NULL,
                                                    `days_open` BIT(7) NOT NULL DEFAULT b'1111111',
                                                    `approved` BIT(1) NOT NULL DEFAULT 0,
                                                    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`drivers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`drivers` ;

CREATE TABLE IF NOT EXISTS `mydb`.`drivers` (
                                                `id` INT NOT NULL,
                                                `license_no` INT NOT NULL,
                                                `approved` BIT(1) NOT NULL DEFAULT 0,
                                                `is_working` BIT(1) NOT NULL,
                                                PRIMARY KEY (`id`, `license_no`),
                                                UNIQUE INDEX `license_no_UNIQUE` (`license_no` ASC) VISIBLE,
                                                CONSTRAINT `drivers.fk_user_id`
                                                    FOREIGN KEY (`id`)
                                                        REFERENCES `mydb`.`users` (`id`)
                                                        ON DELETE NO ACTION
                                                        ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`orders` ;

CREATE TABLE IF NOT EXISTS `mydb`.`orders` (
                                               `id` INT NOT NULL AUTO_INCREMENT,
                                               `user_id` INT NOT NULL,
                                               `driver_id` INT NOT NULL,
                                               `restaurant_id` INT NOT NULL,
                                               `location_id` INT NOT NULL,
                                               `order_text` VARCHAR(1024) NOT NULL,
                                               `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                               `price` DECIMAL(5,2) NOT NULL DEFAULT 0,
                                               PRIMARY KEY (`id`),
                                               INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
                                               INDEX `restaurant_id_idx` (`restaurant_id` ASC) VISIBLE,
                                               INDEX `driver_id_idx` (`driver_id` ASC) VISIBLE,
                                               INDEX `location_id_idx` (`location_id` ASC) VISIBLE,
                                               CONSTRAINT `orders.fk_user_id`
                                                   FOREIGN KEY (`user_id`)
                                                       REFERENCES `mydb`.`users` (`id`)
                                                       ON DELETE NO ACTION
                                                       ON UPDATE NO ACTION,
                                               CONSTRAINT `orders.fk_restaurant_id`
                                                   FOREIGN KEY (`restaurant_id`)
                                                       REFERENCES `mydb`.`restaurants` (`id`)
                                                       ON DELETE NO ACTION
                                                       ON UPDATE NO ACTION,
                                               CONSTRAINT `orders.fk_driver_id`
                                                   FOREIGN KEY (`driver_id`)
                                                       REFERENCES `mydb`.`drivers` (`id`)
                                                       ON DELETE NO ACTION
                                                       ON UPDATE NO ACTION,
                                               CONSTRAINT `orders.fk_location_id`
                                                   FOREIGN KEY (`location_id`)
                                                       REFERENCES `mydb`.`locations` (`id`)
                                                       ON DELETE NO ACTION
                                                       ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ratings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`ratings` ;

CREATE TABLE IF NOT EXISTS `mydb`.`ratings` (
                                                `id` INT NOT NULL,
                                                `rating` INT NOT NULL,
                                                `comment` VARCHAR(1024) NULL,
                                                PRIMARY KEY (`id`),
                                                CONSTRAINT `order_id`
                                                    FOREIGN KEY (`id`)
                                                        REFERENCES `mydb`.`orders` (`id`)
                                                        ON DELETE NO ACTION
                                                        ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`vehicles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`vehicles` ;

CREATE TABLE IF NOT EXISTS `mydb`.`vehicles` (
                                                 `id` INT NOT NULL AUTO_INCREMENT,
                                                 `driver_id` INT NOT NULL,
                                                 `color` VARCHAR(64) NOT NULL,
                                                 `model` VARCHAR(64) NOT NULL,
                                                 `year` INT NOT NULL,
                                                 PRIMARY KEY (`id`),
                                                 INDEX `vehicles.fk_driver_id_idx` (`driver_id` ASC) VISIBLE,
                                                 CONSTRAINT `vehicles.fk_driver_id`
                                                     FOREIGN KEY (`driver_id`)
                                                         REFERENCES `mydb`.`drivers` (`id`)
                                                         ON DELETE NO ACTION
                                                         ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`cancelled_orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cancelled_orders` ;

CREATE TABLE IF NOT EXISTS `mydb`.`cancelled_orders` (
                                                         `id` INT NOT NULL,
                                                         `reason` VARCHAR(1024) NOT NULL,
                                                         `date` DATETIME NULL,
                                                         PRIMARY KEY (`id`),
                                                         CONSTRAINT `cancelled_orders.fk_order_id`
                                                             FOREIGN KEY (`id`)
                                                                 REFERENCES `mydb`.`orders` (`id`)
                                                                 ON DELETE NO ACTION
                                                                 ON UPDATE NO ACTION)
    ENGINE = InnoDB;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure QuickOrder
-- -----------------------------------------------------

USE `mydb`;
DROP procedure IF EXISTS `mydb`.`QuickOrder`;

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE QuickOrder (
    IN first_name VARCHAR(128),
    IN last_name VARCHAR(128),
    IN email VARCHAR(255),
    IN phone VARCHAR(10),
    IN address VARCHAR(256),
    IN address2 VARCHAR(256),
    IN city VARCHAR(64),
    IN zip INT,
    IN state VARCHAR(2),
    IN restaurant_id INT,
    IN order_text VARCHAR(1024)
)
BEGIN
    INSERT INTO users (first_name, last_name, email, phone) VALUES (first_name, last_name, email, phone);
    SET @userid = LAST_INSERT_ID();

    INSERT INTO locations (address, address2, city, state, zip, user_id) VALUES (address, address2, city, state, zip, userid);
    SET @locationid = LAST_INSERT_ID();

    SET @driverid = (SELECT id FROM drivers WHERE is_working  = 1 LIMIT 1);

    INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text) VALUES (@userid, @driverid, restaurant_id, @locationid, order_text);
    SET @orderid = LAST_INSERT_ID();

    UPDATE drivers SET is_working = 1 WHERE id = @driverid;

END$$

DELIMITER ;
USE `mydb`;

DELIMITER $$

USE `mydb`$$
DROP TRIGGER IF EXISTS `mydb`.`orders_AFTER_DELETE` $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`orders_AFTER_DELETE` AFTER DELETE ON `orders` FOR EACH ROW
BEGIN
    INSERT INTO cancelled_orders(cancelled_orders.id) VALUES (orders.id);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
