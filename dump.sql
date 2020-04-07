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



-- DELETING ALL DATA
SET SQL_SAFE_UPDATES = 0;
DELETE FROM vehicles;
DELETE FROM drivers;
DELETE FROM users;



-- GENERATING USERS
ALTER TABLE users AUTO_INCREMENT = 1;
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Lizeth', 'Will', 'Jonathon_Berge68@yahoo.com', '502.595.0757 x20052');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Jerald', 'King', 'Pete58@yahoo.com', '136-910-1413');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Lenora', 'Hills', 'Barbara74@hotmail.com', '(782) 494-5344');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Isabelle', 'Kris', 'Hettie4@yahoo.com', '(253) 356-4379');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Walker', 'Thompson', 'Brionna.Kozey12@yahoo.com', '549-144-9347 x476');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Timothy', 'Heathcote', 'Dora37@gmail.com', '768.237.3475 x171');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Zechariah', 'Muller', 'Vicky.Hintz93@hotmail.com', '(168) 903-4870 x3368');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Candido', 'Sanford', 'Harmony86@gmail.com', '1-320-170-0825');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Bennett', 'Lakin', 'Arjun68@gmail.com', '354-842-7903');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Luella', 'Barton', 'Camylle.Cruickshank16@gmail.com', '(012) 730-5643 x921');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Berneice', 'Nader', 'Webster_Gulgowski42@gmail.com', '203-904-0889 x59421');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Irwin', 'Feil', 'Abdullah_Borer70@yahoo.com', '(995) 405-3143 x50367');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Eulalia', 'Medhurst', 'Abdul.Harber@gmail.com', '221.273.4133 x069');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Matilda', 'Walsh', 'Kiera50@yahoo.com', '524-932-1704');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Veda', 'Fay', 'Sean29@hotmail.com', '(426) 496-5349 x7122');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Edwardo', 'Prohaska', 'Kiana.Terry@gmail.com', '(449) 914-1410');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Travon', 'Ebert', 'Noble_OKeefe66@yahoo.com', '488-864-4012');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Mellie', 'Upton', 'Weldon77@gmail.com', '671-756-9615');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Travon', 'Parker', 'Alberto.Daugherty91@hotmail.com', '763-436-9342');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Joelle', 'Heller', 'Mike_Nitzsche@hotmail.com', '1-150-143-8483 x1508');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Verna', 'Herman', 'Elmo72@yahoo.com', '1-030-231-1781 x0678');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Gail', 'McClure', 'Eudora53@gmail.com', '(240) 388-2950');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Ford', 'Friesen', 'Charles84@yahoo.com', '(626) 476-6260 x8715');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Nellie', 'Fisher', 'Orval_Kemmer64@yahoo.com', '921-920-1383 x183');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Lavinia', 'Rogahn', 'Bernita78@gmail.com', '1-574-698-0780 x7255');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Enos', 'Ortiz', 'Hulda_Wuckert63@hotmail.com', '167.151.5555 x3090');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Hope', 'Balistreri', 'German.Simonis@yahoo.com', '(965) 673-5650 x9560');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Halle', 'Treutel', 'Cristobal_Spinka19@hotmail.com', '863.691.6749 x03944');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Brian', 'Quigley', 'Kailee_Harber@gmail.com', '547.051.1575 x6047');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Dangelo', 'Stoltenberg', 'Lila53@hotmail.com', '(187) 102-2277 x3604');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Wyman', 'Mante', 'Tara7@yahoo.com', '(472) 994-1813 x5317');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Elisabeth', 'OConnell', 'Zoie_Rohan72@yahoo.com', '1-700-509-6898');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Alan', 'Wolff', 'Orrin33@hotmail.com', '034-868-6036');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Nedra', 'Schneider', 'Natasha.Hettinger33@yahoo.com', '(662) 583-9458');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Evie', 'Maggio', 'Donnie.Schaden@yahoo.com', '454.171.5076 x407');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Rebecca', 'Kuhlman', 'Cary.Will@gmail.com', '1-994-865-4966');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Lulu', 'Schroeder', 'Melissa_Osinski@hotmail.com', '175.916.7030');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Gabriella', 'Kling', 'Tatyana.Becker@yahoo.com', '608.313.6439 x401');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Eleazar', 'Keebler', 'Carlee.Kirlin@yahoo.com', '1-698-733-6674 x665');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Sanford', 'Bruen', 'Audie_Weimann12@yahoo.com', '1-883-355-8161 x05170');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Santina', 'Miller', 'Lamont_Lind@yahoo.com', '1-877-388-3914');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Ebony', 'Conroy', 'Albert.Oberbrunner1@hotmail.com', '(928) 569-3671 x53382');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Saige', 'Haley', 'Rosalinda.Walsh@yahoo.com', '(240) 188-1440 x461');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Terrance', 'Kreiger', 'Shea_Breitenberg88@gmail.com', '860-924-8352');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Jabari', 'Upton', 'Brock_Bogisich73@gmail.com', '964-264-7119 x96691');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Evie', 'Runolfsdottir', 'Joanne.Hilll22@gmail.com', '411.969.9783 x1781');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Michale', 'Streich', 'Sandrine.Stanton10@yahoo.com', '1-499-067-3678 x11921');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Mozelle', 'Ernser', 'Bryce.Bartell@yahoo.com', '241-820-7812');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Lora', 'Bogisich', 'Anderson74@hotmail.com', '1-105-504-0616');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Ariane', 'Murphy', 'Burnice_Gutkowski@gmail.com', '1-601-703-4867 x6336');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Connie', 'Sanford', 'Kariane_Erdman@gmail.com', '(392) 974-8573');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Tad', 'Christiansen', 'Joel_Purdy@yahoo.com', '732.620.2903 x378');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Elian', 'MacGyver', 'Kayla.Blick@gmail.com', '1-589-134-6423 x514');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Ashly', 'Schaden', 'Margaret87@hotmail.com', '1-748-159-9633 x3986');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Aron', 'OConner', 'Conor_Haley63@gmail.com', '(248) 692-6673 x22707');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Darrell', 'Schiller', 'Jana73@yahoo.com', '861.264.5179 x20451');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Polly', 'Aufderhar', 'Agustina.Kautzer12@yahoo.com', '728.102.9563 x514');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Toy', 'Kilback', 'Angelo_Renner94@hotmail.com', '1-002-550-2819 x95911');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Estell', 'Weimann', 'Margarita_Cormier@yahoo.com', '1-732-473-5043 x65164');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Brenda', 'Stroman', 'Will_Walker@gmail.com', '025.581.0205 x886');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Sean', 'Marks', 'Gaston.Altenwerth@yahoo.com', '(207) 489-1020');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Frederick', 'Luettgen', 'Anderson.Trantow55@hotmail.com', '515-939-8436 x06267');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Sister', 'Feest', 'Keagan.Boyer2@yahoo.com', '856-588-1988 x296');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Gwendolyn', 'Murazik', 'Dewitt.Berge@hotmail.com', '721.032.5841');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Misael', 'Senger', 'Kiana_Beatty@yahoo.com', '1-020-961-5999');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Angus', 'Brakus', 'Anne30@gmail.com', '576-284-8219 x01099');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Rose', 'Hegmann', 'Winnifred.Paucek32@gmail.com', '(252) 548-5517 x6278');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Cristobal', 'Stoltenberg', 'Devante.Kerluke65@gmail.com', '1-219-934-0684 x971');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Audrey', 'Senger', 'Lindsey40@hotmail.com', '599.797.4570');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Alvera', 'Senger', 'Rosina.Berge@hotmail.com', '(631) 617-3883 x656');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Salvador', 'Kuhic', 'Reva_Fay31@yahoo.com', '238.344.0749');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Madie', 'Stiedemann', 'Delta_Aufderhar42@yahoo.com', '691.562.6847 x61040');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Mona', 'Berge', 'Norris.Ledner41@gmail.com', '1-020-831-2122');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Reva', 'Weissnat', 'Elissa87@gmail.com', '089.770.3591 x320');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Salma', 'Hansen', 'Leif47@yahoo.com', '900.247.5109 x3029');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Mitchell', 'Nolan', 'Wilford63@yahoo.com', '862-010-6185');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Reginald', 'Huel', 'Kennith_Kautzer79@yahoo.com', '(000) 138-2910');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Catalina', 'Dicki', 'Iva.Rowe81@gmail.com', '1-241-632-3633 x4805');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Jonas', 'Rempel', 'Dallas_Von67@yahoo.com', '(058) 664-8875 x5891');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Wilburn', 'Connelly', 'Chloe_Wunsch@hotmail.com', '(695) 319-3145');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Jo', 'Crist', 'Friedrich_Labadie48@gmail.com', '164-429-6045 x7450');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Forrest', 'Wunsch', 'Arielle_Raynor97@gmail.com', '(830) 368-3976');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Monty', 'Thiel', 'Major96@hotmail.com', '514.753.0139 x82090');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Leone', 'Hahn', 'Imogene88@gmail.com', '(617) 496-0610 x779');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Khalid', 'Denesik', 'Robb_Hegmann66@hotmail.com', '962-226-0211 x6077');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Kip', 'Wunsch', 'Antonietta_Goyette46@yahoo.com', '(701) 756-4696 x6335');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Eldora', 'Schultz', 'Zackery80@yahoo.com', '(156) 868-1443 x689');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Avis', 'Botsford', 'Jerome_Prosacco@yahoo.com', '664.446.9435 x908');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Kaden', 'Stracke', 'Orlando_Greenfelder78@yahoo.com', '229.034.9610 x8035');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Aniyah', 'Ritchie', 'Ilene.Hane@hotmail.com', '073-616-4897 x64256');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Zola', 'Lehner', 'Wendy.Mills@gmail.com', '705-438-6032');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Elisabeth', 'Lemke', 'Torrance19@gmail.com', '1-693-487-5152');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Enoch', 'Rodriguez', 'Everette_Ernser@hotmail.com', '1-977-850-9390 x03948');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Christiana', 'Wiegand', 'Terrance.Tremblay7@yahoo.com', '1-444-717-0210');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Augustine', 'Lind', 'Tad67@gmail.com', '(001) 701-5160');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Ebony', 'Littel', 'Herman2@yahoo.com', '369.867.0336 x7446');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Fanny', 'Terry', 'Josie.Sipes@hotmail.com', '(823) 806-8613 x6138');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Trevion', 'Bartell', 'Thaddeus_Jerde46@yahoo.com', '(247) 602-2854');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Izaiah', 'Lowe', 'Santiago_Mraz79@hotmail.com', '(812) 522-5932 x322');
INSERT INTO users (first_name, last_name, email, phone) VALUES ('Aliza', 'Reilly', 'Gregg_Weimann@hotmail.com', '982.476.8799');



-- GENERATING DRIVERS
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (24, '67993', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (34, '187', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (14, '4153', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (24, '46049', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (94, '73903', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (58, '49038', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (46, '20536', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (77, '14106', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (64, '18812', 1, 1);
INSERT INTO drivers (id, license_no, approved, is_working) VALUES (38, '71', 1, 1);



-- GENERATING VEHICLES
INSERT INTO vehicles (driver_id, color, model, year) VALUES (24, 'turquoise', 'ku7gy8ma5h', '1995');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (34, 'plum', 'vz2jgchk91', '1996');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (14, 'salmon', '1ofv00trjt', '1958');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (24, 'ivory', 's932ghh0rx', '2013');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (94, 'purple', 'o0icxb0cc2', '1975');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (58, 'lavender', '0su6a2qaml', '1951');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (46, 'maroon', 'eewu9gasx6', '2005');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (77, 'mint green', '5adebhsw6z', '1980');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (64, 'lavender', 'sm6hfifcww', '1973');
INSERT INTO vehicles (driver_id, color, model, year) VALUES (38, 'olive', '1cgnuwj4ps', '1956');



-- GENERATING LOCATIONS
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gorczany LLC', '6215 Edwardo Dale','Suite 328','Port Asia','NY','72700',-78.6176,33.1509,'quisquam vel ut cupiditate aut sint sit enim sed qui','1');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Veum - Gorczany', '56583 Anabel Ports','Suite 229','Bernhardfurt','NJ','71044-4246',73.1069,-122.3022,'ipsam labore quia fugiat aut itaque totam incidunt ipsum autem','1');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Corkery, Smith and Ward', '950 Cronin Well','Suite 261','Yostfort','NH','23826-2490',42.6113,134.6740,'qui beatae officia adipisci sed id doloribus dolor est aut','2');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Mann Group', '755 Predovic Oval','Apt. 940','South Freida','CA','31301-1162',-60.9639,-2.1592,'eaque atque quis voluptatem sed enim accusamus eum dolorem adipisci','2');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hettinger - Waters', '79161 Emilio Springs','Apt. 802','Port Joe','MO','76498',81.3277,93.2313,'molestiae modi quod eos dolor tenetur corrupti pariatur omnis optio','3');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kreiger LLC', '65958 Hettinger Falls','Apt. 251','West Kirstentown','IN','24043',9.6748,134.2274,'et et consequatur consectetur omnis voluptas quo nesciunt ipsa ut','3');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Walter - Swift', '9811 Jerde Lane','Apt. 239','North Christina','WA','68541',-10.2381,-29.4042,'velit aut placeat iure aut quia tenetur vel eum ullam','4');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Walsh, Pfannerstill and Hessel', '29594 Runolfsdottir Corners','Apt. 336','South Austin','ND','95028-2726',30.3107,-76.2947,'quas quas non non voluptatem praesentium aspernatur at nesciunt sit','4');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ledner, Runte and Johnston', '95669 Kling Parks','Suite 462','North Ameliahaven','RI','91640',-67.9668,-138.8319,'ratione nam qui ratione nulla fugit molestiae corporis eum et','5');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kshlerin and Sons', '956 Lebsack Stravenue','Apt. 186','New Thalia','MI','53015',50.0952,169.1084,'quisquam esse veritatis rerum voluptates qui sunt et sit facilis','5');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hamill, Schaden and McGlynn', '67768 Nils Field','Suite 897','South Kaydenburgh','NH','85377-8374',-49.7302,22.7353,'suscipit neque cumque ut maxime molestias et et minus numquam','6');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wiza - Osinski', '6462 Metz Meadows','Apt. 753','Fadeltown','FL','45911',36.8169,146.1154,'est est numquam eaque ducimus ut fugit aut sunt et','6');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lind Group', '99343 Eichmann Viaduct','Apt. 091','Filomenaville','MD','34307',-62.5073,-178.2193,'eius distinctio libero vel adipisci voluptatem repellat dolor sed tempora','7');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Corkery - Collins', '5349 Sonia Park','Apt. 654','Port Caden','MD','11263',45.2862,-151.7109,'hic sit et sunt suscipit odio et enim deleniti ab','7');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Robel, Koch and Bahringer', '74859 Arnold Flat','Suite 573','Denismouth','LA','12089-7857',-37.2989,95.3080,'consequatur eligendi velit voluptatem sequi dolor debitis magni corrupti laudantium','8');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Green, Schroeder and Muller', '1887 Gilbert Dale','Suite 381','Shanahanchester','IL','56446-6006',24.5347,160.1640,'corrupti est facere molestiae eos eum necessitatibus quo autem et','8');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Von - Kunze', '35436 Steuber Branch','Suite 822','East Sabryna','MN','67430-2520',32.5658,46.2579,'quibusdam qui veniam qui ab sed perferendis animi repudiandae est','9');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Stamm, Shields and Hintz', '886 Hershel Crescent','Apt. 614','Trompland','CA','30701',-36.6626,-80.6221,'excepturi tenetur est aspernatur quia dolorem fuga id in aperiam','9');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Mraz, Fahey and Osinski', '70340 Stehr Flats','Suite 396','Ignatiushaven','SD','45594-1816',-6.5641,108.4929,'et libero enim doloribus rerum exercitationem numquam eaque in harum','10');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kub - Gerlach', '48101 Darron Street','Apt. 762','New Feliciastad','AR','98198',-55.2273,-4.6289,'quisquam quaerat eaque earum sunt omnis ex odit facilis consequatur','10');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Glover - Wehner', '59352 Olen Neck','Suite 913','Port Rickie','VT','87061',-20.5767,-176.8449,'aut omnis fuga dolor dolore odio molestiae vitae ullam velit','11');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Beier Inc', '639 Leonardo Mountain','Apt. 579','Rossieborough','IN','23550',63.9707,-146.0106,'dolorem facilis fuga explicabo ipsam et et ab asperiores magnam','11');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Goodwin - Keeling', '2026 Melvina Ford','Apt. 258','North Leolaberg','MO','78978-9118',74.3233,-45.7464,'consequatur in iure debitis quas ab reprehenderit exercitationem ipsa veniam','12');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Roob - Hills', '9988 Heathcote Passage','Suite 974','Murielmouth','FL','74465',39.7079,-144.3256,'dolor adipisci fuga voluptas eligendi sapiente maxime quidem molestiae vel','12');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Walter, Feil and Breitenberg', '2911 Brad Walks','Apt. 550','Blickmouth','SC','67361-2611',-29.6957,-22.6377,'ut mollitia ducimus et sapiente quia qui qui necessitatibus nam','13');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Bernhard Group', '2890 Lind Ways','Apt. 758','South Nestorhaven','NM','74819',-49.6733,-179.3792,'reprehenderit nihil atque est quo pariatur impedit veritatis a iure','13');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Berge - Kiehn', '406 Johnson Circle','Suite 394','Haneberg','NJ','23919-8556',42.5216,-132.0222,'voluptatibus vel sit laboriosam rerum excepturi dolorem nulla odit eaque','14');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hodkiewicz LLC', '65220 Neva Cliffs','Suite 811','East Art','NY','03986',79.2143,31.8756,'iure dolore iste rerum et voluptates officia consectetur sed et','14');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Walsh Group', '260 Bogisich Burgs','Apt. 307','South Marieland','MI','26220-5674',-48.1516,119.4533,'omnis quisquam eum in similique id exercitationem blanditiis occaecati quibusdam','15');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lang - Runte', '72845 Feil Crescent','Suite 484','South Araceliland','FL','33708-6198',-1.9168,120.9251,'iure iusto hic commodi voluptas quasi aut distinctio quibusdam debitis','15');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Runolfsson and Sons', '48288 Terry Extensions','Apt. 704','Gilbertofort','NH','91110-7876',-40.2116,170.1829,'qui qui quasi voluptate non non officiis ut consequatur laborum','16');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wolff and Sons', '5405 Cruickshank Rapid','Apt. 186','Boganstad','MN','64027-0918',-18.5432,149.0088,'vel aliquam minima ipsum eius repudiandae saepe voluptatum quia consequatur','16');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Yost, Kassulke and Stokes', '273 Elva Island','Suite 627','Howellborough','ND','87437-6350',46.9454,-108.6383,'placeat aut incidunt nam odio eveniet in est aut eos','17');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Morar, Kshlerin and Goodwin', '062 Ellis Mill','Suite 864','West Raeganmouth','MD','15707-6110',-60.0041,-122.9172,'ratione deleniti harum ut reprehenderit harum molestiae quas nihil consequuntur','17');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Pouros Inc', '7819 Conroy Forks','Apt. 545','Violashire','IA','90484',21.0808,-91.1666,'aut aliquam autem et eius voluptatibus quibusdam animi accusantium quo','18');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Nolan and Sons', '7313 Bailey Plains','Suite 145','West Kayleigh','RI','03432',53.0621,-25.0752,'aperiam inventore ipsa vel eaque et culpa repudiandae impedit rerum','18');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Greenfelder - Welch', '844 Sim Overpass','Apt. 963','Maggiofurt','NJ','93191',61.4725,-65.3535,'odit qui asperiores ea nihil illum est sint sed et','19');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Breitenberg Group', '37548 Josefina Points','Suite 754','Gutkowskiberg','KS','01697',3.2010,60.8280,'quam minus vitae id et reprehenderit consectetur consequatur explicabo cumque','19');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Schinner LLC', '8815 Boyle Expressway','Apt. 368','Blicktown','CT','13322-9642',-19.5117,73.8728,'culpa quos tenetur aut sapiente quam distinctio est dolor sed','20');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Schaefer Group', '874 Hershel View','Apt. 633','Koeppbury','ND','33763-7433',48.7434,35.5412,'expedita qui doloribus itaque possimus nemo et sed praesentium esse','20');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Stoltenberg - Mohr', '703 Ebert Pass','Apt. 370','Ryleetown','CO','04164',21.8777,120.9394,'eos sed veniam ut sequi dolorem soluta nam minus doloremque','21');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Deckow, Farrell and Hegmann', '612 Bahringer Forge','Suite 287','Lebsackborough','VA','58770-8353',-26.2533,-27.9256,'beatae velit expedita deleniti voluptas et temporibus veniam et ut','21');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wisoky, Streich and Hartmann', '98638 Haley Trail','Suite 659','Laurelfort','GA','50052-5060',53.3502,82.0339,'eveniet assumenda quia tempore officia labore consequatur accusamus et consequatur','22');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Donnelly, DuBuque and Altenwerth', '7955 Rhett Village','Suite 180','South Marjoriechester','FL','13201',-56.9367,-12.4315,'et quo qui molestiae quos dicta labore adipisci ipsam ea','22');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Howe, West and Oberbrunner', '650 Dominique Shore','Apt. 115','Dickinsonchester','LA','69658',-83.6929,-18.9862,'ratione accusantium tempore saepe aspernatur et rerum eos maxime nemo','23');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Krajcik, Kiehn and Gutmann', '30507 Jerde Estate','Suite 940','South Demetriusport','AR','08266',22.6438,93.7983,'odit ab necessitatibus est repudiandae sint aut cumque magnam repellendus','23');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Jerde, Watsica and Marquardt', '98821 Ritchie Crossroad','Suite 618','Rossiemouth','NM','23799-1733',83.5004,99.7344,'id nihil consequatur impedit aliquam vel nemo ea consequatur explicabo','24');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Marquardt, Hilpert and Mayert', '13778 Kathlyn Shores','Suite 178','Veumshire','NH','82443',37.3434,-10.7457,'totam voluptatem suscipit blanditiis voluptatem pariatur quidem velit et sint','24');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Bogisich - Hodkiewicz', '481 Vivien Shores','Apt. 134','East Kassandra','OR','84940',-65.2705,105.2613,'libero consequatur excepturi facere est odit magnam omnis aut perferendis','25');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wilderman - Cartwright', '723 Reinger Port','Suite 258','Port Raeport','VT','89451',30.7793,-146.7739,'quae illo ut ad rerum voluptates qui ipsum quo iure','25');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ryan Group', '0132 Nat Spur','Apt. 903','Windlerside','PA','73437-8059',2.4683,50.1330,'ullam quae optio nihil nulla pariatur eos ea temporibus deserunt','26');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Sporer, Rolfson and Conroy', '80823 Raquel Vista','Apt. 564','New Alexandria','OK','83509',-8.6331,137.7356,'doloribus quas occaecati ullam occaecati hic non ut sapiente laboriosam','26');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ortiz and Sons', '19587 Maxine Tunnel','Apt. 439','Hickleport','MT','66039-2807',48.3806,-92.1052,'minus laborum voluptatem doloremque pariatur non earum delectus nesciunt eaque','27');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wilderman Group', '884 Ortiz Viaduct','Apt. 389','Onafort','NC','78552',23.1934,50.4531,'consequatur exercitationem nesciunt adipisci necessitatibus repellat veniam et accusantium totam','27');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Adams LLC', '8555 Okuneva Harbor','Suite 996','New Althea','MO','86364-7000',39.2006,-130.7984,'repellat optio nihil itaque ex quaerat non qui delectus a','28');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Miller Group', '626 Darryl Ports','Suite 186','Kozeymouth','FL','36562-0698',-88.1361,128.6287,'quae quis sint rerum earum ea asperiores qui nam voluptates','28');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ritchie, Schneider and Stehr', '00045 Irving Club','Apt. 124','West Vickieland','IA','56683',-29.8484,-6.8958,'et optio tenetur non voluptate aut voluptas recusandae non et','29');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Jones - Hoeger', '59955 Bartoletti Drive','Suite 677','East Myraport','MN','59239',71.1106,65.0612,'et dolores sint ipsum dolorum aut consectetur atque at dolor','29');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Schaefer LLC', '581 Abshire Plains','Suite 780','Lake Teagan','MS','41885',16.8381,176.0300,'animi placeat quis non eum ratione molestias consequatur fuga non','30');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ebert - Koss', '545 Pollich Path','Suite 446','Mayafurt','MT','32585',-64.0714,144.3183,'repellat libero suscipit numquam ipsam corrupti dolorem et sed velit','30');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('McGlynn, Lockman and Reynolds', '666 Modesta Lake','Apt. 528','Port Louveniaside','IN','03473',-19.0921,3.6610,'labore cumque et odio nostrum et enim ea adipisci repellat','31');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Cummerata - Bergnaum', '56067 Reinger Square','Suite 411','Lindstad','WV','14320-8085',4.0184,-110.4535,'labore qui recusandae est et dolorem voluptas aspernatur voluptas qui','31');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Herzog Group', '21749 Fletcher Isle','Apt. 764','North Donavonhaven','VA','56201-1532',34.5239,-165.8499,'aperiam et rerum modi aliquam quia consequatur iure ut quas','32');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hand Group', '3417 Lessie Fall','Suite 737','East Fausto','MS','06290',-46.0876,-113.4930,'magni architecto ea autem consequatur voluptas ut illo eius rerum','32');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Morissette, Collins and Predovic', '60676 Cyrus Dam','Suite 575','Lake Jameychester','AZ','56420',63.8010,106.0427,'est eos impedit eos autem ut sint pariatur qui voluptatem','33');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kub - Daugherty', '31593 Feest Stravenue','Suite 205','Nolamouth','CO','77767-6748',-7.5944,169.3280,'odio minus laborum aperiam et eligendi voluptatem esse quis dicta','33');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kunde - Buckridge', '3677 Goyette Forks','Apt. 058','South Daphneyhaven','NV','20278-8390',14.3105,-21.3051,'temporibus qui magnam numquam placeat et ipsam nobis culpa pariatur','34');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Rippin Group', '4449 Arthur Ridges','Suite 514','New Reid','NE','58378',0.8843,113.4248,'minima saepe non itaque mollitia incidunt sit qui illum eligendi','34');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Russel, Streich and Baumbach', '53459 Gleason Meadows','Apt. 045','Nikkiland','WY','41140',40.5053,145.7725,'voluptatum voluptate ad et nostrum dolorum pariatur ab error similique','35');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Herman, Kerluke and Goyette', '87729 Langosh Spring','Suite 975','North Lailamouth','IA','15828-4123',-22.7572,-39.2170,'ullam iure quisquam ut totam quas voluptatibus eaque cumque sit','35');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gerhold - Emard', '32371 Jacobson Fork','Suite 703','New Christophebury','ME','90542',-30.2571,126.0124,'dolores esse omnis rerum in velit accusantium iure fugiat ipsa','36');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Smitham Group', '9321 Block Islands','Apt. 426','Hamillburgh','WA','77220',-14.2968,-52.6503,'distinctio veniam fuga iste minus voluptatum et quas modi alias','36');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kilback, Sporer and Kirlin', '964 Graciela Pines','Apt. 367','Keeblerchester','FL','95699',64.1015,-31.7527,'ipsum qui officiis doloribus ut ut aspernatur error eum aut','37');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Collier - Morissette', '09313 Lemke Lodge','Suite 236','Pacochaburgh','NY','83054-6710',33.9796,-31.0442,'distinctio aspernatur voluptatem quasi officiis sunt dolorem libero quisquam molestiae','37');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hand and Sons', '7389 Flatley Crest','Suite 973','North Bryana','OK','39273',-18.8637,38.5298,'iusto accusamus doloremque quas ratione rem qui quam voluptatum praesentium','38');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kub, Jakubowski and Stoltenberg', '5053 Myrtis Club','Suite 255','Emardmouth','KY','84189-1566',-64.7299,-12.7543,'labore illum rem impedit ipsum culpa odio unde dolores iste','38');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lebsack, Trantow and Brekke', '71202 Gerhold Junction','Suite 070','Kossburgh','CT','65762-4781',3.5653,-17.3538,'eaque voluptatem ratione similique fugiat voluptatem rerum rem et facilis','39');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gutmann - Gleichner', '0434 Pagac Street','Suite 238','Lake Yadira','AK','81259',-3.0616,-28.7220,'maiores odit beatae ad aut doloremque fugiat recusandae quisquam ut','39');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('McDermott - Ledner', '026 Nolan Isle','Suite 929','North Keon','AK','20547',-30.7061,24.5961,'beatae enim voluptas omnis rem explicabo recusandae nisi hic culpa','40');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ruecker Group', '534 Clark Ways','Suite 992','New Sofiaside','PA','59665-1159',-39.5493,-116.5298,'unde quis et voluptatem officiis rem qui veniam sunt quibusdam','40');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Sipes - Cremin', '4036 Berneice Common','Suite 540','Josebury','ID','80784-8626',5.1670,-172.0564,'et modi voluptatem ipsum id eius iusto doloribus nam qui','41');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('OConnell - Will', '6769 Carley Extensions','Apt. 056','Trompfort','UT','74337',-48.8913,-11.1008,'quaerat non explicabo et voluptate qui laboriosam quaerat numquam illo','41');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Effertz Inc', '7433 Schroeder Forks','Suite 695','Lake Bonnieberg','FL','04562-0149',56.1962,9.0753,'quidem earum iusto rerum iure ut et temporibus dolorem esse','42');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Reichel - Mante', '66529 Murray Mission','Apt. 330','Framiburgh','CO','49990-7829',-8.6510,-61.5593,'fuga atque blanditiis rem et itaque perspiciatis ducimus harum consectetur','42');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Weber - Braun', '40444 Mills Grove','Apt. 650','East Travon','AR','14662',77.4195,-165.8167,'maiores reprehenderit fugit aperiam incidunt sunt officiis accusamus nobis a','43');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Langworth LLC', '29413 Dooley Crossroad','Suite 229','West Millieton','DE','53924-7569',-76.7717,178.3371,'id animi eaque cupiditate maxime dolorem quis cumque fuga numquam','43');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Keebler, West and Collier', '24162 Crona Expressway','Suite 001','East Michellehaven','SD','58128',70.1957,-142.7734,'magni et excepturi quod similique deserunt eveniet recusandae harum eum','44');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kuhn and Sons', '33165 Charlene Gateway','Suite 740','Mafaldaton','NH','00356-6631',72.5432,167.8566,'voluptate quia sit ratione error voluptate eveniet cumque non sed','44');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lakin, Lowe and Kemmer', '96607 Gerlach Canyon','Apt. 482','Lake Tillman','KS','37133-8618',-72.3568,12.6867,'sit quod alias aut voluptas quidem dolor in accusantium ab','45');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Frami - Bergnaum', '082 Emile Rapids','Apt. 724','Vandervortmouth','AL','23479',-24.2402,157.2370,'sed atque consequatur unde qui est voluptates nisi possimus vitae','45');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Senger, Schamberger and Terry', '36654 Weimann Points','Apt. 752','New Allanstad','MI','49766',-64.1119,-170.5400,'hic dolore magni vel illum quae molestiae consequatur id molestiae','46');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('McCullough Inc', '979 Arch Radial','Suite 458','North Enidfurt','OK','93504-0262',67.3827,-60.2394,'ipsum magnam consequuntur dolore voluptas voluptas exercitationem dignissimos voluptate sit','46');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Johns - Reinger', '76207 Alene Neck','Suite 859','Skyeville','WA','36482',-39.2065,150.2595,'soluta sed earum dolorum necessitatibus voluptatem enim doloribus perspiciatis porro','47');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Purdy - Hettinger', '02505 Schroeder Extension','Suite 492','Port Erling','WA','12948',46.3227,24.7859,'blanditiis qui error fugit deleniti nam voluptas autem voluptas pariatur','47');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ruecker Group', '21011 Karli Falls','Suite 022','Yostside','ME','61468-7295',-15.3953,-61.3407,'aut eius ad consequatur libero nemo exercitationem et in nulla','48');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kris - Willms', '0808 Roderick Harbor','Suite 889','Ondrickaville','WI','86687',-54.5113,118.0764,'et voluptas quo aliquid voluptatem quos quam in eum consequatur','48');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Mann, McLaughlin and Ziemann', '335 Axel Mount','Suite 822','New Alvina','PA','89715-1964',76.6070,44.7317,'repudiandae omnis officia animi magni in aut recusandae nam laboriosam','49');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Metz - Hessel', '496 Rolfson Knolls','Apt. 803','Port Keenanmouth','WA','75659-0438',23.2636,-168.7531,'et rem laudantium nostrum est maiores est nihil aspernatur libero','49');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kerluke - Heller', '6231 Ward Path','Suite 039','Port Mariettaburgh','AZ','39636',-19.4029,-6.9257,'natus praesentium cum est optio maxime omnis ut facilis est','50');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Bradtke Group', '974 Streich Turnpike','Apt. 634','West Millie','WI','22954',9.5959,58.9728,'expedita voluptatibus veritatis quia sed et et modi iste blanditiis','50');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Dooley and Sons', '145 Lueilwitz Square','Suite 940','North Lia','MS','51567',-27.3754,60.4429,'natus facilis impedit error incidunt doloremque est nostrum voluptatum debitis','51');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Mitchell Inc', '930 Andrew View','Suite 296','Spencerland','AL','94523-0454',-70.3434,84.6054,'veniam esse iure dolorem consequuntur et illo voluptatem magnam ipsa','51');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Osinski - Kris', '615 Hand Underpass','Apt. 991','South Margeside','WV','98895',57.6807,-35.8371,'ad modi culpa aliquid ut perferendis repudiandae velit voluptates ipsum','52');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lynch Inc', '697 Oberbrunner Station','Apt. 160','North Earlene','NV','79704',-88.2887,37.6198,'cumque minus est dolores consequatur quos quos nihil quasi deserunt','52');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Jenkins - Wehner', '5861 Shawn Mount','Apt. 790','Port Myah','MT','35930-0812',28.6366,2.5386,'accusantium iure est et incidunt sed est perspiciatis distinctio necessitatibus','53');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Auer - Cormier', '12911 Kuhic Ranch','Apt. 341','South Elenorabury','KS','12063-5786',33.5599,-68.4710,'reiciendis voluptatem ad eius modi nisi quam debitis quia assumenda','53');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Bartell - Kuhlman', '43206 Beier Shoal','Suite 259','Marquardtville','FL','76232-1369',29.4913,-107.6256,'ullam sit voluptatum quia aut repudiandae quo ut tenetur rerum','54');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('McClure - Hane', '76380 Juana Tunnel','Apt. 230','Port Audra','WY','86703',47.9607,143.9507,'consequatur doloribus totam pariatur consequuntur ut et optio excepturi eaque','54');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('White Inc', '1893 Jovany Ways','Apt. 530','New Wardmouth','MT','24481',-39.1423,-149.8748,'culpa pariatur necessitatibus tenetur animi ut deleniti quo harum odit','55');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Berge, Cruickshank and Ziemann', '6896 Kautzer Fords','Suite 596','Sengerbury','LA','50382-7467',59.1814,52.6447,'consequatur voluptates ducimus incidunt quidem mollitia sint est occaecati ratione','55');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Block, Schaden and Predovic', '4208 Leanna Expressway','Suite 364','Vernerland','WV','62847',33.4320,116.5670,'nihil eum quis neque eos et est necessitatibus quod rerum','56');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Turcotte LLC', '1388 Gina Turnpike','Apt. 655','Pagacside','OK','80977',-78.8022,-107.6778,'cupiditate ipsum consequuntur quisquam odio qui vitae est veritatis quibusdam','56');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wintheiser - Pouros', '945 Keebler Fork','Suite 701','Lindgrenborough','OR','29784',6.5479,-117.3068,'et est voluptatibus eius in et non culpa nulla optio','57');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Breitenberg, Schaefer and Reichel', '26883 Americo Viaduct','Apt. 909','Hermanmouth','IN','81121',25.3762,-95.0864,'quisquam dicta animi quo sed ipsa omnis nobis exercitationem vel','57');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wyman Inc', '895 Eichmann Streets','Suite 746','South Staceyton','NJ','67316',-82.2560,-22.9158,'excepturi aut aut hic ex animi at aut est voluptatem','58');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Prohaska - Weber', '9636 Wehner Circle','Suite 137','New Max','NC','11432',-12.8683,31.8365,'quam et delectus et non aut necessitatibus perspiciatis voluptas rerum','58');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Mertz and Sons', '662 Wiegand Ville','Suite 717','Dangelofurt','OH','67569',-21.5723,88.1682,'voluptatem eum aut autem minus sit fugit omnis excepturi nihil','59');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hackett, Mann and Kautzer', '009 Lila Ridge','Suite 954','South Emily','AZ','24900-8643',30.0836,62.2244,'aut veniam rerum illo cum molestias hic officia magnam omnis','59');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Anderson, VonRueden and Kulas', '96459 Lindgren Alley','Apt. 927','North Eduardoborough','GA','57461-3349',-80.8875,-49.7629,'quod qui distinctio corporis facilis ea aut nam doloremque est','60');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Waelchi, Sipes and Langworth', '7567 Tessie Fall','Suite 109','South Vergietown','ID','11966-1820',-69.8451,-105.1608,'excepturi quo doloribus magni quisquam ea voluptatem laborum minima repudiandae','60');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Zemlak and Sons', '29246 Williamson Points','Apt. 513','Rennerfort','AR','60799',-1.6899,-117.8368,'dolorem temporibus ut fugit in expedita recusandae aut aliquam consectetur','61');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Emard - Considine', '5663 Keeley Burgs','Apt. 691','Port Harmon','AL','01914-0615',57.4103,-169.4376,'consequatur magnam fuga eligendi illo molestiae quisquam saepe fugiat assumenda','61');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gutmann LLC', '682 Hector Orchard','Suite 616','Kubburgh','WY','97682',-51.8462,-174.4631,'qui voluptas et consequatur ipsam autem dolorem et aut velit','62');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Rodriguez - Nicolas', '305 Hubert Falls','Suite 924','South Odie','VA','40928-6482',47.6922,108.7096,'omnis expedita atque ut eius amet optio quia consequatur magnam','62');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Connelly - Cummings', '445 Hoppe Crossing','Suite 738','Tonyview','VA','14381',0.2137,-83.3218,'ipsa sapiente et qui qui et id corrupti rerum rerum','63');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lakin Group', '194 Ruecker Turnpike','Suite 317','South Salvador','TX','82295-6814',60.4373,-4.8362,'eveniet velit delectus qui aut molestias voluptatem consequatur et voluptas','63');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Abernathy and Sons', '28612 Harris Street','Apt. 394','East Estellehaven','ME','14101-4741',-26.4856,160.1593,'omnis voluptatum laudantium corrupti quia quidem minus et autem et','64');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Green LLC', '469 Harry Plains','Apt. 564','West Hugh','NV','24868',-39.1861,133.6583,'nemo repellendus vel molestiae blanditiis accusantium ratione dolor qui in','64');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Collier Inc', '357 Viva Stravenue','Suite 689','Croninview','NC','54730-3999',-3.3998,-152.9160,'ducimus sint dolorem dolor qui veniam cum molestiae inventore quis','65');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lang Group', '69537 Matteo Station','Apt. 610','Helmerview','DE','95263',-62.8585,-66.9290,'perferendis voluptatem omnis et ut repellendus deleniti optio error asperiores','65');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Pfannerstill, Dicki and Green', '8271 Antoinette Mills','Apt. 974','Lake Tommie','IA','65155-7214',-81.1781,177.2364,'deserunt dolorem nihil id asperiores magni velit dolorem ipsam vitae','66');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Glover, Howell and Johnston', '469 Tillman Mountains','Suite 800','Walkerport','UT','96442',89.0864,-109.5452,'at dolorem alias officia consequatur mollitia deleniti maxime nesciunt et','66');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Borer - Turcotte', '26242 Goyette Turnpike','Suite 213','South Emmanuel','IA','28440-4054',-71.0862,18.5918,'vel itaque voluptates in est ut iste ipsa explicabo optio','67');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Shields - Ankunding', '2776 Schowalter Mission','Suite 180','Muellerfurt','TN','10857',-52.3258,21.0706,'iusto enim est vel aut aut et rem voluptatem sunt','67');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hagenes, Bartell and Mueller', '33794 Rubye Station','Suite 409','Clintonview','MS','23293-0972',5.9257,78.3470,'tenetur enim quia dolorem sunt minus minima non qui molestiae','68');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Stehr Inc', '4185 Homenick Mission','Suite 339','Harryfort','VT','99662-6416',73.3997,-147.3739,'ut et possimus at et aliquid ea voluptatem ullam consequatur','68');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Abshire, Boyer and Harris', '9316 Champlin Knoll','Suite 266','Juddstad','WV','24626',34.1680,-121.7978,'nisi sint possimus ab nobis provident eos in error et','69');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Nikolaus, Pagac and Keeling', '315 Rollin Hills','Apt. 088','Dariusland','WV','44530',65.8902,-159.4456,'eum placeat culpa nesciunt consequatur autem quos possimus nisi laborum','69');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Beahan, VonRueden and Feil', '85705 Littel Crossing','Suite 472','Ortiztown','NV','28813',44.8581,31.3970,'eius voluptatem ratione modi et et ut quia commodi dolor','70');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Orn, Stoltenberg and Walsh', '465 Grant Spur','Suite 925','Schinnerland','UT','18023-2435',-84.8465,-102.1145,'excepturi sint nihil qui sapiente repellendus cupiditate aliquam saepe id','70');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Upton - Bernhard', '395 Friesen Vista','Suite 839','Maureenton','SC','52462-2950',81.8230,-31.6745,'suscipit eligendi natus aut vero dolor necessitatibus veritatis et quidem','71');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Bashirian Group', '693 Doyle Branch','Suite 888','New Marlen','OH','87909',-24.9753,-130.0053,'ipsum voluptate nulla labore et tempora asperiores deserunt consectetur et','71');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gorczany - Konopelski', '236 Adaline Lakes','Suite 869','North Mozell','CO','45792',-19.4192,-140.4892,'dicta quia hic inventore quia ad eum non dolorum a','72');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Glover, Wehner and Lueilwitz', '0962 Celine Groves','Apt. 259','Haagton','AR','70997-1186',-6.6952,-69.9746,'cumque molestiae fuga illum ut dignissimos autem cum omnis explicabo','72');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Bayer, Bauch and Howe', '8283 Hintz Meadow','Apt. 855','Port Shawna','SD','24367-2088',89.2275,126.1793,'et nihil omnis aliquid porro enim harum autem molestias molestiae','73');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Kassulke - Ritchie', '62435 Norwood Viaduct','Apt. 768','West Dorrisbury','MO','48667',6.8886,-50.3796,'libero repellendus unde aut perspiciatis id sed excepturi quo id','73');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('DAmore Group', '149 Glover Lodge','Suite 692','Lake Kayleigh','MA','34822',-31.6601,-39.9099,'velit minima quo aut a molestias illum quae vel hic','74');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Zboncak, Jenkins and Carter', '1356 Saige Shoal','Suite 699','Lake Maritzaview','WV','12588-7405',-77.3872,156.4935,'dolore commodi aut ut qui rerum expedita inventore temporibus veniam','74');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Boyer, Harber and Rau', '555 Lester Point','Apt. 025','Lake Jaron','VT','56356',20.4661,-97.6397,'non quod necessitatibus dignissimos placeat dignissimos architecto est voluptatibus aut','75');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Leannon - White', '79702 Beatty Freeway','Suite 022','East Lorabury','ID','87024-0852',16.7301,40.1467,'consectetur ut similique et facere sit ducimus unde et nam','75');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Volkman and Sons', '396 Willms Freeway','Suite 692','New Carafurt','KS','10001',-29.8088,103.4752,'architecto dicta nostrum dignissimos aperiam possimus aliquam numquam molestiae nobis','76');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Rempel, Goodwin and Boehm', '85429 Richard Hills','Apt. 449','New Antwan','RI','87453',-3.6502,142.4385,'possimus libero architecto optio et laboriosam et maiores qui dolores','76');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Schimmel - Ratke', '36385 Eleazar Dale','Apt. 889','Lake Carmelatown','IA','79903-9242',77.0980,50.9315,'voluptatem voluptatem provident ea et sit eum fuga inventore ducimus','77');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Keebler - Watsica', '26701 Justice Valleys','Suite 049','Jensenhaven','RI','40840',46.7215,-168.1052,'adipisci ut illum quas molestiae est dolorem voluptate voluptatem assumenda','77');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Lebsack, Hagenes and Konopelski', '12592 Adrienne Lights','Suite 891','Port Petraburgh','PA','48556',58.1842,-19.7878,'quam est aliquid non eaque deserunt quae voluptates harum perspiciatis','78');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Runte Inc', '08350 Winifred Greens','Apt. 644','Krajcikburgh','KY','47361-0480',89.0503,0.0762,'nemo aliquid quae et ut aut eum necessitatibus quis eius','78');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Yost - Ullrich', '24792 Stokes Estate','Suite 289','Welchchester','CO','56319',58.4543,-145.1803,'iusto et asperiores deserunt beatae laudantium facere fugiat officia ipsa','79');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Nienow Inc', '75328 Maurine Extension','Apt. 851','Lake Jaquelinefurt','NH','72940-3745',-73.8647,27.0696,'sapiente possimus sed tempora ullam inventore incidunt reiciendis non alias','79');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('OHara - Barrows', '87644 Beth Walks','Apt. 348','Lake Wainoview','WY','77739-0188',18.3628,136.8985,'incidunt ut et et quae recusandae sunt aperiam enim qui','80');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Aufderhar, Roob and Robel', '8788 Wyman Track','Apt. 267','Zanderfurt','NH','56735',83.5535,-158.0823,'quos et rerum quam corporis vero totam adipisci cum ratione','80');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('McLaughlin LLC', '111 Johnson Gateway','Apt. 898','Jazminland','RI','26202',-80.1372,157.7507,'libero tenetur deserunt voluptatem incidunt qui sint molestiae itaque eveniet','81');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Schiller, DAmore and Wunsch', '973 Brooke Cape','Apt. 405','West Milan','CO','72500-9773',-53.7436,-157.5087,'non debitis perspiciatis laudantium quos sunt eos nisi nesciunt et','81');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Rowe, Macejkovic and Moen', '443 Terrell Ferry','Apt. 450','South Lisa','CO','74068-8946',17.2658,91.4769,'amet in ducimus eos commodi accusantium nisi et consequatur dolor','82');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Romaguera - Kulas', '329 Ritchie Highway','Apt. 320','North Anne','GA','53375',-15.8713,-11.8818,'quis aut quas qui pariatur dolor suscipit dicta id a','82');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Heathcote and Sons', '68913 Riley Lodge','Apt. 265','Dorianborough','CO','22465-3929',-11.9143,-0.5654,'consequatur illum hic est pariatur quo voluptates et numquam quia','83');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Cummings - Simonis', '97801 Jamey Overpass','Suite 601','Wilkinsonburgh','NY','28347-9809',-68.8926,-178.0269,'laboriosam eius iusto quis modi doloremque officiis eum rerum aliquam','83');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Monahan, Abbott and Keebler', '02975 Littel Burg','Suite 085','West Nicholeland','MI','56922',45.7989,175.5498,'non quidem dolorem in consequatur libero voluptatum est nam aliquid','84');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ullrich, Treutel and Lindgren', '5258 Althea Garden','Suite 659','Jordynton','RI','31005-2758',-27.6853,58.7217,'deserunt dolor excepturi vel laborum iusto voluptatem ut sed recusandae','84');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hammes and Sons', '3786 Rogahn Knoll','Suite 935','Duaneside','ME','65480',-5.3073,42.9072,'molestiae iusto vitae adipisci aut distinctio excepturi nihil ut quos','85');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Veum - Schroeder', '5641 Hanna Land','Suite 672','North Estaborough','FL','44341',-51.6475,-167.3810,'enim amet dicta maiores veritatis dolorem commodi sed asperiores omnis','85');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Witting - Parisian', '03939 Aufderhar Row','Suite 745','Ignatiuston','IL','05574',-62.0571,-125.6172,'repellendus animi omnis neque consequatur eos fugit corporis quidem quis','86');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ondricka - Heaney', '3735 Simonis Hills','Suite 655','Lanefurt','LA','08981',-5.0850,-106.9786,'velit quia recusandae et non voluptas nisi labore exercitationem officiis','86');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Wyman Inc', '094 McKenzie Street','Apt. 867','East Dashawn','NH','42374-4838',-63.6158,-125.3590,'qui voluptates adipisci qui repellat ut tempora blanditiis animi dolorem','87');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gottlieb - Zieme', '9290 Kenny Trafficway','Apt. 617','South Loganchester','IL','72770-9119',-77.7312,-175.6086,'temporibus cum placeat voluptas consequatur praesentium aut saepe voluptatem voluptatum','87');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Weber - McLaughlin', '6711 Libbie Field','Apt. 027','South Christianfort','OK','44843',50.5485,-95.8603,'corporis odio eum ipsam a tempora veritatis neque et aperiam','88');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Keeling, Jacobs and Becker', '47505 Heath Estate','Apt. 247','North Cade','ID','41811',-34.2655,-54.6859,'eos consequatur voluptatibus laborum aliquid est doloribus earum cumque ex','88');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Johnson - Herman', '334 Keeling Road','Apt. 947','Port Shanna','AL','72447',39.4924,25.7044,'voluptatem vitae dolores ut minima aut impedit rem amet aspernatur','89');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Hermiston Group', '1995 Ruecker Forge','Suite 618','East Albaville','ID','69075-9998',-39.0912,131.0947,'unde sunt natus accusantium enim voluptatem quam harum expedita ad','89');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Skiles, Stokes and Durgan', '42907 Hilll Crest','Apt. 211','Priceshire','MA','83157',73.2991,-165.7599,'voluptas aut dolorum est rem accusamus iusto quos sed nihil','90');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Dooley and Sons', '5173 Alivia Rapid','Apt. 939','Goldnerburgh','AK','99516-6668',-8.3819,-103.1589,'odio qui tempore et rerum ut non nihil repellat expedita','90');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Glover, Armstrong and Kovacek', '771 Kassulke Dale','Suite 735','Lakinfort','VT','44393',69.7553,-120.1120,'repellat eligendi in sequi nemo natus est aperiam itaque ut','91');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Renner Inc', '7942 Beryl Turnpike','Apt. 094','South Zionport','ID','16499-7827',-0.0874,-40.9038,'ducimus aut veritatis facilis qui eum odit velit optio et','91');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Collins and Sons', '11182 Alvis Skyway','Apt. 241','Port Pattieton','ID','76274',18.5179,42.9774,'ipsam magnam quos aut non et quam sint itaque omnis','92');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Boyle - Rodriguez', '060 Harris Crest','Apt. 346','Wardchester','ME','41420',55.9248,-2.4134,'impedit voluptas illo iusto maxime nihil quasi rerum cumque rerum','92');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Harris, Pfeffer and Watsica', '054 Rowena Hill','Suite 863','South Ellafort','NE','65587-2506',45.5093,7.2577,'quis dignissimos temporibus sunt velit ut est repudiandae quo omnis','93');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Batz, Marks and Brekke', '64338 Koelpin Locks','Suite 181','Fadelfurt','CO','80551',29.1176,-35.7236,'id deleniti nam iste nostrum praesentium laboriosam voluptate qui et','93');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Collins - Schamberger', '771 Torphy Streets','Suite 524','Lake Randal','IL','09495-4905',38.4187,-75.6931,'est enim eum quia ex neque autem aut eligendi veniam','94');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Monahan - Muller', '176 Elva Lock','Suite 926','Hauckland','CO','04329',28.3983,37.0869,'aspernatur dolor laboriosam aut et quidem ullam assumenda ut quibusdam','94');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Crona, Hammes and Mayert', '52772 Eleanora Camp','Suite 587','West Maci','UT','11916',-37.5194,165.3748,'ut quis quia ducimus labore laboriosam qui suscipit sit voluptatem','95');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Sawayn, Ritchie and Upton', '6609 Weissnat Fort','Apt. 018','Rutherfordchester','WA','84392-9177',-81.1891,-96.7612,'nihil facilis laudantium dicta enim fugit velit mollitia rerum delectus','95');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Nader, Stamm and Boehm', '9714 Braxton Parkway','Suite 626','North Lucioville','WV','27250-2796',-51.7486,-84.6388,'voluptatibus numquam tempore architecto sapiente eius doloribus expedita ab est','96');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Ullrich, Predovic and Christiansen', '97110 Mueller Street','Apt. 991','Grahamberg','GA','08155',-11.3630,4.6355,'sint dolor modi sit explicabo et sed possimus eos minima','96');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Beier, Funk and Wolff', '736 Zaria Views','Apt. 706','Ashlynnberg','TX','67122-7572',72.2494,101.2724,'quis maiores possimus inventore autem hic aspernatur cum maiores illum','97');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Mitchell - VonRueden', '628 Morissette Station','Apt. 220','Gregorioshire','VT','56069-5097',38.9187,150.7957,'excepturi distinctio quia aut aperiam atque nam vel ullam nesciunt','97');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Gaylord - Toy', '461 Garrison Curve','Suite 267','West Clair','UT','63204-3050',8.2571,-0.9587,'dolor voluptatem quisquam labore iusto amet facere non ut ratione','98');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Harvey - Friesen', '95845 Casper Rapids','Apt. 022','New Zackaryhaven','HI','87152-9832',-16.5271,98.6697,'qui accusantium reprehenderit harum maxime molestiae maxime ad quaerat natus','98');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Jacobi Inc', '70774 Veum Forges','Suite 690','Rutherfordfurt','LA','80948',56.9342,68.5731,'cupiditate eum voluptas sed voluptates consectetur magnam sunt recusandae quibusdam','99');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Quigley and Sons', '124 Jeffrey Route','Suite 802','Andrewmouth','MI','47368-5497',21.8824,-39.2308,'cumque deserunt rerum voluptas aut aut id quod possimus explicabo','99');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Turner LLC', '05020 Caroline Parkway','Suite 272','Wildermanbury','SC','07179',-18.5135,-172.0048,'eaque repellat voluptatem laboriosam amet qui cum quisquam sit dignissimos','100');
INSERT INTO locations (name, address, address2, city, state, zip, latitude, longitude, instructions, user_id) VALUES ('Reichel Group', '888 Mariano Plain','Suite 247','Gleasonbury','UT','51638-6941',59.3401,-116.1300,'asperiores deserunt doloremque autem quia et possimus non et et','100');



-- GENERATING RESTAURANTS
ALTER TABLE restaurants AUTO_INCREMENT = 1;
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Mraz, Durgan and Armstrong', 'cody.org', 4.24, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Daugherty, Gottlieb and Mayer', 'friedrich.net', 1.82, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Oberbrunner - Cole', 'telly.info', 4.97, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Hackett, Steuber and Cormier', 'alda.biz', 7.82, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Ullrich LLC', 'haylie.net', 9.52, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Feil, Bahringer and Reilly', 'alta.name', 3.42, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Bogan - Jast', 'lucie.org', 4.17, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Heller, Fahey and Emard', 'cassandra.biz', 4.14, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Kohler and Sons', 'brent.biz', 5.56, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);
INSERT INTO restaurants (name, website, fee, open_time, close_time, approved) VALUES ('Goodwin - Herman', 'lowell.name', 7.38, '2020-1-1 08:00:00', '2020-1-1 20:00:00', 1);



-- GENERATING ORDERS
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (1, 24, 9, 78, 'ut et veniam temporibus odio corporis consequatur modi voluptatum aut nulla dolore qui odit culpa facilis architecto esse assumenda quia', '2020-04-06 10:34:11.207', 42.23);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (2, 77, 4, 18, 'tenetur ut et minus dolor est ipsum culpa nihil fuga veritatis incidunt nisi aliquam maxime itaque facere repellendus sit hic', '2020-04-06 12:20:58.854', 24.57);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (3, 34, 1, 48, 'optio architecto non natus soluta doloremque quia error similique enim atque magnam aut et voluptatem quod perferendis est quos et', '2020-04-06 06:40:21.203', 26.29);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (3, 94, 8, 10, 'mollitia ex quod vitae nemo sed nostrum et eius non voluptatem quam sunt quis consequatur distinctio hic ratione asperiores ex', '2020-04-06 09:43:12.003', 29.83);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (3, 94, 1, 131, 'veniam expedita et fugit esse ea eius assumenda sit itaque nostrum consequatur dolore natus natus eum voluptas minima et tempore', '2020-04-06 21:31:45.513', 16.62);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (6, 14, 2, 160, 'dolores vero repudiandae non velit totam aut fuga quis dolorem tempora aut atque ut eius beatae est modi quos et', '2020-04-06 13:29:05.150', 8.41);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (7, 24, 1, 1, 'dicta tenetur vel et consequatur laboriosam et qui sed quia suscipit quae asperiores rerum consectetur laudantium impedit illum sit culpa', '2020-04-06 08:51:34.465', 19.48);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (9, 34, 2, 141, 'illo et adipisci voluptatem neque dolores est sed officia recusandae et eos consectetur est nulla et debitis fugiat consequatur atque', '2020-04-06 22:54:25.708', 12.59);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (9, 34, 9, 43, 'occaecati et eum omnis quibusdam fugit voluptates quia qui ipsa velit cumque nesciunt facilis modi ut laboriosam sunt fugiat nihil', '2020-04-06 08:25:16.065', 23.80);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (10, 77, 8, 108, 'recusandae eligendi corporis error molestiae molestiae aliquam vel animi dolor est distinctio sunt id est qui cupiditate soluta ut sit', '2020-04-06 23:41:50.823', 48.88);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (11, 34, 1, 48, 'et velit sit molestiae molestiae provident et autem aperiam aut sint animi maiores labore aperiam omnis et libero dolor corrupti', '2020-04-06 06:05:35.808', 48.13);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (12, 24, 8, 175, 'ducimus deleniti in alias nihil qui sint consectetur repudiandae delectus nobis quam tenetur facere voluptate sit facilis suscipit repudiandae pariatur', '2020-04-06 16:16:18.528', 19.03);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (12, 24, 1, 175, 'eius quam eum autem nulla molestiae est adipisci et nostrum vel quia qui ab repellat dolorem a velit voluptatem sequi', '2020-04-06 16:02:34.353', 7.46);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (13, 24, 10, 187, 'fuga incidunt velit necessitatibus deleniti quaerat iure dolorem dolores repudiandae sit recusandae quia molestiae consequuntur voluptatum laborum accusantium earum amet', '2020-04-07 00:32:17.614', 35.43);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (13, 58, 9, 158, 'officiis nostrum reiciendis sunt error laudantium qui qui provident aliquid inventore et aut magnam vitae perspiciatis rerum aut qui cumque', '2020-04-07 00:41:10.112', 11.09);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (14, 46, 10, 159, 'ab culpa dolor aspernatur incidunt voluptas pariatur quia autem aliquam qui mollitia temporibus illo sit nihil ducimus totam magnam alias', '2020-04-06 11:57:43.722', 28.16);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (14, 34, 2, 20, 'quo ad amet non sit placeat possimus ex nihil qui est facere voluptas voluptates laboriosam ut ipsum esse voluptatem qui', '2020-04-06 20:20:28.421', 18.20);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (15, 94, 6, 148, 'qui nulla eum nobis ut asperiores voluptas quibusdam asperiores veniam dolorem dolor consequatur qui qui mollitia dolorum quasi beatae rerum', '2020-04-07 01:56:05.062', 36.28);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (16, 77, 8, 185, 'porro nisi necessitatibus iste suscipit expedita cumque libero nam non perferendis quia fugiat debitis molestiae ratione est ullam voluptatum aspernatur', '2020-04-06 18:46:41.953', 7.27);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (16, 77, 9, 44, 'corrupti et tempora dolorum magnam est ut reprehenderit aut odio doloribus consequuntur nam repellat laborum omnis quisquam molestias eum consectetur', '2020-04-06 22:25:31.819', 24.78);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (17, 58, 7, 32, 'quia dignissimos ea et aperiam blanditiis autem molestiae quia qui sint quaerat incidunt magni et at aut quos non iure', '2020-04-06 12:39:30.148', 10.93);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (18, 38, 5, 162, 'doloribus numquam quia fugit exercitationem facilis fugit eius repellendus ab et quos doloribus est sequi nihil doloribus molestiae error accusantium', '2020-04-06 08:49:10.817', 19.45);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (19, 46, 9, 61, 'quod excepturi eligendi debitis vel doloremque quam iusto deserunt unde deleniti et libero et cum dolorem dolorum ut maiores ratione', '2020-04-06 12:33:43.008', 12.87);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (19, 14, 7, 77, 'sit blanditiis et consequuntur voluptatem quasi quam reprehenderit ad enim architecto voluptates velit possimus unde culpa eveniet est iusto quae', '2020-04-06 19:59:11.749', 13.55);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (21, 77, 7, 20, 'unde neque mollitia eaque voluptatum at necessitatibus nulla expedita ut voluptas accusantium illo optio voluptatem exercitationem nam voluptas quia fugit', '2020-04-06 16:17:47.553', 41.93);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (22, 24, 9, 27, 'sequi iusto non velit placeat eum ea mollitia facilis quia blanditiis vero tenetur exercitationem ad natus ut vero modi dolorem', '2020-04-06 08:19:44.376', 33.60);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (22, 77, 2, 128, 'animi amet sequi quia dolorem assumenda sed sint quisquam adipisci ut numquam nihil aliquid laudantium ratione alias aliquid itaque consequuntur', '2020-04-06 05:06:10.479', 48.59);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (23, 77, 6, 92, 'voluptate nam autem neque rem aperiam rerum dolor soluta molestias dolor quis ducimus maxime et qui numquam maiores eos quasi', '2020-04-06 18:01:37.375', 47.42);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (26, 46, 8, 57, 'eius numquam reprehenderit voluptatem id nemo adipisci dolores aut qui voluptatem rerum est inventore eligendi eum tempore consequuntur laudantium maxime', '2020-04-06 06:41:00.621', 24.71);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (26, 77, 4, 124, 'quos omnis et quis at autem cupiditate inventore exercitationem eligendi ea aut consequatur aut ea hic similique velit aut recusandae', '2020-04-07 04:52:52.687', 22.15);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (27, 77, 2, 152, 'et ducimus deleniti vero quia repellat quod nulla qui eaque nisi quia quod explicabo impedit repudiandae ut velit pariatur aperiam', '2020-04-06 14:33:41.946', 13.35);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (27, 38, 1, 86, 'fugiat sapiente suscipit dolor omnis impedit quo quo aut labore magni eligendi id voluptas iste quasi adipisci omnis est impedit', '2020-04-06 11:58:09.410', 24.09);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (28, 58, 7, 81, 'vel debitis pariatur aspernatur non libero exercitationem excepturi sequi magni aut cupiditate consequatur beatae a voluptatem quasi optio voluptates fuga', '2020-04-07 04:40:18.832', 37.04);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (28, 94, 1, 103, 'cupiditate ullam et non officiis voluptates et eius dolorum et qui aut expedita eos voluptates dolores magnam soluta velit atque', '2020-04-06 11:02:32.346', 19.68);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (30, 64, 6, 143, 'molestiae officia qui ipsam temporibus similique soluta quidem fuga illo necessitatibus at delectus possimus nihil qui voluptatem repellat facere sapiente', '2020-04-06 11:31:04.791', 26.07);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (30, 58, 1, 45, 'sed dolor sed adipisci vel nobis corporis ullam reprehenderit similique aut fugit magni nam nam iusto modi facilis perspiciatis non', '2020-04-06 14:05:54.288', 31.08);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (31, 94, 3, 94, 'rerum quam minima inventore eveniet explicabo sint excepturi ullam cumque modi dolorem ipsam voluptas consequuntur natus facilis asperiores laborum porro', '2020-04-07 02:57:05.975', 26.63);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (33, 24, 5, 163, 'repudiandae enim debitis et accusantium perferendis et dolore optio ad repudiandae eveniet enim aut amet laborum voluptatem est voluptate fugit', '2020-04-07 02:52:12.880', 17.71);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (34, 24, 8, 132, 'eum quia error eveniet voluptatibus amet aspernatur nihil quos voluptatem praesentium voluptatibus ratione doloribus voluptatem eaque consectetur nam quis et', '2020-04-06 19:45:06.328', 29.21);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (34, 58, 6, 193, 'aut hic assumenda repellendus harum sit sit voluptatem rem architecto vero accusamus sit est velit molestiae nihil nostrum est et', '2020-04-06 05:27:15.180', 43.89);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (35, 64, 1, 66, 'autem architecto rem quisquam ad provident quis qui quia sequi impedit in cum consectetur non aut quibusdam cupiditate saepe ea', '2020-04-06 16:02:15.688', 48.01);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (35, 46, 1, 69, 'quisquam voluptas sed et quis quod aut aut voluptate nihil qui qui ut aliquid voluptas rerum et deleniti sunt enim', '2020-04-06 11:57:06.675', 29.95);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (36, 64, 7, 150, 'aut iusto ipsam magni placeat sit et eaque qui ratione laboriosam inventore sint consequatur id ipsum soluta impedit autem numquam', '2020-04-06 13:31:31.729', 17.11);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (36, 34, 2, 79, 'et saepe a numquam maxime sit vero est consequatur illum qui quisquam id nihil voluptas eos qui possimus aliquam provident', '2020-04-06 08:02:03.915', 18.40);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (38, 38, 8, 176, 'tenetur error a architecto dolor doloremque quaerat nisi aut magnam illo error corrupti minima quia iure labore culpa nemo est', '2020-04-06 21:54:34.729', 38.23);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (38, 24, 1, 31, 'aliquam cum et totam cupiditate explicabo possimus nihil nemo facere rem provident repudiandae qui velit magnam dolor sit maxime nesciunt', '2020-04-07 00:46:04.342', 27.70);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (38, 24, 6, 152, 'natus molestiae exercitationem rerum et quod quod est quidem et pariatur enim totam sit ea dolor temporibus modi voluptates qui', '2020-04-06 06:52:34.185', 28.81);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (39, 46, 4, 9, 'provident enim velit voluptate recusandae quisquam delectus quia earum maxime dicta qui aperiam sequi aut ullam vero rerum dicta quas', '2020-04-06 11:59:44.065', 6.88);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (39, 24, 10, 169, 'quo atque ea non et veritatis soluta laudantium accusantium itaque consequatur est autem nihil autem qui exercitationem reiciendis nam et', '2020-04-06 22:37:24.701', 15.56);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (40, 77, 9, 191, 'blanditiis in eaque fuga iure consequuntur voluptates molestiae et inventore et a delectus quibusdam tempore iste modi commodi iure expedita', '2020-04-06 22:03:55.983', 43.02);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (41, 58, 8, 68, 'veritatis aut porro quisquam ad quia debitis explicabo maxime delectus qui aut voluptatem ipsa ullam ut laudantium rerum dolorem perspiciatis', '2020-04-06 18:37:10.554', 45.31);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (41, 77, 10, 80, 'autem perspiciatis quo dolore ut eum deserunt placeat exercitationem at nostrum quo doloribus mollitia aut quos at aliquam recusandae id', '2020-04-06 22:48:13.306', 45.81);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (42, 14, 4, 145, 'accusantium et voluptas non dolorum cupiditate dolores vitae aut asperiores qui eum incidunt perferendis sit deserunt rerum debitis sunt adipisci', '2020-04-06 14:24:30.007', 18.83);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (42, 24, 10, 133, 'dolorum mollitia est praesentium quia porro nemo eligendi et ut sequi facilis sequi magnam qui minus voluptas blanditiis ducimus ex', '2020-04-06 06:51:12.808', 19.22);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (42, 77, 4, 1, 'doloremque quis ducimus sint asperiores voluptatem atque et laborum dolores nemo aut qui laboriosam voluptates veritatis minus quia dolores quos', '2020-04-06 16:55:00.234', 43.25);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (43, 77, 8, 28, 'aut et libero aut sit sed alias necessitatibus maxime dolorem voluptatem eum sunt numquam natus aliquam qui omnis aut corrupti', '2020-04-06 18:20:16.813', 49.93);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (45, 46, 2, 65, 'perferendis aliquam labore at amet nobis sequi eos id accusamus aut facilis aspernatur dolores corrupti ad dolores temporibus ipsam est', '2020-04-07 01:13:12.116', 27.25);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (45, 34, 7, 137, 'veniam sit quod tempora omnis quibusdam aut dolor sunt non quaerat sint neque odio quibusdam consequatur iusto commodi dicta itaque', '2020-04-06 14:16:48.526', 16.21);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (46, 94, 5, 20, 'eum debitis vitae occaecati voluptatibus est ducimus sed ex odio velit illo voluptatem iure ipsum assumenda atque saepe distinctio dolor', '2020-04-06 19:09:00.629', 27.95);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (47, 94, 8, 152, 'voluptas fugit non repellendus voluptatem eum nulla qui explicabo possimus aut est et ducimus officiis qui ipsa ut aliquam sit', '2020-04-06 08:53:06.205', 34.91);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (48, 24, 6, 69, 'error est soluta reprehenderit eveniet voluptates sed voluptate dolorum aut veniam qui consequatur voluptatem temporibus aperiam quisquam nobis quod expedita', '2020-04-06 20:12:18.045', 16.73);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (49, 94, 10, 47, 'aut laborum rerum dolore dicta laboriosam placeat aut exercitationem itaque quas repudiandae quidem iure autem dolor adipisci ut rem velit', '2020-04-06 15:41:39.019', 18.66);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (49, 14, 6, 19, 'eos consectetur temporibus sit corporis ipsum et assumenda itaque vel modi consectetur sed molestiae quasi amet fuga quia repellendus nihil', '2020-04-06 05:10:32.102', 35.84);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (50, 46, 3, 182, 'delectus dignissimos explicabo debitis id assumenda sit delectus laborum autem earum reprehenderit quaerat reiciendis dolorem aliquam quam qui magni qui', '2020-04-06 16:24:31.495', 40.38);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (50, 64, 6, 66, 'in et dicta quo eos minima ut aut aperiam ut suscipit tempora voluptatum dolor dolorum est at reiciendis eaque quibusdam', '2020-04-06 23:53:45.020', 38.11);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (50, 38, 3, 106, 'quasi voluptates error autem praesentium et quam ut sint nostrum amet molestiae corrupti enim eligendi ad assumenda et perspiciatis qui', '2020-04-06 18:48:06.240', 44.94);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (51, 34, 3, 161, 'cumque dolore ullam aliquam est tenetur est quaerat est eum at porro sed voluptatum officiis voluptates reiciendis qui voluptatem iure', '2020-04-06 22:35:33.733', 34.71);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (51, 24, 4, 140, 'est in qui sint et et dolor totam laborum sint cum doloremque odio et totam natus nam eligendi modi sed', '2020-04-07 01:05:07.738', 25.31);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (55, 58, 8, 3, 'in consequuntur error tempora consequatur debitis reiciendis quaerat rerum odit sit sed omnis molestias est aut et nostrum commodi est', '2020-04-06 17:24:37.100', 41.33);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (56, 24, 4, 59, 'soluta necessitatibus veniam fugit molestias ut ratione sint voluptas aut et sed omnis unde repudiandae placeat culpa est esse perferendis', '2020-04-06 11:06:25.152', 12.87);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (58, 14, 10, 149, 'id eligendi laboriosam inventore laborum consectetur culpa porro assumenda cupiditate distinctio et blanditiis non dicta velit officia necessitatibus voluptas nobis', '2020-04-06 07:51:39.841', 32.08);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (59, 24, 3, 63, 'minus ut aut id suscipit dolores excepturi debitis sed optio porro sed laboriosam aliquid eum et pariatur vitae maxime nostrum', '2020-04-06 23:50:26.032', 20.93);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (59, 46, 6, 150, 'dolorum in non et aliquam cum non officia id et ipsa ut nemo sunt fugit sed et aut omnis in', '2020-04-07 01:46:29.150', 34.07);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (60, 34, 4, 33, 'enim praesentium distinctio recusandae fuga qui cupiditate provident sit similique ipsam autem ex officiis facilis dicta quia dolorum esse suscipit', '2020-04-06 08:28:56.272', 31.07);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (60, 64, 9, 32, 'est non itaque tenetur et nesciunt sed ducimus vitae qui minus enim dicta odio dolores molestiae occaecati inventore error blanditiis', '2020-04-06 17:31:26.100', 48.14);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (60, 46, 8, 135, 'vel quo omnis quod temporibus sit suscipit itaque enim dolorem pariatur dolorem asperiores blanditiis debitis eius consequatur enim quae qui', '2020-04-06 11:07:29.292', 46.19);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (61, 24, 3, 63, 'magnam est non at autem id et eaque maxime aut consequatur ex eaque dignissimos omnis laboriosam earum natus nemo natus', '2020-04-06 05:19:03.415', 34.97);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (62, 24, 5, 101, 'aut vel officia quia voluptatem quis minima ut enim saepe sed mollitia dolor et laborum adipisci animi laboriosam temporibus voluptas', '2020-04-06 12:09:16.648', 40.17);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (63, 38, 7, 162, 'dolorum distinctio quos molestiae autem eos dolor magni atque doloremque illo adipisci aut reprehenderit voluptates vitae et illum enim non', '2020-04-06 06:48:48.604', 13.09);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (63, 14, 1, 81, 'eaque error fugit sequi maxime dolores laudantium quasi autem sit cumque et vel est veritatis est fuga perspiciatis dolorum dolor', '2020-04-06 18:20:21.003', 36.88);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (63, 24, 6, 111, 'ex sint possimus ducimus facilis ad est rerum quia provident recusandae quia nobis dolores sed minima aperiam nisi consequuntur natus', '2020-04-06 14:45:32.770', 24.45);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (64, 58, 7, 32, 'sit minus voluptas et ad delectus non animi molestiae accusamus maiores assumenda adipisci rerum cupiditate voluptatem odit maiores et inventore', '2020-04-07 00:06:34.544', 21.04);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (65, 34, 1, 176, 'quia ut sunt in modi ut expedita ut et repudiandae minima voluptatibus autem illo soluta eveniet non ut commodi eaque', '2020-04-06 21:12:18.681', 24.89);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (66, 24, 9, 93, 'quia aliquam tenetur velit debitis pariatur nihil aperiam deserunt provident nulla quia molestiae et magni quia eaque qui iure totam', '2020-04-06 13:46:57.275', 22.37);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (67, 64, 2, 78, 'consectetur ad qui delectus id eaque hic incidunt voluptas porro explicabo voluptatem vel sint eum et ea atque voluptatem doloribus', '2020-04-06 10:47:19.776', 13.26);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (67, 24, 5, 191, 'nobis vitae maiores mollitia quibusdam molestias tempore et ullam sit sunt voluptas corrupti molestiae omnis ut occaecati ipsa unde omnis', '2020-04-06 16:48:25.308', 8.49);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (67, 64, 4, 176, 'voluptatem molestiae est sint vel ipsa sit suscipit doloribus rerum quis quam exercitationem dolores amet dolor animi voluptatem ipsum tenetur', '2020-04-07 04:02:03.296', 28.39);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (68, 24, 10, 69, 'veritatis qui soluta deleniti natus rerum perspiciatis at unde recusandae unde qui numquam consequuntur aut dolore maiores quis dolores beatae', '2020-04-06 09:14:45.420', 25.74);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (69, 14, 1, 1, 'deleniti et molestiae voluptatem cumque sed dolorum exercitationem ut delectus expedita minima corporis eos quo possimus et quia quod eligendi', '2020-04-07 04:52:49.704', 28.88);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (69, 38, 7, 134, 'quia nam dignissimos quia voluptatem voluptates enim eos sit non facere reiciendis dolorem aut mollitia in totam consequatur similique suscipit', '2020-04-07 04:06:02.958', 38.88);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (69, 14, 9, 16, 'et dolorem architecto ea totam rem veniam est aspernatur consequuntur modi aut nemo inventore itaque dolorem dignissimos sit dignissimos odit', '2020-04-07 00:13:41.333', 14.60);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (70, 24, 9, 42, 'sint delectus ipsum autem reiciendis tenetur recusandae blanditiis optio veritatis voluptatibus nobis quibusdam voluptatibus et et delectus sit ut ea', '2020-04-06 21:11:49.255', 24.09);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (71, 94, 7, 107, 'sit enim reiciendis ea harum rerum debitis provident rerum eos deleniti numquam sit ab sed et est esse est laboriosam', '2020-04-06 17:10:50.273', 26.97);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (72, 38, 1, 14, 'rerum ut molestiae ut enim aut voluptatem qui mollitia iure sed velit soluta et aut quasi dolorem non hic delectus', '2020-04-06 22:09:53.308', 10.24);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (72, 24, 8, 148, 'doloremque asperiores ipsam nulla quaerat vel tempore et est omnis quia voluptatum rem laudantium quaerat laborum dolores voluptatem consequuntur doloribus', '2020-04-06 10:59:30.525', 35.09);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (73, 34, 10, 84, 'fugiat atque ut excepturi suscipit et libero dignissimos voluptate autem at magnam culpa excepturi cum accusantium ipsum et explicabo nam', '2020-04-06 12:46:29.806', 34.19);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (74, 34, 3, 107, 'nisi rerum cum modi voluptatem assumenda iusto cumque inventore expedita corrupti accusamus mollitia rerum iste est corrupti velit minus ipsa', '2020-04-06 21:43:14.380', 34.82);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (74, 58, 8, 142, 'ut quia omnis voluptatem non est tempora totam natus quia sapiente illo quos vero nulla mollitia laborum asperiores vel et', '2020-04-06 08:45:27.919', 36.07);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (75, 38, 1, 188, 'facere sint ipsam numquam repellat minima iusto voluptatem qui quas deserunt est voluptatibus harum tempora ut vel quidem eius nihil', '2020-04-06 10:42:03.271', 29.31);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (78, 64, 5, 104, 'possimus dolor totam doloribus soluta sequi consectetur accusantium non rerum est nisi pariatur iure expedita unde eum nostrum sed non', '2020-04-06 15:47:45.947', 35.08);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (78, 24, 4, 186, 'incidunt ut explicabo odio eius provident accusamus aliquam pariatur quia quia repellat ea voluptatibus cum occaecati autem qui velit earum', '2020-04-06 13:22:48.635', 16.68);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (78, 77, 7, 144, 'ad magnam et est quia rerum necessitatibus tempore culpa animi et quo sapiente iure et eos iste aut veniam et', '2020-04-06 05:05:24.827', 25.86);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (79, 58, 2, 4, 'quo et harum consequuntur ipsum qui ipsam nobis quia voluptates voluptas quia velit ea cumque ex eum nulla aperiam temporibus', '2020-04-06 16:55:39.000', 39.56);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (79, 46, 5, 6, 'et nemo alias consequuntur laboriosam expedita ipsum modi fugiat tempore commodi consequatur vero eveniet nesciunt et voluptatum sed nobis ut', '2020-04-06 22:51:27.567', 26.30);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (80, 34, 7, 6, 'sint non accusamus iste in molestiae eum tempore nemo ab enim dolorum et sequi mollitia tenetur laudantium mollitia architecto rerum', '2020-04-06 12:36:07.112', 48.92);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (80, 94, 2, 71, 'iusto officia sunt maxime aliquid excepturi qui fugit non qui aut fugiat doloribus id totam officiis reprehenderit molestiae mollitia sunt', '2020-04-07 00:21:13.236', 37.60);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (82, 77, 5, 167, 'fugiat magnam et dolor aut repellat ipsa et et quod ut vel est accusamus autem possimus ut harum aliquid eius', '2020-04-06 12:31:50.170', 31.51);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (82, 24, 2, 117, 'voluptatum sequi est nisi qui architecto explicabo quaerat facilis nisi animi et voluptatem voluptatum est error atque adipisci in consequatur', '2020-04-06 18:40:53.034', 25.43);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (83, 24, 5, 156, 'ut nemo incidunt itaque accusantium voluptatem fuga enim voluptatem ducimus provident id soluta quos temporibus nisi tempore beatae omnis veritatis', '2020-04-07 01:22:39.656', 22.51);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (84, 77, 6, 47, 'non fugiat eos sint culpa vel possimus impedit perferendis aut eos quo velit doloribus qui harum explicabo non dolores rerum', '2020-04-06 16:17:20.594', 16.37);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (84, 34, 9, 58, 'voluptas et sit provident porro alias excepturi illum aperiam in est expedita id sed magnam quo nostrum ut sint doloremque', '2020-04-06 17:40:43.911', 48.85);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (86, 46, 6, 175, 'rerum fugit ipsum officiis nesciunt quia alias placeat reprehenderit et ut repellendus sint et rerum dolor et dignissimos ullam magni', '2020-04-06 16:02:06.347', 11.59);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (86, 77, 9, 172, 'tempore fuga eos deleniti dolores cum nobis sit rerum doloribus quas error quaerat quae voluptas aspernatur fugiat voluptates nobis sint', '2020-04-06 15:37:04.657', 6.56);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (87, 14, 6, 135, 'natus aperiam aut et magnam error modi eius itaque ad quo ut non et repudiandae consequatur aut odit aliquam sit', '2020-04-06 06:27:49.174', 13.77);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (87, 64, 6, 187, 'porro incidunt nihil totam incidunt rerum velit totam in molestias recusandae culpa qui quis repudiandae molestiae quia blanditiis ad et', '2020-04-06 09:39:09.956', 19.81);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (88, 64, 5, 6, 'et autem repellat velit qui pariatur et et et recusandae aperiam amet voluptates qui natus pariatur quia sequi minima iure', '2020-04-06 14:47:02.563', 7.65);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (89, 38, 8, 89, 'corrupti nam debitis incidunt provident nobis enim reiciendis voluptatem quae non ut provident architecto voluptatem iure aut sit ea atque', '2020-04-06 07:02:59.823', 49.33);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (89, 38, 9, 56, 'et praesentium et quam eveniet ullam consectetur dolor occaecati doloremque dolores omnis nisi voluptas fuga iusto qui aut consequatur omnis', '2020-04-06 11:45:08.634', 22.80);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (90, 38, 7, 126, 'sequi earum est provident doloremque aliquam dolorem fugiat qui est distinctio possimus rerum praesentium nihil accusamus perspiciatis voluptatem illum laudantium', '2020-04-06 22:08:12.277', 46.87);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (90, 77, 3, 129, 'accusantium tenetur quibusdam dolor praesentium vitae libero qui autem blanditiis qui laudantium sequi aspernatur quo asperiores corrupti rerum ut odio', '2020-04-07 04:23:06.130', 41.56);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (90, 46, 6, 172, 'est vero quia repellendus sunt autem quis nisi harum adipisci id eius qui quia aut maxime qui corrupti laborum est', '2020-04-07 01:58:03.803', 46.22);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (91, 24, 2, 157, 'animi consequatur quas omnis magnam possimus consequuntur quis recusandae in ipsum quaerat deleniti voluptas et rem optio voluptatum odit aliquid', '2020-04-07 01:36:54.038', 14.73);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (91, 24, 9, 55, 'officia odit explicabo animi cum ut suscipit maxime eum porro illo fugit quod et sequi iusto optio voluptas laborum ut', '2020-04-07 03:13:34.921', 12.19);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (92, 94, 9, 4, 'officiis quo qui repellendus vero eius culpa quis porro aut dolores veritatis quis est quod sit sed et non minus', '2020-04-06 16:45:03.948', 5.53);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (96, 34, 6, 1, 'accusantium voluptatibus repellat necessitatibus optio quam laboriosam qui distinctio ut optio fuga nisi ea et est quasi eaque deleniti voluptatibus', '2020-04-06 22:50:02.574', 39.94);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (96, 46, 8, 30, 'inventore est sed reprehenderit id minus animi aut non molestias pariatur quos inventore qui voluptas quasi sunt blanditiis neque ad', '2020-04-07 02:09:02.597', 37.31);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (97, 77, 4, 90, 'mollitia voluptas fugit quo molestias assumenda et perferendis eveniet est voluptate doloribus nam expedita sed labore et animi non ea', '2020-04-06 20:02:45.976', 46.25);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (97, 14, 5, 166, 'quos inventore amet est vitae et voluptatibus quaerat ea vel optio consequuntur non nobis aut magni quos cupiditate qui aut', '2020-04-06 04:55:45.570', 31.99);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (97, 77, 1, 127, 'sed dicta quam quia id fuga omnis omnis id laboriosam eum et eius autem culpa cum dolores ea eligendi veniam', '2020-04-06 21:58:09.028', 16.89);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (98, 77, 8, 62, 'quibusdam non tempore itaque nostrum sed placeat qui totam sunt ex earum ut voluptatem sit veniam labore voluptas ullam dignissimos', '2020-04-07 01:24:40.442', 26.84);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (99, 14, 5, 3, 'corporis inventore saepe omnis vel suscipit doloremque autem eos enim maxime aut dolores animi nihil dolorem enim reiciendis sapiente sit', '2020-04-07 04:31:59.975', 23.52);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (99, 38, 8, 163, 'odio qui ducimus deserunt quia velit qui fuga repudiandae iusto veritatis totam pariatur corrupti aspernatur accusantium distinctio sint deserunt in', '2020-04-07 04:45:41.931', 19.98);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (100, 77, 9, 150, 'commodi aut asperiores quibusdam et accusamus architecto nostrum sint illo alias iure maiores voluptas sunt deserunt aut sed porro iusto', '2020-04-06 06:51:51.342', 47.89);
INSERT INTO orders (user_id, driver_id, restaurant_id, location_id, order_text, date, price) VALUES (100, 64, 5, 176, 'praesentium qui culpa illo quisquam aliquam vitae repellat qui qui exercitationem ipsum sint ut iure iste ipsam illo similique optio', '2020-04-06 05:46:36.127', 42.87);
