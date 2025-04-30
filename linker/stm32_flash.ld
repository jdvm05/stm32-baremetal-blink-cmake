cat > linker/stm32_flash.ld << 'EOF'
/* Base linker script for STM32 Cortex-M4
 * Adjust FLASH/RAM sizes & addresses per your MCU’s datasheet.
 */

MEMORY
{
    /* Default STM32F4 values; update these! */
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K
    RAM   (rwx): ORIGIN = 0x20000000, LENGTH = 128K
}

/* Symbol for initial stack pointer */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    /* Vector table in FLASH */
    .isr_vector :
    {
        KEEP(*(.isr_vector))
    } > FLASH

    /* Code and read-only data in FLASH */
    .text :
    {
        *(.text*)
        *(.rodata*)
        *(.glue_7)
        *(.glue_7t)
    } > FLASH

    /* Initialized data goes into RAM, load from FLASH */
    .data : AT(__etext)
    {
        __sdata = .;
        *(.data*)
        __edata = .;
    } > RAM

    /* Uninitialized data (BSS) in RAM */
    .bss :
    {
        __sbss = .;
        *(.bss*)
        *(COMMON)
        __ebss = .;
    } > RAM

    /* End of RAM symbol (for stack limits, etc.) */
    __end__ = .;
}
EOF
