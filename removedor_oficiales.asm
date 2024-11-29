;chequea si hace falta remover oficiales por no comer soldados

%include "constantes.asm"

global remover_oficiales
extern datos_oficial1, datos_oficial2
extern calcular_indice
extern tablero
extern juego_loop
extern fin_col, fin_fila
extern inicio_col, inicio_fila
extern SOLDADO


section .data
    mensaje_oficial_removido db 'Un oficial fue removido por no cumplir con su deber', 0


section .bss
    oficial_actual  resw 1
    otro_oficial    resw 1

section .text

remover_oficiales:

definir_oficial:
;defino r8 para luego usar en buscar soldados
    mov r8,1
    mov al,[fin_fila]
    mov ah,[fin_col]
    mov cl,[inicio_fila]
    mov ch,[inicio_col]
    mov r9w,[datos_oficial1]
    mov r10w,[datos_oficial2]
    cmp ax,word[datos_oficial1]
    je elegir_oficial1
    cmp ax,word[datos_oficial2]
    je elegir_oficial2
    jmp no_remover_oficiales


elegir_oficial2:
    mov word[oficial_actual],cx
    mov word[otro_oficial],r9w
    jmp buscar_soldados_adyacentes


elegir_oficial1:
    mov word[oficial_actual],cx
    mov word[otro_oficial],r10w

buscar_soldados_adyacentes:
    mov rcx,3

loop_buscar_soldados:
    movzx rsi,byte[oficial_actual + 1]
    add rsi,rcx
    sub rsi,2
    movzx rdi,byte[oficial_actual]
    add rdi,r8
;rsi columna actual y rdi fila actual
    call calcular_indice
    mov r9b,[tablero + rax]
    cmp r9b,[SOLDADO]
    je comprobar_captura

fin_loop_buscar_soldados:
    loop loop_buscar_soldados
    sub r8,1
    cmp r8,-2
    jne buscar_soldados_adyacentes

buscar_otro_oficial:
    mov r11b,-1

    cmp byte[otro_oficial],r11b
    je no_remover_oficiales

    mov r9w,[otro_oficial]
    cmp word[oficial_actual],r9w
    je no_remover_oficiales

    mov word[oficial_actual],r9w
    mov r8,1

    jmp buscar_soldados_adyacentes

comprobar_captura:
    add rsi,rcx
    sub rsi,2
    add rdi,r8
    call calcular_indice
    mov r9b,[tablero + rax]
    cmp r9b,VACIO
    je remover_oficial
    jmp fin_loop_buscar_soldados

remover_oficial:
    mov r9w,[oficial_actual]
    cmp r9w,[otro_oficial]
    jne remover_posicion_final
    movzx rsi,byte[oficial_actual + 1]
    movzx rdi,byte[oficial_actual]
    call calcular_indice
    mov byte [tablero + rax], VACIO
    jmp remover_del_tablero

remover_posicion_final:
    movzx rsi,byte[fin_col]
    movzx rdi,byte[fin_fila]
    call calcular_indice
    mov byte [tablero + rax], VACIO

remover_del_tablero:
    mov byte [tablero + rax], VACIO
    mov r11b,-1
    mov r9w,[oficial_actual]
    cmp r9w,[datos_oficial1]
    je  limpiar_oficial1
    mov byte[datos_oficial2],r11b
    mov byte[datos_oficial2 + 1],r11b
    jmp no_remover_oficiales

limpiar_oficial1:
    mov byte[datos_oficial1],r11b
    mov byte[datos_oficial1 + 1],r11b

no_remover_oficiales:
    jmp juego_loop
