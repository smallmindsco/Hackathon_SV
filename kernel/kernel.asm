; Smith&Vader OS ES - Main Kernel
; Orchestrates the entire system

.section .text
.global kernel_main

; Kernel entry point (called from bootloader)
kernel_main:
    push {lr}

    ; Clear screen before entering main loop
    bl clear_screen

    ; Main OS loop
.os_loop:
    ; Show user creation screen
    bl create_user_prompt

    ; Start the game
    bl game_main

    ; Game ended - loop will restart based on game_main's exit behavior
    ; (either reboot or halt will jump back appropriately)

    b .os_loop

    ; Should never reach here
    pop {pc}

; Additional kernel utilities can be added here
