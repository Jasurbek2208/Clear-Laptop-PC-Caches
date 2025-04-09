### 📁 Проект: Очистка системных кэшей Windows

В этом репозитории находятся скрипты для очистки различных видов временных файлов и кэшей в операционной системе **Windows**.  
Поддерживаются два варианта запуска:

- `PowerShell`: для запуска непосредственно в Windows.
- `Bash`: для запуска в Git Bash.
- `Bash`: для запуска в **WSL (Windows Subsystem for Linux)**.

---

## 📂 Структура проекта

```
windows/
├── clearCaches.ps1   # PowerShell-скрипт
├── clearCaches.sh    # Bash-скрипт
├── clearCachesWSL.sh    # Bash-скрипт для WSL
README.md             # Документация
```

---

## ⚙️ Использование

### 🔵 PowerShell (Windows)

1. Откройте PowerShell **от имени администратора**.
2. Перейдите в директорию `windows/`.
3. Запустите скрипт:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\clearCaches.ps1
```

---

### 🟢 Bash Git Bash

1. Убедитесь, что у вас установлен WSL и смонтирован диск `C:`.
2. Перейдите в папку `windows/`:

```bash
cd /path/to/your/project/windows
```

3. Отредактируйте переменную `WIN_USER` в `clearCaches.sh`, указав имя вашего Windows-пользователя:

```bash
WIN_USER="YourWindowsUsername"
```

4. Запустите скрипт:

```bash
bash clearCaches.sh
```

---

### 🟢 Bash (WSL)

1. Убедитесь, что у вас установлен WSL и смонтирован диск `C:`.
2. Перейдите в папку `windows/`:

```bash
cd /path/to/your/project/windows
```

3. Отредактируйте переменную `WIN_USER` в `clearCaches.sh`, указав имя вашего Windows-пользователя:

```bash
WIN_USER="YourWindowsUsername"
```

4. Запустите скрипт:

```bash
bash clearCaches.sh
```

> 💡 **Важно:** Если возникает ошибка доступа, запустите скрипт с `sudo` (в зависимости от настроек WSL).

---

## 🧹 Что очищается

| Категория                      | Путь                                                         |
|-------------------------------|--------------------------------------------------------------|
| Временные файлы пользователя  | `C:\Users\<User>\AppData\Local\Temp`                         |
| Prefetch-кэш                  | `C:\Windows\Prefetch`                                       |
| Системный кэш                 | `C:\Windows\Temp`                                           |
| Кэш обновлений Windows        | `C:\Windows\SoftwareDistribution\Download`                  |
| Отчёты об ошибках Windows     | `C:\ProgramData\Microsoft\Windows\WER\ReportQueue`          |

---

## ⚠️ Предупреждение

> ❗ Используйте скрипты **только если понимаете, что делаете**. Очистка этих директорий может повлиять на поведение некоторых приложений или служб.  
> Рекомендуется запускать скрипты **от имени администратора**.

---
