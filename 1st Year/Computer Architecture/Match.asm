.model small
.stack 100h

.data

	msg db "Iveskite eilute: ", 24h
    Patt db "a"
    msg_Rado db 10, "Rasta$"
    msg_NeRa db 10, "Nerasta$" 
    ;buff db 255, 0, 255 dup(24h)
    buff db "a"

.code

start:

    mov dx, @data
    mov ds, dx
    
	mov ah, 09h
	mov dx, offset msg
	int 21h
    ;mov ah, 0ah
    ;mov dx, offset buff
    ;int 21h

    xor cx, cx
    mov cl, 10

    mov di, offset buff
    mov bx, offset Patt

ciklas:

    mov ah, [di]
    mov al, [bx]
    cmp ah, al
    jne NeR
    mov ah, 09h
    mov dx, offset msg_Rado
    int 21h
    jmp Pabaiga
NeR:
    

    inc ah
    inc dh
    loop ciklas

    mov ah, 09h
    mov dx, offset msg_NeRa
    int 21h

Pabaiga:

    mov ax, 4c00h
    int 21h

end start
