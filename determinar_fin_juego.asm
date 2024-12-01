%include "constantes.asm"

extern printf
extern tablero
extern OFICIAL


%include "constantes.asm"

global determinar_fin_juego

extern cantidad_soldados
extern cantidad_oficiales
extern datos_oficial1
extern datos_oficial2
extern cerrar_programa

section .data
    mensaje_pocos_soldados db "Gana los oficiales, no hay suficientes soldados para ocupar la base!",10,0
    mensaje_pocos_oficiales db "Ganan los soldados, no hay oficiales que puedan detener a los soldados!",10,0
    mensaje_base_ocupada db "Ganan los soldados, la base de los oficiales fue capturada",10,0
    mensaje_mov_oficial_n db "Movimientos hacia el norte: %li",0
    mensaje_mov_oficial_no db "Movimientos hacia el noroeste: %li",0
    mensaje_mov_oficial_ne db "Movimientos hacia el noreste: %li",0
    mensaje_mov_oficial_e db "Movimientos hacia el este: %li",0
    mensaje_mov_oficial_o db "Movimientos hacia el oeste: %li",0
    mensaje_mov_oficial_s db "Movimientos hacia el sur: %li",0
    mensaje_mov_oficial_se db "Movimientos hacia el sureste: %li",0
    mensaje_mov_oficial_so db "Movimientos hacia el suroeste: %li",0
    mensaje_capturas_oficial db "Capturas: %li",0
    mensaje_estadisticas_oficial1 db "Estadisticas Oficial 1:",0
    mensaje_estadisticas_oficial2 db "Estadisticas Oficial 2:",0


section .text

global determinar_fin_juego
determinar_fin_juego:
    mov rbp, rsp; for correct debugging
    ;write your code here
    xor rax, rax
    
    movzx rax, byte[cantidad_soldados]
    cmp rax, 8
    jle caso_no_hay_soldados
    movzx rax, byte[cantidad_oficiales]
    cmp rax, 0
    jle caso_no_hay_oficiales
    
    jmp comprobacion
    ret
    
caso_no_hay_oficiales:
    mov rdi, mensaje_pocos_oficiales
    jmp fin
caso_no_hay_soldados:
    mov rdi, mensaje_pocos_soldados
    jmp fin
    
caso_fortaleza_ocupada:
    mov rdi, mensaje_base_ocupada
    jmp fin

fin:
    sub rsp, 8
    call printf
    add rsp, 8
    
    jmp imprimir_estadisticas
continua:
    ret
    
comprobacion:
    mov rcx, 0
    mov rdx, 0
    
nueva_col:
    mov rsi, 0
    mov esi, edx
    imul esi, 7
    add rsi, rcx
    add rsi, 30
    mov al, [tablero + rsi]
    cmp al, VACIO
    je continua
    
    cmp al, [OFICIAL]
    je continua
    
    inc rdx
    
    cmp rdx, 3
    je nueva_fila
    jmp nueva_col
    
nueva_fila:
    mov rdx, 0
    inc rcx
    
    cmp rcx, 3
    jl nueva_col
    
    jmp caso_fortaleza_ocupada

imprimir_estadisticas:
    mov rdi,mensaje_estadisticas_oficial1
    call printf
    mov rdi,mensaje_mov_oficial_no
    mov si,[datos_oficial1 + 2]
    call printf
    mov rdi,mensaje_mov_oficial_n
    mov si,[datos_oficial1 + 4]
    call printf
    mov rdi,mensaje_mov_oficial_ne
    mov si,[datos_oficial1 + 6]
    call printf
    mov rdi,mensaje_mov_oficial_o
    mov si,[datos_oficial1 + 8]
    call printf
    mov rdi,mensaje_mov_oficial_e
    mov si,[datos_oficial1 + 12]
    call printf
    mov rdi,mensaje_mov_oficial_so
    mov si,[datos_oficial1 + 14]
    call printf
    mov rdi,mensaje_mov_oficial_s
    mov si,[datos_oficial1 + 16]
    call printf
    mov rdi,mensaje_mov_oficial_se
    mov si,[datos_oficial1 + 18]
    call printf
    mov rdi,mensaje_capturas_oficial
    mov si,[datos_oficial1 + 20]

    jmp cerrar_programa