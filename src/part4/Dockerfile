FROM nginx
WORKDIR /home/
COPY nginx.conf /etc/nginx
COPY serv.c /home/serv.c
COPY run_docker.sh /home/run_docker.sh
RUN apt-get update; \
	apt-get install -y libfcgi-dev; \
	apt-get install spawn-fcgi; \
	apt-get install -y gcc; \
	chmod +x /home/run_docker.sh
ENTRYPOINT bash run_docker.sh
