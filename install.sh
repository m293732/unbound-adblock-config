#!/bin/bash
tmpdir=$(mktemp -d)
gh_raw_url='https://raw.githubusercontent.com/m293732/unbound-adblock-config/main'
pushd "$tmpdir" > /dev/null
curl --silent \
	-OJ "${gh_raw_url}/unbound.conf" \
	-OJ "${gh_raw_url}/update-unbound-blacklist.sh" \
	-OJ "${gh_raw_url}/systemd/update-unbound-blacklist.service" \
	-OJ "${gh_raw_url}/systemd/update-unbound-blacklist.timer"

mkdir -p /etc/unbound/unbound.conf.d
[ -f /etc/unbound/unbound.conf ] && mv /etc/unbound/unbound.conf /etc/unbound/unbound.conf.old
install -Dt /etc/unbound -m644 ./unbound.conf
install -Dt /lib/systemd/system -m644 ./update-unbound-blacklist.service
install -Dt /lib/systemd/system -m644 ./update-unbound-blacklist.timer
install -Dt /usr/local/bin -m744 ./update-unbound-blacklist.sh
popd > /dev/null
rm -rf "$tmpdir"
systemctl daemon-reload
