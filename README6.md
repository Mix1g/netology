### Домашнее задание к занятию  Файловые системы

##### 1 Узнайте о sparse (разряженных) файлах.


Разреженные файлы - это файлы, для которых выделяется пространство на диске только для участков с ненулевыми данными. Список всех "дыр" хранится в метаданных ФС и используется при операциях с файлами. В результате получается, что разреженный файл занимает меньше места на диске (более эффективное использование дискового пространства)


##### 2 Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Не могут, так жесткие ссылки имеют один и тот же inode (объект, который содержит метаданные файла).


##### 3 Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим. Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.


    vagrant@vagrant:~$ lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
    ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
    └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    sdc                    8:32   0  2.5G  0 disk
    
    
  ##### 4 Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
  
    vagrant@vagrant:~$ sudo fdisk /dev/sdb

    Welcome to fdisk (util-linux 2.34).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Device does not contain a recognized partition table.
    Created a new DOS disklabel with disk identifier 0x8e9c6d3a.

    Command (m for help): n
    Partition type
       p   primary (0 primary, 0 extended, 4 free)
       e   extended (container for logical partitions)
    Select (default p):

    Using default response p.
    Partition number (1-4, default 1):
    First sector (2048-5242879, default 2048):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

    Created a new partition 1 of type 'Linux' and of size 2 GiB.

    Command (m for help): n
    Partition type
       p   primary (1 primary, 0 extended, 3 free)
       e   extended (container for logical partitions)
    Select (default p):

       Using default response p.
       Partition number (2-4, default 2):
       First sector (4196352-5242879, default 4196352):
       Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

       Created a new partition 2 of type 'Linux' and of size 511 MiB. 
       Command (m for help): w
       The partition table has been altered.
       Calling ioctl() to re-read partition table.
       Syncing disks.

    vagrant@vagrant:~$ lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
    ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
    └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    └─sdb2                 8:18   0  511M  0 part
    sdc                    8:32   0  2.5G  0 dis
    
    
  ##### 5 Используя sfdisk, перенесите данную таблицу разделов на второй диск.
  
    vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
    Checking that no-one is using this disk right now ... OK

    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes

    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Created a new DOS disklabel with disk identifier 0xb1cf5424.
    /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
    /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
    /dev/sdc3: Done.

    New situation:
    Disklabel type: dos
    Disk identifier: 0xb1cf5424

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G 83 Linux
    /dev/sdc2       4196352 5242879 1046528  511M 83 Linux

    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    vagrant@vagrant:~$ lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
    ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
    └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    └─sdb2                 8:18   0  511M  0 part
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    └─sdc2                 8:34   0  511M  0 part
    
   ##### 6 Соберите mdadm RAID1 на паре разделов 2 Гб
   
   
    vagrant@vagrant:~$ sudo mdadm --create /dev/md0 -l 1 -n 2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started
    
   ##### 7 Соберите mdadm RAID0 на второй паре маленьких разделов
   
   
    vagrant@vagrant:~$ sudo mdadm --create /dev/md1 -l 0 -n 2 /dev/sdb2 /dev/sdc2
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.
    vagrant@vagrant:~$ lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part  /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
    ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
    └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md0                9:0    0    2G  0 raid1
    └─sdb2                 8:18   0  511M  0 part
    └─md1                9:1    0 1018M  0 raid0
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md0                9:0    0    2G  0 raid1
    └─sdc2                 8:34   0  511M  0 part
    └─md1                9:1    0 1018M  0 raid0
    
   ##### 8 Создайте 2 независимых PV на получившихся md-устройствах.
   
     vagrant@vagrant:~$ sudo pvcreate /dev/md1 /dev/md0
     Physical volume "/dev/md1" successfully created.
     Physical volume "/dev/md0" successfully created.
     vagrant@vagrant:~$ sudo pvscan
     PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]
     PV /dev/md0                       lvm2 [<2.00 GiB]
     PV /dev/md1                       lvm2 [1018.00 MiB]
     Total: 3 [<66.49 GiB] / in use: 1 [<63.50 GiB] / in no VG: 2 [2.99 GiB] 
     
   ##### 9 Создайте общую volume-group на этих двух PV
   
     vagrant@vagrant:~$ sudo vgcreate VG1 /dev/md0 /dev/md1
     Volume group "VG1" successfully created
     vagrant@vagrant:~$ sudo vgscan
     Found volume group "vgvagrant" using metadata type lvm2
     Found volume group "VG1" using metadata type lvm2
     
   ##### 10 Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
   
      vagrant@vagrant:~$ sudo lvcreate -L 100M -n LV1 VG1 /dev/md1
      Logical volume "LV1" created..
      
   ##### 11 Создайте mkfs.ext4 ФС на получившемся LV.
   
     vagrant@vagrant:~$ sudo mkfs.ext4 /dev/VG1/LV1
     mke2fs 1.45.5 (07-Jan-2020)
     Creating filesystem with 25600 4k blocks and 25600 inodes

     Allocating group tables: done
     Writing inode tables: done
     Creating journal (1024 blocks): done
     Writing superblocks and filesystem accounting information: done
     
     
   ##### 12 Смонтируйте этот раздел в любую директорию, например, /tmp/new
   
     vagrant@vagrant:~$ mkdir /tmp/new
     vagrant@vagrant:~$ sudo mount /dev/VG1/LV1 /tmp/new 
