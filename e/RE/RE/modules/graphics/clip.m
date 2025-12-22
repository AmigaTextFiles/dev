#ifndef	GRAPHICS_CLIP_H
#define	GRAPHICS_CLIP_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif
#ifndef EXEC_SEMAPHORES_H
MODULE  'exec/semaphores'
#endif
#ifndef UTILITY_HOOKS_H
MODULE  'utility/hooks'
#endif
#define NEWLOCKS
OBJECT Layer

       front:PTR TO Layer
back:PTR TO Layer
      	ClipRect:PTR TO ClipRect  
      	rp:PTR TO RastPort
      	bounds:Rectangle
    reserved[4]:UBYTE
    priority:UWORD		    
    Flags:UWORD		    
       SuperBitMap:PTR TO BitMap
       SuperClipRect:PTR TO ClipRect 
				  
    Window:LONG		  
    X:WORD
Y:WORD
       cr:PTR TO ClipRect
cr2:PTR TO ClipRect
crnew:PTR TO ClipRect	
       SuperSaveClipRects:PTR TO ClipRect 
       cliprects:PTR TO ClipRect	
      	LayerInfo:PTR TO Layer_Info	
       Lock:SignalSemaphore
       BackFill:PTR TO Hook
    reserved1:LONG
       ClipRegion:PTR TO Region
       saveClipRects:PTR TO Region	
    Width:WORD
Height:WORD		
    reserved2[18]:UBYTE
    
        DamageList:PTR TO Region    
ENDOBJECT

OBJECT ClipRect

       Next:PTR TO ClipRect	    
       prev:PTR TO ClipRect	    
         lobs:PTR TO Layer	    
        BitMap:PTR TO BitMap	    
      	bounds:Rectangle     
    p1:PTR TO LONG		    
    p2:PTR TO LONG		    
    reserved:LONG		    
#ifdef NEWCLIPRECTS_1_1
    Flags:LONG		    
				    
#endif				    
ENDOBJECT


#define CR_NEEDS_NO_CONCEALED_RASTERS  1
#define CR_NEEDS_NO_LAYERBLIT_DAMAGE   2

#define ISLESSX 1
#define ISLESSY 2
#define ISGRTRX 4
#define ISGRTRY 8
#endif	
