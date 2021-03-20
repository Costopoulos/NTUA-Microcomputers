org 100h

.DATA

M1 DB 'START (Y,N): ', '$'
M2 DB 'ERROR', '$'

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
  IGNORE_INP:
    MOV AH,8
    INT 21H ;read Y or N
    CMP AL,78 ;N
    JNE CONTINUE
    PRINT AL ;print N
    MOV AX,4C00H ;end
    INT 21H
  CONTINUE:
    CMP AL,89 ;Y
    JNE IGNORE_INP ;ignore input if it isn't N or Y
    PRINT AL ;print Y    
    NEWLINE
    CALL HEX_KEYB ;read first hex digit
    MOV AH,0
    SHL AX,8 ;shift bits in correct position
    MOV BX,AX
    CALL HEX_KEYB ;read second hex digit
    MOV AH,0
    SHL AX,4 ;shift bits in correct position
    ADD BX,AX
    CALL HEX_KEYB ;read third hex digit
    NEWLINE
    MOV AH,0
    ADD AX,BX ;AX now contains 3-digit (hex) input
    MOV BX,10
    MUL BX ;multiply AX by 10 so that we can have one decimal digit in final result
    CMP AX,20470
    JBE CASE1
    CMP AX,36850
    JBE CASE2
    JMP CASE3 ;else case 3
  CASE1:
    MOV BX,200
    MUL BX
    MOV BX,819
    DIV BX
    JMP FINISH
  CASE2:
    MOV BX,100
    MUL BX
    MOV BX,819
    DIV BX
    ADD AX,2500
    JMP FINISH
  CASE3:
    MOV BX,600
    MUL BX
    MOV BX,819
    DIV BX
    SUB AX,20000
    CMP AX,9999
    JBE FINISH
    PRINT_STR M2 ;error
    NEWLINE
    JMP REPEAT   
  FINISH:
    CALL PRINT_DEC  
    NEWLINE
    JMP REPEAT
MAIN ENDP

INPUT PROC NEAR
    
    RET    
INPUT ENDP

HEX_KEYB PROC NEAR
  IGNORE:
    MOV AH,8
    INT 21H ;read from keyboard, result in AL
    CMP AL,78 ;N
    JNE CONTINUE2
    PRINT AL ;print N
    MOV AX,4C00H ;end
    INT 21H
  CONTINUE2:
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
    CMP AX,100
    JB ONES ;skip hundreds and tens
    CMP AX,1000
    JB TENS ;skip hundreds
    MOV BX,1000
    MOV DX,0 ;for division
    DIV BX
    ADD AL,30H ;ASCII code of digits 0-9
    PRINT AL ;print hundreds
    MOV AX,DX ;remainder
  TENS:
    MOV BX,100
    MOV DX,0 ;for division
    DIV BX
    ADD AL,30H ;ASCII code of digits 0-9
    PRINT AL ;print tens
    MOV AX,DX ;remainder
  ONES:
    MOV BX,10
    MOV DX,0 ;for division
    DIV BX
    ADD AL,30H ;ASCII code of digits 0-9
    PRINT AL ;print ones
    MOV AX,DX ;remainder
    PRINT '.'
    ADD AL,30H
    PRINT AL ;print decimal digit
    RET    
PRINT_DEC ENDP

ret
