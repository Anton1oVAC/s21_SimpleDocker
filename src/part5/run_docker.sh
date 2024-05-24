#!/bin/bush

gcc serv.c -lfcgi -o serv
spawn-fcgi -p 8080 ./serv
nginx -g "daemon off;"
/bin/bash