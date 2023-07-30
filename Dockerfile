FROM icr.io/appcafe/websphere-liberty:kernel-java11-openj9-ubi

#Installing network tools for troubleshooting purposes 
USER root

RUN yum install -y net-tools && \
    yum clean all
#Creating the directory to copy the mq resource adapter 
RUN mkdir -p /opt/wmq/
RUN chmod 777 /opt/wmq

USER 1001

COPY wmq.jmsra.rar /opt/wmq/

COPY ccdt.json /opt/wmq/
# Default setting for the verbose option. Set it to true to debug the application container image build failures
ARG VERBOSE=false

# Add Liberty server configuration including all necessary features
COPY --chown=1001:0  server.xml /config/

# Modify feature repository (optional)
#COPY --chown=1001:0 featureUtility.properties /opt/ibm/wlp/etc/

# This script will add the requested XML snippets to enable Liberty features and grow the image to be fit-for-purpose using featureUtility.
RUN features.sh

# Add interim fixes (optional)
#COPY --chown=1001:0  interim-fixes /opt/ibm/fixes/

# Add application
COPY --chown=1001:0  was-mq-aa-sample.war /config/dropins/

#Expose the application port
EXPOSE 9080
#EXPOSE 9443
# This script will add the requested server configurations, apply any interim fixes and populate caches to optimize runtime
RUN configure.sh
