section .data
_AgauSZkxqVsTvFXKFfzH db "Hello, World!", 0x00
newline db 0x0a, 0x00
_8BlbdwySvfYR47zDAn6x db 'This is a program to demonstrate that', 0x00
_s5EUgqRHDJ5ChrvOlT5e db ' you can concatenate prints!', 0x00
_OLKar5juhy1OdfoO1RzJ db 'Using hex value for the quote in don', 0x27, 't', 0x00
_j5W8TddiZGcqel3J5l4c db "Putting double quotes so you can use single quotes in don't", 0x00
_tP9BcseMHPBnHT5C54yD db 'It is possible.', 0x00

section .text
%include 'stdlib.asm'
global _start
_start:
xor eax, eax

call _stdcurbrk
mov ecx, eax

mov ebx, 64
call _stdincbrk

mov dword [ecx], 7565
mov eax, dword [ecx]

mov ebx, 62
call _stddecbrk
; debug and look at registers and whatnot
call _stdcurbrk

mov dword [ecx], 7565
mov eax, dword [ecx]

mov ecx, _AgauSZkxqVsTvFXKFfzH
call _stdstrlen
call _stdprint

mov edx, 2
mov ecx, newline
call _stdprint

mov ecx, _8BlbdwySvfYR47zDAn6x
call _stdstrlen
call _stdprint

mov ecx, _s5EUgqRHDJ5ChrvOlT5e
call _stdstrlen
call _stdprint

mov edx, 2
mov ecx, newline
call _stdprint

mov ecx, _OLKar5juhy1OdfoO1RzJ
call _stdstrlen
call _stdprint

mov edx, 2
mov ecx, newline
call _stdprint

mov ecx, _j5W8TddiZGcqel3J5l4c
call _stdstrlen
call _stdprint

mov edx, 2
mov ecx, newline
call _stdprint

mov ecx, _tP9BcseMHPBnHT5C54yD
call _stdstrlen
call _stdprint

mov edx, 2
mov ecx, newline
call _stdprint

xor ebx, ebx
call _stdexit
