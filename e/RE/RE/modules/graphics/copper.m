#ifndef GRAPHICS_COPPER_H
#define GRAPHICS_COPPER_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#define COPPER_MOVE 0	    
#define COPPER_WAIT 1	    
#define CPRNXTBUF   2	    
#define CPR_NT_LOF  $8000  
#define CPR_NT_SHT  $4000  
#define CPR_NT_SYS  $2000  
OBJECT CopIns

    OpCode:WORD 
        UNION u3

	      nxtlist:PTR TO CopList
	    	OBJECT u4

						UNION u1

				VWaitPos:WORD	      
				DestAddr:WORD	      
			 ENDUNION
						UNION u2

				HWaitPos:WORD	      
				DestData:WORD	      
			 ENDUNION
		 ENDOBJECT
     ENDUNION
ENDOBJECT


#define NXTLIST     u3.nxtlist
#define VWAITPOS    u3.u4.u1.VWaitPos
#define DESTADDR    u3.u4.u1.DestAddr
#define HWAITPOS    u3.u4.u2.HWaitPos
#define DESTDATA    u3.u4.u2.DestData

OBJECT cprlist

      Next:PTR TO cprlist
    start:PTR TO UWORD	    
    MaxCount:WORD	   
ENDOBJECT

OBJECT CopList

       Next:PTR TO CopList  
       CopList:PTR TO CopList	
       ViewPort:PTR TO ViewPort    
       CopIns:PTR TO CopIns 
       CopPtr:PTR TO CopIns 
    CopLStart:PTR TO UWORD     
    CopSStart:PTR TO UWORD     
    Count:WORD	   
    MaxCount:WORD	   
    DyOffset:WORD	   
#ifdef V1_3
    Cop2Start:PTR TO UWORD
    Cop3Start:PTR TO UWORD
    Cop4Start:PTR TO UWORD
    Cop5Start:PTR TO UWORD
#endif
    SLRepeat:UWORD
    Flags:UWORD
ENDOBJECT


#define EXACT_LINE 1
#define HALF_LINE 2
OBJECT UCopList

      Next:PTR TO UCopList
       FirstCopList:PTR TO CopList 
       CopList:PTR TO CopList	   
ENDOBJECT


OBJECT copinit

    vsync_hblank[2]:UWORD
    diagstrt[12]:UWORD      
    fm0[2]:UWORD
    diwstart[10]:UWORD
    bplcon2[2]:UWORD
	sprfix[16]:UWORD
    sprstrtup[32]:UWORD
    wait14[2]:UWORD
    norm_hblank[2]:UWORD
    jump[2]:UWORD
    wait_forever[6]:UWORD
    sprstop[8]:UWORD
ENDOBJECT

#endif	
