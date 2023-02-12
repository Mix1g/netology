
  ###### 1 Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
  
  
  
  
![sysadmin-39-bitwarden](https://user-images.githubusercontent.com/119140245/218298017-347f592d-b1ca-4c28-8af5-f9f13243e999.png)




 
   ##### 2 Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
   
   
 
 ![sysadmin-39-bitwarden-g-auth](https://user-images.githubusercontent.com/119140245/218298074-aa30e509-b4cd-47e9-b615-7cb751972aea.png)





   ##### 3 Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.  





![sysadmin-39-apache-ssl](https://user-images.githubusercontent.com/119140245/218298114-af187cb7-f606-449e-a8e6-0bdaa6dfdcb5.png)














    root@debian:/home/alexander# sudo systemctl status apache2
    ● apache2.service - The Apache HTTP Server
     Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor prese>
     Active: active (running) since Sun 2023-02-12 08:56:07 MSK; 11s ago
       Docs: https://httpd.apache.org/docs/2.4/
    Main PID: 1497 (apache2)
      Tasks: 55 (limit: 2294)
     Memory: 8.8M
        CPU: 28ms
     CGroup: /system.slice/apache2.service
             ├─1497 /usr/sbin/apache2 -k start
             ├─1499 /usr/sbin/apache2 -k start
             └─1500 /usr/sbin/apache2 -k start

    root@debian:~$ sudo a2enmod ssl
    root@debian:~$ sudo systemctl restart apache2
    root@debian:~$ sudo openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key \
    -out /etc/ssl/certs/apache-selfsigned.crt
    Generating a RSA private key
    .....+++++
    ..................................................................................................................................+++++
    writing new private key to '/etc/ssl/private/apache-selfsigned.key'
    -----
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
     Country Name (2 letter code) [AU]:RU
     State or Province Name (full name) [Some-State]:Example
     Locality Name (eg, city) []:Example
     Organization Name (eg, company) [Internet Widgits Pty Ltd]:Example
     Organizational Unit Name (eg, section) []:
     Common Name (e.g. server FQDN or YOUR name) []:10.5.5.5
     Email Address []:test@example.com
     root@debian:~$ sudo nano /etc/apache2/sites-available/10.5.5.5.conf

    <VirtualHost *:443>
    ServerName 10.5.5.5
    DocumentRoot /var/www/10.5.5.5

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
    </VirtualHost>
    
    Проверяем на другом сервере
    
     vagrant@ubnt:~$ curl --insecure -v https://10.5.5.5
     *   Trying 10.5.5.5:443...
     * Connected to 10.5.5.5 (10.5.5.5) port 443 (#0)
     * ALPN, offering h2
     * ALPN, offering http/1.1
     * successfully set certificate verify locations:
     *  CAfile: /etc/ssl/certs/ca-certificates.crt
     *  CApath: /etc/ssl/certs
     * TLSv1.3 (OUT), TLS handshake, Client hello (1):
     * TLSv1.3 (IN), TLS handshake, Server hello (2):
     * TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
     * TLSv1.3 (IN), TLS handshake, Certificate (11):
     * TLSv1.3 (IN), TLS handshake, CERT verify (15):
     * TLSv1.3 (IN), TLS handshake, Finished (20):
     * TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
     * TLSv1.3 (OUT), TLS handshake, Finished (20):
     * SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
     * ALPN, server accepted to use http/1.1
     * Server certificate:
     *  subject: C=RU; ST=Example; L=Example; O=Example; CN=10.5.5.5; emailAddress=test@example.com
     *  start date: Feb 12 9:08:34 2023 GMT
     *  expire date: Feb 12 9:08:34 2024 GMT
     *  issuer: C=RU; ST=Example; L=Example; O=Example; CN=10.5.5.5; emailAddress=test@example.com
     *  SSL certificate verify result: self signed certificate (18), continuing anyway.
     > GET / HTTP/1.1
     > Host: 10.5.5.5
     > User-Agent: curl/7.74.0
     > Accept: */*
     >
     * TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
     * TLSv1.3 (IN), TLS handshake, Newsession Ticket (4):
     * old SSL session ID is stale, removing
     * Mark bundle as not supporting multiuse
     < HTTP/1.1 200 OK
     < Date: Sat,  Feb 2023 9:05:40 GMT
     < Server: Apache/2.4.48 (Ubuntu)
     < Last-Modified: Sat, 12 Feb 2023 09:04:50 GMT
     < ETag: "14-5d6b9bbc20d84"
     < Accept-Ranges: bytes
     < Content-Length: 20
     < Content-Type: text/html
     <
     <h1>it worked!</h1>
     * Connection #0 to host 10.5.5.5 left intact
     
 ##### 4Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).
     
      vagrant@ubnt:~/testssl.sh$ ./testssl.sh -U --sneaky https://netology.ru/
      Testing vulnerabilities

      Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
      CCS (CVE-2014-0224)                       not vulnerable (OK)
      Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session tickets
      ROBOT                                     not vulnerable (OK)
      Secure Renegotiation (RFC 5746)           OpenSSL handshake didn't succeed
      Secure Client-Initiated Renegotiation     not vulnerable (OK)
      CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
      
      
   ##### 5Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
     
     
      vagrant@ubnt:~$ systemctl status sshd.service
      ● ssh.service - OpenBSD Secure Shell server
      Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
      Active: active (running) since Sat 2023-02-12 10:20:55 UTC; 49min ago
        Docs: man:sshd(8)
              man:sshd_config(5)
    Main PID: 874 (sshd)
       Tasks: 1 (limit: 1081)
      Memory: 4.6M
         CPU: 107ms
      CGroup: /system.slice/ssh.service
             └─874 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
             
     vagrant@ubnt:~$ ssh-keygen
     Generating public/private rsa key pair.
     Enter file in which to save the key (/home/vagrant/.ssh/id_rsa):
     Enter passphrase (empty for no passphrase):
     Enter same passphrase again:
     Your identification has been saved in /home/vagrant/.ssh/id_rsa
     Your public key has been saved in /home/vagrant/.ssh/id_rsa.pub
     The key fingerprint is:
     SHA256:YLewM0tSXiENKfpYs4QnT3L6Qp6q3sbNEcvkPw52Amc vagrant@linux1
     The key's randomart image is:
     +---[RSA 3072]----+
     |      o+.        |
     |    . ....       |
     |   o .= o        |
     |  = B* * .       |
     |   #=EO S        |
     |  + BB +         |
     | o.oo++.         |
     |  =ooo+o         |
     |=o.o  ...        |
     +----[SHA256]-----+

      vagrant@ubnt:~$ ssh-copy-id vagrant@10.5.5.5

      /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/vagrant/.ssh/id_rsa.pub"
      The authenticity of host '10.5.5.5 (10.5.5.5)' can't be established.
      ECDSA key fingerprint is SHA256:/rZjeIEeI4GXObGdc6iTj7LjwLh3TA1bwOPXEHLrkaM.
     Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
      /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
      /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
     vagrant@10.5.5.5's password:

     Number of key(s) added: 1

     Now try logging into the machine, with:   "ssh 'vagrant@10.5.5.5'"
     and check to make sure that only the key(s) you wanted were added.

     vagrant@ubnt:~$ ssh vagrant@10.5.5.5
     Welcome to Ubuntu 22.10 (GNU/Linux 5.13.0-22-generic x86_64)

      * Documentation:  https://help.ubuntu.com
      * Management:     https://landscape.canonical.com
      * Support:        https://ubuntu.com/advantage

      System information as of Sat Feb 10:12:03 PM UTC 2023

      System load:  0.0                Processes:             113
      Usage of /:   16.6% of 25.83GB   Users logged in:       1
      Memory usage: 10%                IPv4 address for eth0: 10.0.2.15
      Swap usage:   0%                 IPv4 address for eth1: 10.5.5.5


      This system is built by the Bento project by Chef Software
      More information can be found at https://github.com/chef/bento
      Last login: Sat Feb 12 10:26:12 2022 from 10.0.2.2

##### 6 Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

     vagrant@ubnt:~$ mv /home/vagrant/.ssh/id_rsa /home/vagrant/.ssh/linux2_rsa
     vagrant@ubnt:~$ touch ~/.ssh/config && chmod 600 ~/.ssh/config
     vagrant@ubnt:~$ nano .ssh/config

     Host linux2
      HostName 10.5.5.5
      User vagrant
      IdentityFile ~/.ssh/linux2_rsa
     
     vagrant@ubnt:~$ ssh linux2
     Welcome to Ubuntu 22.10 (GNU/Linux 5.13.0-22-generic x86_64)

     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage

     System information as of Sat Feb 12 10:21:15 PM UTC 2023

       System load:  0.0                Processes:             113
       Usage of /:   16.6% of 25.83GB   Users logged in:       1
       Memory usage: 10%                IPv4 address for eth0: 10.0.2.15
       Swap usage:   0%                 IPv4 address for eth1: 10.5.5.5


       This system is built by the Bento project by Chef Software
       More information can be found at https://github.com/chef/bento
       Last login: Sat Feb 29 10:12:03 2023 from 10.5.5.2
       
       
 ##### 7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
 
    root@ubnt:~# tcpdump -nnei any -c 100 -w node4-100packets.pcap
    tcpdump: listening on any, link-type LINUX_SLL (Linux cooked v1), capture size 262144 bytes
    100 packets captured
    106 packets received by filter
     0 packets dropped by kernel
   
   
   ![krVTMM6](https://user-images.githubusercontent.com/119140245/218298211-cb4a923e-3c4f-4321-80d9-f58b2901b38e.png)
   
   
   ##### 8 Просканируйте хост scanme.nmap.org. Какие сервисы запущены?
   
     Запущены ssh, web-сервер, сервер nping-echo. Открытый порт 31337
   
   
     root@ubnt:~# nmap scanme.nmap.org
     Starting Nmap 7.80 ( https://nmap.org ) at 2023-02-12 11:02 UTC
     Nmap scan report for scanme.nmap.org (45.33.32.156)
     Host is up (0.21s latency).
     Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f
     Not shown: 996 closed ports
     PORT      STATE SERVICE
     22/tcp    open  ssh
     80/tcp    open  http
     9929/tcp  open  nping-echo
     31337/tcp open  Elite

     Nmap done: 1 IP address (1 host up) scanned in 3.86 seconds
   
   ##### 9 Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443


    root@ubnt:~# ufw status verbose
    Status: active
    Logging: on (low)
    Default: deny (incoming), allow (outgoing), disabled (routed)
    New profiles: skip

    To                         Action      From
    --                         ------      ----
    22/tcp                     ALLOW IN    Anywhere
    80,443/tcp (Apache Full)   ALLOW IN    Anywhere
    22/tcp (v6)                ALLOW IN    Anywhere (v6)
    80,443/tcp (Apache Full (v6)) ALLOW IN    Anywhere (v6)
 
 
