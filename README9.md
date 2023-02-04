   ### Домашнее задание к занятию "Компьютерные сети, лекция 3
   
   
   ###### 1 Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

    route-views>show ip route 188.186.238.159
    Routing entry for 188.186.192.0/18
    Known via "bgp 6447", distance 20, metric 0
    Tag 6939, type external
    Last update from 64.71.137.241 16:32:23 ago
    Routing Descriptor Blocks:
    * 64.71.137.241, from 64.71.137.241, 16:32:23 ago
    Route metric is 0, traffic share count is 1
    AS Hops 3
    Route tag 6939
    MPLS label: none

##### 2 Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.


     alexander@ubnt:~$ ip a show type dummy
    3: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
     link/ether 06:34:d8:a4:6c:06 brd ff:ff:ff:ff:ff:ff
     inet 192.168.70.2/24 scope global dummy0
        valid_lft forever preferred_lft forever
     inet6 fe80::dacb:8aff:fe14:525c /64 scope link
       valid_lft forever preferred_lft forever
    alexander@ubnt:~$ sudo ip route add 192.168.40.0/24 via 10.0.2.1
    alexander@ubnt:~$ sudo ip route add 192.168.40.0/24 dev eth0
    alexander@ubnt:~$ ip -br route
     default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
     10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
     10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
     192.168.40.0/24 via 10.0.2.1 dev eth0
    192.168.70.0/24 dev dummy0 proto kernel scope link src 192.168.70.2
   
   ##### 3 Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
   
    alexander@ubnt:~$ sudo ss -ltpn
    State      Recv-Q     Send-Q           Local Address:Port            Peer Address:Port     Process
    LISTEN     0          4096                127.0.0.54:53                   0.0.0.0:*         users:(("systemd-resolve",pid=200833,fd=16))
    LISTEN     0          151                  127.0.0.1:3306                 0.0.0.0:*         users:(("mysqld",pid=262790,fd=23))
    LISTEN     0          32                   127.0.0.1:5905                 0.0.0.0:*         users:(("VBoxHeadless",pid=205353,fd=25))
    LISTEN     0          4096                   0.0.0.0:111                  0.0.0.0:*         users:(("rpcbind",pid=200819,fd=4),("systemd",pid=1,fd=333))
    LISTEN     0          70                   127.0.0.1:33060                0.0.0.0:*         users:(("mysqld",pid=262790,fd=21))
    LISTEN     0          10                   127.0.0.1:2222                 0.0.0.0:*         users:(("VBoxHeadless",pid=205353,fd=22))
    LISTEN     0          4096             127.0.0.53%lo:53                   0.0.0.0:*         users:(("systemd-resolve",pid=200833,fd=14))
    LISTEN     0          128                  127.0.0.1:631                  0.0.0.0:*         users:(("cupsd",pid=454929,fd=7))
    LISTEN     0          2                        [::1]:3350                    [::]:*         users:(("xrdp-sesman",pid=211911,fd=11))
    LISTEN     0          4096                      [::]:111                     [::]:*         users:(("rpcbind",pid=200819,fd=6),("systemd",pid=1,fd=335))
    LISTEN     0          4096                         *:22                         *:*         users:(("sshd",pid=200837,fd=3),("systemd",pid=1,fd=339))
    LISTEN     0          32                        [::]:5900                    [::]:*         users:(("VBoxHeadless",pid=205353,fd=26))
    LISTEN     0          128                      [::1]:631                     [::]:*         users:(("cupsd",pid=454929,fd=6))
    LISTEN     0          2                            *:3389                       *:*         users:(("xrdp",pid=211921,fd=11))

3389-RDP
53 - DNS
22 - SSH
   
   ##### 4 Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порт
   
     alexander@ubnt:~$ sudo ss -lupn
    State    Recv-Q   Send-Q                          Local Address:Port      Peer Address:Port  Process
    UNCONN   0        0                                  127.0.0.54:53             0.0.0.0:*      users:(("systemd-resolve",pid=200833,fd=15))
    UNCONN   0        0                               127.0.0.53%lo:53             0.0.0.0:*      users:(("systemd-resolve",pid=200833,fd=13))
    UNCONN   0        0                          10.10.0.105%enp2s0:68             0.0.0.0:*      users:(("systemd-network",pid=200835,fd=18))
    UNCONN   0        0                                     0.0.0.0:111            0.0.0.0:*      users:(("rpcbind",pid=200819,fd=5),("systemd",pid=1,fd=334))
    UNCONN   0        0                                     0.0.0.0:631            0.0.0.0:*      users:(("cups-browsed",pid=454932,fd=7))
    UNCONN   0        0                                     0.0.0.0:5353           0.0.0.0:*      users:(("avahi-daemon",pid=744,fd=12))
    UNCONN   0        0                                     0.0.0.0:34455          0.0.0.0:*      users:(("avahi-daemon",pid=744,fd=14))
    UNCONN   0        0                                        [::]:111               [::]:*      users:(("rpcbind",pid=200819,fd=7),("systemd",pid=1,fd=336))
    UNCONN   0        0                                        [::]:47494             [::]:*      users:(("avahi-daemon",pid=744,fd=15))
    UNCONN   0        0          [fe80::dacb:8aff:fe14:525c]%enp2s0:546               [::]:*      users:(("systemd-network",pid=200835,fd=21))
    UNCONN   0        0                                        [::]:5353              [::]:*      users:(("avahi-daemon",pid=744,fd=13))

   
   
   
