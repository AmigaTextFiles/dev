/*

         Readargsgroup.mcc example
         Szymon Ulatowski  szulat@friko6.onet.pl
*/

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <math.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/muimaster.h>
#include <libraries/mui.h>

#include <mui/Readargsgroup_mcc.h>

#define PROGNAME "ReadArgsGUI"

struct Library *MUIMasterBase;
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

long __stack=8192;

char parameters[1000]={0};

Object *app,*win,*obj,*ok_but,*ca_but;

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
long ret=5,running=1;
MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
if (!MUIMasterBase) 
	{
	puts("Can't open muimaster.library!");	// what a shame...
	return 21;
	}

if (argc<2) 
	{
	puts("Arguments are: <TEMPLATE> [<ARG1> <ARG2> ...]");
	return 22;
	}

{int i;
for (i=2;i<argc;i++) {strcat(parameters,argv[i]); strcat(parameters," ");}
}

app=ApplicationObject,
		MUIA_Application_Title      , PROGNAME,
		MUIA_Application_Version    , "$VER: " PROGNAME " 1.01 (23.10.98)",
		MUIA_Application_Copyright  , "©1998, Szymon Ulatowski",
		MUIA_Application_Author     , "Szymon Ulatowski",
		MUIA_Application_Description, "Shows Readargsgroup for a given key",
		MUIA_Application_Base       , PROGNAME,
		SubWindow,win=WindowObject,
			MUIA_Window_Title, PROGNAME,
			MUIA_Window_ID   , 'WIN1',
			WindowContents, VGroup,
				Child,obj=ReadargsgroupObject,
					MUIA_Readargsgroup_Key,argv[1],
					MUIA_Readargsgroup_Args,parameters,
					End,
				Child,HGroup,
					Child,ok_but=KeyButton("OK",'o'),
					Child,HVSpace,
					Child,ca_but=KeyButton("Cancel",'c'),					
					End,
				End,
			End,
		End;

if (app)
	{
		DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
		DoMethod(ca_but,MUIM_Notify,MUIA_Selected,0,
			app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

		DoMethod(ok_but,MUIM_Notify,MUIA_Selected,0,
			app,2,MUIM_Application_ReturnID,100);

		SetAttrs(win,MUIA_Window_Open,TRUE,0);	

		while (running)
		{
		switch (DoMethod(app,MUIM_Application_NewInput,&sigs))
				{
				case MUIV_Application_ReturnID_Quit: running=0; break;
				case 100: ret=0; running=0; break;
				}
		if (sigs) {sigs = Wait(sigs | SIGBREAKF_CTRL_C); if (sigs & SIGBREAKF_CTRL_C) break;}
		}

		if (!ret) puts(get1(obj,MUIA_Readargsgroup_Args));

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
