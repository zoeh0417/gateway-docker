FROM nguoianphu/docker-sybase

ADD entrypoint.sh /
COPY tpch/*.tbl /tmp/

RUN chmod +x /entrypoint.sh

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]
