
# FROM centos:centos7
FROM fsadykov/centos
MAINTAINER Farkhod Sadykov

# Install the basic requirements
RUN yum -y install epel-release && yum -y update && yum -y install pwgen wget logrotate && yum -y install nss_wrapper gettext && yum clean all

# Setup rabbitmq-server
RUN useradd -d /var/lib/rabbitmq -u 1001 -o -g 0 rabbitmq && \
    yum -y install rabbitmq-server && yum clean all

# Send the logs to stdout
ENV RABBITMQ_LOGS=- RABBITMQ_SASL_LOGS=-

# Create directory for scripts and passwd template
RUN mkdir -p /tmp/rabbitmq

RUN /usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

ADD run-rabbitmq-server.sh /tmp/rabbitmq/run-rabbitmq-server.sh

# Set permissions for openshift run
RUN chown -R 1001:0 /etc/rabbitmq && chown -R 1001:0 /var/lib/rabbitmq  && chmod -R ug+rw /etc/rabbitmq && \
    chmod -R ug+rw /var/lib/rabbitmq && find /etc/rabbitmq -type d -exec chmod g+x {} + && \
    find /var/lib/rabbitmq -type d -exec chmod g+x {} +

# Set  workdir
WORKDIR /var/lib/rabbitmq

# expose the ports
EXPOSE 5672 15672 4369 25672

# Add passwd template file for nss_wrapper
ADD passwd.template /tmp/rabbitmq/passwd.template

# Set permissions for scripts directory
RUN chown -R 1001:0 /tmp/rabbitmq && chmod -R ug+rwx /tmp/rabbitmq && \
    find /tmp/rabbitmq -type d -exec chmod g+x {} +

USER 1001

#########################################

RUN yum -y install openssh-server passwd; yum clean all
ADD ./scripts/start_ssh.sh /start_ssh.sh
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN chmod 755 /start_ssh.sh
EXPOSE 22
RUN ./start_ssh.sh

#########################################

# entrypoint/cmd for container
CMD ["/tmp/rabbitmq/run-rabbitmq-server.sh"]
