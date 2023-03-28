#### Задача 1 



#### В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?

Для replicated сервисов мы указываем количество идентичных задач, которых хотим запустить. Swarm отслеживает текущее количество запущенных задач и в случае падения какой-либо ноды - запустит задачу на другой (поддерживает заданное количество реплик).
Global сервис запускает одну задачу на каждой ноде. То есть при добавлении в кластер новых нод, глобальный сервис будет запущен и на ней автоматически

#### Какой алгоритм выбора лидера используется в Docker Swarm кластере?

Docker Swarm использует алгоритм консенсуса Raft для определения лидера. Этот алгоритм обеспечивает согласованное состояние кластера. Raft требует, чтобы большинство членов кластера согласились на изменение, и допускает (N-1)/2сбоев. В случае недоступности лидера, его роль берет на себя одна из нод-менеджеров (если за нее проголосовало большинство менеджеров). Реализуется это за счет таймаутов. Если в течение определенного времени менеджер не получил данные от лидера - он объявляет себя кандидатом и другие ноды голосуют за него.


### Что такое Overlay Network?


Overlay сеть - это сеть между несколькими демонами Docker. Она перекрывает сети хоста и позволяет контейнерам безопасно обмениваться данными (с использованием сертификатов и шифрования). Docker маршрутизирует пакеты к нужному хосту и контейнеру.


#### Задача 2


    [root@node01 ~]# docker node ls
    ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
    q7ybewzhnlt4g8i4q2hgsme16 *   node01.netology.yc   Ready     Active         Leader           20.10.11
    rjgo07uaqsffxaduqgogexh4y     node02.netology.yc   Ready     Active         Reachable        20.10.11
    hnvx6ug830f6q2orbt21wl536     node03.netology.yc   Ready     Active         Reachable        20.10.11
    yvksdjnnhdz7m918gjodmime5     node04.netology.yc   Ready     Active                          20.10.11
    1actkrhyg3s1gaboy6ibf1wv6     node05.netology.yc   Ready     Active                          20.10.11
    vovxqnougcs1d37cui2vv1bs6     node06.netology.yc   Ready     Active                          20.10.11

#### Задача 3

    [root@node01 ~]# docker service ls
    ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
    m5by05q5moyf   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
    hys6xv2fdtol   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
    252i1tqzcp7e   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
    45uh23r36c5r   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
    tze6cvq8ivs8   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
    zlnmt3l8f7oe   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
    fanirldjts6j   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
    lp5ti1ot5ea2   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0 
