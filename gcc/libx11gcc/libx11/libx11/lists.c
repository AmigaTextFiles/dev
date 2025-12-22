/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     lists
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Feb 15, 1996: Created.
***/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <exec/memory.h>

//#include <memwatch.h> 
/* To enable memlib, you must #define MWDEBUG to 1 */

#include "debug.h"
#include "lists.h"

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

__inline List_p
List_NewNode( void )
{
  ListNode_p pNew = calloc(sizeof(ListNode_t),1);

#if (DEBUG!=0)
  if( !pNew )
    X11resource_exit(sizeof(ListNode_t));
#endif /* DEBUG */

  return(pNew);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

List_p
List_MakeNull( void )
{
  List_p l = List_NewNode();
  l->pData = (void*)-1;

  return(l);
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
List_AddEntry( ListNode_t *pNode, void *pData )
{
  ListNode_t *pNew = List_NewNode();

#if (DEBUG!=0)
  if( pData==0 || pNode==0 ){
    printf("Warning: null entry!\n");
    getchar();
    if( !pNode )
      exit(-1);
  }
#endif /* DEBUG */
  pNew->pNext = pNode->pNext;
  pNode->pNext = pNew;
  pNew->pData = pData;
}

void
List_InsertSorted( List_p pList, void *pData, boolean (*bLessThan)(void*,void*) )
{
  ListNode_p pNew = List_NewNode();
  ListNode_p pNode = pList->pNext;
  ListNode_p pPrev = pList;

#if (DEBUG!=0)
  if( pData==0 || pList==0 ){
    printf("Warning: null entry!\n");
    getchar();
    if( !pList )
      exit(-1);
  }
#endif /* DEBUG */

  while( pNode!=NULL && !bLessThan(pNode,pNode->pData) ){
    pPrev = pNode;
    pNode = pNode->pNext;
  }
  pNew->pNext = pNode;
  pPrev->pNext = pNew;
  pNew->pData = pData;
}


/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
List_GetNext( ListNode_t **pNode )
{
  *pNode = (*pNode)->pNext;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

ListNode_t **
ListIter_GetNext( ListNode_t **pNode )
{
  ListNode_t **pNext;

  if( *pNode ){
    pNext = pNode;
    *pNode = (*pNode)->pNext;

    return pNext;
  } else
    return NULL;
}

ListNode_t **
ListIter_GetFirst( ListNode_t *pNode )
{
  return( &(pNode->pNext) );
}

boolean
ListIter_IsEmpty( ListNode_t **pNode )
{
  if( *pNode )
    return FALSE;
  else
    return TRUE;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
List_AddLast( ListNode_t *pNode, void *pData )
{
  ListNode_t *pNew, *pPrev = pNode;

#if (DEBUG!=0)
  if( pData==0 || pNode==0 ){
    printf("Warning: null entry!\n");
    getchar();
    if(!pNode)
      exit(-1);
  }
#endif /* DEBUG */

  while( pNode->pNext ){
    pPrev = pNode;
    pNode = pNode->pNext;
  }

  pNew = List_NewNode();
  pNew->pNext = pPrev->pNext;
  pPrev->pNext = pNew;
  pNew->pData = pData;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
List_FreeList( ListNode_t *pNode )
{
  ListNode_t *pNext;

  pNext = pNode->pNext;
#if (DEBUG!=0)
  if( !pNode ){
    printf("Freeing null list!\n");
    exit(-1);
  }
#endif /* DEBUG */
  free( pNode );
  pNode = pNext;
  while( pNode ){
    pNext = pNode->pNext;
    if( pNode->pData ){
      free( pNode->pData );
    }
    free( pNode );
    pNode = pNext;
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
List_RemoveEntry( ListNode_t *pNode, void *pData )
{
  ListNode_t *pPrev = NULL;

#if (DEBUG!=0)
  if( !pNode ){
    printf("Freeing entry from empty list!\n");
    exit(-1);
  }
  if( !pData ){
    printf("Freeing null entry from list!\n");
    exit(-1);
  }
#endif /* DEBUG */
  while( pNode && pNode->pData!=pData ){
    pPrev = pNode;
    pNode = pNode->pNext;
  }

  if( !pNode ){
    return;
  }
  if( pNode->pData==pData ){
    assert( pPrev );
    pPrev->pNext = pNode->pNext;
    if( pNode->pData ){
      free( pNode->pData );
    }
    free( pNode );
  } else {
    printf("removing nonexistent entry\n");
    getchar();
  }

}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/
void
List_RemoveNode( ListNode_t *pNode, void *pData )
{
  ListNode_t *pPrev = NULL;

#if (DEBUG!=0)
  if( !pNode ){
    printf("Freeing entry from empty list!\n");
    exit(-1);
  }
#endif /* DEBUG */
  while( pNode && pNode->pData!=pData ){
    pPrev = pNode;
    pNode = pNode->pNext;
  }

  if( !pNode ){
    return;
  }

  if( pNode->pData==pData ){
    assert( pPrev );
    pPrev->pNext = pNode->pNext;
    free( pNode );
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
List_CountEntries( ListNode_t *pNode )
{
  ListNode_t *pNext;
  int nEntries = 0;

  pNext=pNode->pNext;
  if( !pNode ){
    printf("Freeing null list!\n");
    exit(-1);
  }
  while( pNode ){
    nEntries++;
    pNode=pNode->pNext;
  }

  return nEntries;
}
