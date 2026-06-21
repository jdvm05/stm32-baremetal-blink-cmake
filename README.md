# STM32 Bare-Metal Blink with CMake

Minimal bare-metal STM32 blink project scaffold using CMake and the ARM GNU toolchain. The project is set up for a Cortex-M4 target, such as an STM32F4 device, and builds an ELF image from C sources, startup assembly, and a flash linker script.

## Project Layout

```text
.
├── CMakeLists.txt
├── linker/
│   └── stm32_flash.ld
├── startup/
│   └── *.s
└── src/
    └── *.c
```

## Requirements

- CMake 3.13 or newer
- ARM GNU toolchain with `arm-none-eabi-gcc` on your `PATH`
- A flashing/debugging tool such as OpenOCD or `st-flash`
- An STM32 Cortex-M4 board, or updated compiler/linker settings for your target MCU

## Build

From the repository root:

```sh
mkdir build
cd build
cmake ..
cmake --build .
```

The default target builds `BareMetalBlink`, producing an ELF file suitable for flashing once the startup code, linker script, and board-specific application code match your MCU.

## Flash Example

For an STM32F4 target using an ST-Link adapter:

```sh
openocd -f interface/stlink.cfg -f target/stm32f4x.cfg \
  -c "program BareMetalBlink.elf verify reset exit"
```

Adjust the OpenOCD target configuration for boards outside the STM32F4 family.

## Configuration Notes

- `CMakeLists.txt` currently targets `cortex-m4` with Thumb instructions.
- `linker/stm32_flash.ld` contains default STM32F4-style flash and RAM regions. Update `FLASH` and `RAM` sizes to match your MCU datasheet.
- Add board-specific startup assembly under `startup/`.
- Add application code under `src/`.
- If you use a different Cortex-M family, update `-mcpu` and linker settings before building.

## Useful Commands

Clean and rebuild:

```sh
rm -rf build
mkdir build
cd build
cmake ..
cmake --build .
```

Check the generated ELF sections:

```sh
arm-none-eabi-size BareMetalBlink.elf
arm-none-eabi-objdump -h BareMetalBlink.elf
```
