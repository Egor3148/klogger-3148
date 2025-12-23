.model small
.stack 100h
.data

    ; =================== FILE IO CONFIG =================
	
    filename     db 'MYFILE.BIN',0
    handle       dw 0         	; File handle
    buf_size     dw 1		  	; Buf to read: SIZE
    buffer       db 1 dup(?)  	; Buf to read: MEM
    ;file_size    dw 100h
  
    reader_pos   dw 0           ; Position of reader (for FILE walkthrough)
    buf_pos      db 0        	; Position at buffer (for BUFFER walkthrough)
    
	
	; =================== KEYBOARD CONFIG ==========
	; 1 = ON  / pressed
	; 0 = OFF / not_pressed
	
    CAPS_ON        db 0               
    L_SHIFT_PRESS  db 0                
    R_SHIFT_PRESS  db 0
    L_ALT_PRESS    db 0
    R_ALT_PRESS    db 0
    L_CTRL_PRESS   db 0
    R_CTRL_PRESS   db 0
    ESC_PRESS      db 0
  
    layout        db 0          ; 0 - EN keyb layout, 1 - RU keyb layout
    
	; SPECIAL KEYS SCAN_CODES
    sc_caps       db 3Ah
    sc_lShift     db 2Ah
    sc_rShift     db 36h
    sc_lAlt       db 38h              
    sc_rAlt       db 0
    sc_lCtrl      db 1Dh
    sc_rCtrl      db 0


    ; CHARS TO SCAN_CODES TABLES
	; These segments are aligned with 0-s
	; Character codes are located in the segments 
	; in such way that their offset is equal to the 
	; corresponding scan-code

    ; EN, No Shift pressed
    scan_table 		db 00h, 00h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 30h, 2Dh, 3Dh, 08h
					db 00h, 71h, 77h, 65h, 72h, 74h, 79h, 75h, 69h, 6Fh, 70h, 5Bh, 5Dh, 00h
					db 00h, 61h, 73h, 64h, 66h, 67h, 68h, 6Ah, 6Bh, 6Ch, 3Bh, 27h, 60h, 00h
					db 5Ch, 7Ah, 78h, 63h, 76h, 62h, 6Eh, 6Dh, 2Ch, 2Eh, 2Fh, 00h, 00h, 00h, 20h, 00h
    
    ; EN, Shift pressed
    shift_table 	db 00h, 00h, 21h, 40h, 23h, 24h, 25h, 5Eh, 26h, 2Ah, 28h, 29h, 5Fh, 2Bh, 08h
					db 00h, 51h, 57h, 45h, 52h, 54h, 59h, 55h, 49h, 4Fh, 50h, 7Bh, 7Dh, 00h
					db 00h, 41h, 53h, 44h, 46h, 47h, 48h, 4Ah, 4Bh, 4Ch, 3Ah, 22h, 7Eh, 00h
					db 7Ch, 5Ah, 58h, 43h, 56h, 42h, 4Eh, 4Dh, 3Ch, 3Eh, 3Fh, 00h, 00h, 00h, 20h, 00h
    
    ; RU, No Shift pressed
    rus_table 		db 00h, 00h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 30h, 2Dh, 3Dh, 08h
                    db 00h, 0A9h, 0E6h, 0E3h, 0AAh, 0A5h, 0ADh, 0A3h, 0E8h, 0E9h, 0A7h, 0E5h, 0EAh, 00h
                    db 00h, 0E4h, 0EBh, 0A2h, 0A0h, 0AFh, 0E0h, 0AEh, 0ABh, 0A4h, 0A6h, 0EDh, 0F1h, 00h
                    db 5Ch, 0EFh, 0E7h, 0E1h, 0ACh, 0A8h, 0E2h, 0ECh, 0A1h, 0EEh, 2Eh, 00h, 00h, 00h, 20h, 0
    
    ; RU, Shift pressed
    rus_shift_table db 00h, 00h, 21h, 22h, 23h, 3Bh, 25h, 3Ah, 3Fh, 2Ah, 28h, 29h, 5Fh, 2Bh, 08h
                    db 00h, 089h, 096h, 093h, 08Ah, 085h, 08Dh, 083h, 098h, 099h, 087h, 095h, 09Ah, 00h
                    db 00h, 094h, 09Bh, 082h, 080h, 08Fh, 090h, 08Eh, 08Bh, 084h, 086h, 09Dh, 0F2h, 00h
                    db 2Fh, 09Fh, 097h, 091h, 08Ch, 088h, 092h, 09Ch, 081h, 09Eh, 2Ch, 00h, 00h, 00h, 20h, 0
					
	; -------------------- CAPS LOCK ON ---------------------------
	
	; EN, No Shift pressed
    scan_table_caps 	db 00h, 00h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 30h, 2Dh, 3Dh, 08h
						db 00h, 51h, 57h, 45h, 52h, 54h, 59h, 55h, 49h, 4Fh, 50h, 5Bh, 5Dh, 00h
						db 00h, 41h, 53h, 44h, 46h, 47h, 48h, 4Ah, 4Bh, 4Ch, 3Bh, 27h, 60h, 00h
						db 7Ch, 5Ah, 58h, 43h, 56h, 42h, 4Eh, 4Dh, 2Ch, 2Eh, 2Fh, 00h, 00h, 00h, 20h, 00h
    
    ; EN, Shift pressed
    shift_table_caps 	db 00h, 00h, 21h, 40h, 23h, 24h, 25h, 5Eh, 26h, 2Ah, 28h, 29h, 5Fh, 2Bh, 08h
						db 00h, 71h, 77h, 65h, 72h, 74h, 79h, 75h, 69h, 6Fh, 70h, 7Bh, 7Dh, 00h
						db 00h, 61h, 73h, 64h, 66h, 67h, 68h, 6Ah, 6Bh, 6Ch, 3Ah, 22h, 7Eh, 00h
						db 5Ch, 7Ah, 78h, 63h, 76h, 62h, 6Eh, 6Dh, 3Ch, 3Eh, 3Fh, 00h, 00h, 00h, 20h, 00h
    
    ; RU, No Shift pressed
    rus_table_caps 		db 00h, 00h, 31h, 32h, 33h, 34h, 35h, 36h, 37h, 38h, 39h, 30h, 2Dh, 3Dh, 08h
						db 00h, 089h, 096h, 093h, 08Ah, 085h, 08Dh, 083h, 098h, 099h, 087h, 095h, 09Ah, 00h
						db 00h, 094h, 09Bh, 082h, 080h, 08Fh, 090h, 08Eh, 08Bh, 084h, 086h, 09Dh, 0F2h, 00h
						db 2Fh, 09Fh, 097h, 091h, 08Ch, 088h, 092h, 09Ch, 081h, 09Eh, 2Eh, 00h, 00h, 00h, 20h, 0
    
    ; RU, Shift pressed
    rus_shift_table_caps 	db 00h, 00h, 21h, 22h, 23h, 3Bh, 25h, 3Ah, 3Fh, 2Ah, 28h, 29h, 5Fh, 2Bh, 08h
							db 00h, 0A9h, 0E6h, 0E3h, 0AAh, 0A5h, 0ADh, 0A3h, 0E8h, 0E9h, 0A7h, 0E5h, 0EAh, 00h
							db 00h, 0E4h, 0EBh, 0A2h, 0A0h, 0AFh, 0E0h, 0AEh, 0ABh, 0A4h, 0A6h, 0EDh, 0F1h, 00h
							db 5Ch, 0EFh, 0E7h, 0E1h, 0ACh, 0A8h, 0E2h, 0ECh, 0A1h, 0EEh, 2Ch, 00h, 00h, 00h, 20h, 0
	
	; ------------------------- CTRL ON ------------------------------------
					
	; Ctrl pressed
	ctrl_table 		db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 1Eh, 00h, 00h, 00h, 00h, 1Fh, 00h, 7Fh    ; 00 - 0E
                    db 00h, 11h, 17h, 05h, 12h, 14h, 19h, 15h, 09h, 0Fh, 10h, 1Bh, 1Dh, 00h, 00h    ; 0F - 1D
                    db 00h, 01h, 13h, 04h, 06h, 07h, 08h, 0Ah, 0Bh, 0Ch, 00h, 1Ch				    ; 3A, 1E - 2B
                    db 1Ah, 18h, 03h, 16h, 17h, 02h, 0Eh, 0Dh, 00h, 00h, 00h, 00h, 0, 0				; 2C - do_pobednogo
    
    ; @brief   Interface messages
    msg_reading db 'Reading file... $'
    msg_parsing db 'Parsing scan-codes... $'
    msg_result  db 'Decoded text:',13,10,'$'
    msg_error   db 'Error while opening the file',13,10,'$'
    newline     db 13,10,'$'

.code
start:
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ; 1) OPEN FILE
    mov ax, 3D00h
    lea dx, filename
    int 21h
    mov handle, ax  ; 
    jc open_err     ; IF NOT OPEN, ERROR
  
read_block:
    ; 2.1) SET READER POSITION
    mov ax, 4200h   ; Offset from the beginning of file
    mov bx, handle
    ;mov cx, word ptr reader_pos+2
  mov cx, 0
    mov dx, word ptr reader_pos
    int 21h
    jc read_done    ; ERROR? DONE
  
    ; 2.2) READ BLOCK
    mov ah, 3Fh
    mov bx, handle
    mov cx, buf_size
    lea dx, buffer
    int 21h
    jc read_done    ; ERROR? DONE
  
	; Check for EOF (explicit)
    cmp ax, 0
    je read_done    ; If 0 bytes read - end of file
  
    ; INCREMENT POSITION
    mov ax, reader_pos
    add ax, buf_size
    mov reader_pos, ax
  
    ; 2.4) PARSE
    jmp parse_byte

parsing_done:
    jmp read_block

read_done:    
    jmp exit
  
open_err:
    mov ah, 9h
    lea dx, msg_error
    int 21h
    jmp exit
  
exit:
    mov ah, 3Eh     ; Close file
    mov bx, handle
    int 21h
    
    mov ah, 4Ch
    int 21h

; ================= PARSE BYTE ===================
parse_byte:
    mov cx, buf_size
  add cx, 1
    mov si, offset buffer
    mov buf_pos, 0
    
parse_loop:
    mov al, [si]        ; GET SCAN-CODE
    add si, 1
    add buf_pos, 1
    sub cx, 1
  jcxz parsing_done
    
    test al, 80h        ; PRESSED OR RELEASED?
    jnz k_rls
  jmp k_norls
k_rls:
    jmp key_release
k_norls:

key_press:
    ; CHECK FOR SPECIAL KEYS
    cmp al, sc_caps
    je tg_caps
  jmp notg_caps
tg_caps:
  jmp toggle_caps
notg_caps:


    cmp al, sc_lShift
    je st_lshift
  jmp nost_lshift
st_lshift:
  jmp set_lshift
nost_lshift:
  
    cmp al, sc_rShift
    je st_rshift
  jmp nost_rshift
st_rshift:
  jmp set_rshift
nost_rshift:
  
    cmp al, sc_lAlt
    je st_lalt
  jmp nost_lalt
st_lalt:
  jmp set_lalt
nost_lalt:
  
    cmp al, sc_rAlt
    je st_ralt
  jmp nost_ralt
st_ralt:
  jmp set_ralt
nost_ralt:
  
    cmp al, sc_lCtrl
    je st_lctrl
  jmp nost_lctrl
st_lctrl:
  jmp set_lctrl
nost_lctrl:
  
    cmp al, sc_rCtrl
    je st_rctrl
  jmp nost_rctrl
st_rctrl:
  jmp set_rctrl
nost_rctrl:
    
    ; CHECK FOR ESCAPE
    cmp al, 01h
    je st_esc
  jmp nost_esc
st_esc:
  jmp set_esc
;nost_esc:
    
    ; CHECK FOR LAYOUT SWITCHING
    ; Left Shift + Left Alt = EN layout
check_layout_EN:
    ;cmp L_SHIFT_PRESS, 1
    ;jne check_right_shift
    cmp L_ALT_PRESS, 1
    jne prs_lp
    mov layout, 0
    jmp parse_loop

check_layout_RU:
    ; Right Shift + Left Alt = RU layout  
    ;cmp R_SHIFT_PRESS, 1
    ;jne check_printable
    cmp L_ALT_PRESS, 1
    jne prs_lp
    mov layout, 1
    jmp parse_loop

nost_esc:
check_printable:
    ; IF ALT PRESSED - SKIP PRINTING
    cmp L_ALT_PRESS, 1
    je prs_lp
    cmp R_ALT_PRESS, 1
    je prs_lp
  jmp noprs_lp
    
prs_lp:
  jmp parse_loop
noprs_lp:
  
    ; PRINT CHARACTER
    jmp print_char

key_release:
    and al, 7Fh        ; CLEAR RELEASE BIT
	cmp al, sc_caps
	je unset_caps
    cmp al, sc_lShift
    je unset_lshift
    cmp al, sc_rShift
    je unset_rshift
    cmp al, sc_lAlt
    je unset_lalt
    cmp al, sc_rAlt
    je unset_ralt
    cmp al, sc_lCtrl
    je unset_lctrl
    cmp al, sc_rCtrl
    je unset_rctrl
    jmp parse_loop

toggle_caps:
    mov CAPS_ON, 1
    jmp parse_loop
	
unset_caps:
	mov CAPS_ON, 0
	jmp parse_loop

set_lshift:
    mov L_SHIFT_PRESS, 1
    ;jmp parse_loop
	jmp check_layout_EN

set_rshift:
    mov R_SHIFT_PRESS, 1
    ;jmp parse_loop
	jmp check_layout_ru

set_lalt:
    mov L_ALT_PRESS, 1
    jmp parse_loop

set_ralt:
    mov R_ALT_PRESS, 1
    jmp parse_loop

set_lctrl:
    mov L_CTRL_PRESS, 1
    jmp parse_loop

set_rctrl:
    mov R_CTRL_PRESS, 1
    jmp parse_loop

set_esc:
    mov ESC_PRESS, 1
    jmp parse_loop

unset_lshift:
    mov L_SHIFT_PRESS, 0
    jmp parse_loop

unset_rshift:
    mov R_SHIFT_PRESS, 0
    jmp parse_loop

unset_lalt:
    mov L_ALT_PRESS, 0
    jmp parse_loop

unset_ralt:
    mov R_ALT_PRESS, 0
    jmp parse_loop

unset_lctrl:
    mov L_CTRL_PRESS, 0
    jmp parse_loop

unset_rctrl:
    mov R_CTRL_PRESS, 0
    jmp parse_loop

; ================= PRINT CHAR ===================
print_char:
    ; DETERMINE SHIFT STATE
    ;mov bl, al          ; SAVE SCAN-CODE
	push ax
    
    ; CHECK CTRL PRESSED - USE SPECIAL LAYOUT
    cmp L_CTRL_PRESS, 1
    je ctrl_layout
    cmp R_CTRL_PRESS, 1
    je ctrl_layout
    
    ; CHECK SHIFT STATE
    mov al, L_SHIFT_PRESS
    or al, R_SHIFT_PRESS
    ;xor al, CAPS_ON     ; XOR WITH CAPS LOCK
    
	cmp CAPS_ON, 1
	je layouts_caps
	
    ; SELECT TABLE BASED ON LAYOUT AND SHIFT STATE
    cmp layout, 0
    je english_layout
    jmp russian_layout
layouts_caps:
	cmp layout, 0
    je english_layout_caps
    jmp russian_layout_caps

english_layout:
    test al, al
    jz en_no_shift
    lea bx, shift_table		; MARK: in previous version was loaded to DI
    jmp get_char

en_no_shift:
    lea bx, scan_table
    jmp get_char

russian_layout:
    test al, al
    jz ru_no_shift
    lea bx, rus_shift_table
    jmp get_char

ru_no_shift:
    lea bx, rus_table
    jmp get_char
	
	; ======== CAPS ======
	
english_layout_caps:
    test al, al
    jz en_no_shift_caps
    lea bx, shift_table_caps		; MARK: in previous version was loaded to DI
    jmp get_char

en_no_shift_caps:
    lea bx, scan_table_caps
    jmp get_char

russian_layout_caps:
    test al, al
    jz ru_no_shift_caps
    lea bx, rus_shift_table_caps
    jmp get_char

ru_no_shift_caps:
    lea bx, rus_table_caps
    jmp get_char

ctrl_layout:
    ; ADD SPECIAL CTRL CHARACTERS HANDLING HERE
    ; FOR NOW, JUST USE ENGLISH NO SHIFT
    lea bx, ctrl_table

get_char:
    ; GET CHARACTER FROM TABLE
    ;mov al, bl
	pop ax
    xlatb               ; AL = [DI + AL]
    
    ; SKIP IF ZERO
    test al, al
    jz prs_lp_2
  jmp noprs_lp_2
  
prs_lp_2:
  jmp parse_loop
noprs_lp_2:
    
    ; PRINT CHARACTER
    mov ah, 02h
    mov dl, al
    int 21h
    
    jmp parse_loop

end start
