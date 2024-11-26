# Use the official PHP 8.2 image with Apache
FROM php:8.2-apache AS base

# Set working directory
WORKDIR /var/www/html

# Install required PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libmariadb-dev \
    unzip zip \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    && docker-php-ext-install intl pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Copy composer from the latest official composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Copy application files to the container
COPY . .

# Set proper permissions for Apache
RUN chown -R www-data:www-data /var/www/html

# Set DocumentRoot to Laravel's public directory
RUN sed -i 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Expose port 80 for Apache
EXPOSE 80

# Use the Apache foreground command to keep the container running
CMD ["apache2-foreground"]