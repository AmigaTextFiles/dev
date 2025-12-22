/* GadTools Drag&Drop - Library part, 28.6.99
**
** Copyright ©1999 pinc Software. All Rights Reserved.
*/

#include "gtdrag_includes.h"

/** does only contain the library vector (file is cut) **/

STATIC APTR LibVectors[] =
{
  LibOpen,
  LibClose,
  LibExpunge,
  LibNull,

  GTD_GetIMsg,
  GTD_ReplyIMsg,
  GTD_FilterIMsg,
  GTD_PostFilterIMsg,
  LibNOP,              /* GTD_GetDragMsg() */
  LibNOP,              /* GTD_ReplyDragMsg() */
  GTD_AddAppA,
  GTD_RemoveApp,
  GTD_AddWindowA,
  GTD_RemoveWindow,
  GTD_AddGadgetA,
  GTD_RemoveGadget,
  GTD_RemoveGadgets,
  GTD_SetAttrsA,
  GTD_GetAttr,
  GTD_GetHook,
  GTD_GetString,
  GTD_PrepareDrag,
  GTD_BeginDrag,
  GTD_HandleInput,
  GTD_StopDrag,

  FreeTreeList,
  InitTreeList,
  FreeTreeNodes,
  AddTreeNode,
  CloseTreeNode,
  OpenTreeNode,
  ToggleTreeNode,
  GetTreeContainer,
  GetTreePath,
  FindTreePath,
  FindTreeSpecial,
  FindListSpecial,
  ToggleTree,

  (APTR)-1
};

/* if this function is not defined here, makelib will warn you */

APTR PUBLIC LibNOP(void)
{
  return(NULL);
}
  
