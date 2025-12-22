/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	Palis

	FILE: Main.c
	TASK:	mainloop

	(c)1995 by Hans Bühler
*/

#include	"pl.h"

// ---------------------------
// defines
// ---------------------------

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

static BOOL CheckQuit(BOOL request);

// ---------------------------
// vars
// ---------------------------

// ---------------------------
// funx
// ---------------------------

void MainLoop(void)
{
	ULONG				rec;
#ifndef FINAL
	ULONG				cxID;
	CxMsg				*cxmsg;
#endif
	BOOL				quit	=	FALSE;

	// -- commodities ... ---
#ifndef FINAL
	ActivateCxObj(CxMain,TRUE);
#endif
	SetTaskPri(SysBase->ThisTask,PROG_PRI);

	do
	{
		rec	=	1 << SIGBREAKB_CTRL_C;			// you may also quit
															// PALIS by sending ^C signal to it !!!
#ifndef FINAL
		rec	|=	1 << CxPort->mp_SigBit;
#endif
		rec = Wait(rec);

#ifndef FINAL
		if(rec & (1 << CxPort->mp_SigBit))
			while((cxmsg = (CxMsg *)GetMsg(CxPort)) && !quit)
			{
				cxID	=	CxMsgID(cxmsg);

				ReplyMsg((APTR)cxmsg);

				if(cxID == CXCMD_KILL)
					quit	=	CheckQuit(TRUE);
				else
					DisplayBeep(0);
			}
#endif

		if(!quit && rec & (1 << SIGBREAKB_CTRL_C))
			quit	=	CheckQuit(TRUE);
	}
	while(!quit);

	SetTaskPri(SysBase->ThisTask,0);
}


/************************************************
 * this routine checks whether it's possible to	*
 * quit PALIS												*
 ************************************************/

static BOOL CheckQuit(BOOL request)
{
	BOOL	quit	=	TRUE;

	ObtainSemaphore(&plBase.Sem);

	if(plBase.LibCnt)
	{
		if(!request ||
			!Req(	"* WARNING *\n"
					"There are still %ld patches concerning %ld libraries\n"
					"known to " PROGNAME " !\n"
					"\n"
					"+----------------------------------------+\n"
					"| * IT IS VERY DANGEROUS TO QUIT NOW ! * |\n"
					"+----------------------------------------+\n"
					"\n"
					"Please refer to the manual before you proceed\n"
					"to quit " PROGNAME " !!!!",
					" Quit ;( | Cancel & be save ",
					(APTR)plBase.PatchCnt,(APTR)plBase.LibCnt,0,0))
		{
			quit	=	FALSE;
		}
	}

	ReleaseSemaphore(&plBase.Sem);

	return quit;
}