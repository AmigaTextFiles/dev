/******************************************************************************
**                                                                           **
** VSort V 1.0                                                               **
**                                                                           **
*******************************************************************************
** Visualisierung von Sortierprozessen                                       **
** by Stefan Kost                                                            **
** 19.04.1995                                                                **
******************************************************************************/

#include "demo.h"
#include <exec/types.h>
#include <dos/dostags.h>
#include <libraries/asl.h>
#include <math.h>
#ifdef _M68881
	#include <m68881.h>
#endif

#include <proto/asl.h>

//							 ID`s für main_win
#define ID_GO		 1
#define ID_EXIT		 2
#define ID_ABOUT	 3

#define	ID_SORTTYP	10
#define ID_DATATYP	11
#define ID_SWAPCT	12
#define ID_ANZ		13
#define ID_DELAY	14

//							 ID`s für Cycle`s
#define ST_BUBBLE			0
#define ST_SELECTION		1
#define ST_INSERTION		2
#define ST_SHELL			3
#define ST_QUICK			4
#define ST_MERGE			5
#define ST_RADIXEXCHANGE	6
#define ST_HEAP				7

#define DT_SORTED		0
#define DT_MERGED		1
#define	DT_REVERSED		2
#define	DT_REVMERGED	3

// 							other defines
#define maxanz 500

// GUI-Globals 

extern struct DosLibrary	*DOSBase;
struct Screen				*scr=0l;
struct Window				*gfxwin=0l;
struct RastPort				rp;
char *sorttyp[]={	"BubbleSort",
					"SelectionSort",
					"InsertionSort",
					"ShellSort",
					"QuickSort",
					"MergeSort",
					"RadixExchangeSort",
					"HeapSort",
					NULL };
char *datatyp[]={	"sorted",
					"merged",
					"reversed",
					"rev + merged",
					NULL };
char *mess[]={
	"\033c\0338VisualSort V1.0\0332\033n\n\nwritten by ENSONIC of TRINOMIC\nVisualising of sortingprocesses.",
};
char *ques[]={
	"\033cDo you really want to leave \033bVisualSort\033n ?",
};

APTR	app1,
		main_win,
			main_go,main_exit,main_about,
			main_sorttyp,main_datatyp,main_swapct,main_anz,main_delay;

struct TagItem wintags[]={
	WA_Left,				50,
	WA_Top,					20,
	WA_InnerWidth,			200,
	WA_InnerHeight,			70,
	WA_IDCMP,				IDCMP_CLOSEWINDOW|IDCMP_RAWKEY,
	WA_Flags,				WFLG_SMART_REFRESH|WFLG_ACTIVATE|WFLG_CLOSEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_GIMMEZEROZERO|WFLG_RMBTRAP,
	WA_Title,				(ULONG *)"VisualSort GFXWindow",
	WA_CustomScreen,		0l,
	TAG_DONE
};
