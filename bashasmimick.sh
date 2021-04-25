#!/bin/bash

if [ "$1" == "" ]; then

	echo "No source asmimick file (.amk) provided."
	exit 1

fi

fileName=$(echo "$1" | cut -d'.' -f1)
asmFile=""$fileName".asm"
datasec="section .data\n"
textsec="section .text\n%include 'stdlib.asm'\n"
textsec="$textsec""global _start\n""_start:\n"
textsec="$textsec""xor eax, eax ; so that you can define 'note_need_thing db 0x90 (nop) to be able to see the note in r2 debugger or normal r2 if not stripped'\n"
hasnewlinedb=0
rm -f $asmFile
rm -f Makefile

while read line; do

	instr=$(echo "$line" | cut -d' ' -f1)

	if [ "$instr" == "inline-prt" ]; then

		string=$(echo -n "$line" | awk -F ' <s> ' '{print $2}')
		stringname=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20)
		stringname="_""$stringname"
		stringlenname="$stringname""len"

		datasec="$datasec""\n$stringname db $string, 0x00\n"
		datasec="$datasec""$stringlenname equ \$-$stringname\n\n"

		textsec="$textsec""\nmov edx, $stringlenname\n"
		textsec="$textsec""mov ecx, $stringname\n"
		textsec="$textsec""mov ebx, 1\n"
		textsec="$textsec""mov eax, 4\n"
		textsec="$textsec""int 0x80\n"
		
	elif [ "$instr" == "prt" ]; then

		string=$(echo -n "$line" | awk -F ' <s> ' '{print $2}')
		stringname=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20)
		stringname="_""$stringname"

		datasec="$datasec""$stringname db $string, 0x00\n"

		textsec="$textsec""\nmov ecx, $stringname\n"
		textsec="$textsec""call _stdstrlen\n"
		textsec="$textsec""call _stdprint\n"
		
	elif [ "$instr" == "inline-nwl" ]; then

		if [ "$hasnewlinedb" == "0" ]; then

			datasec="$datasec""newline db 0x0a, 0x00\n"

			textsec="$textsec""\nmov edx, 2\n"
			textsec="$textsec""mov ecx, newline\n"
			textsec="$textsec""mov ebx, 1\n"
			textsec="$textsec""mov eax, 4\n"
			textsec="$textsec""int 0x80\n"

			hasnewlinedb=1

		else

			textsec="$textsec""\nmov edx, 2\n"
			textsec="$textsec""mov ecx, newline\n"
			textsec="$textsec""mov ebx, 1\n"
			textsec="$textsec""mov eax, 4\n"
			textsec="$textsec""int 0x80\n"

		fi

	elif [ "$instr" == "nwl" ]; then

		if [ "$hasnewlinedb" == "0" ]; then

			datasec="$datasec""newline db 0x0a, 0x00\n"

			textsec="$textsec""\nmov edx, 2\n"
			textsec="$textsec""mov ecx, newline\n"
			textsec="$textsec""call _stdprint\n"

			hasnewlinedb=1

		else

			textsec="$textsec""\nmov edx, 2\n"
			textsec="$textsec""mov ecx, newline\n"
			textsec="$textsec""call _stdprint\n"

		fi

	elif [ "$instr" == ";" ] || [ "$instr" == "" ]; then

		:

	elif [ "$instr" == "end" ]; then

		textsec="$textsec""\nxor ebx, ebx\n""call _stdexit"

	fi

done < $1

echo -e $datasec >> $asmFile
echo -e $textsec >> $asmFile
nasm -f elf $asmFile
ld -m elf_i386 "$fileName".o -o $fileName

if [ "$DEBUG" != "" ]; then
	echo "all: assemble link" >> Makefile
	echo "assemble:" >> Makefile
	echo "	nasm -f elf $asmFile" >> Makefile
	echo "link:" >> Makefile
	echo "	ld -m elf_i386 "$fileName".o -o $fileName" >> Makefile
	echo "strip:" >> Makefile
	echo "	strip -s $fileName" >> Makefile
	echo "cleanup:" >> Makefile
	echo "	rm -f $asmFile" >> Makefile
	echo "	rm -f "$fileName".o" >> Makefile
	echo "	rm -f $fileName" >> Makefile
	echo "	rm -f Makefile" >> Makefile
	NOSTRIP=0
else
	rm -f $asmFile
	rm -f "$fileName".o
fi

if [ "$NOSTRIP" != "" ]; then
	:
else
	strip -s $fileName
fi

echo "Compiled to executable '$fileName'"
