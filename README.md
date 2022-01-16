# Firewalls and `iptables`

## Story

So you've have heard that Linux firewalls are tougher than in Windows and you needed to see it for yourself.

Not sure if this is legit info or not, but it is sure as hell tougher to _configure_ it ... yeah, you've guessed it, back to the command-line soldier!

## What are you going to learn?

* How to use `iptables`
* How to enable/disable traffic on specified ports and protocols
* What are different _chains_ like `INPUT` and `OUTPUT` in `iptables`
* How to disable `ping`
* Learn what is a firewall in a general sense

## Tasks

1. Start and configure a VM with bridged network settings.
    - Started a VM loaded and configured with an SSH server (either an existing one or a fresh one using [this image](https://github.com/CodecoolBase/short-admin-vms/releases/latest/download/ubuntu-18.04-base.ova))
    - The VM's Network settings are configured with a single _Bridged Adapter_
    - Determined the VM's IP address (most probably received and served via the DHCP server on the local network, e.g. the home router)

2. Use `ping` on your host machine to ping the guest VM's local address.
    - `ping` reports sucess, e.g. something like `Packets: Sent = 4, Received = 4, Lost = 0 (0% loss)` among other things

3. Configure `iptables` on the guest VM so that it rejects/blocks ICMP requests sent by `ping` from all other hosts.
    - One or more rules are added to `iptables` to reject ICMP echo requests (and just these)
    - Pinging the guest VM from the host the response is `Destination port is unreachable`
    - Save commands used to setup the `iptables` rules in `reject-ping.sh`

4. Configure `iptables` on the guest VM so that it drops ICMP requests sent by `ping` from all other hosts.
    - One or more rules are added to `iptables` to drop ICMP echo requests (and just these)
    - Pinging the guest VM from the host the response is `Request timed out`
    - Save commands used to setup the `iptables` rules in `drop-ping.sh`

5. Configure the guest VM so that it blocks every incoming SSH conncetion.
    - One or more rules are added to `iptables` to drop TCP packets destined to port 22
    - Trying to connect to the guest VM via `ssh` times out after a while with a message like `ssh: connect to host <guest IP> port 22: Connection timed out`
    - Save commands used to setup the `iptables` rules in `reject-ssh.sh`

6. It's not a good idea to block every SSH traffic to a remote server (it's easy to lock yourself out of a system like this). Add a rule to allow TCP connections on port 22 from your host machine, but not from other machines (e.g. other VMs using bridged networking, etc.).
    - One or more rules are added to `iptables` to drop TCP packets destined to port 22 except if they originate from your host machine
    - Trying to connect to the guest VM via `ssh` from your host machine works
    - Trying to connect to the guest VM via `ssh` from any computer or VM other than your host machines times out after a while
    - Save commands used to setup the `iptables` rules in `reject-ssh-except.sh`

## General requirements

None

## Hints

- You can modify a VM's network adapters via the VirtualBox application by going to _Network_ section in the VM's _Settings_
- Use `iptables` as root or prepend commands with `sudo`
- Make sure to study the following `iptables` flags:
  - `-A`, append
  - `-I`, insert
  - `-D`, delete
  - `-F`, flush
  - `-p` or `--protocol`
  - `--dport` or `--destination-port`
  - `-j` or `--jump`
- In rules you can specify the source and destination ports with `--sport` and the `--dport` flags, but **be aware** that these are used to match the source and destination ports specified on **incoming/leaving packets**, so if you want to block traffic _arriving_ to a host on port 22 you need to use the `--dport` flag not `--sport`
- This project requires you to modify the `INPUT` chain with `iptables`, but you have the option to work with the `OUTPUT` chain which is useful in preventing certain applications on the host to initiate outbound network connections
- In `iptable` rules using
  - `REJECT` as a target will notify the sender that the packet being sent was rejected
  - `DROP` as a target will simply drop the packet being sent and sender won't now for sure what happened, which essentially can _hide_ your computer or certain ports, services on it
- **Never** block all incoming SSH traffic via `iptables` without adding exceptions, because you'll lock yourself out of the remote system :)
- After reboot `iptables` rules are gone, but you can take a look at how to make them permanent ;)
- **When you are reading background materials:**
  - [iptables tutorial](https://www.hostinger.com/tutorials/iptables-tutorial)
    - Installing `iptables` won't be necessary
  - [iptables manual](https://linux.die.net/man/8/iptables)
    - The manual contains lots of examples, search for `-p tcp` and/or `-p icmp` to find specific examples

## Background materials

- <i class="far fa-exclamation"></i> [iptables tutorial](https://www.hostinger.com/tutorials/iptables-tutorial)
- [iptables manual](https://linux.die.net/man/8/iptables)
- [How to block all `ssh` traffic except yours](https://mikeeverhart.net/2015/04/how-to-use-iptables-to-block-all-ssh-traffic-port-22-except-for-your-ip/)
- <i class="far fa-book-open"></i> [Using `ufw`, an alternative `iptables` interface](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04)
