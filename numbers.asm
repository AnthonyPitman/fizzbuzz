section .text
    global _start

_start:
    push '0'
    ; call the sys_write system call
    mov rax, 1
    mov edi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    add rsp, 8              ; restore stack pointer
    ; exit the program
    mov rax, 60
    xor rdi, rdi
    syscall