
### Домашнее задание к занятию  PostgreSQL

#### Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя `psql.`

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

Найдите и приведите управляющие команды для:

- вывода списка БД,
- подключения к БД,
- вывода списка таблиц,
- вывода описания содержимого таблиц,
- выхода из psql.


вывода списка БД

      \l[+]   [PATTERN]      list databases
      
подключения к БД

      \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                             connect to new database (currently "postgres")
вывода списка таблиц

      \dt[S+] [PATTERN]      list tables
      
вывода описания содержимого таблиц

      \d[S+]  NAME           describe table, view, sequence, or index
выхода из psql

      \q     quit psql       

#### Задача 2

Используя `psql,` создайте БД `test_database.`

Изучите бэкап БД.

Восстановите бэкап БД в `test_database.`

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу pg_stats, найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.



##### Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.

     test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' order by avg_width desc limit 1;
    -[ RECORD 1 ]----
    attname   | title
    avg_width | 16


#### Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?


    --
    -- (шардировать на orders_1 - price>499 и orders_2 - price<=499).
    --

    begin;

      -- переименование "старой"  orders
      alter table public.orders rename to orders_old;

      -- создание новой orders с партиционированием
      create table public.orders (
          like public.orders_old
          including defaults
          including constraints
          including indexes
      );

      create table public.orders_1 (
          check (price>499)
      ) inherits (public.orders);

      create table public.orders_2 (
          check (price<=499)
      ) inherits (public.orders);

      ALTER TABLE public.orders_1 OWNER TO postgres;
      ALTER TABLE public.orders_2 OWNER TO postgres;

      create rule orders_insert_over_499 as on insert to public.orders
      where (price>499)
      do instead insert into public.orders_1 values(NEW.*);

      create rule orders_insert_499_or_less as on insert to public.orders
      where (price<=499)
      do instead insert into public.orders_2 values(NEW.*);

      -- копирование данных из старой в новую
      insert into public.orders (id,title,price) select id,title,price from public.orders_old;

     -- перепривязывание SEQUENCE
     alter table public.orders_old alter id drop default;
     ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;

      -- удаление старой orders
      drop table public.orders_old;

    end;
    
#### Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Можно сделать при создании таблицы:

    --
    -- Name: orders; Type: TABLE; Schema: public; Owner: postgres
    --

     drop table public.orders cascade;

    CREATE TABLE public.orders (
        id integer NOT NULL,
        title character varying(80) NOT NULL,
        price integer DEFAULT 0
    );
    ALTER TABLE public.orders OWNER TO postgres;

    -- (шардировать на orders_1 - price>499 и orders_2 - price<=499).

    create table public.orders_1 (
        check (price>499)
     ) inherits (public.orders);

     create table public.orders_2 (
        check (price<=499)
     ) inherits (public.orders);

     ALTER TABLE public.orders_1 OWNER TO postgres;
     ALTER TABLE public.orders_2 OWNER TO postgres;

     create rule orders_insert_over_499 as on insert to public.orders
     where (price>499)
     do instead insert into public.orders_1 values(NEW.*);

     create rule orders_insert_499_or_less as on insert to public.orders
     where (price<=499)
     do instead insert into public.orders_2 values(NEW.*);

#### Задача 4

Используя утилиту `pg_dump,` создайте бекап БД `test_database.`

     export PGPASSWORD=netology && pg_dump -h localhost -U postgres test_database > /media/backup/test_database_$(date --iso-8601=m | sed 's/://g; s/+/z/g').sql

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database?`

#### Можно добавить  свойство UNIQUE

    --
        title character varying(80) NOT NULL UNIQUE,
    --
