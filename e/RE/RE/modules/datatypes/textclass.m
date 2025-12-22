#ifndef	DATATYPES_TEXTCLASS_H
#define	DATATYPES_TEXTCLASS_H

#ifndef	UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef	DATATYPES_DATATYPESCLASS_H
MODULE  'datatypes/datatypesclass'
#endif
#ifndef	LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define	TEXTDTCLASS		'text.datatype'


#define	TDTA_Buffer		(DTA_Dummy + 300)
#define	TDTA_BufferLen		(DTA_Dummy + 301)
#define	TDTA_LineList		(DTA_Dummy + 302)
#define	TDTA_WordSelect		(DTA_Dummy + 303)
#define	TDTA_WordDelim		(DTA_Dummy + 304)
#define	TDTA_WordWrap		(DTA_Dummy + 305)
     


OBJECT Line

     	 Link:MinNode		
    Text:PTR TO CHAR		
    TextLen:LONG		
    XOffset:UWORD		
    YOffset:UWORD		
    Width:UWORD		
    Height:UWORD		
    Flags:UWORD		
    FgPen:BYTE		
    BgPen:BYTE		
    Style:LONG		
    Data:LONG		
ENDOBJECT




#define	LNF_LF		(1 << 0)

#define	LNF_LINK	(1 << 1)

#define	LNF_OBJECT	(1 << 2)

#define	LNF_SELECTED	(1 << 3)


#define	ID_FTXT		MAKE_ID("F","T","X","T")
#define	ID_CHRS		MAKE_ID("C","H","R","S")

#endif	
