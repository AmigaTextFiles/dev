#include <utility/pack.h>
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

struct TagList MX_Tags[MX_TAGS]=
{
  GTMX_Labels,      0,
  GTMX_Active,      0,
  GTMX_Spacing,     1,
  GTMX_Scaled,      0,
  GTMX_TitlePlace,  0,
  GTA_Flags,        0,
  GTA_TextAttr,     0,
  TAG_DONE,         0,
};

LONG MX_Dispatch(Class *C, Object *O, Msg *M)
{
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

LONG GTMX_SetAttrs(struct Class *C, struct Object *O, struct opSet *Set)
{
  struct TagItem *settags;
  STRPTR *labels, title;
  LONG labelcnt, spacing, scaled, tplace;
  
  if(settags=CloneTagItems(Set->ops_AttrList))
  {
    FilterTagItems(settags,gdata->mx_GTTags,TAGFILTER_AND);
    if(Set->MethodID==OM_SET)
    {
      DoSuperMethodA(C,O,(Msg *)Set);
    }
    DoSuperMethod(C,O,GTM_SETGTATTRS,settags);
    
    FilterTagChanges(settags,gdata->mx_GTTags,1);
    labels    =GetTagData(GTMX_Labels,  0, gdata->mx_GTTags)
    labelcnt  =gt_CountStrings(labels);
    spacing   =GetTagData(GTMX_Spacing,      0, gdata->mx_GTTags);
    scaled=0;
    tplace=0;
    if(GadToolsBase->lib_Version>=39)
    {
      scaled  =(GetTagData(GTMX_Scaled,      0, gdata->mx_GTTags));
      tplace  =(GetTagData(GTMX_TitlePlace,  0, gdata->mx_GTTags));
    }

    gd->mx_Domain[0].Height = (gd->mx_TA->ta_YSize + spacing) * labelcnt;
    gd->mx_Domain[0].Width  = 0;
    if(labels)
    {
      while(*labels)
      {
        gd->mx_Domain[0].Width = max(gd->mx_Domain[0].Width, StrLength(   SL_TextFont,    gd->mx_TF,
                                                                          SL_String,      *labels,
                                                                          TAG_DONE));
        labels++;
      }
    }
    gd->mx_Domain[0].Width += gd->mx_Width + 8;
    
    if(tplace)
    {
      switch(tplace)
      {
        case PLACETEXT_ABOVE:
        case PLACETEXT_BELOW:
          gd->mx_Domain[0].Width = max(gd->mx_Domain[0].Width,StrLength(   SL_TextFont,    gd->mx_TF,
                                                                           SL_String,      gd->mx_GadgetText,
                                                                           TAG_DONE));
          gd->mx_Domain[0].Height+= 4 + gd->mx_TF->tf_YSize;
          break;
        case PLAVETEXT_LEFT:
        case PLACETEXT_RIGHT:
          
    }
    
    FreeTagItems(settags);
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
