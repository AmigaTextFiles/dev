#ifndef INTUITION_GADGETCLASS_H
#define INTUITION_GADGETCLASS_H 1

#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif


#define	   GA_Dummy		(TAG_USER +$30000)
#define    GA_Left		(GA_Dummy + $0001)
#define    GA_RelRight		(GA_Dummy + $0002)
#define    GA_Top		(GA_Dummy + $0003)
#define    GA_RelBottom		(GA_Dummy + $0004)
#define    GA_Width		(GA_Dummy + $0005)
#define    GA_RelWidth		(GA_Dummy + $0006)
#define    GA_Height		(GA_Dummy + $0007)
#define    GA_RelHeight		(GA_Dummy + $0008)
#define    GA_Text		(GA_Dummy + $0009) 
#define    GA_Image		(GA_Dummy + $000A)
#define    GA_Border		(GA_Dummy + $000B)
#define    GA_SelectRender	(GA_Dummy + $000C)
#define    GA_Highlight		(GA_Dummy + $000D)
#define    GA_Disabled		(GA_Dummy + $000E)
#define    GA_GZZGadget		(GA_Dummy + $000F)
#define    GA_ID		(GA_Dummy + $0010)
#define    GA_UserData		(GA_Dummy + $0011)
#define    GA_SpecialInfo	(GA_Dummy + $0012)
#define    GA_Selected		(GA_Dummy + $0013)
#define    GA_EndGadget		(GA_Dummy + $0014)
#define    GA_Immediate		(GA_Dummy + $0015)
#define    GA_RelVerify		(GA_Dummy + $0016)
#define    GA_FollowMouse	(GA_Dummy + $0017)
#define    GA_RightBorder	(GA_Dummy + $0018)
#define    GA_LeftBorder	(GA_Dummy + $0019)
#define    GA_TopBorder		(GA_Dummy + $001A)
#define    GA_BottomBorder	(GA_Dummy + $001B)
#define    GA_ToggleSelect	(GA_Dummy + $001C)
    
#define    GA_SysGadget		(GA_Dummy + $001D)
	
#define    GA_SysGType		(GA_Dummy + $001E)
	
#define    GA_Previous		(GA_Dummy + $001F)
	
#define    GA_Next		(GA_Dummy + $0020)
	 
#define    GA_DrawInfo		(GA_Dummy + $0021)
	

#define GA_IntuiText		(GA_Dummy + $0022)
	
#define GA_LabelImage		(GA_Dummy + $0023)
	
#define GA_TabCycle		(GA_Dummy + $0024)
	
#define GA_GadgetHelp		(GA_Dummy + $0025)
	
#define GA_Bounds		(GA_Dummy + $0026)
	
#define GA_RelSpecial		(GA_Dummy + $0027)
	

#define PGA_Dummy	(TAG_USER + $31000)
#define PGA_Freedom	(PGA_Dummy + $0001)
	
#define PGA_Borderless	(PGA_Dummy + $0002)
#define PGA_HorizPot	(PGA_Dummy + $0003)
#define PGA_HorizBody	(PGA_Dummy + $0004)
#define PGA_VertPot	(PGA_Dummy + $0005)
#define PGA_VertBody	(PGA_Dummy + $0006)
#define PGA_Total	(PGA_Dummy + $0007)
#define PGA_Visible	(PGA_Dummy + $0008)
#define PGA_Top		(PGA_Dummy + $0009)

#define PGA_NewLook	(PGA_Dummy + $000A)

#define STRINGA_Dummy			(TAG_USER      +$32000)
#define STRINGA_MaxChars	(STRINGA_Dummy + $0001)

#define STRINGA_Buffer		(STRINGA_Dummy + $0002)
#define STRINGA_UndoBuffer	(STRINGA_Dummy + $0003)
#define STRINGA_WorkBuffer	(STRINGA_Dummy + $0004)
#define STRINGA_BufferPos	(STRINGA_Dummy + $0005)
#define STRINGA_DispPos		(STRINGA_Dummy + $0006)
#define STRINGA_AltKeyMap	(STRINGA_Dummy + $0007)
#define STRINGA_Font		(STRINGA_Dummy + $0008)
#define STRINGA_Pens		(STRINGA_Dummy + $0009)
#define STRINGA_ActivePens	(STRINGA_Dummy + $000A)
#define STRINGA_EditHook	(STRINGA_Dummy + $000B)
#define STRINGA_EditModes	(STRINGA_Dummy + $000C)

#define STRINGA_ReplaceMode	(STRINGA_Dummy + $000D)
#define STRINGA_FixedFieldMode	(STRINGA_Dummy + $000E)
#define STRINGA_NoFilterMode	(STRINGA_Dummy + $000F)
#define STRINGA_Justification	(STRINGA_Dummy + $0010)
	
#define STRINGA_LongVal		(STRINGA_Dummy + $0011)
#define STRINGA_TextVal		(STRINGA_Dummy + $0012)
#define STRINGA_ExitHelp	(STRINGA_Dummy + $0013)
	
#define SG_DEFAULTMAXCHARS	(128)

#define	LAYOUTA_Dummy		(TAG_USER  + $38000)
#define LAYOUTA_LayoutObj	(LAYOUTA_Dummy + $0001)
#define LAYOUTA_Spacing		(LAYOUTA_Dummy + $0002)
#define LAYOUTA_Orientation	(LAYOUTA_Dummy + $0003)

#define LORIENT_NONE	0
#define LORIENT_HORIZ	1
#define LORIENT_VERT	2

#define GM_Dummy	(-1)	
#define GM_HITTEST	(0)	
#define GM_RENDER	(1)	
#define GM_GOACTIVE	(2)	
#define GM_HANDLEINPUT	(3)	
#define GM_GOINACTIVE	(4)	
#define GM_HELPTEST	(5)	
#define GM_LAYOUT	(6)	


OBJECT gpHitTest

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
        OBJECT gpht_Mouse

	X:WORD
	Y:WORD
    			ENDOBJECT
ENDOBJECT


#define GMR_GADGETHIT	$($00000004)	
#define GMR_NOHELPHIT	$($00000000)	
#define GMR_HELPHIT	$($FFFFFFFF)	
#define GMR_HELPCODE	$($00010000)	

OBJECT gpRender

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo	
     	RPort:PTR TO RastPort	
    Redraw:LONG	
ENDOBJECT


#define GREDRAW_UPDATE	(2)	
#define GREDRAW_REDRAW	(1)	
#define GREDRAW_TOGGLE	(0)	

OBJECT gpInput

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
     	IEvent:PTR TO InputEvent
    Termination:PTR TO LONG
        OBJECT gpi_Mouse

	X:WORD
	Y:WORD
    			ENDOBJECT
    
     	TabletData:PTR TO TabletData
ENDOBJECT



#define GMR_MEACTIVE	(0)
#define GMR_NOREUSE	(1 << 1)
#define GMR_REUSE	(1 << 2)
#define GMR_VERIFY	(1 << 3)	

#define GMR_NEXTACTIVE	(1 << 4)
#define GMR_PREVACTIVE	(1 << 5)

OBJECT gpGoInactive

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
    
    Abort:LONG	
ENDOBJECT



OBJECT gpLayout

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
    Initial:LONG	
ENDOBJECT


#ifndef INTUITION_IOBSOLETE_H
->MODULE  'intuition/iobsolete'
#endif
#endif
