#ifndef INTUITION_INTUITIONBASE_H
#define INTUITION_INTUITIONBASE_H 1

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif
#ifndef EXEC_INTERRUPTS_H
MODULE  'exec/interrupts'
#endif

#define DMODECOUNT	$0002	
#define HIRESPICK	$0000
#define LOWRESPICK	$0001
#define EVENTMAX 10		

#define RESCOUNT	2
#define HIRESGADGET	0
#define LOWRESGADGET	1
#define GADGETCOUNT	8
#define UPFRONTGADGET	0
#define DOWNBACKGADGET	1
#define SIZEGADGET	2
#define CLOSEGADGET	3
#define DRAGGADGET	4
#define SUPFRONTGADGET	5
#define SDOWNBACKGADGET	6
#define SDRAGGADGET	7





OBJECT IntuitionBase

      LibNode:Library
      ViewLord:View
      ActiveWindow:PTR TO Window
      ActiveScreen:PTR TO Screen
    
      FirstScreen:PTR TO Screen 
    Flags:LONG	
    MouseY:WORD
 MouseX:WORD
			
    Seconds:LONG	
    Micros:LONG	
    
ENDOBJECT

#endif
