;funciones para validar movimientos

%include "constantes.asm"

extern tablero
extern turno_actual
extern inicio_fila, inicio_col, fin_fila, fin_col
extern puts
extern SOLDADO
extern OFICIAL
extern puts

global validar_movimiento

section .data
    formato_error_movimiento_invalido db 'Movimiento inválido. Intente nuevamente.', 10, 0
    formato_error_ficha_incorrecta db 'No hay una ficha válida en la posición de inicio.', 10, 0
    formato_error_posicion db 'La posición seleccionada es una pared. Intente nuevamente.', 10, 0
    formato_error_destino_ocupado db 'La posición de destino está ocupada. Intente nuevamente.', 10, 0
    print db 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',0

section .text

extern calcular_indice
extern obtener_pieza_inicio
extern obtener_pieza_fin

; Devuelve 1 en AL si es válido, 0 si no
validar_movimiento:
    push rbx
    push r12
    push rdx
    push rcx
    push r8
    push r9
    push r10
    push r11

    ; verificar que la posición de inicio no sea una pared
    call obtener_pieza_inicio
    cmp al, PARED
    je movimiento_invalido_posicion

    ; verificar que la ficha en inicio corresponde al turno actual
    mov dl, [turno_actual]
    cmp dl, 'S'
    je verificar_soldado
    cmp dl, 'O'
    je verificar_oficial

verificar_soldado:
    cmp al, [SOLDADO]
    je verificar_destino
    lea rdi, [rel formato_error_ficha_incorrecta]
    xor rax, rax
    call puts
    jmp retornar_falso

verificar_oficial:
    cmp al, [OFICIAL]
    je verificar_destino
    lea rdi, [rel formato_error_ficha_incorrecta]
    xor rax, rax
    call puts
    jmp retornar_falso

; verificar que la posición de destino no sea una pared y esté vacía
verificar_destino:
    call obtener_pieza_fin
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
    mov     rdi,SOLDADO
    call puts
    ; Si turno_actual no es 'S' ni 'O', invalidar
    jmp movimiento_invalido

; función de validación para soldados
; función de validación para soldados
validar_movimiento_soldado:
    ; calculo diferencia de filas y columnas
    movzx rax, byte [fin_fila]      ; rax = fila fin 
    movzx rcx, byte [inicio_fila]   ; rcx = inicio fila
    sub rax, rcx                    ; rax = fila fin - inicio fila
    movsx r8d, al                   ; r8d = diferencia de filas

    movzx rbx, byte [fin_col]       ; rbx = col fin
    movzx rdx, byte [inicio_col]    ; rdx = col inicio (0-6)
    sub rbx, rdx                    ; rbx = fin col - col inicio
    movsx r9d, bl                   ; r9d = diferencia de columnas

    ; verificar si el soldado está en posición especial (fila 4, col 0,1,5,6)
    movzx eax, byte [inicio_fila]
    cmp eax, 4
    jne verificar_movimiento_normal  ; si no está en fila 4, verificar movimiento normal

    movzx ebx, byte [inicio_col]
    cmp ebx, 0
    je verificar_movimiento_lateral
    cmp ebx, 1
    je verificar_movimiento_lateral
    cmp ebx, 5
    je verificar_movimiento_lateral
    cmp ebx, 6
    je verificar_movimiento_lateral
    ; si no está en columnas 0,1,5,6, verificar movimiento normal
    jmp verificar_movimiento_normal

verificar_movimiento_lateral:
    ; r8d = diferencia de filas
    ; r9d = diferencia de columnas
    cmp r8d, 0
    jne movimiento_invalido  ; debe ser movimiento lateral (sin cambio en filas)

    ; determinar si está a la izq o der comparando con medio
    movzx eax, byte [inicio_col]
    cmp eax, 3
    jl movimiento_lateral_derecha
    jg movimiento_lateral_izquierda

movimiento_lateral_derecha:
    ; desde columnas 0 y 1, movimiento hacia derecha (diferencia de cols = 1)
    cmp r9d, 1
    je movimiento_valido
    jmp movimiento_invalido

movimiento_lateral_izquierda:
    ; desde columnas 5 y 6, movimiento hacia izquierda (diferencia de cols = -1)
    cmp r9d, -1
    je movimiento_valido
    jmp movimiento_invalido

verificar_movimiento_normal:
    ; los soldados deben avanzar una fila hacia adelante (r8d = 1)
    cmp r8d, 1
    jne movimiento_invalido

    ; pueden moverse en línea recta o diagonal (r9d = -1, 0, 1)
    cmp r9d, -1
    je movimiento_valido
    cmp r9d, 0
    je movimiento_valido
    cmp r9d, 1
    je movimiento_valido

    ; si no caemos en los jumps anteriores, es inválido
    jmp movimiento_invalido

; función de validación para Oficiales
validar_movimiento_oficial:
    ; calcula la diferencia de filas y columnas
    ; lo mismo de arriba con los soldados
    movzx rax, byte [fin_fila]
    movzx rcx, byte [inicio_fila]
    sub rax, rcx                   
    movsx r8d, al                   

    movzx rbx, byte [fin_col]
    movzx rdx, byte [inicio_col]
    sub rbx, rdx                    
    movsx r9d, bl                  

    ; valores absolutos de diferencias de filas y columnas
    mov r10d, r8d                   ; r10d = dif fila
    mov r11d, r9d                   ; r11d = dif columnas

    test r10d, r10d
    jge calcular_abs_fila_simple
    neg r10d                         ; r10d = abs(dif fila)
calcular_abs_fila_simple:
    test r11d, r11d
    jge calcular_abs_col_simple
    neg r11d                         ; r11d = abs(dif columnas)
calcular_abs_col_simple:
    ; Verificar si es movimiento de una sola casilla
    cmp r10d, 1
    jg verificar_captura
    cmp r11d, 1
    jg verificar_captura

    ; Si ambos <=1, entonces es un movimiento de una casilla
    ; verificar que no es movimiento nulo
    cmp r10d, 0
    jne movimiento_valido
    cmp r11d, 0
    jne movimiento_valido
    ; si ambos son cero, movimiento inválido
    jmp movimiento_invalido

verificar_captura:
    ;revisar si es un movimiento de captura
    ;deberia cumplir con una de las condiciones de captura:
    ; 1- abs(diferencia fila) ==2 y abs(diferencia columna) ==0
    ; 2-  abs(diferencia fila) ==0 y abs(diferencia columna) ==2
    ; 3- abs(diferencia fila) ==2 y abs(diferencia columna) ==2

    ; 1: abs(diferencia fila) ==2 y abs(diferencia columna) ==0
    cmp r10d, 2
    jne verificar_condicion_horizontal
    cmp r11d, 0
    je realizar_captura
    ; Si abs(diferencia columna) != 0, verificar captura horizontal
    jmp verificar_condicion_horizontal

verificar_condicion_horizontal:
    ;2: abs(diferencia fila) == 0 y abs(diferencia columna) ==2
    cmp r10d, 0
    jne verificar_condicion_diagonal
    cmp r11d, 2
    je realizar_captura
    jmp verificar_condicion_diagonal

verificar_condicion_diagonal:
    ; 3: abs(diferencia fila) == 2 y abs(diferencia columna) ==2  
    cmp r10d, 2
    jne movimiento_invalido
    cmp r11d, 2
    je realizar_captura

    jmp movimiento_invalido

realizar_captura:
    ; esta funcion es muy parecida a la de ejecutar_movimientos, pero son distintas.
    ; Esta se fija que haya un soldado en el medio para permitir el movimiento
    ; La otra simplemente lo asume como correcto y lo hace
    ; es repetitivo, si. 
    ; pero me pareció mas entendible tambien
    movzx rdi, byte [inicio_fila]    
    movzx rax, byte [fin_fila]       
    add rdi, rax                    
    shr rdi, 1                       

    movzx rsi, byte [inicio_col]     
    movzx rax, byte [fin_col]        
    add rsi, rax                      
    shr rsi, 1                       

    call calcular_indice               ; calcula el índice de [fila][col]

    mov al, [tablero + rax]            ;agarra la pieza en la posición intermedia
    cmp al, [SOLDADO]                    ;verifica si es un soldado
    jne movimiento_invalido            ;si no es un soldado, es inválido

    jmp movimiento_valido

; movimiento válido
movimiento_valido:
    mov al, 1
    jmp fin_validar_movimiento

movimiento_invalido_posicion:
    lea rdi, [rel formato_error_posicion]
    xor rax, rax
    call puts
    jmp retornar_falso

movimiento_invalido_destino_ocupado:
    lea rdi, [rel formato_error_destino_ocupado]
    xor rax, rax
    call puts
    jmp retornar_falso

movimiento_invalido:
    lea rdi, [rel formato_error_movimiento_invalido]
    xor rax, rax
    call puts

retornar_falso:
    mov al, 0

fin_validar_movimiento:
    pop r11
    pop r10
    pop r9
    pop r8
    pop rcx
    pop rdx
    pop r12
    pop rbx
    ret
