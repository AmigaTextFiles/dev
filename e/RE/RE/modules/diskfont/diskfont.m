#ifndef	DISKFONT_DISKFONT_H
#define	DISKFONT_DISKFONT_H

#ifndef     EXEC_NODES_H
MODULE  'exec/nodes'
#endif
#ifndef     EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef     GRAPHICS_TEXT_H
MODULE  'graphics/text'
#endif
#define     MAXFONTPATH 256   
OBJECT FontContents
 
    FileName[MAXFONTPATH]:LONG
    YSize:UWORD
    Style:UBYTE
    Flags:UBYTE
ENDOBJECT

OBJECT TFontContents
 
    FileName[MAXFONTPATH-2]:LONG
    TagCount:UWORD	
    
    YSize:UWORD
    Style:UBYTE
    Flags:UBYTE
ENDOBJECT

#define  FCH_ID		$0f00	
#define  TFCH_ID	$0f02	
#define  OFCH_ID	$0f03	
OBJECT FontContentsHeader
 
    FileID:UWORD		
    NumEntries:UWORD	
    
ENDOBJECT

#define  DFH_ID		$0f80
#define  MAXFONTNAME	32	
OBJECT DiskFontHeader
 
    
    
    
    
    
    
    
      DF:Node		
    FileID:UWORD		
    Revision:UWORD	
    Segment:LONG	
    Name[MAXFONTNAME]:LONG 
      TF:TextFont	
ENDOBJECT



#define	dfh_TagList	dfh_Segment	
#define     AFB_MEMORY	0
#define     AFF_MEMORY	$0001
#define     AFB_DISK	1
#define     AFF_DISK	$0002
#define     AFB_SCALED	2
#define     AFF_SCALED	$0004
#define     AFB_BITMAP	3
#define     AFF_BITMAP	$0008
#define     AFB_TAGGED	16	
#define     AFF_TAGGED	$10000
OBJECT AvailFonts
 
    Type:UWORD		
      Attr:TextAttr	
ENDOBJECT

OBJECT TAvailFonts
 
    Type:UWORD		
      Attr:TTextAttr	
ENDOBJECT

OBJECT AvailFontsHeader
 
    NumEntries:UWORD	 
    
ENDOBJECT

#endif	
