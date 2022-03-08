.model small
.stack 100h

.data
    endl db 10, 24h

    buff_one db 512 dup(0)
    buff_two db 512 dup(0)
    output db 4096 dup(0)
    output_size db 0
    counter db 0

    file_one dw 0
    file_two dw 0
    file_one_in db 16, 0, 16 dup(0)
    file_two_in db 16, 0, 16 dup(0)

    err_msg db "Ivyko klaida atidarant failus $"
    help db "Iveskita fcomp file1 file2 ir programa isves nesutampancius simbolius.", 10, 13, "$"

.code 

start:

    mov dx, @data
    mov ds, dx

    xor cx, cx
    mov cl, es:[0080h]
    cmp cx, 0
    je nera
    mov bx, 0081h

paieska:

    cmp es:[bx], '?/'
    je yra
    inc bx
    loop paieska
    jmp nera

yra:
    mov ah, 09h
    mov dx, offset help 
    int 21h

    mov ax, 4c00h
    int 21h

nera:
   
    xor cx, cx
    mov cl, es:[0080h]
    mov bx, 0082h
    mov di, offset file_one_in
ReadFileOne:

    mov al, es:[si + bx]
    cmp al, " "
    je EndFirstRead
    mov [di], al
    inc di
    inc bx

    loop ReadFileOne

EndFirstRead:

    mov di, offset file_two_in
    dec cx
ReadFileTwo:
    
    mov al, es:[si + bx]
    cmp al, " "
    je SkipRead
    mov [di], al
    inc di
SkipRead:
    inc bx

    loop ReadFileTwo

EndSecondRead:

; --------   Debug checking input

    ; mov ax, 4000h
	; mov bx, 1
	; mov cx, 000Fh
	; mov dx, offset file_one_in
	; int 21h

    ; mov ah, 09h
    ; mov dx, offset endl
    ; int 21h

    ; mov ax, 4000h
	; mov bx, 1
	; mov cx, 000Fh
	; mov dx, offset file_two_in
	; int 21h

; --------------

; -------- Open first file
    mov bx, offset file_one_in
    call fix_file

    mov ax, 3d00h
    mov dx, offset file_one_in
    int 21h
    jc klaida
    mov file_one, ax
; ------
; ----------- Open second file
    mov bx, offset file_two_in
    call fix_file


    mov ax, 3d00h 
    mov dx, offset file_two_in
    int 21h
    jc klaida
    mov file_two, ax
; -----------

    jmp SkipKlaida
klaida:

    mov ah, 09h
    mov dx, offset err_msg
    int 21h

SkipKlaida:

    mov si, offset output
    ;---------- Read both files
BeginRead:

    mov ah, 3fh
    mov bx, file_one
    mov cx, 512
    mov dx, offset buff_one
    int 21h
    
    push ax

    mov ah, 3fh
    mov bx, file_two
    mov cx, 512
    mov dx, offset buff_two
    int 21h
; ----- end of reading both files

    pop bx
    cmp ax, bx
    ja SkipChange
    xchg ax, bx
SkipChange:
    mov cx, ax
    cmp ax, 0
    je exit

    mov di, offset buff_one
    mov bx, offset buff_two
    mov [counter], 0

MainLoop:

    mov al, [di]
    mov ah, [bx]

    cmp al, ah
    je SkipDifferent

    mov al, [counter]
    aam
    add ax, 3030h
    mov [si], ah
    inc si
    inc [output_size]
    mov [si], al
    inc si
    inc [output_size]

    mov al, " "
    mov [si], al
    inc si
    inc [output_size]

    mov al, [di]
    mov [si], al
    inc si
    inc [output_size]
    

    mov al, " "
    mov [si], al
    inc si
    inc [output_size]


    mov al, [bx]
    mov [si], al
    inc si
    inc [output_size]


    mov al, 10
    mov [si], al
    inc si
    inc [output_size]

    ; inc [output_size]
    ; mov al, [output_size]
    ; add al, 5

;-- Jei nelygu tai



SkipDifferent:
    inc di
    inc bx
    inc [counter]

    loop MainLoop

    mov ax, 4000h
    mov bx, 1
    xor cx, cx
    mov cl, [output_size]
    mov dx, offset output
    int 21h

    jmp BeginRead

exit:

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
