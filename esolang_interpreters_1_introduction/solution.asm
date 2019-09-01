section .text
global interpret

; void interpret(const char *code [rax], char *output [rdx])
interpret:

  xor bl, bl                        ; our memory cell

  .process:
    mov cl, [rax]                   ; grab the current instruction char
    cmp cl, 0                       ; check for NULL marking end of instructions
    je .end                         ;   if it *is* NULL, exit processing

    cmp cl, '+'                     ; check for "increment memory cell" instruction
    jne .process_output_instr       ;   if it's *not* the incr instr, check other instruction type

    inc bl                          ; perform "increment memory cell" instruction (bl is our memory cell)
    jmp .next_instr                 ; all done executing instruction, move to next instruction

    .process_output_instr:
      cmp cl, '.'                   ; check for "append memory cell to output" instruction
      jne .next_instr               ;   if it's *not* the output instr, move to next instruction (we have no other instr types to check)

      mov [rdx], bl                 ; perform the "append memory cell to output" instruction (rdx points to output, bl is our memory cell)
      inc rdx                       ; after we've written the char to output, move our pointer one step ahead, so next output is in correct place

    .next_instr:
      inc rax                       ; increment our instruction pointer (rax)
      jmp .process                  ; process the next instruction

  .end:
    mov byte [rdx], 0               ; ensure our output ends with a NULL byte
    ret
