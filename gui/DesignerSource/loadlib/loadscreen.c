int ReadScreen( struct ProducerNode *pwn, struct IFFHandle *IFF)
{
	struct ScreenNode *sn;
	long result = 0;
	long error = 0;
	struct ContextNode *pcn;
	struct screenstore ss;
	long finished = 0;
	long tagpos = 0;

#ifdef DEBUG
	FPuts(pwn->debug, "Load screen \n");
#endif
	
	sn = (struct ScreenNode *)AllocVec(sizeof(struct ScreenNode),MEMF_CLEAR);
	if (sn)
		{
		pwn->MemCount += 1;
		AddTail((struct List *)&pwn->ScreenList,(struct Node *)sn);
		while (((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
			{
			error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
			
			pcn = CurrentChunk(IFF);
			
			if (error == IFFERR_EOC )
				if ( (pcn->cn_Type==id_scrn) && (pcn->cn_ID==ID_FORM) )
					finished=1;
			
			if ((error ==0) && (finished == 0) )
				{
				if ( (pcn->cn_ID==id_scrc) && (result == 0) )
					{
					if (sn->sn_ColorArray != NULL)
						{
#ifdef DEBUG
	FPuts(pwn->debug, "Load screen colors\n");
#endif
						error = ReadChunkBytes(IFF, sn->sn_ColorArray, sn->sn_SizeColorArray);
						if (error>0)
							{
							error = 0;
							}
						else
							result = 5;
#ifdef DEBUG
	FPuts(pwn->debug, "Loaded screen colors\n");
#endif
						}
					else
						result = 6;
					}
				
				if ( (pcn->cn_ID==id_scri) && (result == 0) )
					{
					error = ReadChunkBytes(IFF,&ss,sizeof(struct screenstore));
					if (error>0)
						{
						error = 0;
						CopyMem(&ss.labelid[0],&sn->sn_labelid[0],256);
						fixstring(&sn->sn_labelid[0]);
						sn->sn_Label        = &sn->sn_labelid[1];
						sn->sn_Left         = ss.left;
						sn->sn_Top          = ss.top;
						sn->sn_Width        = ss.width;
						sn->sn_Height       = ss.height;
						sn->sn_Depth        = ss.depth;
						sn->sn_OverScan     = ss.overscan;
						sn->sn_FontType     = ss.fonttype;
						sn->sn_Behind       = ss.behind;
						sn->sn_Quiet        = ss.quiet;
						sn->sn_ShowTitle    = ss.showtitle;
						sn->sn_AutoScroll   = ss.autoscroll;
						sn->sn_Bitmap       = ss.bitmap;
						sn->sn_CreateBitmap = ss.createbitmap;
						CopyMem(&ss.title[0],&sn->sn_titlestr[0],256);
						fixstring(&sn->sn_titlestr[0]);
						sn->sn_Title = &sn->sn_titlestr[1];
						sn->sn_LocaleTitle      = ss.loctitle;
						sn->sn_DisplayID        = ss.idnum;
						sn->sn_ScreenType       = ss.screentype;
						
						CopyMem(&ss.pubname[0],&sn->sn_pubnamestr[0],256);
						fixstring(&sn->sn_pubnamestr[0]);
						sn->sn_PubScreenName   = &sn->sn_pubnamestr[1];
						
						
						sn->sn_DoPubSig        = ss.dopubsig;
						sn->sn_DefaultPens     = ss.defpens;
						sn->sn_FullPalette     = ss.fullpalette;
						CopyMem(&ss.fontname[0],&sn->sn_fontname[0],52);
						fixstring(&sn->sn_fontname[0]);
						CopyMem(&ss.font,&sn->sn_Font,sizeof(struct TextAttr));
						sn->sn_Font.ta_Name = &sn->sn_fontname[1];
						sn->sn_ErrorCode     = ss.errorcode;
						sn->sn_SharePens     = ss.sharedpens;
						sn->sn_Draggable     = ss.draggable;
						sn->sn_Exclusive     = ss.exclusive;
						sn->sn_Interleaved   = ss.interleaved;
						sn->sn_LikeWorkbench = ss.likeworkbench;
						
						CopyMem(&ss.penarray[0],&sn->sn_PenArray[0],62);
						
						if (ss.sizecolorarray > 0)
							{
#ifdef DEBUG
	FPuts(pwn->debug, "allocating screen colors \n");
#endif
							sn->sn_ColorArray = (UWORD *)AllocVec( ss.sizecolorarray, MEMF_CLEAR);
							if (sn->sn_ColorArray == NULL)
								result = 4;
							else
								{
								sn->sn_SizeColorArray = ss.sizecolorarray;
								pwn->MemCount += 1;
								}
#ifdef DEBUG
	FPuts(pwn->debug, "allocated screen colors \n");
#endif
							}
						
#ifdef DEBUG
	FPuts(pwn->debug, "screen tags \n");
#endif

						
						tagpos = 0;
						
						sn->sn_TagList = &sn->sn_ActualTagList[0];
						
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Left;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Left;
						tagpos +=1;
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Top;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Top;
						tagpos +=1;
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Width;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Width;
						tagpos +=1;
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Height;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Height;
						tagpos +=1;
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Depth;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Depth;
						tagpos +=1;
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Overscan;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_OverScan;
						tagpos +=1;
						switch (sn->sn_FontType)
							{
							case 0 :
								sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Font;
								sn->sn_ActualTagList[tagpos].ti_Data = (ULONG)&sn->sn_Font;
								tagpos +=1;
								break;
							case 1 :
								sn->sn_ActualTagList[tagpos].ti_Tag  = SA_SysFont;
								sn->sn_ActualTagList[tagpos].ti_Data = 0;
								tagpos +=1;
								break;
							case 2 :
								sn->sn_ActualTagList[tagpos].ti_Tag  = SA_SysFont;
								sn->sn_ActualTagList[tagpos].ti_Data = 1;
								tagpos +=1;
								break;
							}
						if (sn->sn_Behind)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Behind;
							sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Behind;
							tagpos +=1;
							}
						if (sn->sn_Quiet)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Quiet;
							sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_Quiet;
							tagpos +=1;
							}
						if (sn->sn_ShowTitle == 0)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_ShowTitle;
							sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_ShowTitle;
							tagpos +=1;
							}
						if (sn->sn_AutoScroll)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_AutoScroll;
							sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_AutoScroll;
							tagpos +=1;
							}
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_DisplayID;
						sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_DisplayID;
						tagpos +=1;
						if (sn->sn_FullPalette)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_FullPalette;
							sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_FullPalette;
							tagpos +=1;
							}
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Title;
						sn->sn_ActualTagList[tagpos].ti_Data = (ULONG)sn->sn_Title;
						tagpos +=1;
						
						if (strlen(sn->sn_PubScreenName) > 0)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_PubName;
							sn->sn_ActualTagList[tagpos].ti_Data = (ULONG)sn->sn_PubScreenName;
							tagpos +=1;
							}
						else
							if (sn->sn_ScreenType == 1)
								{
								sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Type;
								sn->sn_ActualTagList[tagpos].ti_Data = PUBLICSCREEN;
								tagpos +=1;
								}
						sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Pens;
						sn->sn_ActualTagList[tagpos].ti_Data = (ULONG)&sn->sn_PenArray[0];
						tagpos +=1;
						if (sn->sn_DefaultPens)
							sn->sn_PenArray[0] = 65535;
						
						if (sn->sn_ColorArray != NULL)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Colors;
#ifdef DEBUG
	FPuts(pwn->debug, "hmmmm 2 \n");
#endif
							sn->sn_ActualTagList[tagpos].ti_Data = sn->sn_ColorArray;
							tagpos +=1;
#ifdef DEBUG
	FPuts(pwn->debug, "hmmmm 1 \n");
#endif
							}
						if (sn->sn_ErrorCode)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_ErrorCode;
							tagpos +=1;
							}
						if (sn->sn_Draggable == 0)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Draggable;
							tagpos +=1;
							}
						if (sn->sn_Exclusive)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Exclusive;
							sn->sn_ActualTagList[tagpos].ti_Tag  = 1;
							tagpos +=1;
							}
						if (sn->sn_SharePens)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_SharePens;
							sn->sn_ActualTagList[tagpos].ti_Tag  = 1;
							tagpos +=1;
							}
						if (sn->sn_Interleaved)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_Interleaved;
							sn->sn_ActualTagList[tagpos].ti_Tag  = 1;
							tagpos +=1;
							}
						if (sn->sn_LikeWorkbench)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_LikeWorkbench;
							sn->sn_ActualTagList[tagpos].ti_Tag  = 1;
							tagpos +=1;
							}
						if (sn->sn_Bitmap)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_BitMap;
							sn->sn_ActualTagList[tagpos].ti_Tag  = sn->sn_CreateBitmap;
							tagpos +=1;
							}
						if (sn->sn_DoPubSig)
							{
							sn->sn_ActualTagList[tagpos].ti_Tag  = SA_PubSig;
							tagpos +=1;
							}
						}
					else
						result = 5;
					}
								
				}
			}
		}
	else
		return 4;
	
#ifdef DEBUG
	FPuts(pwn->debug, "Loaded screen \n");
#endif
	
	return result;
 }

void FreeScreenNode(struct ProducerNode *pwn,struct ScreenNode *sn)
{
	if (sn)
		{
		if (sn->sn_ColorArray)
			{
			pwn->MemCount -= 1;
			FreeVec(sn->sn_ColorArray);
			}
		FreeVec(sn);
		pwn->MemCount -= 1;
		}
}