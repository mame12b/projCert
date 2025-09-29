FROM php:8.1-apache

COPY ./website/ /var/www/html/

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]

