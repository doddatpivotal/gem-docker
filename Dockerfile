# Docker Apache Geode 1.2.1 represents GEODE version this can be changed to use a different version
FROM apachegeode/geode:1.2.1

# Add only if you need to specify a proxy
# ARG PROXY
# ENV http_proxy ${PROXY}
# ENV https_proxy ${PROXY}

# Install network and other tools need for linux image
RUN env
RUN yum makecache fast
RUN yum install -y nc
RUN yum install -y net-tools
RUN yum install -y tcpdump

# Only used if you want to build some code with maven during container provisioning
# ARG MAVEN_VERSION=3.6.0
# ARG USER_HOME_DIR="/tmp"
# ARG SHA=fae9c12b570c3ba18116a4e26ea524b29f7279c17cbaadc3326ca72927368924d9131d11b9e851b8dc9162228b6fdea955446be41207a5cfc61283dd8a561d2f
# ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

# RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
#   && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
#   && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
#   && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#   && rm -f /tmp/apache-maven.tar.gz \
#   && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# ENV MAVEN_HOME /usr/share/maven
# ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# ADD deploy/settings.xml "$USER_HOME_DIR/.m2/settings.xml"
# RUN /usr/share/maven/bin/mvn -s /tmp/.m2/settings.xml dependency:get -DremoteRepositories=http://remote-repo/solipsys-snapshots -DgroupId=com.solipsys.doctrine -DartifactId=doctrine-geode -Dversion=1.0.0-SNAPSHOT -Dtransitive=false 

# Add files needed. The source directory is first followed by target directory
ADD gfsh/gofish.gfsh .
ADD build/rungeode.sh .

# TCP ports exposed by the container
# Ports 40404 and 40405 are server ports
# Port 10334 default locator port
# Ports 8080, 7070 and 1099 http/jmx
EXPOSE  8080 10334 40404 40405 1099 7070

# Run this command after the container is built 
CMD ./rungeode.sh