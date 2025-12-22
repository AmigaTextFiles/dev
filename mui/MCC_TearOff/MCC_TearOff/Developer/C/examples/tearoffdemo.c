/*
    Demo of the new TearOff MUI classes
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

#include <mui/tearoffpanel_mcc.h>
#include <mui/tearoffbay_mcc.h>

#define PROGNAME "Second TearOff Demo"

#define LIST(ftxt)   ListviewObject, MUIA_Listview_Input, FALSE, MUIA_Listview_List,\
                     FloattextObject, MUIA_Frame, MUIV_Frame_ReadList, MUIA_Background, MUII_ReadListBack, MUIA_Floattext_Text, ftxt, MUIA_Floattext_TabSize, 4, End, End

#define ESC "\033"

char *sometext="\n" MUIX_C MUIX_PH "Welcome to the Second TearOff demo!\n"
MUIX_PT MUIX_L "\n"
"This program is a brief introduction to the new MCC classes "
"for easy toolbar-like window and group management.\n"
"Look at the example toolbars in this application! "
"They are placed in " MUIX_PH "TearOffPanels" MUIX_PT ".\n"
"This means user can "
"move them with a mouse, rearrange and even drag out the window! "
"This version adds extra features to TearOff system:\n"
" - you can define the frames and images used by TearOff panels "
"(standard installation includes example settings for Netscape-like and Microsoft-like configuration!)\n"
" - the panels can be horizontal or vertical\n"
" - you can drag the panel to another bay (eg.from the top to the bottom of the window)\n"
"\n"
"If you need help on how to use TearOff Panels, "
"select 'Help' from the panel context menu (right mouse button)\n"
"\n\n"
"Visit the WWW suport page!\n"
"\thttp://friko6.onet.pl/rz/szulat/tearoff/\n\n"
MUIX_I "\tSzymon Ulatowski\n"
"\t<szulat@friko6.onet.pl>\n"
"\n"
;


struct Library *MUIMasterBase;
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}

long __stack=8192;

Object *app,*win,*obj,*ok_but,*ca_but;

long get1(Object *o,ULONG par)
{
ULONG out=0;
GetAttr(par,(void*)o,&out);
return out;
}

Object *txtob(char *txt)
{
return TextObject,
	MUIA_Text_Contents,txt,
	MUIA_Text_SetMin,0,
	MUIA_Text_SetMax,1,
	MUIA_Text_SetVMax,0,
	End;
}

Object *string(char *txt)
{
return StringObject,StringFrame,
	MUIA_String_Contents,txt,
	End;
}

Object *mybutton(char *txt)
{
return TextObject,ButtonFrame,
	MUIA_Text_PreParse,MUIX_C,
	MUIA_Background,MUII_ButtonBack,
	MUIA_InputMode,MUIV_InputMode_RelVerify,
	MUIA_Text_Contents,txt,
	MUIA_Text_SetMin,0,
	MUIA_Text_SetMax,0,
	MUIA_Text_SetVMax,0,
	End;
}

char *findusing[]={"Excite","Yahoo","HotBot","All",0};

////////////////////      MAIN      ///////////////////////

int main(int argc,char *argv[])
{
Object *panel1,*panel2,*panel3,*panel4,*panel5;
Object *cont1,*cont2,*cont3,*cont4,*cont5;
Object *firstbay,*secondbay,*thirdbay,*fourthbay;
ULONG sigs = 0;
long ret=0,running=1;
MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN);
if (!MUIMasterBase) 
	{
	puts("Can't open muimaster.library!");	// what a shame...
	return 21;
	}

cont1=HGroup,
	Child,Label("Navigation"),
	Child,mybutton("\033I[6:31] Back"),
	Child,mybutton("\033I[6:30] Forward"),
	Child,mybutton("\033I[6:17] Reload"),
	Child,mybutton("\033I[6:33] Stop"),
	End;

cont2=HGroup,
	Child,Label("Fastlinks"),
	Child,mybutton("Aminet"),
	Child,mybutton("AWD"),
	Child,mybutton("Amiga.org"),
	End;

cont3=HGroup,
	Child,txtob("Find on WWW"),
	Child,string("Do you believe in life after love? ;-)"),
	Child,txtob("using"),
	Child,MUI_MakeObject(MUIO_Cycle,"?",findusing),
	Child,mybutton("Find!"),
	End;

cont4=HGroup,
	Child,txtob("Location"),
	Child,string("http://friko6.onet.pl/rz/szulat/tearoff/"),
	End;

cont5=HGroup,
	Child,Label("Status:"),
	Child,GaugeObject,GaugeFrame,
		MUIA_Gauge_Current,20,
		MUIA_Gauge_Horiz,1,
		End,
	Child,txtob("Got 66 of 666 images..."),
	End;

app=ApplicationObject,
MUIA_Application_Title      , PROGNAME,
MUIA_Application_Version    , "$VER: " PROGNAME " 1.0 (25.11.98)",
MUIA_Application_Copyright  , "©1998, Szymon Ulatowski",
MUIA_Application_Author     , "Szymon Ulatowski",
MUIA_Application_Description, "Introduction to TearOff MUI classes",
MUIA_Application_Base       , PROGNAME,
SubWindow,win=WindowObject,
	MUIA_Window_Title, PROGNAME,
	MUIA_Window_ID   , 'WIN1',
	WindowContents, VGroup,
		Child,firstbay=TearOffBayObject,
			MUIA_ObjectID,'BAY1',
			Child,panel1=TearOffPanelObject,
				MUIA_ObjectID,'PAN1',
				MUIA_TearOffPanel_Contents,cont1,
				MUIA_TearOffPanel_Label,"Navigation",
				MUIA_TearOffPanel_CanFlipShape,1,
				End,
			Child,panel2=TearOffPanelObject,
				MUIA_ObjectID,'PAN2',
				MUIA_TearOffPanel_Contents,cont2,
				MUIA_TearOffPanel_Label,"Fastlinks",
				MUIA_TearOffPanel_CanFlipShape,1,
				End,
			Child,panel3=TearOffPanelObject,
				MUIA_ObjectID,'PAN3',
				MUIA_TearOffPanel_Contents,cont3,
				MUIA_TearOffPanel_Label,"Find on WWW",
				End,
			Child,panel4=TearOffPanelObject,
				MUIA_ObjectID,'PAN4',
				MUIA_TearOffPanel_Contents,cont4,
				MUIA_TearOffPanel_Label,"Location",
				End,
			Child,panel5=TearOffPanelObject,
				MUIA_ObjectID,'PAN5',
				MUIA_TearOffPanel_Contents,cont5,
				MUIA_TearOffPanel_Label,"Status",
				MUIA_TearOffPanel_CanFlipShape,1,
				End,
			End,
		Child,HGroup,
			Child,thirdbay=TearOffBayObject,
				MUIA_TearOffBay_Horiz,0,
				MUIA_ObjectID,'BAY3',
				End,
			Child,LIST(sometext),
			Child,fourthbay=TearOffBayObject,
				MUIA_TearOffBay_Horiz,0,
				MUIA_ObjectID,'BAY4',
				End,
			End,
		Child,secondbay=TearOffBayObject,
			MUIA_ObjectID,'BAY2',
			End,
		End,
	End,
End;

if (app)
	{
	SetAttrs(firstbay,MUIA_TearOffBay_LinkedBay,secondbay,
		MUIA_TearOffBay_LinkedBay,thirdbay,
		MUIA_TearOffBay_LinkedBay,fourthbay,0);

	DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	DoMethod(panel1,MUIM_Notify,MUIA_TearOffPanel_Horiz,MUIV_EveryTime,
		cont1,3,MUIM_Set,MUIA_Group_Horiz,MUIV_TriggerValue);
	DoMethod(panel2,MUIM_Notify,MUIA_TearOffPanel_Horiz,MUIV_EveryTime,
		cont2,3,MUIM_Set,MUIA_Group_Horiz,MUIV_TriggerValue);
	DoMethod(panel5,MUIM_Notify,MUIA_TearOffPanel_Horiz,MUIV_EveryTime,
		cont5,3,MUIM_Set,MUIA_Group_Horiz,MUIV_TriggerValue);

	DoMethod(app,MUIM_Application_Load,MUIV_Application_Load_ENV);

		SetAttrs(win,MUIA_Window_Open,TRUE,0);	

		while (running)
		{
		switch (DoMethod(app,MUIM_Application_NewInput,&sigs))
				{
				case MUIV_Application_ReturnID_Quit: running=0; break;
				}
		if (sigs) {sigs = Wait(sigs | SIGBREAKF_CTRL_C); if (sigs & SIGBREAKF_CTRL_C) break;}
		}

	DoMethod(app,MUIM_Application_Save,MUIV_Application_Save_ENV);
	DoMethod(app,MUIM_Application_Save,MUIV_Application_Save_ENVARC);

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
