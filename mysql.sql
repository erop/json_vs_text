SELECT VERSION();

-- Create test database and tables
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


-- Initialize test data
SET @qty = 10000;
SET @data = '{"firstName": "John", "lastName": "Doe", "age": 42, "company": "ACME Consulting", "position": "Manager"}';


-- Define procedures
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

-- Populate text_data_table
SET @text_start = UNIX_TIMESTAMP();
CALL text_data_insert(@qty);
SET @text_end = UNIX_TIMESTAMP();
SET @text_time = @text_end - @text_start;


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

-- Populate json_data_table
SET @json_start = UNIX_TIMESTAMP();
CALL json_data_insert(@qty);
SET @json_end = UNIX_TIMESTAMP();
SET @json_time = @json_end - @json_start;


-- Get results
SELECT table_name AS `Table`, ROUND(data_length / 1024 / 1024) AS `Size in MB`, data_length AS `Size in bytes`,
       CASE WHEN table_name = 'json_data_table' THEN @json_time
            WHEN table_name = 'text_data_table' THEN @text_time END AS `Time in sec`
  FROM information_schema.tables
 WHERE table_schema = 'json_vs_text'
 ORDER BY table_name;