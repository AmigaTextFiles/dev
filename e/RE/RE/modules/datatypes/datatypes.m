#ifndef  DATATYPES_DATATYPES_H
#define  DATATYPES_DATATYPES_H


#ifndef  EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef  EXEC_LISTS_H
MODULE  'exec/lists'
#endif
#ifndef  EXEC_NODES_H
MODULE  'exec/nodes'
#endif
#ifndef  EXEC_LIBRARIES_H
MODULE  'exec/libraries'
#endif
#ifndef  LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif
#ifndef	DOS_DOS_H
MODULE  'dos/dos'
#endif

#define ID_DTYP MAKE_ID("D","T","Y","P")

#define ID_DTHD MAKE_ID("D","T","H","D")
OBJECT DataTypeHeader

    Name:PTR TO CHAR				
    BaseName:PTR TO CHAR				
    Pattern:PTR TO CHAR				
    Mask:PTR TO WORD				
    GroupID:LONG				
    ID:LONG				
    MaskLen:WORD				
    Pad:WORD				
    Flags:UWORD				
    Priority:UWORD				
ENDOBJECT

#define	DTHSIZE	 SIZEOF DataTypeHeader


#define	DTF_TYPE_MASK	$000F
#define	DTF_BINARY	$0000
#define	DTF_ASCII	$0001
#define	DTF_IFF		$0002
#define	DTF_MISC	$0003

#define	DTF_CASE	$0010

#define	DTF_SYSTEM1	$1000


#define	GID_SYSTEM	MAKE_ID("s","y","s","t")

#define	GID_TEXT	MAKE_ID("t","e","x","t")

#define	GID_DOCUMENT	MAKE_ID("d","o","c","u")

#define	GID_SOUND	MAKE_ID("s","o","u","n")

#define	GID_INSTRUMENT	MAKE_ID("i","n","s","t")

#define	GID_MUSIC	MAKE_ID("m","u","s","i")

#define	GID_PICTURE	MAKE_ID("p","i","c","t")

#define	GID_ANIMATION	MAKE_ID("a","n","i","m")

#define	GID_MOVIE	MAKE_ID("m","o","v","i")


#define ID_CODE MAKE_ID("D","T","C","D")

OBJECT DTHookContext

    
     		SysBase:PTR TO Library
     		DOSBase:PTR TO Library
     		IFFParseBase:PTR TO Library
     		UtilityBase:PTR TO Library
    
    Lock:LONG		
     	FIB:PTR TO FileInfoBlock		
    FileHandle:LONG	
     		IFF:PTR TO IFFHandle		
    Buffer:PTR TO CHAR		
    BufferLength:LONG	
ENDOBJECT


#define ID_TOOL MAKE_ID("D","T","T","L")
OBJECT Tool

    Which:UWORD				
    Flags:UWORD				
    Program:PTR TO CHAR				
ENDOBJECT

#define	TSIZE	 SIZEOF Tool

#define	TW_INFO			1
#define	TW_BROWSE		2
#define	TW_EDIT			3
#define	TW_PRINT		4
#define	TW_MAIL			5

#define	TF_LAUNCH_MASK		$000F
#define	TF_SHELL		$0001
#define	TF_WORKBENCH		$0002
#define	TF_RX			$0003

#define	ID_TAGS	MAKE_ID("D","T","T","G")

#ifndef	DATATYPE
#define	DATATYPE
OBJECT DataType

     			 Node1:Node		
     			 Node2:Node		
     	Header:PTR TO DataTypeHeader		
     			 ToolList:List		
    FunctionName:PTR TO CHAR	
     		AttrList:PTR TO TagItem		
    Length:LONG		
ENDOBJECT
#endif
#define	DTNSIZE	 SIZEOF DataType

OBJECT ToolNode

     	 Node:Node				
       Tool:Tool				
    Length:LONG				
ENDOBJECT

#define	TNSIZE	 SIZEOF ToolNode

#ifndef	ID_NAME
#define	ID_NAME	MAKE_ID("N","A","M","E")
#endif


#define DTERROR_UNKNOWN_DATATYPE		2000
#define DTERROR_COULDNT_SAVE			2001
#define DTERROR_COULDNT_OPEN			2002
#define DTERROR_COULDNT_SEND_MESSAGE		2003

#define	DTERROR_COULDNT_OPEN_CLIPBOARD		2004
#define	DTERROR_Reserved			2005
#define	DTERROR_UNKNOWN_COMPRESSION		2006
#define	DTERROR_NOT_ENOUGH_DATA			2007
#define	DTERROR_INVALID_DATA			2008

#define	DTMSG_TYPE_OFFSET			2100

#endif	 
