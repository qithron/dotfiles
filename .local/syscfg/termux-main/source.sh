root=/data/data/com.termux/files
list() { cat << --
home/.termux/shell
home/.termux/termux.properties
usr/etc/profile
usr/etc/zprofile
usr/etc/zshrc
usr/var/service/pulseaudio/run
--
}
