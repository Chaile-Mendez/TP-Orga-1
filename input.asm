; funciones para manejar la entrada del usuario

%include "constantes.asm"

extern printf, getchar, puts
extern invalid_posicion
extern mensaje_turno_soldados, mensaje_turno_oficiales
extern mensaje_pos_inicio_fila, mensaje_pos_inicio_col
extern mensaje_pos_fin_fila, mensaje_pos_fin_col
extern turno_actual, inicio_fila, inicio_col, fin_fila, fin_col

global leer_movimiento

section .text

leer_movimiento:
    push rbx
    push r12

    ; mostrar mensaje segun el turno actual
    mov al, [turno_actual]
    cmp al, 'S'
    je mensaje_soldados
    cmp al, 'O'
    je mensaje_oficiales

mensaje_soldados:
    lea rdi, [rel mensaje_turno_soldados]
    xor rax, rax
    call puts
    jmp solicitar_inicio_fila

mensaje_oficiales:
    lea rdi, [rel mensaje_turno_oficiales]
    xor rax, rax
    call puts
    jmp solicitar_inicio_fila

    ; solicitar fila inicio
solicitar_inicio_fila:
    lea rdi, [rel mensaje_pos_inicio_fila]
    xor rax, rax
    call printf

    call getchar                        
    ; Validar que sea un dígito entre '0' y '6'
    cmp al, '0'
    jb invalid_inicio_fila
    cmp al, '6'
    ja invalid_inicio_fila
    sub al, '0'                          ; conversión carácter a número
    mov [inicio_fila], al
    jmp continuar_inicio_fila

invalid_inicio_fila:
    lea rdi, [rel invalid_posicion]
    xor rax, rax
    call puts
    jmp solicitar_inicio_fila            ; si es invalido pedilo otra vez

continuar_inicio_fila:
    ; consumir salto de línea
    call getchar

    ; solicitad columna inicio
solicitar_inicio_col:
    lea rdi, [rel mensaje_pos_inicio_col]
    xor rax, rax
    call printf

    call getchar                       
    ; Validar que sea un dígito entre '0' y '6'
    cmp al, '0'
    jb invalid_inicio_col
    cmp al, '6'
    ja invalid_inicio_col
    sub al, '0'                          ; conversión carácter a número
    mov [inicio_col], al
    jmp continuar_inicio_col

invalid_inicio_col:
    lea rdi, [rel invalid_posicion]
    xor rax, rax
    call puts
    jmp solicitar_inicio_col            ; Repetir solicitud

continuar_inicio_col:
    ; consumir el salto de línea
    call getchar

    ; solicitar fila fin
solicitar_fin_fila:
    lea rdi, [rel mensaje_pos_fin_fila]
    xor rax, rax
    call printf

    call getchar                        
    ; Validar que sea un dígito entre '0' y '6'
    cmp al, '0'
    jb invalid_fin_fila
    cmp al, '6'
    ja invalid_fin_fila
    sub al, '0'                          ;  conversión carácter a número
    mov [fin_fila], al
    jmp continuar_fin_fila

invalid_fin_fila:
    lea rdi, [rel invalid_posicion]
    xor rax, rax
    call puts
    jmp solicitar_fin_fila              ; Repetir solicitud

continuar_fin_fila:
    ; Consumir el salto de línea
    call getchar

    ; solicitar columna fin
solicitar_fin_col:
    lea rdi, [rel mensaje_pos_fin_col]
    xor rax, rax
    call printf

    call getchar                        
    ; Validar que sea un dígito entre '0' y '6'
    cmp al, '0'
    jb invalid_fin_col
    cmp al, '6'
    ja invalid_fin_col
    sub al, '0'                          ; conversión carácter a número
    mov [fin_col], al
    jmp continuar_fin_col

invalid_fin_col:
    lea rdi, [rel invalid_posicion]
    xor rax, rax
    call puts
    jmp solicitar_fin_col                ; repetir solicitud

continuar_fin_col:
    ; Consumir el salto de línea
    call getchar

    pop r12
    pop rbx
    ret
