:align 4
:section .text
:global _start

_start:
    mov %qg0, 5
    mov %qg1, [%qg0]
    push64 %qg0
    ret