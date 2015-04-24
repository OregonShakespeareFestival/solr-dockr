############################################################
# OSF SOLR Repo
# A Docker Container Installation of SOLR
############################################################


#Declare CentOS the latest
FROM centos

Maintainer Andrew J Krug

# UPDATE
RUN yum -y update  

# INSTALL packages 
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install epel-release
RUN yum -y install pwgen

# INSTALL JAVA
RUN yum -y install java-1.7.0-openjdk \
lsof \
procps \
curl \
slf4j

ENV SOLR_VERSION 4.10.3
ENV SOLR solr-$SOLR_VERSION
ENV TOMCAT_VERSION 7.0.55
ENV JAVA_HOME /usr
ENV JRE_HOME $JAVA_HOME
ENV JAVA_OPTS "-Djava.awt.headless=true"
ENV JAVA_ENDORSED_DIRS /opt/tomcat/endorsed

RUN  wget -nv --output-document=/opt/$SOLR.tgz http://ftp.osuosl.org/pub/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -C /opt --extract --file /opt/$SOLR.tgz && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr

ADD http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar /opt/solr/dist/postgresql-9.3-1102.jdbc41.jar


# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz

# UNPACK
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz

# REMOVE APPS 
RUN rm -rf /opt/tomcat/webapps/examples /opt/tomcat/webapps/docs

# SET CATALINE_HOME and PATH 
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

#Randomize the TC Admin and write to container log
ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh


#Here's all the SOLR prep work
RUN cp -a /opt/solr/dist/solrj-lib/* /opt/tomcat/lib/
RUN cp -a /opt/solr/example/resources/log4j.properties /opt/tomcat/conf/
RUN cp -a /opt/solr/dist/solr-*.war /opt/tomcat/webapps/solr.war
RUN cp /usr/share/java/slf4j/slf4j-simple.jar /opt/tomcat/lib/
RUN cp -rn /usr/share/java/* /opt/tomcat/lib/

#Now let's add the sufia configuration
RUN mkdir -p /opt/tomcat/solr/cores/osfsufia

ADD solr-cores/osfsufia /opt/tomcat/solr/cores/osfsufia
ADD solr.xml /opt/tomcat/conf/Catalina/localhost/solr.xml
ADD solr-cores/solr.xml /opt/tomcat/solr/cores/solr.xml

EXPOSE 8080
EXPOSE 8443

ADD run.sh /run.sh
RUN chmod +x /*.sh

VOLUME ["/opt/fedoracommons"]

CMD ["/run.sh"]

