%include "io64.inc"

section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging
    ;write your code here
    
    xor rsi, rsi
    
    .reset:
        mov rax, 0xEFFFFFf0
    
    .loop:
        mov rsi, rax
        and rsi, 0xff
        PRINT_HEX 8, rax
        NEWLINE
        PRINT_UDEC 1, rsi
        NEWLINE
        NEWLINE
        
        inc rax
        jc .reset
        jmp .loop
    
    
    ret