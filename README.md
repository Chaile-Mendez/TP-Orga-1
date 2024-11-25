nasm -f elf64 main.asm -o main.o
nasm -f elf64 input.asm -o input.o
nasm -f elf64 movimiento.asm -o movimiento.o
nasm -f elf64 turno.asm -o turno.o
nasm -f elf64 tablero.asm -o tablero.o
nasm -f elf64 imprimir.asm -o imprimir.o
nasm -f elf64 constantes.asm -o constantes.o
nasm -f elf64 datos.asm -o datos.o
nasm -f elf64 transformaciones.asm -o transformaciones.o

ld main.o input.o movimiento.o turno.o tablero.o imprimir.o constantes.o datos.o transformaciones.o -o juego -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2
