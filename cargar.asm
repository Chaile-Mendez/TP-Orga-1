; funcion para cargar la partida

%include "constantes.asm"

global cargar_partida
extern fopen, fclose, fread, puts
extern id_archivo, nombre_archivo
extern tablero
extern turno_actual
extern juego_loop
extern menu

section .data
    modo_r      db  'r', 0
    mensaje_c_exito db 'La partida se cargo exitosamente', 0
    error_lectura db 'No hay partida guardada', 0

section .text
cargar_partida:


abrir_archivor:
    mov rdi,nombre_archivo
    mov rsi,modo_r
    call fopen

    cmp rax,0
    jle error_apertura_r
    mov qword[id_archivo],rax

cargar_archivo:

    mov rdi,tablero
    mov rsi,1
    mov rdx,49
    mov rcx,[id_archivo]
    call fread


    mov rdi,turno_actual
    mov rsi,1
    mov rdx,1
    mov rcx,[id_archivo]
    call fread


    sub     rsp,8
    mov rdi,[id_archivo]
    call fclose
    add     rsp,8

    mov     rdi,mensaje_c_exito
    sub     rsp,8
    call puts



    call juego_loop

error_apertura_r:
    mov     rdi,error_lectura
    sub     rsp,8
    call puts
    add     rsp,8
    
    call menu
