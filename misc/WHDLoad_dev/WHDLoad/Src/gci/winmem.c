/*************************************************************************
;  :Module.	winmem.c
;  :Author.	Bert Jahn
;  :Address.	Franz-Liszt-Straﬂe 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: winmem.c 1.10 2006/05/07 19:47:22 wepl Exp wepl $
;  :History.	21.03.00 separated from main
;		06.06.04 'Goto Address' fixed, MCC stuff seperated
;		18.04.06 goto_abs added
;  :Copyright.	All Rights Reserved
;  :Language.	C
;  :Translator.	GCC
*************************************************************************/

#include <stdio.h>

#include <exec/execbase.h>
#include <libraries/mui.h>
#include <mui/BetterString_mcc.h>
#include <mui/HexEdit_mcc.h>

#include <clib/alib_protos.h>
#include <clib/muimaster_protos.h>

#include "whddump.h"
#include "WHDLoadGCI.h"
#include "class.h"

/************************************************************************/
/* Compiler Stuff                                                       */
/************************************************************************/

/************************************************************************/
/* defines								*/
/************************************************************************/

#define MAXWINMEM 10	/* amount of possible memory hexdump windows */

/************************************************************************/
/* extern variables							*/
/************************************************************************/

/************************************************************************/
/* static variables							*/
/************************************************************************/

static APTR win_mem[MAXWINMEM];		/* memory hexdump windows */
static APTR gad_hex[MAXWINMEM];		/* hex display gadgets */
       APTR gad_goto_abs[MAXWINMEM];	/* goto gadgets absolut */
       APTR gad_goto_rel[MAXWINMEM];	/* goto gadgets relative */

/************************************************************************/
/* function declarations						*/
/************************************************************************/

/************************************************************************/

void
wmem_make(
	int adr		/* start address (logical) of memory to display */
) {
	int n;
	APTR prop;
	ULONG open;
	APTR low,high;
	ULONG off,cur;
	char *title, infostart[18], infoend[18];
	
	/*
	 *  check if there is a free window left
	 *  if window closed dispose it
	 */
	for (n=0; (n<MAXWINMEM) && win_mem[n]; n++) {
		get(win_mem[n],MUIA_Window_Open,&open);
		if (!open) {
			DoMethod(app,OM_REMMEMBER,win_mem[n]);
			MUI_DisposeObject(win_mem[n]);
			win_mem[n] = NULL;
			break;
		}
	}
	if (n==MAXWINMEM) {
		MUI_Request(app,win,0,NULL,"Ok","Sorry, too many windows already open.");
		return;
	}
	
	/*
	 *  check which memory is requested
	 */
	if (adr < header->wdh_BaseMemSize) {
		title = "Base Memory (Chip)";
		low = mem;
		high = ((UBYTE*)mem) + header->wdh_BaseMemSize - 1;
		off = -(ULONG)mem;
		cur = adr;
	} else if ((adr >= header->wdh_ExpMemLog) && (adr < header->wdh_ExpMemLog + header->wdh_ExpMemLen)) {
		title = "Expansion Memory (Fast)";
		low = emem;
		high = ((UBYTE*)emem) + header->wdh_ExpMemLen - 1;
		off = header->wdh_ExpMemLog - (ULONG)emem;
		cur = adr - header->wdh_ExpMemLog;
	} else if ((adr >= header->wdh_SlaveLog) && (adr < header->wdh_SlaveLog + header->wdh_SlaveLen)) {
		title = "Slave Memory";
		low = slave;
		high = ((UBYTE*)slave) + header->wdh_SlaveLen - 1;
		off = header->wdh_SlaveLog - (ULONG)slave;
		cur = adr - header->wdh_SlaveLog;
	} else {
		MUI_Request(app,win,0,NULL,"Ok","Sorry, address is outside the defined memory.");
		return;
	}
	sprintf(infostart,"Start = $%lx",(ULONG)low+off);
	/*printf("infostart %ld\n",strlen(infostart));*/
	sprintf(infoend,"End = $%lx",(ULONG)high+off);
	/*printf("infoend %ld\n",strlen(infoend));*/

	/*
	 *  create the window
	 */
	win_mem[n] = WindowObject,
		MUIA_Window_Title, title,
		MUIA_Window_ID   , n + MAKE_ID('M','E','M','0'),
		WindowContents, VGroup,
			Child, HGroup,
				Child, TextObject, TextFrame,
					MUIA_Background, MUII_TextBack,
					MUIA_Text_Contents, infostart,
					End,
				Child, TextObject, TextFrame,
					MUIA_Background, MUII_TextBack,
					MUIA_Text_Contents, infoend,
					End,
				Child, Label2("Goto Adr Abs:"),
				Child, gad_goto_abs[n] = BetterStringObject,
					StringFrame,
					MUIA_String_Accept , StringHexAccept,
					MUIA_String_MaxLen , 10,
					MUIA_String_Format , MUIV_String_Format_Right,
					MUIA_ShortHelp, "Goto Address Absolut",
					MUIA_CycleChain, 1,
					End,
				Child, Label2("Goto Adr Rel:"),
				Child, gad_goto_rel[n] = BetterStringObject,
					StringFrame,
					MUIA_String_Accept , StringHexAccept,
					MUIA_String_MaxLen , 10,
					MUIA_String_Format , MUIV_String_Format_Right,
					MUIA_ShortHelp, "Goto Offset Relative",
					MUIA_CycleChain, 1,
					End,
				End,
			Child, HGroup,
				Child, gad_hex[n] = NewObject(GCIHexEdit_Class->mcc_Class,0, VirtualFrame,
					MUIA_HexEdit_LowBound, low,
					MUIA_HexEdit_HighBound, high,
					MUIA_HexEdit_BaseAddressOffset, off,
					MUIA_HexEdit_AddressChars, 0,	/* must be after Low, High and BaseAddressOffset! */
					MUIA_HexEdit_EditMode, TRUE,
					MUIA_HexEdit_SelectMode, MUIV_HexEdit_SelectMode_Byte,
					MUIA_HexEdit_CursorAddress, cur,
					MUIA_CycleChain, 1,
					End,
				Child, prop = ScrollbarObject,
					MUIA_Prop_UseWinBorder, MUIV_Prop_UseWinBorder_Right,
					End,
				End,
			End,
		End;
	if (!win_mem[n]) {
		MUI_Request(app,win,0,NULL,"Ok","Couldn't open window.");
		return;
	}

	/*
	 *  add window to application and open it
	 */
	DoMethod(app,OM_ADDMEMBER,win_mem[n]);
	set(gad_hex[n],MUIA_HexEdit_PropObject,prop);
	DoMethod(win_mem[n],MUIM_Notify,MUIA_Window_CloseRequest,TRUE,win_mem[n],3,MUIM_Set,MUIA_Window_Open,FALSE);
	/* DoMethod(gad_goto[n],MUIM_Notify,MUIA_String_Accept,MUIV_EveryTime,gad_hex[n],3,MUIM_Set,MUIA_GCIHexEdit_CursorAddress,n); doesn't work??? */
	DoMethod(gad_goto_abs[n],MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,gad_hex[n],3,MUIM_Set,MUIA_GCIHexEdit_CursorAddressAbs,n);
	DoMethod(gad_goto_rel[n],MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,gad_hex[n],3,MUIM_Set,MUIA_GCIHexEdit_CursorAddressRel,n);
	/* DoMethod(gad_hex[n],MUIM_Notify,MUIA_HexEdit_CursorAddress,MUIV_EveryTime,gad_goto_abs[n],4,MUIM_SetAsString,MUIA_String_Contents,"$%lx",MUIV_TriggerValue); */
	DoMethod(gad_hex[n],MUIM_Notify,MUIA_HexEdit_CursorAddress,MUIV_EveryTime,gad_goto_rel[n],4,MUIM_SetAsString,MUIA_String_Contents,"$%lx",MUIV_TriggerValue);
	set(win_mem[n],MUIA_Window_Open,TRUE);
	DoMethod(gad_goto_abs[n],MUIM_SetAsString,MUIA_String_Contents,"$%lx",adr);

}

/****************************************************************************/

