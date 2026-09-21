# television

Context-aware fuzzy finder. Installed from `scripts/pkgs.txt`, initialised in
`.zshrc` (deferred, label `television-init`).

## What it gives you over plain fzf

`ctrl-t` does not open one generic file picker. It looks at what is already on
the command line and opens the channel that matches:

| You type | `ctrl-t` opens | keys inside |
|---|---|---|
| `git checkout ` | branches | `enter` checkout · `ctrl-d` delete · `ctrl-m` merge · `ctrl-r` rebase |
| `git add ` | changed files (diff preview) | |
| `git log ` | commits | `ctrl-y` cherry-pick · `ctrl-r` revert · `ctrl-o` checkout |
| `docker run ` | images | |
| `cd `, `ls `, `z ` | directories | |
| `cat`, `nvim`, `bat`, `cp`, `mv` … | files | |
| `export `, `unset ` | env vars | |
| `alias `, `unalias ` | aliases | |
| anything else | files (fallback) | |

Other channels are reachable with `tv <name>` or `ctrl-r` *inside* tv (remote
control). `tv channels` lists them all.

## Keys

- `ctrl-t` — smart autocomplete (the table above)
- `ctrl-alt-r` — tv's own history channel
- **`ctrl-r` is deliberately NOT bound to tv** — atuin owns it. atuin is the
  better history search here (sync, dedup, stats, per-directory filtering), so
  `television-init` loads at zinit label `0c`, *after* `atuin-init` at `0b`,
  which stops tv taking the binding back.

## Local changes to the upstream channels

- `files.toml` — `shell = "nu"` → `"zsh"` (upstream author runs nushell)
- `zsh-history.toml` — reads `~/.local/state/zsh/history`; `.zshrc` sets
  `HISTFILE` but does not export it, so a subshell would not inherit it
- dropped as non-applicable: `brew-packages`, `bash-history`, `nu-history`,
  `wt-list`, `sesh`, `aws-*`

Channels are plain TOML — copy one in `cable/` and edit to add your own.
