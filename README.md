nasm -f elf64 main.asm -o main.o;
nasm -f elf64 input.asm -o input.o;
nasm -f elf64 validacion_movimiento.asm -o validacion_movimiento.o;
nasm -f elf64 ejecucion_movimiento.asm -o ejecucion_movimiento.o;
nasm -f elf64 funciones_auxiliares.asm -o funciones_auxiliares.o;
nasm -f elf64 turno.asm -o turno.o;
nasm -f elf64 tablero.asm -o tablero.o;
nasm -f elf64 imprimir.asm -o imprimir.o;
nasm -f elf64 constantes.asm -o constantes.o;
nasm -f elf64 datos.asm -o datos.o;
nasm -f elf64 transformaciones.asm -o transformaciones.o;
nasm -f elf64 contar_jugadores.asm -o contar_jugadores.o;
nasm -f elf64 menu.asm -o menu.o;
nasm -f elf64 guardado.asm -o guardado.o;
nasm -f elf64 cargar.asm -o cargar.o
nasm -f elf64 transformar_coordenadas.asm -o transformar_coordenadas.o
ld main.o input.o validacion_movimiento.o ejecucion_movimiento.o funciones_auxiliares.o transformar_coordenadas.o turno.o tablero.o imprimir.o constantes.o datos.o transformaciones.o contar_jugadores.o menu.o guardado.o cargar.o -o juego -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2