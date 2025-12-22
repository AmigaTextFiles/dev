void fixmytagpointers( struct MyTag *mt )
{
	UBYTE * s;
	ULONG * l;
	struct IntuiText *prevpit; 
	struct IntuiText *pit;
	if (mt)
	  if (mt->mt_BufferSize>0)
		{
		switch (mt->mt_TagType)
			{
			case TagTypeArrayString :
				l = (ULONG *)mt->mt_Data;
				while (*l)
					l += 1;
				l += 1;
				s =  (UBYTE*)l;
				
				l = (ULONG *)mt->mt_Data;
				while (*l)
					{
					*l = (ULONG)s;
					while( *s !=0)
						s += 1;
					s += 1;
					l = (ULONG *)( (ULONG)l + 4 );
					}
				break;
			case TagTypeStringList :
				s = (UBYTE*)mt->mt_Data;
				NewList((struct List *)s);
				s += sizeof(struct List);
				while ( (ULONG)s - (ULONG)(mt->mt_Data) < mt->mt_BufferSize )
					{
					AddTail( (struct List *)(mt->mt_Data), (struct Node *)s);
					s += 10;
					l = (ULONG *)s;
					*l = (ULONG)s + 4;
					s += 4;
					while( *s != 0)
						s += 1;
					s += 1;
					s = (UBYTE *)((((ULONG)s+1)/2)*2);
					}
				break;
			case TagTypeIntuiText :
				prevpit = NULL;
				s = (UBYTE *)mt->mt_Data;
				while ( (ULONG)s - (ULONG)(mt->mt_Data) < mt->mt_BufferSize )
					{
					pit = (struct Intuitext *)s;
					if (prevpit)
						prevpit->NextText = pit;
					prevpit = pit;
					pit->ITextFont = NULL;
					pit->NextText = NULL;
					s += sizeof(struct IntuiText);
					
					while( *s != 0)
						s += 1;
					s += 1;
					s = (UBYTE *)((((ULONG)s+1)/2)*2);
					}
				break;
			
			}
		}
}

int ReadGadgetNode(struct ProducerNode *pwn, struct IFFHandle *IFF, struct WindowNode *wn)
{
	long result = 0;
	long error  = 0;
	struct gadgetstore gs;
	struct GadgetNode *gn;
	struct MyTag *mt = NULL;
	struct StringNode *sn;
	struct tagstore ts;
	struct ContextNode * pcn;
	
#ifdef DEBUG
	FPuts(pwn->debug, "  Loading Gadget\n");
#endif
	
	gs.EditHook[0] = 0;
	gs.EditHook[1] = 0;
	gs.Contents[0] = 0;
	gs.Contents[1] = 0;
	gs.Contents2   = 0;
	
	error = ReadChunkBytes(IFF, &gs, sizeof(struct gadgetstore));
	if (error>0)
		{
		gn = (struct GadgetNode *)AllocVec(sizeof(struct GadgetNode), MEMF_CLEAR);
		if (gn)
			{
			pwn->MemCount += 1;
			
			AddTail((struct List *)&wn->wn_GadgetList, (struct Node *)gn);
			
			gn->gn_Flags    = gs.flags;
			gn->gn_LeftEdge = gs.leftedge;
			gn->gn_TopEdge  = gs.topedge;
			gn->gn_Width    = gs.width;
			gn->gn_Height   = gs.height;
			gn->gn_Kind     = gs.kind;
			CopyMem( &gs.title[0], &gn->gn_title[0], 68);
			fixstring(&gn->gn_title[0]);
			gn->gn_Title = &gn->gn_title[1];
			gn->gn_Label = &gn->gn_LabelID[1];
			gn->gn_GadgetID = gs.id;
			CopyMem( &gs.labelid[0], &gn->gn_LabelID[0], 68);
			fixstring(&gn->gn_LabelID[0]);
			CopyMem( &gs.fontname[0], &gn->gn_FontName[0], 48);
			fixstring(&gn->gn_FontName[0]);
			gn->gn_Font.ta_Name = &gn->gn_FontName[1];
			gn->gn_Font.ta_YSize = gs.fontysize;
			gn->gn_Font.ta_Style = gs.fontstyle;
			gn->gn_Font.ta_Flags = gs.fontflags;
			
			CopyMem( &gs.tags[0], &gn->gn_Tags[0], 120);
			gn->gn_Joined = gs.joined;
			CopyMem( &gs.datas[0], &gn->gn_datas[0], 68);
			fixstring(&gn->gn_datas[0]);
			NewList((struct List *)&gn->gn_InfoList);
			CopyMem( &gs.EditHook[0], &gn->gn_EditHook[0], 256);
			fixstring(&gn->gn_EditHook[0]);
			CopyMem( &gs.Contents[0], &gn->gn_Contents[0], 86);
			fixstring(&gn->gn_Contents[0]);
			gn->gn_Contents2 = gs.Contents2;
			
			switch (gn->gn_Kind)
				{
				case (STRING_KIND):
					if (gn->gn_Joined)
						gn->gn_pointers[0] = (UBYTE *)gs.specialdata;
					break;
				case (LISTVIEW_KIND):
					gn->gn_Tags[0].ti_Data = (ULONG)&gn->gn_InfoList;
					if (gn->gn_Tags[2].ti_Data != 0)
						gn->gn_Tags[2].ti_Data = gs.specialdata;
					break;
				case (TEXT_KIND):
					gn->gn_Tags[0].ti_Data = (ULONG)&gn->gn_title[1];
					break;
				}
			
			while ( (gs.listfollows>0) && ( result ==0 ) )
				{
				error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
				if ( (error == 0) || (error==IFFERR_EOC) )
					{
					pcn = CurrentChunk(IFF);
					
					if ( (pcn->cn_ID == id_tagd ) && (error ==0 ) )
						{
						gs.listfollows -=1;
						mt = (struct MyTag *)AllocVec(sizeof(struct MyTag),MEMF_CLEAR);
						if (mt)
							{
							pwn->MemCount +=1 ;
							AddTail((struct List *)&gn->gn_InfoList, (struct Node *)mt);
							error = ReadChunkBytes( IFF, &ts, sizeof(struct tagstore));
							if (error>0)
								{
								error = 0;
								
								CopyMem( &ts.dataname[0], &mt->dataname[0], 68);
								fixstring(&mt->dataname[0]);
								
								CopyMem( &ts.title[0], &mt->title[0], 68);
								fixstring(&mt->title[0]);
								mt->mt_Label = &mt->title[1];
	
#ifdef DEBUG
	FPuts(pwn->debug, "  Loading Tag : ");
	FPuts(pwn->debug, mt->mt_Label);
	FPuts(pwn->debug, "\n");
#endif

								mt->mt_TagType = ts.tagtype;
								mt->mt_Value = ts.value;
								mt->mt_BufferSize = ts.datasize;
								mt->mt_Data = (UBYTE *)ts.data;
								
								if (mt->mt_BufferSize>0)
									{
									mt->mt_Data = AllocVec(mt->mt_BufferSize, MEMF_CLEAR);
									if (mt->mt_Data == NULL)
										{
										result = 4;
										mt->mt_BufferSize = 0;
										}
									gs.listfollows += 1;
									}

#ifdef DEBUG
	FPuts(pwn->debug, "  Loading Tag 2 : ");
	FPuts(pwn->debug, mt->mt_Label);
	FPuts(pwn->debug, "\n");
#endif

								}
							else
								result = 5;
							}
						else
							result = 4;
						}
					
					if ( (pcn->cn_ID == id_tags ) && (error ==0 ) )
						{
						if (mt)
							if (mt->mt_Data)
								{
								error = ReadChunkBytes( IFF, mt->mt_Data, mt->mt_BufferSize);
								if (error>0)
									fixmytagpointers(mt);
								else
									result = 5;
								mt = NULL;
								gs.listfollows -=1;
								}
							else
								result = 5;
						else
							result = 5;
						}
					
					if ( (pcn->cn_ID == id_strn ) && (error ==0 ) )
						{
						gs.listfollows -= 1;
						sn = (struct StringNode *)AllocVec(sizeof(struct StringNode),MEMF_CLEAR);
						if (sn)
							{
							pwn->MemCount +=1 ;
							AddTail((struct List *)&gn->gn_InfoList,(struct Node *)sn);
							error = ReadChunkBytes( IFF, &sn->sn_st[0], 256);
							if (error>0)
								{
								error = 0;
								fixstring(&sn->sn_st[0]);
								}
							else
								result = 5;
							}
						else
							result = 4;
						}
					}
				else
					result = 6;
				}
			
			}
		else
			result = 4;
		}
	else
		result = 5;
	return result;
}

int ReadTextNode(struct ProducerNode *pwn, struct IFFHandle *IFF, struct WindowNode *wn)
{
	long result = 0;
	long error  = 0;
	struct textstore ts;
	struct TextNode *tn;
	
#ifdef DEBUG
	FPuts(pwn->debug, "  Loading Text\n");
#endif
	
	error = ReadChunkBytes(IFF, &ts, sizeof(struct textstore));
	if (error>0)
		{
		tn = (struct TextNode *)AllocVec(sizeof(struct TextNode), MEMF_CLEAR);
		if (tn)
			{
			pwn->MemCount += 1;
			AddTail((struct List *)&wn->wn_TextList, (struct Node *)tn);
			
			tn->tn_LeftEdge = ts.leftedge;
			tn->tn_TopEdge  = ts.topedge;
			tn->tn_FrontPen = ts.frontpen;
			tn->tn_BackPen  = ts.backpen;
			tn->tn_DrawMode = ts.drawmode;
			tn->tn_ScreenFont = ts.screenfont;
			
			CopyMem(&ts.title[0],&tn->title[0],68);
			fixstring(&tn->title[0]);
			tn->tn_Title = &tn->title[1];
			
			CopyMem(&ts.fontname[0],&tn->fonttitle[0],48);
			fixstring(&tn->fonttitle[0]);
			tn->tn_Font.ta_Name = &tn->fonttitle[1];
			
			tn->tn_Font.ta_YSize = ts.fontysize;
			tn->tn_Font.ta_Style = ts.fontstyle;
			tn->tn_Font.ta_Flags = ts.fontflags;
			
			}
		else
			result = 4;
		}
	else
		result = 5;
	return result;
}

int ReadBevelBox(struct ProducerNode *pwn, struct IFFHandle *IFF, struct WindowNode *wn)
{
	long result = 0;
	long error  = 0;
	struct bevelboxstore bbs;
	struct BevelBoxNode *bb;
	
#ifdef DEBUG
	FPuts(pwn->debug, "  Loading BevelBox\n");
#endif
	
	error = ReadChunkBytes(IFF, &bbs, sizeof(struct bevelboxstore));
	if (error>0)
		{
		bb = (struct BevelBoxNode *)AllocVec(sizeof(struct BevelBoxNode), MEMF_CLEAR);
		if (bb)
			{
			pwn->MemCount += 1;
			AddTail((struct List *)&wn->wn_BevelBoxList, (struct Node *)bb);
			
			bb->bb_LeftEdge  = bbs.leftedge;
			bb->bb_TopEdge   = bbs.topedge;
			bb->bb_Width     = bbs.width;
			bb->bb_Height    = bbs.height;
			bb->bb_BevelType = bbs.beveltype;
			
			}
		else
			result = 4;
		}
	else
		result = 5;
	return result;
}

ReadSmallImage(struct ProducerNode *pwn, struct IFFHandle *IFF, struct WindowNode *wn)
{
	long result = 0;
	long error  = 0;
	struct smallimagestore sis;
	struct SmallImageNode *sin;
	
#ifdef DEBUG
	FPuts(pwn->debug, "  Loading Small Image\n");
#endif
	
	error = ReadChunkBytes(IFF, &sis, sizeof(struct smallimagestore));
	if (error>0)
		{
		if (sis.placed)
			{
			sin = (struct SmallImageNode *)AllocVec(sizeof(struct SmallImageNode), MEMF_CLEAR);
			if (sin)
				{
				pwn->MemCount += 1;
				AddTail((struct List *)&wn->wn_ImageList, (struct Node *)sin);
				sin->sin_LeftEdge = sis.leftedge;
				sin->sin_TopEdge  = sis.topedge;
				CopyMem(&sis.title[0],&sin->title[0],68);
				fixstring(&sin->title[0]);
				CopyMem(&sis.imagename[0],&sin->imagename[0],68);
				fixstring(&sin->imagename[0]);
				}
			else
				result = 4;
			}
		}
	else
		result = 5;
	return result;
}

int ReadWindowInfo(struct ProducerNode *pwn, struct IFFHandle *IFF, struct WindowNode *wn)
{
	long result = 0;
	long error  = 0;
	long loop;
	long count;
	struct windowstore ws;
	
#ifdef DEBUG
	FPuts(pwn->debug, "  Loading Info\n");
#endif
	
	for (loop=0;loop<6;loop++)
		{
		ws.localeoptions[loop]=0;
		ws.moretags[loop]=0;
		}
	ws.defpubname[0]=0;
	ws.defpubname[1]=0;
	ws.moretags[0]=1;
	for (loop=0;loop<20;loop++)
		{
		ws.codeoptions[loop]=0;
		ws.extracodeoptions[loop]=0;
		}
	ws.winparams[0]=0;
	ws.winparams[1]=0;
	
	ws.fontx=0;
	ws.fonty=0;
	
	error = ReadChunkBytes(IFF, &ws, sizeof(struct windowstore));
	if (error>0)
		{
		CopyMem( &ws.localeoptions[0], &wn->wn_LocaleOptions[0], 5);
		CopyMem( &ws.codeoptions[0], &wn->wn_CodeOptions[0], 20);
		CopyMem( &ws.extracodeoptions[0], &wn->wn_ExtraCodeOptions[0], 20);
		CopyMem( &ws.moretags[0], &wn->wn_MoreTags[0], 5);
		wn->wn_Offx    = ws.offx;
		wn->wn_Offy    = ws.offy;
		wn->wn_FirstID = ws.nextid;
		
		CopyMem( &ws.title[0], &wn->wn_Titlestr[0], 69);
		fixstring(&wn->wn_Titlestr[0]);
		wn->wn_Title   = &wn->wn_Titlestr[1];
		
		wn->wn_LeftEdge  = ws.leftedge;
		wn->wn_TopEdge   = ws.topedge;
		wn->wn_Width     = ws.width;
		wn->wn_Height    = ws.height;
		
		CopyMem( &ws.screentitle[0], &wn->wn_ScreenTitlestr[0], 69);
		fixstring(&wn->wn_ScreenTitlestr[0]);
		wn->wn_ScreenTitle   = &wn->wn_ScreenTitlestr[1];
		
		wn->wn_MinWidth   = ws.minw;
		wn->wn_MaxWidth   = ws.maxw;
		wn->wn_MinHeight  = ws.minh;
		wn->wn_MaxHeight  = ws.maxh;
		wn->wn_InnerWidth   = ws.innerw;
		wn->wn_InnerHeight  = ws.innerh;
		
		CopyMem( &ws.labelid[0], &wn->wn_LabelID[0], 69);
		fixstring(&wn->wn_LabelID[0]);
		wn->wn_Label   = &wn->wn_LabelID[1];
		
		wn->wn_Zoom[0] = ws.zoom[0];
		wn->wn_Zoom[1] = ws.zoom[1];
		wn->wn_Zoom[2] = ws.zoom[2];
		wn->wn_Zoom[3] = ws.zoom[3];
		
		wn->wn_MouseQueue = ws.mousequeue;
		wn->wn_RptQueue = ws.rptqueue;
		
		wn->wn_SizeGadget  = ws.sizegad;
		wn->wn_SizeBRight  = ws.sizebright;
		wn->wn_SizeBBottom = ws.sizebbottom;
		wn->wn_DragBar     = ws.dragbar;
		wn->wn_DepthGad    = ws.depthgad;
		wn->wn_CloseGad    = ws.closegad;
		wn->wn_ReportMouse = ws.reportmouse;
		wn->wn_NoCareRefresh = ws.nocarerefresh;
		wn->wn_Borderless    = ws.borderless;
		wn->wn_Backdrop    = ws.backdrop;
		wn->wn_GimmeZZ     = ws.gimmezz;
		wn->wn_Activate    = ws.activate;
		wn->wn_RMBTrap     = ws.rmbtrap;
		wn->wn_SimpleRefresh = ws.simplerefresh;
		wn->wn_SmartRefresh  = ws.smartrefresh;
		wn->wn_AutoAdjust  = ws.autoadjust;
		wn->wn_MenuHelp    = ws.menuhelp;
		wn->wn_UseZoom     = ws.usezoom;
		wn->wn_CustomScreen= ws.customscreen;
		wn->wn_PubScreen   = ws.pubscreen;
		wn->wn_PubScreenName  = ws.pubscreenname;
		wn->wn_PubScreenFallBack  = ws.pubscreenfallback;
		
		CopyMem(&ws.idcmplist[0], &wn->wn_idcmplist[0], 25);
		
		CopyMem( &ws.menutitle[0], &wn->wn_MenuTitle[0], 69);
		fixstring(&wn->wn_MenuTitle[0]);
		
		CopyMem( &ws.gadgetfontname[0], &wn->wn_GadgetFontName[0], 49);
		fixstring(&wn->wn_GadgetFontName[0]);
		
		wn->wn_GadgetFont.ta_YSize = ws.gadgetfont.ta_YSize;
		wn->wn_GadgetFont.ta_Style = ws.gadgetfont.ta_Style;
		wn->wn_GadgetFont.ta_Flags = ws.gadgetfont.ta_Flags;
		wn->wn_GadgetFont.ta_Name = &wn->wn_GadgetFontName[1];
		
		wn->wn_Fontx = ws.fontx;
		wn->wn_Fonty = ws.fonty;
		
		CopyMem( &ws.winparams[0], &wn->wn_WinParamsstr[0], 256);
		fixstring(&wn->wn_WinParamsstr[0]);
		
		wn->wn_WinParams = &wn->wn_WinParamsstr[1];
		wn->wn_RendParams = &wn->wn_RendParamsstr[1];
		
		loop = 1;
		while( wn -> wn_WinParamsstr[loop] != 0)
			{
			if ((wn -> wn_WinParamsstr[loop] == ':') && (wn -> wn_WinParamsstr[loop+1] == ':'))
				{
				wn -> wn_WinParamsstr[loop] = 0;
				wn -> wn_WinParamsstr[0] = loop-1;
				loop +=2;
				count = 1;
				while( wn -> wn_WinParamsstr[loop] != 0)
					{
					wn->wn_RendParamsstr[count] = wn->wn_WinParamsstr[loop];
					count++;
					loop++;
					}
				wn->wn_RendParamsstr[count] = 0;
				wn->wn_RendParamsstr[0]     = count-1;
				}
			else
				loop++;
			}
		
		wn->wn_CodeOptions[14] = 1;
		CopyMem( &ws.defpubname[0], &wn->wn_DefPubName[0], 80);
		fixstring(&wn->wn_DefPubName[0]);
		wn->wn_DefaultPubScreenName = &wn->wn_DefPubName[1];
		}
	else
		result = 5;
	return result;
}

int ReadWindow( struct ProducerNode *pwn, struct IFFHandle *IFF)
{
	struct WindowNode *wn;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	long finished = 0;
	struct GadgetNode *gn;
	struct GadgetNode *gn2;
	
#ifdef DEBUG
	FPuts(pwn->debug,"Loading Window:\n");
#endif
	
	wn = (struct WindowNode *)AllocVec(sizeof(struct WindowNode),MEMF_CLEAR);
	if (wn)
		{
		NewList((struct List *)&wn->wn_GadgetList);
		NewList((struct List *)&wn->wn_TextList);
		NewList((struct List *)&wn->wn_ImageList);
		NewList((struct List *)&wn->wn_BevelBoxList);
	
		pwn->MemCount += 1;
		AddTail((struct List *)&pwn->WindowList,(struct Node *)wn);
		while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
			{
			error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
	
			pcn = CurrentChunk(IFF);
			
			if (error == IFFERR_EOC )
				if ( (pcn->cn_Type==id_wind) && (pcn->cn_ID==ID_FORM) )
					finished=1;
			
			if (error == 0 )
				{
				
				if ( (result == 0) && (pcn->cn_ID == id_bevl) )
					result = ReadBevelBox(pwn, IFF, wn);
				
				if ( (result == 0) && (pcn->cn_ID == id_info) )
					result = ReadWindowInfo(pwn, IFF, wn);
				
				if ( (result == 0) && (pcn->cn_ID == id_imag) )
					result = ReadSmallImage(pwn, IFF, wn);
				
				if ( (result == 0) && (pcn->cn_ID == id_text) )
					result = ReadTextNode(pwn, IFF, wn);
				
				if ( (result == 0) && (pcn->cn_ID == id_gadg) )
					result = ReadGadgetNode(pwn, IFF, wn);
				
				}
			
			}

		}
	else
		return 4;
	
	if (result == 0)
		{
		gn = (struct GadgetNode *)wn->wn_GadgetList.mlh_Head;
		while (gn->gn_Succ)
			{
			if (gn->gn_Kind == STRING_KIND)
				{
				if (gn->gn_Joined)
					{
					result = 6;
					gn2 = (struct GadgetNode *)wn->wn_GadgetList.mlh_Head;
					while (gn2->gn_Succ)
						{
						if (gn2->gn_GadgetID == (ULONG)gn->gn_pointers[0])
							{
							result = 0;
							gn->gn_pointers[0] = gn2;
							gn2->gn_Tags[2].ti_Data = (ULONG)gn;
							}
						gn2 = gn2->gn_Succ;
						}
					}
				}
			
			gn = gn->gn_Succ;
			}
		}
	
	return result;
}

void FreeWindowNode(struct ProducerNode *pwn,struct WindowNode *wn)
{
	struct SmallImageNode *sin;
	struct TextNode       *tn;
	struct BevelBoxNode   *bb;
	struct GadgetNode     *gn;
	struct MyTag          *mt;
	struct StringNode     *sn;
	
	if (wn)
		{
		gn = (struct GadgetNode *)RemHead((struct List *)&wn->wn_GadgetList);
		while(gn)
			{
			
			if (gn->gn_Kind == MYOBJECT_KIND)
				{
				mt = (struct MyTag *)RemHead((struct List *)&gn->gn_InfoList);
				while (mt)
					{
					if (mt->mt_BufferSize>0)
						{
						pwn->MemCount -=1 ;
						FreeVec(mt->mt_Data);
						}
#ifdef DEBUG
	FPuts(pwn->debug, "  Freeing Tag : ");
	FPuts(pwn->debug, mt->mt_Label);
	FPuts(pwn->debug, "\n");
#endif
					pwn->MemCount -=1 ;
					FreeVec(mt);
					mt = (struct MyTag *)RemHead((struct List *)&gn->gn_InfoList);
					}
				}
			else
				{
				sn = (struct StringNode *)RemHead((struct List *)&gn->gn_InfoList);
				while(sn)
					{
					pwn->MemCount -=1 ;
					FreeVec(sn);
					sn = (struct StringNode *)RemHead((struct List *)&gn->gn_InfoList);
					}
				}
			
			if (gn->extradata)
				{
				pwn->MemCount -=1 ;
				FreeVec(gn->extradata);
				}
			
			pwn->MemCount -=1 ;
			FreeVec(gn);
			gn = (struct GadgetNode *)RemHead((struct List *)&wn->wn_GadgetList);
			}

		sin = (struct SmallImageNode *)RemHead((struct List *)&wn->wn_ImageList);
		while (sin)
			{
			FreeVec(sin);
			pwn->MemCount -=1 ;
			sin = (struct SmallImageNode *)RemHead((struct List *)&wn->wn_ImageList);
			}
		bb = (struct BevelBoxNode *)RemHead((struct List *)&wn->wn_BevelBoxList);
		while (bb)
			{
			FreeVec(bb);
			pwn->MemCount -=1 ;
			bb = (struct BevelBoxNode *)RemHead((struct List *)&wn->wn_BevelBoxList);
			}
		tn = (struct TextNode *)RemHead((struct List *)&wn->wn_TextList);
		while (tn)
			{
			FreeVec(tn);
			pwn->MemCount -=1 ;
			tn = (struct TextNode *)RemHead((struct List *)&wn->wn_TextList);
			}
		FreeVec(wn);
		pwn->MemCount -= 1;
		}
}