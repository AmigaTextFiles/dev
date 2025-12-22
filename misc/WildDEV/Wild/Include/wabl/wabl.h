#ifndef	WILD_WABL_FORMAT
#define WILD_WABL_FORMAT

#include <exec/types.h>
#include <exec/lists.h>
#include <utility/hooks.h>

// syntax: !&Comm/[Type|Name]

struct WABLFriend
{
 struct MinNode		WABL_F_Node;	 
 char			WABL_F_Comm[16]; // The command or attribute name
 char 			WABL_F_Type[16]; // The type of object linked
 char			WABL_F_Name[32]; // The name of the object linked
 struct WABLObject 	*WABL_F_Object;
 ULONG			WABL_F_UserData;
};

// syntax: !$Comm/[Value]

struct WABLAttr
{
 struct MinNode		WABL_A_Node;	// Link to other attrs of the object
 char			WABL_A_Comm[16]; // The command or attribute name
 char			*WABL_A_Value;	// The value (no size limit: it's a pointer!)
 ULONG			WABL_A_ValueLen; // Size of mem, to free then.
 ULONG			WABL_A_UserData;
};

// syntax: !#Type/[Name]

struct WABLObject
{
 struct MinNode		WABL_O_Node;	// Link to brothers.
 struct WABLObject	*WABL_O_Parent;	// Parent object.
 struct	MinList		WABL_O_Attrs;	// The attributes, defined with $ commands.
 struct MinList		WABL_O_Friends;	// The friends, using & commands.
 struct MinList		WABL_O_Childs;	// The child groups, defined with #??/ commands
 char			WABL_O_Type[16]; // You define with the command: #Level/[..] type is "Level"
 char			WABL_O_Name[32]; // You define with command's arg: #Level/[hey!] name is "hey!"
 ULONG			WABL_O_UserData;	// when using, useful having a userdata prt.
 struct	WABL		*WABL_O_WABL;
};

struct WABL
{
 struct	MinNode		WABL_Node;	// Useless now.
 struct	WABLObject	*WABL_Parent;	// Useless now.
 struct	MinList		WABL_Attrs;	// The attributes, defined with $ commands.
 struct MinList		WABL_Friends;	// Pointers to other objects, defined with & commands.
 struct MinList		WABL_Childs;	// The child groups, defined with #??/ commands
 ULONG			*WABL_Pool;	// memory pool of this WABL
 ULONG			*WABL_File;	// passed to hooks
 struct Hook		*WABL_GetChar;	// must return a char (call conv: A2:file A1:unused)
 struct Hook		*WABL_PutChar;	// must write a char  (call conv: A2:file A1:byte to write)
 ULONG			WABL_UserData;	// used by you.
};

#define GetWABLChar(wabl) CallHookPkt(wabl->WABL_GetChar,wabl->WABL_File,NULL)
#define PutWABLChar(wabl,byte) CallHookPkt(wabl->WABL_PutChar,wabl->WABL_File,byte)

#define	WABL_TagBase	0x84000000+('W'<<16)+2000	// WILDOTHER+2000

#define	WABL_FileHandle		WABL_TagBase+1		// passed as data to Get&PutChar hooks via A2. 
#define WABL_GetCharHook	WABL_TagBase+2		// the hook pointer
#define WABL_PutCharHook	WABL_TagBase+3		// the hook pointer

#define	WABL_NEWOBJECT	'#'
#define	WABL_NEWATTR	'$'
#define WABL_NEWFRIEND	'&'
#define WABL_COMMENT	'*'
#define WABL_ENDOBJECT	'-'
#define WABL_ENDCOMMAND	'/'
#define WABL_LINESTART	'!'

#endif