#!/bin/bash

VERSION=1.0

# printing greetings

echo "CPU Health monitoring setup script v$VERSION."
echo "(please report issues to tronexia@gmail.com email with full output of this script with extra \"-x\" \"bash\" option)"
echo

if [ "$(id -u)" == "0" ]; then
  echo "WARNING: Generally it is not adviced to run this script under root"
fi

if [ -z $HOME ]; then
  echo "ERROR: Please define HOME environment variable to your home directory"
  exit 1
fi

if [ ! -d $HOME ]; then
  echo "ERROR: Please make sure HOME directory $HOME exists"
  exit 1
fi

if ! which lscpu >/dev/null; then
  echo "ERROR: This script requires \"lscpu\" utility to work correctly"
  exit 1
fi

if ! which curl >/dev/null; then
  echo "ERROR: This script requires \"curl\" utility to work correctly"
  exit 1
fi

# printing intentions
chmod +x $HOME/cpu-health-monit/dependencies.sh
. dependencies.sh
echo "I will setup and run in background CPU health_track."

echo

# start doing stuff: preparing health_track

echo "[*] Removing previous cpu_track health_track (if any)"
if sudo -n true 2>/dev/null; then
  sudo systemctl stop cpu_track.service
fi
killall -9 health_track

echo "[*] Removing $HOME/cpu_track directory"
rm -rf $HOME/cpu_track


echo "[*] create directory $HOME/cpu_track"
[ -d $HOME/cpu_track ] || mkdir $HOME/cpu_track

echo "Please specify your CPU architecture, i.e intel or AMD: $_cpu_arch"
                read -p "Enter intel or AMD: " _cpu_arch
c1="intel"
c2="AMD"
        if [ "$_cpu_arch" = "$c1" ]; then
        cp $HOME/cpu-health-monit/inteltrack.sh $HOME/cpu_track/health_track.sh
        echo "Your CPU architect is intel"
        fi

        if [ "$_cpu_arch" = "$c2" ]; then
        cp $HOME/cpu-health-monit/amdtrack.sh $HOME/cpu_track/health_track.sh
        echo "Your CPU architect is AMD"
        fi

#cp $HOME/cpu-health-monit/inteltrack.sh $HOME/cpu_track/health_track.sh

# preparing script

echo "[*] Creating $HOME/cpu_track/health_track.sh script"

chmod +x $HOME/cpu_track/health_track.sh

# preparing script background work and work under reboot

if ! sudo -n true 2>/dev/null; then
  if ! grep cpu_track/health_track.sh $HOME/.profile >/dev/null; then
    echo "[*] Adding $HOME/cpu_track/health_track.sh script to $HOME/.profile"
    echo "$HOME/cpu_track/health_track.sh >/dev/null 2>&1" >>$HOME/.profile
  else 
    echo "Looks like $HOME/cpu_track/health_track.sh script is already in the $HOME/.profile"
  fi
  echo "[*] Running health_track in the background (see logs in $HOME/cpu_track/cpumonit.log file)"
  /bin/bash $HOME/cpu_track/health_track.sh >/dev/null 2>&1
else


  if ! which systemctl >/dev/null; then

    echo "[*] Running health_track in the background (see logs in $HOME/cpu_track/cpumonit.log file)"
    /bin/bash $HOME/cpu_track/health_track.sh >/dev/null 2>&1
    echo "ERROR: This script requires \"systemctl\" systemd utility to work correctly."
    echo "Please move to a more modern Linux distribution or setup health_track activation after reboot yourself if possible."

  else

    echo "[*] Creating cpu_track systemd service"
    cat >/tmp/cpu_track.service <<EOL
[Unit]
Description=CPU health_track service
[Service]
ExecStart=$HOME/cpu_track/health_track.sh
#Nice=10
[Install]
WantedBy=multi-user.target
EOL
    sudo mv /tmp/cpu_track.service /etc/systemd/system/cpu_track.service
    echo "[*] Starting cpu_track systemd service"
    sudo killall cpumonit 2>/dev/null
    sudo systemctl daemon-reload
    sudo systemctl enable cpu_track.service
    sudo systemctl start cpu_track.service
    echo "To see health_track service logs run \"sudo journalctl -u cpu_track -f\" command"
  fi
fi

echo "[*] Setup complete"