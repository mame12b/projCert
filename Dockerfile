# Use official PHP Apache image
FROM php:8.1-apache

# Copy your website code into the container
COPY ./website/ /var/www/html/

# Expose port 80 for web traffic
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2ctl", "-D", "FOREGROUND"]

