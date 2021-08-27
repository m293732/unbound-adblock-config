#!/bin/bash
[ -f /etc/unbound/unbound.conf ] && mv /etc/unbound/unbound.conf /etc/unbound/unbound.conf.old
install -Dt /etc/unbound -m644 ./unbound.conf
install -Dt /lib/systemd/system -m644 ./systemd/update-unbound-blacklist.*
install -Dt /usr/local/bin -m744 ./update-unbound-blacklist.sh
