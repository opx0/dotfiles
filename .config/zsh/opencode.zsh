# ==========================================
#  OPENCODE FUNCTIONS (No quotes needed!)
# ==========================================

# Helper function to handle arguments
function _oc_run() {
    local model="$1"
    shift
    # If arguments are passed, join them into a string.
    # If no arguments, it might wait for piped input (stdin).
    if [ "$#" -gt 0 ]; then
        opencode run -m "$model" "$*"
    else
        # Handle piping: echo "logs" | oc-code
        opencode run -m "$model"
    fi
}

# --- 1. PRIMARY: GitHub Copilot ---
function oc-code()  { _oc_run "github-copilot/claude-3.5-sonnet" "$@"; }
function oc-think() { _oc_run "github-copilot/claude-3.7-sonnet-thought" "$@"; }
function oc-gpt()   { _oc_run "github-copilot/gpt-4o" "$@"; }
function oc-logic() { _oc_run "github-copilot/o3-mini" "$@"; }

# --- 2. BACKUP A: Google Direct ---
function oc-fast()   { _oc_run "google/gemini-2.0-flash" "$@"; }
function oc-backup() { _oc_run "google/gemini-2.5-pro" "$@"; }

# --- 3. BACKUP B: OpenRouter ---
function oc-deep() { _oc_run "openrouter/deepseek/deepseek-r1:free" "$@"; }
function oc-free() { _oc_run "openrouter/google/gemini-2.0-flash-exp:free" "$@"; }
function oc-qwen() { _oc_run "openrouter/qwen/qwen-2.5-coder-32b-instruct" "$@"; }

# --- 4. Utilities ---
alias oc='opencode run'
alias oc-models='opencode models'
