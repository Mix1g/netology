# Домашнее задание к занятию "Troubleshooting"

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер k8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить.

1. Установить приложение по команде:  
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```
2. Выявить проблему и описать.  
Устанавливаю и получаю ошибку, в которой говорится, что отсутвтсуют `namespaces` `"web"` и `"data"`. Создаю их  
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "web" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
Error from server (NotFound): error when creating "https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml": namespaces "data" not found
ubuntu@ubuntu-VirtualBox:~/.kube$ 
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl create namespace web
namespace/web created
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl create namespace data
namespace/data created
```

3. Исправить проблему, описать, что сделано.  
Проверяю `pod-ы` и их логи.
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS    RESTARTS   AGE
data          auth-db-795c96cddc-wszqs                  1/1     Running   0          86s
kube-system   calico-kube-controllers-6dfcdfb99-rd9l9   1/1     Running   0          115m
kube-system   calico-node-rhlq2                         1/1     Running   0          116m
kube-system   calico-node-rptr2                         1/1     Running   0          116m
kube-system   calico-node-tb469                         1/1     Running   0          116m
kube-system   coredns-645b46f4b6-2tzlq                  1/1     Running   0          115m
kube-system   coredns-645b46f4b6-9bsgg                  1/1     Running   0          115m
kube-system   dns-autoscaler-659b8c48cb-wbzmc           1/1     Running   0          115m
kube-system   kube-apiserver-node1                      1/1     Running   1          118m
kube-system   kube-controller-manager-node1             1/1     Running   2          118m
kube-system   kube-proxy-294tp                          1/1     Running   0          117m
kube-system   kube-proxy-88kwn                          1/1     Running   0          117m
kube-system   kube-proxy-bqbc8                          1/1     Running   0          117m
kube-system   kube-scheduler-node1                      1/1     Running   1          118m
kube-system   nginx-proxy-node2                         1/1     Running   0          115m
kube-system   nginx-proxy-node3                         1/1     Running   0          115m
kube-system   nodelocaldns-8h8t5                        1/1     Running   0          115m
kube-system   nodelocaldns-qqxz4                        1/1     Running   0          115m
kube-system   nodelocaldns-z65pq                        1/1     Running   0          115m
web           web-consumer-577d47b97d-682qx             1/1     Running   0          86s
web           web-consumer-577d47b97d-w6t62             1/1     Running   0          86s
```
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl logs -n web web-consumer-577d47b97d-682qx
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
curl: (6) Couldn't resolve host 'auth-db'
...............................
```
Т.к. `pod-ы` в разных `namespace`, есть предположение, что это где-то не обозначено, поэтому `pod-ы` из `web` не могут достучаться до `pod-a` из `data`  
Исправляю на `auth-db.data` через команду `kubectl edit -n web deployments.apps web-consumer`  
![image](https://https://github.com/Mix1g/netology/tree/master/14-kubecloud-05-Troubleshooting/239f.png)

```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl edit -n web deployments.apps web-consumer
deployment.apps/web-consumer edited
```

4. Продемонстрировать, что проблема решена.  
После, проверяю поднявшиеся `pod-ы` и их логи, что получается достучаться до `nginx`
```bash
ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS        RESTARTS   AGE
data          auth-db-795c96cddc-wszqs                  1/1     Running       0          25m
kube-system   calico-kube-controllers-6dfcdfb99-rd9l9   1/1     Running       0          139m
kube-system   calico-node-rhlq2                         1/1     Running       0          140m
kube-system   calico-node-rptr2                         1/1     Running       0          140m
kube-system   calico-node-tb469                         1/1     Running       0          140m
kube-system   coredns-645b46f4b6-2tzlq                  1/1     Running       0          139m
kube-system   coredns-645b46f4b6-9bsgg                  1/1     Running       0          139m
kube-system   dns-autoscaler-659b8c48cb-wbzmc           1/1     Running       0          139m
kube-system   kube-apiserver-node1                      1/1     Running       1          142m
kube-system   kube-controller-manager-node1             1/1     Running       2          142m
kube-system   kube-proxy-294tp                          1/1     Running       0          141m
kube-system   kube-proxy-88kwn                          1/1     Running       0          141m
kube-system   kube-proxy-bqbc8                          1/1     Running       0          141m
kube-system   kube-scheduler-node1                      1/1     Running       1          142m
kube-system   nginx-proxy-node2                         1/1     Running       0          140m
kube-system   nginx-proxy-node3                         1/1     Running       0          140m
kube-system   nodelocaldns-8h8t5                        1/1     Running       0          139m
kube-system   nodelocaldns-qqxz4                        1/1     Running       0          139m
kube-system   nodelocaldns-z65pq                        1/1     Running       0          139m
web           web-consumer-566f496484-5m5h4             1/1     Running       0          19s
web           web-consumer-566f496484-95j9z             1/1     Running       0          20s
web           web-consumer-577d47b97d-682qx             1/1     Terminating   0          25m
web           web-consumer-577d47b97d-w6t62             1/1     Terminating   0          25m




ubuntu@ubuntu-VirtualBox:~/.kube$ kubectl logs -n web web-consumer-566f496484-5m5h4 
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>


```

### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md
