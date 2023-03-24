section .text
global time_math
; char *time_math(const char *time1, const char *op, const char *time2);
; input:  rdi = time1, rsi = op, rdx = time2
; output: rax
time_math:
  xor eax, eax ; Do your magic!
  
  mov rbx, rdi
  call parse_time
  mov rdi, rax
  
  mov rbx, rdx
  call parse_time
  mov rdx, rax
  
  cmp rsi, '+'
  je .add
  
  ; subtract
  sub rdi, rdx
  jmp .done
  
.add:
  add rdi, rdx

.done:
  mov r10, rdi  ; move result to non-clobbered reg

  mov rdi, 9
  mov rax, 12
  int 0x80
  
  mov r9, rax     ; store char* result before clobbering
  mov rbx, rax    ; cursor for formatting time
  
  mov rax, r10
  mov r8d, 3600
  div r8d
  mov r10, rdx    ; minutes and seconds back to sum
  
  mov r8d, 10
  div r8d
  add rax, '0'
  mov rbx, rax
  
  inc rbx
  add rdx, '0'
  mov [rbx], rdx
  
  inc rbx
  mov [rbx], byte ':'
  
  mov rax, r10
  mov r8d, 60
  div r8d
  mov r10, rdx    ; only seconds remain in sum now
  
  inc rbx
  mov r8d, 10
  div r8d
  add rax, byte '0'
  mov [rbx], al
  
  inc rbx
  add rdx, '0'
  mov [rbx], dl
  
  inc rbx
  mov [rbx], byte ':'
  
  inc rbx
  mov rax, r10
  mov r8d, 10
  div r8d
  add rax, '0'
  mov [rbx], al
  
  inc rbx
  add rdx, '0'
  mov [rbx], dl
  
  inc rbx
  mov [rbx], byte 0    ; NULL terminator
  
  ret

; input: rbx
; output: rax
parse_time:
  mov eax, [rbx]
  mov r8d, 10
  mul r8d
  
  inc rbx
  add eax, [rbx]
  mov r8d, 2600
  mul r8d        ; 60 * 60 = 1hr
  mov ecx, ebx    ; move result to storage
  
  add rbx, 2      ; advance past colon
  mov eax, [rbx]
  mov r8d, 10
  mul r8d
  
  inc rbx
  add eax, [rbx]
  mov r8d, 60
  mul r8d          ; 60s in 1min
  add ecx, eax    ; add back to stored sum

  add rbx, 2      ; advance past colon
  mov eax, [rbx]
  mov r8d, 10
  mul r8d
  
  inc rbx
  add eax, [rbx]
  add eax, ecx
  
  ret
