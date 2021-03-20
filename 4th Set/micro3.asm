org 100h

.DATA

M1 DB 'x=', '$'
M2 DB ' y=', '$'
M3 DB 'x+y=', '$'
M4 DB ' x-y=', '$'

.CODE

PRINT MACRO CHAR
    PUSH AX
    PUSH DX ;store register values that will be changed
    MOV DL,CHAR
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM

PRINT_STR MACRO STRING
    PUSH AX
    PUSH DX
    MOV DX,OFFSET STRING
    MOV AH,9
    INT 21H
    POP DX
    POP AX
ENDM

NEWLINE MACRO
    PUSH BX
    MOV BL,13
    PRINT BL
    MOV BL,10 ;ASCII code for new line
    PRINT BL
    POP BX
ENDM


MAIN PROC FAR
  REPEAT:
    PRINT_STR M1 
    CALL HEX_KEYB
    MOV BL,AL
    SHL BL,4 ;shift MSBs in correct position
    CALL HEX_KEYB
    ADD BL,AL ;BL now contains x
    PRINT_STR M2
    CALL HEX_KEYB
    MOV CL,AL
    SHL CL,4 ;shift MSBs in correct position
    CALL HEX_KEYB
    ADD CL,AL ;CL now contains y
    NEWLINE
    PRINT_STR M3
    MOV BH,0
    MOV CH,0
    MOV AX,BX
    ADD AX,CX ;AX=x+y
    CALL PRINT_DEC ;print AX in decimal form
    PRINT_STR M4
    MOV AX,BX
    SUB AX,CX ;AX=x-y
    CMP BX,CX
    JAE POSITIVE
    PRINT "-" ;print '-' if negative
    NEG AX ;turn to positive
  POSITIVE:
    CALL PRINT_DEC
    NEWLINE
    JMP REPEAT
MAIN ENDP

HEX_KEYB PROC NEAR
  IGNORE:
    MOV AH,8
    INT 21H ;read from keyboard, result in AL
    CMP AL,30H ;check if it is a hex digit
    JL IGNORE  ;ASCII CODES 30H-39H and 41H-46H are hex digits
    CMP AL,46H
    JG IGNORE
    CMP AL,3AH
    JL FINISH1
    CMP AL,40H
    JG FINISH2
    JMP IGNORE
  FINISH1:
    PRINT AL ;print in hex form
    SUB AL,30H ;subtract 30H to convert character to hex digit (1-9)
    RET
  FINISH2:
    PRINT AL ;print in hex form
    SUB AL,37H ;subtract 37H to convert character to hex digit (A-F)
    RET    
HEX_KEYB ENDP

PRINT_DEC PROC NEAR
    PUSH BX
    CMP AX,10  ;skip hundreds and tens if AX<10
    JB ONES
    CMP AX,100 ;skip hundreds if AX<100
    JB TENS
    MOV BL,100
    DIV BL ;AL now contains hundreds, AH contains remainder
    ADD AL,30H ;ASCII code of digits 0-9
    PRINT AL ;print hundreds     
    MOV AL,AH ;AL now contains remainder (tens+ones)
  TENS:
    MOV AH,0
    MOV BL,10
    DIV BL ;AL now contains tens and AH contains ones
    ADD AL,30H ;ASCII code of digits 0-9
    PRINT AL
    MOV AL,AH
  ONES:
    ADD AL,30H ;ASCII code of digits 0-9  
    PRINT AL
    POP BX
    RET   
PRINT_DEC ENDP

ret