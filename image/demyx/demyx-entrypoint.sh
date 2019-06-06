#!/bin/bash
# Demyx
# https://demyx.sh

if [[ ! -d /demyx/etc ]]; then
    echo 'Demyx not found, installing now ... '
    git clone https://github.com/demyxco/demyx.git /demyx/etc
    mkdir -p /demyx/app/html
    mkdir -p /demyx/app/php
    mkdir -p /demyx/app/wp
    mkdir -p /demyx/app/stack
    mkdir -p /demyx/backup
    mkdir -p /demyx/custom
    cp /demyx/etc/example/example-callback.sh /demyx/custom
fi

if [[ "$DEMYX_MODE" = development ]]; then
    DEMYX_MODE=DEVELOPMENT
else
    DEMYX_MODE=PRODUCTION
fi

[[ -z "$DEMYX_SSH" ]] && DEMYX_SSH=2222
[[ -z "$DEMYX_ET" ]] && DEMYX_ET=2022

cat > /demyx/.motd <<-EOF
#!/bin/bash

PRINT_TABLE="DEMYX, $DEMYX_MODE\n"
PRINT_TABLE+="USER, DEMYX\n"
PRINT_TABLE+="SSH/SFTP, $DEMYX_SSH\n"
PRINT_TABLE+="ETSERVER, $DEMYX_ET"

echo "
Demyx
https://demyx.sh

Welcome to Demyx! To see all demyx commands, run: demyx help
"
sudo demyx util "source /table.sh && printTable ',' '\$PRINT_TABLE'"
echo

EOF

if [[ ! -d /home/demyx/.ssh ]]; then
    mkdir -p /home/demyx/.ssh
fi
if [[ ! -f /etc/ssh/ssh_host_rsa_key ]]; then
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [[ -f /home/demyx/.ssh/ssh_host_rsa_key ]]; then
	cp /home/demyx/.ssh/ssh_host_rsa_key /etc/ssh
	cp /home/demyx/.ssh/ssh_host_rsa_key.pub /etc/ssh
else
	cp /etc/ssh/ssh_host_rsa_key /home/demyx/.ssh
	cp /etc/ssh/ssh_host_rsa_key.pub /home/demyx/.ssh
fi

chmod 700 /home/demyx/.ssh
chmod 644 /home/demyx/.ssh/authorized_keys
chown -R demyx:demyx /home/demyx
chown -R demyx:demyx /demyx
chmod -R a=X /demyx
chmod +x /usr/local/bin/demyx
chmod +x /demyx/etc/demyx.sh
chmod +x /demyx/etc/cron/every-minute.sh
chmod +x /demyx/etc/cron/every-6-hour.sh
chmod +x /demyx/etc/cron/every-day.sh
ln -s /demyx/etc/demyx.sh /usr/local/bin/demyx

crond
/usr/sbin/sshd
/usr/local/bin/etserver -v 9 -logtostdout true
