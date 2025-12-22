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

#ifndef RESOURCE_LIST
#define RESOURCE_LIST

typedef struct lnode {
  char *name;
  char *data;
  struct lnode *next;
} listnode;

extern listnode *new(char*,char*);
extern void makenull(listnode **);
extern void insert(listnode**,listnode*);
extern void deleteentry(listnode**,char*);
extern char *findentry(listnode*,char*);
extern void deletelist(listnode**);

#endif /* RESOURCE_LIST */
