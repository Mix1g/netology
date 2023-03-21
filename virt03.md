
### Задача 1

Сценарий выполнения задачи: создайте свой репозиторий на https://hub.docker.com; выберете любой образ, который содержит веб-сервер Nginx; создайте свой fork образа; реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже. Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

    <html>
    <head>
    Hey, Netology
    </head>
    <body>
    <h1>I’m DevOps Engineer!</h1>
    </body>
    </html>

Решение:

https://hub.docker.com/repository/docker/mix1g/test/

![Снимок экрана от 2023-03-22 01-39-13](https://user-images.githubusercontent.com/119140245/226738341-f1783be7-d2be-4ec3-96c3-603f061cfa6f.jpg)

![Снимок экрана от 2023-03-22 01-33-58](https://user-images.githubusercontent.com/119140245/226739013-63cec4dd-86ac-4faa-8278-bc4a5b9978d0.png)
![Снимок экрана от 2023-03-22 01-34-27](https://user-images.githubusercontent.com/119140245/226739265-f730a476-c59b-4b7e-ba80-8908dc91b526.png)

 ##### Запушить образ на докерхаб почему то никак нехочет
 
 ### Задача 2
 Посмотрите на сценарий ниже и ответьте на вопрос: «Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Детально опишите и обоснуйте свой выбор.

Решение:

1. Высоконагруженное монолитное java веб-приложение - монолитное веб-приложение предполагает сборку всего в одном месте (frontend, backend, UI). Так как монолитное веб-приложение высоконагруженное, то стоит размещать или на физической среде, или можно использовать пара виртуализацию, если накладными расходами можно пренебречь, однако контейнеризация не подойдет, так предполагается выполнение одного сервиса в рамках контейнера.

2. Nodejs веб-приложение - контейнеризация подойдет для решения задачи, по сути node.js - это условно говоря environment для javascript для построения логики работы веб-приложения, является его частью, модулем, хорошо укладывается в микро сервисную архитектуру.

3. Мобильное приложение c версиями для Android и iOS - предполагается, что приложение имеет своего потребителя, а значит необходим UI для взаимодействия с пользователем. По моему мнению, корректнее всего использовать виртуализацию с реализацией виртуальной машины.

4. Шина данных на базе Apache Kafka - если можно так выразится, то это сервис по трансляции данных из одного формата данных одного приложения в другое. По моему мнению хорошо применить контейнеризацию, так как отсутствуют накладные расходы на виртуализацию, достигается простота масштабирования и управления. В данном случае необходимо организация отказоустойчивости.

5. Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana - для упомянутых продуктов есть контейнеры на docker hub. Из-за простоты управления и сборки контейнеров, мне кажется необходимо распихать продукты по контейнерам и на основании контейнеров собрать кластер стека ELK. В силу прозрачности реализации, в том числе возможности реализации подходов IaaC, контейнеризация в данном случае помогает закрыть вопросы по менеджменту и что очень важно получить регулярный предсказуемый результат.

6. Мониторинг-стек на базе Prometheus и Grafana - по моему мнению также как и пример с ELK, скорее всего с течением времени будут вноситься изменения в систему мониторинга и не один раз, будут добавляется метрики, так как точки мониторинга будут меняться - добавляться новый функционал, было бы не плохо применить IaaC в том числе и в этом случае - мониторинг как код, контейнеризация помогает этого добиться.

7. MongoDB, как основное хранилище данных для java-приложения - либо виртуализация, либо контейнеризация, все зависит от реализации архитектуры приложения. Сложно дать вразумительный ответ - никогда не работал с данной БД, затрудняюсь обосновать выбор. Чувствую, что так будет правильно.

8. Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry - отдельный физический сервер или виртуализация, если сервер есть в наличии использовал бы его, но только необходимо оценить доступные объемы хранения данных, в том числе подумать о техническом сопровождении: просчитать затраты на поддержку железа и ЗИП. Если по совокупности поставленных задач будет понятно, что через осязаемое недалекое время мы выйдем за пределы мощностей физ. сервера, то выбрал бы, на перспективу, виртуализацию, однако возможны первичные затраты на доп. железо, но все зависит от проекта. Требуется пред проектная аналитика.

### Задача 3

Запустите первый контейнер из образа centos c любым тегом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.
Добавьте ещё один файл в папку /data на хостовой машине.
Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.

    alexander@Lenovo:~$ docker run -d -v $(pwd)/data:/data:rw centos sleep infinity
    4ad5c856bcefc577b475190c63018f1085f211b4e38de9bb828ae0a776d1413c

    lexander@Lenovo:~$ docker ps
    CONTAINER ID   IMAGE     COMMAND            CREATED          STATUS          PORTS     NAMES
    4ad5c856bcef   centos    "sleep infinity"   46 seconds ago   Up 45 seconds             bold_johnson

    alexander@Lenovo:~$ docker exec -it 4ad5c856bcef bash
    [root@4ad5c856bcef /]#

    [root@4ad5c856bcef /]# ls -lah /
    total 60K
    drwxr-xr-x   1 root root 4.0K Mar 21 21:23 .
    drwxr-xr-x   1 root root 4.0K Mar 21 21:23 ..
    -rwxr-xr-x   1 root root    0 Mar 21 21:23 .dockerenv
    lrwxrwxrwx   1 root root    7 Nov  3  2020 bin -> usr/bin
    drwxr-xr-x   2 root root 4.0K Mar 21 21:23 data
    drwxr-xr-x   5 root root  340 Mar 21 21:23 dev
    drwxr-xr-x   1 root root 4.0K Mar 21 21:23 etc
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 home
    lrwxrwxrwx   1 root root    7 Nov  3  2020 lib -> usr/lib
    lrwxrwxrwx   1 root root    9 Nov  3  2020 lib64 -> usr/lib64
    drwx------   2 root root 4.0K Sep 15  2021 lost+found
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 media
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 mnt
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 opt
    dr-xr-xr-x 220 root root    0 Mar 21 21:23 proc
    dr-xr-x---   2 root root 4.0K Sep 15  2021 root
    drwxr-xr-x  11 root root 4.0K Sep 15  2021 run
    lrwxrwxrwx   1 root root    8 Nov  3  2020 sbin -> usr/sbin
    drwxr-xr-x   2 root root 4.0K Nov  3  2020 srv
    dr-xr-xr-x  13 root root    0 Mar 21 21:23 sys
    drwxrwxrwt   7 root root 4.0K Sep 15  2021 tmp
    drwxr-xr-x  12 root root 4.0K Sep 15  2021 usr
    drwxr-xr-x  20 root root 4.0K Sep 15  2021 var
    [root@4ad5c856bcef /]# 
    
    
Аналогичные действия для контейнера с debian

    alexander@Lenovo:~$ docker run -v $(pwd)/data:/data:rw -d debian sleep infinity
    Unable to find image 'debian:latest' locally
    latest: Pulling from library/debian
    32fb02163b6b: Pull complete 
    Digest: sha256:f81bf5a8b57d6aa1824e4edb9aea6bd5ef6240bcc7d86f303f197a2eb77c430f
    Status: Downloaded newer image for debian:latest
    0270addd6cbb5743c596daaf26a5b2ca01f048408190d65eff848f17ae7c1476
    
    alexander@Lenovo:~$ docker ps
    CONTAINER ID   IMAGE     COMMAND            CREATED          STATUS          PORTS     NAMES
    0270addd6cbb   debian    "sleep infinity"   25 seconds ago   Up 23 seconds             keen_chatelet
    4ad5c856bcef   centos    "sleep infinity"   10 minutes ago   Up 10 minutes             bold_johnson
    alexander@Lenovo:~$ 

    alexander@Lenovo:~$ ls -lah /
    итого 2,1G
    drwxr-xr-x  20 root root 4,0K мар 13 23:57 .
    drwxr-xr-x  20 root root 4,0K мар 13 23:57 ..
    -rw-r--r--   1 root root    0 мар 13 23:57 0
    lrwxrwxrwx   1 root root    7 мар 14 03:17 bin -> usr/bin
    drwxr-xr-x   4 root root 4,0K мар 14 14:13 boot
    drwxrwxr-x   2 root root 4,0K мар 14 03:18 cdrom
    drwxr-xr-x  21 root root 4,9K мар 21 23:32 dev
    drwxr-xr-x 145 root root  12K мар 21 23:01 etc
    drwxr-xr-x   3 root root 4,0K мар 14 03:18 home
    lrwxrwxrwx   1 root root    7 мар 14 03:17 lib -> usr/lib
    lrwxrwxrwx   1 root root    9 мар 14 03:17 lib32 -> usr/lib32
    lrwxrwxrwx   1 root root    9 мар 14 03:17 lib64 -> usr/lib64
    lrwxrwxrwx   1 root root   10 мар 14 03:17 libx32 -> usr/libx32
    drwx------   2 root root  16K мар 14 03:17 lost+found
    drwxr-xr-x   3 root root 4,0K мар 13 22:28 media
    drwxr-xr-x   2 root root 4,0K окт 20 12:06 mnt
    drwxr-xr-x   7 root root 4,0K мар 20 17:13 opt
    dr-xr-xr-x 507 root root    0 мар 21 23:32 proc
    drwx------  11 root root 4,0K мар 20 14:24 root
    drwxr-xr-x  46 root root 1,3K мар 21 23:32 run
    lrwxrwxrwx   1 root root    8 мар 14 03:17 sbin -> usr/sbin
    drwxr-xr-x  27 root root 4,0K мар 20 14:05 snap
    drwxr-xr-x   2 root root 4,0K окт 20 12:06 srv
    -rw-------   1 root root 2,0G мар 14 03:17 swapfile
    dr-xr-xr-x  13 root root    0 мар 21 23:32 sys
    drwxrwxrwt  33 root root 4,0K мар 22 02:33 tmp
    drwxr-xr-x  14 root root 4,0K окт 20 12:06 usr
    drwxr-xr-x  14 root root 4,0K окт 20 12:11 var
    alexander@Lenovo:~$ 
    
С контейнера под centos создаем в директории файл

    alexander@Lenovo:~$ echo '' > $(pwd)/data/centos-file-056
    alexander@Lenovo:~$ ls $(pwd)/data
    centos-file-056

Создадим  файл с хоста

     alexander@Lenovo:~$ echo '' > $(pwd)/data/fedora-host-file-001
     alexander@Lenovo:~$ ls $(pwd)/data
     centos-file-056  fedora-host-file-001
     alexander@Lenovo:~$ 
     
Просмотр списка файлов 

     lexander@Lenovo:~$ ls -lah $(pwd)/data
     итого 16K
     drwxr-xr-x  2 alexander alexander 4,0K мар 22 02:42 .
     drwxr-x--- 34 alexander alexander 4,0K мар 22 02:23 ..
     -rw-rw-r--  1 alexander alexander    1 мар 22 02:38 centos-file-056
     -rw-rw-r--  1 alexander alexander    1 мар 22 02:42 fedora-host-file-001
     alexander@Lenovo:~$ 

    
     
