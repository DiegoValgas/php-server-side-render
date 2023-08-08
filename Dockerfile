FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    unzip \
    # Clear cache
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # GD Settings
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    # Install PHP extensions
    && docker-php-ext-install mysqli pdo pdo_mysql mbstring exif pcntl bcmath gd zip \
    # Get latest Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # Create system user to run Composer and Artisan Commands
    && useradd -G www-data,root -u $uid -d /home/$user $user \
    && mkdir -p /home/$user/.composer \
    && chown -R $user:$user /home/$user

# Set working directory
WORKDIR /var/www

USER $user