; maneja el flujo del programa

%include "constantes.asm"

global main
global juego_loop
extern printf, getchar, puts
extern inicializar_tablero, transponer, espejoX, imprimir_tablero
extern tablero, user_option
extern formato_numero, formato_caracter
extern menu_prompt, invalid_option, encabezado_x, encabezado_y, salto_linea, mensaje_fin_juego
extern leer_movimiento  
extern turno_actual      
extern switch_turno       
extern validar_movimiento 
extern ejecutar_movimiento
extern contar_jugadores
extern menu
extern bool_captura
extern remover_oficiales


section .text

main:
    push rbx
    push r12        

    call menu

    call inicializar_tablero

    ; inicializo el turno en Soldados
    mov byte [turno_actual], 'S'   

    ; iniciar el bucle del juego
    call juego_loop

    pop r12
    pop rbx

    ; fin
    mov rax, 60     ; syscall: exit
    xor rdi, rdi    ; estado de salida 0
    syscall

; bucle del juego
juego_loop:
    mov byte[bool_captura],0
    call imprimir_tablero
    call contar_jugadores
    ; solicitar movimiento
    call leer_movimiento
    ; validar el movimiento
    call validar_movimiento
    cmp al, 1
    jne juego_loop  ; si es invalido, repetir el bucle

    call ejecutar_movimiento

    ; verificar condiciones de fin de juego 
    ; si no hay mas soldados, o no hay mas oficiales, o los soldados ocuparon fortaleza
    ; call verificar_fin_juego
    ; cmp al, 1
    ; je fin_del_juego

    call switch_turno
    cmp byte[bool_captura],1
    jne remover_oficiales

    jmp juego_loop

    ret

fin_del_juego:
    call imprimir_tablero

    ; mensaje de fin de juego. Aclarar quien ganó
    lea rdi, [rel mensaje_fin_juego]
    xor rax, rax
    call puts

    mov rax, 60     ; syscall exit
    xor rdi, rdi    ; estado de salida 0
    syscall
