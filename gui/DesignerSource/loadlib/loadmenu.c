void fixstring(char *s)
{
	char l;
	if (s)
		{
		l = *s;
		s += (l+1);
		*s = 0 ;
		}
}

int ReadSubItems( struct IFFHandle *IFF, struct MenuItemNode *mi, struct ProducerNode *pwn)
{
	struct MenuSubItemNode *ms = NULL;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct subitemstore ss;
	long finished = 0;
	
	while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
		{
		error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
		pcn = CurrentChunk(IFF);
		
		if (error == IFFERR_EOC )
			if ( (pcn->cn_Type==id_subs) && (pcn->cn_ID==ID_FORM) )
				finished=1;
		
		if (error ==0 )
			{
			
			if ( (pcn->cn_ID==id_subi) && (result==0))
				{
				error = ReadChunkBytes(IFF, &ss, sizeof(struct subitemstore));
				if (error>0)
					{
					error = 0;
					ms = (struct MenuItemNode *)AllocVec(sizeof(struct MenuSubItemNode),MEMF_CLEAR);
					if (ms)
						{
						pwn->MemCount += 1;
						AddTail((struct List *)&mi->mi_SubItemList,(struct Node *)ms);
						
						CopyMem(&ss.idlabel[0],&ms->ms_idlabel[0],70);				
						fixstring(&ms->ms_idlabel[0]);
						
						ms->ms_Barlabel = ss.barlabel;
						CopyMem(&ss.text[0],&ms->ms_textstr[0],70);
						fixstring(&ms->ms_textstr[0]);
						ms->ms_CommKey = ss.commkey[1];
						ms->ms_Disabled = ss.disabled;
						ms->ms_Checkit = ss.checkit;
						ms->ms_MenuToggle = ss.menutoggle;
						ms->ms_Checked = ss.checked;
						ms->ms_Exclude = ss.exclude;
						CopyMem(&ss.graphicname[0],&ms->ms_graphicname[0],68);
						fixstring(&ms->ms_graphicname[0]);
						
						ms->ms_Text  = &ms->ms_textstr[1];
						ms->ms_Label = &ms->ms_idlabel[1];
						}
					else
						result = 4;
					}
				else
					result = 5;
				}
			
			}
		}
	return result;
}

int ReadItems( struct IFFHandle *IFF, struct MenuTitleNode *mt, struct ProducerNode *pwn)
{
	struct MenuItemNode *mi = NULL;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct itemstore is;
	long finished = 0;
	
	while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
		{
		error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
		pcn = CurrentChunk(IFF);
		
		if (error == IFFERR_EOC )
			if ( (pcn->cn_Type==id_itms) && (pcn->cn_ID==ID_FORM) )
				finished=1;
		
		if (error ==0 )
			{
			
			if ( (pcn->cn_ID==id_item) && (result==0))
				{
				error = ReadChunkBytes(IFF, &is, sizeof(struct itemstore));
				if (error>0)
					{
					error=0;
					mi = (struct MenuItemNode *)AllocVec(sizeof(struct MenuItemNode),MEMF_CLEAR);
					if (mi)
						{
						pwn->MemCount += 1;
						AddTail((struct List *)&mt->mt_ItemList,(struct Node *)mi);
						NewList((struct List *)&mi->mi_SubItemList);
						CopyMem(&is.idlabel[0],&mi->mi_idlabel[0],68);
						fixstring(&mi->mi_idlabel[0]);
						mi->mi_Barlabel = is.barlabel;
						CopyMem(&is.text[0],&mi->mi_textstr[0],68);
						fixstring(&mi->mi_textstr[0]);
						mi->mi_CommKey = is.commkey[1];
						mi->mi_Disabled = is.disabled;
						mi->mi_Checkit = is.checkit;
						mi->mi_MenuToggle = is.menutoggle;
						mi->mi_Checked = is.checked;
						mi->mi_Exclude = is.exclude;
						CopyMem(&is.graphicname[0],&mi->mi_graphicname[0],67);
						fixstring(&mi->mi_graphicname[0]);
						mi->mi_Text = &mi->mi_textstr[1];
						mi->mi_Label = &mi->mi_idlabel[1];
						}
					else
						result = 4;
					}
				else
					result = 5;
				}
			
			if ( (pcn->cn_ID==ID_FORM) && (result==0))
				{
				if ( pcn->cn_Type == id_subs)
					{
					if (mi)
						result = ReadSubItems(IFF,mi,pwn);
					else
						result = 5;
					}
				}
			}
		}
	return result;
}

int ReadTitles( struct IFFHandle *IFF, struct MenuNode *mn, struct ProducerNode *pwn)
{
	struct MenuTitleNode *mt = NULL;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct titlestore ts;
	long finished = 0;
	
	while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
		{
		error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
		pcn = CurrentChunk(IFF);
		
		if (error == IFFERR_EOC )
			if ( (pcn->cn_Type==id_ttls) && (pcn->cn_ID==ID_FORM) )
				finished=1;
		
		if (error ==0 )
			{
			
			if ( (pcn->cn_ID==id_ttle) && (result==0))
				{
				error = ReadChunkBytes(IFF, &ts, sizeof(struct titlestore));
				if (error>0)
					{
					error=0;
					mt = (struct MenuTitleNode *)AllocVec(sizeof(struct MenuTitleNode),MEMF_CLEAR);
					if (mt)
						{
						pwn->MemCount += 1;
						AddTail((struct List *)&mn->mn_MenuList,(struct Node *)mt);
						NewList((struct List *)&mt->mt_ItemList);
						mt->mt_Disabled = ts.disabled;
						CopyMem(&ts.idlabel[0],&mt->mt_idlabelstr[0],68);
						fixstring(&mt->mt_idlabelstr[0]);
						CopyMem(&ts.text[0],&mt->mt_textstr[0],68);
						fixstring(&mt->mt_textstr[0]);	
						mt->mt_Text = &mt->mt_textstr[1];
						mt->mt_Label = &mt->mt_idlabelstr[1];
						}
					else
						result = 4;
					}
				else
					result = 5;
				}
			if ( (pcn->cn_ID==ID_FORM) && (result==0))
				{
				if ( pcn->cn_Type == id_itms)
					{
					if (mt)
						result = ReadItems(IFF,mt,pwn);
					else
						result = 5;
					}
				}
			}
		}
	return result;
}

int ReadMenu( struct ProducerNode *pwn, struct IFFHandle *IFF)
{
	struct MenuNode *mn;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct menustore ms;
	long finished = 0;
	long tagpos = 0;
#ifdef DEBUG
	FPuts(pwn->debug,"Menu : ");
#endif
	mn = (struct MenuNode *)AllocVec(sizeof(struct MenuNode),MEMF_CLEAR);
	if (mn)
		{
		pwn->MemCount += 1;
		AddTail((struct List *)&pwn->MenuList,(struct Node *)mn);
		NewList((struct List *)&mn->mn_MenuList);				
		while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
			{
			error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
	
			pcn = CurrentChunk(IFF);
			
			if (error == IFFERR_EOC )
				if ( (pcn->cn_Type==id_menu) && (pcn->cn_ID==ID_FORM) )
					finished=1;
			
			if (error ==0 )
				{
				
				if ( (pcn->cn_ID==id_info) && (result==0))
					{
					error = ReadChunkBytes(IFF, &ms, sizeof(struct menustore));
					if (error>0)
						{
						error = 0;
						CopyMem(&ms.text[0],&mn->mn_textstr[0],68);
						fixstring(&mn->mn_textstr[0]);
						/*
						mn->mn_Text = &mn->mn_textstr[1];
						*/
						CopyMem(&ms.idlabel[0],&mn->mn_idlabelstr[0],68);
						fixstring(&mn->mn_idlabelstr[0]);
						mn->mn_Label = &mn->mn_idlabelstr[1];
						mn->mn_FrontPen = ms.frontpen;
						CopyMem(&ms.fontname[0],&mn->mn_fontname[0],48);
						fixstring(&mn->mn_fontname[0]);
						mn->mn_DefaultFont = ms.defaultfont;
						CopyMem(&ms.font,&mn->mn_Font,sizeof(struct TextAttr));
						mn->mn_Font.ta_Name = &mn->mn_fontname[1];
						mn->mn_LocaleMenu = ms.localmenu;
						
						mn->mn_TagList = &mn->mn_ActualTagList[0];
						tagpos = 0;
						
						mn->mn_ActualTagList[tagpos].ti_Tag  = GT_TagBase+67;
						mn->mn_ActualTagList[tagpos].ti_Data = 1;
						tagpos += 1;
						
						if (mn->mn_FrontPen != 0)
							{
							mn->mn_ActualTagList[tagpos].ti_Tag  = GTMN_FrontPen;
							mn->mn_ActualTagList[tagpos].ti_Data = mn->mn_FrontPen;
							tagpos += 1;
							}
						
						if (mn->mn_DefaultFont == 0)
							{
							mn->mn_ActualTagList[tagpos].ti_Tag  = GTMN_TextAttr;
							mn->mn_ActualTagList[tagpos].ti_Data = (ULONG)&mn->mn_Font;
							tagpos += 1;
							}
						
#ifdef DEBUG
    FPuts(pwn->debug,mn->mn_Label);
	FPuts(pwn->debug,"\n");
#endif					
						}
					else
						result = 5;
					}
				if ( (pcn->cn_ID==ID_FORM) && (result==0))
					{
					if ( (pcn->cn_Type == id_ttls) )
						result = ReadTitles(IFF,mn,pwn);
					}
				}
			}
		}
	else
		return 4;
	return result;
}

void FreeMenuNode(struct ProducerNode *pwn,struct MenuNode *mn)
{
	struct MenuTitleNode *tn;
	struct MenuItemNode *in;
	struct MenuSubItemNode *sn;
	if (mn)
		{
		tn = (struct MenuTitleNode *)RemHead((struct List *)&mn->mn_MenuList);
		while (tn)
			{
			in = (struct MenuItemNode *)RemHead((struct List *)&tn->mt_ItemList);
			while (in)
				{
				sn = (struct MenuSubItemNode *)RemHead((struct List *)&in->mi_SubItemList);
				while(sn)
					{
					FreeVec(sn);
					pwn->MemCount -= 1;
					sn = (struct MenuSubItemNode *)RemHead((struct List *)&in->mi_SubItemList);
					}
				FreeVec(in);
				pwn->MemCount -= 1;
				in = (struct MenuItemNode *)RemHead((struct List *)&tn->mt_ItemList);
				}
			FreeVec(tn);
			pwn->MemCount -= 1;
			tn = (struct MenuTitleNode *)RemHead((struct List *)&mn->mn_MenuList);
			}
		FreeVec(mn);
		pwn->MemCount -= 1;
		}
}