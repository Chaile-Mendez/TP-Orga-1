extern printf
extern rotacion_tablero
extern tablero

%include "constantes.asm"
global imprimir_tablero_rotado
section .data
    formato_caracter db " %c ",0

    salto_de_linea db 10,0
    formato_eje_x db " %i ", 0
    
section .text

imprimir_tablero_rotado:

    sub rsp, 16
    
    mov rdi, formato_caracter
    mov rsi, ' '
    
    call printf
    
    add rsp, 16
   
    mov rcx, 0

imprimir_eje_x:
    push rcx
    sub rsp, 8
    
    mov rdi, formato_eje_x
    mov rsi, rcx
    call printf
    
    add rsp, 8
    pop rcx
    

    add rcx, 1
    cmp rcx, 7
    jne imprimir_eje_x
    
    sub rsp, 16

    mov rdi, salto_de_linea
    
    call printf
    
    add rsp, 16
     
    movzx rax, word [rotacion_tablero]

    ;push rax
    cmp rax, 90
    je imprimir_90
    cmp rax, 180
    je imprimir_180
    cmp rax, 270
    je imprimir_270
    jmp imprimir_0
    
    
imprimir_0:
    mov rdx, 0;FILAS

    push rdx
    sub rsp, 16
    
    mov rdi, formato_eje_x
    mov rsi, rdx
    call printf
    
    add rsp, 16
    pop rdx




    mov rcx, 0;COLUMNAS
    mov rbx, tablero
    
    jmp nuevo_caracter_0

nueva_linea_0:
    
       
    
    ;Nueva linea
    mov rcx, 0; COLUMNAS
    add rdx, 1
    cmp rdx, 7
    je terminar_rotacion_0

    push rcx
    
    push rbx
    push rdi
    push rsi
    push rdx
    
    sub rsp, 8

    mov rdi, salto_de_linea
    call printf
    
    add rsp, 8
    
    pop rdx
    
    push rdx
    
    sub rsp, 8
    mov rdi, formato_eje_x
    mov rsi, rdx
    call printf
       
    add rsp, 8
    
    pop rdx
    pop rsi
    pop rdi
    pop rbx
    pop rcx
    
    

    
nuevo_caracter_0:
    push rdx
    push rcx
    push rdi
    push rsi

    sub rsp, 16

    mov rdi, formato_caracter
    mov sil, [rbx]
    call printf

    add rsp, 16
    
      

    pop rsi
    pop rdi
    pop rcx
    pop rdx
    
   
    add rbx, 1
    add rcx, 1
    cmp rcx, 7

    je nueva_linea_0
    jmp nuevo_caracter_0
    
terminar_rotacion_0:

    sub rsp, 16
    mov rdi, salto_de_linea
    call printf
    add rsp, 16
    
    
    jmp terminar_rotacion
    
    
imprimir_180:

    mov edx, 7;FILAS
    mov ecx, 7;COLUMNAS
    
    imul edx, ecx
    
    mov rbx, tablero
    add rbx, rdx
    
    mov rdx, 7;FILAS
    mov rcx, 7;COLUMNAS
    sub rbx, 1
    
    push rax
    push rcx
    push rdx

    
    
    sub rsp, 8
    
    mov rdi, formato_eje_x
    mov rsi, 0
    call printf
    
    add rsp, 8
    
    pop rdx
    pop rcx
    pop rax

    
    
    jmp nuevo_caracter_180

nueva_linea_180:
    ;Nueva linea
    mov rcx, 7; COLUMNAS
    
    push rcx
    push rdx
    push rbx
    push rdi
    push rsi

    sub rsp, 8
    
    mov rdi, salto_de_linea
    call printf
       
    add rsp, 8
    
    pop rsi
    pop rdi

    pop rbx
    pop rdx
    pop rcx
    
    sub rdx, 1
    cmp rdx, 0
    je terminar_rotacion
 
    push rax
    push rcx
    push rdx

    
    
    sub rsp, 8
    
    mov rdi, formato_eje_x
    sub rdx, 7
    neg rdx
    mov rsi, rdx
    call printf
    
    add rsp, 8
    
    pop rdx
    pop rcx
    pop rax
    
nuevo_caracter_180:

    push rdx
    push rcx
    push rdi
    push rsi


    sub rsp, 16
    mov rdi, formato_caracter

    mov sil, [rbx]
    call printf
    add rsp, 16
    

    pop rsi
    pop rdi
    pop rcx
    pop rdx

    
    sub rbx, 1
    sub rcx, 1
    cmp rcx, 0
    je nueva_linea_180
    jmp nuevo_caracter_180
    
end_180:
    ret
    
    
    
imprimir_270:
    mov edx, 0;FILAS
    mov ecx, 6;COLUMNAS
    mov rbx, tablero
    
nueva_linea_270:
    
    mov rax, rcx
    
    push rax
    push rcx
    push rdx
    
    sub rsp, 8
    
    mov rdi, formato_eje_x
    sub rcx, 6
    neg rcx
    mov rsi, rcx
    call printf
    
    add rsp, 8
    
    pop rdx
    pop rcx
    pop rax

nuevo_caracter_270:
    push rax
    push rdx
    push rcx
    push rdi
    push rsi

    sub rsp, 8
    
    mov rdi, formato_caracter
    mov rsi, 0
    mov sil, [tablero + rax]
    call printf
    
    add rsp, 8
    

    pop rsi
    pop rdi
    pop rcx
    pop rdx
    pop rax

    
    
    add rax, 7
    add rdx, 1
    cmp rdx, 7
    
    je salto_linea_270
    jmp nuevo_caracter_270
    
salto_linea_270:

    push rcx
    push rdx
    push rbx
    push rdi
    push rsi

    sub rsp, 8
    
    mov rdi, salto_de_linea
    call printf
       
    add rsp, 8
    
    pop rsi
    pop rdi

    pop rbx
    pop rdx
    pop rcx

    
    sub rcx, 1
    mov rdx, 0
    
    cmp rcx, 0
    jl terminar_rotacion
    jmp nueva_linea_270
    
end_270:
    ret
    
    
imprimir_90:

    mov edx, 0;FILAS
    mov ecx, 0;COLUMNAS
    mov rbx, tablero
    
nueva_linea_90:
    
    mov rax, rcx
    add rax, 42
    
    
    push rax
    push rcx
    push rdx

    
    
    sub rsp, 8
    
    mov rdi, formato_eje_x
    mov rsi, rcx
    call printf
    
    add rsp, 8
    
    pop rdx
    pop rcx
    pop rax

    
    
    
nuevo_caracter_90:
    push rax
    push rdx
    push rcx
    push rdi
    push rsi

    sub rsp, 8
    
    mov rdi, formato_caracter
    mov rsi, 0
    mov sil, [tablero + rax]
    call printf
    
    add rsp, 8
    

    pop rsi
    pop rdi
    pop rcx
    pop rdx
    pop rax
    
    
    sub rax, 7
    add rdx, 1
    cmp rdx, 7
    
    je salto_linea_90
    jmp nuevo_caracter_90
    
salto_linea_90:
    push rcx
    push rdx
    push rbx
    push rdi
    push rsi

    sub rsp, 8
    
    mov rdi, salto_de_linea
    call printf
       
    add rsp, 8
    
    pop rsi
    pop rdi
    pop rbx
    pop rdx
    pop rcx

    
    
    add rcx, 1
    mov rdx, 0
    
    cmp rcx, 7
    je terminar_rotacion
    jmp nueva_linea_90
    
terminar_rotacion:
    ;pop rax

    sub rsp, 16
    mov rdi, salto_de_linea
    call printf
    add rsp, 16
    
    ret   