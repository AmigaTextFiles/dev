/* $Id: nodes.c,v 1.4 1997/11/09 17:21:52 lars Exp $ */

/*---------------------------------------------------------------------------
** Management of the dependency tree and nodes.
**
** Copyright © 1995-1997  Lars Düning  -  All rights reserved.
** Permission granted for non-commercial use.
**---------------------------------------------------------------------------
** Each file (source or include) is associated one node which is kept in
** a binary search tree with the name as index. Glued to each node is
** a list of that nodes which files the master nodes includes.
** Each node contains an extra node pointer the module uses to implement
** tree-independant lists, namely the TODO list of files still to read
** and a virtual stack for inorder tree traversals.
*
** Adding and retrieving the files to analyse is done using the functions
**   nodes_addsource()
**   nodes_depend()
**   nodes_todo()
**
** The output of the dependency tree is done inorder using
**   nodes_initwalk()
**   nodes_inorder()
**
** The list of dependencies for one single node is managed using
**   nodes_deplist()
**   nodes_freelist()
**
** Tree traversal and creation must not be mixed!
**---------------------------------------------------------------------------
** C: DICE 3.20
**---------------------------------------------------------------------------
** [lars] Lars Düning; <duening@ibr.cs.tu-bs.de>
**---------------------------------------------------------------------------
** 10-Sep-95 [lars]
** 25-Feb-96 [lars] Added .pUsers to node structure, extended the routines
**    nodes_depend() and nodes_deplist().
**---------------------------------------------------------------------------
** $Log: nodes.c,v $
** Revision 1.4  1997/11/09  17:21:52  lars
** New option -H=HIDE/K to hide included files from being listed in the Makefile.
** Names are stored in args::aIHide[], the corresponding nodes are marked with
** NODE_HIDE.
**
** Revision 1.3  1997/11/08  19:49:36  lars
** The dependency lists are kept in alphabetical order, to allow for
** sorted printing.
**
** Revision 1.2  1997/11/08  19:02:01  lars
** Added the patches and bugfixes submitted by Flavio Stanchini.
** Updated my address.
**
** Revision 1.1  1996/02/25  20:41:45  lars
** Put under RCS.
**
**---------------------------------------------------------------------------
*/

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "nodes.h"

/*-------------------------------------------------------------------------*/

/* Types for block allocation of Nodes and NodeRefs.
 * Note that Nodes are never freed.
 */

#define NBLOCKSIZE 16

typedef struct nodeblock
 {
  struct nodeblock * pNext;               /* Next nodeblock */
  int                iFree;               /* Number of first free node */
  Node               aNodes[NBLOCKSIZE];  /* Block of nodes */
 }
NodeBlock;

#define RBLOCKSIZE 16

typedef struct refblock
 {
  struct refblock * pNext;              /* Next refblock */
  int               iFree;              /* Number of first free noderef */
  NodeRef           aRefs[NBLOCKSIZE];  /* Block of noderefs */
 }
RefBlock;

/*-------------------------------------------------------------------------*/

static NodeBlock *pFreeNBlocks = NULL;  /* Nodeblocks */
static RefBlock  *pFreeRBlocks = NULL;  /* Refblocks */
static NodeRef   *pFreeRefs    = NULL;  /* List of free NodeRefs */
static Node      *pTree        = NULL;  /* Dependency tree */
static Node      *pList        = NULL;  /* List of (tree) nodes */
  /* The List is used as TODO list for the files to analyse as well as
   * stack simulation for the tree traversal.
   */

/*-------------------------------------------------------------------------*/
static Node *
nodes_newnode (void)

/* Allocate a new Node.
 *
 * Result:
 *   Pointer to the new Node, or NULL on error.
 *
 * The memory of the Node is cleared, except for .flags which is set
 * to NODE_NEW.
 */

{
  Node * pNode;

  if (!pFreeNBlocks || !pFreeNBlocks->iFree)
  {
    NodeBlock * pNewBlock;
    pNewBlock = (NodeBlock *)malloc(sizeof(*pNewBlock));
    if (!pNewBlock)
      return NULL;
    memset(pNewBlock, 0, sizeof(*pNewBlock));
    pNewBlock->iFree = NBLOCKSIZE;
    pNewBlock->pNext = pFreeNBlocks;
    pFreeNBlocks = pNewBlock;
  }
  pNode = &(pFreeNBlocks->aNodes[--pFreeNBlocks->iFree]);
  pNode->flags |= NODE_NEW;
  return pNode;
}

/*-------------------------------------------------------------------------*/
static NodeRef *
nodes_newref (void)

/* Allocate a new NodeRef.
 *
 * Result:
 *   Pointer to the new NodeRef, or NULL on error.
 *
 * The memory of the NodeRef is cleared.
 */

{
  NodeRef * pRef;

  if (pFreeRefs)
  {
    pRef = pFreeRefs;
    pFreeRefs = pRef->pNext;
  }
  else
  {
    if (!pFreeRBlocks || !pFreeRBlocks->iFree)
    {
      RefBlock * pNewBlock;
      pNewBlock = (RefBlock *)malloc(sizeof(*pNewBlock));
      if (!pNewBlock)
        return NULL;
      pNewBlock->iFree = NBLOCKSIZE;
      pNewBlock->pNext = pFreeRBlocks;
      pFreeRBlocks = pNewBlock;
    }
    pRef = &(pFreeRBlocks->aRefs[--pFreeRBlocks->iFree]);
  }
  memset(pRef, 0, sizeof(*pRef));
  return pRef;
}

/*-------------------------------------------------------------------------*/
static void
nodes_freeref (NodeRef * pRef)

/* Free a NodeRef.
 *
 *  pRef: Pointer to the NodeRef to free.
 */

{
  assert(pRef);
  pRef->pNext = pFreeRefs;
  pFreeRefs = pRef;
}

/*-------------------------------------------------------------------------*/
static void
nodes_addref (NodeRef * pRef, NodeRef ** ppRoot)

/* Add a NodeRef to a list of NodeRefs
 *
 *  pRef  : Pointer to the NodeRef to add.
 *  ppRoot: Pointer to the pointer to the first NodeRef in the list.
 *
 * The new NodeRef is added to the list at the proper lexicographical
 * position.
 */

{

  const char * pNodeName;
  NodeRef    * pPrev;

  assert(pRef);
  assert(ppRoot);

  pNodeName = pRef->pNode->pName;

  /* Easy case: insertion at the begin of the list */
  if (!*ppRoot || strcmp(pNodeName, (*ppRoot)->pNode->pName) <= 0)
  {
    pRef->pNext = *ppRoot;
    *ppRoot = pRef;
    return;
  }

  /* The rest is insertion in a single-linked list */
  pPrev = *ppRoot;
  while (pPrev->pNext && strcmp(pNodeName, pPrev->pNext->pNode->pName) > 0)
    pPrev = pPrev->pNext;

  pRef->pNext = pPrev->pNext;
  pPrev->pNext = pRef;
}

/*-------------------------------------------------------------------------*/
static Node *
nodes_findadd (const char *pName)

/* Find the node associated with file *pName. If necessary, add the node.
 *
 *   pName: Pointer to the filename of the node.
 *
 * Result:
 *   Pointer to the node associated with this filename, or NULL on error.
 *
 * If the nodes has been added by this call, NODE_NEW is set in its .flags.
 */

{
  Node * pThis, * pPrev;
  int    i;

  assert(pName);
  pPrev = NULL;
  if (!pTree)
  {
    pTree = nodes_newnode();
    return pTree;
  }
  pThis = pTree;
  while(pThis)
  {
    i = strcmp(pThis->pName, pName);
    if (!i)
      return pThis;
    pPrev = pThis;
    if (i > 0)
      pThis = pThis->pLeft;
    else
      pThis = pThis->pRight;
  }
  pThis = nodes_newnode();
  if (pThis)
  {
    if (i > 0)
      pPrev->pLeft = pThis;
    else
      pPrev->pRight = pThis;
  }
  return pThis;
}

/*-------------------------------------------------------------------------*/
int
nodes_addsource (const char *pName, int iAvoid)

/* Add a source file to the dependency tree.
 *
 *   pName : Name of the file to add.
 *   iAvoid: 0 for sourcefiles,
 *           >0 if the file is explicitely _no_ sourcefile,
 *           <0 if the file is an include file to hide.
 *
 * Result:
 *   0 on success, non-0 on error (out of memory).
 *
 * The file is also added to the internal TODO list of files if it is
 * a sourcefile.
 * It is possible to add a source file in one call, and then in later
 * calls modify it to an exempted sourcefile or even an hidden include
 * file later on.
 */

{
  Node *pNode;

  assert(pName);
  pNode = nodes_findadd(pName);
  if (!pNode)
    return 1;
  if (pNode->flags & NODE_NEW)
  {
    if (iAvoid >= 0)
      pNode->flags = NODE_SOURCE;
    else
      pNode->flags = 0;
    pNode->pName = strdup(pName);
    if (!pNode->pName)
      return 1;
    if (!iAvoid)
    {
      pNode->pNext = pList;
      pList = pNode;
    }
  }

  if (iAvoid > 0)
    pNode->flags |= NODE_AVOID;
  if (iAvoid < 0)
    pNode->flags |= (NODE_HIDE|NODE_NEW);
    /* Setting flag NODE_NEW is a hack: this fools nodes_depend into thinking
     * that this node has been added by nodes_depend and thus needs to be
     * analysed. The effect we achieve is that the 'hidden' include files
     * are added to the TODO list not earlier than the first actual reference
     * form a source file.
     */
  return 0;
}

/*-------------------------------------------------------------------------*/
int
nodes_depend (Node * pDepender, const char * pName)

/* Add file *pName to the list of dependees of *pDepender, vice versa add
 * pDepender to the list of users of pName.
 *
 *  pDepender: Node which depends on the file given.
 *  pName    : Name of the file pDepender depends on.
 *
 * Result:
 *   0 on success, non-0 on error (out of memory).
 *
 * The file is added to the dependee- and user-lists of the given node.
 * If the file has no node in the dependency tree yet, one is created
 * and inserted, and is also added to the TODO list to compute nested
 * dependencies. Note that this gracefully handles 'assumed' include
 * files, as for these a node already exists.
 */

{
  Node    * pNode;
  NodeRef * pRef;

  assert(pDepender);
  assert(pName);

  pNode = nodes_findadd(pName);
  if (!pNode)
    return 1;
  if (pNode->flags & NODE_NEW)
  {
    pNode->flags = (pNode->flags & NODE_HIDE); /* see nodes_addsource() */
    pNode->pName = strdup(pName);
    if (!pNode->pName)
      return 1;
    pNode->pNext = pList;
    pList = pNode;
  }

  /* Add pNode to pDependers->pDeps if not already there */
  for ( pRef = pDepender->pDeps
      ; pRef && pRef->pNode != pNode
      ; pRef = pRef->pNext
      );
  if (!pRef)
  {
    pRef = nodes_newref();
    if (!pRef)
      return 1;
    pRef->pNode = pNode;
    nodes_addref(pRef, &(pDepender->pDeps));
  }

  /* Add pDepender to pNode->pUsers if not already there */
  for ( pRef = pNode->pUsers
      ; pRef && pRef->pNode != pDepender
      ; pRef = pRef->pNext
      );
  if (!pRef)
  {
    pRef = nodes_newref();
    if (!pRef)
      return 1;
    pRef->pNode = pDepender;
    nodes_addref(pRef, &(pNode->pUsers));
  }

  return 0;
}

/*-------------------------------------------------------------------------*/
Node *
nodes_todo (void)

/* Return the tree node of the next file to analyse.
 *
 * Result:
 *   Pointer to the node of the next file to analyse, or NULL if there is
 *   none.
 */

{
  Node * pNode;

  /* NODE_DONE should not happen, but checking it is free */
  while (pList && (pList->flags & (NODE_AVOID|NODE_DONE)))
    pList = pList->pNext;
  if (pList)
  {
    pNode = pList;
    pList = pList->pNext;
    pNode->flags |= NODE_DONE;
  }
  else
    pNode = NULL;
  return pNode;
}

/*-------------------------------------------------------------------------*/
void
nodes_initwalk (void)

/* Initialise a tree traversal.
 */

{
  assert(!pList);
  pList = pTree;
  if (pList)
  {
    pList->iStage = 0;
    pList->pNext = NULL;
  }
}

/*-------------------------------------------------------------------------*/
Node *
nodes_inorder (void)

/* Return the next Node of an inorder tree traversal.
 *
 * Result:
 *   Pointer to the next node, or NULL if traversal is complete.
 */

{
  Node *pNode;
  if (!pList)
    return NULL;
  while (pList)
  {
    switch (pList->iStage)
    {
    case 0:
      pList->iStage++;
      pNode = pList->pLeft;
      break;
    case 1:
      pList->iStage++;
      return pList;
      break;
    case 2:
      pList->iStage++;
      pNode = pList->pRight;
      break;
    case 3:
      pList = pList->pNext;
      pNode = NULL;
      break;
    default:
      assert(0);
      break;
    }
    if (pNode)
    {
      pNode->pNext = pList;
      pList = pNode;
      pNode->iStage = 0;
    }
  }
  return NULL;
}

/*-------------------------------------------------------------------------*/
NodeRef *
nodes_deplist (Node * pNode, int bUsers)

/* Gather the list of dependees or users of *pNode.
 *
 *   pNode: the Node to get the list for.
 *   bUsers: TRUE: gather the list of users instead of the dependees.
 *
 * Result:
 *   Pointer to the list of dependees/users, or NULL if an error occurs.
 *   First entry in the list is pNode itself.
 */

{
  NodeRef *pDList;
  NodeRef *pMark;
  NodeRef *pThis;
  NodeRef *pRover;
  Node    *pDep;

  assert(pNode);
  pDList = nodes_newref();
  if (!pDList)
    return NULL;

  /* The list of dependencies is gathered in a wide search. */
  pDList->pNode = pNode;
  NODES_MARK(pNode);
  for ( pThis = pDList, pMark = pDList
      ; pMark
      ; pMark = pMark->pNext
      )
  {
    for ( pRover = (bUsers ? pMark->pNode->pUsers : pMark->pNode->pDeps)
        ; pRover
        ; pRover = pRover->pNext
        )
    {
      pDep = pRover->pNode;
      if (!NODES_MARKED(pDep))
      {
        pThis->pNext = nodes_newref();
        if (!pThis->pNext)
          return NULL;
        pThis = pThis->pNext;
        pThis->pNode = pDep;
        NODES_MARK(pDep);
      }
    }
  }
  return pDList;
}

/*-------------------------------------------------------------------------*/
void
nodes_freelist (NodeRef * pDList)

/* Free a dependency list earlier produced by nodes_deplist().
 *
 *   pDList: Base of the list to free.
 */

{
  NodeRef * pThis;

  while (pDList)
  {
    NODES_UNMARK(pDList->pNode);
    pThis = pDList;
    pDList = pDList->pNext;
    pThis->pNext = pFreeRefs;
    pFreeRefs = pThis;
  }
}

/***************************************************************************/
