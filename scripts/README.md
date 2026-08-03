# Package lists

Plain text, one package per line. `../bootstrap.sh` reads all three and installs
whatever is missing — repo packages via `pacman`, the rest via `yay`.

| File | Holds |
|---|---|
| `pkgs.txt` | CLI and general-purpose tools |
| `devTools.txt` | development: runtimes, editors, containers, browsers |
| `sysPkgs.txt` | system-level: fonts, X11/Wayland utilities, shells |

Format: blank lines are skipped, `#` comments out a package, and `-->` starts a
section header.

Adding a package? Append it to the right list and re-run `./bootstrap.sh` — it
installs only what's missing.
