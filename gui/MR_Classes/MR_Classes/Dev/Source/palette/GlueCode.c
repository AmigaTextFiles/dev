#include "ui.h"
#include "edata.h"
#include "apptags.h"

#include <tagitemmacros.h>
#include <debug.h>

#include <graphics/text.h>

struct TextAttr Topaz8={"topaz.font",8,0,0};

ULONG __asm __saveds GM_Set(register __a0 struct smGlueData     *GD, 
                            register __a1 struct TagItem        *TagList, 
                            register __a2 struct EData          *edata)
{
  ULONG retval=0;
  struct TagItem *tstate,*tag, *mytags;
  
  //u=(APTR)Set;
  
  if(mytags=SMTAG_AllocTags(10))
  {
    ProcessTagList(TagList,tag,tstate)
    {
      ULONG t,d;
      
      t=tag->ti_Tag;
      d=tag->ti_Data;
      
      switch(t)
      {
        case APP_EditMode:
          if(edata->CopyMode!=(d == TCPEM_COPY))
          {
            edata->CopyMode=(d == TCPEM_COPY);
            SMTAG_AddTag(mytags,APP_CopyMode,edata->CopyMode);
          }
          
          if(edata->SwapMode!=(d == TCPEM_SWAP))
          {
            edata->SwapMode=(d == TCPEM_SWAP);
            SMTAG_AddTag(mytags,APP_SwapMode,edata->SwapMode);
          }
          
          if(edata->SpreadMode!=(d == TCPEM_SPREAD))
          {
            edata->SpreadMode=(d == TCPEM_SPREAD);
            SMTAG_AddTag(mytags,APP_SpreadMode,edata->SpreadMode);
          }
          
          break;          
          
        case APP_CopyMode:
          if(d)
          {
            SMTAG_AddTag(mytags,APP_EditMode, TCPEM_COPY);
            SMTAG_AddTag(mytags,APP_SwapMode,0);
            SMTAG_AddTag(mytags,APP_SpreadMode,0);
          }
          else
          {
            SMTAG_AddTag(mytags,APP_EditMode, 0);
            SMTAG_AddTag(mytags,APP_CopyMode,0);
            SMTAG_AddTag(mytags,APP_SwapMode,0);
            SMTAG_AddTag(mytags,APP_SpreadMode,0);
          }
          break;


        case APP_SwapMode:
          if(d)
          {
            SMTAG_AddTag(mytags,APP_EditMode, TCPEM_SWAP);
            SMTAG_AddTag(mytags,APP_CopyMode,0);
            SMTAG_AddTag(mytags,APP_SpreadMode,0);
          }
          else
          {
            SMTAG_AddTag(mytags,APP_EditMode, 0);
            SMTAG_AddTag(mytags,APP_CopyMode,0);
            SMTAG_AddTag(mytags,APP_SwapMode,0);
            SMTAG_AddTag(mytags,APP_SpreadMode,0);
          }
          break;


        case APP_SpreadMode:
          if(d)
          {
            SMTAG_AddTag(mytags,APP_EditMode, TCPEM_SPREAD);
            SMTAG_AddTag(mytags,APP_CopyMode,0);
            SMTAG_AddTag(mytags,APP_SwapMode,0);
          }
          else
          {
            SMTAG_AddTag(mytags,APP_EditMode, 0);
            SMTAG_AddTag(mytags,APP_CopyMode,0);
            SMTAG_AddTag(mytags,APP_SwapMode,0);
            SMTAG_AddTag(mytags,APP_SpreadMode,0);
          }
          break;
      }
    }
    SMTAG_TagMore(mytags, TagList);
    retval=SM_SendGlueAttrsA(GD, mytags);
    SMTAG_FreeTags(mytags);
  }
  return(retval);
}
