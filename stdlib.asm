_stdcurbrk:
push ebx ; protecc

xor ebx, ebx ; optimize mov ebx, 0 for size
mov eax, 45
int 0x80

pop ebx
ret

_stdincbrk:
push ecx
push ebx ; protect registers while working

mov ecx, ebx

xor ebx, ebx ; optimize mov ebx, 0 for size
mov eax, 45
int 0x80

add eax, ecx

mov ebx, eax
mov eax, 45
int 0x80

pop ebx
pop ecx ; re-fill registers with their values
ret

_stddecbrk:
push ecx
push ebx ; protect registers while working

mov ecx, ebx

xor ebx, ebx ; optimize mov ebx, 0 for size
mov eax, 45
int 0x80

sub eax, ecx

mov ebx, eax
mov eax, 45
int 0x80

pop ebx
pop ecx ; re-fill registers with their values
ret

_stdstrlen:
mov edx, ecx ; needs to be passed ecx: string

	.nextchar:

	cmp byte [edx], 0
	jz .done
	inc edx
	jmp .nextchar

	.done:

	sub edx, ecx
	ret ; returns in edx

_stdprint:
push ebx ; protect ebx

xor ebx, ebx ; needs to be passed edx and ecx
inc ebx ; set fd to stdout

mov eax, 4 ; syscall #
int 0x80

pop ebx ; re-fill
ret

_stdexit:
xor eax,eax ; lowest bytes used to get to 
inc eax     ; 1 in eax, this uses 3 while 
int 0x80    ; mov uses 5
