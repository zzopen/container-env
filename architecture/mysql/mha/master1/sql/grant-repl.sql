/*  REPLICA */
CREATE USER 'repl'@'%' IDENTIFIED BY 'repl';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'0.0.0.0';
FLUSH PRIVILEGES;