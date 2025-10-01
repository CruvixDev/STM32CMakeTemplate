![GitHub release](https://img.shields.io/github/v/release/CruvixDev/STM32CMakeTemplate)
![Build](https://github.com/cruvixdev/STM32CMakeTemplate/actions/workflows/STM32_CI-CD.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-green)

![STM32 Template](https://github.com/user-attachments/assets/359f3191-b27c-4982-b950-f91c0b88e8dc)

# STM32H7 CMake Template

A **modular and maintainable CMake template** for STM32H7 development. This template is based on **CMSIS**, **Cube HAL/LL drivers**, and uses **Git submodules** for version-controlled dependencies.  

It is designed to simplify STM32 project creation, providing a **clean folder structure**, build presets, and integration with testing frameworks.

---

## ⚡ Features

1. **Version Information:**  
   - `app_version.hpp.in` embeds project version (Major, Minor, Patch), Git commit hash, and build date directly into the final `.elf` firmware.  

2. **Submodules Integration:**  
   - CMSIS, `cmsis-device-h7`, and Cube HAL/LL are included as Git submodules, ensuring **consistent versions** and easy updates.  

3. **Unit Testing:**  
   - `tests/` folder integrated with **Ceedling** (requires Ruby on host machine).  

4. **CMake Presets:**  
   - `CMakePresets.json` allows separating build variants (Debug, Release, RelWithDebInfo) and ensures **consistent configuration across developers**.  

5. **Clean Project Structure:**  
   - `inc/` → headers (`app/` and `hal/`)  
   - `src/` → source files (`app/`, `hal/`, `system/`)  
   - `startup/` → startup assembly and linker script  
   - `submodules/` → CMSIS and HAL/LL drivers  

---

## 🛠️ Getting Started

### 1. Clone the repository

```bash
git clone --recurse-submodules https://github.com/CruvixDev/STM32CMakeTemplate.git
cd STM32CMakeTemplate
```

. Select your STM32H7 MCU

Edit the CMakeLists.txt file and set your target model:

# User must set the STM32 model here
set(STM32_MODEL "STM32H723xx")
message("STM32 Model: " ${STM32_MODEL})

3. Configure CMake

Use your preferred build folder and preset:

cmake -S . -B build/Debug -DCMAKE_BUILD_TYPE=Debug

4. Customize the Project

Modify CPU parameters, include directories, source files, compiler flags, libraries, and preprocessor symbols in:

cmake/project_configuration.cmake

📂 Project Structure
STM32CMakeTemplate/
├─ .vscode/                # VS Code settings for build and debug
├─ build/                  # Build outputs by preset
├─ CMake/                  # Helper CMake scripts (toolchain, auto-generated settings)
├─ inc/
│  ├─ app/                 # Application-level headers
│  └─ hal/                 # HAL/peripheral headers
├─ src/
│  ├─ app/                 # Application source files
│  ├─ hal/                 # HAL/peripheral source files
│  └─ system/              # System-level files (syscall, sysmem, etc.)
├─ startup/
│  ├─ startup_stm32h723zgtx.s
│  └─ stm32h723zgtx_FLASH.ld
├─ submodules/             # CMSIS and HAL/LL drivers
├─ tests/                  # Ceedling unit tests
├─ CMakeLists.txt
├─ CMakePresets.json
└─ app_version.hpp.in

✅ Benefits

Clear separation of application, HAL, and system code.

Consistent naming convention (lowercase folders, prefixed files).

Easy to maintain and extend for multiple STM32H7 projects.

Git submodules allow controlled dependency versions.

📋 TODO

Add a simple LED blinking example.

Include a unit test example with HAL/LL mocking.

Provide a step-by-step tutorial for creating this template from scratch.

Extend GitHub Actions CI/CD: add deploy and lint phases.

Expand support to all STM32H7/STM32xx series.

📝 License

This project is licensed under the MIT License – see LICENSE
 for details.


---

If you want, I can also **add a “Quick Start” section** with example build & flash commands for STM32 — that makes the README even more practical.  

Do you want me to add that?