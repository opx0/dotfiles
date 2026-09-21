# opencode

Agents, skills and commands for the `opencode` CLI (installed from
`scripts/devTools.txt`). Model wrappers live in `.config/zsh/opencode.zsh`.

`~/.config/opencode` is a real directory (it holds an npm project), so stow
folds these in as individual symlinks rather than linking the whole tree.

| Path | |
|---|---|
| `skills/ship/` | "ship it" — rebase, commit, push, open a PR |
| `agent/` | specialist agent definitions |
| `command/` | `/build`, `/scan` slash commands |
| `tui.json` | TUI keymap, leader is `ctrl+o` |

## Local changes to the upstream copies

- **Model pins removed** from every agent. Upstream pinned
  `anthropic/claude-sonnet-4-6` and `opencode/big-pickle`; the agents now
  inherit whatever default model is configured, so they work regardless of
  which providers are authenticated.
- **`ship` skill**: step 7 posted `/oc review` unconditionally, which only does
  anything in repos running the opencode GitHub Action. It now checks
  `.github/workflows/` first and skips silently otherwise.
- **`ship` skill**: no longer assumes the base branch is `main`; it detects the
  remote default branch via `origin/HEAD`.
