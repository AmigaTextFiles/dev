#define MUI_OBSOLETE

#include <exec/types.h>
#include <exec/memory.h>
#define ASM
#define Prototype  extern
#define Local      static

#ifdef __STORM__
#define REG(x)     register __ ## x
#define SAVEDS     __saveds
#define __stkargs
#define __argargs
#else
#ifdef _DCC
#define REG(x)     __ ## x
#define SAVEDS     __geta4
#endif
#endif

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#include <stdio.h>
#include <stdlib.h>
#include <clib/alib_protos.h>
#include <libraries/mui.h>

#ifdef __STORM__
#include <pragma/muimaster_lib.h>
#include <pragma/exec_lib.h>
#include <pragma/utility_lib.h>
#else
#ifdef _DCC
#include <proto/muimaster.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#endif
#endif

#include "mui/pkb_mcc.h"


Local     void fail( APTR, char * );
Local     void init( void );
int main( int, STRPTR * );

int
wbmain(struct WBStartup *wb_startup)
{
	 return (main(0, (STRPTR *)wb_startup));
}

struct Library  *MUIMasterBase   = NULL;

int
main(int argc, STRPTR argv[])
{
	 APTR  app,
		window,
		PianoKeyboard,PKbsmall,
		cx,ch,cq,cr,
		sl,sl1,sl2,sl3,
		slA,slB,
		clow,chigh,
		but1,but2;

	 static char *CY_0[] = {"NORMAL","RANGE","SPECIAL",NULL};
	 static char *CY_1[] = {"HEAD OFF","HEAD TOP","HEAD BOT",NULL};
	 static char *CY_2[] = {"QUIET OFF","QUIET ON",NULL};

	 init();


		  /*------------------------------*/
app = ApplicationObject,
MUIA_Application_Title      , "Keyboard",
MUIA_Application_Version    , "$VER: Keyboard 0.002 (28 Feb 1999)",
MUIA_Application_Copyright  , "© 1999 Calogero Calì",
MUIA_Application_Author     , "Calogero Calì",
MUIA_Application_Description, "Keyboard custom class.",
MUIA_Application_Base       , "Keyboard",
SubWindow, window = WindowObject,
	 MUIA_Window_Title, "Keyboard custom class",
	 MUIA_Window_ID   , MAKE_ID('C','L','S','1'),
	 WindowContents, VGroup,
				Child, ColGroup(2),
					 Child, cq = Cycle(CY_2),
					 Child, cr = SimpleButton("Refresh"),
				End,

				Child, ColGroup(2),
					 Child, ColGroup(2),
						  Child, CLabel("KeyRelease"),  Child,  sl  = TextObject,MUIA_Text_Contents," ",End,
						  Child, CLabel("KeyCurrent"),  Child,  sl1 = TextObject,MUIA_Text_Contents," ",End,
						  Child, CLabel("From"),        Child,  sl2 = TextObject,MUIA_Text_Contents," ",End,
						  Child, CLabel("To"),          Child,  sl3 = TextObject,MUIA_Text_Contents," ",End,
					 End,
					 Child, ColGroup(2),
						  Child, CLabel("Down"),       Child,  slA = Slider(0,131,0),
						  Child, CLabel("Up"),         Child,  slB = Slider(0,131,0),

						  Child, CLabel("Low  note:"),       Child,  clow  = TextObject,MUIA_Text_Contents," ",End,
						  Child, CLabel("High note:"),       Child,  chigh = TextObject,MUIA_Text_Contents," ",End,
					 End,
				End,
				Child, HGroup,
					 GroupFrame,
					 MUIA_Group_HorizSpacing, 2,
					 Child,but1 = SimpleButton("Reset"),
					 Child,but2 = SimpleButton("Range 12~24"),
					 Child,  cx = Cycle(CY_0),
					 Child,  ch = Cycle(CY_1),
				End,

				Child, VGroup,
					 Child, ScrollgroupObject,
						  MUIA_Scrollgroup_FreeVert,FALSE,
						  MUIA_Scrollgroup_Contents, PianoKeyboard = PkbObject,
								VirtualFrame,
								MUIA_Background, MUII_BACKGROUND,
								MUIA_Pkb_Octv_Start, 1,
								MUIA_Pkb_Octv_Range, 11,
								MUIA_Pkb_Octv_Name,TRUE,
								MUIA_Pkb_Octv_Base, -2,
								MUIA_Pkb_ExcludeHigh, 4,
						  End,
					 End,

					 Child, ScrollgroupObject,
						  MUIA_Scrollgroup_FreeVert,FALSE,
						  MUIA_Scrollgroup_Contents, PKbsmall = PkbObject,
								VirtualFrame,
								MUIA_Background, MUII_BACKGROUND,
								MUIA_Pkb_Octv_Start, 1,
								MUIA_Pkb_Octv_Range, 11,
								MUIA_Pkb_Octv_Name,TRUE,
								MUIA_Pkb_Octv_Base, -2,
								MUIA_Pkb_ExcludeHigh, 4,
								MUIA_Pkb_Type, MUIV_Pkb_Type_SMALL,
						  End,
					 End,
				End,

		  End, /* VGroup */
	 End,  /* WindowObject */
End; /* ApplicationObject */
		  /*------------------------------*/


	 if (!app)
		  fail(app,"Failed to create Application.");


	 DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
				 app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);


	 DoMethod(cx,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
				 PianoKeyboard, 3,
				 MUIM_Set, MUIA_Pkb_Mode, MUIV_TriggerValue);
	 DoMethod(cx,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
				 PKbsmall, 3,
				 MUIM_Set, MUIA_Pkb_Mode, MUIV_TriggerValue);

	 DoMethod(ch,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
				 PianoKeyboard, 3,
				 MUIM_Set, MUIA_Pkb_Range_Head, MUIV_TriggerValue);
	 DoMethod(ch,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
				 PKbsmall, 3,
				 MUIM_Set, MUIA_Pkb_Range_Head, MUIV_TriggerValue);

		  /*Quiet */
	 DoMethod(cq,MUIM_Notify,MUIA_Cycle_Active,MUIV_EveryTime,
				 PianoKeyboard,3,
				 MUIM_Set,MUIA_Pkb_Quiet,MUIV_TriggerValue);

		  /*Refresh */
	 DoMethod(cr,MUIM_Notify,MUIA_Pressed, FALSE,
				 PianoKeyboard,1,MUIM_Pkb_Refresh);

		  /*Reset */
	 DoMethod(but1,MUIM_Notify,MUIA_Pressed, FALSE, 
				 PianoKeyboard,1,MUIM_Pkb_Reset);
	 DoMethod(but1,MUIM_Notify,MUIA_Pressed, FALSE, 
				 PKbsmall,1,MUIM_Pkb_Reset);

		  /*Refresh */
	 DoMethod(but2,MUIM_Notify,MUIA_Pressed, FALSE, 
				 PianoKeyboard,3,
				 MUIM_Pkb_Range,24,12);

		  /* Down */
	 DoMethod(slA,MUIM_Notify,MUIA_Numeric_Value, MUIV_EveryTime,
				 PianoKeyboard,3,
				 MUIM_Set,MUIA_Pkb_Key_Press,MUIV_TriggerValue);

		  /* Up */
	 DoMethod(slB,MUIM_Notify,MUIA_Numeric_Value, MUIV_EveryTime,
				 PianoKeyboard,3,
				 MUIM_Set,MUIA_Pkb_Key_Release,MUIV_TriggerValue);
//-------------------------------------------------------------------------------
		  /* KeyRelease*/
	 DoMethod(PianoKeyboard,MUIM_Notify,MUIA_Pkb_Key_Release, MUIV_EveryTime,
				 sl, 4,
				 MUIM_SetAsString,MUIA_Text_Contents,"%ld",MUIV_TriggerValue);

		  /* KeyCurrent */
	 DoMethod(PianoKeyboard,MUIM_Notify,MUIA_Pkb_Current,    MUIV_EveryTime,
				 sl1,4,
				 MUIM_SetAsString,MUIA_Text_Contents,"%ld",MUIV_TriggerValue);

		  /* From */
	 DoMethod(PianoKeyboard,MUIM_Notify,MUIA_Pkb_Range_Start,MUIV_EveryTime,
				 sl2,4,
				 MUIM_SetAsString,MUIA_Text_Contents,"%ld",MUIV_TriggerValue);

		  /* To */
	 DoMethod(PianoKeyboard,MUIM_Notify,MUIA_Pkb_Range_End,  MUIV_EveryTime,
				 sl3,4,
				 MUIM_SetAsString,MUIA_Text_Contents,"%ld",MUIV_TriggerValue);
//-------------------------------------------------------------------------------

	 {
		  ULONG *l;
		  ULONG *h;
		  static char buf[20];

		  get(PianoKeyboard,MUIA_Pkb_Low,&l);
		  sprintf(buf,"%ld",l);
		  set(clow ,MUIA_Text_Contents,buf);

		  get(PianoKeyboard,MUIA_Pkb_High,&h);
		  sprintf(buf,"%ld",h);
		  set(chigh,MUIA_Text_Contents,buf);
	 }

	 set(window,MUIA_Window_Open,TRUE);
	 {
		  ULONG sigs = 0;
		  while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit){
				if (sigs) {
					 sigs = Wait(sigs | SIGBREAKF_CTRL_C);
					 if (sigs & SIGBREAKF_CTRL_C) break; }
		  }
	 }
	 set(window,MUIA_Window_Open,FALSE);


/*
** Shut down...
*/

	 MUI_DisposeObject(app);             /* dispose all objects. */
	 fail(NULL,NULL);                    /* exit, app is already disposed. */

	 return(0);
}

void
init()
{
	 if ( !(MUIMasterBase = OpenLibrary("muimaster.library",17L)) )
		  fail(NULL,"required muimaster.library");

}

void
fail(APTR app,char *str)
{
	 if (app)           MUI_DisposeObject(app);
	 if (str)           puts(str);
	 if (MUIMasterBase) CloseLibrary(MUIMasterBase);

	 exit(0);
}

