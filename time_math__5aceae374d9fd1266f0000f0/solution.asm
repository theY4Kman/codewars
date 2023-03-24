extern malloc
section .text
global time_math
; char *time_math(const char *time1, const char *op, const char *time2);
; input:  rdi = time1, rsi = op, rdx = time2
; output: rax
time_math:
  push rdx
  call parse_time
  pop rdx
  mov rdi, rax

  push rdi
  mov rdi, rdx
  call parse_time
  mov rdx, rax
  pop rdi

  cmp byte [rsi], '+'
  je .add

  ; subtract
  sub rdi, rdx
  jmp .bounds

.add:
  add rdi, rdx

.bounds:
  ; check for negatives first
  cmp rdi, 0
  jge .positive

  ; negative, do the wraparound
  add rdi, 86400
  jmp .format

.positive:
  ; if not negative, check for overflow
  cmp rdi, 86399
  jle .format

  ; overflow, modulo the overflow
  ; (and since we're only dealing with two durations, we can just subtract 86400)
  sub rdi, 86400

.format:
  call format_time
  ret

; char *format_time(int seconds);
; input:  rdi = seconds
; output: rax
format_time:
  mov r13, rdi    ; save passed seconds in tmp register
  mov rdi, 9
  call malloc
  mov rdi, r13    ; restore seconds

  mov r9, rax     ; store char* result before clobbering

  mov rax, rdi
  mov ebx, 3600
  xor edx, edx
  div ebx
  mov r10d, edx    ; minutes and seconds back to sum

  mov ebx, 10
  xor edx, edx
  div ebx
  add eax, '0'
  mov byte [r9], al

  add edx, '0'
  mov byte [r9+1], dl

  mov [r9+2], byte ':'

  mov eax, r10d
  mov ebx, 60
  xor edx, edx
  div ebx
  mov r10d, edx    ; only seconds remain in sum now

  mov ebx, 10
  xor edx, edx
  div ebx
  add eax, byte '0'
  mov byte [r9+3], al

  add edx, '0'
  mov byte [r9+4], dl

  mov [r9+5], byte ':'

  mov eax, r10d
  mov ebx, 10
  xor edx, edx
  div ebx
  add eax, '0'
  mov byte [r9+6], al

  add edx, '0'
  mov byte [r9+7], dl

  mov byte [r9+8], 0    ; NULL terminator

  mov rax, r9           ; return value
  ret

; int parse_time(const char *time);
; input:  rdi = time
; output: rax
parse_time:
  push rbx
  xor rax, rax

  ; hours, 10s digit
  movzx eax, byte [rdi]
  sub eax, '0'
  mov ebx, 10
  mul ebx

  ; hours, 1s digit
  movzx ebx, byte [rdi+1]
  sub ebx, '0'
  add eax, ebx
  mov ebx, 60*60
  mul ebx        ; 60 * 60 = 1hr
  mov ecx, eax    ; move result to storage

  ; minutes, 10s digit
  movzx eax, byte [rdi+3]
  sub eax, '0'
  mov ebx, 10
  mul ebx

  ; minutes, 1s digit
  movzx ebx, byte [rdi+4]
  sub ebx, '0'
  add eax, ebx
  mov ebx, 60
  mul ebx          ; 60s in 1min
  add ecx, eax    ; add back to stored sum

  ; seconds, 10s digit
  movzx eax, byte [rdi+6]
  sub eax, '0'
  mov ebx, 10
  mul ebx

  ; seconds, 1s digit
  movzx ebx, byte [rdi+7]
  sub ebx, '0'
  add eax, ebx
  add eax, ecx

  ; restore clobbered rbx
  pop rbx

  ret
