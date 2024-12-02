%include "constantes.asm"

extern printf
extern tablero
extern OFICIAL

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
    mensaje_mov_oficial_n db "Movimientos hacia el norte: %i",10 ,0
    mensaje_mov_oficial_no db "Movimientos hacia el noroeste: %i",10 ,0
    mensaje_mov_oficial_ne db "Movimientos hacia el noreste: %i",10 ,0
    mensaje_mov_oficial_e db "Movimientos hacia el este: %i",10 ,0
    mensaje_mov_oficial_o db "Movimientos hacia el oeste: %i",10 ,0
    mensaje_mov_oficial_s db "Movimientos hacia el sur: %i",10 ,0
    mensaje_mov_oficial_se db "Movimientos hacia el sureste: %i",10 ,0
    mensaje_mov_oficial_so db "Movimientos hacia el suroeste: %i",10 ,0
    mensaje_capturas_oficial db "Capturas: %i",10 ,0
    mensaje_estadisticas_oficial1 db "Estadisticas Oficial 1:",10 ,0
    mensaje_estadisticas_oficial2 db "Estadisticas Oficial 2:",10 ,0


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
    sub rsp,16
    mov rdi,mensaje_estadisticas_oficial1
    call printf
    add rsp,16
    mov rdi,mensaje_mov_oficial_no
    movzx rsi,word[datos_oficial1 + 2]
    call printf
    mov rdi,mensaje_mov_oficial_n
    movzx rsi,word[datos_oficial1 + 4]
    call printf
    mov rdi,mensaje_mov_oficial_ne
    movzx rsi,word[datos_oficial1 + 6]
    call printf
    mov rdi,mensaje_mov_oficial_o
    movzx rsi,word[datos_oficial1 + 8]
    call printf
    mov rdi,mensaje_mov_oficial_e
    movzx rsi,word[datos_oficial1 + 12]
    call printf
    mov rdi,mensaje_mov_oficial_so
    movzx rsi,word[datos_oficial1 + 14]
    call printf
    mov rdi,mensaje_mov_oficial_s
    movzx rsi,word[datos_oficial1 + 16]
    call printf
    mov rdi,mensaje_mov_oficial_se
    movzx rsi,word[datos_oficial1 + 18]
    call printf
    mov rdi,mensaje_capturas_oficial
    movzx rsi,word[datos_oficial1 + 20]
    call printf

    mov rdi,mensaje_estadisticas_oficial2
    call printf
    add rsp,16
    mov rdi,mensaje_mov_oficial_no
    movzx rsi,word[datos_oficial2 + 2]
    call printf
    mov rdi,mensaje_mov_oficial_n
    movzx rsi,word[datos_oficial2 + 4]
    call printf
    mov rdi,mensaje_mov_oficial_ne
    movzx rsi,word[datos_oficial2 + 6]
    call printf
    mov rdi,mensaje_mov_oficial_o
    movzx rsi,word[datos_oficial2 + 8]
    call printf
    mov rdi,mensaje_mov_oficial_e
    movzx rsi,word[datos_oficial2 + 12]
    call printf
    mov rdi,mensaje_mov_oficial_so
    movzx rsi,word[datos_oficial2 + 14]
    call printf
    mov rdi,mensaje_mov_oficial_s
    movzx rsi,word[datos_oficial2 + 16]
    call printf
    mov rdi,mensaje_mov_oficial_se
    movzx rsi,word[datos_oficial2 + 18]
    call printf
    mov rdi,mensaje_capturas_oficial
    movzx rsi,word[datos_oficial2 + 20]
    call printf

    jmp cerrar_programa