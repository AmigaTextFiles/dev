#include <stdio.h>

#import <objam/FlatList.h>
#import <objam/ExecList.h>
#import <objam/FileList.h>
#import "FooObject.h"


void testflatlist(void)
{
  id myList,foo1,foo2,foo3,foo4,foo5;

  foo1=[[FooObject new] setFoo:100];
  foo2=[[FooObject new] setFoo:2000];
  foo3=[[FooObject new] setFoo:3];
  foo4=[[FooObject new] setFoo:444];
  foo5=[[FooObject new] setFoo:505];

  if(myList=[FlatList new])
  {
    [myList addObject:foo1];
    [myList addObject:foo2];
    [myList addObject:foo3];
    [myList addObject:foo4];
    [myList addObject:foo5];
    [myList makeObjectsPerform:@selector(printFoo)];
    if(!([myList storeOn:"ram:myFlatList.tds"])) puts("Error storing FlatList object.");
    [myList freeObjects];
    [myList free];

    if( myList = [FlatList readFrom:"ram:myFlatList.tds"] )
    {
      puts("Contents of read list:");
      [myList makeObjectsPerform:@selector(printFoo)];
      [myList free];
    }
    else puts("Error loading FlatList object.");
  }
  else puts("Error creating FlatList object.");
  return;
}


void testexeclist(void)
{
  id myList;
  struct Node *node;

  if(myList=[ExecList new])
  {
    printf("Number of elements in list: %d\n",[myList count]);
    [myList addNodeNamed:"foo"];
    [myList addNodeNamed:"bar"];
    printf("Number of elements in list: %d\n",[myList count]);
    for(node=[myList execList]->lh_Head;node->ln_Succ;node=node->ln_Succ) printf("Line: %s\n",node->ln_Name);
    if(!([myList storeOn:"ram:myExecList.tds"])) puts("Error storing ExecList object.");
    [myList free];

    if( myList = [ExecList readFrom:"ram:myExecList.tds"] )
    {
      printf("Number of elements in list: %d\n",[myList count]);
      for(node=[myList execList]->lh_Head;node->ln_Succ;node=node->ln_Succ)
	printf("Line: %s\n",node->ln_Name);
      [myList free];
    }
    else puts("Error loading ExecList object.");
  }
  else puts("Error creating ExecList object.");
  return;
}


void testfilelist(void)
{
  id myList;
  struct Node *node;

  if(myList=[FileList new])
  {
    if([myList addDirectory:"env:"])
    {
      for(node=[myList execList]->lh_Head;node->ln_Succ;node=node->ln_Succ)
	printf("Line: %s\n",node->ln_Name);
      [myList free];
    }
    else puts("Error adding 'env:' to FileList object.");
  }
  else puts("Error creating FileList object.");
  return;
}


int main(void)
{
  testflatlist();
  testexeclist();
  testfilelist();
  return 0;
}
