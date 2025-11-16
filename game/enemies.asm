; Smith&Vader OS ES - Enemy System
; Agents and Stormtroopers with AI pursuit

.section .text
.global spawn_enemies
.global update_enemies
.global draw_enemies
.global check_all_collisions
.global spawn_bosses
.global draw_bosses
.global are_bosses_defeated

; Enemy types
.equ ENEMY_AGENT, 0
.equ ENEMY_STORMTROOPER, 1
.equ ENEMY_SMITH, 2
.equ ENEMY_VADER, 3

; Enemy characters
.equ CHAR_AGENT, 'A'
.equ CHAR_STORMTROOPER, 'S'
.equ CHAR_SMITH, 'M'          ; M for Matrix/Smith
.equ CHAR_VADER, 'V'

; Max enemies
.equ MAX_REGULAR_ENEMIES, 10
.equ ENEMY_SIZE, 16           ; x, y, type, active (4 words)

; Spawn initial enemies
spawn_enemies:
    push {r4, r5, r6, r7, r8, lr}

    ldr r4, =enemies
    mov r5, #0                  ; Counter

.spawn_loop:
    cmp r5, #MAX_REGULAR_ENEMIES
    bge .spawn_done

    ; Random position
    bl random
    and r6, r0, #0x3F
    add r6, r6, #10             ; X: 10-74

    bl random
    and r7, r0, #0x0F
    add r7, r7, #5              ; Y: 5-20

    ; Random type (agent or stormtrooper)
    bl random
    and r8, r0, #1

    ; Calculate enemy offset
    mov r0, #ENEMY_SIZE
    mul r1, r5, r0
    add r0, r4, r1

    ; Store enemy data
    str r6, [r0]                ; X
    str r7, [r0, #4]            ; Y
    str r8, [r0, #8]            ; Type
    mov r1, #1
    str r1, [r0, #12]           ; Active

    add r5, r5, #1
    b .spawn_loop

.spawn_done:
    pop {r4, r5, r6, r7, r8, pc}

; Spawn Smith and Vader
spawn_bosses:
    push {lr}

    ; Spawn Smith
    ldr r0, =boss_smith
    mov r1, #20
    str r1, [r0]                ; X
    mov r1, #10
    str r1, [r0, #4]            ; Y
    mov r1, #1
    str r1, [r0, #8]            ; Active

    ; Spawn Vader
    ldr r0, =boss_vader
    mov r1, #60
    str r1, [r0]                ; X
    mov r1, #10
    str r1, [r0, #4]            ; Y
    mov r1, #1
    str r1, [r0, #8]            ; Active

    pop {pc}

; Update all enemies
update_enemies:
    push {r4, r5, r6, lr}

    ldr r4, =enemies
    mov r5, #0

.update_loop:
    cmp r5, #MAX_REGULAR_ENEMIES
    bge .update_bosses

    ; Calculate enemy offset
    mov r0, #ENEMY_SIZE
    mul r1, r5, r0
    add r6, r4, r1

    ; Check if active
    ldr r0, [r6, #12]
    cmp r0, #0
    beq .update_next

    ; Update this enemy
    mov r0, r6
    bl update_single_enemy

.update_next:
    add r5, r5, #1
    b .update_loop

.update_bosses:
    ; Update Smith
    ldr r0, =boss_smith
    ldr r1, [r0, #8]            ; Active?
    cmp r1, #0
    beq .update_vader
    bl update_boss

.update_vader:
    ldr r0, =boss_vader
    ldr r1, [r0, #8]            ; Active?
    cmp r1, #0
    beq .update_done
    bl update_boss

.update_done:
    pop {r4, r5, r6, pc}

; Update single enemy with simple AI
; r0 = pointer to enemy data
update_single_enemy:
    push {r4, r5, r6, r7, r8, lr}

    mov r4, r0

    ; Get enemy position
    ldr r5, [r4]                ; X
    ldr r6, [r4, #4]            ; Y

    ; Get Peon position
    bl get_peon_pos
    mov r7, r0                  ; Peon X
    mov r8, r1                  ; Peon Y

    ; Simple pursuit AI - move toward Peon
    ; Compare X
    cmp r5, r7
    subgt r5, r5, #1            ; Move left if enemy X > peon X
    addlt r5, r5, #1            ; Move right if enemy X < peon X

    ; Compare Y (only if X matched)
    cmp r6, r8
    subgt r6, r6, #1            ; Move up
    addlt r6, r6, #1            ; Move down

    ; Bounds check
    cmp r5, #0
    movlt r5, #0
    cmp r5, #79
    movgt r5, #79
    cmp r6, #0
    movlt r6, #0
    cmp r6, #23
    movgt r6, #23

    ; Store new position
    str r5, [r4]
    str r6, [r4, #4]

    pop {r4, r5, r6, r7, r8, pc}

; Update boss enemy (Smith or Vader)
; r0 = pointer to boss data
update_boss:
    push {r4, r5, r6, r7, r8, lr}

    mov r4, r0

    ; Get boss position
    ldr r5, [r4]                ; X
    ldr r6, [r4, #4]            ; Y

    ; Get Peon position
    bl get_peon_pos
    mov r7, r0                  ; Peon X
    mov r8, r1                  ; Peon Y

    ; Bosses move more intelligently - diagonal movement
    cmp r5, r7
    subgt r5, r5, #1
    addlt r5, r5, #1

    cmp r6, r8
    subgt r6, r6, #1
    addlt r6, r6, #1

    ; Store new position
    str r5, [r4]
    str r6, [r4, #4]

    pop {r4, r5, r6, r7, r8, pc}

; Draw all enemies
draw_enemies:
    push {r4, r5, r6, r7, lr}

    ldr r4, =enemies
    mov r5, #0

.draw_loop:
    cmp r5, #MAX_REGULAR_ENEMIES
    bge .draw_done

    ; Calculate enemy offset
    mov r0, #ENEMY_SIZE
    mul r1, r5, r0
    add r6, r4, r1

    ; Check if active
    ldr r0, [r6, #12]
    cmp r0, #0
    beq .draw_next

    ; Get position and type
    ldr r0, [r6]                ; X
    ldr r1, [r6, #4]            ; Y
    ldr r7, [r6, #8]            ; Type

    ; Choose character
    cmp r7, #ENEMY_AGENT
    moveq r2, #CHAR_AGENT
    movne r2, #CHAR_STORMTROOPER

    ; Draw
    bl set_char_at

.draw_next:
    add r5, r5, #1
    b .draw_loop

.draw_done:
    pop {r4, r5, r6, r7, pc}

; Draw bosses
draw_bosses:
    push {r4, lr}

    ; Draw Smith
    ldr r4, =boss_smith
    ldr r0, [r4, #8]            ; Active?
    cmp r0, #0
    beq .draw_vader_boss

    ldr r0, [r4]                ; X
    ldr r1, [r4, #4]            ; Y
    mov r2, #CHAR_SMITH
    bl set_char_at

.draw_vader_boss:
    ; Draw Vader
    ldr r4, =boss_vader
    ldr r0, [r4, #8]            ; Active?
    cmp r0, #0
    beq .draw_bosses_done

    ldr r0, [r4]                ; X
    ldr r1, [r4, #4]            ; Y
    mov r2, #CHAR_VADER
    bl set_char_at

.draw_bosses_done:
    pop {r4, pc}

; Check all collisions
check_all_collisions:
    push {r4, r5, r6, r7, lr}

    ; Get Peon position
    bl get_peon_pos
    mov r6, r0                  ; Peon X
    mov r7, r1                  ; Peon Y

    ; Check collision with regular enemies
    ldr r4, =enemies
    mov r5, #0

.collision_loop:
    cmp r5, #MAX_REGULAR_ENEMIES
    bge .check_boss_collision

    ; Calculate enemy offset
    mov r0, #ENEMY_SIZE
    mul r1, r5, r0
    add r0, r4, r1

    ; Check if active
    ldr r1, [r0, #12]
    cmp r1, #0
    beq .collision_next

    ; Check position
    ldr r1, [r0]                ; Enemy X
    ldr r2, [r0, #4]            ; Enemy Y

    cmp r1, r6
    bne .collision_next
    cmp r2, r7
    bne .collision_next

    ; Collision detected!
    ldr r3, [r0, #8]            ; Enemy type

    ; Check if Peon can eat this enemy
    cmp r3, #ENEMY_AGENT
    beq .collision_with_agent

    ; Stormtrooper
    mov r0, #POWER_STORMTROOPER
    bl is_peon_powered
    cmp r0, #1
    beq .eat_enemy

    ; Not powered - death!
    bl kill_peon
    b .collision_done

.collision_with_agent:
    mov r0, #POWER_AGENT
    bl is_peon_powered
    cmp r0, #1
    beq .eat_enemy

    ; Not powered - death!
    bl kill_peon
    b .collision_done

.eat_enemy:
    ; Deactivate enemy
    mov r0, #ENEMY_SIZE
    mul r1, r5, r0
    add r0, r4, r1
    mov r1, #0
    str r1, [r0, #12]

.collision_next:
    add r5, r5, #1
    b .collision_loop

.check_boss_collision:
    ; Check Smith collision
    ldr r0, =boss_smith
    ldr r1, [r0, #8]            ; Active?
    cmp r1, #0
    beq .check_vader_collision

    ldr r1, [r0]                ; X
    ldr r2, [r0, #4]            ; Y
    cmp r1, r6
    bne .check_vader_collision
    cmp r2, r7
    bne .check_vader_collision

    ; Collision with Smith!
    mov r1, #POWER_ASTERISK
    bl is_peon_powered
    cmp r0, #1
    bne .boss_kills_peon

    ; Eat Smith!
    ldr r0, =boss_smith
    mov r1, #0
    str r1, [r0, #8]
    b .check_vader_collision

.check_vader_collision:
    ; Check Vader collision
    ldr r0, =boss_vader
    ldr r1, [r0, #8]            ; Active?
    cmp r1, #0
    beq .collision_done

    ldr r1, [r0]                ; X
    ldr r2, [r0, #4]            ; Y
    cmp r1, r6
    bne .collision_done
    cmp r2, r7
    bne .collision_done

    ; Collision with Vader!
    mov r1, #POWER_ASTERISK
    bl is_peon_powered
    cmp r0, #1
    bne .boss_kills_peon

    ; Eat Vader!
    ldr r0, =boss_vader
    mov r1, #0
    str r1, [r0, #8]
    b .collision_done

.boss_kills_peon:
    bl kill_peon

.collision_done:
    pop {r4, r5, r6, r7, pc}

; Check if both bosses are defeated
; Returns: r0 = 1 if both defeated, 0 otherwise
are_bosses_defeated:
    push {r4, lr}

    ldr r4, =boss_smith
    ldr r0, [r4, #8]
    cmp r0, #1
    moveq r0, #0                ; Smith still active
    beq .bosses_check_done

    ldr r4, =boss_vader
    ldr r0, [r4, #8]
    cmp r0, #1
    moveq r0, #0                ; Vader still active
    beq .bosses_check_done

    ; Both defeated
    mov r0, #1

.bosses_check_done:
    pop {r4, pc}

.section .bss
    .align 4

; Regular enemy array
enemies:
    .space (ENEMY_SIZE * MAX_REGULAR_ENEMIES)

; Boss enemies
boss_smith:
    .space 12               ; x, y, active

boss_vader:
    .space 12               ; x, y, active
