### Задача 1

##### Опишите своими словами основные преимущества применения на практике IaaC паттернов.

##### Преимущества IaaC:

1 Скорость. Конфигурирование инфраструктуры занимает меньше времени. Рутиные задачи автоматизируются, что позволяет минимизировать человеский фактор.

2 Масштабируемость. Развернуть идентичную конфигурацию можно на большом количестве сред.

3 Безопасность. Аудит безопасности можно проводить на файлах конфигурации, а не в ручную на различных системах

4 Возможность отката на предыдущую версию. В случае ошибок, файлы конфигурации хранятся в системе контроля версии и их с легкостью можно откатить до последней рабочей версии

5 Возможность быстрого восстановления инфраструктуры. В аварийных ситуациях не нужно тратить время на ручной разворот инфраструктуры. Это сокращает время простоя и экономит деньги для бизнеса

6 Документация. Описанный код легко может понять новый сотрудник, в результате чего время адаптации уменьшается. Также описанный код делает инфраструктуру прозрачной как для команды администрирования, так и для разработчиков

7 Идентичность инфраструктуры. IaaC гарантирует, что в различных средах конфигурация будет одинаковой. Это минимизирует вероятность возникновения ошибок, когда в одной среде код работает и проходит все тесты, а в другой нет.

##### Какой из принципов IaaC является основополагающим?

Идемпотетность. То есть мы получаем одинаковый результат при повторных выполнениях операций.

### Задача 2

##### Чем Ansible выгодно отличается от других систем управление конфигурациями?

1 Использование существующей инфраструктуры SSH. Нет необходимости установки дополнительных агентов

2 Легкость описывания конфигурации. Для описывания конфигурации используется YAML, который удобно читать и его легче освоить

3 Большое количество готовых модулей, которые можно использовать из коробки. Ansible написан на Python, поэтому написание новых модулей гораздо легче, чем на других системах

##### Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

На мой взгляд наиболее надежный метод - Push. При этом методе есть централизованная точка распространения, из который можно следить за ходом выполнения доставки. Нет необходимости мониторить состояние агентов на удаленных серверах.

### Задача 3

`root@Lenovo:/home/alexander# VBoxManage -v 6.1.38_Ubuntur153438`

`root@Lenovo:/home/alexander# vagrant -v Vagrant 2.2.19`

`root@Lenovo:/home/alexander# ansible --version ansible [core 2.12.4] config file = None configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules'] ansible python module location = /usr/lib/python3/dist-packages/ansible ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections executable location = /usr/bin/ansible python version = 3.10.7 (main, Nov 24 2022, 19:45:47) [GCC 12.2.0] jinja version = 3.0.3 libyaml = True`

`oot@Lenovo:/home/alexander# terraform -v Terraform v1.4.2 on linux_amd64 root@Lenovo:/home/alexander#`

### Задача 4

```alexander@Lenovo:~/vagrant$
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-144-generic x86_64)Documentation:  https://help.ubuntu.comManagement:     https://landscape.canonical.comSupport:        https://ubuntu.com/advantageSystem information as of Sat 18 Mar 2023 07:30:30 PM UTCSystem load:  1.32               Processes:             167
Usage of /:   12.5% of 30.34GB   Users logged in:       0
Memory usage: 10%                IPv4 address for eth0: 10.0.2.15
Swap usage:   0%Introducing Expanded Security Maintenance for Applications.
Receive updates to over 25,000 software packages with your
Ubuntu Pro subscription. Free for personal use.https://ubuntu.com/proThis system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sat Mar 18 19:24:02 2023 from 10.0.2.2vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
