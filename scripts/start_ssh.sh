#!/bin/bash

__create_user() {

useradd "${RABBITMQ_USER}"
SSH_USERPASS="${RABBITMQ_PASS}"
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin user)
echo ssh user password: $SSH_USERPASS
}

__create_user
