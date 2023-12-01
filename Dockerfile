# Use the official Ubuntu 20.04 image
FROM ubuntu:20.04

# Update the package lists
RUN apt update

# Install PostgreSQL and its contrib package
RUN apt-get install -y postgresql postgresql-contrib

# Initialize PostgreSQL database and configure user and database
RUN service postgresql start && \
    sudo -u postgres psql -c "CREATE USER moodleuser WITH PASSWORD '123';" && \
    sudo -u postgres psql -c "CREATE DATABASE moodle WITH OWNER moodleuser;"

# Configure PostgreSQL to allow connections
RUN echo "host       moodle     moodleuser     0.0.0.0/32       md5" >> /etc/postgresql/13/main/pg_hba.conf
RUN echo "host       moodle     moodleuser     35.156.155.240/32       md5" >> /etc/postgresql/13/main/pg_hba.conf

# Configure PostgreSQL to listen on all addresses
RUN echo "listen_addresses = '*'" >> /etc/postgresql/13/main/postgresql.conf

# Restart PostgreSQL
RUN service postgresql restart

# Expose PostgreSQL port
EXPOSE 5432
