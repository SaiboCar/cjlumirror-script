#!/usr/bin/sudo /bin/sh
mkdir -p /var/sync-logs/alpine /var/repos/alpine
docker run --rm \
    -e LOG_ROTATE_CYCLE='5' \
    -e RSYNC_HOST='rsync.alpinelinux.org' \
    -e RSYNC_PATH='alpine/' \
    -e RSYNC_MAXDELETE='10000' \
    -v /var/repos/alpine:/data \
    -v /var/sync-logs/alpine:/log \
    ustcmirror/rsync:latest &

mkdir -p /var/repos/ubuntu
docker run --rm \
    -e APTSYNC_URL='http://mirrors.ustc.edu.cn/ubuntu/' \
    -e APTSYNC_UNLINK=1 \
    -e APTSYNC_DISTS='ubuntu-lts|main multiverse restricted universe|amd64|/data' \
    -v /var/repos/ubuntu:/data \
    ustcmirror/apt-sync:latest &