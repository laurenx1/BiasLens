SELECT user FROM mysql.user;

-- Creating student & admin users for BiasLens
CREATE USER 'biaslensadmin'@'localhost' IDENTIFIED BY 'fakepassword123';
CREATE USER 'biaslensstudent'@'localhost' IDENTIFIED BY 'fakepw1234567';

-- See the default privileges for users
SELECT user, execute_priv FROM mysql.user;



-- Clients (e.g. app developers interacting with the database) may only have SELECT
-- privileges granted



-- Admins can do all the things
GRANT ALL PRIVILEGES ON biaslensDB.* TO 'biaslensadmin'@'localhost';
 
GRANT SELECT ON biaslensDB.* TO 'biaslensstudent'@'localhost';

GRANT SELECT, INSERT, UPDATE ON biaslensDB.account TO 'biaslensstudent'@'localhost';
GRANT INSERT ON biaslensDB.student TO 'biaslensstudent'@'localhost';

GRANT EXECUTE ON PROCEDURE `biaslensDB`.`sp_add_user` TO 'biaslensstudent'@'localhost';
GRANT EXECUTE ON FUNCTION `biaslensDB`.`authenticate` TO 'biaslensstudent'@'localhost';
GRANT EXECUTE ON PROCEDURE `biaslensDB`.`sp_change_password` TO 'biaslensstudent'@'localhost';

-- Flush the GRANT commands to update the privileges
FLUSH PRIVILEGES;

-- -- Let's see the results!
-- SELECT user, execute_priv FROM mysql.user WHERE user LIKE 'airbnb%';
-- -- Now, only airbnbadmin has admin privileges, airbnbclient only has SELECT
-- privileges (e.g. no procedures)
-- -- Permissions in action (after logging in with mysql -u airbnbclient -p)
-- USE airbnbdb;
-- -- Client doesn't have execute permissions, thus this CALL to a superhosts()
-- procedure
-- -- will cause an error
-- CALL superhosts();
-- -- ERROR 1370 (42000): execute command denied to user 'airbnbclient'@'localhost'
-- for routine 'airbnbdb.superhosts'
