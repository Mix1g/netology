### Домашнее задание к занятию "3. MySQL"
#### Задача 1
Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

    version: '3.5'
     services:
       mysql:
        image: mysql:8
        environment:
          - MYSQL_ROOT_PASSWORD=root
          - MYSQL_DATABASE=test_db
         volumes:
          - ./data:/var/lib/mysql
          - ./backup:/data/backup/mysql
         ports:
          - "3306:3306"
         restart: always
        
 
         
      vagrant@vagrant:~/docker/mysql$ docker-compose  ps
      NAME                COMMAND                  SERVICE             STATUS              PORTS
      mysql-mysql-1       "docker-entrypoint.s…"   mysql               running             0.0.0.0:3306->3306/tcp, :::3306->3306/tcp     

Изучите бэкап БД и восстановитесь из него.

     vagrant@vagrant:~/docker/mysql$ docker exec -it mysql-mysql-1 bash
     root@ba1c54c7ad6a:/# mysql -u root -p test_db < /data/backup/mysql/test_dump.sql
     Enter password:'
     
Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

    mysql> status
    --------------
    mysql  Ver 8.0.32 for Linux on x86_64 (MySQL Community Server - GPL)

    Connection id:          12
    Current database:
    Current user:           root@localhost
    SSL:                    Not in use
    Current pager:          stdout
    Using outfile:          ''
    Using delimiter:        ;
    Server version:         8.0.32 MySQL Community Server - GPL
    Protocol version:       10
    Connection:             Localhost via UNIX socket
    Server characterset:    utf8mb4
    Db     characterset:    utf8mb4
    Client characterset:    latin1
    Conn.  characterset:    latin1
    UNIX socket:            /var/run/mysqld/mysqld.sock
    Binary data as:         Hexadecimal
    Uptime:                 10 min 30 sec

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

    mysql> use test_db;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A

    Database changed
    mysql> show tables;
    +-------------------+
    | Tables_in_test_db |
    +-------------------+
    | orders            |
    +-------------------+
    1 row in set (0.01 sec)
    
 Приведите в ответе количество записей с `price` > 300.
    
       mysql> SELECT * FROM orders WHERE price > 300;
       +----+----------------+-------+
       | id | title          | price |
       +----+----------------+-------+
       |  2 | My little pony |   500 |
       +----+----------------+-------+
       1 row in set (0.00 sec)


       mysql> SELECT count(*) FROM orders WHERE price > 300;
       +----------+
       | count(*) |
       +----------+
       |        1 |
       +----------+
       1 row in set (0.03 sec)

    
  ####  Задача 2
  
  Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"


.
    
      CREATE USER 'test'@'localhost'
      IDENTIFIED WITH mysql_native_password BY 'test-pass' 
      WITH MAX_QUERIES_PER_HOUR 100
      PASSWORD EXPIRE INTERVAL 180 DAY
      FAILED_LOGIN_ATTEMPTS 3
      ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
    
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db.`

     mysql> GRANT SELECT ON test_db.* TO 'test'@'localhost';
     Query OK, 0 rows affected, 1 warning (0.07 sec)
     
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и приведите в ответе к задаче.

     mysql> select * from information_schema.user_attributes where user='test';
     +------+-----------+---------------------------------------+
     | USER | HOST      | ATTRIBUTE                             |
     +------+-----------+---------------------------------------+
     | test | localhost | {"fname": "James", "lname": "Pretty"} |
     +------+-----------+---------------------------------------+
     1 row in set (0.00 sec)

#### Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб
Приведите в ответе измененный файл `my.cnf.`


      [mysqld]
      pid-file        = /var/run/mysqld/mysqld.pid
      socket          = /var/run/mysqld/mysqld.sock
      datadir         = /var/lib/mysql
      secure-file-priv= NULL

      # Custom config should go here
      !includedir /etc/mysql/conf.d/

      innodb_flush_method = O_DSYN
      innodb_file_per_table = 1
      innodb_log_buffer_size = 1M
      innodb_buffer_pool_size = 1G
      innodb_log_file_size = 100M
