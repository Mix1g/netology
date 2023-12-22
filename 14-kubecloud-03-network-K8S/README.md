# Домашнее задание к занятию  «Как работает сеть в K8s»

## Основная часть

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

### Ответ:

### Задание 1.

Развернул с помощью kubeadm кластер, под CNI поднял calico

![1](img/1.png)

Написал deployments [backend](https://github.com/Mix1g/netology/tree/master/14-kubecloud-03-network-K8S/back.yaml) , [frontend](https://github.com/Mix1g/netology/tree/master/14-kubecloud-03-network-K8S/front.yaml), [cache](https://github.com/Mix1g/netology/tree/master/14-kubecloud-03-network-K8S/cache.yaml). И для каждого svc соответсвенно. Поднял поды:

![2](img/2.png)

Проверю связность внутри подов до применения политик:

    kubectl exec backend-7d7d868764-5wgsz -n app -- curl 192.168.171.85:443

![3](img/3.png)

После применения запрещающего [правила](https://github.com/Mix1g/netology/blob/master/14-kubecloud-03-network-K8S/net_policy.yaml):

![4](img/4.png)

После применения разрешающего [правила](https://github.com/Mix1g/netology/blob/master/14-kubecloud-03-network-K8S/policy.yaml)

![5](img/5.png)

