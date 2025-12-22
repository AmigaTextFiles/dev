/*
**      $VER: wildprefs.h 0.00 (2.10.98)
**
**      definition of WildPrefs
**
*/

#ifndef WILDPREFS_H
#define WILDPREFS_H

#ifndef  EXEC_LIBRARIES
#include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

#ifndef	UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#include <exec/lists.h>
#include <wild/wild.h>

// My library base.

struct WildPrefsBase
{
 struct Library         exb_LibNode;
 BPTR	                exb_SegList;
 struct ExecBase        *wpb_SysBase;
 struct	MinList		wpb_Apps;
};

#define exb_SysBase wpb_SysBase		// Just to be compatible with std StartUp.c

// The AppPrefs struct.

#define WIPR_BaseNameMaxLen 	 32	// Max len of basename!

struct AppPrefs
{
 struct	MinNode 	ap_Node;		// The list node
 struct	TagItem		*ap_Tags;		// The Current prefs, in the tags form.
 char			ap_BaseName[32];	// The Application BaseName. 
 ULONG			*ap_PrefsBuffer;	// Buffer for tags data.
 ULONG			ap_PrefsBufferSize;	// Size of the buffer.
 struct WildApp		*ap_WildApp;
};

#define ap_BaseName_offset	12	// Don't know how to code... hak.

struct FileTag
{
 UBYTE	ft_Flags;				// Flags for this tag.
 UBYTE	ft_PAD;
 ULONG	ft_Len;					// Data len. (only for pointed)
 ULONG	ft_Tag;					// The tag. 
};

#define FTF_PointerToData	0x01

struct PrefsFile
{
 int	pf_Num;					// Num of tags.
 ULONG	pf_BufSize;				// Size of the prefsbuffer: the one containing all the not-pointed tags data.
};

#endif 







