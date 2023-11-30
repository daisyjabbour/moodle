# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    git \
    software-properties-common \
    postgresql \
    postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# Add PHP repository
RUN add-apt-repository ppa:ondrej/php && apt-get update

# Install PHP 7.4 and required extensions
RUN apt-get install -y \
    php7.4 \
    php7.4-pgsql \
    libapache2-mod-php7.4 \
    graphviz \
    aspell \
    ghostscript \
    clamav \
    php7.4-pspell \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mysql \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-ldap \
    php7.4-zip \
    php7.4-soap \
    php7.4-mbstring \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Copy local Moodle repository into the Docker image
COPY . /var/www/html/moodle

# Create moodledata directory
RUN mkdir /var/moodledata && chown -R www-data /var/moodledata && chmod -R 777 /var/moodledata

# Set permissions for Moodle directory
RUN chmod -R 0755 /var/www/html/moodle

# Fix deprecated string syntax
RUN find /var/www/html/moodle -type f -name '*.php' -exec sed -i 's/\${\([^}]*\)}/{$\1}/g' {} +

# Expose ports
EXPOSE 80

# Start Apache and PostgreSQL setup
CMD service apache2 restart && \
    /etc/init.d/postgresql start && \
    psql --command "CREATE USER moodleuser WITH PASSWORD '123';" && \
    createdb -O moodleuser moodle && \
    sed -i 's/#listen_addresses = '\''localhost'\''/listen_addresses = '\''*'\''/g' /etc/postgresql/14/main/postgresql.conf && \
    sh -c 'echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/14/main/pg_hba.conf' && \
    systemctl restart postgresql && \
    chmod -R 777 /var/www/html/moodle && \
    tail -f /dev/null
