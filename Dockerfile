FROM debian:stretch-slim

LABEL maintainer="Caio Villela <caiovmv@hotmail.com>"

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies.
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install -y --no-install-recommends sudo vim curl net-tools wget ftp telnet iputils-ping

# Install Ansible via pip.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential libffi-dev libssl-dev python-pip python-dev python-setuptools 
RUN pip install ansible cryptography setuptools
COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Cleaning
RUN  rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

# Copy playbook
COPY playbooks /playbooks
# Install Ansible inventory file
ADD ansible-hosts /etc/ansible/hosts
# Copy Keys
RUN mkdir /root/.ssh
COPY keys/* /root/.ssh/
