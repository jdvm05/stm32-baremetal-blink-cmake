# STM32 Bare-Metal Blink with CMake

A minimal STM32 bare-metal project scaffold for building Cortex-M4 firmware with **CMake** and the **GNU Arm Embedded Toolchain** (`arm-none-eabi-gcc`).

The project is intentionally small and is useful as a starting point for learning how an STM32 firmware project is assembled without relying on an IDE-generated build system.

## What this project demonstrates

- Cross-compiling C and assembly for an ARM Cortex-M4
- Building an ELF firmware image with CMake
- Using a custom linker script for flash/RAM layout
- Organizing application code, startup code, and linker configuration separately
- Preparing firmware that can be flashed with tools such as OpenOCD or `st-flash`

## Repository layout

```text
.
├── CMakeLists.txt
├── linker/
│   └── stm32_flash.ld
├── src/
├── startup/
└── README.md
```

`src/` is intended for application C sources, `startup/` for startup assembly, and `linker/` contains the linker script used by the build.

> **Note:** the repository is currently a scaffold: `src/` and `startup/` do not yet contain the actual blink application and startup code. Those files must be added before a complete firmware image can be built.

## Requirements

Install the following tools:

- CMake 3.13 or newer
- GNU Arm Embedded Toolchain (`arm-none-eabi-gcc`)
- Make, Ninja, or another CMake-supported build tool
- Optional: OpenOCD or `st-flash` for programming the microcontroller

Verify the compiler is available:

```bash
arm-none-eabi-gcc --version
```

## Build

From the repository root:

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

The CMake configuration targets a Cortex-M4 and produces an executable named:

```text
BareMetalBlink
```

## Flashing with OpenOCD

Once the project contains valid application and startup sources and builds successfully, an STM32F4 target using an ST-Link programmer could be flashed with a command such as:

```bash
openocd -f interface/stlink.cfg \
        -f target/stm32f4x.cfg \
        -c "program BareMetalBlink verify reset exit"
```

The exact OpenOCD target configuration and output filename may need to be adjusted for your board and toolchain.

## Important hardware note

The current CMake configuration uses Cortex-M4 compiler flags and the linker script defines the MCU memory layout. Before using this project with a specific STM32 device, verify that:

1. the CPU flags match the MCU,
2. the flash and RAM sizes in `linker/stm32_flash.ld` match the device,
3. the startup/vector-table code matches the MCU family, and
4. the GPIO pin used by the blink example corresponds to the LED on your board.

## Next steps

A useful next improvement would be to add a minimal `main.c` plus startup assembly so the repository becomes a complete buildable blink example. After that, generating `.bin` and `.hex` files from the ELF with `arm-none-eabi-objcopy` would make the project more convenient to flash with different tools.

## License

See [LICENSE](LICENSE).