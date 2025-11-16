; Smith&Vader OS ES - Tiny Context Protocol (TCP)
; Revolutionary protocol for communicating with Emperor 8LM

.section .text
.global tcp_init
.global tcp_send_request
.global tcp_receive_response

; TCP Protocol version
.equ TCP_VERSION, 1
.equ TCP_MAX_PAYLOAD, 256

; Initialize TCP
tcp_init:
    push {lr}

    ldr r0, =tcp_initialized
    mov r1, #1
    str r1, [r0]

    pop {pc}

; Send TCP request to Emperor 8LM
; r0 = request type (0 = death speech)
tcp_send_request:
    push {r4, lr}

    mov r4, r0

    ; Build TCP packet header
    ldr r0, =tcp_packet
    mov r1, #0x54               ; 'T'
    strb r1, [r0]
    mov r1, #0x43               ; 'C'
    strb r1, [r0, #1]
    mov r1, #0x50               ; 'P'
    strb r1, [r0, #2]
    mov r1, #TCP_VERSION
    strb r1, [r0, #3]

    ; Store request type
    strb r4, [r0, #4]

    ; Display TCP transmission
    ldr r0, =tcp_tx_msg
    bl print_string

    pop {r4, pc}

; Receive TCP response
; Returns: r0 = pointer to response data
tcp_receive_response:
    push {lr}

    ldr r0, =tcp_rx_msg
    bl print_string

    ; Simulate receiving response
    ldr r0, =tcp_response_buffer

    pop {pc}

.section .data

tcp_tx_msg:
    .ascii "  [TCP] Transmitting request to 8LM...\n"
    .asciz ""

tcp_rx_msg:
    .ascii "  [TCP] Receiving response from 8LM...\n\n"
    .asciz ""

.section .bss
    .align 4

tcp_initialized:
    .word 0

; TCP packet buffer
tcp_packet:
    .space 512

; TCP response buffer
tcp_response_buffer:
    .space 512
