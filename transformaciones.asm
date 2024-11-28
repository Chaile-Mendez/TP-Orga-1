; funciones de transformación del tablero. rotar y espejar

%include "constantes.asm"

global transponer, espejoX
extern tablero, aux
extern SOLDADO
extern OFICIAL
section .text

transponer:
    ; Preservar registros 
    push rbx
    push r12
    push r13
    push r14

    ; for (i = 0; i < ALTO; i++)
    xor rbx, rbx    ; rbx = i = 0
transponer_i_loop:
    cmp rbx, ALTO
    jge transponer_i_end

    ; for (j = 0; j < ANCHO; j++)
    xor r12, r12   ; r12 = j = 0
transponer_j_loop:
    cmp r12, ANCHO
    jge transponer_j_end

    ; calcular índices
    ; index_tablero = i * ANCHO + j
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; index_aux = j * ALTO + i
    mov rcx, r12
    imul rcx, ALTO
    add rcx, rbx

    ; aux[j][i] = tablero[i][j]
    mov dl, [tablero + rax]
    mov [aux + rcx], dl

    inc r12
    jmp transponer_j_loop

transponer_j_end:
    inc rbx
    jmp transponer_i_loop

transponer_i_end:

    ; copiar aux a tablero
    xor rbx, rbx    ; rbx = i = 0
copiar_aux_i_loop:
    cmp rbx, ALTO
    jge copiar_aux_i_end

    xor r12, r12    ; r12 = j = 0
copiar_aux_j_loop:
    cmp r12, ANCHO
    jge copiar_aux_j_end

    ; index_tablero = i * ANCHO + j
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; index_aux = i * ANCHO + j
    mov rcx, rbx
    imul rcx, ANCHO
    add rcx, r12

    ; tablero[i][j] = aux[i][j]
    mov dl, [aux + rcx]
    mov [tablero + rax], dl

    inc r12
    jmp copiar_aux_j_loop

copiar_aux_j_end:
    inc rbx
    jmp copiar_aux_i_loop

copiar_aux_i_end:

    ; restaurar registros
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

espejoX:
    ; preservar registros
    push rbx
    push r12
    push r13
    push r14

    ; for (i = ALTO - 1; i >= 0; i--)
    mov rbx, ALTO - 1      ; rbx = i = ALTO - 1
espejoX_i_loop:
    cmp rbx, -1
    jl espejoX_i_end

    ; for (j = ANCHO - 1; j >= 0; j--)
    mov r12, ANCHO - 1     ; r12 = j = ANCHO - 1
espejoX_j_loop:
    cmp r12, -1
    jl espejoX_j_end

    ; calcular índices
    ; index_tablero = i * ANCHO + j
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; index_aux = (ALTO - 1 - i) * ANCHO + (ANCHO - 1 - j)
    mov rcx, ALTO - 1
    sub rcx, rbx
    imul rcx, ANCHO
    mov rdx, ANCHO - 1
    sub rdx, r12
    add rcx, rdx

    ; aux[ALTO - 1 - i][ANCHO - 1 - j] = tablero[i][j]
    mov dl, [tablero + rax]
    mov [aux + rcx], dl

    dec r12
    jmp espejoX_j_loop

espejoX_j_end:
    dec rbx
    jmp espejoX_i_loop

espejoX_i_end:

    ; copiar aux a tablero
    xor rbx, rbx    ; rbx = i = 0
copiar_aux_i_loop_espejo:
    cmp rbx, ALTO
    jge copiar_aux_i_end_espejo

    xor r12, r12    ; r12 = j = 0
copiar_aux_j_loop_espejo:
    cmp r12, ANCHO
    jge copiar_aux_j_end_espejo

    ; index_tablero = i * ANCHO + j
    mov rax, rbx
    imul rax, ANCHO
    add rax, r12

    ; index_aux = i * ANCHO + j
    mov rcx, rbx
    imul rcx, ANCHO
    add rcx, r12

    ; tablero[i][j] = aux[i][j]
    mov dl, [aux + rcx]
    mov [tablero + rax], dl

    inc r12
    jmp copiar_aux_j_loop_espejo

copiar_aux_j_end_espejo:
    inc rbx
    jmp copiar_aux_i_loop_espejo

copiar_aux_i_end_espejo:

    ; restaurar registros
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
