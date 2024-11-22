FROM php:8.1-fpm-alpine

# Установка необходимых пакетов
RUN apk add --no-cache \
    libzip-dev \
    zip \
    unzip

# Установка необходимых расширений PHP
RUN docker-php-ext-install zip

# Создание рабочей директории
WORKDIR /var/www/html

# Копирование файлов приложения
COPY . .

# Создание необходимых директорий и настройка прав
RUN mkdir -p cache logs packages package-assets/banners package-assets/icons \
    && chown -R www-data:www-data cache logs packages package-assets \
    && chmod -R 755 cache logs packages package-assets

# Установка composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка зависимостей
RUN composer install --no-dev --optimize-autoloader

# Запуск PHP-FPM от пользователя www-data
USER www-data

EXPOSE 9000 