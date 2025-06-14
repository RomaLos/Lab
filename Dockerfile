FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y \
    build-essential \
    devscripts \
    debhelper \
    rpm \
    alien \
    curl \
    wget \
    git \
    make \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

RUN usermod -aG docker jenkins

WORKDIR /var/jenkins_home/workspace

COPY count_files.sh /usr/local/bin/count-files
COPY Makefile /var/jenkins_home/
COPY *.spec /var/jenkins_home/
COPY debian/ /var/jenkins_home/debian/

RUN chmod +x /usr/local/bin/count-files
RUN chown -R jenkins:jenkins /var/jenkins_home/

USER jenkins

RUN jenkins-plugin-cli --plugins \
    git \
    workflow-aggregator \
    docker-workflow \
    build-timeout \
    timestamper

EXPOSE 8080 50000

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
