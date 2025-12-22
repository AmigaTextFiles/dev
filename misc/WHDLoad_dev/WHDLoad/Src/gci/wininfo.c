/*************************************************************************
;  :Module.	wininfo.c
;  :Author.	Bert Jahn
;  :Address.	Franz-Liszt-Straﬂe 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: wininfo.c 1.7 2004/06/14 19:09:57 wepl Exp wepl $
;  :History.	22.03.00 created
;  :Copyright.	All Rights Reserved
;  :Language.	C
;  :Translator.	GCC
*************************************************************************/

#include <stdio.h>

#include <libraries/mui.h>

#include <clib/alib_protos.h>
#include <clib/muimaster_protos.h>

#include "WHDLoadGCI.h"
#include "whddump.h"

/************************************************************************/
/* defines								*/
/************************************************************************/

/************************************************************************/
/* extern variables							*/
/************************************************************************/

/************************************************************************/
/* static variables							*/
/************************************************************************/

APTR win_info = NULL;

/************************************************************************/
/* function declarations						*/
/************************************************************************/

/************************************************************************/

void make_win_info(void) {
	ULONG open;
	char buf[1024];

	if (win_info) {
		get(win_info,MUIA_Window_Open,&open);
		if (open)	set(win_info,MUIA_Window_Open,FALSE);
		else		set(win_info,MUIA_Window_Open,TRUE);
	} else {

	sprintf(buf,
		"BaseMemSize = $%lx = %ld\n"
		"ShadowMem = $%lx\n"
		"TermReason = $%lx = %ld\n"
		"TermPrimary = $%lx = %ld\n"
		"TermSecondary = $%lx = %ld\n"
		"TermString = \"%s\"\n"
		"LastBlitPC = $%lx\n"
		"ExpMemLog = $%lx\n"
		"ExpMemPhy = $%lx\n"
		"ExpMemLen = $%lx = %ld\n"
		"ResLoadLog = $%lx\n"
		"ResLoadPhy = $%lx\n"
		"ResLoadLen = $%lx = %ld\n"
		"SlaveLog = $%lx\n"
		"SlavePhy = $%lx\n"
		"SlaveLen = $%lx = %ld\n"
		"SlaveName = \"%s\"\n"
		"kn = %ld\n"
		"rw = $%lx\n"
		"cs = $%x\n"
		"CPU = $%x\n"
		"WVer = %d\n"
		"WRev = %d\n"
		"WBuild = %d\n"
		"fc = %d\n"
		"zpt = %d"
		,header->wdh_BaseMemSize,header->wdh_BaseMemSize
		,header->wdh_ShadowMem
		,header->wdh_TermReason,header->wdh_TermReason
		,header->wdh_TermPrimary,header->wdh_TermPrimary
		,header->wdh_TermSecondary,header->wdh_TermSecondary
		,header->wdh_TermString
		,header->wdh_LastBlitPC
		,header->wdh_ExpMemLog
		,header->wdh_ExpMemPhy
		,header->wdh_ExpMemLen,header->wdh_ExpMemLen
		,header->wdh_ResLoadLog
		,header->wdh_ResLoadPhy
		,header->wdh_ResLoadLen,header->wdh_ResLoadLen
		,header->wdh_SlaveLog
		,header->wdh_SlavePhy
		,header->wdh_SlaveLen,header->wdh_SlaveLen
		,header->wdh_SlaveName
		,header->wdh_kn
		,header->wdh_rw
		,header->wdh_cs
		,header->wdh_CPU
		,header->wdh_WVer
		,header->wdh_WRev
		,header->wdh_WBuild
		,header->wdh_fc
		,header->wdh_zpt
		);

		win_info = WindowObject,
			MUIA_Window_Title, "WHDLoad Info",
			MUIA_Window_ID   , MAKE_ID('I','N','F','O'),
			WindowContents,
				TextObject, TextFrame, 
					MUIA_Background, MUII_TextBack,
					MUIA_Text_Contents, buf,
					End,
			End;
		if (win_info) {
			DoMethod(app,OM_ADDMEMBER,win_info);
			DoMethod(win_info,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MAIN_MOREINFO);
			set(win_info,MUIA_Window_Open,TRUE);
		} else {
			MUI_Request(app,win,0,NULL,"Ok","Couldn't open Info window.");
		}
	}
}

/************************************************************************/

