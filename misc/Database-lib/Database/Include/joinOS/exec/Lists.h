#ifndef _LISTS_H_
#define _LISTS_H_ 1
/* lists.h
 *
 * This is the implementation of the Exec list functions.
 *
 * A List is composed of a header and a doubly-linked chain of elements
 * called nodes. The header contains memory pointers to the first and last
 * nodes of the linked chain. The address of the header is used as the
 * handle to the entire list. To manipulate a list, you must provide the
 * address of its header.
 *
 *                            *----------------*
 *        +-------------------|   First Node   |
 *        |        +--------->|                |
 *        |  List  |          *----------------*
 *        | Header |             |         /|\
 *       \|/       |             |          |
 *    *----------------*        \|/         |
 *    |   Head Node    |      *----------------*
 *    *----------------*      |   Second Node  |
 *    |   Tail Node    |      *----------------*
 *    *----------------*         |         /|\
 *        |       /|\            |          |
 *        |        |            \|/         |
 *        |        |          *----------------*
 *        |        +----------|   Third Node   |
 *        +------------------>|                |
 *                            *----------------*
 *
 *			Simplified Overview of an Exec List
 *
 * Nodes may be scattered anywhere in memory. Each node contains two pointers;
 * a successor and a predecessor. As illustrated above, a list header contains
 *	two placeholder nodes that contain no data. In an empty list, the head and
 * the tail nodes point to each other.
 */

#include <joinOS/exec/defines.h>

#ifdef _AMIGA

#ifndef	EXEC_NODES_H
#include <exec/nodes.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#else		/* _AMIGA */

/* --- Structures for nodes and lists --------------------------------------- */

/*  List Node Structure.  Each member in a list starts with a Node
 */
struct Node		/* word-aligned, size 14 */
{
    struct  Node *ln_Succ;	/* Pointer to next (successor) */
    struct  Node *ln_Pred;	/* Pointer to previous (predecessor) */
    UBYTE   ln_Type;			/* see below for defines */
    BYTE    ln_Pri;			/* Priority, for sorting */
    char    *ln_Name;		/* ID string, null terminated */
};

/* minimal node -- no type checking possible
 */
struct MinNode		/* longword-aligned, size 8 */
{
    struct MinNode *mln_Succ;
    struct MinNode *mln_Pred;
};

/*  Full featured list header.
 */
struct List		/* word-aligned, size 14 */
{
   struct  Node *lh_Head;		/* first node in list */
   struct  Node *lh_Tail;		/* always NULL */
   struct  Node *lh_TailPred; /* last node in list */
   UBYTE   lh_Type;				/* type of nodes, see defines below */
   UBYTE   l_pad;
};

/* Minimal List Header - no type checking
 */
struct MinList		/* longword-aligned, size 12 */
{
   struct  MinNode *mlh_Head;
   struct  MinNode *mlh_Tail;		/* always NULL */
   struct  MinNode *mlh_TailPred;
};

/* One subtlety here must be explained further. the list header is constructed
 * in an efficient but confusing manner. Think of the header as a structure
 * containing the head and tail nodes for the list. The head and tail nodes are
 *	placeholders, and never carry data. The head and tail portions of the header
 * actually overlap in memory. lh_Head and lh_Tail form the head node; lh_Tail
 * and lh_TailPred form the tail node. This makes it easy to find the start or
 * end of the list, and eleminates any special cases for insertion or removal.
 *
 *
 *   "Head Node"   "Tail Node"        "Merged Header"
 *
 * *-------------*                    *-------------*
 * |   ln_Succ   |                    |   lh_Head   |
 * *-------------*-------------*      *-------------*
 * | ln_Pred = 0 | ln_Succ = 0 |  ==> | lh_Tail = 0 |
 * *-------------*-------------*      *-------------*
 *               |   ln_Pred   |      | lh_TailPred |
 *               *-------------*      *-------------*
 *
 *						List Header Overview
 */

/* --- Predefined symbolic values for nodes ln_Type field ------------------- */

/* Note: Newly initialized IORequests, and software interrupt structures
 * used with Cause(), should have type NT_UNKNOWN.  The OS will assign a type
 * when they are first used.
 */

/*----- Node Types for LN_TYPE -----*/
#define NT_UNKNOWN	0
#define NT_TASK		1	/* Exec task */
#define NT_INTERRUPT	2
#define NT_DEVICE		3
#define NT_MSGPORT	4
#define NT_MESSAGE	5	/* Indicates message currently pending */
#define NT_FREEMSG	6
#define NT_REPLYMSG	7	/* Message has been replied */
#define NT_RESOURCE	8
#define NT_LIBRARY	9
#define NT_MEMORY		10
#define NT_SOFTINT	11	/* Internal flag used by SoftInits */
#define NT_FONT		12
#define NT_PROCESS	13	/* AmigaDOS Process */
#define NT_SEMAPHORE	14
#define NT_SIGNALSEM	15	/* signal semaphores */
#define NT_BOOTNODE	16
#define NT_KICKMEM	17
#define NT_GRAPHICS	18
#define NT_DEATHMESSAGE	19

#define NT_USER		254	/* User node types work down from here */
#define NT_EXTENDED	255

/* --- Macros useful for list manipulation ---------------------------------- */

/*	Check for the presence of any nodes on the given list.	These
 *	macros are even safe to use on lists that are modified by other
 *	tasks.	However; if something is simultaneously changing the
 *	list, the result of the test is unpredictable.
 *
 *	Unless you first arbitrated for ownership of the list, you can't
 *	_depend_ on the contents of the list.  Nodes might have been added
 *	or removed during or after the macro executes.
 *
 *		if( IsListEmpty(list) )		printf("List is empty\n");
 */
#define IsListEmpty(x) \
	( ((x)->lh_TailPred) == (struct Node *)(x) )

#define IsMsgPortEmpty(x) \
	( ((x)->mp_MsgList.lh_TailPred) == (struct Node *)(&(x)->mp_MsgList) )

#endif		/* _AMIGA */

#endif		/* _LISTS_H_ */