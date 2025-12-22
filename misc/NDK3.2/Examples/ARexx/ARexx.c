;/*
sc ARexx.c LINK LIB lib:reaction.lib
quit
*/

#include <dos/dos.h>
#include <dos/datetime.h>
#include <libraries/gadtools.h>
#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>

#include <classes/arexx.h>
#include <gadgets/layout.h>
#include <classes/window.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <clib/alib_protos.h>

#include <proto/arexx.h>
#include <proto/button.h>
#include <proto/layout.h>
#include <proto/window.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _DCC
#define SAVEDS __geta4
#define ASM
#define REG_A0 __A0
#define REG_A1 __A1
#else
#define SAVEDS __saveds
#define ASM __asm
#define REG_A0 register __a0
#define REG_A1 register __a1
#endif

#ifdef _DCC
extern __stkargs ULONG HookEntry();
#else
extern __stdargs ULONG HookEntry();
#endif

/* Gadget IDs.
 */
#define GAD_QUIT 1

/* ARexx command IDs.
 */
enum { REXX_NAME, REXX_VERSION, REXX_AUTHOR, REXX_SEND, REXX_DATE };


/* Protos for the reply hook and ARexx command functions.
 */
VOID SAVEDS reply_callback(struct Hook *, Object *, struct RexxMsg *);
VOID ASM rexx_Name(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_Version(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_Author(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_Send(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);
VOID ASM rexx_Date(REG_A0 struct ARexxCmd *, REG_A1 struct RexxMsg *);

/* Buffer for the system date.
 */
UBYTE systemDate[32];

/* Our reply hook function.
 */
struct Hook reply_hook;

/* The following commands are valid for this demo.
 */
struct ARexxCmd Commands[] =
{
	{ "NAME",     	REXX_NAME,		rexx_Name,		NULL,		NULL, },
	{ "VERSION",  	REXX_VERSION,	rexx_Version,	NULL,		NULL, },
	{ "AUTHOR",   	REXX_AUTHOR,	rexx_Author,	NULL,		NULL, },
	{ "SEND",   	REXX_SEND,		rexx_Send,		"TEXT/F",	NULL, },
	{ "DATE",     	REXX_DATE,		rexx_Date, 		"SYSTEM/S",	NULL, },
	{ NULL,			NULL,			NULL,			NULL,		NULL, }
};


/* Starting point.
 */
int main(int argc, char *argv[])
{
	Object *arexx_obj;

	if (!ButtonBase) return(20);

	/* Create host object.
	 */
	if (arexx_obj = ARexxObject,
						AREXX_HostName, "AREXXDEMO",
						AREXX_Commands, Commands,
						AREXX_NoSlot, TRUE,
						AREXX_ReplyHook, &reply_hook,
						End)
	{
		Object *win_obj;

		/* Create the window object.
		 */
		if (win_obj = WindowObject,
						WA_Title, "ReAction arexx.class Demo",
						WA_DragBar, TRUE,
						WA_CloseGadget, TRUE,
						WA_DepthGadget, TRUE,
						WINDOW_ParentGroup, LayoutObject,
							LAYOUT_AddChild, ButtonObject,
								GA_Text, "_Quit",
								GA_ID, GAD_QUIT,
								GA_RelVerify, TRUE,
								ButtonEnd,
							LayoutEnd,
						EndWindow)
		{
			struct Window *window;

			/* try to open the window.
			 */
			if (window = (struct Window*) RA_OpenWindow(win_obj))
			{
				ULONG wnsig = 0, rxsig = 0, signal, result, Code;
				BOOL running = TRUE;

				/* Setup the reply callback hook.
				 */
				reply_hook.h_Entry = HookEntry;
				reply_hook.h_SubEntry = (ULONG (*)()) reply_callback;
				reply_hook.h_Data = NULL;

				/* Try to start the macro "Demo.rexx".  Note that the
				 * current directory and REXX: will be searched for this
				 * macro.  Our reply hook will get the results of our
				 * efforts to start this macro.  To be totally robust, we
				 * should have also passed pointers for the various result
				 * variables.
				 */
				DoMethod(arexx_obj, AM_EXECUTE, "Demo.rexx", NULL, NULL, NULL, NULL, NULL);

				/* Obtain wait masks.
				 */
				GetAttr(WINDOW_SigMask, win_obj, &wnsig);
				GetAttr(AREXX_SigMask, arexx_obj, &rxsig);

				/* Event loop...
				 */
				do
				{
					signal = Wait(wnsig | rxsig | SIGBREAKF_CTRL_C);

					/* ARexx event?
					 */
					if (signal & rxsig)
						RA_HandleRexx(arexx_obj);

					/* Window event?
					 */
					if (signal & wnsig)
					{
						while ((result = RA_HandleInput(win_obj, &Code)) != WMHI_LASTMSG)
						{
							switch (result & WMHI_CLASSMASK)
							{
								case WMHI_CLOSEWINDOW:
									running = FALSE;
									break;

								case WMHI_GADGETUP:
									switch(result & WMHI_GADGETMASK)
									{
										case GAD_QUIT:
											running = FALSE;
											break;
									}
									break;

								default:
									break;
							}
						}
					}

					if (signal & SIGBREAKF_CTRL_C)
					{
						running = FALSE;
					}
				}
				while (running);
			}
			else
				puts ("Could not open the window");
			DisposeObject(win_obj);
		}
		else
			puts("Could not create the window object");
		DisposeObject(arexx_obj);
	}
	else
		puts("Could not create the ARexx host.");

	return(0);
}

#ifdef _DCC
int wbmain(struct WBStartup *wbs)
{
	return(main(0, NULL));
}
#endif


/* Note the use of SAVEDS, it is required for the callback
 * ARexx command functions if access the global data such as
 * systemData[] made in the callback.
 */

/* This function gets called whenever we get an ARexx reply.  In this example,
 * we will see a reply come back from the REXX server when it has finished
 * attempting to start the Demo.rexx macro.
 */
VOID SAVEDS reply_callback(struct Hook *hook, Object *o, struct RexxMsg *rxm)
{
	Printf("Args[0]: %s\nResult1: %ld  Result2: %ld\n",
		rxm->rm_Args[0], rxm->rm_Result1, rxm->rm_Result2);
}

/* NAME
 */
VOID SAVEDS ASM rexx_Name(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	/* return the program name.
	 */
	ac->ac_Result = "ARexxTest";
}

/* VERSION
 */
VOID SAVEDS ASM rexx_Version(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	/* return the program version.
	 */
	ac->ac_Result = "1.0";
}

/* AUTHOR
 */
VOID SAVEDS ASM rexx_Author(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	/* return the authors name.
	 */
	ac->ac_Result = "Phantom Development LLC";
}

/* SEND
 */
VOID SAVEDS ASM rexx_Send(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	/* Print some text
	 */
	if (ac->ac_ArgList[0])
		Printf("%s\n", (STRPTR)ac->ac_ArgList[0]);
}

/* DATE
 */
VOID SAVEDS ASM rexx_Date(REG_A0 struct ARexxCmd *ac, REG_A1 struct RexxMsg *rxm)
{
	struct DateTime dt;

	/* SYSTEM switch specified?
	 */
	if (!ac->ac_ArgList[0])
	{
		/* return the compilation date.
		 */
		ac->ac_Result = "11-10-95";
	}
	else
	{
		/* compute system date and store in systemDate buffer
		 */
		DateStamp((struct DateStamp *)&dt);

		dt.dat_Format  = FORMAT_USA;
		dt.dat_Flags   = 0;
		dt.dat_StrDay  = NULL;
		dt.dat_StrDate = systemDate;
		dt.dat_StrTime = NULL;

		DateToStr(&dt);

		/* return system date
		 */
		ac->ac_Result = systemDate;
	}
}

