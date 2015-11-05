FROM jenkins:1.625.1

USER root

# Java 8 and fakeroot for javafx builds
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get --no-install-recommends -y install oracle-java8-installer && \
    apt-get --no-install-recommends -y install fakeroot && \
    rm -rf /var/lib/apt/lists/*


# Let Jenkins be sudoer
RUN apt-get update && \
    apt-get --no-install-recommends -y install sudo && \
    echo "jenkins ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*
 
USER jenkins

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

ENV DOCKER_GID_ON_HOST ""
COPY jenkins.sh /usr/local/bin/jenkins.sh

