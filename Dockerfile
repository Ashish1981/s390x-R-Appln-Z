FROM ashish1981/s390x-shiny-server
ENV DEBIAN_FRONTEND noninteractive
# ENV SHINY_LOG_LEVEL=TRACE
RUN install2.r  rJava
# # #
RUN apt-get update && apt-get install -y \
    nano

RUN mkdir -p /var/log/supervisord
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
COPY /supervisord.conf /etc/
RUN chgrp -Rf root /var/log/supervisord && chmod -Rf g+rwx /var/log/supervisord
RUN chgrp -Rf root /var/log/shiny-server && chmod -Rf g+rwx /var/log/shiny-server
RUN chgrp -Rf root /srv/shiny-server && chmod -Rf g+rwx /srv/shiny-server
RUN chgrp -Rf root /var/lib/shiny-server && chmod -Rf g+rwx /var/lib/shiny-server
RUN chgrp -Rf root /etc/shiny-server && chmod -Rf g+rwx /etc/shiny-server

RUN chmod -Rf g+rwx /var/log/supervisord
RUN chmod -Rf g+rwx /var/log/shiny-server 
RUN chmod -Rf g+rwx /srv/shiny-server
RUN chmod -Rf g+rwx /var/lib/shiny-server
RUN chmod -Rf g+rwx /etc/shiny-server

#VOLUME [ "/tmp/log/supervisord" ]
WORKDIR /var/log/supervisord
#

# ###Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd
### Access Fix 24
COPY /scripts/uid-set.sh /usr/bin/
RUN chmod +x /usr/bin/uid-set.sh
# RUN /usr/bin/uid-set.sh
####################
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]  
