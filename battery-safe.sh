#!/bin/bash
 
sudo dnf install tlp
echo "STOP_CHARGE_THRESH_BAT0=1" | sudo tee -a /etc/tlp.d/01-BatterySave.conf
 
 
sudo systemctl enable tlp.service
sudo systemctl start tlp.service
 
sudo tlp-stat -b