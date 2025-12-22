#include "TreeTool.h"
#include <stdio.h>

/* Some prototypes. */
void displayFunc(NODE_HANDLE);
void killFunc(struct someData *);

struct someData
{
  int   a,b,c;
  char  *string;
}

main()
{
  NODE_HANDLE         a_tree=NULL;
  struct someData     data1={1,2,3,"Root node."},data2,data3={7,8,9,"Sub-child node."};
  struct someData     *ptrDat2;

  /* We create our tree root. */
  a_tree=tt_NewNode(NULL,NULL);

  /* Let's create a child.    */
  tt_NewNode(a_tree,&data2);

  /* Create a child of the child. */
  tt_NewNode(tt_GetFirstSon(a_tree),&data3);

  /* Set the root node pointer. */
  tt_SetNodeData(a_tree,&data1);

  /* Get the user data pointer to the child node. */
  ptrDat2=tt_GetNodeData(tt_GetFirstSon(a_tree));

  /* We can now fill it with "meaningfull" information. */
  if( ptrDat2 )
  {
    ptrDat2->a=4;
    ptrDat2->b=5;
    ptrDat2->c=6;
    ptrDat2->string="Child node.";
  }

  /* We will use our displayFunc to recursively display the message */
  /* in each node.                                                  */
  tt_ApplyFunction(a_tree,displayFunc);

  printf("\n");

  /* We kill all the allocated nodes before quitting.                 */
  /* We could just have used tt_KillNode(a_tree,NULL) because data is */
  /* static.                                                          */
  tt_KillNode(a_tree,killFunc);
}

void displayFunc(NODE_HANDLE node)
{
  struct someData *ptrData;

  if( ptrData=tt_GetNodeData(node) )
  {
    printf("This node contains the message: %s\n",ptrData->string);
  }
}

void killFunc(struct someData *ptrData)
{

   /* Actually does nothing but could do something if dynamic data was  */
   /* used.                                                             */
   printf("Killing the node containing message: %s\n",ptrData->string);
}
