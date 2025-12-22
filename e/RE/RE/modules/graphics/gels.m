#ifndef	GRAPHICS_GELS_H
#define	GRAPHICS_GELS_H

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif


#define SUSERFLAGS  $00FF    
#define VSPRITE     $0001    
#define SAVEBACK    $0002    
#define OVERLAY     $0004    
#define MUSTDRAW    $0008    

#define BACKSAVED   $0100    
#define BOBUPDATE   $0200    
#define GELGONE     $0400    
#define VSOVERFLOW  $0800    


#define BUSERFLAGS  $00FF    
#define SAVEBOB     $0001    
#define BOBISCOMP   $0002    

#define BWAITING    $0100    
#define BDRAWN	    $0200    
#define BOBSAWAY    $0400    
#define BOBNIX	    $0800    
#define SAVEPRESERVE $1000   
#define OUTSTEP     $2000    

#define ANFRACSIZE  6
#define ANIMHALF    $0020
#define RINGTRIGGER $0001

#ifndef VUserStuff	      
#define VUserStuff WORD
#endif
#ifndef BUserStuff	      
#define BUserStuff WORD
#endif
#ifndef AUserStuff	      
#define AUserStuff WORD
#endif

OBJECT VSprite



        NextVSprite:PTR TO VSprite
        PrevVSprite:PTR TO VSprite

        DrawPath:PTR TO VSprite     
        ClearPath:PTR TO VSprite    

    OldY:WORD
 OldX:WORD	      

    Flags:WORD	      


    Y:WORD
 X:WORD		      
    Height:WORD
    Width:WORD	      
    Depth:WORD	      
    MeMask:WORD	      
    HitMask:WORD	      
    ImageData:PTR TO WORD	      

    BorderLine:PTR TO WORD	      
    CollMask:PTR TO WORD	      

    SprColors:PTR TO WORD
      VSBob:PTR TO Bob	      

    PlanePick:BYTE
    PlaneOnOff:BYTE
    VUserExt:VUserStuff      
ENDOBJECT

OBJECT Bob
{


    WORD Flags

    WORD *SaveBuffer

    WORD *ImageShadow


    OBJECT Bob
 Before
    OBJECT Bob
 After
    OBJECT VSprite
   BobVSprite  
    OBJECT AnimComp
  BobComp    
    OBJECT DBufPacket
 DBuffer    
    BUserStuff BUserExt    
}

OBJECT AnimComp



    Flags:WORD		    

    Timer:WORD


    TimeSet:WORD

       NextComp:PTR TO AnimComp
       PrevComp:PTR TO AnimComp

       NextSeq:PTR TO AnimComp
       PrevSeq:PTR TO AnimComp
    AnimCRoutine:WORD 
    YTrans:WORD     
    XTrans:WORD     
         HeadOb:PTR TO AnimOb
     	     AnimBob:PTR TO Bob
ENDOBJECT

OBJECT AnimOb


         NextOb:PTR TO AnimOb
 PrevOb:PTR TO AnimOb

    Clock:LONG
    AnOldY:WORD
 AnOldX:WORD	    

    AnY:WORD
 AnX:WORD		    

    YVel:WORD
 XVel:WORD		    
    YAccel:WORD
 XAccel:WORD	    
    RingYTrans:WORD
 RingXTrans:WORD    
    AnimORoutine:WORD	    
       HeadComp:PTR TO AnimComp     
    AUserExt:AUserStuff	    
ENDOBJECT


OBJECT DBufPacket

    BufY:WORD
 BufX:WORD		    
        BufPath:PTR TO VSprite	    


    BufBuffer:PTR TO WORD
ENDOBJECT



#define InitAnimate(animKey) {*(animKey) = NULL
#define RemBob(b) {(b).Flags OR= BOBSAWAY

#define B2NORM	    0
#define B2SWAP	    1
#define B2BOBBER    2


OBJECT collTable

    collPtrs[16]:LONG
ENDOBJECT

#endif	
