FROM eclipse-temurin:17-jdk

RUN apt-get update && \
    apt-get install -y maven openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/sshd

RUN useradd -m -s /bin/bash jenkins && \
    mkdir -p /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]
