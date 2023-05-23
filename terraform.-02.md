### Домашнее задание 07-ter-homeworks-02 «Основы Terraform. Yandex Cloud»
#### ЗАДАНИЕ 1

1 Изучил проект и файл variables.tf в котором объявлены переменные для yandex provider.
2 Переименовал файл personal.auto.tfvars_example в personal.auto.tfvars. Заполнил переменные (идентификаторы облака, токен доступа). Благодаря .gitignore этот файл не попадет в публичный репозиторий. Но можно выбрать иной способ безопасно передать секретные данные в terraform.

`mv personal.auto.tfvars_example personal.auto.tfvars`

3 Сгенерировал ssh ключ. Записал его открытую часть в переменную vms_ssh_root_key (в файле src/variables.tf).


    sh-keygen -t ed24419 
    
    cat ~/.ssh/id_ed24419.pub
    
 4 Инициализировал проект, выполнил код. Исправил возникшую ошибку.
 
    terraform init
    terraform plan
    terraform apply
    
![4](https://github.com/Mix1g/netology/assets/119140245/c4ade546-3cc9-440c-8598-e54ece6a49c0)

 Получил ошибку, в которой видно  что для платформы standard-v1 доступны к использованию только 2 или 4 ядра, а ну нас указано 1 ядро. 
 
 Исправил на 2.
 
    terraform destroy
    terraform plan
    terraform apply
    
![5](https://github.com/Mix1g/netology/assets/119140245/c0cbfa4b-bc51-4b1f-801f-af6cf3977c32)
![6 копия](https://github.com/Mix1g/netology/assets/119140245/9ad139d5-22e6-4158-9394-43b38ab9f66a)

    ssh -i ~/.ssh/id_ed25519 'ubuntu@130.193.23.192'

![7 копия 3](https://github.com/Mix1g/netology/assets/119140245/b5eb20f4-1c68-4d2d-bf7d-8d5cacb40172)

5 В процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ.

- `preemptible` – прерываемые виртуальные машины, это ВМ, которые могут быть принудительно остановлены в любой момент (если с момента запуска виртуальной машины прошло 24 часа, либо если возникнет нехватка ресурсов для запуска обычной ВМ в той же зоне доступности).

- `core_fraction` – уровни производительности vCPU (минимальные конфигурации указаны для уровня производительности 5%).

 #### ЗАДАНИЕ 2
 1. Изучите файлы проекта.
 2. Замените все "хардкод" значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.
 3. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.
 4. Проверьте terraform plan (изменений быть не должно).

- Решение [variables.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/variables.tf)

#### ЗАДАНИЕ 3
1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные ВМ.
2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ: "netology-develop-platform-db" , cores = 2, memory = 2, core_fraction = 20. Объявите ее переменные с префиксом vm_db_ в том же файле.
3. Примените изменения.

- Решение [vms_platform.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/vms_platform.tf) [main.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/main.tf)  


#### ЗАДАНИЕ 4
1. Объявите в файле outputs.tf отдельные output, для каждой из ВМ с ее внешним IP адресом.
2. Примените изменения.
3. В качестве решения приложите вывод значений ip-адресов команды terraform output

- Решение [outputs.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/outputs.tf)

       $ terraform output
       db_ip_address = "51.250.0.213"
       web_ip_address = "51.250.74.121"
  
 #### ЗАДАНИЕ 5
1. В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию по примеру из лекции.
2. Замените переменные с именами ВМ из файла variables.tf на созданные вами local переменные.
3. Примените изменения.
 
 Решение: ссылка на файлы [variables.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/variables.tf) закоментировал vm_web_name,[vms_platform.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/vms_platform.tf) закоментировал vm_db_name, использовал интерполяцию [main.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/main.tf)
 
#### ЗАДАНИЕ 6
1. Вместо использования 3-х переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедените их в переменные типа map с именами "vm_web_resources" и "vm_db_resources".
2. Так же поступите с блоком metadata {serial-port-enable, ssh-keys}, эта переменная должна быть общая для всех ваших ВМ.
3. Найдите и удалите все более не используемые переменные проекта.
4. Проверьте terraform plan (изменений быть не должно).

- Решение: ссылкка на файлы [variables.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/variables.tf) ,[vms_platform.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/vms_platform.tf) , [main.tf](https://github.com/Mix1g/netology/blob/master/7.2-terraform/src/main.tf) удалил не используемые переменные, использовал переменную типа - map.

#### Задание 7
Изучите сожержимое файла console.tf. Откройте terraform console, выполните следующие задания:

1. Напишите, какой командой можно отобразить второй элемент списка test_list?
2. Найдите длину списка test_list с помощью функции length(<имя переменной>).
3. Напишите, какой командой можно отобразить значение ключа admin из map test_map ?
4. Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.

В качестве решения предоставьте необходимые команды и их вывод.

- Решение:

       local.test_list[1]
       length(local.test_list)
       local.test_map.admin
       "${ local.test_map.admin } is admin for ${local.test_list[2]} server based on OS ${local.servers.production.image} with ${local.servers.production.cpu} vcpu,       
        ${local.servers.production.ram} ram and ${length(local.servers.production.disks)} virtual disks"
   
