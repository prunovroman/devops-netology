# Результаты домашнего задания к занятию "3.9. Элементы безопасности информационных систем"

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

    ![bitwarden](img/bitwarden.png)

1. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

1. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

``` bash
    vagrant@vagrant:~$ systemctl status apache2
    ● apache2.service - The Apache HTTP Server
        Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
        Active: active (running) since Sun 2021-12-12 09:28:59 UTC; 1min 45s ago
        Docs: https://httpd.apache.org/docs/2.4/
    Main PID: 5465 (apache2)
        Tasks: 55 (limit: 1071)
        Memory: 5.5M
        CGroup: /system.slice/apache2.service
                ├─5465 /usr/sbin/apache2 -k start
                ├─5466 /usr/sbin/apache2 -k start
                └─5467 /usr/sbin/apache2 -k start

    Dec 12 09:28:59 vagrant systemd[1]: Starting The Apache HTTP Server...
    Dec 12 09:28:59 vagrant systemd[1]: Started The Apache HTTP Server.
    ------------------------

    vagrant@vagrant:~$ sudo openssl req -x509 -nodes -days 10 -newkey rsa:2048 -keyout /etc/ssl/private/apache.key -out /etc/ssl/certs/apache.crt

    ------------------------

    vagrant@vagrant:~$ cat /etc/apache2/sites-available/mysite.com.conf
    <VirtualHost *:443>
        DocumentRoot /var/www/mysite

        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/apache.crt
        SSLCertificateKeyFile /etc/ssl/private/apache.key

    </VirtualHost>

    ------------------------

    vagrant@vagrant:~$ openssl x509 -in /etc/ssl/certs/apache.crt -text -noout
    Certificate:
        Data:
            Version: 3 (0x2)
            Serial Number:
                73:d6:3b:14:0f:ae:2b:ec:8f:ac:f8:c2:54:f7:94:dc:c6:85:07:6b
            Signature Algorithm: sha256WithRSAEncryption
            Issuer: C = UZ, ST = Tashkent, L = Tashkent, O = Vagrant, OU = VM, CN = Prunov Roman, emailAddress = prunovroman@gmail.com
            Validity
                Not Before: Dec 12 09:49:31 2021 GMT
                Not After : Dec 22 09:49:31 2021 GMT
            Subject: C = UZ, ST = Tashkent, L = Tashkent, O = Vagrant, OU = VM, CN = Prunov Roman, emailAddress = prunovroman@gmail.com
```

![bitwarden](img/ssl.png)

