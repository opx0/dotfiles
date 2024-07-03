#!/bin/bash

# Define the path to the text file containing package names
PACKAGE_FILE="packages.txt"

# Check if the package file exists
if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Package file '$PACKAGE_FILE' not found."
    exit 1
fi

# Loop through each package name in the file and install it
while IFS= read -r package; do
    # Check if the package is available in the repositories
    if pacman -Qi "$package" &>/dev/null || yay -Qi "$package" &>/dev/null; then
        echo "$package is already installed."
    else
        # Install the package using pacman if available, otherwise using yay
        if pacman -Ss "$package" &>/dev/null; then
            sudo pacman -S --noconfirm "$package"
        else
            yay -S --noconfirm "$package"
        fi
    fi
done < "$PACKAGE_FILE"

echo "All packages have been installed."

