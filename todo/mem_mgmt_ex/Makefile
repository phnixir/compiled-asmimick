all: assemble link
assemble:
	nasm -f elf program.asm
link:
	ld -m elf_i386 program.o -o program
strip:
	strip -s program
