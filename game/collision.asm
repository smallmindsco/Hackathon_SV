; Smith&Vader OS ES - Collision Detection
; Already implemented in enemies.asm as check_all_collisions
; This file serves as documentation and future expansion

.section .text
.global check_collision_at

; Check for collision at specific coordinates
; r0 = x position
; r1 = y position
; r2 = entity type to check against
; Returns: r0 = 1 if collision, 0 if no collision
check_collision_at:
    push {r4, r5, r6, lr}

    mov r4, r0
    mov r5, r1
    mov r6, r2

    ; Get character at position
    mov r0, r4
    mov r1, r5
    bl get_char_at

    ; Check if it matches the entity type
    cmp r0, r6
    moveq r0, #1
    movne r0, #0

    pop {r4, r5, r6, pc}
