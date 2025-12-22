
#ifndef INTUITION_INTUITION_H
#define INTUITION_INTUITION_H TRUE

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
#ifndef GRAPHICS_TEXT_H
MODULE  'graphics/text'
#endif
#ifndef EXEC_PORTS_H
MODULE  'exec/ports'
#endif
#ifndef DEVICES_INPUTEVENT_H
MODULE  'devices/inputevent'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif




OBJECT Menu

      NextMenu:PTR TO Menu	
    LeftEdge:WORD
 TopEdge:WORD	
    Width:WORD
 Height:WORD	
    Flags:UWORD		
    MenuName:PTR TO BYTE		
      FirstItem:PTR TO MenuItem 
    
    JazzX:WORD
 JazzY:WORD
 BeatX:WORD
 BeatY:WORD
ENDOBJECT


#define MENUENABLED $0001	

#define MIDRAWN $0100		



OBJECT MenuItem

      NextItem:PTR TO MenuItem	
    LeftEdge:WORD
 TopEdge:WORD	
    Width:WORD
 Height:WORD		
    Flags:UWORD		
    MutualExclude:LONG		
    ItemFill:LONG		
    
    SelectFill:LONG		
    Command:BYTE		
      SubItem:PTR TO MenuItem	
    
    NextSelect:UWORD
ENDOBJECT


#define CHECKIT		$0001	
#define ITEMTEXT	$0002	
#define COMMSEQ		$0004	
#define MENUTOGGLE	$0008	
#define ITEMENABLED	$0010	

#define HIGHFLAGS	$00C0	
#define HIGHIMAGE	$0000	
#define HIGHCOMP	$0040	
#define HIGHBOX		$0080	
#define HIGHNONE	$00C0	

#define CHECKED	$0100	

#define ISDRAWN		$1000	
#define HIGHITEM	$2000	
#define MENUTOGGLED	$4000	



OBJECT Requester

      OlderRequest:PTR TO Requester
    LeftEdge:WORD
 TopEdge:WORD		
    Width:WORD
 Height:WORD			
    RelLeft:WORD
 RelTop:WORD		
      ReqGadget:PTR TO Gadget		
      ReqBorder:PTR TO Border		
      ReqText:PTR TO IntuiText		
    Flags:UWORD			
    
    BackFill:UBYTE
    
      ReqLayer:PTR TO Layer
    ReqPad1[32]:UBYTE
    
      ImageBMap:PTR TO BitMap	
      RWindow:PTR TO Window	
       ReqImage:PTR TO Image	
    ReqPad2[32]:UBYTE
ENDOBJECT


#define POINTREL	$0001
			  
#define PREDRAWN	$0002
	
#define NOISYREQ	$0004
	
#define SIMPLEREQ	$0010
	

#define USEREQIMAGE	$0020
	
#define NOREQBACKFILL	$0040
	

#define REQOFFWINDOW	$1000	
#define REQACTIVE	$2000	
#define SYSREQUEST	$4000	
#define DEFERREFRESH	$8000	



OBJECT Gadget

      NextGadget:PTR TO Gadget	
    LeftEdge:WORD
 TopEdge:WORD	
    Width:WORD
 Height:WORD		
    Flags:UWORD		
    Activation:UWORD		
    GadgetType:UWORD		
    
    GadgetRender:LONG
    
    SelectRender:LONG
      GadgetText:PTR TO IntuiText   
    
    MutualExclude:LONG  
    
    SpecialInfo:LONG
    GadgetID:UWORD	
    UserData:LONG	
ENDOBJECT

OBJECT ExtGadget

    
      NextGadget:PTR TO ExtGadget 
    LeftEdge:WORD
 TopEdge:WORD	  
    Width:WORD
 Height:WORD		  
    Flags:UWORD		  
    Activation:UWORD		  
    GadgetType:UWORD		  
    GadgetRender:LONG		  
    SelectRender:LONG		  
      GadgetText:PTR TO IntuiText 
    MutualExclude:LONG		  
    SpecialInfo:LONG		  
    GadgetID:UWORD		  
    UserData:LONG		  
    
    MoreFlags:LONG		
    BoundsLeftEdge:WORD	
    BoundsTopEdge:WORD		
    BoundsWidth:WORD		
    BoundsHeight:WORD		
ENDOBJECT



#define GFLG_GADGHIGHBITS $0003
#define GFLG_GADGHCOMP	  $0000  
#define GFLG_GADGHBOX	  $0001  
#define GFLG_GADGHIMAGE	  $0002  
#define GFLG_GADGHNONE	  $0003  
#define GFLG_GADGIMAGE		  $0004  

#define GFLG_RELBOTTOM	  $0008  
#define GFLG_RELRIGHT	  $0010  
#define GFLG_RELWIDTH	  $0020  
#define GFLG_RELHEIGHT	  $0040  

#define GFLG_RELSPECIAL	  $4000  
#define GFLG_SELECTED	  $0080  

#define GFLG_DISABLED	  $0100

#define GFLG_LABELMASK	  $3000
#define GFLG_LABELITEXT	  $0000  
#define	GFLG_LABELSTRING  $1000  
#define GFLG_LABELIMAGE	  $2000  

#define GFLG_TABCYCLE	  $0200  

#define GFLG_STRINGEXTEND $0400  

#define GFLG_IMAGEDISABLE $0800  

#define GFLG_EXTENDED	  $8000  


#define GACT_RELVERIFY	  $0001

#define GACT_IMMEDIATE	  $0002

#define GACT_ENDGADGET	  $0004

#define GACT_FOLLOWMOUSE  $0008

#define GACT_RIGHTBORDER  $0010
#define GACT_LEFTBORDER	  $0020
#define GACT_TOPBORDER	  $0040
#define GACT_BOTTOMBORDER $0080
#define GACT_BORDERSNIFF  $8000  
#define GACT_TOGGLESELECT $0100  
#define GACT_BOOLEXTEND	  $2000  

#define GACT_STRINGLEFT	  $0000  
#define GACT_STRINGCENTER $0200
#define GACT_STRINGRIGHT  $0400
#define GACT_LONGINT	  $0800  
#define GACT_ALTKEYMAP	  $1000  
#define GACT_STRINGEXTEND $2000  
				  
#define GACT_ACTIVEGADGET $4000  



#define GTYP_GADGETTYPE	$FC00	
#define GTYP_SCRGADGET		$4000	
#define GTYP_GZZGADGET		$2000	
#define GTYP_REQGADGET		$1000	

#define GTYP_SYSGADGET		$8000
#define GTYP_SYSTYPEMASK	$00F0

#define GTYP_SIZING		$0010	
#define GTYP_WDRAGGING		$0020	
#define GTYP_SDRAGGING		$0030	
#define GTYP_WDEPTH		$0040	
#define GTYP_SDEPTH		$0050	
#define GTYP_WZOOM		$0060	
#define GTYP_SUNUSED		$0070	
#define GTYP_CLOSE		$0080	

#define GTYP_WUPFRONT		GTYP_WDEPTH	
#define GTYP_SUPFRONT		GTYP_SDEPTH	
#define GTYP_WDOWNBACK		GTYP_WZOOM	
#define GTYP_SDOWNBACK		GTYP_SUNUSED	

#define GTYP_GTYPEMASK		$0007
#define GTYP_BOOLGADGET		$0001
#define GTYP_GADGET0002		$0002
#define GTYP_PROPGADGET		$0003
#define GTYP_STRGADGET		$0004
#define GTYP_CUSTOMGADGET	$0005


#define GMORE_BOUNDS	   $00000001 
#define GMORE_GADGETHELP   $00000002 
#define GMORE_SCROLLRASTER $00000004 




OBJECT BoolInfo

    Flags:UWORD	
    Mask:PTR TO UWORD	
    Reserved:LONG	
ENDOBJECT


#define BOOLMASK	$0001	




OBJECT PropInfo

    Flags:UWORD	
    
    HorizPot:UWORD	
    VertPot:UWORD	
    
    HorizBody:UWORD		
    VertBody:UWORD		
    
    CWidth:UWORD	
    CHeight:UWORD	
    HPotRes:UWORD
 VPotRes:UWORD	
    LeftBorder:UWORD		
    TopBorder:UWORD		
ENDOBJECT


#define AUTOKNOB	$0001	

#define FREEHORIZ	$0002	
#define FREEVERT	$0004	
#define PROPBORDERLESS	$0008	
#define KNOBHIT		$0100	
#define PROPNEWLOOK	$0010	
#define KNOBHMIN	6	
#define KNOBVMIN	4	
#define MAXBODY		$FFFF	
#define MAXPOT			$FFFF	




OBJECT StringInfo

    
    Buffer:PTR TO UBYTE	
    UndoBuffer:PTR TO UBYTE	
    BufferPos:WORD	
    MaxChars:WORD	
    DispPos:WORD	
    
    UndoPos:WORD	
    NumChars:WORD	
    DispCount:WORD	
    CLeft:WORD
 CTop:WORD	
    
    
      Extension:PTR TO StringExtend
    
    LongInt:LONG
    
      AltKeyMap:PTR TO KeyMap
ENDOBJECT





OBJECT IntuiText

    FrontPen:UBYTE
 BackPen:UBYTE	
    DrawMode:UBYTE		
    LeftEdge:WORD		
    TopEdge:WORD		
      ITextFont:PTR TO TextAttr	
    IText:PTR TO UBYTE		
      NextText:PTR TO IntuiText 
ENDOBJECT





OBJECT Border

    LeftEdge:WORD
 TopEdge:WORD	
    FrontPen:UBYTE
 BackPen:UBYTE	
    DrawMode:UBYTE		
    Count:BYTE			
    XY:PTR TO WORD			
      NextBorder:PTR TO Border	
ENDOBJECT





OBJECT Image

    LeftEdge:WORD		
    TopEdge:WORD		
    Width:WORD			
    Height:WORD
    Depth:WORD			
    ImageData:PTR TO UWORD		
    
    PlanePick:UBYTE
 PlaneOnOff:UBYTE
    
      NextImage:PTR TO Image
ENDOBJECT




OBJECT IntuiMessage

      ExecMessage:Message
    
    Class:LONG
    
    Code:UWORD
    
    Qualifier:UWORD
    
    IAddress:LONG
    
    MouseX:WORD
 MouseY:WORD
    
    Seconds:LONG
 Micros:LONG
    
      IDCMPWindow:PTR TO Window
    
      SpecialLink:PTR TO IntuiMessage
ENDOBJECT


OBJECT ExtIntuiMessage

      IntuiMessage:IntuiMessage
      TabletData:PTR TO TabletData
ENDOBJECT



#define IDCMP_SIZEVERIFY	$00000001
#define IDCMP_NEWSIZE		$00000002
#define IDCMP_REFRESHWINDOW	$00000004
#define IDCMP_MOUSEBUTTONS	$00000008
#define IDCMP_MOUSEMOVE		$00000010
#define IDCMP_GADGETDOWN	$00000020
#define IDCMP_GADGETUP		$00000040
#define IDCMP_REQSET		$00000080
#define IDCMP_MENUPICK		$00000100
#define IDCMP_CLOSEWINDOW	$00000200
#define IDCMP_RAWKEY		$00000400
#define IDCMP_REQVERIFY		$00000800
#define IDCMP_REQCLEAR		$00001000
#define IDCMP_MENUVERIFY	$00002000
#define IDCMP_NEWPREFS		$00004000
#define IDCMP_DISKINSERTED	$00008000
#define IDCMP_DISKREMOVED	$00010000
#define IDCMP_WBENCHMESSAGE	$00020000  
#define IDCMP_ACTIVEWINDOW	$00040000
#define IDCMP_INACTIVEWINDOW	$00080000
#define IDCMP_DELTAMOVE		$00100000
#define IDCMP_VANILLAKEY	$00200000
#define IDCMP_INTUITICKS	$00400000

#define IDCMP_IDCMPUPDATE	$00800000  

#define IDCMP_MENUHELP		$01000000  

#define IDCMP_CHANGEWINDOW	$02000000  
#define IDCMP_GADGETHELP	$04000000  


#define IDCMP_LONELYMESSAGE	$80000000


#define CWCODE_MOVESIZE	$0000	
#define CWCODE_DEPTH	$0001	

#define MENUHOT		$0001	
#define MENUCANCEL	$0002	
#define MENUWAITING	$0003	

#define OKOK		MENUHOT	
#define OKABORT		$0004	
#define OKCANCEL	MENUCANCEL 

#define WBENCHOPEN	$0001
#define WBENCHCLOSE	$0002

OBJECT IBox

    Left:WORD
    Top:WORD
    Width:WORD
    Height:WORD
ENDOBJECT




OBJECT Window

      NextWindow:PTR TO Window		
    LeftEdge:WORD
 TopEdge:WORD		
    Width:WORD
 Height:WORD			
    MouseY:WORD
 MouseX:WORD		
    MinWidth:WORD
 MinHeight:WORD		
    MaxWidth:UWORD
 MaxHeight:UWORD		
    Flags:LONG			
      MenuStrip:PTR TO Menu		
    Title:PTR TO UBYTE			
      FirstRequest:PTR TO Requester	
      DMRequest:PTR TO Requester	
    ReqCount:WORD			
      WScreen:PTR TO Screen		
      RPort:PTR TO RastPort		
    
    BorderLeft:BYTE
 BorderTop:BYTE
 BorderRight:BYTE
 BorderBottom:BYTE
      BorderRPort:PTR TO RastPort
    
      FirstGadget:PTR TO Gadget
    
      Parent:PTR TO Window
 Descendant:PTR TO Window
    
    Pointer:PTR TO UWORD	
    PtrHeight:BYTE	
    PtrWidth:BYTE	
    XOffset:BYTE
 YOffset:BYTE	
    
    IDCMPFlags:LONG	
      UserPort:PTR TO MsgPort
 WindowPort:PTR TO MsgPort
      MessageKey:PTR TO IntuiMessage
    DetailPen:UBYTE
 BlockPen:UBYTE	
    
      CheckMark:PTR TO Image
    ScreenTitle:PTR TO UBYTE	
    
    GZZMouseX:WORD
    GZZMouseY:WORD
    
    GZZWidth:WORD
    GZZHeight:WORD
    ExtData:PTR TO UBYTE
    UserData:PTR TO BYTE	
    
      WLayer:PTR TO Layer
    
      IFont:PTR TO TextFont
    
    MoreFlags:LONG
    
ENDOBJECT


#define WFLG_SIZEGADGET	    $00000001	
#define WFLG_DRAGBAR	    $00000002	
#define WFLG_DEPTHGADGET    $00000004	
#define WFLG_CLOSEGADGET    $00000008	
#define WFLG_SIZEBRIGHT	    $00000010	
#define WFLG_SIZEBBOTTOM    $00000020	


#define WFLG_REFRESHBITS    $000000C0
#define WFLG_SMART_REFRESH  $00000000
#define WFLG_SIMPLE_REFRESH $00000040
#define WFLG_SUPER_BITMAP   $00000080
#define WFLG_OTHER_REFRESH  $000000C0
#define WFLG_BACKDROP	    $00000100	
#define WFLG_REPORTMOUSE    $00000200	
#define WFLG_GIMMEZEROZERO  $00000400	
#define WFLG_BORDERLESS	    $00000800	
#define WFLG_ACTIVATE	    $00001000	

#define WFLG_RMBTRAP	    $00010000	
#define WFLG_NOCAREREFRESH  $00020000	

#define WFLG_NW_EXTENDED    $00040000	
					

#define WFLG_NEWLOOKMENUS   $00200000	

#define WFLG_WINDOWACTIVE   $00002000	
#define WFLG_INREQUEST	    $00004000	
#define WFLG_MENUSTATE	    $00008000	
#define WFLG_WINDOWREFRESH  $01000000	
#define WFLG_WBENCHWINDOW   $02000000	
#define WFLG_WINDOWTICKED   $04000000	

#define WFLG_VISITOR	    $08000000	
#define WFLG_ZOOMED	    $10000000	
#define WFLG_HASZOOM	    $20000000	

#define DEFAULTMOUSEQUEUE	5	





OBJECT NewWindow

    LeftEdge:WORD
 TopEdge:WORD		
    Width:WORD
 Height:WORD			
    DetailPen:UBYTE
 BlockPen:UBYTE		
    IDCMPFlags:LONG			
    Flags:LONG			
    
      FirstGadget:PTR TO Gadget
    
      CheckMark:PTR TO Image
    Title:PTR TO UBYTE			  
    
      Screen:PTR TO Screen
    
      BitMap:PTR TO BitMap
    
    MinWidth:WORD
 MinHeight:WORD	    
    MaxWidth:UWORD
 MaxHeight:UWORD	     
    
    Type:UWORD
ENDOBJECT


OBJECT ExtNewWindow

    LeftEdge:WORD
 TopEdge:WORD
    Width:WORD
 Height:WORD
    DetailPen:UBYTE
 BlockPen:UBYTE
    IDCMPFlags:LONG
    Flags:LONG
      FirstGadget:PTR TO Gadget
      CheckMark:PTR TO Image
    Title:PTR TO UBYTE
      Screen:PTR TO Screen
      BitMap:PTR TO BitMap
    MinWidth:WORD
 MinHeight:WORD
    MaxWidth:UWORD
 MaxHeight:UWORD
    
    Type:UWORD
    
     	Extension:PTR TO TagItem
ENDOBJECT


#define WA_Dummy (TAG_USER + 99)	

#define WA_Left     (WA_Dummy + $01)
#define WA_Top			(WA_Dummy + $02)
#define WA_Width		(WA_Dummy + $03)
#define WA_Height		(WA_Dummy + $04)
#define WA_DetailPen		(WA_Dummy + $05)
#define WA_BlockPen		(WA_Dummy + $06)
#define WA_IDCMP		(WA_Dummy + $07)
			
#define WA_Flags		(WA_Dummy + $08)
#define WA_Gadgets		(WA_Dummy + $09)
#define WA_Checkmark		(WA_Dummy + $0A)
#define WA_Title		(WA_Dummy + $0B)
			
#define WA_ScreenTitle		(WA_Dummy + $0C)
#define WA_CustomScreen		(WA_Dummy + $0D)
#define WA_SuperBitMap		(WA_Dummy + $0E)
			
#define WA_MinWidth		(WA_Dummy + $0F)
#define WA_MinHeight		(WA_Dummy + $10)
#define WA_MaxWidth		(WA_Dummy + $11)
#define WA_MaxHeight		(WA_Dummy + $12)

#define WA_InnerWidth		(WA_Dummy + $13)
#define WA_InnerHeight		(WA_Dummy + $14)
			
#define WA_PubScreenName	(WA_Dummy + $15)
			
#define WA_PubScreen		(WA_Dummy + $16)
			
#define WA_PubScreenFallBack	(WA_Dummy + $17)
			
#define WA_WindowName		(WA_Dummy + $18)
			
#define WA_Colors		(WA_Dummy + $19)
			
#define WA_Zoom		(WA_Dummy + $1A)
			
#define WA_MouseQueue		(WA_Dummy + $1B)
			
#define WA_BackFill		(WA_Dummy + $1C)
			
#define WA_RptQueue		(WA_Dummy + $1D)
			
    
#define WA_SizeGadget		(WA_Dummy + $1E)
#define WA_DragBar		(WA_Dummy + $1F)
#define WA_DepthGadget		(WA_Dummy + $20)
#define WA_CloseGadget		(WA_Dummy + $21)
#define WA_Backdrop		(WA_Dummy + $22)
#define WA_ReportMouse		(WA_Dummy + $23)
#define WA_NoCareRefresh	(WA_Dummy + $24)
#define WA_Borderless		(WA_Dummy + $25)
#define WA_Activate		(WA_Dummy + $26)
#define WA_RMBTrap		(WA_Dummy + $27)
#define WA_WBenchWindow		(WA_Dummy + $28)	
#define WA_SimpleRefresh	(WA_Dummy + $29)
			
#define WA_SmartRefresh		(WA_Dummy + $2A)
			
#define WA_SizeBRight		(WA_Dummy + $2B)
#define WA_SizeBBottom		(WA_Dummy + $2C)
    
#define WA_AutoAdjust		(WA_Dummy + $2D)
			
#define WA_GimmeZeroZero	(WA_Dummy + $2E)
			

#define WA_MenuHelp		(WA_Dummy + $2F)
			

#define WA_NewLookMenus		(WA_Dummy + $30)
			
#define WA_AmigaKey		(WA_Dummy + $31)
			
#define WA_NotifyDepth		(WA_Dummy + $32)
			

#define WA_Pointer		(WA_Dummy + $34)
			
#define WA_BusyPointer		(WA_Dummy + $35)
			
#define WA_PointerDelay		(WA_Dummy + $36)
			
#define WA_TabletMessages	(WA_Dummy + $37)
			
#define WA_HelpGroup		(WA_Dummy + $38)
			
#define WA_HelpGroupWindow	(WA_Dummy + $39)
			

#define HC_GADGETHELP	1
#ifndef INTUITION_SCREENS_H
MODULE  'intuition/screens'
#endif
#ifndef INTUITION_PREFERENCES_H
MODULE  'intuition/preferences'
#endif




OBJECT Remember

      NextRemember:PTR TO Remember
    RememberSize:LONG
    Memory:PTR TO UBYTE
ENDOBJECT



OBJECT ColorSpec

    ColorIndex:WORD	
    Red:UWORD	
    Green:UWORD	
    Blue:UWORD	
ENDOBJECT




OBJECT EasyStruct
 
    StructSize:LONG	
    Flags:LONG	
    Title:PTR TO UBYTE	
    TextFormat:PTR TO UBYTE	
    GadgetFormat:PTR TO UBYTE 
ENDOBJECT





#define MENUNUM(n) (n & $1F)
#define ITEMNUM(n) ((n >> 5) & $003F)
#define SUBNUM(n) ((n >> 11) & $001F)
#define SHIFTMENU(n) (n & $1F)
#define SHIFTITEM(n) ((n & $3F) << 5)
#define SHIFTSUB(n) ((n & $1F) << 11)
#define FULLMENUNUM ( menu, item, sub )	\
	 ( SHIFTSUB(sub) OR SHIFTITEM(item) OR SHIFTMENU(menu) )
#define SRBNUM(n)    ($08 - (n >> 4))	
#define SWBNUM(n)    ($08 - (n & $0F))
#define SSBNUM(n)    ($01 + (n >> 4))	
#define SPARNUM(n)   (n >> 4)		
#define SHAKNUM(n)   (n & $0F)	

#define NOMENU $001F
#define NOITEM $003F
#define NOSUB  $001F
#define MENUNULL $FFFF

->#define FOREVER for()
#define SIGN(x)  ( ((x) > 0) - ((x) < 0) )
->#define NOT !

#define CHECKWIDTH	19
#define COMMWIDTH	27
#define LOWCHECKWIDTH	13
#define LOWCOMMWIDTH	16

#define ALERT_TYPE	$80000000
#define RECOVERY_ALERT	$00000000	
#define DEADEND_ALERT	$80000000	

#define AUTOFRONTPEN	0
#define AUTOBACKPEN	1
#define AUTODRAWMODE	RP_JAM2
#define AUTOLEFTEDGE	6
#define AUTOTOPEDGE	3
#define AUTOITEXTFONT	NULL
#define AUTONEXTTEXT	NULL
->since logic has precedence over condition this works: IF var = SELECTUP
->this is interpreted the wrong way: IF var1 = 1 OR var2 = 2 always do IF (var1 = 1) OR (var2 = 2)
#define SELECTUP	IECODE_LBUTTON OR IECODE_UP_PREFIX
#define SELECTDOWN	IECODE_LBUTTON
#define MENUUP		IECODE_RBUTTON OR IECODE_UP_PREFIX
#define MENUDOWN	IECODE_RBUTTON
#define MIDDLEUP	IECODE_MBUTTON OR IECODE_UP_PREFIX
#define MIDDLEDOWN	IECODE_MBUTTON
#define ALTLEFT		IEQUALIFIER_LALT
#define ALTRIGHT	IEQUALIFIER_RALT
#define AMIGALEFT	IEQUALIFIER_LCOMMAND
#define AMIGARIGHT	IEQUALIFIER_RCOMMAND
#define AMIGAKEYS	AMIGALEFT OR AMIGARIGHT
#define CURSORUP	$4C
#define CURSORLEFT	$4F
#define CURSORRIGHT	$4E
#define CURSORDOWN	$4D
#define KEYCODE_Q	$10
#define KEYCODE_Z	$31
#define KEYCODE_X	$32
#define KEYCODE_V	$34
#define KEYCODE_B	$35
#define KEYCODE_N	$36
#define KEYCODE_M	$37
#define KEYCODE_LESS	$38
#define KEYCODE_GREATER $39

#define TABLETA_Dummy		(TAG_USER + $3A000)
#define TABLETA_TabletZ		(TABLETA_Dummy + $01)
#define TABLETA_RangeZ		(TABLETA_Dummy + $02)
#define TABLETA_AngleX		(TABLETA_Dummy + $03)
#define TABLETA_AngleY		(TABLETA_Dummy + $04)
#define TABLETA_AngleZ		(TABLETA_Dummy + $05)
#define TABLETA_Pressure	(TABLETA_Dummy + $06)
#define TABLETA_ButtonBits	(TABLETA_Dummy + $07)
#define TABLETA_InProximity	(TABLETA_Dummy + $08)
#define TABLETA_ResolutionX	(TABLETA_Dummy + $09)
#define TABLETA_ResolutionY	(TABLETA_Dummy + $0A)

OBJECT TabletData

    
    XFraction:UWORD
 YFraction:UWORD
    
    TabletX:LONG
 TabletY:LONG
    
    RangeX:LONG
 RangeY:LONG
    
      TagList:PTR TO TagItem
ENDOBJECT


OBJECT TabletHookData

    
      Screen:PTR TO Screen
    
    Width:LONG
    Height:LONG
    
    ScreenChanged:LONG
ENDOBJECT


#ifndef INTUITION_IOBSOLETE_H
->MODULE  'intuition/iobsolete'
#endif
#endif
