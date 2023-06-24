
## Домашнее задание к занятию 8.3 «Использование Ansible»

### Подготовка к выполнению

1 Подготовьте в Yandex Cloud три хоста: для clickhouse, для vector и для lighthouse. 

2 Репозиторий [LightHouse](https://github.com/VKCOM/lighthouse) находится по ссылке.

## Основная часть

1 Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.

2 При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.

3 Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.

4 Подготовьте свой inventory-файл `prod.yml`.

делаем из шаблона терраформ :
     ---
      clickhouse:
       hosts:
         clickhouse1:
           ansible_host: 51.250.12.198
           ansible_user: centos

       lighthouse:
        hosts:
        lighthouse1:
           ansible_host: 158.160.33.32
           ansible_user: centos

      vector:
        hosts:
        vector1:
          ansible_host: 84.201.131.123
          ansible_user: centos

5 `Запустите ansible-lint site.yml` и исправьте ошибки, если они есть.

6 Попробуйте запустить playbook на этом окружении с флагом `--check`.


      ➜  playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml

     PLAY [Install Clickhouse] **************************************************************************

     TASK [Gathering Facts] *****************************************************************************
     The authenticity of host '84.252.128.19 (84.252.128.19)' can't be established.
     ECDSA key fingerprint is SHA256:1NH7i3gw0+jaVJQcITFTVNFngKJZHm/G67p07VO1QMM.
     Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
     ok: [clickhouse1]

    TASK [Get clickhouse distrib] **********************************************************************
    changed: [clickhouse1] => (item=clickhouse-client)
    changed: [clickhouse1] => (item=clickhouse-server)
    failed: [clickhouse1] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 
    0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": 
    "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

    TASK [Get clickhouse distrib1] *********************************************************************
    changed: [clickhouse1]

    TASK [Install clickhouse packages] *****************************************************************
    changed: [clickhouse1]

    TASK [Flush handlers] ******************************************************************************

    RUNNING HANDLER [Start clickhouse service] *********************************************************
    changed: [clickhouse1]

    TASK [Create database] *****************************************************************************
    changed: [clickhouse1]

    PLAY [Install Vector] ******************************************************************************

    TASK [Gathering Facts] *****************************************************************************
    ok: [vector1]

    TASK [Get package vector] **************************************************************************
    changed: [vector1]

    TASK [Install vector package] **********************************************************************
    changed: [vector1]

    TASK [Vector config file] **************************************************************************
    changed: [vector1]

    TASK [Vector systemd service file] *****************************************************************
    changed: [vector1]

    PLAY [Install nginx] *******************************************************************************

    TASK [Gathering Facts] *****************************************************************************
    ok: [lighthouse1]

    TASK [Install epel-release] ************************************************************************
    changed: [lighthouse1]

    TASK [Install nginx] *******************************************************************************
    changed: [lighthouse1]

    TASK [Create nginx config] *************************************************************************
    changed: [lighthouse1]

    PLAY [Install lighthouse] **************************************************************************

    TASK [Gathering Facts] *****************************************************************************
    ok: [lighthouse1]

    TASK [Lighthouse | Install git] ********************************************************************
    changed: [lighthouse1]

     TASK [Lighthouse | Clone repository] ***************************************************************
     changed: [lighthouse1]

     TASK [Create Lighthouse config] ********************************************************************
     changed: [lighthouse1]

     RUNNING HANDLER [nginx reload] *********************************************************************
     changed: [lighthouse1]

     PLAY RECAP *****************************************************************************************
     clickhouse1                : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
     lighthouse1                : ok=11    changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
     vector1                    : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

7 Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

8 Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

      playbook git:(main) ✗ ansible-playbook -i inventory/prod.yml site.yml --diff

      PLAY [Install Clickhouse] **************************************************************************

      TASK [Gathering Facts] *****************************************************************************
      ok: [clickhouse1]

      TASK [Get clickhouse distrib] **********************************************************************
      ok: [clickhouse1] => (item=clickhouse-client)
      ok: [clickhouse1] => (item=clickhouse-server)
      failed: [clickhouse1] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", " 
      elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 
         404: 
          Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": 
          "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

      TASK [Get clickhouse distrib1] *********************************************************************
      ok: [clickhouse1]

      TASK [Install clickhouse packages] *****************************************************************
      ok: [clickhouse1]

     TASK [Flush handlers] ******************************************************************************

     TASK [Create database] *****************************************************************************
     ok: [clickhouse1]

     PLAY [Install Vector] ******************************************************************************

     TASK [Gathering Facts] *****************************************************************************
     ok: [vector1]

     TASK [Get package vector] **************************************************************************
     ok: [vector1]

     TASK [Install vector package] **********************************************************************
     ok: [vector1]

     TASK [Vector config file] **************************************************************************
     ok: [vector1]

     TASK [Vector systemd service file] *****************************************************************
     ok: [vector1]

     PLAY [Install nginx] *******************************************************************************

     TASK [Gathering Facts] *****************************************************************************
     ok: [lighthouse1]
 
     TASK [Install epel-release] ************************************************************************
     ok: [lighthouse1]

     TASK [Install nginx] *******************************************************************************
     ok: [lighthouse1]

     TASK [Create nginx config] *************************************************************************
     ok: [lighthouse1]

     PLAY [Install lighthouse] **************************************************************************

     TASK [Gathering Facts] *****************************************************************************
     ok: [lighthouse1]

     TASK [Lighthouse | Install git] ********************************************************************
     ok: [lighthouse1]

     TASK [Lighthouse | Clone repository] ***************************************************************
     ok: [lighthouse1]

     TASK [Create Lighthouse config] ********************************************************************
     ok: [lighthouse1]

     PLAY RECAP *****************************************************************************************
     clickhouse1                : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
     lighthouse1                : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
     vector1                    : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

     ----------------------

      ssh centos@84.252.128.19
     [centos@fhmpni1fe8jvbmm0499c ~]$ clickhouse-client -h 127.0.0.1
     ClickHouse client version 22.3.3.44 (official build).
     Connecting to 127.0.0.1:9000 as user default.
     Connected to ClickHouse server version 22.3.3 revision 54455.

     fhmpni1fe8jvbmm0499c.auto.internal :)

     --------------------

      ssh centos@158.160.39.3
      [centos@fhmst8nta7bv7657sbcs ~]$ vector --version
      vector 0.30.0 (x86_64-unknown-linux-gnu 38c3f0b 2023-05-22 17:38:48.655488673)

       systemctl status vector
        ● vector.service - Vector
        Loaded: loaded (/usr/lib/systemd/system/vector.service; disabled; vendor preset: disabled)
        Active: active (running) since Ср 2023-06-24 09:23:37 UTC; 6min ago
          Docs: https://vector.dev
       Main PID: 18331 (vector)
         CGroup: /system.slice/vector.service
                └─18331 /usr/bin/vector --config /etc/vector/vector.yml

9 Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

      1. site.yml Устанавливает на хосты clickhouse и vector nginx lighthouse
      2. вся инфракструктура поднимается terraform
      3. terraform создает файл с хостами и кладет в inventory/prod.yml
      3. group_vars/lighthouse/lighthouse.yml Переменные для lighthouse
      4. group_vars/clickhouse/clickhose.yml Переменные по версиям и устанавливаемому ПО от clickhouse
      5. group_vars/vector/vector.yml Переменная по версии Vector
      6. template/nginx.conf.j2 файл конфиг для вебсервера nginx
      7. template/nginx_lighthouse.j2 конфиг для lighthouse
      8. template/vector.yml.j2 конфиг vector
      9. template/vector.service.j2 конфиг для systemd

10 Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
