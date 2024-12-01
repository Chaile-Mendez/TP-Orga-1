%include "constantes.asm"

section .data
    ; formatos para printf
    formato_numero    db ' %i  ', 0
    formato_caracter  db ' %c  ', 0

    menu_prompt       db 'Por favor, elija una opción (A, B, C, o D): ', 0
    invalid_option    db 'Opción inválida.', 10, 0
    encabezado_x      db '     0   1   2   3   4   5   6   x', 10, 0
    encabezado_y      db 'y', 10, 0
    salto_linea       db 10, 0

    OFICIAL db DEFAULT_OFICIAL
    SOLDADO db DEFAULT_SOLDADO

    rotacion_tablero db 0

    mensaje_pos_inicio_fila   db 'Ingrese la fila de inicio (0-6) o g para guardar la partida: ', 0
    mensaje_pos_inicio_col    db 'Ingrese la columna de inicio (0-6): ', 0
    mensaje_pos_fin_fila      db 'Ingrese la fila de destino (0-6): ', 0
    mensaje_pos_fin_col       db 'Ingrese la columna de destino (0-6): ', 0
    invalid_posicion          db 'Posición inválida. Intente nuevamente.', 10, 0

    formato_error_movimiento_invalido db 'Movimiento inválido. Intente nuevamente.', 10, 0
    formato_error_ficha_incorrecta db 'No hay una ficha válida en la posición de inicio.', 10, 0
    formato_error_posicion db 'La posición seleccionada es una pared. Intente nuevamente.', 10, 0
    formato_error_destino_ocupado db 'La posición de destino no está vacía. Intente nuevamente.', 10, 0

    mensaje_turno_soldados    db 'Es tu turno de mover un Soldado.', 10, 0
    mensaje_turno_oficiales    db 'Es tu turno de mover un Oficial.', 10, 0

    mensaje_fin_juego db '¡Felicidades! Has ganado el juego.', 10, 0

    mensaje_contar_fichas db "Oficiales: %i, Soldados: %i",10,0

    nombre_archivo  db 'partida_guardada.txt',0

    ;booleano 0 para no se capturoen el turno 1 para si se capturo en el turno
    bool_captura    db 0

section .bss
    ; espacio del tablero (7x7)
    tablero resb ALTO * ANCHO
    ; espacio para almacenar la opción del usuario
    user_option resb 1
    ; matriz auxiliar para las transformaciones
    aux resb ALTO * ANCHO

    ; variables para input.asm
    inicio_fila resb 1         ; fila de inicio
    inicio_col resb 1          ; columna de inicio
    fin_fila resb 1            ; fila de fin
    fin_col resb 1             ; columna de fin

    turno_actual resb 1         ; 'S' para Soldados, 'O' par    a Oficiales

    cantidad_soldados resb 1
    cantidad_oficiales resb 1

    id_archivo  resq 1

    ;variables para seguir a cada oficial, la primera word son la posicion en F y C
    ;los siguientes 8 words son para los movimientos en el siguiente orden:
    ;NO, N, NE, O, CENTRO, E, SO, S, SE
    ;y la ultima word es para las capturas
    datos_oficial1 times 11 resw 1
    datos_oficial2 times 11 resw 1

;variables globales
global tablero
global aux
global formato_numero, formato_caracter
global menu_prompt, invalid_option, encabezado_x, encabezado_y, salto_linea
global user_option
global cantidad_oficiales
global cantidad_soldados
global rotacion_tablero
global OFICIAL
global SOLDADO


;varibales globales para contar_jugadores.asm
global mensaje_contar_fichas

;variables globales para input.asm
global inicio_fila, inicio_col
global fin_fila, fin_col
global mensaje_pos_inicio_fila, mensaje_pos_inicio_col
global mensaje_pos_fin_fila, mensaje_pos_fin_col
global invalid_posicion

;variables globales para movimiento.asm
global formato_error_movimiento_invalido
global formato_error_ficha_incorrecta
global formato_error_posicion
global formato_error_destino_ocupado

;variables globales para turno.asm
global mensaje_turno_soldados, mensaje_turno_oficiales

;variable global para turno_actual
global turno_actual

;variable global para mensaje_fin_juego
global mensaje_fin_juego

;variables globales para guardar y cargar
global id_archivo
global nombre_archivo

global datos_oficial1
global datos_oficial2

global bool_captura