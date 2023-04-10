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
