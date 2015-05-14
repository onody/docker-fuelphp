
FROM ubuntu:14.04
MAINTAINER Kohei Onodera

#
# Install Apache & PHP
#
RUN apt-get update -y
RUN apt-get install -y git
RUN apt-get install -y apache2 php5 php5-mysql php5-curl php5-gd php5-redis
RUN apt-get clean


#
# Install fuelphp
#
RUN git clone git://github.com/fuel/fuel.git /var/www/fuelphp
RUN /var/www/fuelphp/composer.phar self-update
RUN cd /var/www/fuelphp/ && ./composer.phar update
RUN rm -rf .git .gitmodules *.md docs fuel/core fuel/packages && git init
RUN git submodule add git://github.com/fuel/core.git fuel/core; \
	git submodule add git://github.com/fuel/oil.git fuel/packages/oil; \
	git submodule add git://github.com/fuel/auth.git fuel/packages/auth; \
	git submodule add git://github.com/fuel/parser.git fuel/packages/parser; \
	git submodule add git://github.com/fuel/orm.git fuel/packages/orm; \
	git submodule add git://github.com/fuel/email.git fuel/packages/email
RUN git submodule foreach 'git checkout 1.7/master'

#
# Start Apache2
#
ADD fuelphp.conf /etc/apache2/sites-available/fuelphp.conf
RUN ln -s /etc/apache2/sites-available/fuelphp.conf /etc/apache2/sites-enabled/fuelphp.conf
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
