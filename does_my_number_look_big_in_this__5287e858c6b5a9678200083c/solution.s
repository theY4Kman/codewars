%include "io64.inc"

section .text
global CMAIN
CMAIN:
    mov rbp, rsp; for correct debugging

    PRINT_STRING "cr_assert(narcissistic(7)) = "
    mov rdi, 7
    call narcissistic
    PRINT_DEC 1, al
    NEWLINE
    
    PRINT_STRING "cr_assert(narcissistic(371)) = "
    mov rdi, 371
    call narcissistic
    PRINT_DEC 1, al
    NEWLINE
    
    PRINT_STRING "cr_assert_not(narcissistic(122)) = "
    mov rdi, 122
    call narcissistic
    PRINT_DEC 1, al
    NEWLINE
    
    PRINT_STRING "cr_assert_not(narcissistic(4887)) = "
    mov rdi, 4887
    call narcissistic
    PRINT_DEC 1, al
    NEWLINE
    
    
    ret

; <--- bool narcissistic(int num) --->
narcissistic:
    ; NOTE: argument passed as rdi
    
    ; Store our number in a scratch, as we shuffle off digits
    mov rax, rdi
    
    ; Zero out a register, to store total number of digits
    xor rcx, rcx
    
    ; Divide off each digit and push to stack
    grab_digits:
        mov rdx, 0        ; rdx MUST be 0 when dividing
        mov rsi, 10       ; our divisor
        div rsi           ; divide rax / 10, with rdx = remainder
        push rdx          ; save our digit (the remainder) to the stack
        inc rcx           ; increment total number of digits
        cmp rax, 0        ; check if we have any remaining digits
        jnz grab_digits   ; if we do, loop again

    ; Counter to loop over all digits
    mov r8, rcx

    sum_digits:
        ; Grab our next digit
        pop r9
        
        ; Counter for tracking exponentiations left
        mov rsi, rcx
        
        ; We'll be multiplying rax by our digit, so start off with 1
        ;  (rules of exponentiation)
        xor rax, rax
        inc rax
        
        exponentiate_digit:
            mul r9
            dec rsi
            jnz exponentiate_digit
        
        ; Subtract our exponentiated digit from our original number
        sub rdi, rax
        
        dec r8
        jnz sum_digits
    
    ; Our return value is al
    xor al, al
    
    ; If we've subtracted all exponentiated digits and ended with zero,
    ; we're narcissistic.
    cmp rdi, 0
    jnz return
    inc al
    
    return: ret
; ---------> endof narcissistic <---------