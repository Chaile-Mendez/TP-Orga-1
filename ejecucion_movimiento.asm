; funciones para ejecutar movimientos

%include "constantes.asm"

extern tablero
extern inicio_fila, inicio_col, fin_fila, fin_col
extern turno_actual
extern OFICIAL
extern bool_captura
extern datos_oficial1, datos_oficial2
global ejecutar_movimiento

section .text
extern calcular_indice

ejecutar_movimiento:
    push r12
    push rbx
    push rdi
    push rsi
    push rax
    push rcx
    push rdx

    ;obtener posiciones de inicio
    movzx rdi, byte [inicio_fila]
    movzx rsi, byte [inicio_col]
    call calcular_indice
    mov rbx, rax 

    ;obtener posiciones de fin
    movzx rdi, byte [fin_fila]
    movzx rsi, byte [fin_col]
    call calcular_indice
    mov r12, rax

    ;obtener la pieza de inicio
    mov al, [tablero + rbx]
    ;moverla al destino
    mov [tablero + r12], al
    ;dejar vacio el inicio
    mov byte [tablero + rbx], VACIO

    ;si es un oficial, verificar si se debe capturar una pieza
    cmp al, [OFICIAL]
    jne fin_mov

    ;actualizo datos de oficial si se trata de uno
actualizar_oficiales:
    mov al,[inicio_fila]
    mov ah,[inicio_col]
    mov cl,[fin_fila]
    mov ch,[fin_col]
    cmp ax,word[datos_oficial1]
    je actualizar_oficial1
    mov word[datos_oficial2],cx
    jmp calcular_diferencias
actualizar_oficial1:
    mov word[datos_oficial1],cx


calcular_diferencias:
    ;calcular la diferencia de filas y columnas con signos
    movzx rax, byte [fin_fila]
    movzx rcx, byte [inicio_fila]
    sub rax, rcx
    movsx r8, al    ; r8d = diferencia de filas

    movzx rbx, byte [fin_col]
    movzx rdx, byte [inicio_col]
    sub rbx, rdx
    movsx r9, bl    ; r9d = diferencia de columnas

    ;calcular los valores absolutos de "diferencia fila" y "diferencia columna"
    mov r10, r8
    mov r11, r9

    test r10, r10 ;hace and bit a bit y setea zero flag o sign flag
    jge fin_calculo_abs_fila 
    neg r10 ;calcula complemento a 2 y lo guarda en el mismo
fin_calculo_abs_fila:
    test r11, r11
    jge fin_calculo_abs_col
    neg r11

fin_calculo_abs_col:
    ;revisar si es un movimiento de captura
    ;deberia cumplir con una de las condiciones de captura:
    ; 1- abs(diferencia fila) ==2 y abs(diferencia columna) ==0
    ; 2-  abs(diferencia fila) ==0 y abs(diferencia columna) ==2
    ; 3- abs(diferencia fila) ==2 y abs(diferencia columna) ==2

    ;1: abs(diferencia fila) ==2 y abs(diferencia columna) ==0
    cmp r10, 2
    jne verificar_condicion_2
    cmp r11, 0
    je realizar_captura
    jmp verificar_condicion_2

verificar_condicion_2:
    ;2: abs(diferencia fila) == 0 y abs(diferencia columna) ==2
    cmp r10, 0
    jne verificar_condicion_3
    cmp r11, 2
    je realizar_captura
    jmp verificar_condicion_3

verificar_condicion_3:
    ;3: abs(diferencia fila) == 2 y abs(diferencia columna) ==2
    cmp r10, 2
    jne fin_mov
    cmp r11, 2
    je realizar_captura

    jmp fin_mov

realizar_captura:
    ;calcular la posición del medio
    movzx rdi, byte [inicio_fila]
    movzx rax, byte [fin_fila]
    add rdi, rax
    shr rdi, 1                      ; med fila = (inicio fila + fin fila) / 2

    movzx rsi, byte [inicio_col]
    movzx rax, byte [fin_col]
    add rsi, rax
    shr rsi, 1                      ; med col = (inicio col + fin col) / 2

    call calcular_indice
    ; eliminar la pieza capturada
    mov byte [tablero + rax], VACIO
    mov byte[bool_captura], 1

    jmp fin_mov


fin_mov:
    pop rdx
    pop rcx
    pop rax
    pop rsi
    pop rdi
    pop rbx
    pop r12
    ret
