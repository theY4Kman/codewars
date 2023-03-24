global reverse_num

section .text

; long long reverse_num(long long n [rdi]) -> [rax]
reverse_num:
    ; rdi: input number
    ; rsi: working register for calculating return value
    ; rax: quotient while dividing, and eventual return value
    ; rdx: remainder while dividing
    ; r8: scratch
    ; r10: holds the number 10

    xor rsi, rsi

    ; store input as unsigned integer
    ; ref: https://stackoverflow.com/a/11927940/148585
    mov rax, rdi
    mov r8, rax             ; copy our orig num to a scratch register
    neg rax                 ; negate our orig num
    cmovl rax, r8           ; if our negated num is less than our orig num in the scratch,
                            ;   we know it was originally positive — so copy back the orig value

    mov r10, 10

    .loop:
        ; break the loop if we've run out of digits
        ;  (i.e. if our quotient is 0)
        test rax, rax
        jz .end

        ; shift our working value left a decimal digit
        mov r8, rax         ; mul stores its value to rax, so save it for later restoration
        mov rax, rsi        ; move our working result register to rax for multiplication
        xor rdx, rdx        ; overflow is held in rdx. if not zeroed, arithmetic exc may be thrown
        mul r10             ; result -> rax, overflow -> rdx
        mov rsi, rax        ; move our shifted result back to its home register, rsi
        mov rax, r8         ; restore

        xor rdx, rdx
        div r10             ; quotient -> rax, remainder -> rdx

        add rsi, rdx        ; add our single digit to our working register

        jmp .loop

    .end:
        add rdi, 0          ; Set SF (sign flag) if input is negative
        jns .ret            ; Skip negation if input is positive (SF unset)
        neg rsi             ; Negate significance of digit holder if input is negative (SF set)

    .ret:
        mov rax, rsi        ; copy our working register to its return register, rax
        ret
