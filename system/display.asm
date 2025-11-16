; Smith&Vader OS ES - Display Engine
; ASCII rendering system for game playfield

.section .text
.global init_display
.global render_playfield
.global set_char_at
.global get_char_at
.global clear_playfield

; Screen dimensions
.equ SCREEN_WIDTH, 80
.equ SCREEN_HEIGHT, 24
.equ SCREEN_SIZE, (SCREEN_WIDTH * SCREEN_HEIGHT)

; Initialize display system
init_display:
    push {lr}

    ; Clear screen buffer
    bl clear_playfield

    ; Hide cursor
    ldr r0, =hide_cursor_seq
    bl print_string

    pop {pc}

; Clear the playfield buffer
clear_playfield:
    push {r4, r5, lr}

    ldr r4, =screen_buffer
    ldr r5, =SCREEN_SIZE
    mov r2, #32                 ; Space character

.clear_loop:
    subs r5, r5, #1
    blt .clear_done
    strb r2, [r4, r5]
    b .clear_loop

.clear_done:
    pop {r4, r5, pc}

; Set character at position
; r0 = x position
; r1 = y position
; r2 = character
set_char_at:
    push {r4, r5, lr}

    ; Bounds check
    cmp r0, #SCREEN_WIDTH
    bge .set_done
    cmp r1, #SCREEN_HEIGHT
    bge .set_done
    cmp r0, #0
    blt .set_done
    cmp r1, #0
    blt .set_done

    ; Calculate offset: y * WIDTH + x
    mov r4, #SCREEN_WIDTH
    mul r5, r1, r4
    add r5, r5, r0

    ; Set character in buffer
    ldr r4, =screen_buffer
    strb r2, [r4, r5]

.set_done:
    pop {r4, r5, pc}

; Get character at position
; r0 = x position
; r1 = y position
; Returns: r0 = character (or 0 if out of bounds)
get_char_at:
    push {r4, r5, lr}

    ; Bounds check
    cmp r0, #SCREEN_WIDTH
    bge .get_invalid
    cmp r1, #SCREEN_HEIGHT
    bge .get_invalid
    cmp r0, #0
    blt .get_invalid
    cmp r1, #0
    blt .get_invalid

    ; Calculate offset: y * WIDTH + x
    mov r4, #SCREEN_WIDTH
    mul r5, r1, r4
    add r5, r5, r0

    ; Get character from buffer
    ldr r4, =screen_buffer
    ldrb r0, [r4, r5]

    pop {r4, r5, pc}

.get_invalid:
    mov r0, #0
    pop {r4, r5, pc}

; Render entire playfield to screen
render_playfield:
    push {r4, r5, r6, lr}

    ; Move cursor to home
    ldr r0, =home_cursor_seq
    bl print_string

    ; Render top border
    ldr r0, =border_top
    bl print_string

    ; Render playfield rows
    ldr r4, =screen_buffer
    mov r5, #0                  ; Row counter

.render_row_loop:
    cmp r5, #SCREEN_HEIGHT
    bge .render_rows_done

    ; Print left border
    ldr r0, =border_left
    bl print_string

    ; Print row contents
    mov r6, #0                  ; Column counter
.render_col_loop:
    cmp r6, #SCREEN_WIDTH
    bge .render_col_done

    ; Calculate offset and get character
    mov r0, #SCREEN_WIDTH
    mul r1, r5, r0
    add r1, r1, r6
    ldrb r0, [r4, r1]

    ; Print character
    bl print_char

    add r6, r6, #1
    b .render_col_loop

.render_col_done:
    ; Print right border
    ldr r0, =border_right
    bl print_string

    add r5, r5, #1
    b .render_row_loop

.render_rows_done:
    ; Render bottom border
    ldr r0, =border_bottom
    bl print_string

    pop {r4, r5, r6, pc}

; Draw a string at position
; r0 = x position
; r1 = y position
; r2 = pointer to null-terminated string
draw_string_at:
    push {r4, r5, r6, r7, lr}

    mov r4, r0                  ; Save x
    mov r5, r1                  ; Save y
    mov r6, r2                  ; String pointer
    mov r7, #0                  ; Offset

.draw_str_loop:
    ldrb r2, [r6, r7]
    cmp r2, #0
    beq .draw_str_done

    ; Set character at current position
    add r0, r4, r7
    mov r1, r5
    bl set_char_at

    add r7, r7, #1
    b .draw_str_loop

.draw_str_done:
    pop {r4, r5, r6, r7, pc}

; Fill area with character
; r0 = start x
; r1 = start y
; r2 = width
; r3 = height
; [sp] = character
fill_area:
    push {r4, r5, r6, r7, r8, lr}

    ldr r8, [sp, #24]           ; Get character from stack

    mov r4, r0                  ; Start x
    mov r5, r1                  ; Start y
    mov r6, r2                  ; Width
    mov r7, r3                  ; Height

    mov r1, #0                  ; Row counter
.fill_row_loop:
    cmp r1, r7
    bge .fill_done

    mov r0, #0                  ; Col counter
.fill_col_loop:
    cmp r0, r6
    bge .fill_row_done

    ; Calculate position
    push {r0, r1}
    add r0, r4, r0
    add r1, r5, r1
    mov r2, r8
    bl set_char_at
    pop {r0, r1}

    add r0, r0, #1
    b .fill_col_loop

.fill_row_done:
    add r1, r1, #1
    b .fill_row_loop

.fill_done:
    pop {r4, r5, r6, r7, r8, pc}

.section .data

hide_cursor_seq:
    .asciz "\033[?25l"

home_cursor_seq:
    .asciz "\033[H"

border_top:
    .ascii "┌"
    .rept SCREEN_WIDTH
    .ascii "─"
    .endr
    .ascii "┐\n"
    .asciz ""

border_left:
    .ascii "│"
    .asciz ""

border_right:
    .ascii "│\n"
    .asciz ""

border_bottom:
    .ascii "└"
    .rept SCREEN_WIDTH
    .ascii "─"
    .endr
    .ascii "┘\n"
    .asciz ""

.section .bss
    .align 4

; Screen buffer (characters only)
screen_buffer:
    .space SCREEN_SIZE
