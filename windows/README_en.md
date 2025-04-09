### 📁 Project: Windows Cache Clearing

This repository contains scripts for clearing various temporary files and caches on the **Windows** operating system.  
Three execution modes are supported:

- `PowerShell`: for direct execution in Windows.
- `Bash`: for execution in Git Bash.
- `Bash`: for execution in **WSL (Windows Subsystem for Linux)**.

---

## 📂 Project Structure

```
windows/
├── clearCaches.ps1      # PowerShell script
├── clearCaches.sh       # Bash script for Git Bash
├── clearCachesWSL.sh    # Bash script for WSL
README_ru.md             # Documentation (Russian version)
README_en.md             # Documentation (English version)
```

---

## ⚙️ Usage

### 🔵 PowerShell (Windows)

1. Open PowerShell **as an administrator**.
2. Navigate to the `windows/` directory.
3. Run the script:

    ```powershell
    Set-ExecutionPolicy Bypass -Scope Process -Force
    .\clearCaches.ps1
    ```

---

### 🟢 Bash (Git Bash)

1. Ensure that Git Bash is installed.
2. Navigate to the `windows/` directory:

    ```bash
    cd /path/to/your/project/windows
    ```

3. Edit the variable `WIN_USER` in `clearCaches.sh`, replacing it with your actual Windows username:

    ```bash
    WIN_USER="YourWindowsUsername"
    ```

4. Run the script:

    ```bash
    bash clearCaches.sh
    ```

---

### 🟢 Bash (WSL)

1. Ensure that WSL is installed and the `C:` drive is mounted.
2. Navigate to the `windows/` directory:

    ```bash
    cd /path/to/your/project/windows
    ```

3. Edit the variable `WIN_USER` in `clearCachesWSL.sh`, replacing it with your actual Windows username:

    ```bash
    WIN_USER="YourWindowsUsername"
    ```

4. Run the script:

    ```bash
    bash clearCachesWSL.sh
    ```

> 💡 **Note:** If you encounter permission errors, run the script with `sudo` (depending on your WSL configuration).

---

## 🧹 What is Cleared

| Category                        | Path                                                         |
|---------------------------------|--------------------------------------------------------------|
| User temporary files            | `C:\Users\<User>\AppData\Local\Temp`                         |
| Prefetch cache                  | `C:\Windows\Prefetch`                                        |
| System temporary files          | `C:\Windows\Temp`                                            |
| Windows Update cache            | `C:\Windows\SoftwareDistribution\Download`                   |
| Windows Error Reporting cache   | `C:\ProgramData\Microsoft\Windows\WER\ReportQueue`           |

---

## ⚠️ Warning

> ❗ Use these scripts **only if you know what you are doing**. Clearing these directories may affect the behavior of certain applications or services.  
> It is recommended to run the scripts **as an administrator**.
