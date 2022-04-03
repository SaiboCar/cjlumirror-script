#!/usr/bin/sudo /bin/sh
mkdir -p /var/sync-logs/alpine /var/repos/alpine
docker stop syncalpine
docker run --name syncalpine --rm \
    -e LOG_ROTATE_CYCLE='5' \
    -e RSYNC_HOST='rsync.mirrors.ustc.edu.cn' \
    -e RSYNC_PATH='alpine/' \
    -e RSYNC_MAXDELETE='10000' \
    -v /var/repos/alpine:/data \
    -v /var/sync-logs/alpine:/log \
    ustcmirror/rsync:latest &

mkdir -p /var/repos/ubuntu
rm -fr /var/repos/ubuntu/ubuntu
ln -s .. /var/repos/ubuntu/ubuntu
docker stop syncubuntu
docker run --name syncubuntu --rm \
    -e APTSYNC_URL='http://mirrors.ustc.edu.cn/ubuntu/' \
    -e APTSYNC_UNLINK=1 \
    -e APTSYNC_DISTS='bionic focal|main multiverse restricted universe|amd64' \
    -e TO='/data' \
    -v /var/repos/ubuntu:/data \
    ustcmirror/aptsync:latest &