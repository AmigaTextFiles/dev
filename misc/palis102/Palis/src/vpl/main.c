/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	PatchLibraries Utility / VIEW

	FILE:	main.c
	TASK:	mainloop

	(c)1995 by Hans Bühler, h0348kil@rz.hu-berlin.de
*/

#include	"plView.h"

// ---------------------------
// defines
// ---------------------------

// ---------------------------
// datatypes
// ---------------------------

// ---------------------------
// proto
// ---------------------------

// ---------------------------
// vars
// ---------------------------

// ---------------------------
// funx
// ---------------------------

void MainLoop(void)
{
	CxMsg				*cxmsg;
	ULONG				rec,cxID,cxType;
	BOOL				quit;

	ActivateCxObj(CxMain,TRUE);

	if(ttGetBool(&tt[ARG_CX_POPUP]))
		OpenWin();

	quit	=	FALSE;

	do
	{
		rec	=	(1 << CxPort->mp_SigBit) |
					(MainWnd ? (1 << MainWnd->UserPort->mp_SigBit) : 0);

		rec	=	Wait(rec);

		// -- cx events --

		if(rec & (1 << CxPort->mp_SigBit))
			while(cxmsg = (APTR)GetMsg(CxPort))
			{
				cxID		=	CxMsgID(cxmsg);
				cxType	=	CxMsgType(cxmsg);

				ReplyMsg((APTR)cxmsg);

				switch(cxType)
				{
					case	CXM_IEVENT	:	// (=> cxID == CXE_POPUP)

								if(MainWnd)
									CloseWin();
								else
									OpenWin();
								break;

					case	CXM_COMMAND	:

								switch(cxID)
								{
									case	CXCMD_APPEAR:
									case	CXCMD_UNIQUE:

												OpenWin();
												break;

									case	CXCMD_DISAPPEAR	:

												CloseWin();
												break;

									case	CXCMD_DISABLE	:
									case	CXCMD_ENABLE	:

												break;				// bis jetzt keine Funktion

									case	CXCMD_KILL	:

												quit	=	TRUE;
												break;

									default	:

												break;
								}
				}
			}

		// -- window stuff --

		if(!quit && MainWnd && (rec & (1 << MainWnd->UserPort->mp_SigBit)))
			switch(HandleMainIDCMP())
			{
				case	CMD_OKAY	:

							break;

				case	CMD_QUIT	:

							quit	=	TRUE;
							break;

				case	CMD_HIDE	:

							CloseWin();
							break;

				case	CMD_ERRORBEEP	:

							DisplayBeep(MainWnd->WScreen);

				case	CMD_REFRESH:

							break;
			}
	}
	while(!quit);

	ActivateCxObj(CxMain,FALSE);
	CloseWin();
}
