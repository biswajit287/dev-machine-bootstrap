# 🚀 DEV-MACHINE-BOOTSTRAP

A modular, idempotent, and cross-platform (macOS/Linux) environment bootstrapper. This project automates the transition from a fresh OS install to a fully configured development machine.


## 📂 Project Structure

The project is organized into logical layers to separate core logic from tool-specific implementation:

* **`install.sh`**: The main entry point. It orchestrates the sequence of operations.
* **`config.yaml`**: The single source of truth for your configuration (versions, features, aliases, and apps).
* **`lib/`**: Core internal logic and system-level utilities.
    * `os_detect.sh`: Detects if the environment is macOS or a Linux distribution.
    * `pkg_manager.sh`: Abstracted installer logic handling `brew` (Mac) and `apt`/`snap` (Linux).
    * `utils.sh`: Global helpers like YAML parsing and the `run` execution wrapper.
* **`modules/`**: High-level category orchestrators (e.g., `terminal.sh`, `mobile.sh`, `infra.sh`).
    * **`helpers/`**: Granular, tool-specific scripts (e.g., `zsh.sh`, `flutter.sh`, `docker.sh`) that perform the actual installation and configuration.

---

## ⚠️ Compatibility Warning

> [!IMPORTANT]
> **Note:** This script is currently optimized and tested for macOS. Support for Linux distributions (Ubuntu/Debian) is in the architectural phase and has not yet been fully verified.

## 🛠 Features
**Idempotency:** Safe to run multiple times; it detects existing installs and only updates what is necessary.

**Cross-Platform:** Intelligent switching between brew (Mac) and apt/snap (Linux).

**Category-Wise:** Easily skip entire sections (like Mobile or Infrastructure) by toggling flags in the config.

**Zsh Integration:** Automatically manages Oh My Zsh plugins, themes, and a dedicated .zsh_aliases file.

---

## ⚙️ Configuration

Before running the bootstrap, customize the `config.yaml` file. This allows you to toggle specific languages, infrastructure tools, and mobile SDKs.

```yaml

features:
  node: true
  docker: true
  flutter: true

terminal:
  theme: "powerlevel10k"
  aliases:
    gs: "git status"
    ll: "ls -lah"
```

## 🚀 Usage

This project is designed to be safe, repeatable, and transparent. Follow these steps to bootstrap your machine.

### 1. Initial Setup
Clone the repository and ensure the execution permissions are set for the core scripts:

```bash

git clone https://github.com/biswajit287/dev-machine-bootstrap.git

cd dev-machine-bootstrap

chmod +x install.sh
```

### 2. Configuration

Open `config.yaml` and toggle the features you need. This is where you define your "Source of Truth" for the environment.

### 3. Execution

<!-- #### Dry Run (Recommended First Step)

Before making any changes to your system, verify what the script will do. Set `dry_run: true` in `config.yaml`.

```bash
./install.sh
```

In this mode, the script will log every command it would execute (prefixed with [DRY RUN]) without actually installing anything. -->

Run the script to start installation:

```bash
./install.sh
```

## ⚖️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.