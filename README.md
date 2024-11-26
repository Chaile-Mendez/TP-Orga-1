nasm -f elf64 -g -F dwarf main.asm -o main.o
nasm -f elf64 -g -F dwarf tablero.asm -o tablero.o
nasm -f elf64 -g -F dwarf transformaciones.asm -o transformaciones.o
nasm -f elf64 -g -F dwarf contarJugadores.asm -o contarJugadores.o
nasm -f elf64 -g -F dwarf imprimir.asm -o imprimir.o
