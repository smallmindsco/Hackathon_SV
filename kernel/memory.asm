; Smith&Vader OS ES - Memory Management
; Simple memory allocator for game and system data

.section .text
.global init_memory
.global malloc
.global free

; Initialize memory management
init_memory:
    push {lr}

    ; Set up heap start
    ldr r0, =heap_start
    ldr r1, =heap_ptr
    str r0, [r1]

    ; Clear user data area
    ldr r0, =user_data_start
    ldr r1, =user_data_end
    mov r2, #0
.clear_loop:
    cmp r0, r1
    bge .clear_done
    str r2, [r0]
    add r0, r0, #4
    b .clear_loop
.clear_done:

    pop {pc}

; Simple malloc implementation
; r0 = size to allocate
; Returns: r0 = pointer to allocated memory (or 0 if failed)
malloc:
    push {r4, r5, lr}

    mov r4, r0              ; Save requested size

    ; Get current heap pointer
    ldr r5, =heap_ptr
    ldr r0, [r5]

    ; Check if we have enough space
    ldr r1, =heap_end
    add r2, r0, r4
    cmp r2, r1
    bgt .malloc_fail

    ; Update heap pointer
    str r2, [r5]

    ; Return allocated address
    pop {r4, r5, pc}

.malloc_fail:
    mov r0, #0
    pop {r4, r5, pc}

; Simple free (currently a no-op, could implement free list)
; r0 = pointer to free
free:
    bx lr

; Get user data area
; Returns: r0 = pointer to user data area
get_user_data_area:
    ldr r0, =user_data_start
    bx lr

; Clear all user data (for reboot)
clear_user_data:
    push {r4, r5, lr}
    ldr r4, =user_data_start
    ldr r5, =user_data_end
    mov r0, #0
.clear_user_loop:
    cmp r4, r5
    bge .clear_user_done
    str r0, [r4]
    add r4, r4, #4
    b .clear_user_loop
.clear_user_done:
    pop {r4, r5, pc}

.section .bss
    .align 4

; Heap area for dynamic allocation
heap_start:
    .space 16384        ; 16KB heap
heap_end:

heap_ptr:
    .space 4

; User data area (persists across reboots for username tracking)
user_data_start:
    .space 8192         ; 8KB for user data
user_data_end:

; Game data area
game_data_start:
    .space 32768        ; 32KB for game state
game_data_end:
