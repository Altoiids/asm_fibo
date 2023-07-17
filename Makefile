name := fibos

build: $(name)

$(name): $(name).o
	ld -m elf_i386 -s -o $(name) $(name).o
	./$(name)

$(name).o: $(name).asm
	nasm -f elf $(name).asm

clean:
	rm -rf $(name) $(name).o