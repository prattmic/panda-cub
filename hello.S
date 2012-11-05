.globl start

start:
    ldr r0, =0x48020000
    mov r1, #0x48
    str r1, [r0]
    mov r1, #0x45
    str r1, [r0]
    mov r1, #0x4C
    str r1, [r0]
    mov r1, #0x4C
    str r1, [r0]
    mov r1, #0x4F
    str r1, [r0]
    mov r1, #0x0A
    str r1, [r0]
    mov r1, #0x0D
    str r1, [r0]

hang:
    b start
