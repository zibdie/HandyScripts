# Nmap

## Local Scan for Port 22

Find all devices in the 192.168.1.1-255 range for any device with port 22 open

```
sudo apt-get update && sudo apt-get install -y nmap
nmap -p 22 --open 192.168.1.1-255
```