## Building OpenWRT

Before you start, enable credential caching (see https://www.softwaredeveloper.blog/git-credential-storage-libsecret for more info). This method stores the password on disk in plaintext so it's not very secure but it works out of the box on Linux:

    git config --global credential.helper store

Clone, download feeds and build:

    git clone http://185.243.54.141:9000/OpenWRT/openwrt.git
    cd openwrt
    ./update
    ./build feeds/thermoeye/config-ThermoEye.seed

To update a device already running this OpenWRT use: (`te-109` is the hostname, see below)

    ./update-remote te-109

To update a device running any version of Linux: (`root@192.168.0.109` is the target device)

    cat bin/targets/sunxi/cortexa53/openwrt-sunxi-cortexa53-sun50i-h5-nanopi-neo-core2-ext4-ramfs-sdcard.img.gz \
        | ssh root@192.168.0.109 \
              'gunzip > /dev/mmcblk0 && sync && reboot'

To burn the image to a local SD card (`/dev/rdisk3` is the SD card device):

    gunzip -c bin/targets/sunxi/cortexa53/openwrt-sunxi-cortexa53-sun50i-h5-nanopi-neo-core2-ext4-ramfs-sdcard.img.gz | \
        | sudo dd of=/dev/rdisk3 bs=10485760

## SSH configuration

To improve our SSH experience we can set some options. The fragments below can be appended to `~/.ssh/config`.

Setup an alias so for example `te-109` can be used to connect to `root@192.168.0.109` without complaining about `known_hosts` conflicts.

    Host te-*
      User root
      CheckHostIP no
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      ProxyCommand nc $(echo %h | sed -e 's/te-/192.168.0./') 22

Setup `ControlMaster` mode so SSH will reuse existing one authenticated connection (50ms to open a session) instead of authenticating each time (500ms over LAN). This also applies to `git`, `rsync` and `scp` running over SSH. If you need to kill a connection that got stuck you can wait 60 seconds or use `ssh -O exit <hostname>`.

    Host *
      ControlMaster auto
      ControlPath ~/.ssh/%C
      ControlPersist 600
      ServerAliveInterval 30
      ServerAliveCountMax 2
