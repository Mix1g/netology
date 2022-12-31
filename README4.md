# 1 Какой системный вызов делает команда cd?

chdir("/tmp")                           = 0

# 2 Используя strace выясните, где находится база данных file, на основании которой она делает свои догадки.

Команда file пыталась обратиться к файлам, но они не существуют

/home/vagrant/.magic.mgc
/home/vagrant/.magic
/etc/magic.mgc


Далее было обращение к


/etc/magic
/usr/share/misc/magic.mgc

# 3 Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или простоперезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).


Сделать Truncate

echo ""| sudo tee /proc/PID/fd/DESCRIPTOR,

где PID - это PID процесса, который записывает в удаленный файл, а DESRIPTOR - дескриптор, удаленного файла.

Например,

exec 5> output.file

ping localhost >&5

rm output.file

vagrant@vagrant:~$ sudo lsof | grep deleted

ping      1580                       vagrant    1w      REG              253,0   865859     131084 /home/vagrant/output.file (deleted)


ping      1580                       vagrant    5w      REG              253,0   865859     131084 /home/vagrant/output.file (deleted)



echo ""| tee /proc/1580/fd/5


  # 4 Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
  
  Зомби-процессы не занимают какие-либо системные ресурсы, но сохраняют свой ID процесса (есть риск исчерпания доступных идентификаторов)
  
  # 5 На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты?
  
  vagrant@vagrant :~$ sudo opensnoop-bpfcc
  
PID    COMM               FD ERR PATH

785    vminfo              4   0 /var/run/utmp

577    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services

577    dbus-daemon        18   0 /usr/share/dbus-1/system-services

577    dbus-daemon        -1   2 /lib/dbus-1/system-services

577    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/

# 6 Какой системный вызов использует uname -a? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в /proc, где можно узнать версию ядра и релиз ОС.

Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

# 7 Чем отличается последовательность команд через ; и через && в bash?


; - выполелнение команд последовательно

&& - команда после && выполняется только если команда до && завершилась успешно (статус выхода 0)


test -d /tmp/some_dir && echo Hi - так как каталога /tmp/some_dir не существует, то статус выхода не равен 0 и echo Hi не будет выполняться


Есть ли смысл использовать в bash &&, если применить set -e?

set -e - останавливает выполнение скрипта при ошибке. Я думаю, в скриптах имеет смысл применять set -e с &&, так как она прекращает действие скрипта (не игнорирует ошибку) при ошибке в команде после && Например,

echo Hellow && test -d /tmp/some_dir; echo Bye-Bae

Без set -e скрипт выполнит echo Bye, а без этой команды - нет


# 8 Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?

-e  Exit immediately if a command exits with a non-zero status.

-u  Treat unset variables as an error when substituting.

-x  Print commands and their arguments as they are executed.

-o pipefail     the return value of a pipeline is the status of

                           the last command to exit with a non-zero status,
                           
                           or zero if no command exited with a non-zero status

# 9 Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе. В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

vagrant@vagrant:~$ ps -d -o stat | sort | uniq -c

7 I

40 I<

1 R+

25 S

2 S+

1 Sl

2 SN
 
 
                <   high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and
                    custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL
                    pthreads do)
               +    is in the foreground process group
