#!/usr/bin/sudo /bin/sh
systemctl stop cjlumirror
systemctl disable cjlumirror
systemctl stop cjlumirror.timer
systemctl disable cjlumirror.timer
rm -f /etc/systemd/system/cjlumirror.service
rm -f /etc/systemd/system/cjlumirror.timer