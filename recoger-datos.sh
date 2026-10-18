#!/bin/bash
# Recoge la configuración de red y DNS. Solo lee, no cambia nada.
# Uso: sudo bash recoger-datos.sh > datos-$(hostname).txt 2>&1
s(){ echo; echo "===== $1 ====="; }
s "HOSTNAME";            hostname; hostname -f 2>/dev/null
s "SISTEMA";             grep PRETTY_NAME /etc/os-release
s "IP A";                ip a
s "RUTAS";               ip r
s "NETPLAN (ficheros)";  for f in /etc/netplan/*.yaml; do echo "--- $f"; cat "$f"; done
s "RESOLV.CONF enlace";  ls -l /etc/resolv.conf
s "RESOLV.CONF";         cat /etc/resolv.conf
s "RESOLVED.CONF (sin comentarios)"; grep -v '^\s*#' /etc/systemd/resolved.conf | grep -v '^\s*$'
s "RESOLVECTL STATUS";   resolvectl status --no-pager
s "SYSTEMD-RESOLVED";    systemctl is-active systemd-resolved
s "NETWORKMANAGER";      systemctl is-active NetworkManager 2>/dev/null; command -v nmcli >/dev/null && { nmcli device status; nmcli connection show; }
s "HOSTS";               cat /etc/hosts
s "NSSWITCH hosts";      grep ^hosts /etc/nsswitch.conf
s "BIND9";               systemctl is-active named 2>/dev/null || systemctl is-active bind9 2>/dev/null
[ -d /etc/bind ] && { s "BIND named.conf.local"; cat /etc/bind/named.conf.local; s "BIND options"; grep -v '^\s*//' /etc/bind/named.conf.options; ls -l /etc/bind/; }
s "DHCP (isc-dhcp-server / kea)"; systemctl is-active isc-dhcp-server 2>/dev/null; [ -f /etc/dhcp/dhcpd.conf ] && grep -v '^\s*#' /etc/dhcp/dhcpd.conf | grep -v '^\s*$'
s "FIN"
