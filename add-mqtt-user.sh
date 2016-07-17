#!/bin/sh

passwd=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1`

echo "Adding/updating password in mosquitto password file";
sudo touch /etc/mosquitto/pwfile
sudo mosquitto_passwd -b /etc/mosquitto/pwfile hass $passwd

echo "Adding mqtt configuration section to configuration.yaml"
cat <<EOF | sudo tee -a ~hass/.homeassistant/configuration.yaml >/dev/null
mqtt:
  broker: 127.0.01
  port: 1883
  client_id: home-assistant-1
  username: hass
  password: $passwd

EOF

echo "Restating Home Assistant"
sudo systemctl restart home-assistant
echo "All set! Your mosquitto installation should now work with mosquitto"
