/*
    Quick demonstration of the CompactWindow class
    Szymon Ulatowski   <szulat@friko6.onet.pl>
*/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <math.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <libraries/mui.h>

#include <mui/compactwindow_mcc.h>

#define PROGNAME "CompactWindow Demo"

struct Library *MUIMasterBase;
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

long __stack=8192;

Object *app,*win,*str;

long get1(Object *o,ULONG par)
{
ULONG out=0;
GetAttr(par,(void*)o,&out);
return out;
}


////////////////////      MAIN      ///////////////////////

int main(int argc,char *argv[])
{
ULONG sigs = 0;
long ret=0,running=1;
MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
if (!MUIMasterBase) 
	{
	puts("Can't open muimaster.library!");	// what a shame...
	return 21;
	}

app=ApplicationObject,
MUIA_Application_Title      , PROGNAME,
MUIA_Application_Version    , "$VER: " PROGNAME " 1.02 (10.01.99)",
MUIA_Application_Copyright  , "©1999, Szymon Ulatowski",
MUIA_Application_Author     , "Szymon Ulatowski",
MUIA_Application_Description, PROGNAME,
MUIA_Application_Base       , PROGNAME,
SubWindow,win=CompactWindowObject,
	MUIA_CompactWindow_Title, PROGNAME,
	MUIA_Window_ID   , 'WIN1',
	MUIA_Group_Horiz,0,
	MUIA_CompactWindow_Contents, VGroup,
		Child,TextObject,
			TextFrame,
			MUIA_Background,MUII_TextBack,
			MUIA_Text_Contents,"\033cHold me, drag me\nsize me, kiss me!",
			MUIA_Text_SetMax,0,
			MUIA_Text_SetMin,0,
			MUIA_Text_SetVMax,0,
			MUIA_ShortHelp,
					"In case you don't know:\n"
					"this window has\n"
					"a close gadget",
			End,
		Child,str=StringObject,
			StringFrame,
			MUIA_String_Contents,"Change me!",
			End,
		End,
	End,
End;

if (app)
	{
		DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

		DoMethod(str,MUIM_Notify,MUIA_String_Contents,MUIV_EveryTime,
			win,3,MUIM_Set,MUIA_CompactWindow_Title,MUIV_TriggerValue);

		SetAttrs(win,MUIA_Window_Open,TRUE,0);	

		while (running)
		{
		switch (DoMethod(app,MUIM_Application_NewInput,&sigs))
				{
				case MUIV_Application_ReturnID_Quit: running=0; break;
				}
		if (sigs) {sigs = Wait(sigs | SIGBREAKF_CTRL_C); if (sigs & SIGBREAKF_CTRL_C) break;}
		}

		MUI_DisposeObject(app);
	}
else 
	{
	puts("MUI can't create application!\n");
	ret=20;
	}

CloseLibrary(MUIMasterBase);
return ret;
}
