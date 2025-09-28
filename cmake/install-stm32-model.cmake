string(TOLOWER ${STM32_MODEL} STM32_MODEL_LC)

# Paths to startup file and linker script based on selected STM32 model
set(STARTUP_FILE ${CMAKE_CURRENT_SOURCE_DIR}/submodules/cmsis-device-h7/Source/Templates/gcc/startup_${STM32_MODEL_LC}.s)
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/submodules/cmsis-device-h7/Source/Templates/gcc/linker/${STM32_MODEL_LC}_FLASH.ld)

# Check if the startup file and linker script exist
if(EXISTS ${STARTUP_FILE})
    file(COPY ${STARTUP_FILE} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR}/startup)
    set(STARTUP_FILE ${LOCAL_STARTUP_DIR}/startup_${STM32_MODEL_LC}.s)
else()
    message(WARNING "No startup file found for" ${STM32_MODEL_LC})
endif()
