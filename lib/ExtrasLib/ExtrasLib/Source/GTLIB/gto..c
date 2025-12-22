#include <extras/gtobject.h>

struct mxData
{
  struct TextAttr *mx_TA;
  struct TextFont *mx_TF;
  LONG   Width,Height;
//  struct Gadget *mx_Gad;
//  struct NewGadget *mx_NGad
  struct IBox mx_Domain[3];
};

#define MX_TAGS 6

LONG MX_Dispatch(Class *C, Object *O, Msg *M)
{
  struct gData *gd;
  
  gd=INST_DATA(C,O);
  
  switch(M->MethodID)
  {
    case OM_NEW:
      if(O=DoSuperMethodA(C,O,M))
      {
        gd=INST_DATA(C,O);
        
        gd->mx_GTags=CloneTagItems(MX_Tags);
        
        GTMX_SetGadgetAttrs(C,O,M);
      }
      rv=O;
      break;
    case OM_DELETE:
      FreeTagItems(gd->mx_GTags);
      rv=0;
      break;
    case OM_SET:
      rv=GTMX_SetAttrs(C,O,(APTR)M);
      break;
    case OM_GET:
      rv=GTMX_GetAttrs(C,O,(APTR)M);
      break;
  }
  return(O);
}

#include <tagitemmacros.h>

LONG counttags(struct TagItem *TagList)
{
  LONG c;
  
  c=0;
  
  ProcessTagList(TagList,tag,tstate)
  {
    c++;
  }
  return(c);
}

LONG GTMX_SetAttrs(struct Class *C, struct Object *O, struct opSet *Set)
{
  struct gData *gd;
  struct TagItem *tags,*nt;
  
  LONG tagc;
  
  gd=INST_DATA(C,O);

  tags=CloneTagItems(Set->ops_AttrList);
  
  FilterTagChanges(tags,gd->TagList,1);
 
  tagc=counttags(gd->TagList) + counttags(tags) + 1;
  
  if(nt=AllocTagItems(tagc))
  {
    
  }
  
}

LONG GTMX_GetAttr(struct Class *C, struct Object *O, struct opGet *Get)
{
  APTR data;
  
  rv=1;
  
  switch(Get->opg_AttrID)
  {
    case GTA_Dimensions:
      data=gdata->mx_Dimensions;
      break;
    // Gadtools tags
    case GTMX_Active:
      data->gdata->mx_Active;
      break;
    default:
      rv=0;
  }
  
  if(rv)
  {
    *(Get->opg_Storage)=data;
  }
}

void mxCreateGadget(C,O,CG)
{
  
}


ULONG mxGetSize(struct gtpGetSize *GS)
      
      if(scaled)
      {
        mxh=font->tf_YSize+1;
        mxw=max(17,mxh);
      }
      
      while(*labels)
      {
        LONG lablen;
        
        lablen=StrLength( SL_TextFont,    font,
                          SL_String,      *labels,
                          TAG_DONE);
        maxlabellen=max(maxlabellen,labellen);
        labels++;
      }
      
      domain.Width  = mxw + 8 + malabellen;
      domain.Height = (mxh + spacing) * labelcnt - spacing;
      
      if(flags & PLACETEXT_LEFT)
        domain.Left-=maxlabellen;
      else
        domain.Left=0;
      
      domain.Top=0;
      
      CloseFont(font);
    }
  }
  
  GS->gtpgs_Domain[0]=domain;
  GS->gtpgs_Domain[1]=domain;
  GS->gtpgs_Domain[2]=domain;
  return(1);
}




/*
  if(tplace)
  {
    switch(tplace)
    {
      case PLACETEXT_ABOVE:
      case PLACETEXT_BELOW:
        {
          LONG ll;
          struct IBox lbox;
          
          ll=StrLength(SL_TextFont,    gd->mx_TF,
                       SL_String,      gd->mx_GadgetText,
                       TAG_DONE));
          lbox.Width    = ll;
          lbox.Height   = gd->mx_TF->tf_YSize;
          lbox.LeftEdge = gd->
          
          
          Size->gtps_Domain->Left  = min(Size->gtps_Domain->Left, -(ll    
          Size->gtps_Domain->Width = max(Size->gtps_Domain->Width, ll );
          Size->gtps_Domain->Height+= 4 + gd->mx_TF->tf_YSize;
        }
        break;
      case PLAVETEXT_LEFT:
      case PLACETEXT_RIGHT:
        
  }
  */
