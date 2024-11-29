#!/bin/bash
# MAKE THIS CHANGES FROM ROOT (sudo -i)
#
# CHOOSE VERSION
VERSION=3.13.7
# adduser ts
adduser --disabled-login teamspeak

# wget ts3 from site
wget https://files.teamspeak-services.com/releases/server/$VERSION/teamspeak3-server_linux_amd64-$VERSION.tar.bz2

# untar ts3 archive
mv /home/dmeyer/teamspeak3-server_linux_amd64-$VERSION.tar.bz2 /home/teamspeak/ && cd /home/teamspeak/ && tar xvjf teamspeak3-server_linux_amd64-$VERSION.tar.bz2 

# clean folder
cd teamspeak3-server_linux_amd64 &&  mv * /home/teamspeak/ && cd ..
rm -rf teamspeak3-server_linux_amd64*

# make rights to user
chown -R teamspeak:teamspeak /home/teamspeak

# to license ts3
touch .ts3server_license_accepted

# create systemd service
echo "[Unit]
Description=TS3-Server
After=network.target
[Service]
WorkingDirectory=/home/teamspeak/
User=teamspeak
Group=teamspeak
Type=forking
ExecStart=/home/teamspeak/ts3server_startscript.sh start inifile=ts3server.ini
ExecStop=/home/teamspeak/ts3server_startscript.sh stop
PIDFile=/home/teamspeak/ts3server.pid
RestartSec=25
Restart=always
[Install]
WantedBy=multi-user.target" >> /lib/systemd/system/teamspeak.service


# start and enable ts3.service
systemctl enable teamspeak.service
systemctl start teamspeak.service
systemctl status teamspeak.service

# get token for first connect 
# этот токен сохраните себе куда-то, т.к. при первом входе на сервак он понадобится
cat /home/teamspeak/logs/ts3server_* | grep -o 'token.*' | cut -f2- -d=

# done
echo "DONE!"
