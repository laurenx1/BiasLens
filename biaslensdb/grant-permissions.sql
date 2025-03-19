SELECT user FROM mysql.user;

-- Creating student & admin users for BiasLens
CREATE USER 'biaslensadmin'@'localhost' IDENTIFIED BY 'fakepassword123';
CREATE USER 'biaslensstudent'@'localhost' IDENTIFIED BY 'fakepw1234567';

-- See the default privileges for users
SELECT user, execute_priv FROM mysql.user;



-- Admins can do all the things
GRANT ALL PRIVILEGES ON biaslensDB.* TO 'biaslensadmin'@'localhost';



-- students can only do things related to signing up / logging in and leaderboard + stats viewing
GRANT SELECT ON biaslensDB.* TO 'biaslensstudent'@'localhost';

GRANT SELECT, INSERT, UPDATE ON biaslensDB.account TO 'biaslensstudent'@'localhost';
GRANT INSERT ON biaslensDB.student TO 'biaslensstudent'@'localhost';

GRANT EXECUTE ON PROCEDURE `biaslensDB`.`sp_add_user` TO 'biaslensstudent'@'localhost';
GRANT EXECUTE ON FUNCTION `biaslensDB`.`authenticate` TO 'biaslensstudent'@'localhost';
GRANT EXECUTE ON PROCEDURE `biaslensDB`.`sp_change_password` TO 'biaslensstudent'@'localhost';

-- Flush the GRANT commands to update the privileges
FLUSH PRIVILEGES;