#include <extras/gtobject.h>

ULONG BUTTON_GetSize(struct gtpGetSize *GS)
{
  struct IBox     domain;
  struct TagItem  *tags;
  struct TextAttr *ta;
  struct TextFont *font;
  STRPTR label;
  LONG  flags,
        labellen;
          
  gd=INST_DATA(C,O);
  
  tags=GS->gtpgs_TagList;
  
  flags      = GetTagData(GTA_Flags,         0, tags) & 0xF;
  ta         = GetTagData(GTA_TextAttr,      0, tags);
  label      = GetTagData(GTA_GadgetText,    0, tags);

  if(label)
  {
    if(font=OpenDiskFont(ta))
    {
      labellen=StrLength( SL_TextFont,    font,
                        SL_String,      label,
                        TAG_DONE);
                        
      domain.Width  = 8;
      if(!flags)
      {
        domain.Width += labellenmxw;
      }
      domain.Height = 4 + font->tf_YSize;
      
      
      CloseFont(font);
    }
  }
  
  GS->gtpgs_Domain[0]=domain;
  GS->gtpgs_Domain[1]=domain;
  
  domain.Width=32767;
  GS->gtpgs_Domain[2]=domain;
  return(1);
}

