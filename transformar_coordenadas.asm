;Transforma coordenadas (i,j) rotandolas X grados, y transforma coordenadas (i,j) rotadas X grados a coordenadas en 0 grados.
%include "constantes.asm"
extern inicio_fila
extern inicio_col
extern rotacion_tablero
extern fin_col
extern fin_fila

global enderezar_coordenadas

enderezar_coordenadas:
    ;FILA, COLUMNA, ROTACION(0,90,180,270)
    
    
    movzx r8, byte[inicio_fila];FILA
    movzx r9, byte[inicio_col];COLUMNA
    movzx r10, word[rotacion_tablero]
    
    movzx r11, byte[fin_fila];FILA
    movzx r12, byte[fin_col];COLUMNA
    
    
    
    cmp r10, 90
    je rotar270

    cmp r10, 180
    je rotar180

    cmp r10, 270
    je rotar90
    
finalizar:
    
    mov [inicio_fila], r8b
    mov [inicio_col], r9b
    mov [fin_fila], r11b
    mov [fin_col], r12b

    mov rax, rcx
    ret


rotar90:
    mov rax, r9
    mov r8, r9
    mov r9, 6
    sub r9, rax
    
    mov rax, r12
    mov r11, r12
    mov r12, 6
    sub r12, rax
    jmp finalizar

rotar180:
    mov rax, r9
    mov r9, 6
    sub r9, rax
    mov rax, r8
    mov r8, 6
    sub r8, rax
    
    mov rax, r12
    mov r12, 6
    sub r12, rax
    mov rax, r11
    mov r11, 6
    sub r11, rax
    jmp finalizar 

rotar270:
    mov rax, r9
    mov r9, r8
    mov r8, 6
    sub r8, rax
    
    mov rax, r12
    mov r12, r11
    mov r11, 6
    sub r11, rax
    jmp finalizar
