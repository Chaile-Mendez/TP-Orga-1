;Cuenta la cantidad de Soldados y Oficiales en el tablero, y los guarda en sus respectivas variables en datos.asm
%include "datos.asm"

global contarJugadores

extern tablero


section .data
    formato db "Oficiales :%i, Soldados:%i",0
    oficiales db 0
    valor db ' '



section .text

contarJugadores:
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
    mov [valor], al

    cmp al, r10b
    je contarOficial
    
        
    cmp al, r11b
    je contarSoldado
    loop siguiente

final:
    mov [cantidadOficiales], r8b
    mov [cantidadSoldados], r9b
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

