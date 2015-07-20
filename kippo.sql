CREATE DATABASE kippo;
GRANT ALL ON kippo.* TO 'kippo'@'172.16.0.0/255.240.0.0' IDENTIFIED BY 'youhackwecapture';
GRANT ALL ON kippo.* TO 'kippo'@'localhost' IDENTIFIED BY 'youhackwecapture';
FLUSH PRIVILEGES;
USE kippo;
SOURCE /kippo/doc/sql/mysql.sql;
