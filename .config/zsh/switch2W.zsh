reboot-windows() {
    # Confirmed entry name from your system
    local WINDOWS_ENTRY="Windows Boot Manager (on /dev/nvme0n1p1)"

    echo "Setting next boot to: $WINDOWS_ENTRY"

    # Set the "once-only" boot target
    sudo grub-reboot "$WINDOWS_ENTRY"

    # Check if grub-reboot was successful before rebooting
    if [ $? -eq 0 ]; then
        echo "Success. Rebooting now..."
        reboot
    else
        echo "Error: Failed to set GRUB entry. Is GRUB_DEFAULT=saved set?"
    fi
}
