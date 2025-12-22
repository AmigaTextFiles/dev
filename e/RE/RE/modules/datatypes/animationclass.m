#ifndef	DATATYPES_ANIMATIONCLASS_H
#define	DATATYPES_ANIMATIONCLASS_H

#ifndef	UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef	DATATYPES_DATATYPESCLASS_H
MODULE  'datatypes/datatypesclass'
#endif
#ifndef	DATATYPES_PICTURECLASS_H
MODULE  'datatypes/pictureclass'
#endif
#ifndef	DATATYPES_SOUNDCLASS_H
MODULE  'datatypes/soundclass'
#endif
#ifndef	LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define	ANIMATIONDTCLASS		'animation.datatype'


#define	ADTA_Dummy		(DTA_Dummy + 600)
#define	ADTA_ModeID		PDTA_ModeID
#define	ADTA_KeyFrame		PDTA_BitMap
	
#define	ADTA_ColorRegisters	PDTA_ColorRegisters
#define	ADTA_CRegs		PDTA_CRegs
#define	ADTA_GRegs		PDTA_GRegs
#define	ADTA_ColorTable		PDTA_ColorTable
#define	ADTA_ColorTable2	PDTA_ColorTable2
#define	ADTA_Allocated		PDTA_Allocated
#define	ADTA_NumColors		PDTA_NumColors
#define	ADTA_NumAlloc		PDTA_NumAlloc
#define	ADTA_Remap		PDTA_Remap
	
#define	ADTA_Screen		PDTA_Screen
	
#define	ADTA_NumSparse		PDTA_NumSparse
	
#define	ADTA_SparseTable	PDTA_SparseTable
	
#define	ADTA_Width		(ADTA_Dummy + 1)
#define	ADTA_Height		(ADTA_Dummy + 2)
#define	ADTA_Depth		(ADTA_Dummy + 3)
#define	ADTA_Frames		(ADTA_Dummy + 4)
	
#define	ADTA_Frame		(ADTA_Dummy + 5)
	
#define	ADTA_FramesPerSecond	(ADTA_Dummy + 6)
	
#define	ADTA_FrameIncrement	(ADTA_Dummy + 7)
	

#define	ADTA_Sample		SDTA_Sample
#define	ADTA_SampleLength	SDTA_SampleLength
#define	ADTA_Period		SDTA_Period
#define	ADTA_Volume		SDTA_Volume
#define	ADTA_Cycles		SDTA_Cycles

#define ID_ANIM	MAKE_ID("A","N","I","M")
#define ID_ANHD	MAKE_ID("A","N","H","D")
#define ID_DLTA	MAKE_ID("D","L","T","A")


OBJECT AnimHeader

    Operation:UBYTE	
    Mask:UBYTE	
    Width:UWORD	
    Height:UWORD	
				
    Left:WORD	
    Top:WORD	
    AbsTime:LONG	
    RelTime:LONG	
    Interleave:UBYTE	
    Pad0:UBYTE	
    Flags:LONG	
    Pad[16]:UBYTE	
ENDOBJECT


#define	ADTM_Dummy		$($700)
#define	ADTM_LOADFRAME		$($701)
    
#define	ADTM_UNLOADFRAME	$($702)
    
#define	ADTM_START		$($703)
    
#define	ADTM_PAUSE		$($704)
    
#define	ADTM_STOP		$($705)
    
#define	ADTM_LOCATE		$($706)
    


OBJECT adtFrame

    MethodID:LONG
    TimeStamp:LONG		
    
    
    Frame:LONG		
    Duration:LONG		
     	BitMap:PTR TO BitMap		
     	CMap:PTR TO ColorMap		
    Sample:PTR TO BYTE		
    SampleLength:LONG
    Period:LONG
    UserData:LONG		
ENDOBJECT


OBJECT adtStart

    MethodID:LONG
    Frame:LONG		
ENDOBJECT


#endif	
