/* Smith&Vader OS ES - Linker Script */
/* For Raspberry Pi ARM */

ENTRY(_start)

SECTIONS
{
    /* Kernel loads at 0x8000 on Raspberry Pi */
    . = 0x8000;

    .text : {
        KEEP(*(.text.boot))
        *(.text)
    }

    .rodata : {
        *(.rodata)
    }

    .data : {
        *(.data)
    }

    /* BSS section for uninitialized data */
    .bss : {
        __bss_start = .;
        *(.bss)
        *(COMMON)
        __bss_end = .;
    }

    /* Discard unwanted sections */
    /DISCARD/ : {
        *(.comment)
        *(.gnu*)
        *(.note*)
        *(.eh_frame*)
    }
}

__bss_size = (__bss_end - __bss_start) >> 3;
