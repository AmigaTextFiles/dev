//
//	$VER: llist.h 2.0 (17.1.99)
//
//	Library base, tags, structures and macro definitions
//	for llist.library.
//
//	©1996-1997 Henrik Isaksson
//	All Rights Reserved.
//

#ifndef LIBRARIES_LLIST_H
#define LIBRARIES_LLIST_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define LINK_INFO	struct LinkInfo _LL_Link
#define LINK_AUTO	struct LinkAuto _LL_Link
#define LL_SIZE		sizeof(struct LinkList)

struct LinkInfo {
	struct LinkInfo	*Prev;	//  0 Previuos item
	struct LinkInfo	*Next;	//  4 Next item
	ULONG		Size;	//  8 Size of this item
	UWORD		Type;	// 12 Kind of item
};			  // size: 14

struct LinkList {
	LINK_INFO;
	struct LinkInfo *First;		// 14 First item
	struct LinkInfo *Last;		// 18 Last item
	struct LinkInfo *Current;	// 22 Current item
};				  // size: 26

typedef struct LinkList LinkList;
typedef struct LinkInfo LinkInfo;

//
// Macros
//

#define LL_Type(m)	(((struct LinkInfo *)m)->Type)
#define LL_Size(m)	(((struct LinkInfo *)m)->Size)
#define LL_VecSize(m)	(*((ULONG *)(((UBYTE *)m)-4)))
#define LL_DataSize(m)	(LL_VecSize(m)-4)
#define LL_Create(t)	(LL_New(sizeof(struct t)))
#define LL_Current(l)	(((struct LinkList *)l)->Current)


//
// Node types
//

#define LL_UNKNOWN	0	// Default
#define LL_LIST		1	// Set by LL_NewList().
#define LL_STOP		2	// Used in file I/O.
#define LL_AUTO		3	// Automatic mode

#define LL_USER		100	// You may only use node types equal to, or
				// higher than, LL_USER.

#define LL_USERLIST	32000

//
// File ID's
// To reserve an ID of your own, just send me a mail.
//

#define LLID_DEMO		1	// Used for the demo
#define LLID_BOARDED		2	// BoardED's ID
#define LLID_UBASE		3	// UltraBase
#define LLID_BUILDER		4	// Magician
#define LLID_CBAR		5	// ControlBar
#define LLID_ICQ_CONTACT	6	// ICQSocket
#define LLID_ICQ_CONFIG		7	// ICQSocket
#define LLID_ICQ_RANDOM		8	// ICQSocket
#define LLID_ICQ_UNKNOWN	9	// ICQSocket
#define LLID_ICQ_INBOX		10	// ICQSocket

//
// Error codes
//

#define LLERR_FILETYPE	1	// Wrong file ID
#define LLERR_MEM	2	// Out of memory
#define LLERR_EOF	3	// Early end of file

#define LLERR_HOOK	100	// If you need to define your own returncodes
				// in the read/write hooks, only use numbers
				// higher than, or equal to this one.

//
// Tags for LL_MergeData() & LL_ExtractData()
//

#define XT_Base		TAG_USER
#define MD_Base		TAG_USER+100

#define XT_Byte		(XT_Base+1)
#define XT_Word		(XT_Base+2)
#define XT_Long		(XT_Base+3)
#define XT_IntelWord	(XT_Base+4)
#define XT_IntelLong	(XT_Base+5)
#define XT_BLBlock	(XT_Base+6)	// Block of data, length stored as a byte
#define XT_WLBlock	(XT_Base+7)	// Block of data, length as Motorola Word
#define XT_LLBlock	(XT_Base+8)
#define XT_IWLBlock	(XT_Base+9)	// Length as Intel Word
#define XT_ILLBlock	(XT_Base+10)
#define XT_NullString	(XT_Base+11)	// NULL terminated string
#define XT_MaxLen	(XT_Base+50)	// The length of your buffer. Defaults to 1k.

#define MD_Byte		(MD_Base+1)
#define MD_Word		(MD_Base+2)
#define MD_Long		(MD_Base+3)
#define MD_IntelWord	(MD_Base+4)
#define MD_IntelLong	(MD_Base+5)
#define MD_BLBlock	(MD_Base+6)	// Block of data, length stored as a byte
#define MD_WLBlock	(MD_Base+7)	// Block of data, length as Motorola Word
#define MD_LLBlock	(MD_Base+8)
#define MD_IWLBlock	(MD_Base+9)	// Length as Intel Word
#define MD_ILLBlock	(MD_Base+10)
#define MD_NullString	(MD_Base+11)	// NULL terminated string
#define MD_String	(MD_Base+12)	// Just the string chars
#define MD_Size		(MD_Base+50)	// Size of next block

//
// Library base
//

struct LListBase {
	struct Library		ll_Library;
	ULONG			ll_SegList;
	ULONG			ll_Flags;
	APTR			ll_MemPool;		// Memory pool
	LONG			ll_MemFile;		// Not implemented
	struct Library		*ll_ExecBase;
	struct Library		*ll_UtilityBase;
	struct Library		*ll_DOSBase;
};

#define LLIST_VERSION	2L
#define LLIST_NAME	"llist.library"
#define OPEN_LLIST()	(LListBase = (struct LListBase *)OpenLibrary(LLIST_NAME, LLIST_VERSION))
#define CLOSE_LLIST()	if(LListBase) CloseLibrary((struct Library *)LListBase);
#define LL_FILE_ID	(0x4a4a3461)

#endif
