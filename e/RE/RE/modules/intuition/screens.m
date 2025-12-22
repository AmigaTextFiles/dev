#ifndef INTUITION_SCREENS_H
#define INTUITION_SCREENS_H TRUE

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef GRAPHICS_GFX_H
MODULE  'graphics/gfx'
#endif
#ifndef GRAPHICS_CLIP_H
MODULE  'graphics/clip'
#endif
#ifndef GRAPHICS_VIEW_H
MODULE  'graphics/view'
#endif
#ifndef GRAPHICS_RASTPORT_H
MODULE  'graphics/rastport'
#endif
#ifndef GRAPHICS_LAYERS_H
MODULE  'graphics/layers'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif






#define DRI_VERSION	2
OBJECT DrawInfo

    Version:UWORD	
    NumPens:UWORD	
    Pens:PTR TO UWORD	
     	Font:PTR TO TextFont	
    Depth:UWORD	
     OBJECT Resolution
	  
	X:UWORD
	Y:UWORD
    		ENDOBJECT
    Flags:LONG		

     	CheckMark:PTR TO Image	
     	AmigaKey:PTR TO Image	
    Reserved[5]:LONG	
ENDOBJECT

#define DRIF_NEWLOOK	$00000001	

#define DETAILPEN	 $0000	
#define BLOCKPEN	 $0001	
#define TEXTPEN		 $0002	
#define SHINEPEN	 $0003	
#define SHADOWPEN	 $0004	
#define FILLPEN		 $0005	
#define FILLTEXTPEN	 $0006	
#define BACKGROUNDPEN	 $0007	
#define HIGHLIGHTTEXTPEN $0008	

#define BARDETAILPEN	 $0009	
#define BARBLOCKPEN	 $000A	
#define BARTRIMPEN	 $000B	
#define NUMDRIPENS	 $000C

#define PEN_C3		$FEFC		
#define PEN_C2		$FEFD		
#define PEN_C1		$FEFE		
#define PEN_C0		$FEFF		




OBJECT Screen

      NextScreen:PTR TO Screen		
      FirstWindow:PTR TO Window		
    LeftEdge:WORD
 TopEdge:WORD		
    Width:WORD
 Height:WORD			
    MouseY:WORD
 MouseX:WORD		
    Flags:UWORD			
    Title:PTR TO UBYTE			
    DefaultTitle:PTR TO UBYTE		
    
    
    BarHeight:BYTE
 BarVBorder:BYTE
 BarHBorder:BYTE
 MenuVBorder:BYTE
 MenuHBorder:BYTE
    WBorTop:BYTE
 WBorLeft:BYTE
 WBorRight:BYTE
 WBorBottom:BYTE
      Font:PTR TO TextAttr		
    
      ViewPort:ViewPort		
      RastPort:RastPort		
      BitMap:BitMap		
      LayerInfo:Layer_Info	
    
      FirstGadget:PTR TO Gadget
    DetailPen:UBYTE
 BlockPen:UBYTE		
    
    SaveColor0:UWORD
    
      BarLayer:PTR TO Layer
    ExtData:PTR TO UBYTE
    UserData:PTR TO UBYTE	
    
ENDOBJECT



#define SCREENTYPE	$000F	

#define WBENCHSCREEN	$0001	
#define PUBLICSCREEN	$0002	
#define CUSTOMSCREEN	$000F	
#define SHOWTITLE	$0010	
#define BEEPING		$0020	
#define CUSTOMBITMAP	$0040	
#define SCREENBEHIND	$0080	
#define SCREENQUIET	$0100	
#define SCREENHIRES	$0200	
#define NS_EXTENDED	$1000		

#define AUTOSCROLL	$4000	

#define PENSHARED	$0400	
#define STDSCREENHEIGHT -1	
#define STDSCREENWIDTH -1	


#define SA_Dummy	(TAG_USER + 32)

#define SA_Left		(SA_Dummy + $0001)
#define SA_Top		(SA_Dummy + $0002)
#define SA_Width	(SA_Dummy + $0003)
#define SA_Height	(SA_Dummy + $0004)
			
#define SA_Depth	(SA_Dummy + $0005)
			
#define SA_DetailPen	(SA_Dummy + $0006)
			
#define SA_BlockPen	(SA_Dummy + $0007)
#define SA_Title	(SA_Dummy + $0008)
			
#define SA_Colors	(SA_Dummy + $0009)
			
#define SA_ErrorCode	(SA_Dummy + $000A)
			
#define SA_Font		(SA_Dummy + $000B)
			
#define SA_SysFont	(SA_Dummy + $000C)
			
#define SA_Type		(SA_Dummy + $000D)
			
#define SA_BitMap	(SA_Dummy + $000E)
			
#define SA_PubName	(SA_Dummy + $000F)
			
#define SA_PubSig	(SA_Dummy + $0010)
#define SA_PubTask	(SA_Dummy + $0011)
			
#define SA_DisplayID	(SA_Dummy + $0012)
			
#define SA_DClip	(SA_Dummy + $0013)
			
#define SA_Overscan	(SA_Dummy + $0014)
			
#define SA_Obsolete1	(SA_Dummy + $0015)
			

#define SA_ShowTitle	(SA_Dummy + $0016)
			
#define SA_Behind	(SA_Dummy + $0017)
			
#define SA_Quiet	(SA_Dummy + $0018)
			
#define SA_AutoScroll	(SA_Dummy + $0019)
			
#define SA_Pens		(SA_Dummy + $001A)
			
#define SA_FullPalette	(SA_Dummy + $001B)
			
#define SA_ColorMapEntries (SA_Dummy + $001C)
			
#define SA_Parent	(SA_Dummy + $001D)
			
#define SA_Draggable	(SA_Dummy + $001E)
			
#define SA_Exclusive	(SA_Dummy + $001F)
			
#define SA_SharePens	(SA_Dummy + $0020)
			
#define SA_BackFill	(SA_Dummy + $0021)
			
#define SA_Interleaved	(SA_Dummy + $0022)
			
#define SA_Colors32	(SA_Dummy + $0023)
			
#define SA_VideoControl	(SA_Dummy + $0024)
			
#define SA_FrontChild	(SA_Dummy + $0025)
			
#define SA_BackChild	(SA_Dummy + $0026)
			
#define SA_LikeWorkbench	(SA_Dummy + $0027)
			
#define SA_Reserved		(SA_Dummy + $0028)
			
#define SA_MinimizeISG		(SA_Dummy + $0029)
			

#ifndef NSTAG_EXT_VPMODE
#define NSTAG_EXT_VPMODE (TAG_USER OR 1)
#endif

#define OSERR_NOMONITOR	   1	
#define OSERR_NOCHIPS	   2	
#define OSERR_NOMEM	   3	
#define OSERR_NOCHIPMEM	   4	
#define OSERR_PUBNOTUNIQUE 5	
#define OSERR_UNKNOWNMODE  6	
#define OSERR_TOODEEP	   7	
#define OSERR_ATTACHFAIL   8	
#define OSERR_NOTAVAILABLE 9	




OBJECT NewScreen

    LeftEdge:WORD
 TopEdge:WORD
 Width:WORD
 Height:WORD
 Depth:WORD  
    DetailPen:UBYTE
 BlockPen:UBYTE	
    ViewModes:UWORD		
    Type:UWORD			
      Font:PTR TO TextAttr	
    DefaultTitle:PTR TO UBYTE	
      Gadgets:PTR TO Gadget	
    
      CustomBitMap:PTR TO BitMap
ENDOBJECT


OBJECT ExtNewScreen

    LeftEdge:WORD
 TopEdge:WORD
 Width:WORD
 Height:WORD
 Depth:WORD
    DetailPen:UBYTE
 BlockPen:UBYTE
    ViewModes:UWORD
    Type:UWORD
      Font:PTR TO TextAttr
    DefaultTitle:PTR TO UBYTE
      Gadgets:PTR TO Gadget
      CustomBitMap:PTR TO BitMap
     	Extension:PTR TO TagItem
				
ENDOBJECT


#define OSCAN_TEXT	1	
#define OSCAN_STANDARD	2	
#define OSCAN_MAX	3	
#define OSCAN_VIDEO	4	


OBJECT PubScreenNode
	
     		Node:Node	
     	Screen:PTR TO Screen
    Flags:UWORD	
    Size:WORD	
    VisitorCount:WORD 
     		SigTask:PTR TO Task	
    SigBit:UBYTE	
ENDOBJECT

#define PSNF_PRIVATE	$0001

#define MAXPUBSCREENNAME	139	

#define SHANGHAI	$0001	
#define POPPUBSCREEN	$0002	


#define	SDEPTH_TOFRONT			0	
#define SDEPTH_TOBACK		1	
#define SDEPTH_INFAMILY		2	

#define SDEPTH_CHILDONLY	SDEPTH_INFAMILY

#define SPOS_RELATIVE		0	
#define SPOS_ABSOLUTE		1	
#define SPOS_MAKEVISIBLE	2	
#define SPOS_FORCEDRAG		4	

OBJECT ScreenBuffer

      BitMap:PTR TO BitMap		
      DBufInfo:PTR TO DBufInfo	
ENDOBJECT


#define SB_SCREEN_BITMAP	1
#define SB_COPY_BITMAP		2

#ifndef INTUITION_IOBSOLETE_H
->MODULE  'intuition/iobsolete'
#endif
#endif
