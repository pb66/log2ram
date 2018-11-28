#!/usr/bin/env sh

if [ "$(id -u)" -eq 0 ]
then
  service log2ram stop
  systemctl disable log2ram
  rm /etc/systemd/system/log2ram.service
  rm /usr/local/bin/log2ram
  rm /etc/log2ram.conf
  rm /etc/cron.hourly/log2ram
  rm /etc/logrotate.d/log2ram
  rm /etc/logrotate.d/00_olddir

  if [ -d /var/log.bak ]; then
    rm -r /var/log.bak
  fi
  if [ -d /var/log.old ]; then
    # TODO: maybe rotated logs should be moved back to /var/log?
    rm -r /var/log.old
  fi
  echo "Log2Ram is uninstalled, removing the uninstaller in progress"
  rm /usr/local/bin/uninstall-log2ram.sh
  echo "##### Reboot isn't needed #####"
else
  echo "You need to be ROOT (sudo can be used)"
fi
