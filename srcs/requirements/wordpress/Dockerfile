FROM debian:bookworm
RUN apt-get update -y && apt-get install -y php8.2 php-fpm php-mysql mariadb-client wget && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /var/www/wordpress /run/php
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wp_setup.sh /usr/local/bin/wp_setup.sh
RUN chmod +x /usr/local/bin/wp_setup.sh
EXPOSE 9000
CMD ["/usr/local/bin/wp_setup.sh"]
