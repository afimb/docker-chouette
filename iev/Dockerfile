FROM jboss/wildfly

ENV CHOUETTE_IEV_VERSION 3.3.1-SNAPSHOT
ENV MAVEN_REPO maven-snapshot

USER root

RUN yum -y install wget

USER jboss

###-- Update hibernate module
RUN wget -q http://www.hibernatespatial.org/repository/org/hibernate/hibernate-spatial/4.3/hibernate-spatial-4.3.jar -P /tmp && \
    wget -q http://central.maven.org/maven2/com/vividsolutions/jts/1.13/jts-1.13.jar -P /tmp && \
    cp /tmp/hibernate-spatial-*.jar /tmp/jts-*.jar /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/ && \
    cp /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml.sav && \
    sed -i '/<resources>/a\\t<resource-root path="hibernate-spatial-4.3.jar"/>'  /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    sed -i '/<resources>/a\\t<resource-root path="jts-1.13.jar"/>'  /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml && \
    sed -i '/<dependencies>/a\\t<module name="org.postgres"/>'  /opt/jboss/wildfly/modules/system/layers/base/org/hibernate/main/module.xml
    # chown -R wildfly: /opt/jboss/wildfly

#-- Install Chouette_IEV
RUN wget http://${MAVEN_REPO}.chouette.mobi/mobi/chouette/chouette_iev/${CHOUETTE_IEV_VERSION}/maven-metadata.xml && \
    CHOUETTE_EAR_VERSION=`sed -n 's:.*<version>\(.*\)</version>.*:\1:p' maven-metadata.xml` && \
    CHOUETTE_EAR_VERSION=${CHOUETTE_EAR_VERSION%SNAPSHOT} && \
    CHOUETTE_EAR_VERSION+=`sed -n 's:.*<timestamp>\(.*\)</timestamp>.*:\1:p' maven-metadata.xml` && \
    CHOUETTE_EAR_VERSION+='-' && \
    CHOUETTE_EAR_VERSION+=`sed -n 's:.*<buildNumber>\(.*\)</buildNumber>.*:\1:p' maven-metadata.xml` && \
    wget -q http://${MAVEN_REPO}.chouette.mobi/mobi/chouette/chouette_iev/${CHOUETTE_IEV_VERSION}/chouette_iev-${CHOUETTE_EAR_VERSION}.ear && \
    cp chouette_iev-*.ear /opt/jboss/wildfly/standalone/deployments/chouette.ear

