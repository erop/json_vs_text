DROP DATABASE IF EXISTS json_vs_text;
CREATE DATABASE json_vs_text;

USE json_vs_text;

CREATE TABLE text_data_table
    (
        id int AUTO_INCREMENT
            PRIMARY KEY,
        data longtext NOT NULL
    );

CREATE TABLE json_data_table
    (
        id int AUTO_INCREMENT
            PRIMARY KEY,
        data json NOT NULL
    );

SET @qty = 100000;
SET @data = '{"firstName": "John", "lastName": "Doe", "age": 42, "company": "ACME Consulting", "position": "Manager"}';

DELIMITER $$
DROP PROCEDURE IF EXISTS json_data_insert;
CREATE PROCEDURE json_data_insert(IN qty INT)
BEGIN
    DECLARE counter INT DEFAULT 1;
    REPEAT
        INSERT INTO json_data_table(data)
        VALUES (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data);
        SET counter = counter + 1;
    UNTIL counter > qty END REPEAT;
END $$
DELIMITER ;
CALL json_data_insert(@qty);


DELIMITER $$
DROP PROCEDURE IF EXISTS text_data_insert;
CREATE PROCEDURE text_data_insert(IN qty INT)
BEGIN
    DECLARE current INT DEFAULT 1;
    REPEAT
        INSERT INTO text_data_table(data)
        VALUES (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data),
               (@data);
        SET current = current + 1;
    UNTIL current > qty END REPEAT;
END $$
DELIMITER ;
CALL text_data_insert(@qty);

SELECT table_name, data_length, index_length
  FROM information_schema.tables
 WHERE table_schema = 'json_vs_text';
