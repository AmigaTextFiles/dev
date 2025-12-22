#ifndef	GRAPHICS_TEXT_H
#define	GRAPHICS_TEXT_H

#ifndef	EXEC_PORTS_H
MODULE 	'exec/ports'
#endif	
#ifndef	GRAPHICS_GFX_H
MODULE 	'graphics/gfx'
#endif	
#ifndef	UTILITY_TAGITEM_H
MODULE 	'utility/tagitem'
#endif	

#define	FS_NORMAL	0	
#define	FSB_UNDERLINED	0	
#define	FSF_UNDERLINED	$01
#define	FSB_BOLD	1	
#define	FSF_BOLD	$02
#define	FSB_ITALIC	2	
#define	FSF_ITALIC	$04
#define	FSB_EXTENDED	3	
#define	FSF_EXTENDED	$08
#define	FSB_COLORFONT	6	
#define	FSF_COLORFONT	$40
#define	FSB_TAGGED	7	
#define	FSF_TAGGED	$80

#define	FPB_ROMFONT	0	
#define	FPF_ROMFONT	$01
#define	FPB_DISKFONT	1	
#define	FPF_DISKFONT	$02
#define	FPB_REVPATH	2	
#define	FPF_REVPATH	$04
#define	FPB_TALLDOT	3	
#define	FPF_TALLDOT	$08
#define	FPB_WIDEDOT	4	
#define	FPF_WIDEDOT	$10
#define	FPB_PROPORTIONAL 5	
#define	FPF_PROPORTIONAL $20
#define	FPB_DESIGNED	6	
				
				
				
				
#define	FPF_DESIGNED	$40
    
#define	FPB_REMOVED	7	
#define	FPF_REMOVED	(1<<7)

OBJECT TextAttr
 
    Name:PTR TO CHAR		
    YSize:UWORD		
    Style:UBYTE		
    Flags:UBYTE		
ENDOBJECT

OBJECT TTextAttr
 
    Name:PTR TO CHAR		
    YSize:UWORD		
    Style:UBYTE		
    Flags:UBYTE		
      Tags:PTR TO TagItem	
ENDOBJECT


#define	TA_DeviceDPI	(1ORTAG_USER)	
					
#define	MAXFONTMATCHWEIGHT	32767	

OBJECT TextFont
 
      Message:Message	
				
    YSize:UWORD		
    Style:UBYTE		
    Flags:UBYTE		
    XSize:UWORD		
    Baseline:UWORD	
    BoldSmear:UWORD	
    Accessors:UWORD	
    LoChar:UBYTE		
    HiChar:UBYTE		
    CharData:LONG	
    Modulo:UWORD		
    CharLoc:LONG		
				
    CharSpace:LONG	
    CharKern:LONG	
ENDOBJECT


#define	tf_Extension	tf_Message.mn_ReplyPort

#define TE0B_NOREMFONT	0	
#define TE0F_NOREMFONT	$01
OBJECT TextFontExtension
 	
    MatchWord:UWORD		
    Flags0:UBYTE			
    Flags1:UBYTE			
      BackPtr:PTR TO TextFont	
      OrigReplyPort:PTR TO MsgPort	
      Tags:PTR TO TagItem		
    OFontPatchS:PTR TO UWORD		
    OFontPatchK:PTR TO UWORD		
    
ENDOBJECT



#define	CT_COLORMASK	$000F	
#define	CT_COLORFONT	$0001	
#define	CT_GREYFONT	$0002	
				
#define	CT_ANTIALIAS	$0004	
#define	CTB_MAPCOLOR	0	
#define	CTF_MAPCOLOR	$0001	

OBJECT ColorFontColors
 
    Reserved:UWORD	
    Count:UWORD		
    ColorTable:PTR TO UWORD	
ENDOBJECT


OBJECT ColorTextFont
 
      TF:TextFont
    Flags:UWORD		
    Depth:UBYTE		
    FgColor:UBYTE	
    Low:UBYTE		
    High:UBYTE		
    PlanePick:UBYTE	
    PlaneOnOff:UBYTE	
      ColorFontColors:PTR TO ColorFontColors 
    CharData[8]:LONG	
ENDOBJECT


OBJECT TextExtent
 
    Width:UWORD		
    Height:UWORD		
      Extent:Rectangle	
ENDOBJECT

#endif	
