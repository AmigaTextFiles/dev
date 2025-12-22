/* $Id: nodes.h,v 1.2 1997/11/09 17:21:52 lars Exp $ */

#ifndef __NODES_H__
#define __NODES_H__ 1

struct noderef;  /* forward */

/* Node structure to build the dependency tree
 */
typedef struct node
 {
   struct node    * pLeft, * pRight;  /* Tree pointers */
   struct node    * pNext;    /* List of Files to do; stack for traversals */
   char           * pName;    /* Name associated with the node */
   int              iInclude; /* Index of the include path the file is in */
   short            flags;    /* misc flags */
   struct noderef * pDeps;    /* What this file depends on */
   struct noderef * pUsers;   /* Who depends on this file */
   short            iStage;   /* Stage counter for tree traversals */
 }
Node;

/* Node.flags
 */
#define NODE_MARK   (1<<0)  /* Generic Node marker, used e.g. in tree walks */
#define NODE_NEW    (1<<1)  /* Node is unused, but see NODE_HIDE as well */
#define NODE_SOURCE (1<<2)  /* Node is a skeleton source */
#define NODE_AVOID  (1<<3)  /* Node is a _not_ a skeleton file despite of NODE_SOURCE */
#define NODE_HIDE   (1<<4)  /* Node is an include file to hide
  * There is a special case: nodes with NODE_NEW|NODE_HIDE denote
  * include files-to-hide which have not been referenced for real
  * yet.
  */
#define NODE_DONE   (1<<5)  /* Node has been evaluated */

/* Node marking
 */
#define NODES_MARK(node)   (node->flags |= NODE_MARK)
#define NODES_UNMARK(node) (node->flags &= (short)(~NODE_MARK))
#define NODES_MARKED(node) (node->flags & NODE_MARK)

/* Reference structure to treenodes
 */
typedef struct noderef
 {
   struct noderef * pNext;  /* next NodeRef */
   Node           * pNode;  /* referenced Node */
 }
NodeRef;

/* Prototypes */
extern int       nodes_addsource (const char *, int);
extern int       nodes_depend (Node *, const char *);
extern Node    * nodes_todo (void);
extern void      nodes_initwalk (void);
extern Node    * nodes_inorder (void);
extern NodeRef * nodes_deplist (Node *, int);
extern void      nodes_freelist (NodeRef *);

#endif
