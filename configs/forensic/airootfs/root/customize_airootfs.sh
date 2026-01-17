#!/usr/bin/env bash
set -e -u

echo "Customizing Forensic Arch ISO environment..."

systemctl enable NetworkManager

useradd -m -G wheel,audio,video,storage,optical -s /bin/bash forensics
echo "forensics:forensics" | chpasswd

mkdir -p /etc/sudoers.d
chmod 750 /etc/sudoers.d

echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

mkdir -p /etc/systemd/system/getty@tty1.service.d
cat >/etc/systemd/system/getty@tty1.service.d/autologin.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin forensics %I \$TERM
EOF

cat >/home/forensics/.bash_profile <<'PROFILE_EOF'
# Auto-run installer on first login
if [ ! -f ~/.forensic-arch-installed ]; then
    clear
    echo "═══════════════════════════════════════════════════════════"
    echo "  Welcome to Forensic Arch Live Environment"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Starting Forensic Arch installation..."
    echo "This will download and install the full system configuration."
    echo ""
    
    # Try to download and run the installer
    if bash <(curl -sL https://raw.githubusercontent.com/OSPI-26/forensic-arch/main/boot.sh); then
        touch ~/.forensic-arch-installed
        echo ""
        echo "✓ Installation complete!"
        echo ""
        read -p "Press Enter to reboot..."
        sudo reboot
    else
        echo ""
        echo "✗ Installation failed. Check your internet connection."
        echo "  You can manually install later by running:"
        echo "  bash <(curl -sL https://raw.githubusercontent.com/OSPI-26/forensic-arch/main/boot.sh)"
        echo ""
    fi
fi
PROFILE_EOF

chown forensics:forensics /home/forensics/.bash_profile

echo "forensic-arch" >/etc/hostname

cat >/etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   forensic-arch.localdomain forensic-arch
EOF

echo "en_US.UTF-8 UTF-8" >/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >/etc/locale.conf

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

cat >/etc/motd <<'EOF'

  ╔═══════════════════════════════════════════════════════════╗
  ║                                                           ║
  ║              FORENSIC ARCH LIVE ENVIRONMENT               ║
  ║                                                           ║
  ║  A modern Arch Linux distribution for digital forensics   ║
  ║                                                           ║
  ╚═══════════════════════════════════════════════════════════╝

  Default credentials:
    Username: forensics
    Password: forensics

  The installer will start automatically on first login.

EOF

echo "Customization complete!"
