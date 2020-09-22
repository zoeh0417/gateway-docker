FROM mariadb:latest

ENV MYSQL_DATABASE=tpch
ENV MYSQL_USER=tpch
ENV MYSQL_PASSWORD=mstr123#
ENV MYSQL_ROOT_PASSWORD=mstr123#
ENV MYSQL_PORT=3306

COPY ./tpch/ /var/lib/mysql-files/
ADD tpch.cnf  /etc/mysql/conf.d
ADD setup.sql /docker-entrypoint-initdb.d/00-setup.sql
RUN sed -i 's/MYSQL_DATABASE/'$MYSQL_DATABASE'/g;s/MYSQL_PASSWORD/'$MYSQL_PASSWORD'/g;s/MYSQL_USER/'$MYSQL_USER'/g' /docker-entrypoint-initdb.d/00-setup.sql

#RUN /entrypoint.sh mysqld & sleep 120  && killall mysqld

#ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
