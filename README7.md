### Домашнее задание к занятию  Компьютерные сети, лекция 1
##### 1  Отправьте HTTP запрос

 В ответ пришел ответ ошибка сервера 403 Forbidden означает ограничение или отсутствие доступа к материалу на странице, которую мы пытались загрузить

    root@ubnt:/home/alexander# telnet stackoverflow.com 80
    Trying 151.101.65.69...
    Connected to stackoverflow.com.
    Escape character is '^]'.
    GET /questions HTTP/1.0
    HOST: stackoverflow.com

    HTTP/1.1 403 Forbidden
    Connection: close
    Content-Length: 1926
    Server: Varnish
    Retry-After: 0
    Content-Type: text/html
    Accept-Ranges: bytes
    Date: Tue, 24 Jan 2023 17:29:10 GMT
    Via: 1.1 varnish
    X-Served-By: cache-hel1410032-HEL
    X-Cache: MISS
    X-Cache-Hits: 0
    X-Timer: S1674581351.875493,VS0,VE1
    X-DNS-Prefetch-Control: off
    
   #### 2 Повторите задание 1 в браузере, используя консоль разработчика F12
   
   status 200 ok
   
![Screenshot from 2023-01-24 17-37-11](https://user-images.githubusercontent.com/119140245/214373651-177686ef-9bbf-434c-bad5-6db08c09087b.png)



Страница загрузилась за 9.54с, самый долгий запрос - гугл статистика  762мс.

![Screenshot from 2023-01-24 17-47-54](https://user-images.githubusercontent.com/119140245/214373676-c5aac3f7-4558-466b-b8f1-b42847f36de5.png)


### 3. Какой IP адрес у вас в интернете?

    root@ubnt:/home/alexander# dig @resolver4.opendns.com myip.opendns.com

    ; <<>> DiG 9.18.4-2ubuntu2-Ubuntu <<>> @resolver4.opendns.com myip.opendns.com
    ; (1 server found)
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15278
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 4096
    ;; QUESTION SECTION:
    ;myip.opendns.com.              IN      A

    ;; ANSWER SECTION:
    myip.opendns.com.       0       IN      A       188.186.X.X

    ;; Query time: 56 msec
    ;; SERVER: 208.67.220.222#53(resolver4.opendns.com) (UDP)
    ;; WHEN: Tue Jan 24 18:18:46 UTC 2023
    ;; MSG SIZE  rcvd: 61

#### 4 Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois

Адрес пренадлежит оператору ЭР телеком 

     root@ubnt:/home/alexander# whois 188.186.X.X  | grep ^org-name
     org-name:       JSC "ER-Telecom Holding" Orenburg branch
     org-name:       JSC "ER-Telecom Holding" Orenburg branch
     
     
      root@ubnt:/home/alexander# whois 188.186.238.159  | grep ^origin
      origin:         AS42683

Номер AS:  AS42683


#### 5.Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой traceroute

Пакет проходит через 3 AS AS42683 AS15169 AS263411

     traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
     1  10.10.0.1 [*]  0.562 ms  0.586 ms  0.631 ms
     2  * * *
     3  91.144.137.194 [AS42683]  1.793 ms  1.834 ms  1.861 ms
     4  72.14.215.165 [AS15169]  26.340 ms  26.331 ms  29.772 ms
     5  72.14.215.166 [AS15169]  25.343 ms  25.433 ms  25.325 ms
     6  * * *
     7  108.170.250.129 [AS15169]  26.643 ms  26.570 ms 108.170.250.33 [AS15169]  25.278 ms
     8  108.170.250.146 [AS15169]  25.912 ms 108.170.250.34 [AS15169]  26.591 ms 108.170.250.113 [AS15169]  24.841 ms
     9  142.250.238.214 [AS15169]  48.501 ms 72.14.234.20 [AS15169]  45.912 ms 142.251.237.156 [AS15169]  38.353 ms
    10  72.14.232.190 [AS15169]  40.786 ms 142.250.235.74 [AS15169]  40.623 ms 172.253.65.159 [AS15169]  40.367 ms
    11  216.239.63.27 [AS15169]  39.096 ms 142.250.209.171 [AS15169]  40.753 ms 172.253.64.51 [AS15169]  42.640 ms
    12  * * *
    13  * * *
    14  * * *
    15  * * *
    16  * * *
    17  * * *
    18  * 8.8.8.8 [AS15169/AS263411]  41.337 ms *
    root@ubnt:/home/alexander#

AS принадлежат моему провайдеру, ЭРтелеком  и Google.



      root@ubnt:/home/alexander#
      $ grep org-name <(whois AS12668)
      org-name:       JSC "ER-Telecom Holding"
      $ grep org-name <(whois AS8359)
      org-name:       JSC "ER-Telecom Holding"
      $ grep OrgName <(whois AS15169)
      OrgName:        Google LLC



##### 6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?



Дольше всех отвечает 10-ый хоп: AS15169 216.239.49.113


      root@ubnt:/home/alexander# mtr 8.8.8.8 -znrc 1
      Start: 2023-01-24T18:44:43+0000
      HOST: ubnt                        Loss%   Snt   Last   Avg  Best  Wrst StDev
      1. AS???    10.10.0.1            0.0%     1    0.6   0.6   0.6   0.6   0.0
      2. AS42683  188.186.251.252      0.0%     1    0.9   0.9   0.9   0.9   0.0
      3. AS42683  91.144.137.194       0.0%     1    1.0   1.0   1.0   1.0   0.0
      4. AS15169  72.14.215.165        0.0%     1   25.3  25.3  25.3  25.3   0.0
      5. AS15169  72.14.215.166        0.0%     1   24.3  24.3  24.3  24.3   0.0
      6. AS15169  108.170.250.129      0.0%     1   26.3  26.3  26.3  26.3   0.0
      7. AS15169  108.170.250.146      0.0%     1   30.5  30.5  30.5  30.5   0.0
      8. AS15169  142.250.239.64       0.0%     1   45.9  45.9  45.9  45.9   0.0
      9. AS15169  172.253.66.110       0.0%     1   38.8  38.8  38.8  38.8   0.0
     10. AS15169  216.239.49.113       0.0%     1   46.4  46.4  46.4  46.4   0.0
     11. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     12. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     13. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     14. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     15. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     16. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     17. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     18. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     19. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     20. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     21. AS???    ???                 100.0     1    0.0   0.0   0.0   0.0   0.0
     22. AS15169  8.8.8.8              0.0%     1   37.6  37.6  37.6  37.6   0.0
     root@ubnt:/home/alexander#




#### 7 Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig

NS1-4

    root@ubnt:/home/alexander# dig +short NS dns.google
    ns2.zdns.google.
    ns4.zdns.google.
    ns3.zdns.google.
    ns1.zdns.google.
  
    А
  
  
    root@ubnt:/home/alexander# dig +short A dns.google
    8.8.4.4
    8.8.8.8



#### 8 Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig

  В обоих случаях dns.google.

    root@ubnt:/home/alexander# for ip in `dig +short A dns.google`; do dig -x $ip | grep ^[0-9].*in-addr; done
    4.4.8.8.in-addr.arpa.   44282   IN      PTR     dns.google.
    8.8.8.8.in-addr.arpa.   44664   IN      PTR     dns.google.
    root@ubnt:/home/alexander#



