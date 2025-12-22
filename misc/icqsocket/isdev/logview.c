/*

 LogView.c

 Shows messages in the ICQSocket message log.

 Usage (from shell): LogView <UIN>

*/


#include <libraries/mui.h>
#include <libraries/gadtools.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>

#include <mui/busy_mcc.h>
#include <MUI/NListview_mcc.h>
#include <MUI/NFloattext_mcc.h>
#include <proto/muimaster.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "icqsocket.h"
#include "icqsocket_pragmas.h"

struct Library *MUIMasterBase;
struct ICQSocketBase *ICQSocketBase;

ICQHandle *ih;

APTR window, dl_close, dl_fwd, dl_list, dl_del, dl_reply;
APTR app;

__asm __saveds ULONG dl_dispfunc(register __a2 char **array, register __a1 ICQMessage *item)
{
	static char tpbfr[32];
	static char uinbfr[32];
	static char txt[32];
	static char date[32];
	static char time[32];
	char *sent;

	if(item) {

		if(item->Instant=55) {
			/* This message is _sent_ by item->UIN */
			array[3]="Sent to";
		} else {
			array[3]="Recieved from";
		}

		switch(item->Type) {
			case MST_TEXT:
				array[0]="Text";
				break;
			case MST_URL:
				array[0]="URL";
				break;
			case MST_AUTHORIZE:
				array[0]="Authorize";
				break;
			case MST_REQAUTH:
				array[0]="Auth. request";
				break;
			case MST_USERADDED:
				array[0]="User added";
				break;
			case MST_CONTACTS:
				array[0]="Contacts";
				break;
			default:
				sprintf(tpbfr, "Unknown: %ld", item->Type);
				array[0]=tpbfr;
		}

		sprintf(date, "%ld-%02ld-%02ld", item->Time.Year, item->Time.Month, item->Time.Day);
		sprintf(time, "%02ld:%02ld", item->Time.Hour, item->Time.Minute);

		array[1]=date;
		array[2]=time;

		//if(item->le_Status=='S') {
		//	sprintf(uinbfr, "\0331%ld", item->UIN);
		//} else {
			sprintf(uinbfr, "\0332%ld", item->UIN);
		//}

		array[4]=uinbfr;

		strncpy(txt, item->Msg, 30);

		txt[28]='.';
		txt[29]='.';
		txt[30]='.';
		txt[31]='\0';

		array[5]=txt;
		
		//printf("Displaying %s\n", txt);
	} else {
		array[0]="Type";
		array[1]="Date";
		array[2]="Time";
		array[3]="Direction";
		array[4]="User";
		array[5]="Message";
	}

	return (ULONG)0;
}

struct Hook dl_disphook = { {NULL, NULL}, (void *)dl_dispfunc, NULL, NULL };

__asm __saveds ULONG dl_consfunc(register __a2 APTR pool, register __a1 ICQMessage *item)
{
	APTR z;

	//printf("item->Size: %ld\n", item->Size);

	z=AllocPooled(pool, item->Size);
	if(z) {
		CopyMem(item, z, item->Size);
	}

	return (ULONG)z;
}

struct Hook dl_conshook = { {NULL, NULL}, (void *)dl_consfunc, NULL, NULL };

__asm __saveds ULONG dl_desfunc(register __a2 APTR pool, register __a1 ICQMessage *item)
{
	FreePooled(pool, item, item->Size);
	return (ULONG)0;
}

struct Hook dl_deshook = { {NULL, NULL}, (void *)dl_desfunc, NULL, NULL };

void ShutdownMUI(APTR app, char *str)
{
	if(app)	MUI_DisposeObject(app);

	if(MUIMasterBase) CloseLibrary(MUIMasterBase);
	
	if(str) {
		puts(str);
		exit(20);
	}
	exit(0);
}

void InitMUI(void)
{
	if(!(MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN)))
		ShutdownMUI(NULL,"Could not open "MUIMASTER_NAME".");
}

BOOL HandleInput(ULONG x)
{
	switch(x)
	{
		case MUIV_Application_ReturnID_Quit:
		//case MEN_QUIT:
			return TRUE;
			break;

	}
	return FALSE;
}

APTR CreateApp(STRPTR title)
{
	ICQMessage *im;
	APTR app;

	app=ApplicationObject,
			MUIA_Application_Title      , "ICQSocket Message Log",
			MUIA_Application_Version    , "$VER:  ICQLog 1.1 (15.10.99)",
			MUIA_Application_Copyright  , "©1999 Henrik Isaksson",
			MUIA_Application_Author     , "Henrik Isaksson",
			MUIA_Application_Description, "Message log viewer for ICQSocket.",
			MUIA_Application_Base       , "ICQLOG",

			SubWindow, window = WindowObject,
				MUIA_Window_Title, title,
				MUIA_Window_ID,		0x00000001,

				WindowContents, VGroup,
					Child, dl_list=NListviewObject,
							MUIA_NListview_NList, NListObject,
								MUIA_NList_DisplayHook, &dl_disphook,
								MUIA_NList_DestructHook, &dl_deshook,
								MUIA_NList_ConstructHook, &dl_conshook,
								MUIA_NList_EntryValueDependent, TRUE,
								MUIA_NList_Format, "BAR,BAR,BAR,BAR,BAR,BAR",
								MUIA_NList_TitleSeparator, TRUE,
								MUIA_NList_Title,	TRUE,
							End,
						End,
					Child, RectangleObject,
						MUIA_Rectangle_HBar,	TRUE,
						MUIA_FixHeight,		8,
						End,
					Child, HGroup,
						/*Child, dl_fwd=SimpleButton("Forward"),
						Child, HSpace(0),
						Child, dl_reply=SimpleButton("Reply"),
						Child, HSpace(0),
						Child, dl_del=SimpleButton("Delete"),*/

						Child, HSpace(0),
						Child, dl_close=SimpleButton("Close"),
						Child, HSpace(0),
						End,
					End,
				End,
		
			End;
	if(app) {
		DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
		set(window, MUIA_Window_Open, TRUE);


		//printf("Opening msg log..\n");

		if(is_OpenMsgLog(ih)) {
			do {
				//printf("Getting logged message..\n");
				im=is_GetLoggedMsg(ih, 0);
				if(im) {
					//printf("msg: %s\n", im->Msg);
					DoMethod(dl_list, MUIM_NList_InsertSingle, im, MUIV_NList_Insert_Bottom);
				}
			} while(im);
			is_CloseMsgLog(ih);
		}
	}
	
	return app;
}

void main(int argc, char *argv[])
{
	APTR app;
	ULONG signals, inp, uin;
	BOOL Quit=FALSE;

	if(argc<2) {
		printf("USAGE: LogView UIN\n");
		exit(0);
	}

	uin=atoi(argv[1]);

	InitMUI();

	//printf("MUI initialised!\n");

	ICQSocketBase=(struct ICQSocketBase *)OpenLibrary("icqsocket.library", 1);
	if(ICQSocketBase) {
		if((ih=is_InitA(uin, NULL))) {
			//printf("ICQSocket initialised\n");
			app=CreateApp(argv[1]);
			if(app) {
				while(!Quit) {
					inp=DoMethod(app,MUIM_Application_Input,&signals);
					Quit=HandleInput(inp);
					if(signals) Wait(signals);
				}
				is_Free(ih);
			}
		}
		CloseLibrary((struct Library *)ICQSocketBase);
	}

	ShutdownMUI(app, NULL);
}
