FROM ashish1981/s390x-shiny-server:new2
#FROM ashish1981/s390x-shiny-server
#
ARG user=shiny
ARG group=shiny
ARG uid=1001
ARG gid=1001
ARG SHINY_HOME=/srv/shiny-server

ENV SHINY_HOME $SHINY_HOME

#
RUN mkdir -p /var/log/supervisord
RUN chown ${uid}:${gid} $SHINY_HOME \
    && chown ${uid}:${gid} /srv/shiny-server \
    && chown ${uid}:${gid} /var/lib/shiny-server \
    && chown ${uid}:${gid} /etc/shiny-server \
    && chown ${uid}:${gid} /var/log/supervisord \
    && groupadd -g ${gid} ${group} \
    && useradd -d "$SHINY_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}
#copy application
COPY /app /srv/shiny-server/
#
# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh
COPY run-myfile.R /srv/shiny-server/
RUN rm -rf /tmp/*
#
# Make the ShinyApp available at port 1240
EXPOSE 9443 8000
#
##################---NGNIX SETUP STARTS-----######################## 
# RUN apt-get update && apt-get install -y \
#     nginx \
#     openssl 
# RUN mkdir -p /etc/ssl/private 
# RUN chmod 700 /etc/ssl/private
# # #########----Create SSL Certificates
# RUN openssl req -new -newkey rsa:4096 -days 90 -nodes -x509 \
#     -subj "/C=IN/ST=MH/L=PUNE/O=IBM/CN=IBM-Cloud" \
#     -keyout /etc/ssl/private/nginx-selfsigned.key \
#     -out /etc/ssl/certs/nginx-selfsigned.crt \
#     && openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 &>/dev/null
# COPY /ssl.conf /etc/nginx/conf.d/
# Copy further configuration files into the Docker image
COPY /supervisord.conf /etc/
RUN chmod -R 777 /var/log/supervisord
RUN chmod -R 777 /var/log/shiny-server 
RUN chmod -R 777 /srv/shiny-server
RUN chmod -R 777 /var/lib/shiny-server
RUN chmod -R 777 /etc/shiny-server
#VOLUME [ "/tmp/log/supervisord" ]
WORKDIR /var/log/supervisord
#

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]  
