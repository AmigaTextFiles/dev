#define abs

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <dos/dos.h>
#include <exec/exec.h>
#include <exec/types.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#include <clib/alib_protos.h>
#include <utility/tagitem.h>
#include <dos/dosasl.h>
#include <dos/rdargs.h>
#include <dos/dostags.h>
#include <clib/dos_protos.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <graphics/gfxbase.h>
#include <workbench/workbench.h>
#include <graphics/scale.h>
#include <clib/wb_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <clib/diskfont_protos.h>

#include "producer_protos.h"
#include "producer.h"

struct	ProducerNode *pn = NULL;
UBYTE  *ProjectName;
long	LineCount;  
BPTR	OutputFile = 0;

char * LoadErrors[] =
{
	"No Error",
	"No filename",
	"No file",
	"No IFF Handle",
	"No memory",
	"Read error",
	"File structure error",
	"Not Designer file",
	"File Version Too Small",
	"File Version Too Large"
};

VOID AddEnding( UBYTE *buff, UBYTE *end )
{
    UBYTE       *pos;

    if ( pos = strrchr( buff, '.' ))
        *pos = 0;
    strcat( buff, end );
}

BPTR OpenOutputFile( UBYTE *ending )
{
    UBYTE       Name[512];

    strcpy( &Name[ 0 ], ProjectName );
    AddEnding( &Name[ 0 ], ending );
    return( Open( &Name[ 0 ], MODE_NEWFILE ));
}

ULONG MyFPrintf( BPTR stream, UBYTE *format, ... )
{
    va_list         arguments;
    ULONG           rc;

    va_start( arguments, format );

    rc = VFPrintf( stream, format, arguments );

    va_end( arguments );

    return( rc );
}

/**********************************************************/
/*                                                        */
/*  Print out information about window passed to function */
/*                                                        */
/**********************************************************/

void ProcessWindow(struct WindowNode *wn)
{
	struct SmallImageNode *sin;
	struct BevelBoxNode *bb;
	struct TextNode *tn;
	struct GadgetNode *gn;
	
	MyFPrintf( OutputFile, "\nWindow              :  %s\n",  GetTagData( WA_Title, 0, wn->wn_TagList));
	MyFPrintf( OutputFile, "  WA_Left           :  %ld\n",  GetTagData( WA_Left , 0, wn->wn_TagList));
	MyFPrintf( OutputFile, "  WA_Top            :  %ld\n",  GetTagData( WA_Top  , 0, wn->wn_TagList));
	
	LineCount+=4;
	
	if (TagInArray(WA_Width, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Width          :  %ld\n",  GetTagData( WA_Width, 0, wn->wn_TagList));
		LineCount+=1;
		}
	if (TagInArray(WA_Height, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Height         :  %ld\n",  GetTagData( WA_Height, 0, wn->wn_TagList));
		LineCount+=1;
		}
	if (TagInArray(WA_InnerWidth, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_InnerWidth     :  %ld\n",  GetTagData( WA_InnerWidth, 0, wn->wn_TagList));
		LineCount+=1;
		}
	if (TagInArray(WA_InnerHeight, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_InnerHeight    :  %ld\n",  GetTagData( WA_InnerHeight, 0, wn->wn_TagList));
		LineCount+=1;
		}
	
	MyFPrintf( OutputFile, "  WA_MinWidth       :  %ld\n",  GetTagData( WA_MinWidth  , 0, wn->wn_TagList));
	MyFPrintf( OutputFile, "  WA_MaxWidth       :  %ld\n",  GetTagData( WA_MaxWidth  , 0, wn->wn_TagList));
	MyFPrintf( OutputFile, "  WA_MinHeight      :  %ld\n",  GetTagData( WA_MinHeight , 0, wn->wn_TagList));
	MyFPrintf( OutputFile, "  WA_MaxHeight      :  %ld\n",  GetTagData( WA_MaxHeight , 0, wn->wn_TagList));
	
	
	if (TagInArray(WA_ScreenTitle, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_ScreenTitle    :  %s\n",  GetTagData( WA_ScreenTitle, 0, wn->wn_TagList));
		LineCount+=1;
		}

	if (TagInArray(WA_SizeGadget, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_SizeGadget     :  TRUE\n");
		LineCount+=1;
		if (TagInArray(WA_SizeBRight, (Tag *)wn->wn_TagList))
			{
			MyFPrintf( OutputFile, "  WA_SizeBRight     :  TRUE\n");
			LineCount+=1;
			}
		if (TagInArray(WA_SizeBBottom, (Tag *)wn->wn_TagList))
			{
			MyFPrintf( OutputFile, "  WA_SizeBBottom    :  TRUE\n");
			LineCount+=1;
			}
		}
	if (TagInArray(WA_DragBar, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_DragBar        :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_DepthGadget, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_DepthGadget    :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_CloseGadget, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_CloseGadget    :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_ReportMouse, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_ReportMouse    :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_NoCareRefresh, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_NoCareRefresh  :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Borderless, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Borderless     :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Backdrop, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Backdrop       :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_GimmeZeroZero, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_GimmeZeroZero  :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Activate, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Activate       :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_RMBTrap, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_RMBTrap        :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Dummy+0x030, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Dummy+0x030    :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Dummy+0x032, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Dummy+0x032    :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Dummy+0x037, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Dummy+0x037    :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_SimpleRefresh, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_SimpleRefresh  :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_SmartRefresh, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_SmartRefresh   :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_AutoAdjust, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_AutoAdjust     :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_MenuHelp, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_MenuHelp       :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_Zoom, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_Zoom           :  yep, its here all right.\n");
		LineCount+=1;
		}
	if (TagInArray(WA_MouseQueue, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_MouseQueue     :  %ld\n",GetTagData( WA_MouseQueue  , 0, wn->wn_TagList));
		LineCount+=1;
		}
	if (TagInArray(WA_RptQueue, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  RptQueue          :  %ld\n",GetTagData( WA_RptQueue  , 0, wn->wn_TagList));
		LineCount+=1;
		}
	if (TagInArray(WA_PubScreenFallBack, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_PubScreenFallBack  :  TRUE\n");
		LineCount+=1;
		}
	if (TagInArray(WA_PubScreen, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_PubScreen      :  Have to deal with this one.\n");
		LineCount+=1;
		}
	if (TagInArray(WA_CustomScreen, (Tag *)wn->wn_TagList))
		{
		MyFPrintf( OutputFile, "  WA_CustomScreen   :  Better expect a parameter.\n");
		LineCount+=1;
		}
	MyFPrintf( OutputFile, "  WA_IDCMP          :  %ld\n", GetTagData( WA_IDCMP  , 0, wn->wn_TagList));
	LineCount+=1;
	
	gn = (struct GadgetNode *)wn->wn_GadgetList.mlh_Head;
	while (gn->gn_Succ)
		{
		MyFPrintf( OutputFile, "  Gadget\n");
		MyFPrintf( OutputFile, "    Label           :  %s\n",gn->gn_Label);
		MyFPrintf( OutputFile, "    Title           :  %s\n",gn->gn_Title);
		MyFPrintf( OutputFile, "    Flags           :  %ld\n",gn->gn_Flags);
		MyFPrintf( OutputFile, "    LeftEdge        :  %ld\n",gn->gn_LeftEdge);
		MyFPrintf( OutputFile, "    TopEdge         :  %ld\n",gn->gn_TopEdge);
		MyFPrintf( OutputFile, "    Width           :  %ld\n",gn->gn_Width);
		MyFPrintf( OutputFile, "    Height          :  %ld\n",gn->gn_Height);
		MyFPrintf( OutputFile, "    GadgetID        :  %ld\n",gn->gn_GadgetID);
		MyFPrintf( OutputFile, "    Kind            :  %ld\n",gn->gn_Kind);
		gn = gn->gn_Succ;
		LineCount+=10;
		}
	
	sin = (struct SmallImageNode *)wn->wn_ImageList.mlh_Head;
	while(sin->sin_Succ)
		{
		MyFPrintf( OutputFile, "  Small Image       :  %ld, %ld, %s\n", sin->sin_LeftEdge, sin->sin_TopEdge, sin->sin_Image->in_Label );
		sin = sin->sin_Succ;
		LineCount+=1;
		}
	
	bb = (struct BevelBoxNode *)wn->wn_BevelBoxList.mlh_Head;
	while(bb->bb_Succ)
		{
		MyFPrintf( OutputFile, "  Bevel Box Node    :  %ld, %ld, %ld, %ld, %ld\n", bb->bb_LeftEdge, bb->bb_TopEdge, bb->bb_Width, bb->bb_Height, bb->bb_BevelType );
		bb = bb->bb_Succ;
		LineCount+=1;
		}
	
	tn = (struct TextNode *)wn->wn_TextList.mlh_Head;
	while(tn->tn_Succ)
		{
		MyFPrintf( OutputFile, "  Text Node         :  %ld, %ld, %s\n", tn->tn_LeftEdge, tn->tn_TopEdge, tn->tn_Title);
		MyFPrintf( OutputFile, "                       %ld, %ld, %ld, %ld\n", tn->tn_FrontPen, tn->tn_BackPen, tn->tn_DrawMode, tn->tn_ScreenFont);
		MyFPrintf( OutputFile, "                       %s, %ld, %ld, %ld\n", tn->tn_Font.ta_Name, tn->tn_Font.ta_YSize, tn->tn_Font.ta_Style, tn->tn_Font.ta_Flags);
		LineCount+=3;
		tn = tn->tn_Succ;
		}
}

/**********************************************************/
/*                                                        */
/*  Print out information about screen passed to function */
/*                                                        */
/**********************************************************/

void ProcessScreen(struct ScreenNode *sn)
{
	
	UWORD * pos;
	
	MyFPrintf( OutputFile, "\nScreen         :  %s\n", GetTagData( SA_Title  , 0, sn->sn_TagList));
	
	MyFPrintf( OutputFile, "  Left Edge    :  %ld\n", GetTagData( SA_Left  , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Top Edge     :  %ld\n", GetTagData( SA_Top   , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Width        :  %ld\n", GetTagData( SA_Width , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Height       :  %ld\n", GetTagData( SA_Height, 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Depth        :  %ld\n",  GetTagData( SA_Depth , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  OverScan     :  %ld\n",  GetTagData( SA_Overscan   , 0, sn->sn_TagList));

	MyFPrintf( OutputFile, "  Behind       :  %ld\n",  GetTagData( SA_Behind, 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Quiet        :  %ld\n",  GetTagData( SA_Quiet , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  ShowTitle    :  %ld\n",  GetTagData( SA_Depth , 1, sn->sn_TagList));
	MyFPrintf( OutputFile, "  AutoScroll   :  %ld\n",  GetTagData( SA_AutoScroll , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  DisplayID    :  %lx\n", GetTagData( SA_DisplayID  , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  FullPalette  :  %ld\n",  GetTagData( SA_FullPalette, 0, sn->sn_TagList));
	LineCount+=14;

	
	if (TagInArray(SA_PubName, (Tag *)sn->sn_TagList))
		{
		MyFPrintf( OutputFile, "  PubName      :  %s\n",  GetTagData( SA_PubName, 0, sn->sn_TagList));
		LineCount+=1;
		}
	if (TagInArray(SA_Type, (Tag *)sn->sn_TagList))
		{
		MyFPrintf( OutputFile, "  Type         :  %ld\n",  GetTagData( SA_Type, CUSTOMSCREEN, sn->sn_TagList));
	    LineCount+=1;
	    }
	if (TagInArray(SA_ErrorCode, (Tag *)sn->sn_TagList))
		{
		MyFPrintf( OutputFile, "  ErrorCode    :  Required\n");
		LineCount+=1;
		}
	
	MyFPrintf( OutputFile, "  Draggable    :  %ld\n",  GetTagData( SA_Draggable     , 1, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Exclusive    :  %ld\n",  GetTagData( SA_Exclusive     , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  SharePens    :  %ld\n",  GetTagData( SA_SharePens     , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  Interleaved  :  %ld\n",  GetTagData( SA_Interleaved   , 0, sn->sn_TagList));
	MyFPrintf( OutputFile, "  LikeWorkbench:  %lx\n", GetTagData( SA_LikeWorkbench , 0, sn->sn_TagList));
	LineCount+=5;

	if (TagInArray(SA_BitMap, (Tag *)sn->sn_TagList))
		{
		MyFPrintf( OutputFile, "  BitMap       :  %ld\n",  GetTagData( SA_BitMap    , 0, sn->sn_TagList));
		LineCount+=1;
		}
	if (TagInArray(SA_PubSig, (Tag *)sn->sn_TagList))
		{
		MyFPrintf( OutputFile, "  PubSig       :  %ld\n",  GetTagData( SA_PubSig    , 0, sn->sn_TagList));
		LineCount+=1;
		}
	
/* Handle DriPens */
	
	pos = (UWORD *)GetTagData(SA_Pens, 0, sn->sn_TagList);
	MyFPrintf( OutputFile, "  Pens         :  ");
	while (*pos != -1)
		{
		MyFPrintf( OutputFile, "%ld, ", *pos );
		pos += 1;
		};
	MyFPrintf( OutputFile, "-1\n");
	LineCount+=1;
	
/* Custom Palette Stuff */
	
	pos = (UWORD *)GetTagData( SA_Colors, 0, sn->sn_TagList);
	if (pos)
		{
		MyFPrintf( OutputFile, "  Colors       :  ");
		while( *pos !=65535 )
			{
			MyFPrintf( OutputFile, "%ld, ",*pos);
			pos +=1;
			MyFPrintf( OutputFile, "%ld, ",*pos);
			pos +=1;
			MyFPrintf( OutputFile, "%ld, ",*pos);
			pos +=1;
			MyFPrintf( OutputFile, "%ld,\n                  ",*pos);
			pos +=1;
			LineCount+=1;
			}
		MyFPrintf( OutputFile, "65535, 0, 0, 0,\n");
		LineCount+=1;
		}
}

/*********************************************************/
/*                                                       */
/*  Print out information about image passed to function */
/*                                                       */
/*********************************************************/

void ProcessImage(struct ImageNode *in)
{
	UWORD *pos;
	long count;
	
	MyFPrintf( OutputFile, "\nImage Node       :  %s\n", in->in_Label );
	MyFPrintf( OutputFile, "  Width          :  %ld\n", in->in_Width);
	MyFPrintf( OutputFile, "  Height         :  %ld\n", in->in_Height);
	MyFPrintf( OutputFile, "  Depth          :  %ld\n", in->in_Depth);
	MyFPrintf( OutputFile, "  PlanePick      :  %ld\n", in->in_PlanePick);
	MyFPrintf( OutputFile, "  PlaneOnOff     :  %ld\n", in->in_PlaneOnOff);
	MyFPrintf( OutputFile, "  DataSize       :  %ld\n", in->in_SizeAllocated);
	MyFPrintf( OutputFile, "  MapSize        :  %ld\n", in->in_MapSize);
	MyFPrintf( OutputFile, "  Colour Map     :  ");
	LineCount+=10;
	if (in->in_ColourMap)
		{
		pos = in->in_ColourMap;
		count = in->in_MapSize;
		while(count>0)
			{
			MyFPrintf( OutputFile, "%ld, ",*pos);
			pos += 1;
			count -= 2;
			}
		MyFPrintf( OutputFile, "\n");
		LineCount+=1;
		}
	else
		MyFPrintf( OutputFile, "None \n");
	if (in->in_ImageData)
		{
		pos = in->in_ImageData;
		count = 0;
		LineCount+=1;
		MyFPrintf( OutputFile, "  Image Data     :\n    ");
		while( count < (in->in_SizeAllocated / 2) )
			{
			count += 1;
			MyFPrintf( OutputFile, "%ld, ",*pos);
			if ((count/10)*10 == count)
				{
				MyFPrintf( OutputFile, "\n    ");
				LineCount+=1;
				}
			pos   += 1;
			}
		MyFPrintf( OutputFile, "\n");
		}
}

/********************************************************/
/*                                                      */
/*  Print out information about menu passed to function */
/*                                                      */
/********************************************************/

void ProcessMenu( struct MenuNode * mn)
{
	
	struct MenuTitleNode *mt;
	struct MenuItemNode *mi;
	struct MenuSubItemNode *si;
	
	char state[7] = "      ";
	long loop;
	
	MyFPrintf( OutputFile, "\nMenu Node    :  %s\n", mn->mn_Label );
	
	MyFPrintf( OutputFile, "  Front Pen  :  %ld\n", GetTagData(GTMN_FrontPen,0, mn->mn_TagList) );
	
	MyFPrintf( OutputFile, "  Locale     :  ");
	if (mn->mn_LocaleMenu) MyFPrintf( OutputFile, "Yes\n"); else MyFPrintf( OutputFile, "No\n");
	
	if ( 0 == TagInArray( GTMN_TextAttr, (Tag *)mn->mn_TagList) )
		MyFPrintf( OutputFile, "  Font       :  default\n" );
	else
		MyFPrintf( OutputFile, "  Font       :  %s\n", ((struct TextAttr *)(GetTagData(GTMN_TextAttr,0, mn->mn_TagList)))->ta_Name );
	LineCount+=5;
	
	mt = (struct MenuTitleNode *)mn->mn_MenuList.mlh_Head;
	while(mt->mt_Succ)
		{
		state[0]='-';
		for (loop=1;loop<6;loop++)
			state[loop] = '-';
		if (mt->mt_Disabled)
			state[0] = 'D';
		MyFPrintf( OutputFile, "  Title  :  %s  %s\n", state, mt->mt_Text );
		LineCount+=1;
		mi = (struct MenuItemNode *)mt->mt_ItemList.mlh_Head;
		while(mi->mi_Succ)
			{
			for (loop=0;loop<6;loop++)
				state[loop] = '-';
			if (mi->mi_Disabled)		state[0]='D';
			if (mi->mi_Barlabel)		state[1]='B';
			if (mi->mi_MenuToggle)		state[2]='M';
			if (mi->mi_Checkit)			state[3]='C';
			if (mi->mi_Checked)			state[4]='C';
			if (mi->mi_Graphic)			state[5]='I';
			if (mi->mi_Graphic == NULL)
				MyFPrintf( OutputFile, "   Item  :  %s    %s\n", state, mi->mi_Text );
			else
				MyFPrintf( OutputFile, "   Item  :  %s    %s\n", state, mi->mi_Graphic->in_Label );
			LineCount+=1;
			si = (struct MenuSubItemNode *)mi->mi_SubItemList.mlh_Head;
			while(si->ms_Succ)
				{
				for (loop=0;loop<6;loop++)
					state[loop] = '-';
				if (si->ms_Disabled)		state[0]='D';
				if (si->ms_Barlabel)		state[1]='B';
				if (si->ms_MenuToggle)		state[2]='M';
				if (si->ms_Checkit)			state[3]='C';
				if (si->ms_Checked)			state[4]='C';
				if (si->ms_Graphic)			state[5]='I';
				if (si->ms_Graphic == NULL)
					MyFPrintf( OutputFile, "    Sub  :  %s      %s\n", state, si->ms_Text );
				else
					MyFPrintf( OutputFile, "    Sub  :  %s      %s\n", state, si->ms_Graphic->in_Label );
				LineCount+=1;
				si = si->ms_Succ;
				}
			mi = mi->mi_Succ;
			}
		mt = mt->mt_Succ;
		}
}

/***********************************************************/
/*                                                         */
/*  Print out information about locale and current strings */
/*                                                         */
/***********************************************************/

void PrintLocale(struct ProducerNode *pn)
{
	struct LocaleNode *ln;
	
	/* Print Locale information and current strings */
	
	MyFPrintf( OutputFile, "\nLocale Info:\n");
	MyFPrintf( OutputFile, "  BaseName         :  %s\n",pn->pn_BaseName);
	MyFPrintf( OutputFile, "  GetString        :  %s\n",pn->pn_GetString);
	MyFPrintf( OutputFile, "  BuiltInLanguage  :  %s\n",pn->pn_BuiltInLanguage);
	LineCount += 5;
	
	ln = (struct LocaleNode *)pn->pn_LocaleList.mlh_Head;
	while (ln->ln_Succ)
		{
		MyFPrintf( OutputFile, "    String         :  %s\n",ln->ln_String);
		MyFPrintf( OutputFile, "    Label          :  %s\n",ln->ln_Label);
		MyFPrintf( OutputFile, "    Comment        :  %s\n",ln->ln_Comment);
		LineCount += 3;
		ln = ln->ln_Succ;
		}
}

/********************************************************/
/*                                                      */
/*  Print out information about main program to be made */
/*                                                      */
/********************************************************/

void ProcessMain(struct ProducerNode *pn)
{
	BPTR   MainFile = 0;
	UBYTE  Name[512];
	
	strcpy( &Name[ 0 ], ProjectName );
    AddEnding( &Name[ 0 ], "Main.c" );
	
	if ( pn->pn_CodeOptions[6])
		if ( ProducerWindowWriteMain( pn, &Name[0]))
			{
			if ( ! (MainFile = OpenOutputFile("Main.c")))
				return ;
			
			MyFPrintf( MainFile  , "/* Designer Producer Main Program Source */");
			
			LineCount+=1;
			
			Close(MainFile);
			}
}

/********************************************************/
/*                                                      */
/*  Process each file in turn and create data           */
/*                                                      */
/********************************************************/

int ProcessFile(char * filename)
{
	long   error = 0;
	struct WindowNode * wn;
	struct MenuNode *mn;
	struct ImageNode *in;
	struct ScreenNode *sn;
	long   done = 0;
	long   abort = 0;
	
	/*  Load the file and process the data in it     */
	/*  Updating the linecout regularly and checking */
	/*  for user aborts                              */
	
	ProjectName = filename;
	
	LineCount = 0;
	SetProducerWindowLineNumber( pn, LineCount);
        
	SetProducerWindowFileName(pn,filename);
	SetProducerWindowAction(pn, "Loading");
	
	error = LoadDesignerData(pn, filename);
	if (error==0)
		{
		
		if ( ! (OutputFile = OpenOutputFile(".c")))
			{
    		SetProducerWindowAction(pn, "Could not open output file.");
			Delay(50);
			return 2;
			}
		
		MyFPrintf( OutputFile, "/* Designer Producer Source Code */\n");
		MyFPrintf( OutputFile, "Process File : %s\n",filename);
		LineCount += 2;
		
		wn = pn->pn_WindowList.mlh_Head;
		mn = pn->pn_MenuList.mlh_Head;
		in = pn->pn_ImageList.mlh_Head;
		sn = pn->pn_ScreenList.mlh_Head;
	
		while ((done == 0)&&(abort==0))
			{
			
			if (wn->wn_Succ)
				{
				ProcessWindow(wn);
				wn = wn->wn_Succ;
				}
			else
				if (mn->mn_Succ)
					{
					ProcessMenu(mn);
					mn = mn->mn_Succ;
					}
				else
					if (in->in_Succ)
						{
						ProcessImage(in);
						in = in->in_Succ;
						}
					else
						if (sn->sn_Succ)
							{
							ProcessScreen(sn);
							sn = sn->sn_Succ;
							}
        				else
        					done = 1;
        	
        	abort = ProducerWindowUserAbort(pn);
        	SetProducerWindowLineNumber( pn, LineCount);
        	
        	}
        	
        if (abort == 0)
        	PrintLocale(pn);
		
		SetProducerWindowLineNumber( pn, LineCount);
        
		Close(OutputFile);
    	
    	if (abort == 0)
    		abort = ProducerWindowUserAbort(pn);
        
    	if (abort == 0)
        	ProcessMain(pn);
    	
    	SetProducerWindowLineNumber( pn, LineCount);
        
		FreeDesignerData(pn);
		}
	else
		{
		SetProducerWindowAction(pn, LoadErrors[error]);
		Delay(50);
		}
	return error;
}

/*************************************************/
/*                                               */
/* CLI Startup, finds all files that match each  */
/* parameter and attempts to parse each file.    */
/* Program exits on a load failure.              */
/*                                               */
/*************************************************/


int main(ac, av)
short ac;
char *av[];
{
	short i;
    long error;
    struct AnchorPath *anchorpath;
    BPTR curdir;
    
    pn=(struct ProducerNode *)GetProducer();
    if (pn)
    	{
    	if (OpenProducerWindow(pn,"Demonstration Handler"))
    		{
    		if (ac==1)
    			{
    			SetProducerWindowAction(pn,"No Files");
    			Delay(50);
    			}
    		else
    			{
    			anchorpath = (struct AnchorPath *)AllocVec(sizeof(struct AnchorPath),MEMF_CLEAR);
    			if (anchorpath)
    				{
    				for (i = 1; i<ac; ++i)
    					{
    					error = MatchFirst(av[i],anchorpath);
    					while (error==0)
    						{
    						
    						curdir = CurrentDir(anchorpath->ap_Last->an_Lock);
    						error  = ProcessFile(&anchorpath->ap_Info.fib_FileName[0]);
    						CurrentDir(curdir);
    						
    						if (error==0)
    							error = MatchNext(anchorpath);
    							
    						}
    					
    					MatchEnd(anchorpath);
    					}
    				FreeVec(anchorpath);
    				}
    			}
    		CloseProducerWindow(pn);
    		}
    	FreeProducer(pn);
    	}
    return(0);
}

