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
    ustcmirror/rsync:latest 'until entry.sh; do :;done' &
) &

(
mkdir -p /var/repos/ubuntu /var/sync-logs/ubuntu
rm -fr /var/repos/ubuntu/ubuntu
ln -s .. /var/repos/ubuntu/ubuntu
docker stop syncubuntu
sleep 1
docker run -d --name syncubuntu --rm \
    -e APTSYNC_URL='http://mirrors.zju.edu.cn/ubuntu/' \
    -e APTSYNC_UNLINK=1 \
    -e APTSYNC_DISTS='bionic,focal|main multiverse restricted universe|amd64|/' \
    -v /var/repos/ubuntu:/data \
    -v /var/sync-logs/ubuntu:/log \
    ustcmirror/apt-sync:latest
) &

wait