	FROM debian:stable

	MAINTAINER Suporte "suporte@paschoalotto.com.br"

	WORKDIR /var/www/html

	RUN apt update && apt -y install lsb-release apt-transport-https ca-certificates && apt-get install -y nginx wget && apt clean

	RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

	RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

	RUN apt update -y

	RUN apt install -y php7.4 php-cas php7.4-fpm php7.4-curl php7.4-gd php7.4-imagick php7.4-intl \
	    php7.4-apcu php7.4-memcache php7.4-imap php7.4-mysql \
	    php7.4-ldap php7.4-tidy php-pear php7.4-xmlrpc php7.4-pspell \
	    php7.4-mbstring php7.4-json php7.4-iconv php7.4-xml php7.4-xsl \
	    php7.4-zip php7.4-bz2 \
	    && apt-get clean

	RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php/7.4/fpm/php.ini \
	        && echo "daemon off;" >> /etc/nginx/nginx.conf

	RUN cd /var/www/html \
	        && wget https://github.com/glpi-project/glpi/releases/download/9.5.5/glpi-9.5.5.tgz \
	        && tar zxvf glpi-9.5.5.tgz \
	        && cd glpi \
	        && cp * -R /var/www/html \
	        && rm /var/www/html/glpi-9.5.5.tgz

	RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html && rm -f /etc/nginx/sites-enabled/default

	COPY default /etc/nginx/sites-enabled/

	EXPOSE 80

	CMD service php7.4-fpm start && nginx
