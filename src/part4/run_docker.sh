#!/bin/bush

gcc serv.c -o serv -lfcgi
spawn-fcgi -p 8080 ./serv
nginx -g "daemon off;"
/bin/bash