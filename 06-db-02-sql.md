### Домашнее задание к занятию 2. «SQL»

#### Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose-манифест.

    version: '3.5'
    services:
      postgres:
    image: postgres:12
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/data/backup/postgres
    ports:
      - "5432:5432"
    restart: always
    
    alexander@ubuntu:~/docker/postgresql$ docker-compose ps
    NAME                    COMMAND                  SERVICE             STATUS              PORTS
    postgresql-postgres-1   "docker-entrypoint.s…"   postgres            running             0.0.0.0:5432->5432/tcp, :::5432->5432/tcp

### Задача 2
В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:

- id (serial primary key)
- наименование (string)
- цена (integer)

      CREATE USER "test-admin-user" WITH LOGIN;
       CREATE DATABASE test_db;
       CREATE TABLE orders (
	   id SERIAL PRIMARY KEY, 
	   наименование TEXT, 
	   цена INT
      );
       CREATE TABLE clients (
	      id SERIAL PRIMARY KEY, 
	      фамилия TEXT, 
	      "страна проживания" TEXT, 
  	      заказ INT REFERENCES orders (id)
       );
       CREATE INDEX ON clients ("страна проживания");

       GRANT ALL ON TABLE clients, orders TO "test-admin-user";
       CREATE USER "test-simple-user" WITH LOGIN;
       GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE clients,orders TO "test-simple-user";
       
Таблица clients:

    - id (serial primary key)
    - фамилия (string)
    - страна проживания (string, index)
    - заказ (foreign key orders)
    
Приведите:

- итоговый список БД после выполнения пунктов выше,

          postgres=# \l
                                 List of databases
           Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
          -----------+----------+----------+------------+------------+-----------------------
           postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
           template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
           template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
           test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
           (4 rows)

 - описание таблиц (describe)

         test_db=# \d+ orders
                                                    Table "public.orders"
            Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description 
            --------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
            id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              | 
            наименование | text    |           |          |                                    | extended |              | 
            цена         | integer |           |          |                                    | plain    |              | 
            Indexes:
            "orders_pkey" PRIMARY KEY, btree (id)
            Referenced by:
            TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
            Access method: heap

       test_db=# \d+ clients
                                                      Table "public.clients"
        Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description 
        -------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
        id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
        фамилия           | text    |           |          |                                     | extended |              | 
        страна проживания | text    |           |          |                                     | extended |              | 
        заказ             | integer |           |          |                                     | plain    |              | 
        Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
        "clients_страна проживания_idx" btree ("страна проживания")
         Foreign-key constraints:
         "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
          Access method: heap
          
 - SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

       SELECT table_name, array_agg(privilege_type), grantee
       FROM information_schema.table_privileges
       WHERE table_name = 'orders' OR table_name = 'clients'
       GROUP BY table_name, grantee ;
     
 - список пользователей с правами над таблицами test_db   

        table_name |                         array_agg                         |     grantee      
        ------------+-----------------------------------------------------------+------------------
        clients    | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | postgres
        clients    | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | test-admin-user
        clients    | {DELETE,INSERT,SELECT,UPDATE}                             | test-simple-user
        orders     | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | postgres
        orders     | {INSERT,TRIGGER,REFERENCES,TRUNCATE,DELETE,UPDATE,SELECT} | test-admin-user
        orders     | {DELETE,SELECT,UPDATE,INSERT}                             | test-simple-user
       (6 rows)
       
      ### Задача 3
      
      Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

    INSERT INTO orders (наименование, цена )
    VALUES 
     ('Шоколад', '10'),
     ('Принтер', '3000'),
     ('Книга', '500'),
     ('Монитор', '7000'),
     ('Гитара', '4000')
    ;
    
 Таблица clients
    
       INSERT INTO clients ("фамилия", "страна проживания")
    VALUES 
       ('Иванов Иван Иванович', 'USA'),
       ('Петров Петр Петрович', 'Canada'),
       ('Иоганн Себастьян Бах', 'Japan'),
       ('Ронни Джеймс Дио', 'Russia'),
       ('Ritchie Blackmore', 'Russia')
    ;
    
    Используя SQL синтаксис:

- вычислите количество записей для каждой таблицы
- приведите в ответе:
   - запросы
   - результаты их выполнения.
       
.       
     
     SELECT 'orders' AS name_table,  COUNT(*) AS number_rows FROM orders
     UNION ALL
     SELECT 'clients' AS name_table,  COUNT(*) AS number_rows  FROM clients;
          
	  name_table | number_rows
         ------------+-------------
          orders     |           5
          clients    |           5
          (2 rows)
	  
###  Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

Приведите SQL-запросы для выполнения данных операций.

    UPDATE clients SET "заказ"=3 WHERE id=1; 
    UPDATE clients SET "заказ"=4 WHERE id=2; 
    UPDATE clients SET "заказ"=5 WHERE id=3; 
    
      test_db=# SELECT "фамилия","заказ",orders."наименование"
     FROM clients
     INNER JOIN orders ON "заказ"=orders."id";
            фамилия        | заказ | наименование
     ----------------------+-------+--------------
      Иванов Иван Иванович |     3 | Книга
      Петров Петр Петрович |     4 | Монитор
      Иоганн Себастьян Бах |     5 | Гитара   
      
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
    
        test_db=# SELECT * FROM clients
     WHERE "заказ" IS NOT null;
      id |       фамилия        | страна проживания | заказ
     ----+----------------------+-------------------+-------
       1 | Иванов Иван Иванович | USA               |     3
       2 | Петров Петр Петрович | Canada            |     4
       3 | Иоганн Себастьян Бах | Japan             |     5
       
   ### Задача 5
   
Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

    test_db=# EXPLAIN SELECT * FROM clients
    WHERE "заказ" IS NOT null;
                         QUERY PLAN
     -----------------------------------------------------------
     Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
       Filter: ("заказ" IS NOT NULL)
       
       Читаем последовательно данные из таблицы clients
       
Стоимость получения первого значения `0.00.`

Стоимость получения всех строк `18.10.`

Приблизительное количество проверенных строк `806`

Средний размер каждой строки в байтах составил `72`

Используется фильтр "заказ" `IS NOT NULL`

### Заадача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

     pg_dump -U postgres -F t test_db > /data/backup/postgres/test_db.tar
     
 Остановите контейнер с PostgreSQL (но не удаляйте volumes).
 
    alexander@ubuntu:~$ docker ps
    CONTAINER ID   IMAGE            COMMAND                  CREATED       STATUS             PORTS                                        NAMES
    fdb314cb44c3   dpage/pgadmin4   "/entrypoint.sh"         3 hours ago   Up About an hour   0.0.0.0:80->80/tcp, :::80->80/tcp, 443/tcp   postgresql-pgadmin-1
    f1257673aab7   postgres:12      "docker-entrypoint.s…"   3 hours ago   Up About an hour   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp    postgresql-postgres-1
    alexander@ubuntu:~$ docker stop postgresql-postgres-1
    postgresql-postgres-1
    alexander@ubuntu:~$ docker ps -a
    CONTAINER ID   IMAGE            COMMAND                  CREATED       STATUS                     PORTS                                        NAMES
    fdb314cb44c3   dpage/pgadmin4   "/entrypoint.sh"         3 hours ago   Up About an hour           0.0.0.0:80->80/tcp, :::80->80/tcp, 443/tcp   postgresql-pgadmin-1
    f1257673aab7   postgres:12      "docker-entrypoint.s…"   3 hours ago   Exited (0) 6 seconds ago                                                postgresql-postgres-1
    
    
  Поднимите новый пустой контейнер с PostgreSQL.
  
     alexander@ubuntu:~/docker/delete$ docker ps
     CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                        NAMES
     4476595b0f8d   postgres:12      "docker-entrypoint.s…"   25 seconds ago   Up 14 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp    delete-postgres-1
     fdb314cb44c3   dpage/pgadmin4   "/entrypoint.sh"         4 hours ago      Up 2 hours      0.0.0.0:80->80/tcp, :::80->80/tcp, 443/tcp   postgresql-pgadmin-1
     
  Восстановите БД test_db в новом контейнере.
  
      postgres=# CREATE USER "test-admin-user" WITH LOGIN;
    CREATE ROLE
    postgres=# CREATE USER "test-simple-user" WITH LOGIN;
    CREATE ROLE

    root@4476595b0f8d:/# pg_restore -U postgres --verbose -C -d postgres /data/backup/postgres/test_db.tar
    pg_restore: connecting to database for restore
    pg_restore: creating DATABASE "test_db"
    pg_restore: connecting to new database "test_db"
    pg_restore: creating TABLE "public.clients"
    pg_restore: creating SEQUENCE "public.clients_id_seq"
    pg_restore: creating SEQUENCE OWNED BY "public.clients_id_seq"
    pg_restore: creating TABLE "public.orders"
    pg_restore: creating SEQUENCE "public.orders_id_seq"
    pg_restore: creating SEQUENCE OWNED BY "public.orders_id_seq"
    pg_restore: creating DEFAULT "public.clients id"
    pg_restore: creating DEFAULT "public.orders id"
    pg_restore: processing data for table "public.clients"
    pg_restore: processing data for table "public.orders"
    pg_restore: executing SEQUENCE SET clients_id_seq
    pg_restore: executing SEQUENCE SET orders_id_seq
    pg_restore: creating CONSTRAINT "public.clients clients_pkey"
    pg_restore: creating CONSTRAINT "public.orders orders_pkey"
    pg_restore: creating INDEX "public.clients_страна проживания_idx"
    pg_restore: creating FK CONSTRAINT "public.clients clients_заказ_fkey"
    pg_restore: creating ACL "public.TABLE clients"
    pg_restore: creating ACL "public.TABLE orders"

    postgres=# \l
                                   List of databases
        Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
     -----------+----------+----------+------------+------------+-----------------------
      postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
      template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                |          |          |            |            | postgres=CTc/postgres
      template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                |          |          |            |            | postgres=CTc/postgres
      test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 

      postgres=# \c test_db
      You are now connected to database "test_db" as user "postgres".
      test_db=# \d orders
                                  Table "public.orders"
          Column    |  Type   | Collation | Nullable |              Default
      --------------+---------+-----------+----------+------------------------------------
       id           | integer |           | not null | nextval('orders_id_seq'::regclass)
       наименование | text    |           |          |
       цена         | integer |           |          |
      Indexes:
      "orders_pkey" PRIMARY KEY, btree (id)
     Referenced by:
        TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)

    test_db=# \d clients
                                     Table "public.clients"
           Column       |  Type   | Collation | Nullable |               Default
     -------------------+---------+-----------+----------+-------------------------------------
      id                | integer |           | not null | nextval('clients_id_seq'::regclass)
      фамилия           | text    |           |          |
      страна проживания | text    |           |          |
      заказ             | integer |           |          |
     Indexes:
         "clients_pkey" PRIMARY KEY, btree (id)
         "clients_страна проживания_idx" btree ("страна проживания")
      Foreign-key constraints:
         "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
 
   
