FROM ubuntu:14.04.2
MAINTAINER ikoniaris@gmail.com

# Update & upgrade system
RUN apt-get -y update
RUN apt-get -y dist-upgrade

# Needed for non-interactive installation (e.g. no asking for MySQL's root password)
ENV DEBIAN_FRONTEND noninteractive

# Install required packages
RUN apt-get install -y git python-pip python-dev openssl python-openssl python-pyasn1 python-twisted python-mysqldb mysql-server supervisor libgeoip-dev

# Install Elasticsearch requirements with pip
RUN pip install pyes
RUN pip install GeoIP

# Get Kippo fork with Elasticsearch support
RUN git clone https://github.com/ikoniaris/kippo /kippo

# Setup kippo user & group
RUN addgroup --gid 2000 kippo 
RUN adduser --system --no-create-home --shell /bin/bash --uid 2000 --disabled-password --disabled-login --gid 2000 kippo

# Copy configs
ADD kippo.cfg /kippo/
ADD kippo.sql /root/
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup MySQL and Kippo DB
RUN sed -i 's#127.0.0.1#0.0.0.0#' /etc/mysql/my.cnf
RUN service mysql start && /usr/bin/mysqladmin -u root password "youhackwecapture" && /usr/bin/mysql -u root -p"youhackwecapture" < /root/kippo.sql

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm /root/kippo.sql

# Change file ownership
RUN chown -R kippo:kippo /kippo

# Open port 2222
EXPOSE 2222

# Start Kippo via supervisord
CMD ["/usr/bin/supervisord"]
