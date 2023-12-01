# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Update the package lists
RUN apt update

# Remove existing PHP installations
RUN apt-get purge $(dpkg -l | grep php| awk '{print $2}' | tr "\n" " ")

# Add PHP repository and update package lists
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php
RUN apt update

# Install PHP 8.0, PostgreSQL 13, and Apache with required modules

RUN apt-get install -y php8.0 
RUN apt-get install -y php8.0-pgsql 
RUN apt-get install -y libapache2-mod-php8.0 
# RUN apt-get install -y postgresql-13 
RUN apt-get install -y php8.0-curl 
RUN apt-get install -y php8.0-gd 
RUN apt-get install -y php8.0-intl 
RUN apt-get install -y php8.0-mysql 
RUN apt-get install -y php8.0-xml 
RUN apt-get install -y php8.0-xmlrpc 
RUN apt-get install -y php8.0-ldap 
RUN apt-get install -y php8.0-zip 
RUN apt-get install -y php8.0-soap 
RUN apt-get install -y php8.0-mbstring

# Restart Apache
RUN service apache2 restart

# Clone Moodle repository
#RUN apt-get install -y git
#RUN cd /opt && git clone git://git.moodle.org/moodle.git
#RUN cd /opt/moodle && git branch -a && git branch --track MOODLE_403_STABLE origin/MOODLE_403_STABLE && git checkout MOODLE_403_STABLE

COPY . /var/www/html/moodle

# Copy Moodle files to Apache directory
#RUN cp -R /opt/moodle /var/www/html/

# Create Moodle data directory and set permissions
RUN mkdir /var/moodledata
RUN chown -R www-data /var/moodledata
RUN chmod -R 777 /var/moodledata
RUN chmod -R 777 /var/www/html/moodle

# Install PostgreSQL and its contrib package
#RUN apt-get install -y postgresql postgresql-contrib

# Initialize PostgreSQL database and configure user and database
#RUN sudo -u postgres psql -c "CREATE USER moodleuser WITH PASSWORD '123';"
#RUN sudo -u postgres psql -c "CREATE DATABASE moodle WITH OWNER moodleuser;"

# Configure PostgreSQL to allow connections
#RUN echo "host       moodle     moodleuser     0.0.0.0/32       md5" >> /etc/postgresql/13/main/pg_hba.conf
#RUN echo "host       moodle     moodleuser     35.156.155.240/32       md5" >> /etc/postgresql/13/main/pg_hba.conf

# Configure PostgreSQL to listen on all addresses
#RUN echo "listen_addresses = '*'" >> /etc/postgresql/13/main/postgresql.conf

# Restart Apache and PostgreSQL services


# RUN systemctl restart postgresql

# Update PHP configuration
RUN echo "max_input_vars = 5000" >> /etc/php/8.0/apache2/php.ini

RUN service apache2 restart


# Expose ports

EXPOSE 80

# Start Apache in the foreground

CMD ["apache2ctl", "-D", "FOREGROUND"]
