%include "constantes.asm"

section .data
    ;formatos para printf
    formato_numero    db ' %i  ', 0
    formato_caracter  db ' %c  ', 0

    ;mensajes
    menu_prompt       db 'Por favor, elija una opción (A, B, C, o D): ', 0
    invalid_option    db 'Opción inválida.', 10, 0
    encabezado_x      db '    0  1  2  3  4  5  6   x', 10, 0
    encabezado_y      db 'y', 10, 0
    salto_linea       db 10, 0

section .bss
    ;espacio para el tablero (7x7)
    tablero resb ALTO * ANCHO
    ;espacio para almacenar la opción del usuario
    user_option resb 1
    ; matriz auxiliar para las transformaciones
    aux resb ALTO * ANCHO

;variables globales
global tablero
global aux
global formato_numero, formato_caracter
global menu_prompt, invalid_option, encabezado_x, encabezado_y, salto_linea
global user_option
