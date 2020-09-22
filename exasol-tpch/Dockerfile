FROM exasol/docker-db:latest

USER root

WORKDIR /home

RUN mkdir /home/TPCH/  && \
    curl -o EXAplus-6.2.9.tar.gz https://www.exasol.com/support/secure/attachment/111057/EXAplus-6.2.9.tar.gz
RUN tar -xvf EXAplus-6.2.9.tar.gz

COPY tpch/* /home/TPCH/
COPY tpch.sh  /home/TPCH/
COPY init.sh /home/TPCH/

RUN chmod -R 777 /home/TPCH


