//#define DEBUG
#include <debug.h>

#include <tagitemmacros.h>

#include "supermodel.h"
#include "protos.h"

#include <string.h>

#include <classes/supermodel.h>

#include <clib/extras/string_protos.h>
#include <clib/extras/utility_protos.h>
#include <clib/alib_protos.h>

#include <exec/memory.h>

#include <intuition/classusr.h>
#include <intuition/classes.h>
#include <intuition/icclass.h>

#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/intuition.h>

#include <proto/exec.h>


ULONG SuperNotifyA(Class *CL, Object *O, struct opUpdate *M, struct TagItem *TagList);
void UpdateCachedStrings(struct SuperModelData *data, struct TagItem *NewTags);
void FreeCachedStrings(struct SuperModelData *data);

Class *SuperModelClass;


BOOL i_SuperModelInit(void)
{
  if(i_SuperICInit())
  {
    if(SuperModelClass=i_MakeClass(0,(STRPTR)"modelclass",0,sizeof(struct SuperModelData), 0, SuperModel_Dispatch)) 
    {
      return(1);
    }
    i_SuperICTerm();    
  }
  return(0);
}




void i_SuperModelTerm(void)
{
  i_SuperICTerm();    
  if(SuperModelClass)
  {
    FreeClass(SuperModelClass);
    SuperModelClass=0;
  }
}

/****** supermodel.class/SM_NewSuperModel ******************************************
*
*   NAME
*       SM_NewSuperModel -- Allocate SuperModel object
*
*   SYNOPSIS
*       model = SM_NewSuperModel( Tag1, Data1, TAg2, ...)
*
*       Object *SM_NewSuperModel(Tag Tags, ...);
*
*   FUNCTION
*       Allocate model object.
*
*   INPUTS
*       Tags
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*       DisposeObject() returned model when done.
*
*       Before targeted objects (ie gadgets) are freed you must either:
*       1. Dispose() the SuperModel object, which also Dispose()s all
*           SuperIC objects.
*       2. SetAttr() ICA_TARGET to NULL on every SuperIC object.
*       SuperIC objects need to clear the ICA_MAP and ICA_TARGET settings 
*       of it's targetted object.  If the target object nolonger exists,
*       expect bad things to happen.
*
*   BUGS
*
*   SEE ALSO
*
******************************************************************************
*
*/


Object  __asm *LIB_SM_NewSuperModelA(register __a0 struct TagItem  *TagList)
{
  return(NewObjectA(SuperModelClass, 0, (APTR)TagList));
}


ULONG SuperModel_Set(Class *CL, Object *O, struct opSet *Set);

ULONG __asm __saveds SuperModel_Dispatch(register __a0 Class *CL, register __a2 Object *O, register __a1 Msg M)
{
  ULONG retval=0;
  struct SuperModelData *data;

  data=INST_DATA(CL,O);

  switch(M->MethodID)
  {
    case OM_NEW:
      if(O=(APTR)DoSuperMethodA(CL,O,M))
      {
        data=INST_DATA(CL,O);
        if(data->CachedStringTags=SMTAG_AllocTags(50))
        {
          NewList(&data->Members);
          SuperModel_Set(CL,O,(APTR)M);
          if(data->NullAddMember)//                                                                    (44.3.1) (08/19/00)
          {//                                                                                          (44.3.1) (08/19/00)
            FreeCachedStrings(data);//                                                                 (44.3.1) (08/19/00)
            DoSuperMethod(CL,O,OM_DISPOSE);//                                                          (44.3.1) (08/19/00)
            retval=0;//                                                                                (44.3.1) (08/19/00)
          }//                                                                                          (44.3.1) (08/19/00)
          else//                                                                                       (44.3.1) (08/19/00)
          {//                                                                                          (44.3.1) (08/19/00)
            retval=(ULONG)O;//                                                                         (44.3.1) (08/19/00)
          }//                                                                                          (44.3.1) (08/19/00)
        }
        else
        {
          DoSuperMethod(CL,O,OM_DISPOSE);
          retval=0;
        }
      } 
      break;
      
    case OM_DISPOSE://                                                                                 (44.1.7) (08/04/00)
      {//                                                                                              (44.1.7) (08/04/00)
        FreeCachedStrings(data);//                                                                     (44.1.7) (08/04/00)
      }
      break;

    case OM_ADDMEMBER:
      {
        struct opMember *m;
        Object *o;
        
        m=(APTR)M;
        o=m->opam_Object;
        
        if(SM_IsMemberOf(o, SuperICClass,0))
        {
          SetAttrs((Object *)o, SICA_Model, O, TAG_DONE);
        }
        retval=DoSuperMethodA(CL,O,M);
      }
      break;
      
    case OM_REMMEMBER:
        //DKP("OM_REMMEMBER\n");
      {
        struct opMember *m;
        Object *o;
        
        m=(APTR)M;
        o=m->opam_Object;
        
        if(SM_IsMemberOf(o, SuperICClass,0))
        {
          SetAttrs((Object *)o, SICA_Model, 0, TAG_DONE);
        }
        retval=DoSuperMethodA(CL,O,M);
      }
      break;

/*  Do real Notify  */
    case SMM_PRIVATE0:
      {
        struct opUpdate u,*uu;
        
        uu=(APTR)M;
        
        u=*uu;
        
        UpdateCachedStrings(data,u.opu_AttrList);
        
        u.MethodID=OM_NOTIFY;
        
        retval=DoSuperMethodA(CL,O,(Msg)&u);
      }
      break;
      
    case OM_SET:
    case OM_UPDATE:
      //DKP("OM_SET/UPDATE\n");
      if(data->GlueFunc)
      {
        struct opUpdate u,*uu;
        struct smGlueData gd;
        struct TagItem *mytags;
        
        uu=(APTR)M;
        
        u.MethodID      =uu->MethodID;
        u.opu_AttrList  =uu->opu_AttrList;
        u.opu_GInfo     =uu->opu_GInfo;
        if(u.MethodID==OM_UPDATE)
        {
          u.opu_Flags=uu->opu_Flags;
        }
        
        if(mytags = u.opu_AttrList = SMTAG_AllocTags(50))
        {
          SMTAG_AddTagsA(u.opu_AttrList, uu->opu_AttrList);
          
//        retval=data->GlueFunc(CL, O, (APTR)&u, data->UserData, data->A6);

          gd.ModelCL    =CL;
          gd.ModelObject=O;
          gd.Update     =&u;
        
          retval=data->GlueFunc(&gd, u.opu_AttrList, (APTR)data->UserData, data->A6);
        
          SMTAG_FreeTags(mytags);//                                                                    (44.1.1) (08/04/00)//  (44.1.2) (08/04/00)
        }
      }
      else
      {
        retval=DoSuperMethodA(CL,O,(APTR)M);
      }
      
      retval+=SuperModel_Set(CL,O,(APTR)M);
      
      break;
      
    default:
      retval=DoSuperMethodA(CL,O,M);
  }

  return(retval);
}

ULONG SuperModel_Set(Class *CL, Object *O, struct opSet *Set)
{
  struct SuperModelData *data;
  struct TagItem *tag, *tstate;
  ULONG d,retval=0,c=0;

  data=INST_DATA(CL,O);

  tstate=Set->ops_AttrList;
  
  while(tag=NextTagItem(&tstate))
  {
    c++;
    d=tag->ti_Data;
    switch(tag->ti_Tag)
    {
      case SMA_AddMember:
        if(d==0)
        {
          data->NullAddMember=1;
        }
        else
        {
          DoMethod(O, OM_ADDMEMBER, d);
        }
        c--;
        break;
      
      case SMA_RemMember:
        DoMethod(O, OM_REMMEMBER, d);
        c--;
        break;

      case ICA_TARGET:
      case ICA_MAP:
        c--;
        break;
      
      case SMA_GlueFunc:
        data->GlueFunc=d;
        c--;
        break;
      case SMA_GlueFuncA6:
        data->A6=d;
        c--;
        break;

      case SMA_GlueFuncUserData:
        data->UserData=(APTR)d;
        c--;
        break;

      case SMA_CacheStringTag://                                                                       (44.1.3) (08/04/00)
//        DKP("SMA_CacheStringTag %lx\n",d);//                                                         (44.1.3) (08/04/00)
        SMTAG_AddTag(data->CachedStringTags, d, AllocVec(258,MEMF_PUBLIC));//                          (44.1.3) (08/04/00)
        c--;//                                                                                         (44.1.3) (08/04/00)
        break;//                                                                                       (44.1.3) (08/04/00)
    }
  }
  
  if(c)
  {
//    retval=SuperNotifyA(CL, O, (APTR)Set, Set->ops_AttrList);
  }
  
  return(retval);
}



ULONG SuperNotifyA(Class *CL, Object *O, struct opUpdate *M, struct TagItem *TagList)
{
  return(DoSuperMethod(CL,O,OM_NOTIFY, TagList, M->opu_GInfo, ((M->MethodID == OM_UPDATE)?(M->opu_Flags): 0)));
}


void UpdateCachedStrings(struct SuperModelData *data, struct TagItem *NewTags)//                       (44.1.4) (08/04/00)//  (44.1.5) (08/04/00)
{
  struct TagItem *tag, *tstate, *nt;

//  DKP("UpdateCacheStrings\n");
  
  ProcessTagList(data->CachedStringTags, tag, tstate)
  {
//    DKP("Tag %08lx\n", tag->ti_Tag);
    
    if(nt=FindTagItem(tag->ti_Tag, NewTags))
    {
//      DKP("Updating Tag\n");
      
      /* unload old string */
      if(tag->ti_Data)
      {
        UBYTE *d;
        
        d=(UBYTE *)tag->ti_Data;
        strncpy(d, (char *)nt->ti_Data, 257);
        d[257]=0;
        /* make new tags reference new copy of string */
        nt->ti_Data=(ULONG)d;
//        DKP("nv %ls\n",d);
      }
    }
  }
}


void FreeCachedStrings(struct SuperModelData *data)//                                                  (44.1.6) (08/04/00)
{
  struct TagItem *tag, *tstate;
  
  ProcessTagList(data->CachedStringTags, tag, tstate)
  {
    FreeVec((APTR)tag->ti_Data);
    tag->ti_Data=0;
  }
}
