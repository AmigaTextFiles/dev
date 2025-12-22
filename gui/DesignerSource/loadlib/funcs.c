/*
 *  FUNCS.C
 */

/*
	load errors:
		
		0 No error
		1 No Filename
		2 No file
		3 No iff handle
		4 No memory
		5 Read error
		6 File structure error
		7 Not Designer File
		8 Version Too Small
		9 Version Too Large
*/

#include <exec/types.h>
#include <exec/ports.h>
#include <exec/semaphores.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <string.h>

#include <exec/lists.h>
#include "defs.h"
#include "producernode.h"
#include <libraries/iffparse.h>
#include <dos/dos.h>
#include <clib/dos_protos.h>
#include <clib/iffparse_protos.h>
#include "producerwindow.c"
#include "designerdefs.h"

/*
 *  library interface
 */

Prototype LibCall int LoadDesignerData(struct ProducerNode *,char *);
Prototype LibCall void FreeDesignerData(struct ProducerNode *);
Prototype LibCall int OpenProducerWindow(struct ProducerNode *, char *);
Prototype LibCall void CloseProducerWindow(struct ProducerNode *);
Prototype LibCall void SetProducerWindowLineNumber(struct ProducerNode *,long);
Prototype LibCall void SetProducerWindowFileName(struct ProducerNode *,char *);
Prototype LibCall void SetProducerWindowAction(struct ProducerNode *,char *);
Prototype LibCall int ProducerWindowUserAbort(struct ProducerNode *);
Prototype LibCall int ProducerWindowWriteMain(struct ProducerNode *,char *);

Prototype LibCall int AddLocaleString(struct ProducerNode *,char *,char *,char *);
Prototype LibCall void FreeLocaleStrings(struct ProducerNode *);
Prototype LibCall int WriteLocaleCT(struct ProducerNode *);
Prototype LibCall int WriteLocaleCD(struct ProducerNode *);

Prototype LibCall struct ProducerNode * GetProducer(void);
Prototype LibCall void FreeProducer(struct ProducerNode *);

#include "loadfile.h"
#include "loadmenu.c"
#include "loadscreen.c"
#include "loadimage.c"
#include "loadlocale.c"
#include "loadwindow.c"
#include "loadcode.c"
#include "windowtags.c"

/*
 *  library local
 */

LibCall int
LoadDesignerData(pwn,filename)
__A0 struct ProducerNode *pwn;
__A1 char *filename;
{
	struct ImageNode *in;
	struct MenuNode * mn;
	struct MenuTitleNode * mt;
	struct MenuItemNode * mi;
	struct MenuSubItemNode *si;
	struct WindowNode * wn;
	struct SmallImageNode *sin;
	struct GadgetNode *gn;
	struct GadgetNode * gn2;
	struct StringNode *sn;
	struct MyTag *mtg;
	struct IFFHandle * IFF;
	long error = 0;
	struct ContextNode *pcn;
	long finished     = 0;
	long result       = 0;
	long designerfile = 0;
	if (filename==NULL)
		return(1);
	
	IFF = (struct IFFHandle *)AllocIFF();
	if (IFF != NULL)
		{
		IFF->iff_Stream = Open ( filename, MODE_OLDFILE);
		if (IFF->iff_Stream != 0)
			{
			InitIFFasDOS(IFF);
			if (0 == OpenIFF( IFF, IFFF_READ))
				{
				while ( ((error == 0) || (error == IFFERR_EOC)) && (finished==0) && (result==0))
					{
					error = ParseIFF( IFF, IFFPARSE_RAWSTEP);
					pcn = CurrentChunk(IFF);
					if (error == IFFERR_EOC )
						if ( (pcn->cn_Type==id_des1) && (pcn->cn_ID==ID_FORM) )
							finished=1;
					
					if (error ==0 )
						{
						
						if ( (pcn->cn_Type==id_des1) && (pcn->cn_ID==ID_FORM) )
							designerfile = 1;
						
						if ( (designerfile == 1) && (pcn->cn_Type==id_pic1) && (pcn->cn_ID==ID_FORM) )
							result = ReadImage( pwn, IFF );
						
						if ( (designerfile == 1) && (pcn->cn_Type==id_menu) && (pcn->cn_ID==ID_FORM) )
							result = ReadMenu( pwn, IFF );
						
						if ( (designerfile == 1) && (pcn->cn_Type==id_scrn) && (pcn->cn_ID==ID_FORM) )
							result = ReadScreen( pwn, IFF );
						
						if ((designerfile == 1) && (pcn->cn_ID==id_loca))
							result = ReadLocale( pwn, IFF );
						
						if ((designerfile == 1) && (pcn->cn_Type==id_wind) && (pcn->cn_ID==ID_FORM) )
							result = ReadWindow( pwn, IFF );
						
						if ((designerfile == 1) && (pcn->cn_ID==id_info))
							result = ReadAllCode( pwn, IFF );
						
						}
					
					}
				CloseIFF(IFF);
				}
			else
				result = 2;
			Close(IFF->iff_Stream);
			}
		else
			result=3;
		FreeIFF(IFF);
		}
	else
		result = 3;
	
	if ((result==0) && (designerfile==0))
		result = 7;
	
	if (result != 0)
		{
		FreeDesignerData(pwn);
#ifdef DEBUG
		FPuts(pwn->debug, "  Load Failed\n");
#endif
		}
	else
		{
#ifdef DEBUG
		FPuts(pwn->debug, "  Sorting out inter pointers\n");
#endif
		
		in = (struct ImageNode *)pwn->ImageList.mlh_Head;
		while(in->in_Succ)
			{
			
						
			/* fix small images */
			
			wn = (struct WindowNode *)pwn->WindowList.mlh_Head;
			while(wn->wn_Succ)
				{
				
				gn = (struct GadgetNode *)wn->wn_GadgetList.mlh_Head;
				while(gn->gn_Succ)
					{
					
					if (gn->gn_Kind == MYBOOL_KIND)
						{
						sn = (struct StringNode *)gn->gn_InfoList.mlh_Head;
						if (sn->sn_Succ)
							{
							if (sn->sn_st[1] != 0)
								if (0 == strcmp( in->in_Label, &sn->sn_st[1] ))
									gn->gn_pointers[0] = in;
							sn = sn->sn_Succ;
							if (sn->sn_Succ)
								{
								if (sn->sn_st[1] != 0)
									if (0 == strcmp( in->in_Label, &sn->sn_st[1] ))
										gn->gn_pointers[1] = in;
								}
							else
								result = 6;
							}
						else
							result = 6;
						}

					if (gn->gn_Kind == 198)
						{
						mtg = (struct MyTag *)gn->gn_InfoList.mlh_Head;
						while(mtg->mt_Succ)
							{
							if ( (mtg->mt_TagType == TagTypeImage) || (mtg->mt_TagType == TagTypeImageData))
								if ( 0 == strcmp( in->in_Label, &mtg->dataname[1] ) )
									mtg->mt_Data = in;
							mtg = mtg->mt_Succ;
							}
						}
					gn = gn->gn_Succ;
					}
				
				sin = (struct SmallImageNode *)wn->wn_ImageList.mlh_Head;
				while (sin->sin_Succ)
					{
					if (sin->sin_Image == NULL)
						{
						if (strcmp( in->in_Label, (char *)&sin->imagename[1] ) == 0 )
							sin->sin_Image = in;
						}
					sin = sin->sin_Succ;
					}
				wn = wn->wn_Succ;
				}
			
			/* Sort out menu images */
			
			mn = (struct MenuNode *)pwn->MenuList.mlh_Head;
			while(mn->mn_Succ)
				{
				
				/* sort out window menu */
				
				wn = (struct WindowNode *)pwn->WindowList.mlh_Head;
				while(wn->wn_Succ)
					{
					if (wn->wn_Menu == NULL)
						if (strcmp( mn->mn_Label,(char *)&wn->wn_MenuTitle[1]) == 0)
							wn->wn_Menu = mn;
					wn = wn->wn_Succ;
					}
				
				mt = (struct MenuTitleNode *)mn->mn_MenuList.mlh_Head;
				while(mt->mt_Succ)
					{
					mi = (struct MenuItemNode *)mt->mt_ItemList.mlh_Head;
					while (mi->mi_Succ)
						{
						if ((mi->mi_graphicname[0] != 0) && (mi->mi_Graphic == NULL))
							{
							if (strcmp((char *)&mi->mi_graphicname[1],(char *)&in->in_titlestr[1]) == 0)
								mi->mi_Graphic = in;
							}
						si = (struct MenuSubItemNode *)mi->mi_SubItemList.mlh_Head;
						while(si->ms_Succ)
							{
							if ((si->ms_graphicname[0] != 0) && (si->ms_Graphic == NULL))
								{
								if (strcmp((char *)&si->ms_graphicname[1],(char *)&in->in_titlestr[1]) == 0)
									si->ms_Graphic = in;
								}
							si = si->ms_Succ;
							}
						mi = mi->mi_Succ;
						}
					mt = mt->mt_Succ;
					}
				mn = mn->mn_Succ;
				}
			
			in = in->in_Succ;
			}
		}
		
	wn = (struct WindowNode *)pwn->WindowList.mlh_Head;
	while(wn->wn_Succ)
		{
		fixwindowtags(pwn,wn);
		gn = (struct GadgetNode *)wn->wn_GadgetList.mlh_Head;
		while(gn->gn_Succ)
			{
			if (result == 0)
				result = fixgadgettags(pwn,gn,wn);
			
			if (wn->wn_CodeOptions[5])
				{
				gn->gn_Font.ta_Name  = &wn->wn_GadgetFontName[1];
				gn->gn_Font.ta_YSize = wn->wn_GadgetFont.ta_YSize;
				gn->gn_Font.ta_Style = wn->wn_GadgetFont.ta_Style;
				gn->gn_Font.ta_Flags = wn->wn_GadgetFont.ta_Flags;
				}
			
			if (gn->gn_Kind == MYOBJECT_KIND)
				{
				mtg = (struct MyTag *)gn->gn_InfoList.mlh_Head;
				while(mtg->mt_Succ)
					{
					if ((mtg->mt_TagType == TagTypeGadget))
						{
						gn2 = (struct GadgetNode *)wn->wn_GadgetList.mlh_Head;
						while(gn2->gn_Succ)
							{
							if (0 == strcmp( &gn2->gn_LabelID[1], &mtg->dataname[1] ))
								mtg->mt_Data = (UBYTE *)gn2;
							gn2 = gn2->gn_Succ;
							}
						}
					mtg = mtg->mt_Succ;
					}
				}
			gn = gn->gn_Succ;
			}
				
		wn = wn->wn_Succ;
		}

	if (result != 0)
		{
		FreeDesignerData(pwn);
#ifdef DEBUG
		FPuts(pwn->debug, "  Load Failed\n");
#endif
		}

#ifdef DEBUG
	FPuts(pwn->debug, "  Load completed.\n");
#endif
	return(result);
}

LibCall void
FreeDesignerData(pwn)
__A0 struct ProducerNode *pwn;
{
	struct ImageNode *in = NULL;
	struct MenuNode *mn  = NULL;
	struct ScreenNode * sn = NULL;
	struct WindowNode * wn = NULL;
#ifdef DEBUG
	FPuts(pwn->debug, "FreeDesignerData:\n");
#endif
	if (pwn==NULL)
		return;
#ifdef DEBUG
	FPuts(pwn->debug, "  Freeing Locale Strings\n");
#endif
	FreeLocaleStrings(pwn);
#ifdef DEBUG
	FPuts(pwn->debug, "  Freeing Images:\n");
#endif
	in = (struct ImageNode *)RemHead((struct List *)&pwn->ImageList);
	while(in)
		{
#ifdef DEBUG
		FPuts(pwn->debug, "    Freeing Image\n");
#endif
		FreeImageNode(pwn,in);
		in = (struct ImageNode *)RemHead((struct List *)&pwn->ImageList);
		}
#ifdef DEBUG
	FPuts(pwn->debug, "  Freeing Menus:\n");
#endif
	mn = (struct MenuNode *)RemHead((struct List *)&pwn->MenuList);
	while(mn)
		{
#ifdef DEBUG
		FPuts(pwn->debug, "    Freeing Menu\n");
#endif
		FreeMenuNode(pwn,mn);
		mn = (struct MenuNode *)RemHead((struct List *)&pwn->MenuList);
		}
#ifdef DEBUG
	FPuts(pwn->debug, "  Freeing Screens:\n");
#endif
	sn = (struct ScreenNode *)RemHead((struct List *)&pwn->ScreenList);
	while(sn)
		{
#ifdef DEBUG
		FPuts(pwn->debug, "    Freeing Screen\n");
#endif
		FreeScreenNode(pwn,sn);
		sn = (struct ScreenNode *)RemHead((struct List *)&pwn->ScreenList);
		}	
#ifdef DEBUG
	FPuts(pwn->debug, "  Freeing Window:\n");
#endif
	wn = (struct WindowNode *)RemHead((struct List *)&pwn->WindowList);
	while(wn)
		{
#ifdef DEBUG
		FPuts(pwn->debug, "    Freeing Window\n");
#endif
		FreeWindowNode(pwn,wn);
		wn = (struct WindowNode *)RemHead((struct List *)&pwn->WindowList);
		}
	
	pwn->BaseName = NULL;
	pwn->GetString = NULL;
	pwn->BuiltInLanguage = NULL;
	pwn->LocaleVersion = 0;
#ifdef DEBUG
		FPuts(pwn->debug, "    Freed Data\n");
#endif

}

LibCall int
OpenProducerWindow(pwn,title)
__A0 struct ProducerNode *pwn;
__A1 char * title;
{
	if (pwn)
		{
#ifdef DEBUG
		FPuts(pwn->debug,"Opening window\n");
#endif
		if (OpenWindowpwnWin(pwn) != 0)
			return 0;
		if (title)
			SetWindowTitles(pwn->Win,title,NULL);
		else
			SetWindowTitles(pwn->Win,"Designer Producer",NULL);
		return 1;
		}
	return 0;
}

LibCall struct ProducerNode *
GetProducer(void)
{
	struct ProducerNode *pwn;
	pwn = AllocVec(sizeof(struct ProducerNode),MEMF_CLEAR);
	if (pwn)
		{
		NewList((struct List *)&pwn->LocaleList);
		NewList((struct List *)&pwn->ImageList);
		NewList((struct List *)&pwn->MenuList);
		NewList((struct List *)&pwn->ScreenList);
		NewList((struct List *)&pwn->WindowList);
#ifdef DEBUG
		pwn->debug = Open( "CON:5/100/450/200/Producer.library Debugging output (C) Ian OConnor 1994/AUTO", MODE_NEWFILE);
#endif
		FreeDesignerData(pwn);
		}
	return pwn;
}

LibCall void
FreeProducer(pwn)
__A0 struct ProducerNode *pwn;
{
	if (pwn)
		{    
		if (pwn->Win)
			CloseWindowpwnWin(pwn);
		FreeDesignerData(pwn);
#ifdef DEBUG
		if (pwn->MemCount != 0)
			FPuts(pwn->debug,"Memory count problem.\n");
		FPuts(pwn->debug,"Closed Window, ending producer, after Delay(100).\n");
		Delay(100);
		if (pwn->debug)
			Close(pwn->debug);
#endif		
		FreeVec(pwn);
		}
}

LibCall void
CloseProducerWindow(pwn)
__A0 struct ProducerNode *pwn;
{
	if (pwn->Win)
		{    
		CloseWindowpwnWin(pwn);
		}
}

LibCall void
SetProducerWindowLineNumber(pwn,num)
__A0 struct ProducerNode *pwn;
__D0 long num;
{
	long tags[] = {GTNM_Number,num,0};
	if (pwn)
		{
		
		if (pwn->Win)
			{
			GT_SetGadgetAttrsA(pwn->WinGadgets[LinesDisplayGad],pwn->Win,
			                   NULL,(struct TagItem *)tags);
			}
		}
}

LibCall void
SetProducerWindowAction(pwn,s)
__A0 struct ProducerNode *pwn;
__A1 char * s;
{
	long tags[] = {GTTX_Text,(long)s,0};
	if (pwn)
		{
		if (pwn->Win)
			{
			GT_SetGadgetAttrsA(pwn->WinGadgets[ActionDisplayGadget],pwn->Win,
			                   NULL,(struct TagItem *)tags);
			}
		}
}


LibCall void
SetProducerWindowFileName(pwn,s)
__A0 struct ProducerNode *pwn;
__A1 char * s;
{
	long tags[] = {GTTX_Text,(long)s,0};
	if (pwn)
		{
		if (pwn->Win)
			{
			GT_SetGadgetAttrsA(pwn->WinGadgets[FileDisplayGadget],pwn->Win,
			                   NULL,(struct TagItem *)tags);
			}
		}
}


LibCall int
ProducerWindowUserAbort(pwn)
__A0 struct ProducerNode *pwn;
{
    long signals;
    struct IntuiMessage *mess;
    struct Gadget * pgsel;
    long class;
    long code;
    long abort = 0;
#ifdef DEBUG
		FPuts(pwn->debug,"Checking user abort.\n");
#endif		
	if (pwn)
		{
		if (pwn->Win)
			{
			signals = SetSignal(0,0);
			if ( signals & ( 1 << pwn->Win->UserPort->mp_SigBit ))
				{
				mess = GT_GetIMsg(pwn->Win->UserPort);
				while(mess)
					{
					pgsel = mess->IAddress;
					code = mess->Code;
					class = mess->Class;
					GT_ReplyIMsg(mess);
					if (class == IDCMP_CLOSEWINDOW)
						abort = 1;
					if (class == IDCMP_GADGETUP)
						if (pgsel->GadgetID == AbortButton)
							abort = 1;
					if (class == IDCMP_VANILLAKEY)
						if ( ((char)code = 'A') || ((char)code = 'a') )
							abort=1;
					mess = GT_GetIMsg(pwn->Win->UserPort);
					}
				}
			}
		}
	return abort;
}

LibCall int
ProducerWindowWriteMain(pwn,filename)
__A0 struct ProducerNode *pwn;
__A1 char * filename;
{
	BPTR l;
	long res;
	struct EasyStruct e = { 20, 0, "Producer Request", "Main File Exists, Overwrite ?", "Yes|All|None|No"};
	
#ifdef DEBUG
	FPuts(pwn->debug,"Checking user abort.\n");
#endif	
	
	if (pwn==NULL)
		return 0;
	
	l = Lock(filename,ACCESS_READ);
	if (l == (BPTR)0)
		return 1;
	else
		{
		UnLock(l);
		
		if (pwn->WriteAllMain == 1)
			return 1;
		if (pwn->WriteNoMain == 1)
			return 0;
		if (pwn->Win)
			SetPointer(pwn->Win, WaitPointer, 16,16,-6,0);
		res = EasyRequestArgs(pwn->Win, &e, NULL, NULL);
		ProducerWindowUserAbort(pwn);
		if (pwn->Win)
			ClearPointer(pwn->Win);
		switch (res)
			{
			case 1:
				return 1;
				break;
			case 2:
				pwn->WriteAllMain=1;
				return 1;
				break;
			case 3:
				pwn->WriteNoMain = 1;
				return 0;
				break;
			}
		}
	return 0;
}


#include "localefuncs.c"