; funcion para guardar la partida

%include "constantes.asm"

global guardar_partida
extern puts, fopen, fclose, fwrite
extern id_archivo,nombre_archivo
extern tablero
extern turno_actual
extern juego_loop
extern getchar



section .data
    modo_w      db  'w+', 0
    mensaje_g_exito db 'La partida se guardo exitosamente', 0


section .text


guardar_partida:
    call getchar ;consumir salto de linea

abrir_archivow:
    mov rdi,nombre_archivo
    mov rsi,modo_w
    call fopen

    cmp rax,0
    jle error_apertura_w
    mov qword[id_archivo],rax

guardar_archivo:
;guardo la matriz
    mov rdi,tablero
    mov rsi,1
    mov rdx,49
    mov rcx,[id_archivo]
    call fwrite

;guardo el turno
    mov rdi,turno_actual
    mov rsi,1
    mov rdx,1
    mov rcx,[id_archivo]
    call fwrite

    mov rdi,[id_archivo]
    call fclose

    mov     rdi,mensaje_g_exito
    sub     rsp,8
    call puts
    add     rsp,8

    call juego_loop

error_apertura_w:


