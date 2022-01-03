.model small
.stack 100h
.data
	msg db "Iveskite eilute: ", 24h
	nl db 10d, 24h 
	buff db 255, 0, 255 dup(24h)
.code

start:

	mov dx, @data
	mov ds, dx

	mov ah, 09h
	mov dx, offset msg
	int 21h
	
	;Nuskaitoma eilute is ekrano
	mov ah, 0ah
	mov dx, offset buff
	int 21h
	
	;Isnulinamas cx registras ir perkeliamas buferio dydis
	xor cx, cx
	mov cl, [buff + 1]
	dec cl
	
	mov bx, offset buff + 2

ciklas:
	
	mov ah, [bx]  
	cmp ah, 20h   ;Tikrinama ar tai yra tarpas
	jne skip      ;Jei ne tarpas, tai einame i pabaiga
	mov [bx], dh

skip:
 
	mov dh, [bx]
	inc bx

	loop ciklas
	

	mov ah, 09h
	mov dx, offset nl ;Isvedama nauja eilute
	int 21h
	
	;Isvedami duomenys i ekrana
	mov ah, 40h
	mov bx, 1
	mov cl, [buff + 1]
	mov dx, offset buff + 2
	int 21h	

	
	mov ax, 4c00h
	int 21h

end start
