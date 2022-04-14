#!/usr/bin/sudo /bin/sh
(
mkdir -p /var/sync-logs/alpine /var/repos/alpine
docker stop syncalpine
sleep 1
docker run -d --name syncalpine --rm \
    -e LOG_ROTATE_CYCLE='5' \
    -e RSYNC_HOST='rsync.mirrors.ustc.edu.cn' \
    -e RSYNC_PATH='alpine/' \
    -e RSYNC_MAXDELETE='10000' \
    -v /var/repos/alpine:/data \
    -v /var/sync-logs/alpine:/log \
    --entrypoint /bin/bash ustcmirror/rsync:latest -c 'until entry.sh; do :;done'
) &

(
mkdir -p /var/repos/ubuntu /var/sync-logs/ubuntu
rm -fr /var/repos/ubuntu/ubuntu
ln -s .. /var/repos/ubuntu/ubuntu
docker stop syncubuntu
sleep 1
docker run -d --name syncubuntu --rm \
    -e APTSYNC_URL='http://mirrors.tuna.tsinghua.edu.cn/ubuntu/' \
    -e APTSYNC_DISTS='bionic,focal|main multiverse restricted universe|amd64' \
    -v /var/repos/ubuntu:/data \
    -v /var/sync-logs/ubuntu:/log \
    ustcmirror/aptsync:latest
) &

(
mkdir -p /var/sync-logs/archlinux /var/repos/archlinux
docker stop syncarch
sleep 1
docker run -d --name syncarch --rm \
    -e LOG_ROTATE_CYCLE='5' \
    -e RSYNC_HOST='mirrors.tuna.tsinghua.edu.cn' \
    -e RSYNC_PATH='archlinux/' \
    -e RSYNC_MAXDELETE='10000' \
    -e RSYNC_DELAY_UPDATES=true \
    -e RSYNC_DELETE_DELAY=true \
    -v /var/repos/archlinux:/data \
    -v /var/sync-logs/archlinux:/log \
    --entrypoint /bin/bash ustcmirror/rsync:latest -c 'until entry.sh; do :;done'
) &

wait