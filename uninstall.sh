#!/bin/bash

VERSION=1.0

# printing greetings

echo "MoneroOcean mining uninstall script v$VERSION."
echo "(please report issues to support@moneroocean.stream email with full output of this script with extra \"-x\" \"bash\" option)"
echo

if [ -z $HOME ]; then
  echo "ERROR: Please define HOME environment variable to your home directory"
  exit 1
fi

if [ ! -d $HOME ]; then
  echo "ERROR: Please make sure HOME directory $HOME exists"
  exit 1
fi

echo "[*] Removing  cpu health monitoring"
if sudo -n true 2>/dev/null; then
  sudo systemctl stop cpu_track.service
  sudo systemctl disable cpu_track.service
  rm -f /etc/systemd/system/cpu_track.service
  sudo systemctl daemon-reload
  sudo systemctl reset-failed
fi

sed -i '/cpu_track/d' $HOME/.profile
killall -9 health_track

echo "[*] Removing $HOME/cpu_track directory"
rm -rf $HOME/cpu_track

echo "[*] Uninstall complete"
