#!/usr/bin/env Rscript
library(plumber)
# Sys.setenv(LD_LIBRARY_PATH='/usr/lib/jvm/java-11-openjdk-s390x/lib/server:/usr/lib/jvm/java-11-openjdk-s390x')
# Sys.setenv(JAVA_HOME='/usr/lib/jvm/java-11-openjdk-s390x')
pr <- plumb('/srv/shiny-server/myRapiv3.R')
pr$run(port=8000, host="0.0.0.0")
# Setting the host option on a VM instance ensures the application can be accessed externally.
# (This may be only true for Linux users.)