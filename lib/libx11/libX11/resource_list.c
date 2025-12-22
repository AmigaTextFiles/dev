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
     resource_list
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Mar 14, 1995: Created.
***/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "resource_list.h"
#include "libx11.h"
#include "amigax_proto.h"

listnode *makenode(char *name,char *data){
  listnode *n=malloc(sizeof(listnode));
  char *str1=NULL,*str2=NULL;
  if(!n) X11resource_exit(RESOURCE1);
  if(name!=NULL){
    str1=malloc(strlen(name)+1);
    if(!str1) X11resource_exit(RESOURCE2);
    strcpy(str1,name);
  }
  if(data!=NULL){
    str2=malloc(strlen(data)+1);
    if(!str2) X11resource_exit(RESOURCE3);
    strcpy(str2,data);
  }
  n->name=str1;
  n->data=str2;
  n->next=NULL;
  return(n);
}

void makenull(listnode **list){
  listnode *n=malloc(sizeof(listnode));
  if(!n) X11resource_exit(RESOURCE4);
  n->data=(char*)999;
  n->name=(char*)999;
  n->next=NULL;
  *list=n;
}

void insert(listnode **list,listnode *n){
  listnode *p=*list,*prev=*list;
  if((int)p->data==999||stricmp(n->name,p->name)<0){
    n->next=*list;
    *list=n;
    return;
  }
  while((int)p->data!=999&&stricmp(p->name,n->name)<=0){
    prev=p;
    p=p->next;
  }
  n->next=p;
  prev->next=n;
}

char *findentry(listnode *list,char *name){
  listnode *p=list;
  while((int)p->data!=999&&stricmp(name,p->name)!=0) p=p->next;
  if((int)p->data!=999) return p->data;
  return NULL;
}

void deleteentry(listnode **list,char *name){
  listnode *p=*list,*prev=*list;
  if((int)p->data==999) return;
  if(stricmp(name,p->name)==0){
    *list=(*list)->next;
    free(p->name);
    free(p->data);
    free(p);
    return;
  }
  while((int)p->data!=999&&stricmp(p->name,name)!=0){
    prev=p;
    p=p->next;
  }
  if((int)p->data!=999){
    prev->next=p->next;
    free(p->name);
    free(p->data);
    free(p);
  }
}

void deletelist(listnode **list){
  listnode *p;
  while(*list!=NULL){
    p=*list;
    *list=(*list)->next;
    if((int)p->data!=999){
      free(p->name);
      free(p->data);
    }
    free(p);
  }
}

