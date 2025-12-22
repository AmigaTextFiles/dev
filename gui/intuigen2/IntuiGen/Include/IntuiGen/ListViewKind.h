/*
ListViewKind.h

(C) Copyright 1993 Justin Miller
	This file is part of the IntuiGen package.
	Use of this code is pursuant to the license outlined in
	COPYRIGHT.txt, included with the IntuiGen package.

    As per COPYRIGHT.txt:

	1)  This file may be freely distributed providing that
	    it is unmodified, and included in a complete IntuiGen
	    2.0 package (it may not be distributed alone).

	2)  Programs using this code may not be distributed unless
	    their author has paid the Shareware fee for IntuiGen 2.0.
*/


#ifndef LISTVIEWKIND_H
#define LISTVIEWKIND_H

/***********************************************************************/
/*  This function adds a node to a list in alphabetical order by       */
/*  Node->ln_Name.  If NODUPLICATES flag is specified, node will not   */
/*  be added if another node with the same name is already in the      */
/*  list.  1 is returned if the node is added, 0 otherwise.	       */
/***********************************************************************/

#define NODUPLICATES 1
LONG AddNodeAlpha(struct List *l,struct Node *n,ULONG flags);


/***********************************************************************/
/* CountNodesInList returns the number of nodes in the given list.     */
/***********************************************************************/

ULONG CountNodesInList(struct List *l);


/***********************************************************************/
/* AddNamedNodeToList allocates a node on the given key, allocates a   */
/* string big enough for the given name on the given key, and adds the */
/* new node to the list.  If the ALPHA flag is specified the Node is   */
/* added in alphabetical order					       */
/***********************************************************************/

#define ALPHA 1
struct Node *AddNamedNodeToList(struct Remember **key,struct List *l,UBYTE *name,
    ULONG size,ULONG flags);


/***********************************************************************/
/* ChangeNodesName allocates enough room on the given key for the      */
/* new name, and assigns the node->ln_Name to the newly allocated      */
/* memory.  It then copies the given name into the newly allocated     */
/* memory.							       */
/***********************************************************************/

UBYTE ChangeNodesName(struct Remember **key,struct GTRequest *req,
    struct GTControl *gtc,struct List *l,struct Node *n,UBYTE *newname);


/***********************************************************************/
/* AddEntryToListBox calls AddNamedNodeToList to add a node with the   */
/* given name to a list box.  It also detaches the list from the list  */
/* box before beginning, and reattaches it when its done.	       */
/***********************************************************************/

struct Node *AddEntryToListBox(struct Remember **key,struct GTRequest *req,
    struct GTControl *gtc,struct List *l,UBYTE *name,ULONG size,ULONG flags);


/***********************************************************************/
/*  RemoveEntryFromListBox detaches the given list from the list box,  */
/*  removes the given node from the list, and reattaches the list to   */
/*  the list box.  It does not free the node.			       */
/***********************************************************************/

UBYTE RemoveEntryFromListBox(struct GTRequest *req,struct GTControl *gtc,
    struct List *l,struct Node *n);


/***********************************************************************/
/*  NodeToOrd returns a node's ordinal position in the list.  The      */
/*  first node in the list is 0, the second 1, and so on.	       */
/*  Convenient if you want to set a ListBox's selected attribute to    */
/*  a given node, but know only a node address and not its ordinal     */
/*  position, which Intuition requires. 			       */
/***********************************************************************/

ULONG NodeToOrd(struct List *l,struct Node *n);


/***********************************************************************/
/*  OrdToNode returns a node address from an ordinal position in the   */
/*  list (like what you get out of msg->Code or Control->Attribute     */
/*  when dealing with a ListView_Kind). 			       */
/***********************************************************************/

struct Node *OrdToNode(struct List *l,ULONG ord);

#endif

