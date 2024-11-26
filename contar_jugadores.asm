;contar_jugadores.asm
;Cuenta la cantidad de Soldados y Oficiales en el tablero, y los guarda en sus respectivas variables en datos.asm
%include "constantes.asm"

global contar_jugadores
extern printf
extern mensaje_contar_fichas
extern cantidad_oficiales
extern cantidad_soldados
extern tablero


section .text

contar_jugadores:
    ;mov rbp, rsp; for correct debugging
    
    mov r10, OFICIAL
    mov r11, SOLDADO

    mov rcx, 49
    mov ebx, tablero
    mov rax, 0
    mov rsi, 0
    
    
    mov r8, 0
    mov r9, 0


siguiente:
    mov al, [ebx + esi]
    add si, 1
    ;mov [valor], al

    cmp al, r10b
    je contarOficial
    
        
    cmp al, r11b
    je contarSoldado
    loop siguiente

final:
    mov [cantidad_oficiales], r8b
    mov [cantidad_soldados], r9b

    sub rsp, 64
    mov rdi, mensaje_contar_fichas
    mov rsi, r8
    mov rdx, r9
    call printf

    add rsp, 64

    ret
    
contarOficial:
    add r8, 1
    sub rcx, 1
    cmp rcx, 0
    je final
    jmp siguiente
    
contarSoldado:
    add r9, 1
    sub rcx, 1
    cmp rcx, 0
    je final
    jmp siguiente

