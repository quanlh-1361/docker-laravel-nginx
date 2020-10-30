FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  autoconf \
  build-essential \
  apt-utils \
  zlib1g-dev \
  libzip-dev \
  unzip \
  zip \
  libmagick++-dev \
  libmagickwand-dev \
  libpq-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libwebp-dev \ 
  libxpm-dev 

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install gd intl pdo_mysql pdo_pgsql mysqli zip

RUN pecl install imagick-3.4.3

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN docker-php-ext-enable imagick

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /var/www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
