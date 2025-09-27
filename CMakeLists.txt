cmake_minimum_required(VERSION 3.22)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
message("Build CMAKE_MODULE_PATH: " ${CMAKE_MODULE_PATH})
include("cmake/gcc-arm-none-eabi.cmake")

# Core project settings
project(Template_STM32_CMake_Project VERSION 1.0.0)
enable_language(C CXX ASM)
message("Build type: " ${CMAKE_BUILD_TYPE})

set(APP_VERSION_MAJOR ${CMAKE_PROJECT_VERSION_MAJOR})
set(APP_VERSION_MINOR ${CMAKE_PROJECT_VERSION_MINOR})
set(APP_VERSION_PATCH ${CMAKE_PROJECT_VERSION_PATCH})

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/inc/app/app_version.h.in
    ${CMAKE_CURRENT_SOURCE_DIR}/inc/app/app_version.h
)

# Setup compiler settings
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# User must set the STM32 model here
set(STM32_MODEL "STM32H723xx")
message("STM32 Model: " ${STM32_MODEL})

# CMake script to add project specific configuration
# (sources, includes, symbols, linker script, options)
include("cmake/project_configuration.cmake")

# Link directories setup
# Must be before executable is added
link_directories(${CMAKE_PROJECT_NAME} ${link_DIRS})

# Create an executable object type
add_executable(${CMAKE_PROJECT_NAME})

# Add sources to executable
target_sources(${CMAKE_PROJECT_NAME} PUBLIC ${sources_SRCS})

# Add include paths
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:C>: ${include_c_DIRS}>
    $<$<COMPILE_LANGUAGE:CXX>: ${include_cxx_DIRS}>
    $<$<COMPILE_LANGUAGE:ASM>: ${include_asm_DIRS}>
)

# Add project symbols (macros)
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
    # Enable the specific STM32 model in stm32xxxx.h
    ${STM32_MODEL}

    # Choose HAL or LL drivers by commenting/uncommenting the following lines
    USE_HAL_DRIVER
    USE_FULL_LL_DRIVER

    $<$<COMPILE_LANGUAGE:C>: ${symbols_c_SYMB}>
    $<$<COMPILE_LANGUAGE:CXX>: ${symbols_cxx_SYMB}>
    $<$<COMPILE_LANGUAGE:ASM>: ${symbols_asm_SYMB}>

    # Configuration specific
    $<$<CONFIG:Debug>:DEBUG>
    $<$<CONFIG:Release>: >
)

# Add linked libraries
target_link_libraries(${CMAKE_PROJECT_NAME} ${link_LIBS})

# Compiler options
target_compile_options(${CMAKE_PROJECT_NAME} PRIVATE
    ${cpu_PARAMS}
    ${compiler_OPTS}
)

# Linker options
target_link_options(${CMAKE_PROJECT_NAME} PRIVATE
    -T${linker_script_SRC}
    ${cpu_PARAMS}
    ${linker_OPTS}
)

# Execute post-build to print size, generate hex and bin
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${CMAKE_PROJECT_NAME}> ${CMAKE_PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${CMAKE_PROJECT_NAME}> ${CMAKE_PROJECT_NAME}.bin
)

enable_testing()

include(ExternalProject)
ExternalProject_Add(
    STM32UnitTests
    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/tests/unity_cmock
    BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/STM32UnitTests
    CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    BUILD_ALWAYS 1
    INSTALL_COMMAND ""
)

add_test(NAME RunUnitTests COMMAND ${CMAKE_COMMAND} ${CMAKE_CURRENT_BINARY_DIR}/STM32UnitTests)
