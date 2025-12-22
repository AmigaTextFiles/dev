/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     assoc
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 20, 1997: Created.
***/

#include <assert.h>
#include <stdio.h>
#include <X11/xlib.h>
#include <X11/X10.h>

int
MakeKey( XAssocTable* pTable, XID x_id )
{
  return (int)((x_id*101) % pTable->size);
}

XAssoc*
MakeAssocNode()
{
  XAssoc* pNode;

  pNode = (XAssoc*)calloc( sizeof(XAssoc), 1 );

  return pNode;
}

XAssocTable *
XCreateAssocTable(size)
     int size;
{
  XAssocTable* pTable;

  pTable = (XAssocTable*)malloc(sizeof(XAssocTable));
  assert( pTable );
  pTable->buckets = (XAssoc*)calloc(sizeof(XAssoc)*size,1);
  pTable->size = size;

  return pTable;
}

char *
XLookUpAssoc(display, table, x_id)
     Display *display;
     XAssocTable *table;
     XID x_id;
{
  int vKey = MakeKey( table, x_id );
  XAssoc* pNode;

  pNode = table->buckets[vKey].next;

  while( pNode != NULL ){
    if( pNode->x_id == x_id )
      return pNode->data;
    pNode = pNode->next;
  }

  printf( "didn't find %d at %d\n", x_id, vKey );
  return NULL;
}

XMakeAssoc(display, table, x_id, data)
     Display *display;
     XAssocTable *table;
     XID x_id;
     char * data;
{
  int vKey = MakeKey( table, x_id );
  XAssoc* pPrev;
  XAssoc* pNode;

  pPrev = &table->buckets[vKey];
  pNode = MakeAssocNode();
  pNode->next = pPrev->next;
  pPrev->next = pNode;
  pNode->prev = pPrev;
  pNode->display = display;
  pNode->x_id = x_id;
  pNode->data = data;

  // printf( "inserting %d at %d\n", x_id, vKey );

  return(0);
}

XDeleteAssoc(display, table, x_id)
     Display *display;
     XAssocTable *table;
     XID x_id;
{
}

XDestroyAssocTable(table)
     XAssocTable *table;
{
}
