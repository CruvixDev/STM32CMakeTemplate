# 🚀 STM32 CMake Template: Step-by-Step Guide

This guide walks you through creating and organizing a **barebones STM32 project** using CMake and VS Code.

---

## 1️⃣ Create an Empty STM32 Project 📄

The **STM32 VS Code Extension** (by STMicroelectronics) allows you to quickly generate a minimal STM32 project for a specific board or MCU.  

### Steps:

1. Enter your project name, e.g., `STM32H7CMakeTemplate`.  
2. Select your **Device** (STM32 model). For this guide, we’ll use **STM32H723ZGTx**.  

![Project Creation](image.png)  
![Select Device](image-1.png)  

3. Click **Create Project**. An empty project is generated:

![Empty Project](image-2.png)

---

### 📂 Default Project Structure

After creation, the project tree looks like this:  

![Project Tree](image-4.png)

| Folder/File | Purpose |
|-------------|---------|
| `.vscode/` ⚙️ | VS Code configuration files for debugging, building, and IntelliSense. |
| `build/` 🛠️ | Stores all CMake build outputs, separated by **build presets** (Debug, Release, RelWithDebInfo). |
| `CMake/` 📜 | Helper CMake scripts: <br>• `gcc-arm-none-eabi.cmake` → ARM GCC toolchain.<br>• `vscode_generated.cmake` → Auto-generated project definitions (headers, sources, symbols, compiler flags). |
| `Inc/` 📑 | User **header files**. |
| `Src/` ✍️ | User **source files**. |
| `Startup/` 🏁 | Assembly startup code for the Cortex-M7 core: vector table, stack/heap setup, jump to `main()`. |

**Root Files:**

- `CMakeLists.txt` 🛠️ → Central build definition pulling helper scripts.  
- `CMakePresets.json` 🔧 → Modern CMake build presets for consistency across machines.  
- `stm32h723zgtx_FLASH.ld` 📍 → Linker script defining memory layout (Flash, RAM, stack, sections).  

---

## 2️⃣ Reorganize the Project 🗂️

To make the project **modular and consistent**, we recommend reorganizing the folder structure.

---

### 🔤 Folder Naming

Rename the default folders to **lowercase**:

| Original | New |
|----------|-----|
| `Inc` | `inc` |
| `Src` | `src` |
| `Startup` | `startup` |

---

### 📑 `inc/` → Headers

Organize headers into subfolders:  

- **`app/`** 🎯 → Application-level (abstract) headers.  
- **`hal/`** ⚡ → Hardware Abstraction Layer headers, directly related to peripherals.

---

### ✍️ `src/` → Sources

Organize sources into:

- **`app/`** 🎯 → Application-level source files.  
- **`hal/`** ⚡ → Hardware/peripheral-dependent source files.  
- **`system/`** 🖥️ → System-level files (e.g., `system_syscall.c`, `system_sysmem.c`).  

**Naming Convention:** Prefix each file with its folder name for clarity:  

app_main.c, hal_uart.c, system_syscall.c


---

### 🏁 `startup/` → Startup & Linker

- Keep the **startup assembly file** (e.g., `startup_stm32h723zgtx.s`).  
- Move the **linker script** (`stm32h723zgtx_FLASH.ld`) here, since it is closely tied to memory initialization.  

---

✅ **Benefits of this Reorganization:**

- Clear separation between **application, hardware, and system code**.  
- Consistent **naming convention** (lowercase, prefixed files).  
- Easier navigation and maintenance for multiple developers.  

---

## 3️⃣ Add Submodules

Empty projects do **not include HAL or CMSIS** by default. Git submodules are the recommended way to manage these dependencies.  

### 📂 Submodules Folder

Create a `submodules` folder at the project root and add the required repositories.  

---

### 🔧 Required Submodules

| Submodule | Purpose |
|-----------|---------|
| **CMSIS** | ARM project handling CPU registers and peripherals. |
| **cmsis-device-h7** | Adds CMSIS support for STM32H7 series. |
| **stm32h7xx-hal-driver** | HAL and LL drivers for STM32H7. |

---

### 📝 Notes

- Adding submodules automatically generates a `.gitmodules` file at the root.  
- Submodules ensure **consistent versions** across different machines and projects.  

# 4️⃣ Add tests support

To test the firmware code, an unit test framework must be added. Ceedling has been choosen, because it uses Unity and CMock from ThrowTheSwitch. Unity is a lightweight unit test framework, performant and almost used in embedded systems context. CMock allows to create mocks and stubs. Ceedling is a generator that combines CMock and Unity together, it generates mocks automatically and executes unit tests. Ceedling is based on Ruby language, so a Ruby interpreter is needed.

1. In tests folder/ceedling, enter ceedling new STM32Tests, a YAML project file is created.

2. In project.yml file, uncomment the line report_tests_log_factory to enable JUnit log output. So that, CTest can read tests results.

3. Run ceedling module:create[Tests] to create tests files

4. In the project.yml file, modify paths to sources and includes

```yaml
:paths:
  :test:
    - +:test/**
    - -:test/support
  :source:
    - ../../src/**
  :include:
    - ../../inc/** # In simple projects, this entry often duplicates :source
  :support:
    - test/support
  :libraries: []
```

5. I create 2 files: test_test1.c and test_test2.c with simple assert tests

6. To run tests, run the command ceedling test:all.

7. To run tests from CMake using CTest, add this line in the CMakeLists.txt file:

```CMake
enable_testing()

# Add Ceedling tests
add_test(
    NAME ceedling_all
    COMMAND ruby -S ceedling test:all
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/tests/ceedling
)
```

# 5️⃣ GitHub Actions Workflow

**GitHub Actions** is the way to introduce **CI/CD practices** 🚀.  
It allows automation of **build** and **test** processes on each push to the repository.

The workflow uses a **custom Ubuntu Docker image** 🐧 with all necessary tools installed:  
- Ruby interpreter 💎  
- `arm-none-eabi-gcc` 🔧  
- CMake 📦  
- Ninja ⚡  

👉 A `Dockerfile` has been created in the `.github/workflows` directory to build this image.  
👉 The image has been pushed to your **GitHub account as a public package** for reuse.

---

## ⚙️ Workflow Steps

The CI workflow is fairly simple:  
1. ✅ **Checkout the repository**  
2. ⚙️ **Configure the CMake project**  
3. 🏗️ **Compile the firmware**  
4. 🧪 **Run Ceedling unit tests**  

---

✨ With this setup, every push automatically triggers a full **build & test pipeline** on GitHub! 🎉
