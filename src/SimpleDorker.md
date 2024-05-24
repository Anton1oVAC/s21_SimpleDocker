## Part 1. Готовый докер

- Устанавливаю Docker с помощью команды: **-sudo apt install docker.io**. Захожу на сайт docker и cкачиваю образ nginx с помощью команды: **-docker pull nginx** и проверяю наличие докер образа командой **-docker images**
![](./Screen/Part%201-%20nginx%20and%20images.png)

- Запускаю docker образ командой: **-docker run -d 070027a3cbe0** и проверяю запустится ли образ командой: **-docker ps**
![](./Screen/PART%201-%20docker%20run%20and%20ps.png)

- Смотрю информацию о контейнере с помощью команды: **-docker inspect [имя(NAMES)]** 
![](./Screen/PART%201-%20docker%20inspect....png)
![](./Screen/PART%201-%20info%20container.png)

- Далее с помощью утилиты grep нужно найти размер контейнера, список замапленных портов и ip контейнра
![](./Screen/PART%201-%20grep%20size,%20port,%20ipaddress.png)

- Останавливаю docker образ с помощью команды: **-docker stop(имя)**
![](./Screen/PART%201-%20docker%20stop.png)

- Запускаю docker с портами 80 и 443, замапленными на такие же порты на локальной машине, команда: **-docker run -d -p 80:80 -p 443:443 nginx**
![](./Screen/PART%201-%20run%20port%2080%20and%20443.png)

- Далее в браузере ввожу свой локальный адрес и порт: **-192.168.64.23:80**  и вижу стартовую страницу nginx
![](./Screen/PART%201-%20localhost%2080.png)

- Перезагружаю docker контейнер с помощью команды: **-docker restart (имя)**, и проверяю перезапуск командой: **-docker ps** и нахожу строчку (STATUS)
![](./Screen/PART%201-%20docker%20restart%20.png)


## Part 2. Операции с контейнером

- С помощью команды: **-docker exec (name) cat /etc/nginx/nginx.conf**, читаю конфигурационный файл внутри docker контейнера  
![](./Screen/PART%202-%20docker%20exec.png)

- Создаю файл **nginx.conf** и дописываю строчку server, чтобы открывалась статус сервера nginx: **localhost:80/status**
![](./Screen/PART%202-%20create%20conf.png)

- Далее копирую созданный файл в docker образ командой: **-sudo docker cp (наз.файла)(название образа и путь)** 
После перезагружаю nginx внутри docker-образа, чтобы новый конфиг заработал
![](./Screen/PART%202-%20cp%20and%20reload.png)

- Проверяю страницу по адресу localhost/status
![](./Screen/PART%202-%20localhost:status.png)

- Экспортирую контейнер командой: **-sudo docker export (файл) > container.tar** 
И командой: **-sudo docker stop (файл)** останавливаю контейнер
![](./Screen/PART%202-%20export%20and%20stop.png)

- Удаляю образ с помощью команды: **-sudo docker rmi -f nginx**
И удаляю остановленный контейнер командой: **-sudo docker rm (имя)**
![](./Screen/PART%202-%20rmi%20nginx,%20rm.png)

- Импортирую контейнер обратно командой: **-sudo docker import -c 'cmd ["nginx", "-g", "daemon off;"]' -c 'ENTRYPOINT ["/docker-entrypoint.sh"]' container.tar nginx** 
- Далее заново запускаю контейнер командой: **-sudo docker run -d -p 80:80 -p 443:443 nginx**
- Проверяю страницу сервера 
![](./Screen/PART%202-%20import%20and%20run%20nginx.png)
![](./Screen/PART%202-%20localhost:status%20two.png)


## Part 3. Мини веб-сервер

- Создаю файл **serv.c**, чтобы мини-сервер возвращал надпись «Hello World!»
![](./Screen/PART%203-%20mini-server%20in%20C.png)

- Создаю конфиг, который будет проксировать все запросы с порта **81** на порт **127.0.0.1:8080**
![](./Screen/PART%203-%20conf%20of%20mini-serv.png)

- Далее запускаю новый контейнер с портом 81. 
- Копирую конфигурацию nginx.conf и Си файл в директорию докер образа
- После командой: **-sudo docker exec -it (имя) bash** запускаю сеанс внутри докер-образа
![](./Screen/PART%203-cp%20serv.c,%20cp%20conf,%20run%2081.png)

- Внутри контейнера устанавливаю компилятор, библиотеку **libfcgi-dev** и **spawn-fcgi**
- Компилирую Си файл и запускаю мини-сервер командой: **-spawn-fcgi -p 8080 -f ./serv**. 
- И командой:**-nginx -s reload** перезагружаю конфигурацию nginx
![](./Screen/%20PART%203-%20gcc,%20spawn-fcgi,%20reload.png)

- Проверяю страницу браузера
![](./Screen/PART%203-%20web.png)


## Part 4. Свой докер

- Создаю файл **Dockerfile** и прописываю в нем команды для билда докер-образа:
- **FROM nginx** - задаю образ, чья файловая система берется за основу
- **WORKDIR /home** - задаю рабочую директорию внутри контейнера 
- **COPY** - копирует файлы из локальной директории внутрь контейнера 
- **RUN** - обновление пакетов, установка компилятора, установка утилиты spawn-fcgi для запуска FastCGI приложений, установка библиотеки libfcgi-dev для работы  FastCGI приложений, права для запуска скрипта
- **ENTRYPOINT** - запускает скрипт, который запускает мини-сервер  
![](./Screen/PART%204-%20dockerfile.png)

- Создаю скрипт, который компилирует мини-сервер, запускает его на порту 8080, и запускает nginx 
![](./Screen/PART%204-%20sh.png)

- Собираю написанный докер-образ командой: **-docker build -t mydock:ver1(имя:тег) .** 
- Проверяю, что все собралось корректно
![](./Screen/PART%204-%20docker%20build%20and%20images.png)

- Запускаю докер-образ с маппингом 81 порта на 80 на локально машине
![](./Screen/PART%204-%20docker%20run.png)

- Проверяю станицу в браузере, что выводит мини-сервер
![](./Screen/PART%204-%20localhost.png)

- Добавляю в файл **nginx.conf**  проксирование страницы /server, чтобы страница показывала статус nginx: **localhost:80/status**
![](./Screen/PART%204-%20conf.png)

- Перехожу в контейнер и перезагружаю nginx командой: **nginx -s reload**
![](./Screen/PART%204-%20nginx%20reload.png)

- Проверяю результат **localhost/server**
![](./Screen/PART%204-%20serv%20status.png)


## Part 5. Dockle

- Устанавливаю dockle и сканирую докер-образ предыдущего задания
![](./Screen/PART%205-%20dockle%20before.png)

- Теперь нужно изменить dockerfile, чтобы при сканировании dockle не было ошибок и предупреждений. Нужно удалить содержимое директории: **rm -rf /var/lib/apt/lists** и **изменить пользователя с root на другого** 
![](./Screen/PART%205-%20dockerfile.png)

- Далее собираю образ и даю новое название командой: **docker build -t mydock2:ver2 .** , и сканирую новый докер образ 
![](./Screen/PART%205-%20dockle%20after.png)


## Part 6. Базовый Docker Compose

- Устанавливаю **docker-compose**

- Создаю файл **docker-compose.yml**, который должен поднять контейнер из 5 части и контейнер из 6 части, который будет перенаправлять трафик с порта 80 на хосте и будет привязан к порту 8080 в контейнере
![](./Screen/PART%206-%20docker-compose.png)

- Далее собираю контейнеры командой: **-docker-compose build**
- И командой **-docker-compose up -d** запускаю контейнеры
![](./Screen/PART%206-%20docker%20build.png)
![](./Screen/PART%206-%20docker%20up%20-d.png)

- Смотрю результат 
![](./Screen/PART%206-%20curl%20localhost.png)
![](./Screen/PART%206-%20localhost.png)