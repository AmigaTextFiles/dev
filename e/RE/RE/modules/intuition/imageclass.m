#ifndef INTUITION_IMAGECLASS_H
#define INTUITION_IMAGECLASS_H TRUE

#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif

#define CUSTOMIMAGEDEPTH	(-1)


#define GADGET_BOX ( g )	 (    &(  (g)).LeftEdge )
#define IM_BOX ( im )	 (    &(  (im)).LeftEdge )
#define IM_FGPEN ( im )	 ( (im).PlanePick )
#define IM_BGPEN ( im )	 ( (im).PlaneOnOff )

#define IA_Dummy		(TAG_USER + $20000)
#define IA_Left			(IA_Dummy + $01)
#define IA_Top			(IA_Dummy + $02)
#define IA_Width		(IA_Dummy + $03)
#define IA_Height		(IA_Dummy + $04)
#define IA_FGPen		(IA_Dummy + $05)
		    
#define IA_BGPen		(IA_Dummy + $06)
		    
#define IA_Data			(IA_Dummy + $07)
		    
#define IA_LineWidth		(IA_Dummy + $08)
#define IA_Pens			(IA_Dummy + $0E)
		    
#define IA_Resolution		(IA_Dummy + $0F)
		    


#define IA_APattern		(IA_Dummy + $10)
#define IA_APatSize		(IA_Dummy + $11)
#define IA_Mode			(IA_Dummy + $12)
#define IA_Font			(IA_Dummy + $13)
#define IA_Outline		(IA_Dummy + $14)
#define IA_Recessed		(IA_Dummy + $15)
#define IA_DoubleEmboss		(IA_Dummy + $16)
#define IA_EdgesOnly		(IA_Dummy + $17)

#define SYSIA_Size		(IA_Dummy + $0B)
		    
#define SYSIA_Depth		(IA_Dummy + $0C)
		    
#define SYSIA_Which		(IA_Dummy + $0D)
		    
#define SYSIA_DrawInfo		(IA_Dummy + $18)
		    

#define SYSIA_Pens		IA_Pens
#define IA_ShadowPen		(IA_Dummy + $09)
#define IA_HighlightPen		(IA_Dummy + $0A)

#define SYSIA_ReferenceFont	(IA_Dummy + $19)
		    
#define IA_SupportsDisable	(IA_Dummy + $1a)
		    
#define IA_FrameType		(IA_Dummy + $1b)
		    



#define SYSISIZE_MEDRES	0
#define SYSISIZE_LOWRES	1
#define SYSISIZE_HIRES	2

#define DEPTHIMAGE	$00	
#define ZOOMIMAGE	$01	
#define SIZEIMAGE	$02	
#define CLOSEIMAGE	$03	
#define SDEPTHIMAGE	$05	
#define LEFTIMAGE	$0A	
#define UPIMAGE		$0B	
#define RIGHTIMAGE	$0C	
#define DOWNIMAGE	$0D	
#define CHECKIMAGE	$0E	
#define MXIMAGE		$0F	

#define	MENUCHECK	$10	
#define AMIGAKEY	$11	

#define FRAME_DEFAULT		0
#define FRAME_BUTTON		1
#define FRAME_RIDGE		2
#define FRAME_ICONDROPBOX	3

#define    IM_DRAW	$202	
#define    IM_HITTEST	$203	
#define    IM_ERASE	$204	
#define    IM_MOVE	$205	
#define    IM_DRAWFRAME	$206	
#define    IM_FRAMEBOX	$207	
#define    IM_HITFRAME	$208	
#define    IM_ERASEFRAME $209	


#define    IDS_NORMAL		0
#define    IDS_SELECTED		1	
#define    IDS_DISABLED		2	
#define	   IDS_BUSY		3	
#define    IDS_INDETERMINATE	4	
#define    IDS_INACTIVENORMAL	5	
#define    IDS_INACTIVESELECTED	6	
#define    IDS_INACTIVEDISABLED	7	
#define	   IDS_SELECTEDDISABLED 8	

#define IDS_INDETERMINANT IDS_INDETERMINATE

OBJECT impFrameBox
 
    MethodID:LONG
     	ContentsBox:PTR TO IBox	
     	FrameBox:PTR TO IBox		
     	DrInfo:PTR TO DrawInfo	
    FrameFlags:LONG
ENDOBJECT

#define FRAMEF_SPECIFY	(1<<0)	

OBJECT impDraw
 
    MethodID:LONG
     	RPort:PTR TO RastPort
     OBJECT Offset

	X:WORD
	Y:WORD
    			ENDOBJECT
    State:LONG
     	DrInfo:PTR TO DrawInfo	
    
     OBJECT Dimensions

	Width:WORD
	Height:WORD
    			ENDOBJECT
ENDOBJECT



OBJECT impErase
 
    MethodID:LONG
     	RPort:PTR TO RastPort
      Offset:Offset
     Dimensions:Dimensions

ENDOBJECT


OBJECT impHitTest
 
    MethodID:LONG
     OBJECT Point

	X:WORD
	Y:WORD
    			ENDOBJECT
    
     Dimensions:Dimensions
ENDOBJECT


#ifndef INTUITION_IOBSOLETE_H
->MODULE  'intuition/iobsolete'
#endif
#endif
