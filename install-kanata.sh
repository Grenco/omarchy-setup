#!/bin/sh

echo "Installing kanata..."

# Install kanata if not already installed
if ! command -v kanata &> /dev/null; then
    echo "Installing kanata-bin..."
    yay -S --needed --noconfirm kanata-bin
else
    echo "kanata already installed, skipping..."
fi

# Add user to required groups if not already a member
if ! groups $USER | grep -q '\binput\b'; then
    echo "Adding user to input group..."
    sudo usermod -aG input $USER
else
    echo "User already in input group, skipping..."
fi

if ! groups $USER | grep -q '\buinput\b'; then
    echo "Adding user to uinput group..."
    sudo usermod -aG uinput $USER
else
    echo "User already in uinput group, skipping..."
fi

# Create uinput group if it doesn't exist
if ! getent group uinput &> /dev/null; then
    echo "Creating uinput group..."
    sudo groupadd uinput
else
    echo "uinput group already exists, skipping..."
fi

# Set up udev rule for uinput device
if [ ! -f /etc/udev/rules.d/99-uinput.rules ]; then
    echo "Setting up udev rules..."
    echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-uinput.rules
else
    echo "udev rules already exist, skipping..."
fi

# Load uinput kernel module
if ! lsmod | grep -q uinput; then
    echo "Loading uinput kernel module..."
    sudo modprobe uinput
else
    echo "uinput module already loaded, skipping..."
fi

# Make uinput load on boot
if [ ! -f /etc/modules-load.d/uinput.conf ]; then
    echo "Configuring uinput to load on boot..."
    echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
else
    echo "uinput already configured to load on boot, skipping..."
fi

# Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules && sudo udevadm trigger

# Create systemd user service
mkdir -p ~/.config/systemd/user
if [ ! -f ~/.config/systemd/user/kanata.service ]; then
    echo "Creating systemd user service..."
    cat > ~/.config/systemd/user/kanata.service << 'EOF'
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStart=/usr/bin/kanata -c %h/.config/kanata/kanata.kbd
Restart=on-failure

[Install]
WantedBy=default.target
EOF
else
    echo "systemd service already exists, skipping..."
fi

# Reload systemd user daemon
systemctl --user daemon-reload

# Enable and start kanata service if not already enabled
if ! systemctl --user is-enabled kanata &> /dev/null; then
    echo "Enabling and starting kanata service..."
    systemctl --user enable --now kanata
else
    echo "kanata service already enabled, skipping..."
fi

echo ""
echo "Kanata installation complete!"
echo ""
echo "NOTE: You may need to log out and back in (or reboot) for group changes to take effect."
echo "Kanata will start automatically on login going forward."
echo ""
echo "Make sure your kanata config exists at: ~/.config/kanata/kanata.kbd"
