.model small
.stack 100h

.data
    newl db 0ah, 24h   
    fh_in dw 0
    fh_out dw 0
    file_in db 16, 0, 16 dup(0)
    file_out db 16, 0, 16 dup(0)
    
    debg db "debug.txt"
    Debug dw 0

    msg_in db "Iveskite ivesties failo varda: $"
    msg_out db 13, 10, "iveskita isvesties dailo varda: $"
    msg_error db 13, 10, "Ivyko klaida atidarant faila. $"
    
    FileStart db 13, "<html> <body>"
    FileEnd db 15, "</body> </html>"
    
    Registers db 36, "ax.al.ah.bx.bl.bh.cx.cl.ch.dx.dl.dh."
    Operations db 25, "mov.int.xor.inc.dec.loop."
    
    TextTag db 4, "<p> "
    EndTextTag db 5, "</p>", 10
    CommentTag db 21, "<font color = ", 22h, "gray", 22h, ">" 
    DotTag db 20, "<font color = ", 22h, "red", 22h, ">" 
    RegisterTag db 22, "<font color = ", 22h, "green", 22h, ">" 
    OperationTag db 21, "<font color = ", 22h, "blue", 22h, ">" 
    RegularTag db 22, "<font color = ", 22h, "black", 22h, ">" 
    FontEndingTag db 7, "</font>"

    buffer db 512h dup(?)
    output db 2048h dup(?)
    outputSize dw 0
    CheckingWord db 0, 20h dup(?)
    WordSize db 0
    State db 0
    ;counter db 0

.code

start:

    mov dx, @data
    mov ds, dx

;----------------------------------------------
    mov ah, 09h
    mov dx, offset msg_in
    int 21h

    mov ah, 0ah
    mov dx, offset file_in
    int 21h
	
	mov ax, 4000h
	mov bx, 1
	mov cx, 0016h
	mov dx, offset file_in
	int 21h
	
    mov bx, offset file_in
    call fix_file
	
	mov ah, 09h
	mov dx, offset newl
	int 21h
	
	mov ax, 4000h
	mov bx, 1
	mov cx, 0016h
	mov dx, offset file_in
	int 21h
	
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

    mov bx, offset debg
    call fix_file

    mov ax, 3c00h
    mov dx, offset debg + 2
    int 21h
    jc klaida
    mov Debug, ax

    mov ax, 3c00h
    xor cx, cx
    mov dx, offset file_out + 2
    int 21h
    jc klaida
    mov fh_out, ax

    jmp skipKlaida
;---------------------------  atidaromi failai

;--------------------------- isvedama error message ir jmp is pabaiga
klaida:
    mov ah, 09h
    mov bx, offset msg_error
    jmp pabaiga
;---------------------------

skipKlaida:
   
    xor cx, cx
    mov cl, [FileStart]

    mov di, offset output
    mov bx, offset FileStart + 1

;-------------------- Idedamas html ir body tagas


StartFile:

    mov al, [bx]
    mov [di], al
    inc bx
    inc di
    inc [outputSize]
    loop StartFile
;-------------------- Idedamas html ir body tagas
    call BeginPara   

    mov si, offset CheckingWord
BeginRead:
;-------------- nuskaitomi duomenys is failo
    mov ah, 3fh
    mov bx, fh_in
    mov cx, 512h
    mov dx, offset buffer
    int 21h
;--------------

    mov cx, ax
    cmp cx, 0
    jz end_read
    mov bx, offset buffer
;------------------------------- main loo
MainReadLoop:
    
    mov al, [bx]
    mov [si], al
    inc [WordSize]
    inc si
    cmp al, 33
    ja skipCheckWord
    ;cmp al, 'z'
    ;jb skipCheckWord
    ;cmp al, 'A'
    ;jb skipCheckWord
    ;cmp al, 'z'
    ;ja skipCheckWord
    push ax
    call CheckWord
    
    mov [WordSize], 0
    mov si, offset CheckingWord
    ;jmp SkipIncrement

skipCheckWord:
    pop ax
    cmp al, 10
    jne skipEndTag
    call EndPara
skipEndTag:
    
    inc bx
    loop MainReadLoop
;-----------------------------------------------
    mov ah, 40h
    mov bx, fh_out
    xor cx, cx
    mov cx, [outputSize]
    mov dx, offset output
    int 21h
    
    mov [outputSize], 0
    mov di, offset output

    jmp BeginRead

end_read:
    
    mov ah, 3eh
    mov bx, fh_out
    int 21h

    mov ah, 3eh
    mov bx, fh_in
    int 21h

Pabaiga:

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

EndPara:
    
    push bx
    push cx
    
    mov bx, offset EndTextTag + 1
    xor cx, cx
    mov cl, [EndTextTag]

EndingParaLoop:

    mov al, [bx]
    mov [di], al
    inc bx
    inc di
    inc [outputSize]
    loop EndingParaLoop


    pop cx
    pop bx


BeginPara:
    
    push bx
    push cx

    mov bx, offset TextTag + 1
    xor cx, cx
    mov cl, [TextTag]
    


ParagraphLoop:
    
    mov al, [bx]
    mov [di], al
    inc bx
    inc di
    inc [outputSize]
    loop ParagraphLoop

    pop cx
    pop bx
    ret

CheckWord:

    push bx
    push cx
    
    mov ah, 40h
    mov bx, Debug
    xor cx, cx
    mov cl, [WordSize]
    mov dx, offset CheckingWord
    int 21h
    
    mov bx, offset regularTag
    ;------- Patikrinimas ar komentaras
    mov si, offset CheckingWord
    mov al, [si]
    cmp al, ";"
    jne skipComment
    mov bx, offset CommentTag
    ;jmp CheckWordPabaiga

skipComment:
    ;------- Patirkinimas ar .
    cmp al, "."
    jne skipDot
    mov bx, offset DotTag
    ;jmp CheckWordPabaiga

skipDot:

;----------------- Iki cia viskas kaip ir veikia
    ;------- Patikrinmas ar registras
    


   

    push di   ; pushinu di, nes di yra mano output
    mov di, offset Registers + 1
    xor cx, cx
    mov cl, [Registers]
    mov byte ptr [State], 0  
    mov si, offset CheckingWord
    ;mov dx, si


   

RegisterCheckLoop:
   
    mov ah, [di]  ; registers
    mov al, [si]  ; Word



    
    mov ah, [di]  ; registers
    mov al, [si]  ; Word


    cmp ah, "."
    je skipRegC

    cmp [State], 1
    je skipRegreset
    
    cmp ah, al
    je skipRegreset
    ;push bx
    ;mov bx, offset State
    ;mov [bx], 1
    ;pop bx
    mov byte ptr [State], 1

skipRegC:
    ;cmp ah, "."
    ;jne skipRegreset
     
    cmp byte ptr [State], 0
    mov si, offset CheckingWord
    mov byte ptr [State], 0
    ;inc di
    jne skipRegInc
    mov bx, offset RegisterTag
    ;jmp CheckWordPabaiga
    ;call ResetWord
skipRegreset:

    inc di
    inc si
skipRegInc:
    loop RegisterCheckLoop
    pop di
;------------------------------------------


;------------------- Funkcija zemiau tai tiesiog kaip ir copy paste sitos, nes tokiu paciu principu darau
    ;------- Patikrinmas ar operacija
    
    push di
    mov di, offset Operations + 1
    xor cx, cx
    mov cl, [Operations]
    mov [State], 0
    mov si, offset CheckingWord
OperationCheckLoop:
   
    mov ah, [di]  ; registers
    mov al, [si]  ; Word

    cmp [State], 1
    je skipOpC
    
    cmp ah, "."
    je skipOpC
    
    cmp ah, al
    je skipOpreset
    mov [State], 1

skipOpC:
    cmp ah, "."
    jne skipOpreset
     
    cmp [State], 0
    jne skipOpreset
    mov bx, offset OperationTag
    inc di
    call ResetWord
skipOpreset:

    inc di
    inc si

    loop OperationCheckLoop
    pop di


;-------- Idedu font tag

CheckWordPabaiga:

    xor cx, cx
    mov cl, [bx]
    inc bx
AddFontTag:
    
    mov al, [bx]
    mov [di], al
    inc bx
    inc di
    inc [outputSize]

    loop AddFontTag

    xor cx, cx
    mov cl, [WordSize]
    mov si, offset CheckingWord
AddWordContent:
        
    mov al, [si]
    mov [di], al
    inc si
    inc di
    inc [outputSize]

    loop AddWordContent

    xor cx, cx
    mov cl, [FontEndingTag]
    mov bx, offset FontEndingTag + 1
AddEndFontTag:
    
    mov al, [bx]
    mov [di], al
    inc bx
    inc di
    inc [outputSize]

    loop AddEndFontTag

    pop cx
    pop bx
    ret

ResetWord:
    mov [State], 0
    mov si, offset CheckingWord
    ret

end start
