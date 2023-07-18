name := fibos

build: $(name)

$(name): $(name).o
	ld -s -o $(name) $(name).o
	./$(name)

$(name).o: $(name).asm
	nasm -f elf64 $(name).asm

clean:
	rm -rf $(name) $(name).o