;Transforma coordenadas (i,j) rotandolas X grados, y transforma coordenadas (i,j) rotadas X grados a coordenadas en 0 grados.


;DEJA LA FILA ROTADA EN R8, LA COLUMAN ROTADA EN R9.
%macro rotar 3 ;FILA, COLUMNA, ROTACION(0,90,180,270)
    mov r8, %1;FILA
    mov r9, %2;COLUMNA

    mov r10, 90
    cmp r10, %3
    je rotar90

    mov r10, 180
    cmp r10, %3
    je rotar180

    mov r10, 270
    cmp r10, %3
    je rotar270
%endmacro


;DEJA LA FILA ENDEREZADA EN R8, LA COLUMAN ENDEREZADA EN R9.
%macro enderezar 3 ;FILA, COLUMNA, ROTACION(0,90,180,270)
    mov r8, %1;FILA
    mov r9, %2;COLUMNA

    mov r10, 90
    cmp r10, %3
    je rotar270

    mov r10, 180
    cmp r10, %3
    je rotar180

    mov r10, 270
    cmp r10, %3
    je rotar90

    ret
%endmacro


rotar90:
    mov rax, r9
    mov r8, r9
    mov r9, 6
    sub r9, rax
    ret

rotar180:
    mov rax, r9
    mov r9, 6
    sub r9, rax
    mov rax, r8
    mov r8, 6
    sub r8, rax
    ret 

rotar270:
    mov rax, r9
    mov r9, r8
    mov r8, 6
    sub r8, rax
    ret
