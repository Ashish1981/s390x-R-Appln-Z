FROM ashish1981/s390x-rbase-rjava-rplumber
ENV DEBIAN_FRONTEND noninteractive
ENV LD_LIBRARY_PATH=/usr/lib/jvm/default-java/lib/server:/usr/lib/jvm/default-java
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-s390x

# ENV SHINY_LOG_LEVEL=TRACE
RUN export LD_LIBRARY_PATH=/usr/lib/jvm/default-java/lib/server:/usr/lib/jvm/default-java \
    && export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-s390x \
    && R CMD javareconf 
RUN install2.r  rJava
RUN export LD_LIBRARY_PATH=/usr/lib/jvm/default-java/lib/server:/usr/lib/jvm/default-java \
    && export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-s390x \
    && R CMD javareconf 

# # #
RUN apt-get update && apt-get install -y \
    nano \
    supervisor 

RUN mkdir -p /var/log/supervisord
#copy application

COPY /app /srv/shiny-server/
#
# Copy configuration files into the Docker image
COPY shiny-server.conf  /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh
COPY run-myfile.R /srv/shiny-server/
COPY plumb.sh /usr/bin/plumb.sh
RUN chmod +x /usr/bin/plumb.sh
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
