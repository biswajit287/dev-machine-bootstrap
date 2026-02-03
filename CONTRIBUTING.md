# Contributing to DEV-MACHINE-BOOTSTRAP

First off, thank you for considering contributing! To maintain the stability and portability of this bootstrap, please follow these guidelines.



## 🛠 Development Principles

1. **Idempotency is Mandatory**: Every script must be safe to run multiple times. Always check if a directory exists, a package is installed, or a line is already in a config file before taking action.
2. **Category Isolation**: Keep logic within its respective module. 
    * Tool-specific logic goes in `modules/helpers/`.
    * Category orchestration goes in `modules/`.
3. **Cross-Platform Compatibility**: Use the `IS_MAC` and `IS_LINUX` flags from `lib/os_detect.sh` to handle platform-specific commands.
<!-- 4. **Use the `run` Wrapper**: Never execute destructive commands directly. Use the `run` function from `lib/utils.sh` to support **Dry Run** mode. -->

---

## 📂 How to Add a New Module

If you want to add support for a new category (e.g., `cloud-tools`):

1. **Create the Helper**: Add `modules/helpers/cloud.sh` with the specific installation logic.
2. **Create the Orchestrator**: Add `modules/cloud.sh` to handle the configuration check and call the helper.
3. **Update Config**: Add the necessary keys to `config.yaml`.
4. **Link to Install**: Add `source ./modules/cloud.sh` and the execution call to `install.sh`.

---

## 📜 Coding Standards

### Bash Style
* Use `local` variables inside functions.
* Use `[[ ... ]]` for tests instead of `[ ... ]`.
* Always provide helpful logs using `log_info`, `log_success`, or `log_error`.

### Linting
Before submitting a pull request or committing changes, run the linter to catch syntax errors and "bad smells":
```bash
./lint_bash.sh