/*
	Create Sinus values
	------------------------
	(c)Codex Design Software
	15.9.1994
*/

#include	<string.h>
#include	<stdio.h>
#include	<math.h>

#include	<dos/dos.h>
#include	<proto/dos.h>

// ------------------------------------

#define	PROGNAME		"CSinVals"
#define	PROGVERSION	"V1.00"

#define	ARG_FILE			0
#define	ARG_LABEL		1
#define	ARG_COSLAB		2
#define	ARG_START		3
#define	ARG_COUNT		4
#define	ARG_STEP			5
#define	ARG_MULTI		6
#define	ARG_ADD			7
#define	ARG_CHAR			8
#define	ARG_SHORT		9
#define	ARG_LONGINT		10
#define	ARG_OVERWRITE	11
#define	ARG_ARGCNT		12

#define	DEF_FILE			0
#define	DEF_LABEL		(long)"SinValues"
#define	DEF_COSLAB		0
#define	DEF_START		0
#define	DEF_COUNT		-1
#define	DEF_STEP			1
#define	DEF_MULTI		256
#define	DEF_ADD			0
#define	DEF_CHAR			FALSE
#define	DEF_SHORT		TRUE
#define	DEF_LONGINT		FALSE
#define	DEF_OVERWRITE	FALSE

#define	VALUES_PER_LINE	10

// write mit Fehlerabfrage
#define	WRITESTR(STR)		if( Write(File,STR,Dummy = strlen(STR)) != Dummy ) { PrintFault(IoErr(),"Can't save data: "); goto EndUp; }

// ------------------------------------

static char	Template[]		=	"C-FILE/A,"
										"LABEL/K,"
										"COSLAB/K,"
										"START/K/N,"
										"COUNT/K/N,"
										"STEP/K/N,"
										"MULTI/K/N,"
										"ADD/K/N,"
										"CHAR/S,SHORT/S,LONGINT/S,"
										"OVERWRITE/S",
				ExtHelpTxt[]	=	"\n"
										"Codex Design Software presents:\n"
										" " PROGNAME " " PROGVERSION "\n"
										"\n"
										" This programm creates an ASCII C-Source with Sinus-Values.\n"
										"It is dedicated to those who want very fast Sin() & Cos()\n"
										"calculations.\n"
										"\n"
										"C-FILE   : Target file; only thing you MUST pass !\n"
										"\n"
										"LABEL    : Label for start of sinus values [SinValues].\n"
										"COSLAB   : Label for start of cosinus values [<none>].\n"
										"           Be careful ! This program assumes that two data\n"
										"           fields wrote behind each other will be compiled\n"
										"           behind each other in the final program, too.\n"
										"           If you are not sure, use:\n"
										"           #define CosLab[OFF] SinLab[(90/<STEP>) + OFF] !\n"
										"\n"
										"START    : Start by this angel [0°].\n"
										"COUNT    : Create that many values [360/STEP].\n"
										"STEP     : Difference between two neighboured values [1].\n"
										"\n"
										"MULTI    : Multiply values by this number [256].\n"
										"ADD      : Add this number to values [0].\n"
										"\n"
										"CHAR,SHORT,LONGINT : Type of data [SHORT].\n"
										"\n"
										"OVERWRITE: Supress warning if file exists [FALSE].\n"
										"\n"
										"(c)15.9.1994 by Hans Bühler, Codex Design Software.\n"
										"all rights reserved; free for copying.";

static LONG		TempArray[ARG_ARGCNT]	=	{	DEF_FILE,
															DEF_LABEL,
															DEF_COSLAB,
															0,
															0,
															0,
															0,
															0,
															DEF_CHAR,
															DEF_SHORT,
															DEF_LONGINT,
															DEF_OVERWRITE
														};

static char		*Types[3]	=	{	"char ",
											"short ",
											"long int "
										};

// ------------------------------------

void main(void)
{
	struct RDArgs	*Anchor;
	double			Multi,Add,Buf;
	int				Count,i,k,Start,
						Step,
						CosLabelOff,
						NLCnt,Dummy;
	char				*Type,
						Buffer[20];
	BPTR				File;
	BOOL				Pred;

	// -- parse arguments --

	if(!( Anchor = ReadArgs(Template,TempArray,0) ))
	{
		puts(ExtHelpTxt);
		return;
	}

	Start		=	(TempArray[ARG_START]) ? *((long *)(TempArray[ARG_START])) : DEF_START;
	Count		=	(TempArray[ARG_COUNT]) ? *((long *)(TempArray[ARG_COUNT])) : DEF_COUNT;
	Step		=	(TempArray[ARG_STEP] ) ? *((long *)(TempArray[ARG_STEP]))  : DEF_STEP;
	Multi		=	(TempArray[ARG_MULTI]) ? *((long *)(TempArray[ARG_MULTI])) : DEF_MULTI;
	Add		=	(TempArray[ARG_ADD]  ) ? *((long *)(TempArray[ARG_ADD]))   : DEF_ADD;

	if(!Step || !Multi || !Count)
	{
		puts("ERROR: Invalid parameters (STEP,MULTI,COUNT == 0) !");
		goto EndUp;
	}

	if(Count == -1)
		Count	=	360 / Step;

	if(TempArray[ARG_CHAR])
		Type	=	Types[0];
	else
		if(TempArray[ARG_LONGINT])
			Type	=	Types[2];
		else
			Type	=	Types[1];

	if(TempArray[ARG_COSLAB])
	{
		if(90 % Step)
		{
			printf(	"NOTE: Can't create Cosinus-Label '%s' since dividing\n"
						"      90° by Step=%ld is difficult for integers.\n"
						"      Label won't be set !\n",TempArray[ARG_COSLAB],Step);
			CosLabelOff	=	Count;	// disable for(;;)
		}
		else
		{
			CosLabelOff	=	90 / Step;
			Count			+=	CosLabelOff;		// make that more !
		}
	}
	else
		CosLabelOff	=	Count;		// disable for(;;)

	// -- open file & write header --

	printf("Opening '%s'.... ",TempArray[ARG_FILE]);

	if(!TempArray[ARG_OVERWRITE])
		if(File = Open((char *)TempArray[ARG_FILE],MODE_OLDFILE))
		{
			Close(File);
			printf("does already exits;\nDelete old file [n]: ");
			scanf("%s",ExtHelpTxt);
			if((ExtHelpTxt[0] | ' ') != 'y')
				goto EndUp;
			printf("Deleting old file... ");
		}

	if(!( File = Open((char *)TempArray[ARG_FILE],MODE_NEWFILE) ))
	{
		PrintFault(IoErr(),PROGNAME " can't open file: ");
		goto EndUp;
	}

	printf("done.\nSaving header... ");

	sprintf(ExtHelpTxt,	"/* %ld SinValues starting by %ld°, step %ld,\n"
								"   multiplied by %ld, added by %ld\n"
								"   ---\n"
								"   Created using " PROGNAME " " PROGVERSION "\n"
								"   (c)1994 Codex Design Software */\n"
								"\n",
								Count,
								Start,
								Step,
								(long)Multi,
								(long)Add);

	WRITESTR(ExtHelpTxt);
	WRITESTR(Type);									// write 'short '
	WRITESTR((char *)TempArray[ARG_LABEL]);
	WRITESTR("[] = {\n  ");

	// -- make first load --

	printf("done.\nSaving sin data... ");

	Pred				=	FALSE;
	ExtHelpTxt[0]	=	0;

	for(NLCnt=0, i=0; i<CosLabelOff; i++)
	{
		Buf	=	sin((double)((PI*2) * (double)Start) / 360);
		Buf	*=	Multi;
		Buf	+=	Add;
		k		=	Buf;					// translate to int
		Start	=	(Start + Step) % 360;

		if(NLCnt == VALUES_PER_LINE)
		{
			strcat(ExtHelpTxt,"\n  ");
			WRITESTR(ExtHelpTxt);
			ExtHelpTxt[0] = 0;
			NLCnt	=	0;
		}

		sprintf(Buffer,"%ld,",k);
		strcat(ExtHelpTxt,Buffer);
		NLCnt++;
	}

	if(NLCnt)											// falls CosLabelOff == 0
	{
		ExtHelpTxt[strlen(ExtHelpTxt)-1] = 0;	// kill last commata !
		strcat(ExtHelpTxt,"\n }");
		WRITESTR(ExtHelpTxt);
	}

	// -- generate cos label ? --

	if(i < Count)										// still something to do ?
	{
		printf("done.\nSaving cosinus data... ");

		WRITESTR(",\n ");
		WRITESTR((char *)TempArray[ARG_COSLAB]);
		WRITESTR("[] = {\n  ");

		Pred				=	FALSE;
		ExtHelpTxt[0]	=	0;

		for(NLCnt=0; i<Count; i++)
		{
			Buf	=	sin((double)((PI*2) * (double)Start) / 360);
			Buf	*=	Multi;
			Buf	+=	Add;
			k		=	Buf;					// translate to int
			Start	+=	Step;

			if(NLCnt == VALUES_PER_LINE)
			{
				strcat(ExtHelpTxt,"\n  ");
				WRITESTR(ExtHelpTxt);
				ExtHelpTxt[0] = 0;
				NLCnt	=	0;
			}

			sprintf(Buffer,"%ld,",k);
			strcat(ExtHelpTxt,Buffer);
			NLCnt++;
		}

		if(NLCnt)											// falls Count == 0 (unmöglich, aber na ja !)
		{
			ExtHelpTxt[strlen(ExtHelpTxt)-1] = 0;	// kill last commata !
			strcat(ExtHelpTxt,"\n }");
			WRITESTR(ExtHelpTxt);
		}
	}

	// -- finish --

	WRITESTR(";\n\n/* " PROGNAME " " PROGVERSION " */\n");

	Close(File);
	puts("done.\nOperation successful.");

EndUp:

	FreeArgs(Anchor);
}