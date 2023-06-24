 ### Описание Playbook
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
/
