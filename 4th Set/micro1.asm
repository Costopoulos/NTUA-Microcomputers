INCLUDE MACROS.ASM

DATA_SEG SEGMENT
    
DATA_SEG ENDS

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG,DS:DATA_SEG
    EQUAL DB "=$"
MAIN PROC FAR
	MOV AX,DATA_SEG
    MOV DS,AX 
START:
     ;FIRST HEX DIGIT		
     CALL HEX_KEYB
     CMP AL,'T'         
     JE QUIT           		;if input is 'T' terminate 
     ROL AL,4  			;multiply x10 and 
     MOV DL,AL   		;put input in BL register
     
     ;SECOND HEX DIGIT
     CALL HEX_KEYB
     CMP AL,'T'
     JE QUIT
     PRINT '='
     ADD DL,AL 			;add units in BL and now BL has the right hex number
     PUSH DX 			;save BL for use in proc "PRINT_OCT"
        
     ;NEW_LINE
     CALL PRINT_DEC
     PRINT '='
     POP DX 			;restore BL for use in "PRINT_OCT"
     PUSH DX			;save BL for use in proc "PRINT_BIN" 
     CALL PRINT_OCT
     PRINT '='
     POP DX 			;restore BL for use in "PRINT_BIN"
     CALL PRINT_BIN

     JMP START
QUIT:
    EXIT     
MAIN ENDP


HEX_KEYB PROC NEAR

    PUSH DX ;DX value changes because of PRINT
IGNORE:
	;check for valid number
    READ
    CMP AL,30H			;if ASCIIcode < 30 ('0') don't accept it
    JL IGNORE
    CMP AL,39H			;if ASCIIcode < 39 ('9') chech for valid character
    JG ADDR1
    SUB AL,30H			;if 30 < ASCIIcode < 39 subtract 30 to make hex number
    JMP ADDR2
ADDR1: 
	;check for valid character       
    CMP AL,'T'			;if ASCIIcode = 'T' accept it
    JE ADDR2
    CMP AL,'A'			;if ASCIIcode < 'A' don't accept it
    JL IGNORE
    CMP AL,'F'			;if ASCIIcode > 'F' don't accept it
    JG IGNORE
    SUB AL,37H			;if 'A' < ASCIIcode < 'F' subtract 37 to make hex number
ADDR2:
    POP DX
    RET
HEX_KEYB ENDP   

PRINT_DEC PROC NEAR
;input: number in BL 
;output: print the decimal number
    MOV AH,0
    MOV AL,DL 			;AX = 00000000xxxxxxxx(8 bit number to be printed)
    MOV DL,10 	
    MOV CX,1 			;decades counter
LOOP_10: 
    DIV DL			;divide number with 10
    PUSH AX             	;save units     
    CMP AL,0 			;if quotient zero I have splitted 
    JE PRINT_DIGITS_10  	;the whole number into dec digits     
    INC CX			;increase number of decades
    MOV AH,0   
    JMP LOOP_10			;if quotient is not zero I have to divide again
PRINT_DIGITS_10:
    POP DX			;pop dec digit to be printed
    MOV DL,DH
    MOV DH,0			;DX = 00000000xxxxxxxx (ASCII of number to be printed)
    ADD DX,30H			;make ASCII code
    MOV AH,2
    INT 21H			;print
    LOOP PRINT_DIGITS_10	;Loop for all digits        
    RET
ENDP PRINT_DEC          

PRINT_OCT PROC NEAR
;input: number in BL 
;output: print the octal number
    MOV AH,0
    MOV AL,DL 
    MOV DL,8 
    MOV CX,1 
LOOP_8: 
    DIV DL
    PUSH AX                  
    CMP AL,0 
    JE GOOUT_8              
    INC CX
    MOV AH,0   
    JMP LOOP_8
GOOUT_8: 
    MOV DH,AL
    PUSH DX   
    
    POP DX
PRINT_DIGITS_8:
    POP DX
    MOV DL,DH
    MOV DH,0
    ADD DX,30H
    MOV AH,2
    INT 21H
    LOOP PRINT_DIGITS_8       
    RET
ENDP PRINT_OCT       

PRINT_BIN PROC NEAR
;input: number in BL 
;output: print the binary number
    MOV AH,0
    MOV AL,DL 
    MOV DL,2 
    MOV CX,1 
LOOP_2: 
    DIV DL
    PUSH AX                  
    CMP AL,0 
    JE GOOUT_2              
    INC CX
    MOV AH,0   
    JMP LOOP_2
GOOUT_2: 
    MOV DH,AL
    PUSH DX   
    
    POP DX
PRINT_DIGITS_2:
    POP DX
    MOV DL,DH
    MOV DH,0
    ADD DX,30H
    MOV AH,2
    INT 21H
    LOOP PRINT_DIGITS_2
    NEW_LINE       
    RET
ENDP PRINT_BIN 