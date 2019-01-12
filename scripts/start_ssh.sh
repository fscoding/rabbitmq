#!/bin/bash

__create_user() {

useradd fsadykov
SSH_USERPASS=redhat
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin user)
echo ssh user password: $SSH_USERPASS
}

__create_user
