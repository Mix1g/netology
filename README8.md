### Домашнее задание к занятию "Компьютерные сети.Лекция


#### 1 Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

    root@ubnt:/home/alexander# ifconfig
    enp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.0.105  netmask 255.255.255.0  broadcast 10.10.0.255
        inet6 fe80::dacb:8aff:fe14:525c  prefixlen 64  scopeid 0x20<link>
        ether d8:cb:8a:14:52:5c  txqueuelen 1000  (Ethernet)
        RX packets 1557761  bytes 270586108 (270.5 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1807724  bytes 1169783004 (1.1 GB)
        TX errors 6  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2160  bytes 251005 (251.0 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2160  bytes 251005 (251.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        
        
            C:\Users\Alexander>ipconfig -all

        Настройка протокола IP для Windows

        Имя компьютера  . . . . . . . . . : DESKTOP-2NDD2P9
        Основной DNS-суффикс  . . . . . . :
        Тип узла. . . . . . . . . . . . . : Гибридный
       IP-маршрутизация включена . . . . : Нет
       WINS-прокси включен . . . . . . . : Нет

       Адаптер Ethernet Ethernet:

       DNS-суффикс подключения . . . . . :
       Описание. . . . . . . . . . . . . : Intel(R) 82579LM Gigabit Network Connection
       Физический адрес. . . . . . . . . : 00-21-86-2A-CD-8B
       DHCP включен. . . . . . . . . . . : Нет
       Автонастройка включена. . . . . . : Да
       IPv4-адрес. . . . . . . . . . . . : 10.27.4.201(Основной)
       Маска подсети . . . . . . . . . . : 255.255.255.0
       Основной шлюз. . . . . . . . . : 10.27.4.10
       DNS-серверы. . . . . . . . . . . : 213.135.97.131
       NetBios через TCP/IP. . . . . . . . : Включен
       
   ##### 2 Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
   
       LLDP – протокол для обмена информацией между соседними устройствами, позволяет определить к какому порту коммутатора подключен сервер.
       apt install lldpdsystemctl 
       enable lldpd && systemctl start lldpd
       
       root@ubnt:/home/alexander# lldpctl
       -------------------------------------------------------------------------------
       LLDP neighbors:
       -------------------------------------------------------------------------------
       
   ##### 3 Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
   VLAN – виртуальное разделение коммутатора на несколького виртуальных сетей.
   
   Необходимо установить модуль modprobe 8021q 
     sudo modprobe 8021q
     
    vagrant@vagrant:~$ lsmod | grep 8021q
    8021q                  36864  0
    garp                   20480  1 8021q
    mrp                    20480  1 8021q
   
  После этого можно установить пакет vlan и добавить виртуальный интерфейс через vconfig 
   
    vagrant@vagrant:~$ sudo vconfig add eth0 400

    Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!

    RTNETLINK answers: File exists
    vagrant@vagrant:~$ sudo ip link set eth0.400 up
    vagrant@vagrant:~$ sudo ip a add 192.168.1.0/255.255.255.0 dev eth0.400
    vagrant@vagrant:~$ ip addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
     inet 127.0.0.1/8 scope host lo
        valid_lft forever preferred_lft forever
     inet6 ::1/128 scope host
        valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
     link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
     inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
        valid_lft 85707sec preferred_lft 85707sec
     inet6 fe80::a00:27ff:fe59:cb31/64 scope link
        valid_lft forever preferred_lft forever
    3: eth0.400@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
     link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
     inet 192.168.45.5/24 scope global eth0.400
        valid_lft forever preferred_lft forever
     inet 192.168.1.0/24 scope global eth0.400
        valid_lft forever preferred_lft forever
     inet6 fe80::a00:27ff:fe59:cb31/64 scope link
        valid_lft forever preferred_lft forever
        
        
   Так как команда vconfig находится в статусе deprecated добавить виртуальный интерфейс через ip  
   
    vagrant@vagrant:~$ sudo ip link add link eth0 name eth0.401 type vlan id 401
    vagrant@vagrant:~$ sudo ip link set eth0.401 upsudo ip link set eth0.401 up
    vagrant@vagrant:~$ sudo ip a add 192.168.1.0/255.255.255.0 dev eth0.401
    vagrant@vagrant:~$ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
     link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
     inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85510sec preferred_lft 85510sec
     inet6 fe80::a00:27ff:fe59:cb31/64 scope link
       valid_lft forever preferred_lft forever
    3: eth0.401@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
     link/ether 08:00:27:59:cb:31 brd ff:ff:ff:ff:ff:ff
     inet 192.168.1.0/24 scope global eth0.401
       valid_lft forever preferred_lft forever

#### 4 Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

  В Linux существуют Team и Bonding. Балансировка нагрузки осуществляется в следующих режимах 
   
   0 - balance-rr - (round-robin)

    1 - active-backup

    2 - balance-xor

    3 - broadcast

    4 - 802.3ad - (dynamic link aggregation)

    5 - balance-tlb - (adaptive transmit load balancing)

    6 - balance-alb - (adaptive load balancing)
    
  Конфиг
  
     vagrant@vagrant:~$ sudo vim /etc/netplan/01-netcfg.yaml
     network:
     version: 2
     ethernets:
       eth0:
       dhcp4: true
        eth1:
        dhcp4: no
        eth2:
         dhcp4: no
     bonds:
     bond0:
      addresses: [192.168.10.5/24]
      interfaces: [eth1, eth2]
      parameters:
      mode: balance-rr
      
    vagrant@vagrant:~$ sudo netplan apply
    vagrant@vagrant:~$ ip a show bond0
    5: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
      link/ether 0a:20:6c:5c:14:43 brd ff:ff:ff:ff:ff:ff
      inet 192.168.10.5/24 brd 192.168.10.255 scope global bond0
         valid_lft forever preferred_lft forever
      inet6 fe80::820:6cff:fe5c:1443/64 scope link
         valid_lft forever preferred_lft forever
    

  5 Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24. 
   
   10.10.10.0/29
   10.10.10.8/29
   10.10.10.16/29
   10.10.10.24/29
   10.10.10.32/29
   10.10.10.40/29
   10.10.10.48/29
   10.10.10.56/29
   10.10.10.64/29
   10.10.10.72/29
   10.10.10.80/29
   10.10.10.88/29
   10.10.10.96/29
   
   
   ##### 6 Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
   
   100.64.0.0/26
   
   ##### 7 Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
   
  Ubuntu
  
     ip neighbour show - показать ARP таблицу
     ip neighbour del [ip address] dev [interface] - удалить из ARP таблицы конкретный адрес
     ip neighbour flush all - очищает таблицу ARP

  Windows
  
     arp -a - показать ARP таблицу
     arp -d * - очистить таблицу ARP
     arp -d [ip address] - удалить из ARP таблицы конкретный адрес \
     
     
   
   


   
   
       

