
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <dos/dos.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <exec/ports.h>
#include <exec/io.h>
#include <libraries/dos.h>
#include <libraries/dosextens.h>
#include <libraries/mui.h>
#include <devices/clipboard.h>
#include <workbench/workbench.h>
#include <intuition/intuition.h>
#include <intuition/classusr.h>

#include <proto/alib.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/gadtools.h>
#include <proto/asl.h>

#include <clib/muimaster_protos.h>

/*
#include <proto/muimaster.h>
#include <inline/muimaster.h>
*/

#include "DXListClass.h"

#ifndef SAVEDS
#define SAVEDS
#endif

/* MUI OBJECTS */

/*
** This is the instance data for our custom class.
*/

struct MUI_CustomClass *DXListClass = NULL;


#define DATA_STRING_MAX 120

struct DXLData
{
  ULONG secs, micros;
  long x_offset;
  unsigned char string[DATA_STRING_MAX];
};

SAVEDS ULONG mDraw(struct IClass *cl,Object *obj,struct MUIP_Draw *msg)
{
  DoSuperMethodA(cl,obj,(Msg) msg);
  set(obj,MUIA_DXList_AfterDraw,1);
  return(0);
}



SAVEDS ULONG mHandleInput(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
  struct DXLData *data = INST_DATA(cl,obj);

  #define _between(a,x,b) ((x)>=(a) && (x)<=(b))
  #define _isinobject(x,y) (_between(_mleft(obj),(x),_mright(obj)) && _between(_mtop(obj),(y),_mbottom(obj)))

  if (msg->imsg)
  {
    switch (msg->imsg->Class)
    {
      case IDCMP_MOUSEBUTTONS:
      {
        if (msg->imsg->Code==SELECTUP && _isinobject(msg->imsg->MouseX,msg->imsg->MouseY))
        {
          if ((data->secs == 0) && (data->micros == 0))
          {
            data->secs = msg->imsg->Seconds;
            data->micros = msg->imsg->Micros;
          }
          else if (DoubleClick(data->secs,data->micros,msg->imsg->Seconds,msg->imsg->Micros))
          {
            struct MUI_List_TestPos_Result res; res.entry = -1;
            DoMethod(obj,MUIM_List_TestPos,msg->imsg->MouseX,msg->imsg->MouseY,&res);
            if (res.entry >= 0)
            {
              long line,col,col1,col2,colstr;
              STRPTR string;
              line = res.entry;
              col = ((msg->imsg->MouseX - _mleft(obj)) / _rp(obj)->TxWidth) + data->x_offset;
              DoMethod(obj,MUIM_List_GetEntry,line,&string);
              if (string)
              {
                col1 = 0;
                col2 = 0;
                while ((string[col1]) && (col2 < col))
                {
                  if (string[col1]=='\t')
                    col2 += 4;
                  else
                    col2 += 1;
                  col1++;
                }
                if (col2 == col)
                {
                  col = col1;
                  col--;
                  while ((col >= 0) && (
                         ((string[col] >= '0') && (string[col] <= '9')) ||
                         ((string[col] >= 'A') && (string[col] <= 'Z')) ||
                         ((string[col] >= 'a') && (string[col] <= 'z')) ||
                         (string[col] == '_') ||
                         (string[col] == '-') ||
                         (string[col] == '.')
                         ))
                  {
                    col--;
                  }
                  col++;
                  colstr=0;
                  while ((colstr < DATA_STRING_MAX-1) && (string[col] != '\0') && (
                         ((string[col] >= '0') && (string[col] <= '9')) ||
                         ((string[col] >= 'A') && (string[col] <= 'Z')) ||
                         ((string[col] >= 'a') && (string[col] <= 'z')) ||
                         (string[col] == '_') ||
                         (string[col] == '-') ||
                         (string[col] == '.')
                         ))
                  {
                    data->string[colstr++] = string[col++];
                  }
                  if ((colstr > 0) && (data->string[colstr-1] == '.'))
                    colstr--;
                  data->string[colstr] = '\0';

                  if (data->string[0] != '\0')
                    set(obj,MUIA_DXList_DClick,data->string);
                }
              }
            }
            data->secs = 0;
            data->micros = 0;
          }
          else
          {
            data->secs = 0;
            data->micros = 0;
          }
        }
      }
      break;
    }
  }
  return(DoSuperMethodA(cl,obj,(Msg) msg));
}



SAVEDS ULONG mSetup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
  struct DXLData *data;
  if (!(DoSuperMethodA(cl,obj,(Msg) msg)))
    return(FALSE);
  data = INST_DATA(cl,obj);
  data->secs = 0;
  data->micros = 0;
  data->x_offset = 0;
  data->string[0] = '\0';
  MUI_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS);
/*  MUI_RequestIDCMP(obj,IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY);*/
  return(TRUE);
}

SAVEDS ULONG mCleanup(struct IClass *cl,Object *obj,struct MUIP_HandleInput *msg)
{
  struct DXLData *data = INST_DATA(cl,obj);
  MUI_RejectIDCMP(obj,IDCMP_MOUSEBUTTONS|IDCMP_RAWKEY);
  return(DoSuperMethodA(cl,obj,(Msg) msg));
}


SAVEDS ULONG mSet(struct IClass *cl,Object *obj,Msg msg)
{
  struct DXLData *data = INST_DATA(cl,obj);
  struct TagItem *tags,*tag;

  for (tags=((struct opSet *)msg)->ops_AttrList;tag=(struct TagItem *) NextTagItem(&tags);)
  {
    switch (tag->ti_Tag)
    {
      case MUIA_DXList_XOffset :
        if (data->x_offset != (long) tag->ti_Data)
        {
          data->x_offset = (long) tag->ti_Data;
          MUI_Redraw(obj,MADF_DRAWOBJECT);  /* MADF_DRAWUPDATE or MADF_DRAWOBJECT ? */
        }
        break;
    }
  }
  return(DoSuperMethodA(cl,obj,msg));
}


static ULONG mGet(struct IClass *cl,Object *obj,Msg msg)
{
  struct DXLData *data = INST_DATA(cl,obj);
  ULONG *store = ((struct opGet *)msg)->opg_Storage;

  switch (((struct opGet *)msg)->opg_AttrID)
  {
    case MUIA_DXList_AfterDraw:
      *store = (ULONG) 0;
      return (TRUE);
    case MUIA_DXList_XOffset:
      *store = (ULONG) 0;
      return (TRUE);
    case MUIA_DXList_DClick:
      *store = (ULONG) data->string;
      return (TRUE);
    case MUIA_DXList_XVisible:
      *store = (ULONG) ((_mright(obj) - _mleft(obj)) / _rp(obj)->TxWidth);
      return (TRUE);
  }
  return(DoSuperMethodA(cl,obj,msg));
}


/* SAVEDS ASM ULONG MyDispatcher(REG(a0) struct IClass *cl,REG(a2) Object *obj,REG(a1) Msg msg)*/
ULONG MyDispatcher(void)
{
  register struct IClass *a0 __asm("a0");
  struct IClass *cl = a0;
  register Object *a2 __asm("a2");
  Object *obj = a2;
  register Msg a1 __asm("a1");
  Msg msg = a1;

  switch (msg->MethodID)
  {
    case MUIM_HandleInput: return (mHandleInput(cl,obj,(APTR)msg));
    case MUIM_Setup      : return (      mSetup(cl,obj,(APTR)msg));
    case MUIM_Cleanup    : return (    mCleanup(cl,obj,(APTR)msg));
    case MUIM_Draw       : return (       mDraw(cl,obj,(APTR)msg));
    case OM_SET          : return (        mSet(cl,obj,(APTR)msg));
    case OM_GET          : return (        mGet(cl,obj,(APTR)msg));
  }
  return(DoSuperMethodA(cl,obj,msg));
}


void DeleteDXListClass(void)
{
  if (DXListClass)
    MUI_DeleteCustomClass(DXListClass); /* delete the custom class. */
  DXListClass = NULL;
}

struct MUI_CustomClass *CreateDXListClass(void)
{
  DXListClass = MUI_CreateCustomClass(NULL,MUIC_List,NULL,sizeof(struct DXLData),(APTR) MyDispatcher);
  return (DXListClass);
}
