### Домашнее задание к занятию «Языки разметки JSON и YAML»

## Обязательная задача 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:

```python
import socket
import time
import json
import yaml
# задаем словарь
service_addr = {
    'drive.google.com': '0',
    'mail.google.com': '0',
    'google.com': '0'
}
# Получаем текущие на момент запуска скрипта значения (чтобы в будущем не сравнивать с 0).
for item in service_addr:
    initial_addr = socket.gethostbyname(item)
    service_addr[item] = initial_addr
    # Записываем полученные данные в виде json файла
    with open(item + '.json', 'w') as output_json:
        # Формируем json
        data_json = json.dumps({item: service_addr[item]})
        # Записываем его в файл
        output_json.write(data_json)
    # Записываем полученные данные в виде yaml файла
    with open(item + '.yaml', 'w') as output_yaml:
        # Формируем yaml
        data_yaml = yaml.dump([{item: service_addr[item]}])
        # Записываем его в файл
        output_yaml.write(data_yaml)
while True:
    # Перебираем все ключи в словаре
    for item in service_addr:
        old_addr = service_addr[item]
        new_addr = socket.gethostbyname(item)
        # Если старое и новое не совпадают - адрес изменился. Перезаписываем значение в словаре и выводим ошибку
        if new_addr != old_addr:
            service_addr[item] = new_addr
            # Записываем полученные данные в виде json файла
            with open(item + '.json', 'w') as output_json:
                # Формируем json
                data_json = json.dumps({item: service_addr[item]})
                # Записываем его в файл
                output_json.write(data_json)
            # Записываем полученные данные в виде yaml файла
            with open(item + '.yaml', 'w') as output_yaml:
                # Формируем yaml
                data_yaml = yaml.dump([{item: service_addr[item]}])
                # Записываем его в файл
                output_yaml.write(data_yaml)
            # Вывод ошибки
            print("[ERROR] " + item + " IP mismatch: old IP " + old_addr + ", new IP " + new_addr)
        print(item + " - " + service_addr[item])
    print("######################################")
    time.sleep(10)
```

### Вывод скрипта при запуске при тестировании:

```
PS C:\Git\ubnt\mix1g-netology> python.exe .\test.py
drive.google.com - 74.125.205.194
mail.google.com - 74.125.131.83
google.com - 142.251.1.102
######################################
drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: old IP 74.125.131.83, new IP 74.125.131.19
mail.google.com - 74.125.131.19
[ERROR] google.com IP mismatch: old IP 142.251.1.102, new IP 142.251.1.113
google.com - 142.251.1.113
######################################
```

### json-файл(ы), который(е) записал ваш скрипт:

```json
{"drive.google.com": "74.125.205.194"}
```

```json
{"google.com": "142.251.1.113"}
```

```json
{"mail.google.com": "74.125.131.18"}
```

### yml-файл(ы), который(е) записал ваш скрипт:

```yaml
- drive.google.com: 74.125.205.194
```

```yaml
- google.com: 142.251.1.113
```

```yaml
- mail.google.com: 74.125.131.18
```
