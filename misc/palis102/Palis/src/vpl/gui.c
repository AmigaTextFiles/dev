/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents

	PatchLibraries Utility / VIEW

	FILE:	gui.c
	TASK:	window control

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
// funx: basic
// ---------------------------

BOOL OpenWin(void)
{
	if(MainWnd)
	{
		SetActiveList(LIST_PALIS);
		return TRUE;
	}

	if(!InitLists())
		return FALSE;

	if(!SetupScreen())
	{
		MainLeft	=	ttGetInt(&tt[ARG_WINX]);
		MainTop	=	ttGetInt(&tt[ARG_WINY]);

		if(!OpenMainWindow())
		{
			SetActiveList(LIST_PALIS);
			return TRUE;
		}
		CloseMainWindow();
	}
	CloseDownScreen();

	DisplayBeep(0);
	return FALSE;
}

// ---------------------------

void CloseWin(void)
{
	if(MainWnd)
	{
		ttSetInt(&tt[ARG_WINX],MainWnd->LeftEdge);
		ttSetInt(&tt[ARG_WINY],MainWnd->TopEdge);
	}

	CloseMainWindow();
	CloseDownScreen();

	RemLists();
}

// ---------------------------
// funx: basic
// ---------------------------

int GadListClicked( void )
{
	return CMD_OKAY;
}

// ---------------------------

int GadUpDateClicked( void )
{
	SetActiveList(LIST_PALIS);				// force REFRESH to show PALIS jobs
	return CMD_REFRESH;
}

// ---------------------------

int GadAboutClicked( void )
{
	SetActiveList(LIST_ABOUT);
	return CMD_REFRESH;
}

// ---------------------------

int GadCloseClicked( void )
{
	return CMD_QUIT;
}

// ---------------------------

int GadHideClicked( void )
{
	return CMD_HIDE;
}

// ---------------------------

int MainCloseWindow(void)
{
	return CMD_HIDE;
}
