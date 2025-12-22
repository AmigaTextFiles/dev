#include <tagitemmacros.h>
//#define DEBUG
#include <debug.h>

#include "supermodel.h"
#include "protos.h"
#include <classes/supermodel.h>
#include <clib/alib_protos.h>

#include <intuition/gadgetclass.h>
#include <intuition/classusr.h>
#include <intuition/classes.h>
#include <intuition/icclass.h>

#include <proto/utility.h>
#include <proto/intuition.h>

Class *SuperICClass;
LONG  GadgetIDKludge=-1;

BOOL i_SuperICInit(void)
{
  if(SuperICClass=i_MakeClass(0,(STRPTR)"icclass", 0,sizeof(struct SuperICData), 0, SuperIC_Dispatch))
  {
    return(1);
  }
  return(0);
}


void i_SuperICTerm(void)
{
  if(SuperICClass)
  {
    FreeClass(SuperICClass);
    SuperICClass=0;
  }
}




/****** supermodel.class/SM_NewSuperIC ******************************************
*
*   NAME
*       SM_NewSuperIC -- Allocate SuperIC object
*
*   SYNOPSIS
*       icobject=SM_NewSuperICA(TagList)
*       a0                      a0
*
*       Object *SM_NewSuperICA(struct TagItem *);
*
*       icobject=SM_NewSuperIC(Tags, ...)
*       a0                     a0
*
*       Object *SM_NewSuperIC(Tag, ...);
*
*   FUNCTION
*       Allocates an SuperIC class object
*
*   INPUTS
*       TagList - see --datasheet-supericclass--
*
*   RESULT
*       Pointer to an ic object on success, if ICA_TARGET is valid,
*       the ic object will set the Target's ICA_TARGET and ICA_MAP.
*
******************************************************************************
*
*/


Object __asm *LIB_SM_NewSuperICA(register __a0 struct TagItem *TagList)
{
  return(NewObjectA(SuperICClass, 0, (APTR)TagList));
}



/****** supermodel.class/SM_SICMAP ******************************************
*
*   NAME
*       SM_SICMAP -- Builds and super ic class object
*
*   SYNOPSIS
*       icobject SM_SICMAPA(Target, MapTags)
*       a0                  a0      a1
*
*       Object *SM_SICMAPA(Object *, struct TagItem *);
*
*       icobject=SM_SICMAP(Target, MapTags, ...)
*       a0                 a0      a1
*
*       Object *SM_SICMAP(Object *, Tag, ...);
*
*   FUNCTION
*       Simplfied way to create and SuperIC object.
*       Target is targeted object of the ic object.
*       MapTags, target map tags.
*
*   INPUTS
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


Object __asm *LIB_SM_SICMAPA(register __a0 Object *Target, register __a1 struct TagItem *MapList)
{
 return(NewObject(SuperICClass, 0, ICA_TARGET,        Target,
                                   SICA_TargetMap,    MapList,
                                   TAG_DONE));
}

ULONG SuperIC_Set(Class *CL, Object *O, struct opSet *Set);
void SuperIC_ClearMaps(Class *CL, Object *O);
void SuperIC_SetMaps(Class *CL, Object *O);

ULONG __asm __saveds SuperIC_Dispatch(register __a0 Class *CL, register __a2 Object *O, register __a1 Msg M, register __a6 struct Library *LibBase)
{
  ULONG retval=0;
  struct SuperICData *data;

  data=INST_DATA(CL,O);

//  kprintf("Disp\n");


//  DKP("{ SuperIC-----------\n");
  NEST  
  
  switch(M->MethodID)
  {
    case OM_NEW:
      {
        retval=DoSuperMethodA(CL,O,M);
        O=(APTR)retval;
        
        //data=INST_DATA(CL,O);
        SuperIC_Set(CL,O,(APTR)M);
      }
      break;

    case OM_DISPOSE:
//    DKP("OM_DISPOSE\n");
      SuperIC_ClearMaps(CL,O);
      FreeTagItems(data->Map);
      FreeTagItems(data->TMap);
      
      retval=DoSuperMethodA(CL,O,M);
      break;
    
    case OM_SET:
    case OM_UPDATE:
//    DKP("OM_SET/UPDATE\n");
        SuperIC_Set(CL,O,(APTR)M);
        if(data->Notify)
        {
          struct TagItem *ntags;
          struct opSet *s,ns;

          data->Notify=0;          

//          DKP("1\n");
          
          s=(APTR)M;
          
          if(ntags=CloneTagItems(s->ops_AttrList))
          {
//              DKP("  tags cloned\n");
            ns=*s;
//            kprintf("  updating id %ld from %ld\n",data->ID.ti_Data, GetTagData(GA_ID, 0, s->ops_AttrList));
            if(data->Map)
            {
//              DKP("  mapping tags\n");              
              MapTags(ntags, data->Map, MAP_REMOVE_NOT_FOUND);
            }
            ns.ops_AttrList=ntags;
            
          
            retval=DoSuperMethodA(CL,O,(Msg)&ns);
            FreeTagItems(ntags);
          }

        }
        else
          retval=0;
        break;
    default:
      retval=DoSuperMethodA(CL,O,M);
  }
  
  UNNEST
//  DKP("} SuperIC-----------\n");
  
  
  return(retval);
}

#define ISOBJECT(x) ( (x) && (ICTARGET_IDCMP!=(ULONG)(x)) )

ULONG SuperIC_Set(Class *CL, Object *O, struct opSet *Set)
{
  struct SuperICData *data;
  struct TagItem *tag, *tstate;
  ULONG d;

  data=INST_DATA(CL,O);

  tstate=Set->ops_AttrList;
  while(tag=NextTagItem(&tstate))
  {
    d=tag->ti_Data;
    switch(tag->ti_Tag)
    {
      case SICA_Model:
//        DKP("SICA_Model %8lx\n",d);
        data->Model=(Object *)d;
        if(data->Target)
        {
          SetAttrs(data->Target, ICA_TARGET, data->Model, TAG_DONE);
        }
        break;
      
      case ICA_TARGET:
//        DKP("ICA_TARGET %lx\n",d);
        if(data->Target)
        {
          SetAttrs(data->Target, 
              ICA_MAP,    0, 
              ICA_TARGET, 0,
              TAG_DONE);
        }
        
        data->Target=(APTR)d;

        if(ISOBJECT(data->Target))
        {
          // Gadget Targets Model
          // IC Targets Gadget
          
          SetSuperAttrs(CL,O,ICA_TARGET, data->Target, 0);
          
          if(SM_IsMemberOf((Object *)d,0,(APTR)"gadgetclass"))
          {
            struct Gadget *g;
            
            g=(APTR)d;
          
            if(g->GadgetID==0)
            {
              g->GadgetID=GadgetIDKludge;
              GadgetIDKludge--;
            }
          
            data->ID.ti_Data=g->GadgetID;
            data->ID.ti_Tag=GA_ID;
          }
          
          SetAttrs(data->Target, 
                ICA_MAP,    data->TMap, 
                ICA_TARGET, data->Model,
                TAG_DONE);
        }
        break;
        
      case ICA_MAP:
//      DKP("ICA_MAP %lx\n",d);
        /* dereference old maps */
        SuperIC_ClearMaps(CL,O);

        /* Dump old tags */
        FreeTagItems(data->Map);  // Safe w/NULL
        FreeTagItems(data->TMap);  
        data->Map=data->TMap=0;

        if(d)
        {
          data->Map=CloneTagItems((APTR)d);
          if(data->TMap=CloneTagItems((APTR)d))
          {
            struct TagItem  *ctag, 
                            *ctstate;
            
            ctstate=data->TMap;
            
             /* flip tag map */            
            while(ctag=NextTagItem(&ctstate))
            {
              ULONG d;
              
              d             = ctag->ti_Tag;
              ctag->ti_Tag  = ctag->ti_Data;
              ctag->ti_Data = d;
            }
          }
        }   
        // 
        SuperIC_SetMaps(CL,O);
        break;

      case SICA_TargetMap://                                                                           (44.3.2) (08/20/00)
//      DKP("ICA_MAP %lx\n",d);
        /* dereference old maps */
        SuperIC_ClearMaps(CL,O);

        /* Dump old tags */
        FreeTagItems(data->Map);  // Safe w/NULL
        FreeTagItems(data->TMap);  
        data->Map=data->TMap=0;

        if(d)
        {
          data->TMap=CloneTagItems((APTR)d);
          if(data->Map=CloneTagItems((APTR)d))
          {
            struct TagItem  *ctag, 
                            *ctstate;
            
            ctstate=data->Map;
            
             /* flip tag map */            
            while(ctag=NextTagItem(&ctstate))
            {
              ULONG d;
              
              d             = ctag->ti_Tag;
              ctag->ti_Tag  = ctag->ti_Data;
              ctag->ti_Data = d;
            }
          }
        }   
        // 
        SuperIC_SetMaps(CL,O);
        break;
      
      case SICA_InMap:
        SuperIC_ClearMaps(CL,O);
        FreeTagItems(data->Map);  // Safe w/NULL
        data->Map=(APTR)d;
        SuperIC_SetMaps(CL,O);
        break;
        
      case SICA_OutMap:
        SuperIC_ClearMaps(CL,O);
        FreeTagItems(data->TMap);  // Safe w/NULL
        data->TMap=(APTR)d;
        SuperIC_SetMaps(CL,O);
        break;
        
      default:
//        DKP("Unknown Tag %08lx\n",tag->ti_Tag);
        if(FindTagItem(tag->ti_Tag, data->Map))
        {
//          DKP("Notify set\n");
          data->Notify=1;
        }
        break;
    }
  }
  
  if(tag=FindTagItem(data->ID.ti_Tag, Set->ops_AttrList))
  { 
    if(tag->ti_Data==data->ID.ti_Data) /* don't notify object that started update */
    {
      data->Notify=0;
//      return(0);
    }
  }
        
   /* see if there's a match in the Map list */            
/*  tstate=data->Map;
  while(tag=NextTagItem(&tstate))
  {
    if(FindTagItem(tag->ti_Tag, Set->ops_AttrList))
      break;
  }
  if(!tag) return(0);
  */
  
  return(1);
}


void SuperIC_ClearMaps(Class *CL, Object *O)
{
  struct SuperICData *data;

  data=INST_DATA(CL,O);

  if(ISOBJECT(data->Target))
  {
    SetAttrs(data->Target, 
              ICA_MAP,      0, 
              TAG_DONE);
  }
  
  SetSuperAttrs(CL,O,
            ICA_MAP,      0, 
            0);

}

void SuperIC_SetMaps(Class *CL, Object *O)
{
  struct SuperICData *data;

  data=INST_DATA(CL,O);

  if(ISOBJECT(data->Target))
  {
    SetAttrs(data->Target, 
              ICA_MAP,      data->TMap, 
              TAG_DONE);
  }
              
   SetSuperAttrs(CL,O,
            ICA_MAP,    data->Map, 
            TAG_DONE);

}


