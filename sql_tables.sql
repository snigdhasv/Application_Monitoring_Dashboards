-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS logs_db;
-- Create the user (only if it doesn't already exist)
CREATE USER IF NOT EXISTS 'new_user'@'%' IDENTIFIED BY 'angel123';
-- Give the user full access to the logs_db database
GRANT ALL PRIVILEGES ON logs_db.* TO 'new_user'@'%';
-- Apply the changes
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS logs_db;

USE logs_db;

CREATE TABLE IF NOT EXISTS logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    timestamp DOUBLE,
    endpoint VARCHAR(255),
    status VARCHAR(50),
    response_time FLOAT,
    service VARCHAR(100),
    error TEXT
);

