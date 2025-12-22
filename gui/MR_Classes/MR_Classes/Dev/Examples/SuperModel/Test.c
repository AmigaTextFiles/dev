#define DEBUG
#include <debug.h>

#include <clib/alib_protos.h>
#include <intuition/classusr.h>

#include <intuition/gadgetclass.h>

#include <intuition/icclass.h>
#include <proto/intuition.h>
#include <proto/exec.h>
#include <proto/utility.h>
#include <proto/dos.h>
#include <stdio.h>
#include <stdlib.h>

#include <string.h>

#include <tagitemmacros.h>

#include <proto/classes/supermodel.h>
#include <classes/supermodel.h>

#define APP_Number    (TAG_USER + 1)
#define APP_Something (TAG_USER + 2)

struct Library *SuperModelBase;

ULONG __asm __saveds GlueCode(register __a0 struct  smaGlueData *GD,
                              register __a1 struct  TagItem *TagList, 
                              register __a2 APTR    UserData);


void main(void)
{
  Object *model;
  struct Gadget *prop,*str1,*str2;
  struct Window *win;
  ULONG go;
  
  if(SuperModelBase=OpenLibrary("supermodel.class",44))
  {
    prop=(APTR)NewObject(0,"propgclass", 
                GA_Top, 30, 
                GA_Left, 10, 
                GA_Height, 10, 
                GA_Width, 100, 
                GA_Immediate, 1,
                PGA_Total, 100,
                PGA_Visible,1,
                PGA_Freedom, FREEHORIZ,
                TAG_DONE);
    str1=(APTR)NewObject(0,"strgclass", 
                GA_Top, 60, 
                GA_Left, 10, 
                GA_Height, 10, 
                GA_Width, 100, 
                STRINGA_LongVal, 0, 
                STRINGA_MaxChars, 7,
                STRINGA_Pens, 0x00000100,
                STRINGA_ActivePens, 0x00000302,
                GA_Previous,  prop,
                TAG_DONE);
    str2=(APTR)NewObject(0,"strgclass", 
                GA_Top, 80, 
                GA_Left, 10, 
                GA_Height, 10, 
                GA_Width, 100, 
                STRINGA_TextVal, "0",
                STRINGA_MaxChars, 24,
                STRINGA_Pens, 0x00000100,
                STRINGA_ActivePens, 0x00000302,
                GA_Previous,  str1,
                TAG_DONE);

    model=SM_NewSuperModel(
            ICA_TARGET,    ICTARGET_IDCMP,
            
            SMA_CacheStringTag, APP_Something,
  
            SMA_GlueFunc,         GlueCode,
            
            SMA_AddMember, SM_SICMAP((APTR)prop, PGA_Top,         APP_Number, TAG_DONE),
            SMA_AddMember, SM_SICMAP((APTR)str1, STRINGA_LongVal, APP_Number, TAG_DONE),
            SMA_AddMember, SM_SICMAP((APTR)str2, STRINGA_TextVal, APP_Something, TAG_DONE),
            
            TAG_DONE);
            

    /* By setting the attributes on the model, all gadgets get updated */
    SetAttrs(model, APP_Number,25, TAG_DONE);
    
    win=OpenWindowTags(0, WA_InnerWidth,        120, 
                          WA_InnerHeight,       100, 
                          WA_DragBar,           1,
                          WA_CloseGadget,       1,
                          WA_Gadgets,           prop,
                          WA_IDCMP,             IDCMP_CLOSEWINDOW | IDCMP_IDCMPUPDATE,
                          TAG_DONE);

    printf("Gadgets added\n");

    go=1;
    while(go)
    {
      struct IntuiMessage *imsg;
      
      WaitPort(win->UserPort);
      
      while(imsg=(APTR)GetMsg(win->UserPort))
      {
        switch(imsg->Class)
        {
          case IDCMP_CLOSEWINDOW:
            go=0;
            break;
          case IDCMP_IDCMPUPDATE:
            {
              struct TagItem *tag,*taglist,*tstate;
              
              taglist=imsg->IAddress;
              
              ProcessTagList(taglist,tag,tstate)
              {
                switch(tag->ti_Tag)
                {
                  case APP_Number:
                    printf("APP_Number %d\n",tag->ti_Data);
                    break;
                  case APP_Something: // this tag isn't always safe to read
                    printf("APP_Something %08lx %s  (This tag can't always be read!)\n",tag->ti_Data,tag->ti_Data);
                    break;
                }
              }
              
            }
            break;
        }
      }
    }

    DisposeObject(model);

    CloseWindow(win);
    DisposeObject(prop);
    DisposeObject(str1);
    DisposeObject(str2);
    CloseLibrary(SuperModelBase); 
  }
}

// runs on input.device!
ULONG __asm __saveds GlueCode(register __a0 struct  smaGlueData *GD,
                              register __a1 struct  TagItem *TagList, 
                              register __a2 APTR    UserData)
{
  ULONG id,retval=0;
  struct TagItem *tstate,*tag, *mytags;
  char buf[8];
  
  id=GetTagData(GA_ID, 0, TagList);
  
  if(mytags=SMTAG_AllocTags(10))
  {
    ProcessTagList(TagList,tag,tstate)
    {
      ULONG t,d;
      
      t=tag->ti_Tag;
      d=tag->ti_Data;
      
      switch(t)
      {
        case APP_Number:
          {
            // Convert APP_Number to hex string, and add APP_Something
            // Note that the buffer is on the stack, and that when 
            // the task tries to print this string, it is bad.
            stci_h(buf,d); 
            SMTAG_AddTag(mytags, APP_Something, (ULONG)buf);
          }
          break;
        
        case APP_Something:
          if(d)
          {
            ULONG i;
            
            stch_i(d,&i);
            SMTAG_AddTag(mytags, APP_Number,      i);
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


