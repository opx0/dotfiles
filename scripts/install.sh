#!/bin/bash

PACKAGE_FILES=("pkgs.txt" "devTools.txt" "sysPkgs.txt")

for PACKAGE_FILE in "${PACKAGE_FILES[@]}"; do
  if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Package file '$PACKAGE_FILE' not found."
    exit 1
  fi

  while IFS= read -r package; do
    if pacman -Qi "$package" &>/dev/null || yay -Qi "$package" &>/dev/null; then
      echo "$package is already installed."
    else
      if pacman -Ss "$package" &>/dev/null; then
        sudo pacman -S --noconfirm "$package"
      else
        yay -S --noconfirm "$package"
      fi
    fi
  done < "$PACKAGE_FILE"
done

echo "All packages have been installed."
