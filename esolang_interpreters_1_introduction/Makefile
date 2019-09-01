build: solution.o test.c
	gcc -g -l criterion test.c solution.o -o test.elf -m64 -fno-pie -no-pie

solution.o: solution.asm
	nasm -g -f elf64 -l solution.lst solution.asm -o solution.o

clean:
	rm -f *.o *.lst *.elf
