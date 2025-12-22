/*
** ObjectiveAmiga: Implementation of class ExecList
** See GNU:lib/libobjam/ReadMe for details
*/


#import <objam/ExecList.h>
#include <proto/exec.h>


@implementation ExecList

// Initializing and freeing a list

- init
{
  if(![super init]) return nil;
  if(!(zone=NXCreateZone(2*vm_page_size,vm_page_size,YES))) return [self free];
  if(!(list=NXZoneMalloc(zone,sizeof(struct List)))) return [self free];
  NewList(list);
  return self;
}

- free
{
  if(zone) NXDestroyZone(zone);
  return [super free];
}

// Naming a list

- (const char *)name
{
  return listName ? listName : [super name];
}

- name:(const char *)name
{
  if(listName) free(listName);
  return (listName=NXCopyStringBufferFromZone(name,[self zone])) ? self : nil;
}

// Getting the Exec list

- (struct List *)execList
{
  return list;
}

// Manipulating contents by index

- (struct Node *)firstNode
{
  if([self isEmpty]) return NULL;
  return list->lh_Head;
}

- (struct Node *)lastNode
{
  if([self isEmpty]) return NULL;
  return list->lh_TailPred;
}

- (struct Node *)nodeAt:(unsigned int)index
{
  struct Node *node;
  unsigned int num=0;
  for(node=list->lh_Head;node->ln_Succ;node=node->ln_Succ,num++) if(num==index) return node;
  return NULL;
}

- (const char *)nameAt:(unsigned int)index
{
  struct Node *node;
  unsigned int num=0;
  for(node=list->lh_Head;node->ln_Succ;node=node->ln_Succ,num++) if(num==index) return node->ln_Name;
  return NULL;
}

- (unsigned int)count
{
  struct Node *node;
  unsigned int num=0;
  for(node=list->lh_Head;node->ln_Succ;node=node->ln_Succ) num++;
  return num;
}

- (BOOL)isEmpty
{
  if(list->lh_TailPred==(struct Node *)list) return TRUE;
  return FALSE;
}

// Manipulating contents by name

- (struct Node *)addNodeNamed:(const char *)aName
{
  struct Node *newNode;
  unsigned int textLength;

  if(!aName) return NULL;
  if((textLength=strlen(aName)+1)==1) return NULL;

  if(newNode=NXZoneMalloc(zone,sizeof(struct Node)))
  {
    if(newNode->ln_Name=NXZoneMalloc(zone,textLength))
    {
      CopyMem((APTR)aName,newNode->ln_Name,textLength);
      AddTail(list,newNode);
      return newNode;
    }
    else { free(newNode); return NULL; }
  }
  else return NULL;
}

- (struct Node *)nodeNamed:(const char *)aName
{
  return FindName(list,(UBYTE *)aName);
}

// Manipulating contents by node

// Comparing and combining Lists

// Emptying a List

- empty
{
  struct Node *workNode,*nextNode;

  workNode=list->lh_Head;
  while(nextNode=workNode->ln_Succ)
  {
    free(workNode->ln_Name);
    free(workNode);
    workNode=nextNode;
  }
  NewList(list);

  return self;
}

// Archiving

- read:(NXTypedStream*)stream
{
  struct Node *node;
  char *string;
  unsigned int i, numElements;
  [self init];
  [super read:stream];
  NXReadTypes(stream,"I",&numElements);
  for(i=0;i<numElements;i++)
  {
    if(!NXReadTypes(stream,"*",&string)) return nil;
    if(![self addNodeNamed:string]) return nil;
  }
  return self;
}

- write:(NXTypedStream*)stream
{
  unsigned int numElements=[self count];
  struct Node *node;
  char *null=0;
  [super write:stream];
  NXWriteTypes(stream,"I",&numElements);
  for(node=list->lh_Head;node->ln_Succ;node=node->ln_Succ)
    if(!(NXWriteTypes(stream,"*",&(node->ln_Name)))) return nil;
  return self;
}

@end
