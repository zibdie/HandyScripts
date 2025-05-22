# Useful Commands

## Find SSH Ports On a Network

Find an SSH port on a network. Useful for finding your headless Raspberry Pi

```
sudo apt-get update && sudo apt-get install -y nmap
nmap -p 22 --open 192.168.1.1-255
```


