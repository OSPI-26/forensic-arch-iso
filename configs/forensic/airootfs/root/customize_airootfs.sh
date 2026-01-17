#!/usr/bin/env bash
set -e -u

echo "Customizing Forensic Arch ISO environment..."

# Enable essential services
systemctl enable NetworkManager

mkdir -p /etc/sudoers.d
chmod 750 /etc/sudoers.d

# Create forensics user
useradd -m -G wheel -s /bin/bash forensics
echo "forensics:forensics" | chpasswd
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

# Set up auto-login
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat >/etc/systemd/system/getty@tty1.service.d/autologin.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin forensics %I \$TERM
EOF

# Create installer launcher script
cat >/home/forensics/.bash_profile <<'PROFILE_EOF'
if [ ! -f ~/.installer-launched ]; then
    clear
    echo "═══════════════════════════════════════════════════════════"
    echo "  FORENSIC ARCH INSTALLER"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "This will install Arch Linux with Forensic Arch configuration."
    echo ""
    
    # Run archinstall
    sudo archinstall
    
    # After archinstall completes, offer to install Forensic Arch
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  Base system installed!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    read -p "Install Forensic Arch configuration now? [Y/n]: " install_config
    
    if [[ ! $install_config =~ ^[Nn]$ ]]; then
        echo "Installing Forensic Arch to /mnt..."
        
        # Chroot and install
        sudo arch-chroot /mnt /bin/bash <<'CHROOT_EOF'
# Inside the installed system now
pacman -Sy --noconfirm git curl

# Run the Forensic Arch installer
bash <(curl -sL https://raw.githubusercontent.com/YOURUSERNAME/forensic-arch/main/boot.sh)
CHROOT_EOF
        
        echo ""
        echo "✓ Installation complete!"
        echo ""
        read -p "Reboot now? [Y/n]: " do_reboot
        if [[ ! $do_reboot =~ ^[Nn]$ ]]; then
            sudo reboot
        fi
    fi
    
    touch ~/.installer-launched
fi
PROFILE_EOF

chown forensics:forensics /home/forensics/.bash_profile

# Welcome message
cat >/etc/motd <<'EOF'
  ╔═══════════════════════════════════════════════════════════╗
  ║              FORENSIC ARCH INSTALLER                      ║
  ║  This will install Arch Linux + Forensic configuration    ║
  ╚═══════════════════════════════════════════════════════════╝
EOF

echo "Customization complete!"
