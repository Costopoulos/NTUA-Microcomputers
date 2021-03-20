READ MACRO
    MOV AH,01 ; by 01 we read character from standard input, with echo 
    INT 21H   ; by 08 we read character from standard input, without echo
ENDM
;######################################
PRINT MACRO CHAR
    PUSH AX
    PUSH DX
    MOV DL,CHAR ; entry DL character to write
    MOV AH,2	; return AL last character output
    INT 21H
    POP DX
    POP AX
ENDM
;######################################
PRINT_STRING MACRO STRING ;WRITE STRING TO STANDARD OUTPUT
    PUSH AX
    PUSH DX
    MOV DX,OFFSET STRING ;Entry: DS:DX -> '$'-terminated string
    MOV AH,9  ;Return: AL = 24h
    INT 21H
    POP DX
    POP AX
ENDM
;######################################
EXIT MACRO  	;"EXIT" - TERMINATE WITH RETURN CODE
	MOV AX,4C00H  ;Entry: AL = return code
	INT 21H		;Return: never returns
ENDM
;######################################
NEW_LINE MACRO
	PUSH DX
	PUSH AX
	MOV DL, 0AH
	MOV AH, 2
	INT 21H
	MOV DL, 0DH
	MOV AH, 2
	INT 21H
	POP AX
	POP DX
ENDM
;######################################
READ_WITHOUT_PRINT MACRO  ;CHARACTER INPUT WITHOUT ECHO
    MOV AH,08	;Return: AL = character read from standard input
    INT 21H
ENDM
;######################################

READ_NO_WAIT MACRO
MOV AH, 06H
MOV DL, 255
INT 21H
ENDM

;PRINT_DEC MACRO
;ADD DL, 30H
;MOV AH,2
;INT 21H
;ENDM