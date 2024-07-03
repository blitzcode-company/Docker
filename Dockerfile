# Usa una imagen base de PHP con el sistema operativo deseado
FROM php:8.2-fpm

# Variables de entorno
ENV PHP_VERSION=8.2.0

# Instala dependencias necesarias para compilar PHP, ffmpeg y ldap
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libxml2-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    libbz2-dev \
    libsqlite3-dev \
    libreadline-dev \
    libicu-dev \
    libxslt1-dev \
    autoconf \
    bison \
    re2c \
    wget \
    zip \
    unzip \
    git \
    ffmpeg \
    libldap2-dev \
    && apt-get clean

# Crea el usuario bitnami y el grupo bitnami
RUN groupadd -g 1000 bitnami && \
    useradd -m -u 1000 -g bitnami -s /bin/bash bitnami

# Crea el directorio para la configuración de PHP antes de compilar
RUN mkdir -p /usr/local/php/etc

# Descarga y compila PHP 8.2
RUN cd /usr/local/src && \
    wget https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz && \
    tar -xzf php-${PHP_VERSION}.tar.gz && \
    cd php-${PHP_VERSION} && \
    ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/usr/local/php/etc/php.d \
    --enable-mbstring \
    --with-curl \
    --with-openssl \
    --with-zlib \
    --enable-soap \
    --enable-intl \
    --enable-pcntl \
    --with-mysqli \
    --with-pdo-mysql \
    --with-zip \
    --enable-opcache \
    --with-ldap \
    && make -j$(nproc) && \
    make install && \
    cp php.ini-production /usr/local/php/etc/php.ini

# Añadir PHP al PATH
ENV PATH="/usr/local/php/bin:$PATH"

# Ajusta la configuración de PHP
RUN sed -i 's/^post_max_size = .*/post_max_size = 500M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 500M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^memory_limit = .*/memory_limit = 512M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^max_execution_time = .*/max_execution_time = 300/' /usr/local/php/etc/php.ini && \
    sed -i 's/^max_input_time = .*/max_input_time = 300/' /usr/local/php/etc/php.ini

# Crea los directorios de almacenamiento necesarios si no existen
RUN mkdir -p /app/storage/app/public && \
    mkdir -p /app/storage/framework/cache && \
    mkdir -p /app/storage/framework/sessions && \
    mkdir -p /app/storage/framework/views && \
    mkdir -p /app/storage/logs

# Establece los permisos y propietario correctos
RUN chown -R bitnami:bitnami /app/storage && \
    chmod -R 755 /app/storage

# Establece el directorio de trabajo
WORKDIR /app

# Instala las extensiones de PHP necesarias para MySQL y LDAP
RUN docker-php-ext-install mysqli pdo pdo_mysql ldap

# Expone el puerto 8000
EXPOSE 8000

# Inicia la aplicación Laravel
CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "8000"]

