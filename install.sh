#!/usr/bin/sudo /bin/sh
ln -s "$PWD/cjlumirror.service" /etc/systemd/system/cjlumirror.service
ln -s "$PWD/cjlumirror.timer" /etc/systemd/system/cjlumirror.timer
systemctl enable cjlumirror
systemctl start cjlumirror
systemctl enable cjlumirror.timer
systemctl start cjlumirror.timer