#include <clib/alib_protos.h>
#include <utility/tagitem.h>
#include <classes/supermodel.h>

ULONG __asm LIB_SM_SuperNotifyA(register __a0 Class *CL, register __a1 Object *O, register __a2 struct opUpdate *M, register __a3 struct TagItem *TagList)
{
  return(DoSuperMethod(CL,O,OM_NOTIFY, TagList, M->opu_GInfo, ((M->MethodID == OM_UPDATE)?(M->opu_Flags): 0)));
}

/****** supermodel.class/SM_SendGlueAttrs ******************************************
*
*   NAME
*       SM_SendGlueAttrs -- Send attributes from GlueFunc (SMA_GlueFunc)
*
*   SYNOPSIS
*       unknown = SM_SendGlueAttrs(GlueData, TagList)
*       d0                         a0        a1
*
*       ULONG SM_SendGlueAttrs(struct smGlueData *, struct TagItem *);
*
*   FUNCTION
*       This function sends TagList back to the modelclass for notification
*       of other objects.
*
*       ONLY to be called from inside a GlueFunction.
*
*   INPUTS
*       GlueData - 
*       TagList -
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/



ULONG __asm LIB_SM_SendGlueAttrsA(register __a0 struct smGlueData *GD, register __a1 struct TagItem *TagList)
{
  return(DoMethod(GD->ModelObject, 
                  SMM_PRIVATE0, 
                  TagList, 
                  GD->Update->opu_GInfo, 
                  GD->Update->opu_Flags ));
}



