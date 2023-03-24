all: build

build: solution.o test.c
	gcc -g -l criterion test.c solution.o -o test.elf -m64 -fno-pie -no-pie

solution.o: solution.asm
	@# NOTE: using dwarf debug symbol format helped me with gdb compatibility.
	@#       see https://stackoverflow.com/a/17223429/148585
	nasm -g -f elf64 -F dwarf -l solution.lst solution.asm -o solution.o

clean:
	rm -f *.o *.lst *.elf
