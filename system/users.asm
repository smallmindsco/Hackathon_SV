; Smith&Vader OS ES - User Management System
; Handles user creation and username imprisonment

.section .text
.global create_user_prompt
.global store_username
.global imprison_username
.global liberate_all_usernames
.global get_imprisoned_count

; Maximum username length and count
.equ MAX_USERNAME_LEN, 16
.equ MAX_IMPRISONED, 64

; Display user creation prompt and capture input
create_user_prompt:
    push {r4, lr}

    ; Clear screen
    bl clear_screen

    ; Display prompt
    ldr r0, =user_prompt_banner
    bl print_string

    ldr r0, =user_prompt_text
    bl print_string

    ; Get username input
    ldr r0, =current_username
    mov r1, #MAX_USERNAME_LEN
    bl read_line

    ; Display welcome message
    ldr r0, =welcome_msg
    bl print_string

    ldr r0, =current_username
    bl print_string

    ldr r0, =newline
    bl print_string

    ; Delay before starting game
    ldr r0, =500000
    bl delay

    pop {r4, pc}

; Store current username
; r0 = pointer to username string
store_username:
    push {r4, r5, lr}

    ldr r4, =current_username
    mov r5, r0

    ; Copy username
    mov r2, #0
.copy_loop:
    ldrb r1, [r5, r2]
    strb r1, [r4, r2]
    cmp r1, #0
    beq .copy_done
    add r2, r2, #1
    cmp r2, #MAX_USERNAME_LEN
    blt .copy_loop
.copy_done:

    pop {r4, r5, pc}

; Imprison current username (add to imprisoned list)
imprison_username:
    push {r4, r5, r6, r7, lr}

    ; Get imprisoned count
    ldr r4, =imprisoned_count
    ldr r5, [r4]

    ; Check if we're at max
    cmp r5, #MAX_IMPRISONED
    bge .imprison_done

    ; Calculate offset into imprisoned array
    ldr r6, =imprisoned_users
    mov r7, #MAX_USERNAME_LEN
    mul r0, r5, r7
    add r6, r6, r0

    ; Copy current username to imprisoned list
    ldr r7, =current_username
    mov r2, #0
.imprison_copy:
    ldrb r1, [r7, r2]
    strb r1, [r6, r2]
    cmp r1, #0
    beq .imprison_increment
    add r2, r2, #1
    cmp r2, #MAX_USERNAME_LEN
    blt .imprison_copy

.imprison_increment:
    ; Increment imprisoned count
    add r5, r5, #1
    str r5, [r4]

.imprison_done:
    pop {r4, r5, r6, r7, pc}

; Liberate all usernames (display victory message)
liberate_all_usernames:
    push {r4, r5, r6, r7, lr}

    ldr r0, =liberation_banner
    bl print_string

    ; Get imprisoned count
    ldr r4, =imprisoned_count
    ldr r5, [r4]

    ; If no imprisoned users, skip
    cmp r5, #0
    beq .liberation_done

    ldr r0, =liberation_msg
    bl print_string

    ; Display all imprisoned usernames
    ldr r6, =imprisoned_users
    mov r7, #0

.lib_loop:
    cmp r7, r5
    bge .lib_list_done

    ; Calculate offset
    mov r0, #MAX_USERNAME_LEN
    mul r1, r7, r0
    add r0, r6, r1

    ; Print username with bullet
    push {r0, r7}
    ldr r0, =username_bullet
    bl print_string
    pop {r0, r7}

    bl print_string

    ldr r0, =newline
    bl print_string

    add r7, r7, #1
    b .lib_loop

.lib_list_done:
    ldr r0, =liberation_footer
    bl print_string

    ; Clear imprisoned count
    mov r0, #0
    str r0, [r4]

.liberation_done:
    pop {r4, r5, r6, r7, pc}

; Get number of imprisoned usernames
; Returns: r0 = count
get_imprisoned_count:
    ldr r1, =imprisoned_count
    ldr r0, [r1]
    bx lr

; Read a line of input from user
; r0 = buffer pointer
; r1 = max length
read_line:
    push {r4, r5, r6, lr}
    mov r4, r0              ; Buffer
    mov r5, r1              ; Max length
    mov r6, #0              ; Current position

.read_loop:
    ; Wait for character
    bl read_char

    ; Check for newline/enter
    cmp r0, #10
    beq .read_done
    cmp r0, #13
    beq .read_done

    ; Check for backspace
    cmp r0, #8
    beq .read_backspace
    cmp r0, #127
    beq .read_backspace

    ; Check if buffer full
    cmp r6, r5
    bge .read_loop

    ; Store character
    strb r0, [r4, r6]
    add r6, r6, #1

    ; Echo character
    bl print_char

    b .read_loop

.read_backspace:
    cmp r6, #0
    beq .read_loop
    sub r6, r6, #1
    ; Print backspace sequence
    mov r0, #8
    bl print_char
    mov r0, #32
    bl print_char
    mov r0, #8
    bl print_char
    b .read_loop

.read_done:
    ; Null terminate
    mov r0, #0
    strb r0, [r4, r6]

    ; Print newline
    mov r0, #10
    bl print_char

    pop {r4, r5, r6, pc}

; Read single character from UART
read_char:
    push {lr}
    ldr r1, =0x3F201000     ; UART0 base
.wait_char:
    ldr r0, [r1, #0x18]     ; Read flags
    tst r0, #0x10           ; Check RX FIFO empty
    bne .wait_char
    ldr r0, [r1]            ; Read character
    pop {pc}

.section .data

user_prompt_banner:
    .ascii "\n"
    .ascii "  ╔════════════════════════════════════════════════════════════════╗\n"
    .ascii "  ║                                                                ║\n"
    .ascii "  ║           S M I T H & V A D E R   OS ... ES                    ║\n"
    .ascii "  ║                                                                ║\n"
    .ascii "  ║              U S E R   C R E A T I O N                         ║\n"
    .ascii "  ║                                                                ║\n"
    .ascii "  ╚════════════════════════════════════════════════════════════╗\n"
    .ascii "\n"
    .asciz ""

user_prompt_text:
    .ascii "  Enter username: "
    .asciz ""

welcome_msg:
    .ascii "\n  Welcome, "
    .asciz ""

liberation_banner:
    .ascii "\n\n"
    .ascii "  ╔═══════════════════════════════════════════════════════════════╗\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ║          ★  L I B E R A T I O N   E V E N T  ★                ║\n"
    .ascii "  ║                                                               ║\n"
    .ascii "  ╚═══════════════════════════════════════════════════════════════╝\n"
    .ascii "\n"
    .asciz ""

liberation_msg:
    .ascii "  The following imprisoned usernames are now FREE:\n\n"
    .asciz ""

username_bullet:
    .ascii "    ► "
    .asciz ""

liberation_footer:
    .ascii "\n  All souls have been liberated from the Matrix.\n"
    .ascii "  The Force is balanced.\n\n"
    .asciz ""

newline:
    .ascii "\n"
    .asciz ""

.section .bss
    .align 4

; Current active username
current_username:
    .space MAX_USERNAME_LEN

; Array of imprisoned usernames
imprisoned_users:
    .space (MAX_USERNAME_LEN * MAX_IMPRISONED)

; Count of imprisoned users
imprisoned_count:
    .word 0
