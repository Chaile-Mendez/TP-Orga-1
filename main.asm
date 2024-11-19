;función main y maneja el flujo del programa

%include "constantes.asm"

global main
extern printf, getchar, puts
extern inicializar_tablero, transponer, espejoX, imprimir_tablero
extern tablero, user_option
extern formato_numero, formato_caracter
extern menu_prompt, invalid_option, encabezado_x, encabezado_y, salto_linea

section .text

main:
    push rbx
    push r12        

    ; bucle para mostrar el menú y leer la opción del usuario
menu_loop:
    ; mostrar el menú
    lea rdi, [rel menu_prompt]   ; formato
    xor rax, rax                 
    call printf

    ; Leer la opción del usuario con getchar
    call getchar ; Problema? Toma el primer char ingresado por el usuario. Si pones "asdasd", recibe A
    mov [user_option], al        ; Guardar el carácter ingresado

    ; Consumir el salto de linea
    call getchar

    ; Obtener el carácter ingresado
    mov al, byte [user_option]

    
    cmp al, 'a'
    jl validar_opcion ; si es menor q la a minscula, validala (va a dar inválido)
    cmp al, 'z'
    jg validar_opcion ; si es mayor q la z mayuscula, validala (puede estar bien)

    sub al, 32                   ; si es una minuscula, convertir a mayúscula. las minusculas en ascii estan a 32 de distancia de sus mayusculas 
    mov byte [user_option], al

validar_opcion:
    ; Verificar si la opción es 'A', 'B', 'C' o 'D'
    cmp al, 'A'
    je opcion_A
    cmp al, 'B'
    je opcion_B
    cmp al, 'C'
    je opcion_C
    cmp al, 'D'
    je opcion_D

    ; Opción inválida, mostrar mensaje y repetir
    lea rdi, [rel invalid_option]
    xor rax, rax
    call puts
    jmp menu_loop

opcion_A:
    ; opción A: no hacer nada
    jmp continuar

opcion_B:
    ; opción B: transponer
    mov byte [user_option], 'B'
    jmp continuar

opcion_C:
    ; opción C: espejo en X
    mov byte [user_option], 'C'
    jmp continuar

opcion_D:
    ; opción D: transponer y espejo en X
    mov byte [user_option], 'D'
    jmp continuar

continuar:
    ; inicializar el tablero
    call inicializar_tablero

    ; Aplicar transformaciones según la opción seleccionada
    mov al, byte [user_option]
    cmp al, 'A'
    je sin_transformacion
    cmp al, 'B'
    je aplicar_transponer
    cmp al, 'C'
    je aplicar_espejoX
    cmp al, 'D'
    je aplicar_transponer_espejoX
    jmp sin_transformacion  ; Por defecto, imprimir sin transformación

aplicar_transponer:
    call transponer
    jmp imprimir

aplicar_espejoX:
    call espejoX
    jmp imprimir

aplicar_transponer_espejoX:
    call transponer
    call espejoX
    jmp imprimir

sin_transformacion:
    jmp imprimir

imprimir:
    call imprimir_tablero

    ; Restaurar registros
    pop r12
    pop rbx

    ; fin
    mov rax, 60     ; syscall: exit
    xor rdi, rdi    ; estado de salida 0
    syscall
