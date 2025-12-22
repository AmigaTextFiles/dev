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

#include <exec/memory.h>

#include <memwatch.h> /* To enable memlib, you must #define MWDEBUG to 1 */

#include "lists.h"

ListNode_t *List_NewNode(void){
  ListNode_t *pNew=calloc(sizeof(ListNode_t),1);
  if(!pNew) X11resource_exit(sizeof(ListNode_t));
  return(pNew);
}

ListNode_t *List_MakeNull(void){
  return(List_NewNode());
}

void List_AddEntry(ListNode_t *pNode,void *pData){
  ListNode_t *pNew=List_NewNode();
  if( pData==0 || pNode==0 ){
    printf("Warning: null entry!\n");
    getchar();
    if(!pNode) exit(-1);
  }
  pNew->pNext=pNode->pNext;
  pNode->pNext=pNew;
  pNew->pData=pData;
}

void List_GetNext(ListNode_t **pNode){
  *pNode=(*pNode)->pNext;
}

void List_AddLast(ListNode_t *pNode,void *pData){
  ListNode_t *pNew,*pPrev=pNode;

  if( pData==0 || pNode==0 ){
    printf("Warning: null entry!\n");
    getchar();
    if(!pNode) exit(-1);
  }

  while( pNode->pNext ){
    pPrev=pNode;
    pNode=pNode->pNext;
  }

  pNew=List_NewNode();
  pNew->pNext=pPrev->pNext;
  pPrev->pNext=pNew;
  pNew->pData=pData;
}

void List_FreeList(ListNode_t *pNode){
  ListNode_t *pNext;
  pNext=pNode->pNext;
  if(!pNode){
    printf("Freeing null list!\n");
    exit(-1);
  }
  free(pNode);
  pNode=pNext;
  while(pNode){
    pNext=pNode->pNext;
    if(pNode->pData) free(pNode->pData);
    free(pNode);
    pNode=pNext;
  }
}

void List_RemoveEntry(ListNode_t *pNode,void *pData){
  ListNode_t *pPrev;
  if(!pNode){
    printf("Freeing entry from empty list!\n");
    exit(-1);
  }
  while(pNode && pNode->pData!=pData){
    pPrev=pNode;
    pNode=pNode->pNext;
  }

  if(!pNode){
    return;
  }
  if(pNode->pData==pData){
    pPrev->pNext=pNode->pNext;
    if(pNode->pData)
      free(pNode->pData);
    free(pNode);
  }
  else {
    printf("removing nonexistent entry\n");
    getchar();
  }

}

void List_RemoveNode(ListNode_t *pNode,void *pData){
  ListNode_t *pPrev;
  if(!pNode){
    printf("Freeing entry from empty list!\n");
    exit(-1);
  }
  while(pNode && pNode->pData!=pData){
    pPrev=pNode;
    pNode=pNode->pNext;
  }

  if(!pNode){
    return;
  }

  if(pNode->pData==pData){
    pPrev->pNext=pNode->pNext;
    free(pNode);
  }
}
