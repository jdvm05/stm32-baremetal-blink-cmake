# ------------------------------------------------------------------------------
#  CMakeLists.txt for STM32 Bare-Metal Blink (CMake + ARM-GCC)
#
#  Targets:
#    - Cortex-M4 (e.g. STM32F4 series)
#    - Cross-compile with arm-none-eabi-gcc
#
#  Layout:
#    /src      C sources
#    /startup  Startup assembly
#    /linker   Linker script (stm32_flash.ld)
#
#  Usage:
#    mkdir build && cd build
#    cmake ..
#    make
#    # then flash with OpenOCD or st-flash, e.g.:
#    # openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
#    #    -c "program BareMetalBlink.elf verify reset exit"
#
#  Author: Juan Vazquez
#  Date:   2025-04-24
# ------------------------------------------------------------------------------

cmake_minimum_required(VERSION 3.13)
project(BareMetalBlink C ASM)

# Cross-compile settings
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER   arm-none-eabi-gcc)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)

# Compiler flags: Cortex-M4, Thumb-2, optimize, warnings on
set(CMAKE_C_FLAGS "-mcpu=cortex-m4 -mthumb -O2 -Wall")

# Linker script for flash and RAM layout
set(CMAKE_EXE_LINKER_FLAGS "-T${CMAKE_SOURCE_DIR}/linker/stm32_flash.ld")

# Include your src/ headers
include_directories(${CMAKE_SOURCE_DIR}/src)

# Gather all C and startup assembly files
file(GLOB SOURCES 
    "${CMAKE_SOURCE_DIR}/src/*.c"
    "${CMAKE_SOURCE_DIR}/startup/*.s"
)

# Build the ELF executable
add_executable(BareMetalBlink ${SOURCES})
