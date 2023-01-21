#!/bin/bash
BLACKLIST_FILE="/etc/unbound/blacklist.conf"
WHITELIST_FILE="/etc/unbound/whitelist"
WHITELIST_URLS="
	https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt
	https://raw.githubusercontent.com/m293732/unbound-adblock-config/main/whitelist
"
BLACKLIST_URLS="
	https://v.firebog.net/hosts/AdguardDNS.txt
	https://v.firebog.net/hosts/Easyprivacy.txt
	https://v.firebog.net/hosts/Prigent-Ads.txt
	https://v.firebog.net/hosts/static/w3kbl.txt
"
function get_domains {
	declare -a ARR=( ${!1} )
	for i in "${ARR[@]}"; do
		curl -sw '\n' "$i"
	done | sed 's/#.*//;/^$/d;s/\r//g' | sort -u
}
function convert_unbound {
	while read domain; do
		printf 'local-zone: "%s" always_nxdomain\n' "$domain"
	done
}
umask 0022
printf '# Generated %s\n' "$(date)" > $WHITELIST_FILE
get_domains "WHITELIST_URLS" >> $WHITELIST_FILE
printf '# Generated %s\n' "$(date)" > $BLACKLIST_FILE
get_domains "BLACKLIST_URLS" | grep -vf $WHITELIST_FILE | convert_unbound >> $BLACKLIST_FILE
systemctl restart unbound.service
