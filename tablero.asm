; función para inicializar el tablero

%include "constantes.asm"

global inicializar_tablero
extern tablero

section .text

inicializar_tablero:
    ; preservar registros !!!!
    push rbx
    push r12

    ; llenar todo con paredes
    mov rcx, 0                 
llenar_paredes:
    ; llenamos todo con paredes
    cmp rcx, ALTO * ANCHO
    jge fin_llenar_paredes

    mov byte [tablero + rcx], PARED   ; tablero[rcx] = pared
    inc rcx
    jmp llenar_paredes

fin_llenar_paredes:

    ; ahora llenamos con soldados y oficiales

    ; llenar soldados en la parte superior central
    mov rbx, 0      ; rbx = fila i = 0
cargar_soldados_superior:
    cmp rbx, 4
    jge fin_cargar_soldados_superior

    mov r12, 2      ; r12 = columna j = 2
cargar_soldados_superior_col:
    cmp r12, 5
    jge fin_cargar_soldados_superior_col

    ; calculo índice lineal: index = i * ANCHO + j
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; asignar soldado
    mov byte [tablero + rax], SOLDADO

    inc r12
    jmp cargar_soldados_superior_col

fin_cargar_soldados_superior_col:
    inc rbx
    jmp cargar_soldados_superior

fin_cargar_soldados_superior:

    ; llenar soldados en los laterales
    ; izquierda
    mov rbx, 2      ; rbx = fila i = 2
cargar_soldados_izquierda:
    cmp rbx, 5
    jge fin_cargar_soldados_izquierda

    mov r12, 0      ; r12 = columna j = 0
cargar_soldados_izquierda_col:
    cmp r12, 2
    jge fin_cargar_soldados_izquierda_col

    ; Calcular índice lineal
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; Asignar soldado
    mov byte [tablero + rax], SOLDADO

    inc r12
    jmp cargar_soldados_izquierda_col

fin_cargar_soldados_izquierda_col:
    inc rbx
    jmp cargar_soldados_izquierda

fin_cargar_soldados_izquierda:

    ; Derecha
    mov rbx, 2      ; rbx = fila i = 2
cargar_soldados_derecha:
    cmp rbx, 5
    jge fin_cargar_soldados_derecha

    mov r12, 5      ; r12 = columna j = 5
cargar_soldados_derecha_col:
    cmp r12, 7
    jge fin_cargar_soldados_derecha_col

    ; Calcular índice
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; Asignar soldado
    mov byte [tablero + rax], SOLDADO

    inc r12
    jmp cargar_soldados_derecha_col

fin_cargar_soldados_derecha_col:
    inc rbx
    jmp cargar_soldados_derecha

fin_cargar_soldados_derecha:

    ; Llenar vacíos en la parte inferior central
    mov rbx, 4      ; fila i = 4
cargar_vacios_inferior:
    cmp rbx, 7
    jge fin_cargar_vacios_inferior

    mov r12, 2      ; columna j = 2
cargar_vacios_inferior_col:
    cmp r12, 5
    jge fin_cargar_vacios_inferior_col

    ; Calcular índice lineal
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; Asignar vacío
    mov byte [tablero + rax], VACIO

    inc r12
    jmp cargar_vacios_inferior_col

fin_cargar_vacios_inferior_col:
    inc rbx
    jmp cargar_vacios_inferior

fin_cargar_vacios_inferior:

    ; colocar oficiales. Esto tal vez podría hacerse algo random. la consigna no dice nada
    ; Oficial en (5,4)
    mov rax, 5
    imul rax, ANCHO
    add rax, 4
    mov byte [tablero + rax], OFICIAL

    ; Oficial en (6,2)
    mov rax, 6
    imul rax, ANCHO
    add rax, 2
    mov byte [tablero + rax], OFICIAL

    ; recuperar registros 
    pop r12
    pop rbx

    ret

    
