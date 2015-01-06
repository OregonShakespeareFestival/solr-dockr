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
curl

ENV SOLR_VERSION 4.10.3
ENV SOLR solr-$SOLR_VERSION

RUN  wget -nv --output-document=/opt/$SOLR.tgz http://www.gtlib.gatech.edu/pub/apache/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -C /opt --extract --file /opt/$SOLR.tgz && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr

ADD http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar /opt/solr/dist/postgresql-9.3-1102.jdbc41.jar

EXPOSE 8983

ADD run.sh /run.sh
RUN chmod +x /*.sh

CMD ["/run.sh"]

