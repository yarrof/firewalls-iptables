#/bin/sh
# Leave this command here
sudo iptables -F
# Write your commands after this comment
sudo iptables -I INPUT -p tcp --dport 22 -j REJECT