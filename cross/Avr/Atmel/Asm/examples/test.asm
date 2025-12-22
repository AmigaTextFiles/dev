 .include "io2313.h"

AAA equ 1
BBB equ AAA
CCC equ L4+1
DDD equ (L2*2)&255
eee equ (L2*2)>8

ONE equ %1
TWO equ %10
THREE equ one + two
four equ 100b
five equ 5
six  equ three* 2
seven equ three*2+1
sixteen equ 10h
seventeen equ sixteen +$1

 .org RESET_VECT

 rjmp ROMSTART

 .org ROMSTART
 
START:
 ADD R16,R19 
 ADIW R30,$5   
 ADIW R28,$20   
 ADC R16,R31  
 ADIW R30,$20 
 SUB R16,R31  
 SUBI R16,$20  
 SBIW R30,$20 
 SBC R16,R31  
 SBCI R16,$20  
 AND R16,R31  
 ANDI R16,$20  
 OR R16,R31                        
 ORI R16,$20   
 EOR R16,R31  
 COM R16     
 NEG R16     
 SBR R16,$20   
 CBR R16,$20   
 INC R16     
 DEC R16     
 TST R16     
 CLR R16     
 SER R16     
 RJMP L1     
 IJMP      
 RCALL L1    
 ICALL     
 RET       
 RETI      
 CPSE R16,R31 
 CP R16,R31   
 CPC R16,R31  
 CPI R16,$20   
 SBRC R31,1  
 SBRS R31,2  
 SBIC 11,3   
 SBIS 12,4   
 BRBS 5,L2   
 BRBC 6,L3   
 BREQ L4     
 BRNE L4      
 BRCS L4     
 BRCC L4     
 BRSH L4     
 BRLO L4     
 BRMI L4     
 BRPL L4     
 BRGE L4     
 BRLT L4     
 BRHS L4     
 BRHC L4     
 BRTS L4     
 BRTC L4     
 BRVS L4     
 BRVC L4     
 BRIE L4     
 BRID L4     
 MOV R16,R31  
L2:
 LDI R16,$20   
L1:
L3:
L4:
L5:
 LD R16,X    
 LD R16,X+   
 LD R16,-X   
 LD R16,Y    
 LD R16,Y+   
 LD R16,-Y   
 LDD R16,Y+1 
 LD R16,Z    
 LD R16,Z+   
 LD R16,-Z   
 LDD R16,Z+0 
 LDS R16,L5   
 ST X,R31    
 ST X+,R31   
 ST -X,R31   
 ST Y,R31    
 ST Y+,R31   
 ST -Y,R31   
 STD Y+2,R31 
 ST Z,R31    
 ST Z+,R31   
 ST -Z,R31   
 STD Z+3,R31 
 STS 34,R31   
 LPM       
 IN R16,PINB    
 OUT DDRB,R31   
 PUSH R31    
 POP R16     
 SBI $10,5    
 CBI $11,7    
 LSL R16     
 LSR R16     
 ROL R16     
 ROR R16     
 ASR R16     
 SWAP R16    
 BSET 1     
 BCLR 0     
 BST R31,0   
 BLD R16,7   
 SEC       
 CLC       
 SEN       
 CLN       
 SEZ       
 CLZ       
 SEI       
 CLI       
 SES       
 CLS       
 SEV       
 CLV       
 SET       
 CLT       
 SEH       
 CLH       
 NOP       
 SLEEP     
 WDR       
gita:
 .db $aa,$aa,$aa,$aa,$aa,1,2,3,4,5,6,7,8,9
 .dw $aa55,$1122
 .db "Hello"

gitb:

