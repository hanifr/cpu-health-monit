#!/bin/bash

# Install the software requirements

echo "${_GREEN}INSTALL DEPENDS STARTED${_RESET}"

#if [ "$_APT_DEPENDS" -eq "1" ]; then

        # Install xmrig depends	
#	sudo apt install -y software-properties-common git build-essential cmake libuv1-dev libssl-dev libmicrohttpd-dev libhwloc-dev gcc g++

	# Install xmrig-bash-scripts depends
#	sudo apt install -y jo cpuid screen

	# Install MQTT for temperature monitoring
	sudo apt install mosquitto mosquitto-clients
	sleep 5
	sudo ufw allow 1883
#fi

echo "${_CYAN}INSTALL DEPENDS STOPPED${_RESET}"