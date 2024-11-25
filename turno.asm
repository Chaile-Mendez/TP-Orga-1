; funciones para manejar el alternar turno actual

%include "constantes.asm"

extern turno_actual

global switch_turno

section .text

switch_turno:
    push rbx

    ; leer el turno actual
    mov bl, [turno_actual]

    ; alternar el turno
    cmp bl, 'S'
    je cambiar_a_oficiales
    cmp bl, 'O'
    je cambiar_a_soldados
    ; si el valor no es 'S' ni 'O', cambiar a 'S'. por lad dudas
    jmp cambiar_a_soldados

cambiar_a_oficiales:
    mov byte [turno_actual], 'O'
    jmp fin_switch

cambiar_a_soldados:
    mov byte [turno_actual], 'S'

fin_switch:
    pop rbx
    ret
