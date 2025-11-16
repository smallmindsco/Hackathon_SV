; Smith&Vader OS ES - Interrupt Handling
; Basic interrupt support for keyboard input

.section .text
.global init_interrupts
.global enable_interrupts
.global disable_interrupts

; Initialize interrupt system
init_interrupts:
    push {lr}

    ; Set up interrupt vector table
    ldr r0, =vector_table
    mcr p15, 0, r0, c12, c0, 0  ; Set VBAR (Vector Base Address Register)

    ; Enable IRQ interrupts
    bl enable_interrupts

    pop {pc}

; Enable interrupts
enable_interrupts:
    push {lr}
    cpsie i                      ; Clear interrupt mask
    pop {pc}

; Disable interrupts
disable_interrupts:
    push {lr}
    cpsid i                      ; Set interrupt mask
    pop {pc}

; IRQ Handler
irq_handler:
    push {r0-r12, lr}

    ; Check interrupt source
    ; TODO: Handle keyboard, timer, etc.

    pop {r0-r12, lr}
    subs pc, lr, #4

; Undefined instruction handler
undefined_handler:
    b .

; SWI handler
swi_handler:
    push {r0-r12, lr}
    ; Handle system calls here
    pop {r0-r12, lr}
    movs pc, lr

; Prefetch abort handler
prefetch_abort_handler:
    b .

; Data abort handler
data_abort_handler:
    b .

; FIQ handler
fiq_handler:
    subs pc, lr, #4

.section .data
    .align 4

; Interrupt vector table
vector_table:
    ldr pc, =_start              ; Reset
    ldr pc, =undefined_handler   ; Undefined instruction
    ldr pc, =swi_handler         ; Software interrupt
    ldr pc, =prefetch_abort_handler  ; Prefetch abort
    ldr pc, =data_abort_handler  ; Data abort
    nop                          ; Reserved
    ldr pc, =irq_handler         ; IRQ
    ldr pc, =fiq_handler         ; FIQ
