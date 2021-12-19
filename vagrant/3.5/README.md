# Результаты домашнего задания к занятию "3.5. Файловые системы"
1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
    * Не могут.  Жесткие ссылки имеют inode и разрешения исходного файла, разрешения будут обновляться при изменении разрешения исходного файла
1. Вывод команды `lsblk`:
    * ```bash
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
        └─md1                9:1    0 1017M  0 raid0
            └─VG1-LV1        253:2    0  100M  0 lvm   /tmp/new
        sdc                    8:32   0  2.5G  0 disk
        ├─sdc1                 8:33   0    2G  0 part
        │ └─md0                9:0    0    2G  0 raid1
        └─sdc2                 8:34   0  511M  0 part
        └─md1                9:1    0 1017M  0 raid0
            └─VG1-LV1        253:2    0  100M  0 lvm   /tmp/new
        vagrant@vagrant:~$ ls -l /tmp/new
        total 22200
        drwx------ 2 root root    16384 Dec  1 09:51 lost+found
        -rw-r--r-- 1 root root 22712441 Dec  1 08:14 test.gz
      ```
1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1:

    * ```bash
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
        │   └─VG1-LV1        253:2    0  100M  0 lvm   /tmp/new
        └─sdb2                 8:18   0  511M  0 part
        └─md1                9:1    0 1017M  0 raid0
        sdc                    8:32   0  2.5G  0 disk
        ├─sdc1                 8:33   0    2G  0 part
        │ └─md0                9:0    0    2G  0 raid1
        │   └─VG1-LV1        253:2    0  100M  0 lvm   /tmp/new
        └─sdc2                 8:34   0  511M  0 part
        └─md1                9:1    0 1017M  0 raid0
      ```
1. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
    * ```bash
        [Wed Dec  1 11:22:01 2021] md/raid1:md0: Disk failure on sdb1, disabling device.
                                   md/raid1:md0: Operation continuing on 1 devices.
      ```