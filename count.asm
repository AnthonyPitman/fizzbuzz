; ------------------------------------------------------------------
; Write out the numbers 1-10 on a new line using only
; system calls. Runs on 64-bit Linux only.
; To assemble run:
;   nasm -f elf64 count.asm && ld count.o && ./a.out
; ------------------------------------------------------------------

section .data
    newline db 10,0

section .text
    global _start

_start:
    mov r8, 1               ; count = 1;
loop_start:
    cmp r8, 100             ; count <= 100
    jg exit_program
    mov rax, r8             ; move the current number to rax
    call print_number       ; print out a number
    call print_newline      ; print newline after each line
    inc r8                  ; count++
    jmp loop_start

exit_program:
    ; call syscall 60 for sys_exit
    mov rax, 60             ; call for sys_exit
    xor rdi, rdi            ; exit code 0
    syscall

print_newline:
    ; call sys_write with a newline character write(int fd, const void *buf, size_t count);
    ; rax=syscall_number=1 for write, rdi=fd=1=stdout, rsi=buf=\n, rdx=count=size_of_buffer
    mov rax, 1              ; syscall number for write
    mov edi, 1              ; file descriptor for stdout
    mov rsi, newline        ; newline character to write to the stdout
    mov rdx, 1              ; size of the buffer which is one for the newline character
    syscall
    ret

print_number:
    ; call sys_write(int fd, const void *buf, size_t count);
    ; rax=syscall=1, rdi=fd=1=stdout, rsi=buf=digit, rdx=count=buff_size
    push rax        ; preserve rax
    push rdi        ; preserve rdi

    mov rax, r8     ; number to be converted
    mov rcx, 10     ; divisor
    xor rbx, rbx    ; count digits

divide:
    xor rdx, rdx    ; clear remainder
    div ecx         ; divide to get remainder
    add rdx, '0'    ; convert remainder to ASCII
    push rdx        ; put remainder onto stack
    inc rbx         ; increase stacked value count
    test rax, rax   ; check if there is another digit
    jnz divide

print_digits:
    mov rsi, rsp    ; get value location from stack

    ; prepare for sys_write call
    mov rax, 1      ; calling sys_write
    mov edi, 1      ; writing to stdout
    mov rdx, 1      ; writing a single character
    syscall
    add rsp, 8      ; skip stack value
    dec rbx         ; decrement count of stacked values
    test rbx, rbx   ; check if there are more stacked values
    jnz print_digits

    pop rdi     ; restore rdi
    pop rax     ; restore rax
    ret