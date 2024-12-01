;funciones auxiliares utilizadas en otros módulos

%include "constantes.asm"

extern tablero
extern inicio_fila, inicio_col, fin_fila, fin_col

global calcular_indice
global obtener_pieza_inicio
global obtener_pieza_fin

section .text

; entrada:
;   rdi: fila
;   rsi: columna
;   salida:
;   rax: índice lineal en el tablero
calcular_indice:
    mov rax, rdi        ; rax = fila
    imul rax, ANCHO     ; rax = fila * ancho
    add rax, rsi        ; rax = fila * ancho + columna
    ret

; retorna en AL la pieza en la posición de inicio
obtener_pieza_inicio:
    movzx rdi, byte [inicio_fila]
    movzx rsi, byte [inicio_col]
    call calcular_indice
    mov al, [tablero + rax]
    ret

;retorna en AL la pieza en la posición de fin
obtener_pieza_fin:
    movzx rdi, byte [fin_fila]
    movzx rsi, byte [fin_col]
    call calcular_indice
    mov al, [tablero + rax]
    ret
