###Описание Playbook
1. site.yml Устанавливает на хосты clickhouse и vector
2. В inventory/prod.yml задаем хосты docker 
3. Поднимаем поднимаем группу хостов docker-compose.yml
4. group_vars/clickhouse/vars.yml Переменные по версиям и устанавливаемому ПО от clickhouse
5. group_vars/vector/vars.yml Переменная по версии Vector
