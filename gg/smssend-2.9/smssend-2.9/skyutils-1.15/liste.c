/****************************************************************/
/* Chained list unit                                            */
/* (c) Christophe CALMEJANE (Ze KiLleR) - 1999-01               */
/****************************************************************/
#include <stdio.h>
#include <stdlib.h>

#include "skyutils.h"

#undef malloc
#undef calloc
#undef realloc
#undef strdup
#undef free

SU_PList SU_AddElementTail(SU_PList List,void *Elem)
{
  SU_PList Ptr,Ptr2,El;

  Ptr = List;
  Ptr2 = NULL;
  while(Ptr != NULL)
  {
    Ptr2 = Ptr;
    Ptr = Ptr->Next;
  }
  El = (SU_PList) malloc(sizeof(SU_TList));
  El->Next = NULL;
  El->Data = Elem;
  if(List == NULL)
    return El;
  Ptr2->Next = El;
  return List;
}

SU_PList SU_AddElementHead(SU_PList List,void *Elem)
{
  SU_PList El;

  El = (SU_PList) malloc(sizeof(SU_TList));
  El->Next = List;
  El->Data = Elem;
  return El;
}

SU_PList SU_DelElementElem(SU_PList List,void *Elem)
{
  SU_PList Ptr,Ptr2,St;

  if(List == NULL)
    return NULL;
  Ptr = List;
  St = List;
  Ptr2 = NULL;
  while(Ptr != NULL)
  {
    if(Ptr->Data == Elem)
    {
      Ptr = SU_DelElementHead(Ptr);
      if(Ptr2 == NULL)
        St = Ptr;
      else
        Ptr2->Next = Ptr;
      if(Ptr == NULL)
        return St;
    }
    Ptr2 = Ptr;
    Ptr = Ptr->Next;
  }
  return St;
}

SU_PList SU_DelElementTail(SU_PList List)
{
  SU_PList Ptr,Ptr2;

  if(List == NULL)
    return NULL;
  Ptr = List;
  Ptr2 = NULL;
  while(Ptr->Next != NULL)
  {
    Ptr2 = Ptr;
    Ptr = Ptr->Next;
  }
  free(Ptr);
  if(Ptr2 == NULL)
    return NULL;
  Ptr2->Next = NULL;
  return List;
}

SU_PList SU_DelElementHead(SU_PList List)
{
  SU_PList Ptr;

  if(List == NULL)
    return NULL;
  Ptr = List->Next;
  free(List);
  return Ptr;
}

SU_PList SU_DelElementPos(SU_PList List,int Pos)
{
  int p;
  SU_PList Ptr;

  if(List == NULL)
    return NULL;
  if(Pos <= 0)
    return SU_DelElementHead(List);
  Ptr = List;
  for(p=0;p<(Pos-1);p++)
  {
    Ptr = Ptr->Next;
    if(Ptr == NULL)
      return List;
  }
  if(Ptr->Next == NULL)
    return List;
  Ptr->Next = SU_DelElementHead(Ptr->Next);
  return List;
}

void *SU_GetElementTail(SU_PList List)
{
  SU_PList Ptr;

  if(List == NULL)
    return NULL;
  Ptr = List;
  while(Ptr->Next != NULL)
    Ptr = Ptr->Next;
  return Ptr->Data;
}

void *SU_GetElementHead(SU_PList List)
{
  if(List == NULL)
    return NULL;
  return List->Data;
}

void *SU_GetElementPos(SU_PList List,int Pos)
{
  int p;
  SU_PList Ptr;

  if(List == NULL)
    return NULL;
  if(Pos <= 0)
    return SU_GetElementHead(List);
  Ptr = List;
  for(p=0;p<Pos;p++)
  {
    Ptr = Ptr->Next;
    if(Ptr == NULL)
      return NULL;
  }
  return Ptr->Data;
}

void SU_FreeList(SU_PList List)
{
  SU_PList Ptr,Ptr2;

  Ptr = List;
  while(Ptr != NULL)
  {
    Ptr2 = Ptr->Next;
    free(Ptr);
    Ptr = Ptr2;
  }
}

void SU_FreeListElem(SU_PList List)
{
  SU_PList Ptr,Ptr2;

  Ptr = List;
  while(Ptr != NULL)
  {
    Ptr2 = Ptr->Next;
    free(Ptr->Data);
    free(Ptr);
    Ptr = Ptr2;
  }
}

int SU_ListCount(SU_PList List)
{
  SU_PList Ptr;
  int c;

  c = 0;
  Ptr = List;
  while(Ptr != NULL)
  {
    c++;
    Ptr = Ptr->Next;
  }
  return c;
}

