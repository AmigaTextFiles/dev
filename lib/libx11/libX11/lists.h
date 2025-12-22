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

#ifndef LISTS
#define LISTS

typedef struct node {
  void *pData;
  struct node *pNext;
} ListNode_t;

typedef struct list {
  struct node *pFirst;
  struct node *pLast;
} List_t;


void List_FreeList(ListNode_t *pNode);
void List_AddEntry(ListNode_t *pNode,void *pData);
void List_AddLast(ListNode_t *pNode,void *pData);
void List_RemoveEntry(ListNode_t *pNode,void *pData);
void List_RemoveNode(ListNode_t *pNode,void *pData);
ListNode_t *List_MakeNull(void);
ListNode_t *List_NewNode(void);
void List_GetNext(ListNode_t **pNode);

#endif /* LISTS */
