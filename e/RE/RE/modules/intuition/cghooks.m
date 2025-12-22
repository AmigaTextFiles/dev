#ifndef INTUITION_CGHOOKS_H
#define INTUITION_CGHOOKS_H 1

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif

OBJECT GadgetInfo
 
     		Screen:PTR TO Screen
     		Window:PTR TO Window	
     		Requester:PTR TO Requester	
    
     		RastPort:PTR TO RastPort
     		Layer:PTR TO Layer
    
     			Domain:IBox
    
     OBJECT Pens

	DetailPen:UBYTE
	BlockPen:UBYTE
    				ENDOBJECT
    
     		DrInfo:PTR TO DrawInfo
    
    Reserved[6]:LONG
ENDOBJECT



OBJECT PGX
	
     	Container:IBox
     	NewKnob:IBox
ENDOBJECT


#define CUSTOM_HOOK ( gadget )  (    (gadget).MutualExclude)
#endif
