FROM ubuntu
MAINTAINER Gerardo Arceri "arcerigerardo@gmail.com"

#RUN apt-get update

# Set the env variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common bash  docker.io docker-registry docker-compose wget ca-certificates git && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean && \
    update-ca-certificates
# Install the gnome desktop so that gnome-terminal is available
RUN apt-get install -y maven
# Copy the files into the container
#ADD config/ /home/docker
RUN mkdir -p /home/docker
RUN mkdir /root/.ssh
RUN chmod 600 /root/.ssh
RUN mkdir /root/workspace
WORKDIR /jenkins-cli
#ADD jenkins_key /root/.ssh/id_rsa
RUN ln -s /root/.ssh /ssh
ADD files/jenkins-cli-wrapper.sh .
ENV JENKINS_URL ""
ENV PRIVATE_KEY "/ssh/id_rsa"
ADD files/.ssh/config /root/.ssh/config
ADD files/settings.xml.template /etc/maven
#ENV JENKINS_URL "https://brightpowersoftware.ci.cloudbees.com/"
# Start dbus, ssh and Xpra services.
ENTRYPOINT ["./jenkins-cli-wrapper.sh"]
