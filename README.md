# 🌌 Ubuntu Caelestia Build & One-Shot Installer

[![Ubuntu](https://img.shields.io/badge/Ubuntu-26.04_LTS_&_25.10-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Hyprland](https://img.shields.io/badge/Hyprland-0.53+-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)](https://hyprland.org/)
[![License](https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge)](LICENSE)

An automated build system and one-shot installer for running [Caelestia Shell](https://github.com/caelestia-dots/shell) — the gorgeous Quickshell-powered desktop shell for Hyprland — on Ubuntu.

Caelestia originally targets Arch Linux and the AUR. This project provides a fully automated toolchain that builds Quickshell from source, compiles `libcava`, applies Qt 6.10 compatibility patches, installs the required ligature fonts, configures systemd process supervision, and deploys verified Hyprland 0.53+ configs.

---

## ⚡ One-Shot Quick Install

Run this single command in your terminal to automatically detect your Ubuntu version and install the complete environment:

```bash
curl -fsSL https://raw.githubusercontent.com/arun2685/ubuntu-calestia-build/main/install.sh | bash
```

*Or using `wget`:*
```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/arun2685/ubuntu-calestia-build/main/install.sh)"
```

---

## 🛠️ Manual / Git Clone Installation

If you prefer to inspect the scripts or run step-by-step:

```bash
git clone https://github.com/arun2685/ubuntu-calestia-build.git
cd ubuntu-calestia-build
chmod +x install.sh
./install.sh
```

### Supported Ubuntu Versions

| OS Version | Compatibility Status | Installer | Guide |
|---|---|---|---|
| **Ubuntu 26.04 LTS** (Resolute Raccoon) | **Native APT Packages** | [`install-26.04.sh`](install-26.04.sh) | **[docs/ubuntu-26.04.md](docs/ubuntu-26.04.md)** |
| **Ubuntu 25.10** (Plucky Puffin) | **Supported** | [`install-25.10.sh`](install-25.10.sh) | **[docs/ubuntu-25.10.md](docs/ubuntu-25.10.md)** |

---

## ✨ Features & Fixes Included

* 📦 **Automated Quickshell Build:** Clones and builds the latest Quickshell against Qt6 with `-DCRASH_HANDLER=OFF`.
* 🎵 **Audio Visualizer Support:** Compiles the `LukashonakV` fork of `libcava` as a shared library for audio bars.
* 🧩 **Qt 6.10 Compatibility Patch:** Ubuntu 26.04 ships Qt 6.10.2 while upstream Caelestia targets 6.11. The bundled [`patches/qt6.10-compat.patch`](patches/qt6.10-compat.patch) patches all 3 breaking areas cleanly.
* 🔤 **Complete Font Provisioning:** Automatically downloads and registers **Material Symbols Rounded** (icon ligatures), **Rubik**, and **CaskaydiaCove Nerd Font**.
* 🛡️ **Systemd Process Supervision:** Includes `caelestia-shell.service` so that crashes or display re-attachments automatically restart your bar seamlessly.
* 🖥️ **Hyprland 0.53 Schema Compliant:** Fully updated `hyprland.conf` with new syntax (no deprecated `gestures {}` or legacy `windowrule =`).

---

## 🖼️ Live Previews

<p align="center">
  <img src="public/cu1.gif" alt="Caelestia Shell preview 1" width="90%">
</p>
<p align="center">
  <img src="public/cu2.gif" alt="Caelestia Shell preview 2" width="90%">
</p>
<p align="center">
  <img src="public/cu3.gif" alt="Caelestia Shell preview 3" width="90%">
</p>

---

## 📂 Repository Layout

```
install.sh                    Smart unified one-shot installer
install-26.04.sh              Automated 26.04 installer (packaged Hyprland 0.53)
install-25.10.sh              Automated 25.10 installer
docs/ubuntu-26.04.md          Comprehensive 26.04 walkthrough
docs/ubuntu-25.10.md          Comprehensive 25.10 walkthrough
patches/qt6.10-compat.patch   Qt 6.10.2 compatibility patch for Caelestia
config/26.04/                 Pre-tuned hyprland.conf, shell.json, qml_color.json, systemd service
config/25.10/                 Configuration templates for 25.10
```

---

## 🚀 Post-Installation

Once the installer finishes:
1. Log out of your current session.
2. At the GDM / SDDM login screen, click the gear icon ⚙️ and select **Hyprland**.
3. Log in — Caelestia Shell and Hyprland will start automatically via systemd user service.

To control the shell manually:
```bash
# Check status
systemctl --user status caelestia-shell.service

# Restart shell
systemctl --user restart caelestia-shell.service
```

---

## 🤝 Credits & Acknowledgements

- [Caelestia Dots](https://github.com/caelestia-dots) — Original shell creation by Scout
- [IshmamDC217](https://github.com/IshmamDC217) — Original Ubuntu adaptation and Qt 6.10 patches
- [Hyprland](https://hyprland.org/) by [@vaxry](https://github.com/vaxerski)
- [Quickshell](https://quickshell.outfoxxed.me/) by [@outfoxxed](https://github.com/outfoxxed)
- [LukashonakV](https://github.com/LukashonakV) — libcava library fork

## 📄 License

GPL-3.0 License.
