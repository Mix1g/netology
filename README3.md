# 1 Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей, если считаете, что она могла бы быть другого типа


cd - это shell builtin команда, то есть команда, которая вызывается напрямую в shell, а не как внешняя исполняемая. Если бы она была внешней, то запускалась бы в отдельном процессе и меняла бы директорию для этого процесса (текущий каталог shell оставался бы неизменным).

# 2 Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?


grep <some_string> <some_file> -c

# 3 Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?


systemd

vagrant@vagrant:/var/log$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:01 systemd

vagrant@vagrant:/var/log$ pstree -p
systemd(1)─┬─VBoxService(780)─┬─{VBoxService}(781)
           │                  ├─{VBoxService}(782)
           │                  ├─{VBoxService}(783)
           │                  ├─{VBoxService}(784)
           │                  ├─{VBoxService}(785)
           │                  ├─{VBoxService}(786)
           │                  ├─{VBoxService}(787)
           │                  └─{VBoxService}(788)
           ├─accounts-daemon(584)─┬─{accounts-daemon}(603)
           │                      └─{accounts-daemon}(633)
           ├─agetty(812)
           ├─atd(800)
           ├─cron(796)
           ├─dbus-daemon(585)
           ├─irqbalance(607)───{irqbalance}(618)
           ├─multipathd(533)─┬─{multipathd}(534)
           │                 ├─{multipathd}(535)
           │                 ├─{multipathd}(536)
           │                 ├─{multipathd}(537)
           │                 ├─{multipathd}(538)
           │                 └─{multipathd}(539)
           ├─networkd-dispat(613)
           ├─polkitd(644)─┬─{polkitd}(645)
           │              └─{polkitd}(647)
           ├─rpcbind(560)
           ├─rsyslogd(617)─┬─{rsyslogd}(626)
           │               ├─{rsyslogd}(627)
           │               └─{rsyslogd}(628)
           ├─sshd(804)───sshd(1078)───sshd(1115)───bash(1116)───pstree(1186)
           ├─systemd(1081)───(sd-pam)(1082)
           ├─systemd-journal(367)
           ├─systemd-logind(620)
           ├─systemd-network(401)
           ├─systemd-resolve(561)
           └─systemd-udevd(397)
           
           
           
   # 4 Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
         
         
         ls /root 2>/dev/pts/X,
где /dev/pts/X - псевдотерминал другой сессии


# 5 Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

Да получиться

cat <test1 >test2 

vagrant@vagrant: ~$ cat test0
    
test0 text
    
vagrant@vagrant: ~$ cat test2
    
vagrant@vagrant: ~$ cat <test0 >test2
    
vagrant@vagrant: ~$ cat test2
    
test0 text

 # 6  Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
  
  
  Да
  
echo "test001" > /dev/tty1
  Находясь в tty1, я смог увидеть отправленные данные
  
  # 7   Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
  
  bash 5>&1 - создаем новый дескриптор 5 и перенаправляем его в STDOUT
echo netology > /proc/$$/fd/5 - перенаправляем результат команды в дескриптор 5
  
  
  # 8  Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.
  
         Получится. Для этого нужно "поменять местами STDOUT и STDERR". Для этого применяется конструкция N>&1 1>&2 2>&N (где N - новый промежуточный дескриптор).


vagrant@vagrant: ~$ vagrant@vagrant:~$ ls /var
backups  cache  crash  lib  local  lock  log  mail  opt  run  snap  spool  tmp
vagrant@vagrant: ~$ ls
2  test0  test1  test2  tty1
vagrant@vagrant: ~$ ls /root
ls: cannot open directory '/root': Permission denied
vagrant@vagrant: ~$ (ls /var && ls && ls /root) 3>&1 1>&2 2>&3 | wc -l
backups  cache  crash  lib  local  lock  log  mail  opt  run  snap  spool  tmp
2  test0  test1  test2  tty1
1
  
  В результате получили, что в pipe передается stdout с дескриптором 2 (stderr)
  
  # 9  Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
  
  Выводится список переменных окружения для процесса, под которым выполняется текущая оболочка bash

Аналогичный вывод можно получить с помощью команды printenv
  
  
  # 10 Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.
  
  /proc/[pid]/cmdline - файл только на чтение, который содержит строку запуска процессов, кроме зомби-процессов (строка 236)
/proc/[pid]/exe - сожержит полное имя выполняемого файла для процесса (строка 279)
  
  # 11   Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.
  
  sse 4_2
  
  vagrant@vagrant:~$ grep sse /proc/cpuinfo
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid
sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase avx2 invpcid rdseed clflushopt md_clear flush_l1d
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid
sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm abm 3dnowprefetch invpcid_single pti fsgsbase avx2 invpcid rdseed clflushopt md_clear flush_l1d
  
  
  
  # 12  При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2
  
  По умолчанию при запуске команды через SSH не выделяется TTY. Если же не указывать команды, то TTY будет выдаваться, так как предполагается, что будет запущен сеанс оболочки. Полагаю, что изменить поведение можно через ssh localhost с последующей авторизацией и выполнением 'tty'. Либо через ssh -t localhost 'tty'
  
  
  # 13  Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
  
  
  после правки /proc/sys/kernel/yama/ptrace_scope
  
  
  # 14   sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте? что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.
  
  
  tee - получает значения из stdin и записывает их в stdout и файл. Так как tee запускается отдельным процессом из-под sudo, то получая в stdin через pipe данные от echo - у нее есть права записать в файл.
  
  
  
  
  Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.
