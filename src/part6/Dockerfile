FROM nginx
WORKDIR /home/
COPY nginx.conf /etc/nginx
COPY run_docker.sh /home/run_docker.sh
RUN	apt-get update; \
	chmod +x /home/run_docker.sh
ENTRYPOINT bash run_docker.sh