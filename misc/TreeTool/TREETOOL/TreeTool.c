/* -------------------------------------------------------------  */
/* TreeTool.c                                                     */
/* -------------------------------------------------------------  */
/*                                                                */
/* Function:  Provides basic functions to work with non-balanced  */
/*            , acyclic trees, in a structure independant way.    */
/*                                                                */
/*     Note: This code is public-domain, you can do wathever you  */
/*           want with it. But, I would like to know if you're    */
/*           using it somewhere.                                  */
/*                                                                */
/* History:                                                       */
/*                                                                */
/* 1.0: Summer 1993: Jean-Christophe Clement (Initial release)    */
/*                                                                */
/* -------------------------------------------------------------  */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "TreeTool.h"

void iKillNodes(NODE_HANDLE,void (*)() );
void iApplyFunction(NODE_HANDLE, void (*)());

extern int main();

/* -------------------------------------------------------------  */
/* tt_NewNode                                                     */
/*                                                                */
/* Function: Allocate memory for a new node. Will make the new    */
/*           node a son of the node 'nodeHandle'. Pointer to      */
/*           user data is kept.                                   */
/*     Note: If NULL is passed as 'nodeHandle', the function      */
/*           will return a node linked to nothing (Be aware to    */
/*           use it carefully). If NULL is passed as 'data', a    */
/*           NULL data pointer will be put in the node but the    */
/*           node will be created.				                        */
/*           Return NULL is no new node has been allocated.       */
/* -------------------------------------------------------------  */
NODE_HANDLE tt_NewNode(NODE_HANDLE nodeHandle,void *data)
{
  NODE_HANDLE newNode=NULL;
  NODE_HANDLE tempNode=NULL;

  if( newNode = (NODE_HANDLE) malloc(sizeof(struct node)) )
  {
    newNode->data=data;
    newNode->NextNode=NULL;
    newNode->FirstLeftSon=NULL;

    if( nodeHandle == NULL )
    { /* Create an unlinked node. */
      newNode->PreviousNode=NULL;
    }
    else
    { /* Create a node linked to the one passed */

      tempNode=tt_GetLastSon(nodeHandle);
      if(tempNode)
      { /* Add another son. */
        tempNode->NextNode=newNode;
        newNode->PreviousNode=tempNode;
      }
      else
      { /* Add the first son. */
        newNode->PreviousNode=nodeHandle;
        nodeHandle->FirstLeftSon=newNode;
      }
    }
  }
  return(newNode);
}

/* Function that kills all the same level and sub-level nodes from */
/* the passed node (included in the deletion).                     */
void iKillNodes(NODE_HANDLE nodeHandle,void (*killFunc)())
{
  if(nodeHandle)
  {
    iKillNodes(nodeHandle->FirstLeftSon,killFunc);
    iKillNodes(nodeHandle->NextNode, killFunc);
    if(nodeHandle->data && killFunc) (*killFunc)(nodeHandle->data);
    free(nodeHandle);
  }
}

/* -------------------------------------------------------------  */
/* tt_KillNode                                                    */
/*                                                                */
/* Function: Deallocate all the memory for the specified node     */
/*           and all of it's child's node memory. Frees data      */
/*           too using the passed function (of course, we         */
/*           assume that the client will de-allocate the data	    */
/*           correctly!)				                                  */
/*     Note: nil.                                                 */
/* -------------------------------------------------------------  */
void tt_KillNode(NODE_HANDLE nodeHandle, void (*killFunc)() )
{
  if(nodeHandle)
  {
    if(nodeHandle->PreviousNode) /* Watch if we are not on top of the tree. */
    {
      if(nodeHandle->NextNode)
      { /* If there is at least another node on the same level, it should */
        /* now points on the previous node.                               */
        nodeHandle->NextNode->PreviousNode=nodeHandle->PreviousNode;
      }
      if(nodeHandle->PreviousNode->FirstLeftSon == nodeHandle)
      { /* If the first left son is deleted, the father should point to the */
        /* new one.                                                         */
        nodeHandle->PreviousNode->FirstLeftSon = nodeHandle->NextNode;
      } else nodeHandle->PreviousNode->NextNode=nodeHandle->NextNode;
    }
    iKillNodes(nodeHandle->FirstLeftSon,killFunc); /* Kill the sub-nodes. */

    /* Deallocate the current node (data and node). */
    if(nodeHandle->data && killFunc) (*killFunc)(nodeHandle->data);
    free(nodeHandle);
  }
}

/* -------------------------------------------------------------  */
/* tt_GetLeftBrother                                              */
/*                                                                */
/* Function: Returns the left brother of the passed node if       */
/*           they both exist.                                     */
/*     Note: Returns NULL otherwise.                              */
/* -------------------------------------------------------------  */
NODE_HANDLE tt_GetLeftBrother(NODE_HANDLE nodeHandle)
{
  if(nodeHandle)
  {
    if( nodeHandle->PreviousNode->FirstLeftSon != nodeHandle )
    {
      return(nodeHandle->PreviousNode);
    }
  };
  return(NULL);
}

/* -------------------------------------------------------------  */
/* tt_GetRightBrother                                             */
/*                                                                */
/* Function: Returns the right brother of the passed node if      */
/*           they both exist.                                     */
/*     Note: Returns NULL otherwise.                              */
/* -------------------------------------------------------------  */
NODE_HANDLE tt_GetRightBrother(NODE_HANDLE nodeHandle)
{
  if(nodeHandle)
  {
    return(nodeHandle->NextNode);
  } else return(NULL);
}

/* -------------------------------------------------------------  */
/* tt_GetSuperMariosBrother                                       */
/*                                                                */
/* Function: To prove that there is still place for fun in        */
/*           computer sciences.                                   */
/*     Note: Is harmless actually.                                */
/* -------------------------------------------------------------  */
void tt_GetSuperMariosBrother()
{
  printf("SuperMario's Brother is Luigi.\n");
  printf("...and I'm really getting tired of all this Nintendo stuff.\n");
}

/* -------------------------------------------------------------  */
/* tt_GetFirstSon                                                 */
/*                                                                */
/* Function: Returns the first left son of the specified node.    */
/*     Note: Returns NULL is there is not such a son.             */
/* -------------------------------------------------------------  */
NODE_HANDLE tt_GetFirstSon(NODE_HANDLE nodeHandle)
{
  if(nodeHandle)
  {
    return(nodeHandle->FirstLeftSon);
  } else return(NULL);
}

/* -------------------------------------------------------------  */
/* tt_GetLastSon                                                  */
/*                                                                */
/* Function: Returns the rightmost son of the specified node.     */
/*     Note: Returns NULL is there is no such son.                */
/* -------------------------------------------------------------  */
NODE_HANDLE tt_GetLastSon(NODE_HANDLE nodeHandle)
{
  if(nodeHandle && nodeHandle->FirstLeftSon) /* Check NULL handle passed and top of tree. */
  {
    nodeHandle=nodeHandle->FirstLeftSon;

    /* We go foward on the linked list until we get to the rightmost son. */
    while(nodeHandle->NextNode)
    {
      nodeHandle=nodeHandle->NextNode;
    }
    return(nodeHandle);
  } else return(NULL);
}

/* -------------------------------------------------------------  */
/* tt_GetFather                                                   */
/*                                                                */
/* Function: Returns the father node associated with the passed   */
/*           one.                                                 */
/*     Note: NULL if top of tree or NULL NODE_HANDLE.             */
/* -------------------------------------------------------------  */
NODE_HANDLE tt_GetFather(NODE_HANDLE nodeHandle)
{
  if(nodeHandle && nodeHandle->PreviousNode) /* Check NULL handle passed and top of tree. */
  {
    /* We go back on the linked list until we get to the first left son. */
    while(nodeHandle->PreviousNode->FirstLeftSon != nodeHandle)
    {
      nodeHandle=nodeHandle->PreviousNode;
    }
    return(nodeHandle->PreviousNode);
  } else return(NULL);
}

/* -------------------------------------------------------------  */
/* tt_SetNodeData                                                 */
/*                                                                */
/* Function: Will link the passed data pointer to a node.         */
/*     Note: If there is already a data pointer in this node, 	  */
/*           it will be replaced.      				                    */
/*           Returns a void pointer where the client              */
/*           can write to modify the node content                 */
/*           directly.                                            */
/* -------------------------------------------------------------  */
void *tt_SetNodeData(NODE_HANDLE nodeHandle,void *data)
{
  if(nodeHandle)
  {
    nodeHandle->data=data;
    return(nodeHandle->data);
  } else return(NULL);
}

/* -------------------------------------------------------------  */
/* tt_GetNodeData                                                 */
/*                                                                */
/* Function: Return the pointer to the user data section of the   */
/*           passed node.					                                */
/*     Note: You can directly alter the content of this data ptr. */
/* -------------------------------------------------------------  */
void *tt_GetNodeData(NODE_HANDLE nodeHandle)
{
  if(nodeHandle)
  {
    return(nodeHandle->data);
  } else return(NULL);
}

/* Internal function for tt_ApplyFunction */
void iApplyFunction(NODE_HANDLE nodeHandle, void (*oneFunc)())
{
  if(nodeHandle)
  {
    iApplyFunction(nodeHandle->FirstLeftSon, oneFunc );
    iApplyFunction(nodeHandle->NextNode, oneFunc );

    (*oneFunc)(nodeHandle);
  }
}

/* -------------------------------------------------------------  */
/* tt_ApplyFunction						                                    */
/*								                                                */
/* Function: Apply a passed function on every node of the Tree	  */
/*           passed as a NODE_HANDLE. 				                    */
/*     Note: Custom function 'oneFunc' will receive one		        */
/*           parameter which will be the NODE_HANDLE of the	      */
/*           current node you want your function to be used on.   */
/*           Function will be applied on the prefix path.         */
/* -------------------------------------------------------------  */
void	    tt_ApplyFunction(NODE_HANDLE nodeHandle, void (*oneFunc)())
{
  if(nodeHandle)
  {
    iApplyFunction(nodeHandle->FirstLeftSon, oneFunc );
  }
  (*oneFunc)(nodeHandle);
}



