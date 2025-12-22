/*
** ObjectiveAmiga: Interface to class ExecList
** See GNU:lib/libobjam/ReadMe for details
*/


// This class manages a simple Exec list with named nodes. This is especially
// useful for all kinds of ListView objects which operate on Exec lists (e.g.
// GadTools and Triton ListViews).
//
// All memory is allocated from a separate zone in order to avoid memory
// fragmentation and to allow easier cleanup.


#import <objc/Object.h>


#include <exec/lists.h>
#include <exec/nodes.h>


@interface ExecList: Object
{
  struct List *list;
  NXZone *zone;
  char *listName;
}

// Initializing and freeing a list

- init;
- free;

// Naming a list

- (const char *)name;
- name:(const char *)name;

// Getting the Exec list

- (struct List *)execList;

// Manipulating contents by index

//-- - (struct Node *)insertNodeNamed:(const char *)aName at:(unsigned int)index;
//-- - (struct Node *)removeNodeAt:(unsigned int)index;
//-- - (struct Node *)removeLastNode;
//-- - (struct Node *)replaceNodeAt:(unsigned int)index withNodeNamed:newName;
//-- - (struct Node *)renameNodeAt:(unsigned int)index as:newName;
- (struct Node *)firstNode;
- (struct Node *)lastNode;
- (struct Node *)nodeAt:(unsigned int)index;
- (const char *)nameAt:(unsigned int)index;
- (unsigned int)count;
- (BOOL)isEmpty;

// Manipulating contents by name

- (struct Node *)addNodeNamed:(const char *)aName;
//-- - (struct Node *)addNodeIfAbsentNamed:(const char *)aName;
//-- - (struct Node *)removeNodeNamed:(const char *)aName;
//-- - (struct Node *)replaceNodeNamed:(const char *)aName withNodeNamed:newName;
//-- - (struct Node *)renameNodeNamed:(const char *)aName as:newName;
- (struct Node *)nodeNamed:(const char *)aName;
//-- - (unsigned int)indexOfNodeNamed:(const char *)aName;

// Manipulating contents by node

//-- - (struct Node *)removeNode:(struct Node *)aNode;
//-- - (struct Node *)replaceNode:(struct Node *)aNode withNodeNamed:newName;
//-- - (struct Node *)renameNode:(struct Node *)aNode as:newName;
//-- - (unsigned int)indexOfNode:(struct Node *)aNode;

// Comparing and combining Lists

//-- - (BOOL)isEqual:anObject;
//-- - appendList:(ExecList*)otherList;

// Emptying a List

- empty;

// Archiving

- read:(NXTypedStream*)stream;
- write:(NXTypedStream*)stream;

@end
