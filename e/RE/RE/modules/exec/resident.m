#ifndef  EXEC_RESIDENT_H
#define  EXEC_RESIDENT_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif 
OBJECT Resident
 
    MatchWord:UWORD  
      MatchTag:PTR TO Resident 
    EndSkip:LONG     
    Flags:UBYTE      
    Version:UBYTE    
    Type:UBYTE    
    Pri:BYTE      
    Name:LONG     
    IdString:LONG 
    Init:LONG     
ENDOBJECT

#define RTC_MATCHWORD   $4AFC 
#define RTF_AUTOINIT 128
#define RTF_AFTERDOS 4
#define RTF_SINGLETASK  2
#define RTF_COLDSTART   1


#define RTW_NEVER 0
#define RTW_COLDSTART   1
#endif   
