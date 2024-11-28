extern puts
extern scanf
extern printf
extern gets
extern stdin

extern rotacion_tablero
extern OFICIAL
extern SOLDADO

%include "constantes.asm"

global personalizar


section .bss
    respuesta resb 100

section .data

    aux_rotacion dw 0
    formato_respuesta db "%c",0
    formato_rotacion db "%i",0

    mensaje_configurar_soldado db "Desea cambiar el simbolo que representa al SOLDADO? (S para SI, cualquier otro caracter para NO)",10,0
    mensaje_configurar_oficial db "Desea cambiar el simbolo que representa al OFICIAL? (S para SI, cualquier otro caracter para NO)",10,0
    mensaje_configurar_rotacion db "Desea cambiar la rotacion del mapa? Puede elegir 0, 90, 180 o 270 grados (S para SI, cualquier otro caracter para NO)",10,0
    mensaje_preguntar_caracter_soldado db "Ingrese un caracter individual que represente al SOLDADO",10,0
    mensaje_preguntar_caracter_oficial db "Ingrese un caracter individual que represente al OFICIAL, debe ser diferente al del SOLDADO",10,0
    mensaje_preguntar_rotacion db "Ingrese el valor de la rotacion del tablero, debe ser 0, 90, 180 o 270",10,0
section .text
personalizar:
    ;Desea configurar SOLDADO?
preguntar_configurar_soldado:
    mov byte [respuesta], 'N'
    sub rsp, 8

    mov rdi, mensaje_configurar_soldado
    call puts

    add rsp, 8

    sub rsp, 16

    ;mov rdi, formato_respuesta
    ;mov rsi, respuesta
    ;call scanf
    mov rdi, respuesta
    call gets

    ;fgets(buffer, sizeof(buffer), stdin);  // Lee hasta 99 caracteres
    add rsp, 16

    mov al, [respuesta]
    cmp al, 'S'
    je configurar_soldado


preguntar_configurar_oficial:
    mov byte [respuesta], 'N'
    sub rsp, 8

    mov rdi, mensaje_configurar_oficial
    call puts

    add rsp, 8

    sub rsp, 8

    mov rdi, respuesta
    call gets

    add rsp, 8

    mov al, [respuesta]
    cmp al, 'S'
    je configurar_oficial

preguntar_configurar_rotacion:
    mov byte [respuesta], 'N'
    sub rsp, 8

    mov rdi, mensaje_configurar_rotacion
    call puts

    add rsp, 8

    sub rsp, 16

    mov rdi, respuesta
    call gets
    
    add rsp, 16

    mov al, [respuesta]
    cmp al, 'S'
    je configurar_rotacion

final_preguntas:
    ret
    ;Desea configurar rotacion del mapa?




configurar_soldado:
    mov byte[respuesta], PARED
    sub rsp, 8

    mov rdi, mensaje_preguntar_caracter_soldado
    call puts
    add rsp, 8

    sub rsp, 16

    mov rdi, respuesta
    call gets

    add rsp, 16

    mov al, [respuesta]
    cmp al, PARED
    je configurar_soldado
    mov [SOLDADO], al
    jmp preguntar_configurar_oficial




configurar_oficial:
    mov byte[respuesta], PARED
    sub rsp, 8

    mov rdi, mensaje_preguntar_caracter_oficial
    call puts
    add rsp, 8

    sub rsp, 16
    mov rdi, respuesta
    call gets

    add rsp, 16

    mov al, [respuesta]
    cmp al, PARED
    je configurar_oficial

    cmp al, [SOLDADO]
    je configurar_oficial

    mov [SOLDADO], al
    jmp preguntar_configurar_rotacion



configurar_rotacion:
    mov word[aux_rotacion], 0
    sub rsp, 8

    mov rdi, mensaje_preguntar_rotacion
    call puts
    add rsp, 8

    sub rsp, 16
    mov rdi, formato_rotacion
    mov rsi, aux_rotacion
    call scanf

    add rsp, 16

    mov ax, [aux_rotacion]

    cmp ax, 0
    je setear_rotacion
    cmp ax, 90
    je setear_rotacion
    cmp ax, 180
    je setear_rotacion
    cmp ax, 270
    je setear_rotacion

    jmp configurar_rotacion

setear_rotacion:
    mov [rotacion_tablero], al
    ret