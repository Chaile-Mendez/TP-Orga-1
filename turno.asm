; funciones para manejar el alternar turno actual

%include "constantes.asm"

extern turno_actual
extern SOLDADO
extern OFICIAL

global switch_turno

section .text

switch_turno:
    push rbx

    ; leer el turno actual
    mov bl, [turno_actual]

    ; alternar el turno
    cmp bl, [SOLDADO]
    je cambiar_a_oficiales
    cmp bl, [OFICIAL]
    je cambiar_a_soldados
    ; si el valor no es 'S' ni 'O', cambiar a 'S'. por lad dudas
    jmp cambiar_a_soldados

cambiar_a_oficiales:
    mov r15b, [OFICIAL]
    mov byte [turno_actual], r15b
    jmp fin_switch

cambiar_a_soldados:
    mov r15b, [SOLDADO]
    mov byte [turno_actual], r15b

fin_switch:
    pop rbx
    ret
