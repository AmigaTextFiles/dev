long idcmpnum[25] =
  {
  IDCMP_MOUSEBUTTONS,    
  IDCMP_MOUSEMOVE,       
  IDCMP_DELTAMOVE,       
  IDCMP_GADGETDOWN,
  IDCMP_GADGETUP,        
  IDCMP_CLOSEWINDOW,     
  IDCMP_MENUPICK,        
  IDCMP_MENUVERIFY,      
  IDCMP_MENUHELP,        
  IDCMP_REQSET,          
  IDCMP_REQCLEAR,        
  IDCMP_REQVERIFY,       
  IDCMP_NEWSIZE,         
  IDCMP_REFRESHWINDOW,   
  IDCMP_SIZEVERIFY,      
  IDCMP_ACTIVEWINDOW,    
  IDCMP_INACTIVEWINDOW,  
  IDCMP_VANILLAKEY,     
  IDCMP_RAWKEY,          
  IDCMP_NEWPREFS,        
  IDCMP_DISKINSERTED,    
  IDCMP_DISKREMOVED,    
  IDCMP_INTUITICKS,      
  IDCMP_IDCMPUPDATE,     
  IDCMP_CHANGEWINDOW     
  };

void fixwindowtags(struct ProducerNode *pwn, struct WindowNode *wn)
{
	long tagpos = 0;
	long loop;
	
	if (wn->wn_InnerWidth == 0)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Width;
		wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_Width;
		}
	else
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_InnerWidth;
		wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_InnerWidth;
		}
	tagpos+=1;
	if (wn->wn_InnerHeight == 0)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Height;
		wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_Height;
		}
	else
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_InnerHeight;
		wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_InnerHeight;
		}
	tagpos+=1;
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Left;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_LeftEdge;
	tagpos+=1;
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Top;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_TopEdge;
	tagpos+=1;
    wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Title;
	wn->wn_ActualTagList[tagpos].ti_Data = (ULONG)&wn->wn_Titlestr[1];
	tagpos+=1;
	if (strlen(&wn->wn_ScreenTitlestr[1])>0)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_ScreenTitle;
		wn->wn_ActualTagList[tagpos].ti_Data = (ULONG)&wn->wn_ScreenTitlestr[1];
		tagpos+=1;
		}
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_MinWidth;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_MinWidth;
	tagpos+=1;
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_MaxWidth;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_MaxWidth;
	tagpos+=1;
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_MinHeight;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_MinHeight;
	tagpos+=1;
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_MaxHeight;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_MaxHeight;
	tagpos+=1;
	if (wn->wn_SizeGadget)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_SizeGadget;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		if ((wn->wn_SizeBBottom) && (wn->wn_SizeBRight))
			{
			wn->wn_ActualTagList[tagpos].ti_Tag  = WA_SizeBRight;
			wn->wn_ActualTagList[tagpos].ti_Data = 1;
			tagpos+=1;
			}
		if (wn->wn_SizeBBottom)
			{
			wn->wn_ActualTagList[tagpos].ti_Tag  = WA_SizeBBottom;
			wn->wn_ActualTagList[tagpos].ti_Data = 1;
			tagpos+=1;
			}
		}
	if (wn->wn_DragBar)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_DragBar;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_DepthGad)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_DepthGadget;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_CloseGad)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_CloseGadget;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_ReportMouse)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_ReportMouse;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_NoCareRefresh)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_NoCareRefresh;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_Borderless)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Borderless;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_Backdrop)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Backdrop;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_GimmeZZ)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_GimmeZeroZero;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_Activate)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Activate;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_RMBTrap)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_RMBTrap;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_MoreTags[0])
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Dummy + 0x30;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_MoreTags[1])
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Dummy + 0x32;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_MoreTags[2])
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Dummy + 0x37;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_SimpleRefresh)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_SimpleRefresh;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_SmartRefresh)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_SmartRefresh;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_AutoAdjust)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_AutoAdjust;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_MenuHelp)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_MenuHelp;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_UseZoom)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_Zoom;
		wn->wn_ActualTagList[tagpos].ti_Data = (ULONG)&wn->wn_Zoom[0];
		tagpos+=1;
		}
	if (wn->wn_MouseQueue != 5)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_MouseQueue;
		wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_MouseQueue;
		tagpos+=1;
		}
	if (wn->wn_RptQueue != 3)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_RptQueue;
		wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_RptQueue;
		tagpos+=1;
		}
	if (wn->wn_PubScreenFallBack)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_PubScreenFallBack;
		wn->wn_ActualTagList[tagpos].ti_Data = 1;
		tagpos+=1;
		}
	if (wn->wn_PubScreen)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_PubScreen;
		wn->wn_ActualTagList[tagpos].ti_Data = 0;
		tagpos+=1;
		}
	if (wn->wn_PubScreenName)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_PubScreenName;
		wn->wn_ActualTagList[tagpos].ti_Data = (ULONG)&wn->wn_DefPubName[1];
		if (strlen(&wn->wn_DefPubName[1]) == 0)
			wn->wn_ActualTagList[tagpos].ti_Data = 0;
		tagpos+=1;
		}
	if (wn->wn_CustomScreen)
		{
		wn->wn_ActualTagList[tagpos].ti_Tag  = WA_CustomScreen;
		wn->wn_ActualTagList[tagpos].ti_Data = 0;
		tagpos+=1;
		}
	for (loop =0; loop<25; loop++)
		if (wn->wn_idcmplist[loop])
			wn->wn_idcmpvalues |= idcmpnum[loop];
	wn->wn_ActualTagList[tagpos].ti_Tag  = WA_IDCMP;
	wn->wn_ActualTagList[tagpos].ti_Data = wn->wn_idcmpvalues;
	tagpos+=1;
	wn->wn_TagList = &wn->wn_ActualTagList[0];
}

long fixgadgettags(struct ProducerNode *pwn, struct GadgetNode *gn, struct WindowNode *wn)
{
	long result = 0;
	long tagpos = 0;
	struct StringNode *sn;
	struct IntuiText * pit;
	ULONG *l;
	
	if ( (gn->gn_Kind == MX_KIND) || (gn->gn_Kind == CYCLE_KIND) )
		{
		sn = (struct StringNode *)gn->gn_InfoList.mlh_Head;
		while(sn->sn_Succ)
			{
			tagpos +=1 ;
			sn = sn->sn_Succ;
			}
		if (tagpos>0)
			{
			gn->extradata = AllocVec(tagpos*4 + 4, MEMF_CLEAR);
			
			if (gn->extradata)
				{
				pwn->MemCount += 1;
				l = (ULONG *)gn->extradata;
				sn = (struct StringNode *)gn->gn_InfoList.mlh_Head;
				while(sn->sn_Succ)
					{
					*l = (ULONG)sn->sn_String;
					l +=1 ;
					sn = sn->sn_Succ;
					}
				}
			else
				result = 4;
			}
		}
	
	gn->gn_TagList = &gn->gn_ActualTagList[0];
	tagpos = 0;
	switch (gn->gn_Kind)
		{
		case BUTTON_KIND:
			wn->wn_idcmpvalues |= BUTTONIDCMP;
			if (gn->gn_Tags[2].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)'_';
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			break;
		case CHECKBOX_KIND:
			wn->wn_idcmpvalues |= CHECKBOXIDCMP;
			if (gn->gn_Tags[0].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTCB_Checked;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)'_';
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+68;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			break;
		case CYCLE_KIND:
			wn->wn_idcmpvalues |= CYCLEIDCMP;
			if (gn->gn_Tags[4].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			if (gn->gn_Tags[5].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[0].ti_Data != 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTCY_Active;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			gn->gn_ActualTagList[tagpos].ti_Tag  = GTCY_Labels;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->extradata;
			tagpos += 1;
			break;
		case INTEGER_KIND:
			wn->wn_idcmpvalues |= INTEGERIDCMP;
			if (gn->gn_Contents2 != 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTIN_Number;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Contents2;
				tagpos += 1;
				}
			if (gn->gn_Tags[0].ti_Data != 10)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTIN_MaxChars;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data != GACT_STRINGLEFT)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = STRINGA_Justification;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = STRINGA_ReplaceMode;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = STRINGA_ExitHelp;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (strlen(&gn->gn_EditHook[1]) > 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTST_EditHook;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_EditHook[1];
				tagpos += 1;
				}
			if (gn->gn_Tags[5].ti_Data == 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_TabCycle;
				gn->gn_ActualTagList[tagpos].ti_Data = 0;
				tagpos += 1;
				}
			if (gn->gn_Tags[7].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			if (gn->gn_Tags[8].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Immediate;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			break;
		case LISTVIEW_KIND:
			wn->wn_idcmpvalues |= LISTVIEWIDCMP;
			if (gn->gn_Tags[9].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTLV_Labels;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_InfoList;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Tag == GTLV_ShowSelected)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTLV_ShowSelected;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[2].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[8].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			if (strlen(&gn->gn_EditHook[1]) > 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+83;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_EditHook[1];
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTLV_Top;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Data != 16)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTLV_ScrollWidth;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[3].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data != ~0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTLV_Selected;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[4].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[5].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = LAYOUTA_Spacing;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[5].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[7].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTLV_ReadOnly;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			break;
		case MX_KIND:
			wn->wn_idcmpvalues |= MXIDCMP;
			if ((gn->gn_Tags[1].ti_Data != 1) || (wn->wn_CodeOptions[17]))
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTMX_Spacing;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			if (gn->gn_Tags[5].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+69;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[6].ti_Data != PLACETEXT_LEFT)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+71;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[6].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[0].ti_Data != 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTMX_Active;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			gn->gn_ActualTagList[tagpos].ti_Tag  = GTMX_Labels;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->extradata;
			tagpos += 1;
			break;
		case MYBOOL_KIND:
			if (gn->gn_pointers[0])
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Image;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->gn_pointers[0];
				tagpos += 1;
				}
			if (gn->gn_pointers[1])
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_SelectRender;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->gn_pointers[1];
				tagpos += 1;
				}
			if (gn->gn_Tags[0].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_IntuiText;
				pit = (struct Intuitext *)&gn->gn_Tags[4].ti_Tag;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)pit;
				pit->FrontPen = gn->gn_Tags[2].ti_Tag;
				pit->BackPen  = gn->gn_Tags[2].ti_Data;
				pit->DrawMode = gn->gn_Tags[3].ti_Tag;
				pit->LeftEdge = gn->gn_Tags[1].ti_Tag;
				pit->TopEdge  = gn->gn_Tags[1].ti_Data;
				pit->ITextFont = NULL;
				pit->NextText = NULL;
				pit->IText = &gn->gn_title[1];
				tagpos += 1;
				}
			gn->gn_ActualTagList[tagpos].ti_Tag  = GA_UserData;
			gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Tag;
			tagpos += 1;
			break;
		case MYOBJECT_KIND:
			gn->gn_ActualTagList[tagpos].ti_Tag  = GA_UserData;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_InfoList;
			gn->gn_ActualTagList[tagpos].ti_Tag  = TAG_USER+47;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_datas[1];
			gn->gn_ActualTagList[tagpos].ti_Tag  = TAG_USER+48;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->gn_Tags[0].ti_Tag;
			gn->gn_ActualTagList[tagpos].ti_Tag  = TAG_USER+49;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->gn_Tags[2].ti_Tag;
			gn->gn_ActualTagList[tagpos].ti_Tag  = TAG_USER+50;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->gn_Tags[0].ti_Data;
			gn->gn_ActualTagList[tagpos].ti_Tag  = TAG_USER+51;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)gn->gn_Tags[3].ti_Tag;
			tagpos += 1;
			break;
		case NUMBER_KIND:
			if (gn->gn_Tags[0].ti_Data != 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTNM_Number;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTNM_Border;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data)
				{
				if (gn->gn_Tags[5].ti_Data != 1)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+72;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[5].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[6].ti_Data != 0)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+73;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[6].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[7].ti_Data != 1)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+74;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[7].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[8].ti_Data == 0)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+85;
					gn->gn_ActualTagList[tagpos].ti_Data = 0;
					tagpos += 1;
					}
				if (gn->gn_Tags[9].ti_Data != 0)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+76;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[9].ti_Data;
					tagpos += 1;
					}
				if ( strlen(&gn->gn_datas[1]) > 0 )
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+75;
					gn->gn_ActualTagList[tagpos].ti_Data = &gn->gn_datas[1];
					tagpos += 1;
					}
				}
			break;
		case PALETTE_KIND:
			wn->wn_idcmpvalues |= PALETTEIDCMP;
			if (gn->gn_Tags[0].ti_Data != 1)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTPA_Depth;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data != 1)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTPA_Color;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data != 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTPA_ColorOffset;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[2].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Data != TAG_IGNORE)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTPA_IndicatorWidth;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[3].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data != TAG_IGNORE)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTPA_IndicatorHeight;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[4].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[7].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)'_';
				tagpos += 1;
				}
			if (gn->gn_Tags[6].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			break;
		case SCROLLER_KIND:
			wn->wn_idcmpvalues |= SCROLLERIDCMP;
			if (gn->gn_Tags[0].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSC_Top;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSC_Total;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data != 2)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSC_Visible;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[2].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[6].ti_Data != LORIENT_HORIZ)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = PGA_Freedom;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[8].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Tag != TAG_IGNORE)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSC_Arrows;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[3].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[9].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Immediate;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[10].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_RelVerify;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[8].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[11].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			break;
		case SLIDER_KIND:
			wn->wn_idcmpvalues |= SLIDERIDCMP;
			if (gn->gn_Tags[0].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_Min;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_Max;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_Level;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[2].ti_Data;
				tagpos += 1;
				}
			if ( strlen(&gn->gn_EditHook[1]) > 0 )
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_DispFunc;
				gn->gn_ActualTagList[tagpos].ti_Data = &gn->gn_EditHook[1];
				tagpos += 1;
				}
			if (gn->gn_Tags[8].ti_Data != LORIENT_HORIZ)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = PGA_Freedom;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[8].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_LevelFormat;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_datas[1];
				tagpos += 1;
				if (gn->gn_Tags[4].ti_Data)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_MaxLevelLen;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[4].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[5].ti_Data != PLACETEXT_LEFT)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GTSL_LevelPlace;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[5].ti_Data;
					tagpos += 1;
					}
				}
			if (gn->gn_Tags[11].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Immediate;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[12].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_RelVerify;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[10].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[13].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			break;
		case STRING_KIND:
			wn->wn_idcmpvalues |= STRINGIDCMP;
			if (gn->gn_Contents[1] != 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTST_String;
				gn->gn_ActualTagList[tagpos].ti_Data = &gn->gn_Contents[1];
				tagpos += 1;
				}
			if (gn->gn_Tags[0].ti_Data != 64)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTST_MaxChars;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[0].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[1].ti_Data != GACT_STRINGLEFT)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = STRINGA_Justification;
				gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[1].ti_Data;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = STRINGA_ReplaceMode;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[3].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Disabled;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = STRINGA_ExitHelp;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (strlen(&gn->gn_EditHook[1]) > 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTST_EditHook;
				gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_EditHook[1];
				tagpos += 1;
				}
			if (gn->gn_Tags[5].ti_Data == 0)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_TabCycle;
				gn->gn_ActualTagList[tagpos].ti_Data = 0;
				tagpos += 1;
				}
			if (gn->gn_Tags[7].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GT_Underscore;
				gn->gn_ActualTagList[tagpos].ti_Data = '_';
				tagpos += 1;
				}
			if (gn->gn_Tags[8].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GA_Immediate;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			break;
		case TEXT_KIND:
			gn->gn_ActualTagList[tagpos].ti_Tag  = GTTX_Text;
			gn->gn_ActualTagList[tagpos].ti_Data = (ULONG)&gn->gn_datas[1];
			tagpos += 1;
			if (gn->gn_Tags[1].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTTX_Border;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[2].ti_Data)
				{
				gn->gn_ActualTagList[tagpos].ti_Tag  = GTTX_CopyText;
				gn->gn_ActualTagList[tagpos].ti_Data = 1;
				tagpos += 1;
				}
			if (gn->gn_Tags[4].ti_Data)
				{
				if (gn->gn_Tags[5].ti_Data != 1)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+72;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[5].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[6].ti_Data != 0)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+73;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[6].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[7].ti_Data != 1)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+74;
					gn->gn_ActualTagList[tagpos].ti_Data = gn->gn_Tags[7].ti_Data;
					tagpos += 1;
					}
				if (gn->gn_Tags[8].ti_Data == 0)
					{
					gn->gn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+85;
					gn->gn_ActualTagList[tagpos].ti_Data = 0;
					tagpos += 1;
					}
				}
			break;

		}
	return result;
}

