#include <utility/pack.h>
#include <extras/gtobject.h>

ULONG MX_GetSize(struct gtpGetSize *GS)
{
  struct IBox domain;
  struct TagItem *tags;
  struct TextAttr *ta;
  struct mxData *gd;
  struct TextFont *font;
  STRPTR *labels;
  LONG  flags,
        labelcnt, 
        spacing, 
        scaled, 
        tplace,
        mxw,
        mxh;
  
  gd=INST_DATA(C,O);
  
  tags=GS->gtpgs_TagList;
  
  flags      = GetTagData(GTA_Flags,         0, tags);
  ta         = GetTagData(GTA_TextAttr,      0, tags);
  labels     = GetTagData(GTMX_Labels,       0, tags);
  labelcnt   = CountStringArray(labels);

  spacing    = GetTagData(GTMX_Spacing,      0, tags);

  scaled=0;
  tplace=0;

  if(GadToolsBase->lib_Version>=39)
  {
    scaled  =GetTagData(GTMX_Scaled,      0, tags);
    tplace  =GetTagData(GTMX_TitlePlace,  0, tags);
  }

  mxw=17;
  mxh=9;

  if(labels)
  {
    if(font=OpenDiskFont(ta))
    {
      maxlabellen=0;
      
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

