; Archivo: imprimir.asm
; Descripción: Contiene la función para imprimir el tablero

%include "constantes.asm"

global imprimir_tablero
extern tablero
extern formato_numero, formato_caracter
extern encabezado_x, encabezado_y, salto_linea
extern printf, puts

section .text

imprimir_tablero:
    push rbx
    push r12

    ; Imprimir encabezado x
    lea rdi, [rel encabezado_x]
    xor rax, rax
    call puts

    ; Imprimir filas
    xor rbx, rbx      ; rbx = i = 0
imprimir_filas:
    cmp rbx, ALTO
    jge fin_imprimir_filas

    ; imprimir número de fila
    ; Formato: "%i  "
    mov rsi, rbx        ; Segundo argumento: número de fila
    lea rdi, [rel formato_numero]    ; Primer argumento: formato
    xor rax, rax
    call printf

    ; Imprimir columnas
    xor r12, r12      ; r12 = j = 0
imprimir_columnas:
    cmp r12, ANCHO
    jge fin_imprimir_columnas

    ; Calcular índice
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; Obtener carácter del tablero
    mov al, [tablero + rax]

    ; Imprimir carácter
    movzx rsi, al       ; Extiende al a rsi (segundo argumento)
    lea rdi, [rel formato_caracter]  ; Primer argumento: formato
    xor rax, rax
    call printf

    inc r12
    jmp imprimir_columnas

fin_imprimir_columnas:
    ; Salto de línea
    lea rdi, [rel salto_linea]
    xor rax, rax
    call puts

    inc rbx
    jmp imprimir_filas

fin_imprimir_filas:

    ; Imprimir encabezado y
    lea rdi, [rel encabezado_y]
    xor rax, rax
    call puts

    ; Restaurar registros no volátiles
    pop r12
    pop rbx
    ret
