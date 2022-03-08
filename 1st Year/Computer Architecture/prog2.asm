.model small
.stack 100h

.data
    fh_in dw 0
    fh_out dw 0
    file_in db 16, 0, 16 dup(0)
    file_out db 16, 0, 16 dup(0)

    msg_in db "Iveskite ivesties failo varda: $"
    msg_out db 13, 10, "iveskita isvesties dailo varda: $"
    msg_error db 13, 10, "Ivyko klaida atidarant faila. $"
    
    FileStart db 13, "<html> <body>"
    FileEnd db 15, "</body> </html>"
    
    Registers db 35, "ax.al.ah.bx.bl.bh.cx.cl.ch.dx.dl.dh$"
    Opereations db "mov.int.xor.inc.dec.loop$"
    
    TextTag db "<a>"
    CommentTag db 21, "<font color = ", 22h, "gray", 22h, ">" 
    RegisterTag db 22, "<font color = ", 22h, "green", 22h, ">" 
    OperationTag db 21, "<font color = ", 22h, "blue", 22h, ">" 
    RegularTag db 22, "<font color = ", 22h, "black", 22h, ">" 
    FontEndingTag db 6, "</font>"

    buffer db 512h dup(?)
    output db 2048h dup(?)
    CheckingWord db 20h dup(?)
    WordSize db 0
    State dw 0
    counter db 0h

.code

start:
   
    mov dx, @data
    mov ds, dx
    
    ;Sita pakeisti reikės
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

    jc TarpinisKlaidosJump
    
    mov fh_in, ax
    mov ax, 3c00h
    xor cx, cx
    mov dx, offset file_out + 2
    int 21h

    jc TarpinisKlaidosJump
    mov fh_out, ax
   
    xor cx, cx
    mov cl, [FileStart]

    mov di, offset [output ]
    mov bx, offset [FileStart + 1]
   
    jmp Startfile

TarpinisKlaidosJump:
    jmp klaida

Startfile:
    
    mov al, [bx]
    mov [di], al

    inc bx
    inc di

    loop Startfile

begin_read:
    mov ah, 3fh
    mov bx, fh_in
    mov cx, 512h
    mov dx, offset buffer
    int 21h

    push ax
    mov cx, ax
    cmp cx, 0
    jz end_read
    mov bx, offset buffer
     
    push di
    mov si, offset [WordSize]
    mov [si], 00h
    mov di, offset [CheckingWord + 1]
loop1:
   
    mov al, [bx]
    mov [di], al

    cmp al, 'A'
    jb skip1
    cmp al, 'z'
    jz skip1
    
    call AddTag

skip1:
    inc di
    inc bx
    inc [si]

    loop loop1
    mov ah, 40h
    mov bx, fh_out
    pop cx
    mov dx, offset output 
    int 21h

    mov di, offset output

    jmp begin_read

end_read:
    mov ah, 3eh
    mov bx, fh_out
    int 21h

    mov ah, 3eh
    mov bx, fh_in
    int 21h
    jmp pabaiga
    
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

AddTag:
    
    push bx
    push dx
    push cx
    push di

    mov bx, offset [CheckingWord + 1]
    mov al, [bx]
    cmp al, 3bh
    mov di, offset [CommentTag]
    je skipAdd

; ------------------------------- Register vieta
    mov bx, offset [CheckingWord + 1]
    mov cl, offset [Registers]
    mov dx, offset [Registers + 1]
    mov State, 0
RegisterLoop:
    
    cmp ax, dx
    mov State, 0
    jne skipRegCheck
    mov State, 1

skipRegCheck:
    
    cmp ax, "."
    jne skipRegReset
    cmp State, 1
    mov di, offset RegisterTag
    je skipAdd 
    call RegReset
skipRegReset:
    
    inc dx
    inc bx
    
    loop RegisterLoop
;---------------------------------------- Register pabaiga

; ------------------------------- Komandu vieta
    mov bx, offset [CheckingWord + 1]
    mov cl, offset [Opereations]
    mov dx, offset [Opereations + 1]
    mov State, 0
OperationLoop:
    
    cmp ax, dx
    mov State, 0
    jne skipOpCheck
    mov State, 1

skipOpCheck:
    
    cmp ax, "."
    jne skipOpReset
    cmp State, 1
    mov di, offset OperationTag
    je skipAdd 
    call OpReset
skipOpReset:

    inc bx
    inc di

    loop OperationLoop
;---------------------------------------- Komandu pabaiga

    mov di, offset [RegularTag]
skipAdd:
    
    push di
    pop bx
    pop di
    
    xor cx, cx
    mov cl, 22
    inc bx
FillingTag:
    
    mov al, [bx]
    mov [di], al 

    inc di
    inc bx

    loop FillingTag
    
    xor cx, cx
    mov cl, 22
    mov bx, offset [CheckingWord + 1]
FillingWord:
    mov al, [bx]
    mov [di], al

    inc di
    inc bx

    loop FillingWord

    
    xor cx, cx
    mov cl, 6
    mov bx, offset [FontEndingTag + 1]
EndingTag:
    mov al, [bx]
    mov [di], al

    inc di
    inc bx

    loop EndingTag


    pop cx
    pop dx
    pop bx
    ret

RegReset:
    mov bx, offset [CheckingWord + 1]
    ret
   
OpReset:
    mov bx, offset [CheckingWord + 1]
    ret

end start
