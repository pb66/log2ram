#!/usr/bin/env sh
# wget -qO- https://raw.githubusercontent.com/pb66/log2ram/install-dev/install-dev.sh | sudo sh

systemctl -q is-active log2ram  && { echo "ERROR: log2ram service is still running. Please run \"sudo service log2ram stop\" to stop it."; exit 1; }
[ "$(id -u)" -eq 0 ] || { echo "You need to be ROOT (sudo can be used)"; exit 1; }

if ! command -v git > /dev/null; then
    apt-get update && apt-get -y install git || echo "Git not available, exiting!"; exit 0
fi

REPO_PATH=/home/pi/
L2R_REPO_PATH=${REPO_PATH}/log2ram

mkdir -p ${REPO_PATH}
git clone https://github.com/pb66/log2ram.git ${L2R_REPO_PATH}

# log2ram
mkdir -p /usr/local/bin/
ln -sf ${L2R_REPO_PATH}log2ram.service /etc/systemd/system/log2ram.service
#install -m 644 log2ram.service /etc/systemd/system/log2ram.service
ln -sf ${L2R_REPO_PATH}log2ram /usr/local/bin/log2ram
#install -m 755 log2ram /usr/local/bin/log2ram
ln -sf ${L2R_REPO_PATH}log2ram.conf /etc/log2ram.conf
#install -m 644 log2ram.conf /etc/log2ram.conf
#install -m 644 uninstall.sh /usr/local/bin/uninstall-log2ram.sh
systemctl enable log2ram.service

# cron
printf "# See /etc/cron.hourly/log2ram for logrotate cron entry.\n" > /etc/cron.daily/logrotate
ln -sf ${L2R_REPO_PATH}log2ram.cron /etc/cron.hourly/log2ram
#install -m 755 log2ram.cron /etc/cron.hourly/log2ram
ln -sf ${L2R_REPO_PATH}log2ram.logrotate /etc/logrotate.d/00-log2ram
#install -m 644 log2ram.logrotate /etc/logrotate.d/00-log2ram

# Remove a previous log2ram version
  rm -rf /var/log.hdd
  rm -rf /var/hdd.log

# Make sure we start clean
rm -rf /var/log.bak
rm -rf /var/log.old

echo "##### Reboot to activate log2ram #####"
