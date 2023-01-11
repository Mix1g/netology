##### 1 Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter
    vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
    [Unit]
    Description=Node Exporter

    [Service]
    EnvironmentFile=/etc/default/node_exporter
    ExecStart=/usr/bin/node_exporter $OPTIONS

    [Install]
    WantedBy=multi-user.target

    vagrant@vagrant:~$ cat /etc/default/node_exporter 
    OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector" 
    
    
    
    
  *Процесс  стартует, завершается, перезапускается*
    

    vagrant@vagrant:~$ sudo systemctl status node_exporter
    node_exporter.service - Node Exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
         Active: active (running) since Sun 2023-01-11 11:44:55 UTC; 4s ago
       Main PID: 900 (node_exporter)
          Tasks: 4 (limit: 1071)
         Memory: 2.3M
         CGroup: /system.slice/node_exporter.service
                 └─900 /usr/bin/node_exporter --collector.textfile.directory /var/lib/node_exporter/textfile_collector

    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=thermal_zone
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=time
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=timex
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=udp_queues
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=uname
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=vmstat
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=xfs
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:115 level=info collector=zfs
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
    Jan 11 11:44:55 vagrant node_exporter[900]: ts=2023-01-11T11:44:55.026Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false

    vagrant@vagrant:~$ ps -e |grep node_exporter
        900 ?        00:00:00 node_exporter
    
    vagrant@vagrant:~$ sudo cat /proc/900/environ
    LANG=en_US.UTF-   8LANGUAGE=en_US:PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binINVOCATION_ID=468effef990c42ab846feabdd52e5734JOURNAL_STREAM=9:25903OPTIONS=--collector.textfile.directory /var/lib/node_exporter/textfile_collector
    
    
   ##### 2 Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети
   *Для CPU*
   
    node_cpu_seconds_total{cpu="0",mode="idle"}
    node_cpu_seconds_total{cpu="0",mode="system"}
    node_cpu_seconds_total{cpu="0",mode="user"}
    process_cpu_seconds_total
    
    
   *Для ОЗУ*
    
    
    node_memory_MemAvailable_bytes
    node_memory_MemFree_bytes
    node_memory_Buffers_bytes
    node_memory_Cached_bytes
    
    
  *По дискам*
  
  
    node_disk_io_time_seconds_total{device="sda"}
    node_disk_read_time_seconds_total{device="sda"}
    node_disk_write_time_seconds_total{device="sda"}
    node_filesystem_avail_bytes
    
   *По сети*
   
    node_network_info
    node_network_receive_bytes_total
    node_network_receive_errs_total
    node_network_transmit_bytes_total
    node_network_transmit_errs_total
    
    
   ##### 3 Установите в свою виртуальную машину Netdata
   
    vagrant@vagrant:~$ sudo ss -tulpn | grep :19999
    tcp    LISTEN   0        4096              0.0.0.0:19999          0.0.0.0:*      users:(("netdata",pid=2147,fd=4))
   
   
   ##### 4 Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
   
       vagrant@vagrant:~$ dmesg | grep -i virtual
    [    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
    [    0.003991] CPU MTRRs all blank - virtualized system.
    [    0.120325] Booting paravirtualized kernel on KVM
    [    2.596500] systemd[1]: Detected virtualization oracle.
    
   ##### 5 Как настроен sysctl fs.nr_open на системе по-умолчанию?
   
       vagrant@vagrant:~$ /sbin/sysctl -n fs.nr_open
       1048576
       
   nr_open - означает максимальное число дескрипторов, которые может использовать процесс. Но этого значения не дает достичь другой лимит
       
    vagrant@vagrant:~$ ulimit -n
    1024     
       
  ##### 6 Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter.
  
    vagrant@vagrant:~$ sudo unshare -f --pid --mount-proc sleep 1h
    vagrant@vagrant:~$ ps -aux | grep sleep
    root        2517  0.0  0.4  11864  4624 pts/1    S+   12:02   0:00 sudo unshare -f --pid --mount-proc sleep 1h
    root        2518  0.0  0.0   8080   592 pts/1    S+   12:02   0:00 unshare -f --pid --mount-proc sleep 1h
    root        2519  0.0  0.0   8076   580 pts/1    S+   12:02   0:00 sleep 1h

    vagrant@vagrant:~$ sudo nsenter --target 2519 --pid --mount
    root@vagrant:/# ps aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.0   8076   580 pts/1    S+   12:02   0:00 sleep 1h
    root           2  0.0  0.4   9836  4144 pts/2    S    12:05   0:00 -bash
    root          11  0.0  0.3  11492  3292 pts/2    R+   12:05   0:00 ps aux
    
  ##### 7 Найдите информацию о том, что такое    
      :(){ :|:& };:.
      
      
  Это fork bomb Её можно переписать в виде
  
  
      :(){
      :|:&
      };:

     или

     bomb() { 
     bomb | bomb &
     }; bomb
  
  
Данная функция рекурсивно вызывает себя и передается через пайп другому вызову этой же функции (в фоне). По сути запускаются 2 фоновых процесса, каждый из которых вызывает еще два фоновых процесса и тд, пока не закончатся ресурсы.

Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

    [ 5667.545996] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-6.scope

    vagrant@vagrant:~$ ulimit -u
    3571


Данная команда выводит количество возможных одновременно запущенных процессов. Изменяя этот параметр, можно защититься от fork bomb (упремся в потолок количества процессов для пользователя, но ресурсы не будут утилизированы полностью)

    ulimit -u 500
    
Данной командой можно уменьшить порог процессов до 500

