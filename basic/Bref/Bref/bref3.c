/* Program bref3.c  help() module, gives on-screen usage instructions  */
/* Set TAB value to 3 for this listing. */
/*		Invoked from bref.c which is main() */

#include "exec/types.h"
#include "intuition/intuition.h"

			/* extern data */

extern struct Window *w;

			/* Back Gadget for HELP screen */

SHORT back_box[] = {0,0,  39,0,  39,10,  0,10,  0,0};

struct Border back_border = {0,0,1,0,JAM1,5,back_box,NULL};

struct IntuiText back_text = {1,0,JAM1,4,2,NULL,"BACK",NULL};

struct Gadget back_gadget = {NULL,50,180,40,11,GADGHCOMP | GADGDISABLED,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET,
		&back_border,NULL,&back_text,NULL,NULL,0,NULL}; 

			/* Next Gadget for HELP screen */

SHORT next_box[] = {0,0,  39,0,  39,10,  0,10,  0,0};

struct Border next_border = {0,0,1,0,JAM1,5,next_box,NULL};

struct IntuiText next_text = {1,0,JAM1,4,2,NULL,"NEXT",NULL};

struct Gadget next_gadget = {&back_gadget,300,180,40,11,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET,
		&next_border,NULL,&next_text,NULL,NULL,0,NULL}; 

			/* OK Gadget for HELP screen */

SHORT ok2_box[] = {0,0,  22,0,  22,10,  0,10,  0,0};

struct Border ok2_border = {0,0,1,0,JAM1,5,ok2_box,NULL};

struct IntuiText ok2_text = {1,0,JAM1,4,2,NULL,"OK",NULL};

struct Gadget ok2_gadget = {&next_gadget,550,180,23,11,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET,
		&ok2_border,NULL,&ok2_text,NULL,NULL,0,NULL}; 

struct IntuiText int_text = { 1,0,JAM2,16,9,NULL,
		NULL,		/* IText */
		NULL};

help()
{
 int i,j,go,smark,sline=0,eline,bline[5],hp=0;
 struct IntuiMessage *msg;
/* BOOL fin, list = TRUE;*/
 BOOL fin, Next = FALSE, Back = FALSE;
 ULONG class;
 struct Gadget *address;
 char *cp[] = {
"                 BREF HELP -- 1/3",
"",
"WHAT DOES BREF DO?     It makes a cross reference table for AmigaBASIC",
"code.  This is a numbered listing of the BASIC code, plus a table showing",
"all variable/label usage.  Highly useful tool for BASIC programmers.",
"",
"RESTRICTION:  The BASIC code must be in ASCII format, not binary.  To save",
"your code in ASCII, use the LIST command in the BASIC output window:",
"    LIST ,\"your.prog.name\"",
"",
"USAGE:   Use the OPTION display to select your settings.  Use FileWindow",
"to select your AmigaBASIC input.  FileWindow starts by showing the current",
"directory--directories/files.  Click on a directory to show its contents.",
"Can change to a different unit (df0:,etc) with a click.  Click on the file",
"you want for input.  Then a click on GO starts BREF execution.",
"",
"You can also click on File or Drawer/File, type your name or path/name,",
"then press RETURN to start execution.",
"",
"ABORT RUN    by click on CloseWindow.",
"zzz",						/* End of page marker */

"               BREF HELP -- 2/3         OPTION",
"",
"Most of the Options are self-explanatory; default values are shown.",
"",
"OUTPUT   Default output goes to the printer (PRT:).  You can change this",
"   by entering an alternate output name, for example--    ram:temp",
"   Then you can use an edit program to look at this.",
"         CLI/SHELL invoke:  can use * for screen output.",
"         Workbench invoke:  no screen output for *",
"",
"PRINT PITCH (10/12 cpi)   \"Pitch\" means how many char's/inch printed.",
"    10 = Pica, 12 = Elite.  If you pick 12, BREF recalculates page width.",
"    Example:  80 --> 96, resulting in fewer printer line overflows.",
"    WARNING:  Your printer may not support pitch = 12.",
"",
"Option SAVE:  After setup of your option values, click on SAVE will write",
"your options to a file.  When you run BREF again, it looks for this file.",
"If found, it restores your saved options, goes directly to FileWindow.",
"If you click on OK of OPTION, it uses the current values, but no save.",
"zzz",						/* End of page marker */

"                    BREF HELP -- 3/3",
"",
"Documentation file \"bref.doc\" contains further information about the",
"BREF program.  Please refer to this for expanded usage details, two minor",
"program limitations, assorted technical details, and program history.",
"",
"If you have found a program bug, or have a program change to suggest,",
"or want to correspond, I'll be glad to hear from you.",
"",
"     Dick Taylor          Tel (203) 633-0100",
"     99 Valley View Rd",
"     Glastonbury CT 06033-3621 USA",
"{{{"};						/* End of text marker */

/* AddGadget(w,&back_gadget,0);
 AddGadget(w,&next_gadget,0);*/
 AddGadget(w,&ok2_gadget,0);
 RefreshGadgets(&ok2_gadget,w,NULL);

 fin = FALSE;
 while (!fin)
 {
	go = TRUE;
	i = sline;		/* start-line */
	j = 0;

	while (go)
	{
			eline = i;
							/* "zzz" is end-of-page marker (smark = 0) */
							/* "{{{" is end-of-text marker (smark < 0) */
			smark = strcmp("zzz",cp[i]);
			if (smark <= 0)
				go = FALSE;
			else
				{ int_text.IText = cp[i];
					PrintIText(w->RPort,&int_text,0,j*8);
				  ++i;  ++j;
				}
	 }				/* on exit while loop, eline contains end-line # */

/*	OnGadget(&ok2_gadget,w,NULL);		/* OK (= exit) is always on */

	if (smark < 0)					/* Last page -- drop Next if in place  */
	{
		if (Next)
		{	RemoveGadget (w,&next_gadget);
			Next = FALSE;
		}
	}
	else if (!Next)		/* Not last page -- add Next if not in place*/
			{	AddGadget (w,&next_gadget,-1);
				Next = TRUE;
			}

	if (hp == 0)					/* First page -- drop Back if in place */
	{
		if (Back)
		{	RemoveGadget (w,&back_gadget);
			Back = FALSE;
		}
	}
	else if (!Back)			/* Not first page -- add Back if not in place*/
			{	AddGadget(w,&back_gadget,-1);
				OnGadget(&back_gadget,w,NULL);
				Back = TRUE;
			}

	RefreshGadgets(&ok2_gadget,w,NULL);

	Wait(1 << w->UserPort->mp_SigBit);
	while (msg = (struct IntuiMessage *) GetMsg(w->UserPort))
	{
		class = msg->Class;
		address = msg->IAddress;
		ReplyMsg(msg);

		switch(class)
		{
			case CLOSEWINDOW:
				Clear_Screen();
				return(1);			/* return 1 = close window */
			case GADGETUP:
				if (address == &ok2_gadget)		/* OK = exit */
				{	Clear_Screen();
					RemoveGadget(w,&back_gadget);
					RemoveGadget(w,&next_gadget);
					RemoveGadget(w,&ok2_gadget);
					fin = TRUE;
				}
				else if (address == &next_gadget)
				{
					Clear_Screen();
					bline[hp++] = sline;		/* save curr start-line for "back" */
					sline = eline + 1;		/* new start-line = end-line + 1 */
				}
				else if (address == &back_gadget)
				{
					Clear_Screen();
					sline = bline[--hp];		/* new start-line from back-line arr*/
				}
				break;
		}	/* end switch(class) */
	}		/* end while (msg ...) */
 }			/* End while (!fin) */
 
 return(0);
}

Clear_Screen()
{
 static int i;
 char *spaces = 
"                                                                           ";

 int_text.IText = spaces;
 for (i = 0; i < 23; ++i)
	PrintIText(w->RPort,&int_text,0,i*8);
}
