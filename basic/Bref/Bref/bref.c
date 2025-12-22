/* Program bref.c -- this is the main() module for BREF icon version */

/* Set TAB value to 3 for this listing. */

/*		Lib name		Invoke name		Function */

/*		bref.c		main			BREF Window, requesters--OPTION, ERROR */
/*		bref2.c		main2			Cross reference table */
/*		bref3.c		help			On-screen user information */
/*		bref4.c		FileWindow	Select input */

char  Version[] = "V 2.0";

#include <exec/types.h>
#include <intuition/intuition.h>
#include <stdio.h>

			/* Data referenced by main2() -- declared extern in main2() */
int  icon;						/* T = icon invoke, F = CLI invoke */
char *Filename;				/* input file name */
UBYTE out_name[40] = "PRT:";	/* WorkBench invoke default output to printer*/
char Brefhdr[133];			/* Report heading */
int Maxlinwidth = 80;		/* Max char's per line (-W) */
int Maxpaglines = 66;		/* Max lines per page (-L) */
int FormFeed = TRUE;			/* Use form feeds? (-S) */ 
int Quiet = FALSE;			/* Suppress print input file? (-Q) */
int Elite = FALSE;			/* Print input file 12 char/in? (-E) */
int ShowKeyWords = FALSE;	/* Show BASIC keywords in table? (-K) */

struct Window *w;			/* Referenced by help() -- extern in help() */

					/* Declare external functions */
extern USHORT FileWindow();	/* input file selector */
extern void main2();				/* cross ref table function */
extern int  help();				/* display HELP screens */

struct IntuitionBase *IntuitionBase;
char *strchr();

/* #include "FileWindow.h" --  Included code for  FileWindow.h */

/* What file_window() will return: */
#define GO      500
#define OPTIONS 600
#define HELP    700
#define CANCEL  800
#define QUIT    900
#define PANIC1  1001
#define PANIC2  1002

/* The maximum size of the strings: */
#define DRAWER_LENGTH 100 /*  100 char's incl NULL. */
#define FILE_LENGTH    30 /*   30       -"-         */
#define TOTAL_LENGTH  130 /*  130       -"-         */

/* THE END of FileWindow.h */

/*= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/
UBYTE undo_buff[133];			/* Undo buffer for string gadgets */

#define BOXW  80		/* Req1 gadget box width */
#define BOXH  15		/* Req1 gadget box height */

		/* Use boxR1 for all Req1 gadgets */
SHORT boxR1[] = {0,0,  BOXW-1,0,  BOXW-1,BOXH-1,  0,BOXH-1,  0,0};

struct Border borderR1 = {0,0,1,0,JAM1,5,boxR1,NULL};

/*= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/

		/* Req3 -- Str31 gadget output option  structures */

SHORT str31_box[] = {-7,-4,  150,-4,  150,11,  -7,11,  -7,-4};

struct Border str31_border = {0,0,1,0,JAM1,5,str31_box,NULL};

struct IntuiText str31_tex1 = {1,0,JAM1,160,-4,NULL,
		"Output:  PRT: = Printer",NULL,};
struct IntuiText str31_tex2 = {1,0,JAM1,232,5,NULL,
		"Filespec",&str31_tex1,};

struct StringInfo str31_info = {out_name, undo_buff,0,40,0,0,0,0,0,0,
		NULL,NULL,};

struct Gadget str31_gadget =
	{	NULL,10,32,148,8,GADGHCOMP,  GADGIMMEDIATE | RELVERIFY,
		STRGADGET | REQGADGET, &str31_border, NULL,&str31_tex2,
		NULL,&str31_info,0,NULL};

		/* Req3 -- Str32 gadget page width option  structures */

SHORT str32_box[] = {-7,-4,  52,-4,  52,11,  -7,11,  -7,-4};

struct Border str32_border = {0,0,1,0,JAM1,5,str32_box,NULL};

struct IntuiText str32_text = {1,0,JAM1,60,0,NULL,
		"Page width  (27-132)",NULL,};

UBYTE PWbuff[4];
struct StringInfo str32_info = {PWbuff, undo_buff,0,4,0,0,0,0,0,0,
		NULL,NULL,};

struct Gadget str32_gadget =
	{	&str31_gadget,10,68,50,8,GADGHCOMP,  GADGIMMEDIATE | RELVERIFY |
		LONGINT, STRGADGET | REQGADGET, &str32_border, NULL,&str32_text,
		NULL,&str32_info,0,NULL};

		/* Req3 -- Str33 gadget page length option  structures */

SHORT str33_box[] = {-7,-4,  52,-4,  52,11,  -7,11,  -7,-4};

struct Border str33_border = {0,0,1,0,JAM1,5,str33_box,NULL};

struct IntuiText str33_text = {1,0,JAM1,60,0,NULL,
		"Page length  (4-999)",NULL,};

UBYTE PLbuff[4];
struct StringInfo str33_info = {PLbuff, undo_buff,0,4,0,0,0,0,0,0,
		NULL,NULL,};

struct Gadget str33_gadget =
	{	&str32_gadget,10,86,50,8,GADGHCOMP,  GADGIMMEDIATE | RELVERIFY |
		LONGINT, STRGADGET | REQGADGET, &str33_border, NULL,&str33_text,
		NULL,&str33_info,0,NULL};

		/* Req3 -- Str34 gadget output option  structures */

SHORT str34_box[] = {-7,-4,  150,-4,  150,11,  -7,11,  -7,-4};

struct Border str34_border = {0,0,1,0,JAM1,5,str34_box,NULL};

struct IntuiText str34_tex = {1,0,JAM1,160,0,NULL,
		"Report heading, if not filename",NULL,};

struct StringInfo str34_info = {Brefhdr, undo_buff,0,133,0,0,0,0,0,0,
		NULL,NULL,};

struct Gadget str34_gadget =
	{	&str33_gadget,10,50,148,8,GADGHCOMP,  GADGIMMEDIATE | RELVERIFY,
		STRGADGET | REQGADGET, &str34_border, NULL,&str34_tex,
		NULL,&str34_info,0,NULL};

		/* Req3 -- Tog31 "FormFeed?" gadget structures */

SHORT tog31_box[] = {0,0,  15,0,  15,10,  0,10,  0,0};

struct Border tog31_border = {0,0,1,0,JAM1,5,tog31_box,NULL};

UBYTE tog31_char = 'Y';
struct IntuiText tog31_tex1 = {1,0,JAM1,4,2,NULL,&tog31_char,NULL};
struct IntuiText tog31_tex2 = {1,0,JAM1,24,2,NULL,"Form Feeds",&tog31_tex1};

struct Gadget tog31_gadget = {&str34_gadget,14,120,16,11,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET | REQGADGET,
		&tog31_border,NULL,&tog31_tex2,NULL,NULL,0,NULL};

		/* Req3 -- tog32 "Print Input?" gadget structures */

SHORT tog32_box[] = {0,0,  15,0,  15,10,  0,10,  0,0};

struct Border tog32_border = {0,0,1,0,JAM1,5,tog32_box,NULL};

char tog32_char = 'Y';
struct IntuiText tog32_tex1 = {1,0,JAM1,4,2,NULL,&tog32_char,NULL};
struct IntuiText tog32_tex2 = {1,0,JAM1,24,2,NULL,
		"Print input file",&tog32_tex1};

struct Gadget tog32_gadget = {&tog31_gadget,14,136,16,11,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET | REQGADGET,
		&tog32_border,NULL,&tog32_tex2,NULL,NULL,0,NULL};

		/* Req3 -- tog33 "Input print pitch" gadget structures */

SHORT tog33_box[] = {0,0,  23,0,  23,10,  0,10,  0,0};

struct Border tog33_border = {0,0,1,0,JAM1,5,tog33_box,NULL};

char tog33_char[] = "10";
struct IntuiText tog33_tex1 = {1,0,JAM1,4,2,NULL,tog33_char,NULL};
struct IntuiText tog33_tex2 = {1,0,JAM1,34,2,NULL,
		"Print Pitch (10/12 cpi)",&tog33_tex1};

struct Gadget tog33_gadget = {&tog32_gadget,14,152,24,11,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET | REQGADGET,
		&tog33_border,NULL,&tog33_tex2,NULL,NULL,0,NULL};

		/* Req3 -- tog34 "Show Keywords?" gadget structures */

SHORT tog34_box[] = {0,0,  15,0,  15,10,  0,10,  0,0};

struct Border tog34_border = {0,0,1,0,JAM1,5,tog34_box,NULL};

char tog34_char = 'N';
struct IntuiText tog34_tex1 = {1,0,JAM1,4,2,NULL,&tog34_char,NULL};
struct IntuiText tog34_tex2 = {1,0,JAM1,24,2,NULL,
		"Show BASIC keywords",&tog34_tex1};

struct Gadget tog34_gadget = {&tog33_gadget,14,168,16,11,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY, BOOLGADGET | REQGADGET,
		&tog34_border,NULL,&tog34_tex2,NULL,NULL,0,NULL};

		/* Req3 -- HELP3 gadget structures */

struct IntuiText help3_text = {3,0,JAM1,20,4,NULL,"HELP",NULL};

struct Gadget help3_gadget = {&tog34_gadget,380,10,BOXW,BOXH,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY | ENDGADGET, BOOLGADGET | REQGADGET,
		&borderR1,NULL,&help3_text,NULL,NULL,0,NULL};

		/* Req3 -- Save3 gadget structures */

struct IntuiText save3_text = {3,0,JAM1,20,4,NULL,"SAVE",NULL};

struct Gadget save3_gadget = {&help3_gadget,380,136,BOXW,BOXH,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY | ENDGADGET, BOOLGADGET | REQGADGET,
		&borderR1,NULL,&save3_text,NULL,NULL,0,NULL};

		/* Req3 -- OK3 gadget structures */

struct IntuiText ok3_text = {3,0,JAM1,25,4,NULL,"OK",NULL};

struct Gadget ok3_gadget = {&save3_gadget,380,160,BOXW,BOXH,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY | ENDGADGET, BOOLGADGET | REQGADGET,
		&borderR1,NULL,&ok3_text,NULL,NULL,0,NULL};

		/* Requester #3 structures -- Options*/

SHORT req3_box[] = {0,0,  499,0,  499,184,  0,184,  0,0};

struct Border req3_border = {0,0,1,0,JAM1,5,req3_box,NULL,};

struct IntuiText req3_tex1 = {3,0,JAM1,130,4,NULL,
		"BREF Options",NULL,};
struct IntuiText req3_tex2 = {2,3,JAM2,30,16,NULL,
		"Click box, type change, RETURN",&req3_tex1,};
struct IntuiText req3_tex3 = {2,3,JAM2,46,108,NULL,
		"Toggle:  Click box to flip",&req3_tex2,};

struct Requester req3 = {NULL,30,10,500,185,0,0,&ok3_gadget,&req3_border,
		&req3_tex3,NULL,2,NULL,NULL,NULL,NULL,NULL};

/*= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =*/

		/* Req2 -- OK gadget structures */

struct IntuiText ok_text = {1,0,JAM1,25,4,NULL,"OK",NULL};

struct Gadget ok_gadget =
	{	NULL,25,40,BOXW,BOXH,GADGHCOMP,
		GADGIMMEDIATE | RELVERIFY | ENDGADGET,
		BOOLGADGET | REQGADGET,
		&borderR1,NULL,&ok_text,NULL,NULL,0,NULL};

		/* Requester #2 structures -- error message */

SHORT req2_box[] = {0,0,  599,0,  599,64,  0,64,  0,0};

struct Border req2_border = {0,0,1,0,JAM1,5,req2_box,NULL,};

char em_buff[75];

struct IntuiText req2_em = {2,3,JAM2,4,26,NULL,&em_buff,NULL};

struct IntuiText req2_text = {2,3,JAM2,14,8,NULL,
		"BREF error:",&req2_em,};

struct Requester req2 =
	{	NULL,10,20,600,65,0,0,&ok_gadget,&req2_border,&req2_text,
		NULL,2,NULL,NULL,NULL,NULL,NULL};

		/* Window declares */

struct NewWindow nw =
	{	0,0,640,200,0,1,
		CLOSEWINDOW | GADGETUP,
		SMART_REFRESH | WINDOWCLOSE | WINDOWDRAG | WINDOWDEPTH |
		WINDOWSIZING | ACTIVATE,
		NULL,NULL,"BREF Window", NULL,NULL,
		140,50,640,200,WBENCHSCREEN};

struct IntuiMessage *msg;
BOOL result;

main(argc,argv)
	int argc;
	char *argv[];
{
struct IntuiText int_text = {
		1,0,JAM2,16,9,NULL,
		NULL,		/* IText */
		NULL};

char *text[] = {
		"Hang in there -- BREF executing . . .",
		"BREF execution completed -- short pause . . .",
		"Completed read file BREF.Option",
		"Completed write file BREF.Option",
		"                                "	/* blanks for erase msg */
	};

 BOOL fin, Req_3, result3 = FALSE, all_done = FALSE, Do_FW;
 ULONG class;
 struct Gadget *address;
 int n, hrc;
 USHORT operation;			/* return code from FileWindow */
 UBYTE file[TOTAL_LENGTH]; /* file name returned from FileWindow */

 if (argc < 2)
	icon = TRUE;
 else
 {	icon = FALSE;			/* CLI mode -- no User Interface requesters */
	main2(argc,argv);
	exit(0);
 }
 Filename = NULL;
 file[0] = '\0';			/* null the FileWindow filename */
 Brefhdr[0] = '\0';		/* null report header */
 strcpy(PLbuff,"66");	/* Initialize Page Line value */
 strcpy(PWbuff,"80");	/* Initialize Page Width value */

 IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library",0);
 if (IntuitionBase == NULL)
	ErrMsg(2,"System error, can't open Intuition.");
		/* Code = 2 signals no close of Window, Intuition */

 w = (struct Window *) OpenWindow(&nw);
 if (w == NULL)
	ErrMsg(1,"System error, can't open Window.");
		/* Code = 1 signals no close Window, close Intuition */

 n = ReadOpt();			/* Read Option file, if available */
 if (n)
 {	Do_FW = TRUE; Req_3 = FALSE; 		/* Set to activate FileWindow */
	int_text.IText = text[2];
	PrintIText(w->RPort,&int_text,0,165);
 }
 else
 { Do_FW = FALSE; Req_3 = TRUE; }	/* Set to activate Option Requester */

 while (!all_done)
 {
	if (Do_FW)
	{
		Do_FW = FALSE;
		operation = FileWindow(file);		/* Invoke FileWindow */
		int_text.IText = text[4];			/* Erase Read file msg */
		PrintIText(w->RPort,&int_text,0,165);

		switch (operation)
		{
			case GO:
				Filename = file;
				fin = TRUE; all_done = TRUE;
				break;
			case OPTIONS:
				Req_3 = TRUE;
				break;
			case HELP:
				hrc = help();		/* display Help screens */
				fin = TRUE;
				if (hrc ==1)
					all_done = TRUE;
				else Do_FW = TRUE;
				break;
			case CANCEL:
			case QUIT:
			case PANIC2:
				fin = TRUE; all_done = TRUE;
				break;
			case PANIC1:
				ErrMsg(0,"System error--can't open window for FileWindow");
			default:
			ErrMsg(0,"FileWindow serious problem, cause unknown. GET HELP.");
		}
	}
	if (Req_3)
	{
		Req_3 = FALSE;
		result3 = Request(&req3,w);
		if (!result3) ErrMsg(0,"System error, can't activate Requester #3");
		fin = FALSE;
	}
	while (!fin)
	{
		Wait(1 << w->UserPort->mp_SigBit);
		while (msg = (struct IntuiMessage *) GetMsg(w->UserPort))
		{
			class = msg->Class;
			address = msg->IAddress;
			ReplyMsg(msg);

			switch(class)
			{
				case GADGETUP:
					if (address == &ok3_gadget)
					{
						fin = TRUE;
						Do_FW = TRUE;		/* Revert to FileWindow */
					}
					else if (address == &help3_gadget)
					{	
						hrc = help();		/* Display Help screens */
						fin = TRUE;
						if (hrc == 1)
							all_done = TRUE;
						else Req_3 = TRUE;
					}
					else if (address == &save3_gadget)
					{	WriteOpt();			/* Write options file */
						int_text.IText = text[3];
						PrintIText(w->RPort,&int_text,0,165);
						fin = TRUE;
						Do_FW = TRUE;		/* Revert to FileWindow */
					}
					else if (address == &str31_gadget)
						;		/* OK, have output name */
					else if (address == &str32_gadget)
					{	n = str32_info.LongInt;
						if (n > 132) n = 132;
						if (n < 27) n = 27;
						Maxlinwidth = n;
					}
					else if (address == &str33_gadget)
					{	n = str33_info.LongInt;
						if (n > 999) n = 999;
						if (n < 4) n = 4;
						Maxpaglines = n;
					}
					else if (address == &str34_gadget)
						;		/* OK, have Report heading */

		/* Next 4 gadgets are Toggles.  In order to change the display char,*/
		/* it is necessary to erase previous char(s), change char(s), */
		/* then redisplay the gadget. */

					else if (address == &tog31_gadget)
					{
						tog31_tex1.FrontPen = 2;	/* Erase prev char */
						RefreshGadgets(&tog31_gadget,w,&req3);
						if (FormFeed == TRUE)
						{	FormFeed = FALSE; tog31_char = 'N';}
						else {FormFeed = TRUE; tog31_char = 'Y';}
						tog31_tex1.FrontPen = 1;	/* Write new char */
						RefreshGadgets(&tog31_gadget,w,&req3);
					}
					else if (address == &tog32_gadget)
					{
						tog32_tex1.FrontPen = 2;	/* Erase prev char */
						RefreshGadgets(&tog32_gadget,w,&req3);
						if (Quiet == FALSE)
						{	Quiet = TRUE; tog32_char = 'N';}
						else {Quiet = FALSE; tog32_char = 'Y';}
						tog32_tex1.FrontPen = 1;	/* Write new char */
						RefreshGadgets(&tog32_gadget,w,&req3);
					}
					else if (address == &tog33_gadget)
					{
						tog33_tex1.FrontPen = 2;	/* Erase prev char */
						RefreshGadgets(&tog33_gadget,w,&req3);
						if (Elite == FALSE)
						{	Elite = TRUE; tog33_char[1] = '2';}
						else {Elite = FALSE; tog33_char[1] = '0';}
						tog33_tex1.FrontPen = 1;	/* Write new char */
						RefreshGadgets(&tog33_gadget,w,&req3);
					}
					else if (address == &tog34_gadget)
					{
						tog34_tex1.FrontPen = 2;	/* Erase prev char */
						RefreshGadgets(&tog34_gadget,w,&req3);
						if (ShowKeyWords == TRUE)
						{	ShowKeyWords = FALSE; tog34_char = 'N';}
						else {ShowKeyWords = TRUE; tog34_char = 'Y';}
						tog34_tex1.FrontPen = 1;	/* Write new char */
						RefreshGadgets(&tog34_gadget,w,&req3);
					}
					break;
			}	/* close switch(class) */
		}		/* close while(msg...) */
	}			/* close while(!fin) */
 }				/* close while (!all_done) */

 if (Filename)
 {
	/* Send "BREF Executing" msg to window */
	int_text.IText = text[0];
	PrintIText(w->RPort,&int_text,0,50);

	main2(argc,argv);

	/* Send "Completed" msg to window */
	int_text.IText = text[1];
	PrintIText(w->RPort,&int_text,0,60);
	Delay(150);		/* Pause for 3 sec's */
 }

 CloseWindow(w);
 CloseLibrary(IntuitionBase);
}			/* close main() */

WriteOpt()				/* Write options to file BREF.Option */
{
FILE *opt;
char MaxLW[5];
char MaxPL[5];
char togs[6];

 opt = fopen("BREF.Option","w");
 if (opt == NULL)
	ErrMsg(0,"Can't open BREF.Option file for write.");

 strcat (out_name,"\n");
 fputs (out_name,opt);			/* Output name */
 *strchr(out_name,'\n') = '\0';	/* Replace newline by null */

 strcat (Brefhdr,"\n");
 fputs (Brefhdr,opt);			/* Report heading */
 *strchr(Brefhdr,'\n') = '\0';	/* Replace newline by null */

 itoa(Maxlinwidth,MaxLW);		/* Convert integer to ASCII */
 fputs (MaxLW,opt);				/* Max line width in char's */

 itoa(Maxpaglines,MaxPL);		/* Convert integer to ASCII */
 fputs (MaxPL,opt);				/* No. lines/page */

 togs[0] = FormFeed + '0';
 togs[1] = Quiet + '0';
 togs[2] = Elite + '0';
 togs[3] = ShowKeyWords + '0';
 togs[4] = '\n';
 togs[5] = '\0';
 fputs (togs,opt);
 fclose(opt);
}

itoa(integ,ascii)		/* Integer to Ascii */
  int integ;			/* 3-digit integer */
  char ascii[];		/* Append 'newline' & null to Ascii */
{
 int i, n;

 n = integ;
 for (i = 2; i > -1; --i)
 {
	if (n > 0) 
	{	ascii[i] = (n % 10) + '0';
		n = n / 10;
	}
	else ascii[i] = ' ';
 }
 ascii[3] = '\n';
 ascii[4] = '\0';
}

ReadOpt()				/* Read file BREF.Option, if available */
{
FILE *opt;
char MaxLW[5];
char MaxPL[5];
char togs[6];

 opt = fopen("BREF.Option","r");
 if (opt == NULL)
	return(FALSE);

 fgets ((char *)out_name,40,opt);	/* Output name */
 *strchr(out_name,'\n') = '\0';		/* Replace newline by null */

 fgets ((char *)Brefhdr,133,opt);	/* Report heading */
 *strchr(Brefhdr,'\n') = '\0';

 fgets ((char *)MaxLW,5,opt);			/* No. char's/line = line width */
 *strchr(MaxLW,'\n') = '\0';
 strcpy(PWbuff,MaxLW);			/* Copy value to display buffer */
 Maxlinwidth = atoi(MaxLW);	/* Convert ASCII to integer */

 fgets ((char *)MaxPL,5,opt);			/* No. lines/page = page length */
 *strchr(MaxPL,'\n') = '\0';
 strcpy(PLbuff,MaxPL);			/* Copy value to display buffer */
 Maxpaglines = atoi(MaxPL);	/* Convert ASCII to integer */

 fgets ((char *)togs,6,opt);		/* 4 toggles */

 if (togs[0] == '0')
 {	FormFeed = FALSE; tog31_char = 'N'; }
 else {FormFeed = TRUE; tog31_char = 'Y'; }

 if (togs[1] == '0')
 {	Quiet = FALSE; tog32_char = 'Y'; }
 else {Quiet = TRUE; tog32_char = 'N'; }

 if (togs[2] == '0')
 {	Elite = FALSE; tog33_char[1] = '0'; }
 else {Elite = TRUE; tog33_char[1] = '2'; }

 if (togs[3] == '0')
 {	ShowKeyWords = FALSE; tog34_char = 'N'; }
 else {ShowKeyWords = TRUE; tog34_char = 'Y'; }

 fclose(opt);
 return(TRUE);
}

			/* ErrMsg -- requester #2 displays error message. */
			/* Called from main(), help(), fatal() in main2 module */
			/* ec: 0 = have Intuition, Window   1 = have Intuition,no window*/
			/*     2 = no Intuition/window */

ErrMsg(ec,ptrn,data1)
	int ec;
	char *ptrn,*data1;
{
 if (ec == 0)			/* For ec = 0, have Window & Intuition */
 {
	sprintf(em_buff,ptrn,data1);	/* sprintf: format msg in em_buff */
	result = Request(&req2,w);
	if (result)
	{
		Wait(1 << w->UserPort->mp_SigBit);
		while (msg = (struct IntuiMessage *) GetMsg(w->UserPort))
			ReplyMsg(msg);				/* Clean out messages & finish up */
	}
	else
	{
		printf("Can't activate requester #2 for error msg.\n");
		printf (ptrn,data1);
	}
 }
 else printf (ptrn,data1);		/* No Window, or no Window/Intuition*/

 if (ec < 1) CloseWindow(w);
 if (ec < 2) CloseLibrary(IntuitionBase);

 exit(10);
}
