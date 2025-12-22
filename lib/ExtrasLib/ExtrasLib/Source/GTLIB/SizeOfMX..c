



GTL_SizeOfMX(struct IBox *Domain, NewGadget *NGad, struct TagItem *TagList)
{
  struct TextFont *font;
  STRPTR *labels;
  LONG  labelcnt, 
        spacing, 
        scaled, 
        tplace;
  
  labels    =GetTagData(GTMX_Labels,       0, TagList)
  labelcnt  =CountStrings(labels);

  spacing   =GetTagData(GTMX_Spacing,      0, TagList);

  scaled=0;
  tplace=0;

  if(GadToolsBase->lib_Version>=39)
  {
    scaled  =(GetTagData(GTMX_Scaled,      0, TagList));
    tplace  =(GetTagData(GTMX_TitlePlace,  0, TagList));
  }

  Domain.Width  = 0;

  if(labels)
  {
    if(font=OpenDiskFont(NGad->ng_TextAttr))
    {
      while(*labels)
      {
        LONG lablen;
        
        lablen=StrLength( SL_TextFont,    font,
                          SL_String,      *labels,
                          TAG_DONE);
        Domain->Width = max(Domain->Width, lablen);
        labels++;
      }
      CloseFont(font);
    }
  }
  
  Domain->Width += 8 + (scaled ? NGad->ng_Width : 26 );
  Domain->Height = (gd->mx_TA->ta_YSize + spacing) * labelcnt;
  
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
          
          
          Domain->Left  = min(Domain->Left, -(ll    
          Domain->Width = max(Domain->Width, ll );
          Domain->Height+= 4 + gd->mx_TF->tf_YSize;
        }
        break;
      case PLAVETEXT_LEFT:
      case PLACETEXT_RIGHT:
        
  }
  */
  
  }
  
}

