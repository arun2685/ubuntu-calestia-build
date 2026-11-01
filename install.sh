#!/usr/bin/env bash
#
# 🌌 Ubuntu Caelestia Build — One-Shot Automated Installer
# https://github.com/arun2685/ubuntu-calestia-build
#
# Builds & installs Hyprland + Quickshell + Caelestia Shell on Ubuntu in one command.
# Compatible with Ubuntu 26.04 LTS (Resolute Raccoon) & Ubuntu 25.10 (Plucky Puffin).
#

set -euo pipefail

# ── Color Palette ─────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*"; }
step()  { echo -e "\n${CYAN}${BOLD}══ $* ══${NC}"; }
banner() {
    echo -e "${PURPLE}${BOLD}"
    cat << "EOF"
  ____           _           _   _         ____  _          _ _ 
 / ___|__ _  ___| | ___  ___| |_(_) __ _  / ___|| |__   ___| | |
| |   / _` |/ _ \ |/ _ \/ __| __| |/ _` | \___ \| '_ \ / _ \ | |
| |__| (_| |  __/ |  __/\__ \ |_| | (_| |  ___) | | | |  __/ | |
 \____\__,_|\___|_|\___||___/\__|_|\__,_| |____/|_| |_|\___|_|_|
                     Ubuntu Build & One-Shot Installer
EOF
    echo -e "${NC}"
}

# ── Root Check ────────────────────────────────────────────────────────────────
if [[ "$(id -u)" -eq 0 ]]; then
    err "Please run this installer as a normal user with sudo privileges, not as root."
    exit 1
fi

REPO_URL="https://github.com/arun2685/ubuntu-calestia-build.git"
CLONE_DIR="$HOME/ubuntu-calestia-build"

# ── Pipe / Curl Detection ─────────────────────────────────────────────────────
# If running through `curl ... | bash`, download repository first and re-exec with tty
IS_PIPED=0
if [[ ! -t 0 ]] || [[ ! -f "${BASH_SOURCE[0]:-}" ]] || [[ ! -f "$(dirname "${BASH_SOURCE[0]:-}")/install-26.04.sh" ]]; then
    IS_PIPED=1
fi

if [[ "$IS_PIPED" -eq 1 ]]; then
    banner
    step "Step 0: Bootstrapping Repository for One-Shot Execution"

    # Ensure git and curl exist
    if ! command -v git &>/dev/null; then
        info "Installing git..."
        sudo apt-get update -y && sudo apt-get install -y git curl
    fi

    if [[ -d "$CLONE_DIR/.git" ]]; then
        info "Updating existing repository at $CLONE_DIR..."
        cd "$CLONE_DIR" && git pull --ff-only || true
    else
        info "Cloning $REPO_URL to $CLONE_DIR..."
        git clone "$REPO_URL" "$CLONE_DIR"
    fi

    cd "$CLONE_DIR"
    chmod +x install.sh install-26.04.sh install-25.10.sh 2>/dev/null || true

    # Re-exec with terminal standard input so sudo prompts work
    exec </dev/tty
    exec ./install.sh "$@"
fi

# ── Main Installer Logic ──────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

banner

# Detect Ubuntu version
if [[ ! -f /etc/os-release ]]; then
    err "Cannot determine OS release: /etc/os-release missing."
    exit 1
fi

. /etc/os-release
UBUNTU_VER="${VERSION_ID:-}"
PRETTY="${PRETTY_NAME:-Linux}"

echo -e "${BOLD}Detected System:${NC} ${CYAN}$PRETTY (Ubuntu $UBUNTU_VER)${NC}"

case "$UBUNTU_VER" in
    "26.04")
        step "Target Selected: Ubuntu 26.04 LTS (Resolute Raccoon)"
        info "Using packaged Hyprland 0.53 + Qt 6.10 compatibility patches."
        exec ./install-26.04.sh "$@"
        ;;
    "25.10")
        step "Target Selected: Ubuntu 25.10 (Plucky Puffin)"
        info "Using standalone Caelestia build + Hyprland components."
        exec ./install-25.10.sh "$@"
        ;;
    *)
        warn "Ubuntu version $UBUNTU_VER detected."
        echo ""
        echo "Which installer would you like to run?"
        echo "  1) Ubuntu 26.04 LTS mode (Recommended if you have modern Hyprland packages)"
        echo "  2) Ubuntu 25.10 mode (Custom Hyprland installer route)"
        echo "  3) Cancel"
        read -rp "Select [1-3]: " choice
        case "$choice" in
            1)
                exec ./install-26.04.sh "$@"
                ;;
            2)
                exec ./install-25.10.sh "$@"
                ;;
            *)
                echo "Installation aborted."
                exit 0
                ;;
        esac
        ;;
esac
