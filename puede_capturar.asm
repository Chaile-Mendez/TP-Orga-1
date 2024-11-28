global puede_capturar
extern tablero, calcular_indice
extern movimientos_puede_capturar
extern printf, puts

%include "constantes.asm"

section .data
    mensaje_inicio_puede_capturar db 'inicio puede capturar', 10, 0
    puede_capturar_ahora db 'PUEDE CAPTURAR AHORA',0
section .text,

puede_capturar:
    push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15

    ;mesaje inicio para debug
    lea rdi, [rel mensaje_inicio_puede_capturar]
    xor rax, rax
    call puts

    ; rdi = fila, rsi = columna

    lea r8, [movimientos_puede_capturar]
    mov rcx, movimientos_puede_capturar_tamanio ; Tamaño del arreglo de movimientos
    xor r9, r9      ; Índice en el arreglo de movimientos

loop_movimientos_puede_capturar:
    cmp r9, rcx
    jge fin_loop_movimientos_puede_capturar

    ; Obtener dx
    movsx r10, byte [r8 + r9]   ; dx
    inc r9

    ; Obtener dy
    movsx r11, byte [r8 + r9]   ; dy
    inc r9

    ; Calcular nueva fila y columna
    ; rdi = fila actual
    mov rax, rdi
    add rax, r10
    cmp rax, 0
    ; si es menor que 0, no es válido
    jl loop_movimientos_puede_capturar
    ; si es mayor que el alto, tampoco
    cmp rax, ALTO
    jge loop_movimientos_puede_capturar
    mov r13, rax   ; nueva fila

    ;rsi = columna actual
    mov rax, rsi
    add rax, r11
    ; si es menor que 0, no es válido
    cmp rax, 0
    jl loop_movimientos_puede_capturar
    ; si es mayor que el ancho, tampoco
    cmp rax, ANCHO
    jge loop_movimientos_puede_capturar
    mov r14, rax   ; nueva columna

    ; Calcular posición intermedia
    mov rax, r10
    sar rax, 1 ;shift aritmetic right. Divide por 2 y conserva signo
    add rax, rdi
    mov r15, rax   ; fila del medio

    mov rax, r11
    sar rax, 1
    add rax, rsi
    mov rbx, rax   ; columna del medio

    ; Verificar si hay un soldado en la posición intermedia
    mov rdi, r15
    mov rsi, rbx
    call calcular_indice
    mov bl, [tablero + rax]
    cmp bl, SOLDADO ;Si no es soldado es suficiente para descartar
    jne loop_movimientos_puede_capturar

    ; Verificar si la posición destino está vacía
    mov rdi, r13
    mov rsi, r14
    call calcular_indice
    mov bl, [tablero + rax]
    cmp bl, VACIO
    jne loop_movimientos_puede_capturar

    ; Puede capturar
    ; mensaje fin debug
    lea rdi, [rel mensaje_inicio_puede_capturar]
    call puts

    xor rax, rax
    mov rax, 1
    jmp fin_loop_movimientos_puede_capturar


fin_loop_movimientos_puede_capturar:
    ; Restaurar registros y return
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
