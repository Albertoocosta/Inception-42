FROM debian:bookworm
RUN apt-get update -y && apt-get install -y nginx openssl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /etc/nginx/ssl /var/run/nginx
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=BR/ST=SP/L=SaoPaulo/O=42/OU=42/CN=cda-fons.42.fr/UID=cda-fons"
COPY conf/nginx.conf /etc/nginx/nginx.conf
EXPOSE 443
CMD [ "nginx", "-g", "daemon off;" ]
