; funciones para validar y ejecutar movimientos

%include "constantes.asm"

extern tablero
extern turno_actual
extern inicio_fila, inicio_col, fin_fila, fin_col
extern puts, printf

global validar_movimiento
global ejecutar_movimiento

section .data
    formato_error_movimiento_invalido db 'Movimiento inválido. Intente nuevamente.', 10, 0
    formato_error_ficha_incorrecta db 'No hay una ficha válida en la posición de inicio.', 10, 0
    formato_error_posicion db 'La posición seleccionada es una pared. Intente nuevamente.', 10, 0
    formato_error_destino_ocupado db 'La posición de destino está ocupada. Intente nuevamente.', 10, 0

section .text

; retorna en AL: 1 si es valido, 0 si es invalido
validar_movimiento:
    push rbx
    push r12
    push rdx
    push rcx

    call obtener_pieza_inicio ;deja en AL la pieza de incio

    ; verificar que la posición de inicio no sea una pared
    cmp al, PARED
    je movimiento_invalido_posicion

    ; verificar que la ficha en inicio corresponde al turno actual
    mov dl, [turno_actual]
    cmp dl, 'S'
    je verificar_soldado
    cmp dl, 'O'
    je verificar_oficial

verificar_soldado:
    cmp al, SOLDADO
    je verificar_destino
    ; si no es soldado, error
    lea rdi, [rel formato_error_ficha_incorrecta]
    xor rax, rax
    call puts
    jmp retornar_false

verificar_oficial:
    cmp al, OFICIAL
    je verificar_destino
    ; si no es oficial, error
    lea rdi, [rel formato_error_ficha_incorrecta]
    xor rax, rax
    call puts
    jmp retornar_false

; verificar que la posición de destino no sea una pared y esté vacía
verificar_destino:
    call obtener_pieza_fin ;la guarda en AL
    cmp al, PARED
    je movimiento_invalido_posicion

    cmp al, VACIO
    jne movimiento_invalido_destino_ocupado

    ; verificar que el movimiento es válido según el tipo de ficha
    mov dl, [turno_actual]
    cmp dl, 'S'
    je validar_movimiento_soldado
    cmp dl, 'O'
    je validar_movimiento_oficial

    ; si turno_actual no es 'S' ni 'O', invalidar. no se, por las dudas
    jmp movimiento_invalido

validar_movimiento_soldado:
    ; calcula la diferencia de filas y columnas
    movzx rax, byte [fin_fila]      ; rax = fin_fila (0-6)
    movzx rcx, byte [inicio_fila]   ; rcx = inicio_fila (0-6)
    sub rax, rcx                    ; rax = fin_fila - inicio_fila

    movzx rbx, byte [fin_col]       ; rbx = fin_col (0-6)
    movzx rdx, byte [inicio_col]    ; rdx = inicio_col (0-6)
    sub rbx, rdx                    ; rbx = fin_col - inicio_col

    ; convertir rbx a entero con signo
    movsx rbx, bl                   ; extiende el byte con signo a rbx

    ; los soldados deben avanzar una fila hacia adelante (rax = 1)
    cmp rax, 1
    jne movimiento_invalido

    ; pueden moverse en línea recta o diagonal (rbx = -1, 0, 1)
    cmp rbx, -1
    je movimiento_valido
    cmp rbx, 0
    je movimiento_valido
    cmp rbx, 1
    je movimiento_valido

    ; si no caimos en los jumps anteriores, es pq es invalido
    jmp movimiento_invalido

validar_movimiento_oficial:
    ; calcula la diferencia de filas y columnas
    movzx rax, byte [fin_fila]      ; rax = fin_fila (0-6)
    movzx rcx, byte [inicio_fila]   ; rcx = inicio_fila (0-6)
    sub rax, rcx                    ; rax = fin_fila - inicio_fila
    movsx rax, al                   ; extender el resultado con signo

    movzx rbx, byte [fin_col]       ; rbx = fin_col (0-6)
    movzx rdx, byte [inicio_col]    ; rdx = inicio_col (0-6)
    sub rbx, rdx                    ; rbx = fin_col - inicio_col
    movsx rbx, bl                   ; extender el resultado con signo

    ; los oficiales pueden moverse una casilla en cualquier dirección
    cmp rax, 1
    jg movimiento_invalido
    cmp rax, -1
    jl movimiento_invalido

    cmp rbx, 1
    jg movimiento_invalido
    cmp rbx, -1
    jl movimiento_invalido

    ; movimiento válido
    jmp movimiento_valido

movimiento_valido:
    mov al, 1
    jmp fin_validar_movimiento

movimiento_invalido_posicion:
    lea rdi, [rel formato_error_posicion]
    xor rax, rax
    call puts
    jmp retornar_false

movimiento_invalido_destino_ocupado:
    lea rdi, [rel formato_error_destino_ocupado]
    xor rax, rax
    call puts
    jmp retornar_false

movimiento_invalido:
    lea rdi, [rel formato_error_movimiento_invalido]
    xor rax, rax
    call puts

retornar_false:
    mov al, 0

fin_validar_movimiento:
    pop rcx
    pop rdx
    pop r12
    pop rbx
    ret

; se asume que el movimiento fue validado
; mueve la pieza de (inicio_fila, inicio_col) a (fin_fila, fin_col)
; También maneja la captura si es un oficial moviendo sobre un soldado
ejecutar_movimiento:
    push r12

    ; Obtener el índice lineal de inicio
    movzx rdi, byte [inicio_fila]
    movzx rsi, byte [inicio_col]
    call calcular_indice
    mov rbx, rax  ; índice inicio

    ; Obtener el índice lineal de fin
    movzx rdi, byte [fin_fila]
    movzx rsi, byte [fin_col]
    call calcular_indice
    mov r12, rax  ; índice fin

    ; Obtener la pieza en inicio
    mov al, [tablero + rbx]
    ; Mover la pieza al destino
    mov [tablero + r12], al
    ; Vaciar la posición de inicio
    mov byte [tablero + rbx], VACIO

    ; Si es un Oficial, verificar si se debe capturar una pieza
    cmp al, OFICIAL
    jne no_captura

    ; Calcular la diferencia de filas y columnas
    movzx rdi, byte [fin_fila]
    movzx rsi, byte [inicio_fila]
    sub rdi, rsi    ; fila_diff = fin_fila - inicio_fila

    movzx rdx, byte [fin_col]
    movzx rcx, byte [inicio_col]
    sub rdx, rcx    ; col_diff = fin_col - inicio_col

    ; Verificar si el movimiento es mayor a una casilla
    ; Actualmente, solo permitimos movimientos de una casilla, así que no realizamos capturas
    ; Si en el futuro se permiten saltos, aquí se puede agregar la lógica de captura
    ; Ejemplo de condición para capturar:
    ; cmp rdi, 1
    ; jg realizar_captura
    ; cmp rdi, -1
    ; jl realizar_captura
    ; cmp rdx, 1
    ; jg realizar_captura
    ; cmp rdx, -1
    ; jl realizar_captura
    ; jmp no_captura

    ; Como actualmente solo permitimos movimientos de una casilla, saltamos la captura
    jmp no_captura

    ; Label para realizar la captura (futuro)
    ; realizar_captura:
    ;     ; Calcular la posición intermedia
    ;     movzx rdi, byte [inicio_fila]
    ;     add rdi, byte [fin_fila]
    ;     shr rdi, 1                ; mid_fila = (inicio_fila + fin_fila) / 2

    ;     movzx rsi, byte [inicio_col]
    ;     add rsi, byte [fin_col]
    ;     shr rsi, 1                ; mid_col = (inicio_col + fin_col) / 2

    ;     ; Obtener el índice de la posición intermedia
    ;     call calcular_indice
    ;     ; Eliminar la pieza capturada
    ;     mov byte [tablero + rax], VACIO

    ;     jmp no_captura

no_captura:
    ; Restaurar registros
    pop r12
    ret


; Entrada:
;   rdi: fila
;   rsi: columna
; Salida:
;   rax: índice lineal en el tablero
calcular_indice:
    mov rax, rdi        ; rax = fila
    imul rax, ANCHO     ; rax = fila * ancho
    add rax, rsi        ; rax = fila * ancho + columna
    ret


; devuelve en AL la pieza en la posición de inicio
obtener_pieza_inicio:
    movzx rdi, byte [inicio_fila]
    movzx rsi, byte [inicio_col]
    call calcular_indice
    mov al, [tablero + rax]
    ret


; devuelve en AL la pieza en la posición de fin
obtener_pieza_fin:
    movzx rdi, byte [fin_fila]
    movzx rsi, byte [fin_col]
    call calcular_indice
    mov al, [tablero + rax]
    ret
