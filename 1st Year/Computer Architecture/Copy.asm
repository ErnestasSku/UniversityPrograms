.model small
.stack 100h
.data
    fh_in dw 0
    fh_out dw 0
    file_in db 16, 0, 16 dup(0)
    file_out db 16, 0, 16 dup(0)

    msg_in db "Iveskite ivesties failo varda: $"
    msg_out db 13, 10, "Iveskite isvesties failo varda: $"
    msg_error db 13, 10, "Ivyko klaida atidarant faila.$"

    buffer db 512h dup(?)
.code
start:

    mov dx, @data
    mov ds, dx

    mov ah, 09h
    mov dx, offset msg_in
    int 21h

    mov ah, 0ah
    mov dx, offset file_in
    int 21h

    mov bx, offset file_in
    call fix_file

    mov ah, 09h
    mov dx, offset msg_out
    int 21h

    mov ah, 0ah
    mov dx, offset file_out
    int 21h

    mov bx, offset file_out
    call fix_file
    mov ax, 3d00h
    mov dx, offset file_in + 2
    int 21h

    jc klaida
    mov fh_in, ax
    mov ax, 3c00h
    xor cx, cx
    mov dx, offset file_out + 2
    int 21h

    jc klaida
    mov fh_out, ax

begin_read:
    mov ah, 3fh
    mov bx, fh_in
    mov cx, 200h
    mov dx, offset buffer
    int 21h

    push ax
    mov cx, ax
    cmp cx, 0
    jz end_read
    mov bx, offset buffer

loop1:
    mov al, [bx]
    cmp al, 'a'
    jb skip
    cmp al, 'z'
    ja skip
    sub al, 20h
    mov [bx], al

skip:
    inc bx
    loop loop1
    mov ah, 40h
    mov bx, fh_out
    pop cx
    mov dx, offset buffer
    int 21h

    jmp begin_read

end_read:
    mov ah, 3eh
    mov bx, fh_out
    int 21h

    mov ah, 3eh
    mov bx, fh_in
    int 21h
    jmp pabaiga

klaida:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h

pabaiga:
    mov ax, 4c00h
    int 21h


fix_file:
    push dx
    push bx
    xor dx, dx
    mov dl, [bx + 1]
    add bx, dx
    mov dl, 0
    mov [bx + 2], dl
    pop bx
    pop dx
    ret
end start


