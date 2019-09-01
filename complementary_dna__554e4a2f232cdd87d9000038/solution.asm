SECTION .text
global dna_strand

; Returns a new heap-allocated string representing the complementary DNA.
; Note that this function will only receive valid inputs, though feel free to do edge-checking.

; char *dna_strand(const char *dna)
dna_strand:
  mov rsi, rdi

  .count_chars:
    mov rax, [rsi]
    inc rsi
    cmp rax, 0
    jz .count_chars

  sub rsi, rdi

  xor rax, rax
  ret
