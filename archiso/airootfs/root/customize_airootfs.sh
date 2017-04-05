#!/bin/bash


set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/zsh liveuser
#chmod 700 /root
chown -R liveuser:users /home/liveuser


sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

#solving obmenu crash
sed -i 's/exec openbox-session/#exec openbox-session/' ~/.xinitrc
sed -i 's/#exec openbox-session/exec openbox-session/' ~/.xsession

systemctl enable pacman-init.service choose-mirror.service NetworkManager.service
systemctl set-default multi-user.target
pacman -Syy
gpg --receive-keys C1A60EACE707FDA5