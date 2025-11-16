; Smith&Vader OS... ES - Bootloader
; Revolutionary Tiny Context Protocol (TCP) Enabled
; Powered by Emperor 8LM (4 braincells)

.section .text
.global _start

_start:
    ; Initialize stack pointer
    ldr sp, =stack_top

    ; Clear screen
    bl clear_screen

    ; Display awe-inspiring boot screen
    bl show_boot_screen

    ; Initialize system
    bl init_memory
    bl init_interrupts

    ; Boot delay for dramatic effect
    ldr r0, =1000000
    bl delay

    ; Jump to kernel
    bl kernel_main

; Clear screen function
clear_screen:
    push {lr}
    ldr r0, =clear_seq
    bl print_string
    pop {pc}

; Display the AWE-INSPIRING boot screen
show_boot_screen:
    push {lr}

    ; Print banner
    ldr r0, =boot_banner
    bl print_string

    ; Print system info
    ldr r0, =boot_info
    bl print_string

    pop {pc}

; Simple delay loop
delay:
    subs r0, r0, #1
    bne delay
    bx lr

; Print null-terminated string
; r0 = pointer to string
print_string:
    push {r4, lr}
    mov r4, r0
.print_loop:
    ldrb r0, [r4]
    cmp r0, #0
    beq .print_done
    bl print_char
    add r4, r4, #1
    b .print_loop
.print_done:
    pop {r4, pc}

; Print single character via UART
; r0 = character to print
print_char:
    push {lr}
    ; UART0 base address (Raspberry Pi)
    ldr r1, =0x3F201000
    ; Wait for UART to be ready
.wait_uart:
    ldr r2, [r1, #0x18]    ; Read UART flags
    tst r2, #0x20           ; Check if transmit FIFO full
    bne .wait_uart
    ; Write character
    str r0, [r1]
    pop {pc}

.section .data

clear_seq:
    .asciz "\033[2J\033[H"

boot_banner:
    .ascii "\n"
    .ascii "  ███████╗███╗   ███╗██╗████████╗██╗  ██╗    ██╗   ██╗ █████╗ ██████╗ ███████╗██████╗ \n"
    .ascii "  ██╔════╝████╗ ████║██║╚══██╔══╝██║  ██║    ██║   ██║██╔══██╗██╔══██╗██╔════╝██╔══██╗\n"
    .ascii "  ███████╗██╔████╔██║██║   ██║   ███████║    ██║   ██║███████║██║  ██║█████╗  ██████╔╝\n"
    .ascii "  ╚════██║██║╚██╔╝██║██║   ██║   ██╔══██║    ╚██╗ ██╔╝██╔══██║██║  ██║██╔══╝  ██╔══██╗\n"
    .ascii "  ███████║██║ ╚═╝ ██║██║   ██║   ██║  ██║     ╚████╔╝ ██║  ██║██████╔╝███████╗██║  ██║\n"
    .ascii "  ╚══════╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝      ╚═══╝  ╚═╝  ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝\n"
    .ascii "\n"
    .ascii "                           ╔═══════════════════════════════════╗\n"
    .ascii "                           ║     O P E R A T I N G   S Y S T E M     ║\n"
    .ascii "                           ║              . . . E S                  ║\n"
    .ascii "                           ╚═══════════════════════════════════╝\n"
    .ascii "\n"
    .asciz ""

boot_info:
    .ascii "  ┌────────────────────────────────────────────────────────────────────┐\n"
    .ascii "  │  Tiny Context Protocol (TCP).................... [ ENABLED ]      │\n"
    .ascii "  │  Emperor 8LM (4 Braincells).................... [ ONLINE ]       │\n"
    .ascii "  │  Braincell Upgrade from non-ES................. [ 2x → 4x ]      │\n"
    .ascii "  │  Halting Problem Support....................... [ READY ]        │\n"
    .ascii "  │  Matrix/Vader Defense Systems.................. [ ARMED ]        │\n"
    .ascii "  └────────────────────────────────────────────────────────────────────┘\n"
    .ascii "\n"
    .ascii "  Loading kernel"
    .asciz ""

.section .bss
    .align 4
    .space 4096
stack_top:
