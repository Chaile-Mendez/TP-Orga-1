; menu de inicio del programa

%include "constantes.asm"

global menu
extern printf, gets, puts
extern cargar_partida


section .data
    
    mensaje_inicio      db  'Bienvenido a El Asalto', 0
    mensaje_solicitar_accion    db  'Ingrese una accion:', 0
    mensaje_opcion_1    db  'nueva - Iniciar una nueva partida', 0
    mensaje_opcion_2    db  'cargar - Carga una partida guardada previamente', 0
    mensaje_opcion_3    db  'salir - Salir del programa', 0
    mensaje_accion_invalida db  'Ingrese una accion valida:', 0

    accion1             db  'nueva', 0
    accion2             db  'cargar', 0
    accion3             db  'salir', 0


section .bss
    accion              resb    100

section .text

menu:

    push rbx
    push r12

    mov     rdi,mensaje_inicio
    sub     rsp,8
    call puts
    add     rsp,8

acciones:
    mov     rdi,mensaje_opcion_1
    sub     rsp,8
    call puts
    mov     rdi,mensaje_opcion_2
    call puts
    mov     rdi,mensaje_opcion_3
    call puts
    mov     rdi,mensaje_solicitar_accion
    call puts
    add     rsp,8

leer_accion:
    mov rdi,accion
    call gets
    mov rax,[accion]
    cmp eax,[accion1]
    je nuevo_juego
    cmp eax,[accion2]
    je cargar_partida
    cmp eax,[accion3]
    je cerrar_programa

accion_invalida:
    mov     rdi,mensaje_accion_invalida
    sub     rsp,8
    call    puts
    add     rsp,8
    jmp leer_accion


nuevo_juego:
    pop r12
    pop rbx
    ret

cerrar_programa:
    mov rax, 60     ; syscall exit
    xor rdi, rdi    ; estado de salida 0
    syscall