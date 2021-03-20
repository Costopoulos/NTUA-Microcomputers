INCLUDE MACROS.ASM
    .8086
    .MODEL SMALL
    .STACK 256    
;------DATA SEGMENT------------
.DATA
    TABLEA DB 16 DUP(?) ;we will store the numbers here
    TABLEB DB 16 DUP(?) ;we eill store the characters here
   
;------CODE SEGMENT------------    	   
.CODE
;----MAIN----------------------
MAIN PROC FAR
	 MOV AX,@DATA
	 MOV DS,AX 
START:            
     MOV DI,0  ;counter for the numbers
     MOV SI,0  ;counter fot the capital characters
     MOV CL,0  ;counter for the total characters (16)
     MOV DX,0  ;here we will store SI's value
      
LOOP_READ:   
     READ         
     CMP AL,13          ;13 is the  ASCII code for the enter key (carriage return)                 
     JE END_PROGRAM     ;if we press enter the program ends
     CMP AL,'0'                 
     JL LOOP_READ       ;if the input is unwanted character read again
     CMP AL,'9'
     JBE STORE_NUMBERS  ;if the ASCII code is bigger than zero's and below or equal nine's jump to STORE_NUMBERS
     CMP AL,'A'
     JL LOOP_READ        
     CMP AL,'Z' 
     JG LOOP_READ       ;if the character is neither number nor capital letter read again

STORE_CHARACTER:        ;else we have capital letter, so we store it
     
     MOV [TABLEB + SI], AL
     INC SI
     INC CL
     CMP CL,16                  
     JL LOOP_READ
     NEW_LINE
     MOV DX,SI
     MOV SI,0
     CMP DI,0
     JE  HERE
     JMP PRINT_THE_NUMBERS

STORE_NUMBERS:     
     MOV [TABLEA+DI],AL
     INC DI
     INC CL
     CMP CL,16                  
     JL LOOP_READ
     NEW_LINE
     MOV DX,SI
     MOV SI,0
      

PRINT_THE_NUMBERS:
     MOV AL, [TABLEA+SI]
     PRINT AL
     INC SI
     CMP SI, DI
     JL PRINT_THE_NUMBERS
     PRINT '-'
     CMP DX,0
     JE START_AGAIN      ;IF WE DON'T HAVE CHARACTERS
HERE:
     MOV DI,DX
     MOV SI,0 

SMALL_CHAR:
LOOP_SMALL_CHAR:
     MOV AL,[TABLEB + SI]                            
     ADD AL,32   
     PRINT AL    
     INC SI    
     CMP SI, DI
     JL  LOOP_SMALL_CHAR      

START_AGAIN:
     NEW_LINE      
     JMP START
END_PROGRAM:
    EXIT     
MAIN ENDP