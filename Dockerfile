FROM ashish1981/s390x-shiny-server:working
#FROM ashish1981/s390x-shiny-server
#
ARG user=shiny
ARG group=shiny
ARG uid=1000
ARG gid=1000
ARG SHINY_HOME=/srv/shiny-server

USER root
# ENV SHINY_HOME $SHINY_HOME
RUN userdel -r docker 

# #
RUN mkdir -p /var/log/supervisord
RUN chown ${uid}:${gid} $SHINY_HOME \
    && chown ${uid}:${gid} /srv/shiny-server \
    && chown ${uid}:${gid} /var/lib/shiny-server \
    && chown ${uid}:${gid} /etc/shiny-server \
    && chown ${uid}:${gid} /var/log/supervisord \
    && groupadd -g ${gid} ${group} \
    && adduser -d "$SHINY_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user} 
    # && useradd -d "$SHINY_HOME" -g ${gid} -m -s /bin/bash ${user}
#copy application
COPY /app /srv/shiny-server/
#
# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh
COPY run-myfile.R /srv/shiny-server/
RUN rm -rf /tmp/*
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
# RUN chmod -Rf g+wx /var/log/supervisord
# RUN chmod -Rf g+wx /var/log/shiny-server 
# RUN chmod -Rf g+wx /srv/shiny-server
# RUN chmod -Rf g+wx /var/lib/shiny-server
# RUN chmod -Rf g+wx /etc/shiny-server
RUN chgrp -Rf root /var/log/supervisord && chmod -Rf g+rwx /var/log/supervisord
RUN chgrp -Rf root /var/log/shiny-server && chmod -Rf g+rwx /var/log/shiny-server
RUN chgrp -Rf root /srv/shiny-server && chmod -Rf g+rwx /srv/shiny-server
RUN chgrp -Rf root /var/lib/shiny-server && chmod -Rf g+rwx /var/lib/shiny-server
RUN chgrp -Rf root /etc/shiny-server && chmod -Rf g+rwx /etc/shiny-server

#VOLUME [ "/tmp/log/supervisord" ]
WORKDIR /var/log/supervisord
#
# USER 1000
# Adjust permissions on /etc/passwd so writable by group root.
# RUN chmod g+w /etc/passwd
# ### Access Fix 24
# RUN username=`id -u` 
# COPY /scripts/uid-set.sh /usr/bin/
# RUN chmod +x /usr/bin/uid-set.sh
# RUN /usr/bin/uid-set.sh


ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]  