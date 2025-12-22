/*************************************************************************
;  :Module.	WHDLoadGCI.c
;  :Author.	Bert Jahn
;  :EMail.	jah@fh-zwickau.de
;  :Address.	Franz-Liszt-Straﬂe 16, Rudolstadt, 07404, Germany
;  :Version.	$Id: WHDLoadGCI.c 0.15 2004/06/14 19:10:49 wepl Exp wepl $
;  :History.	18.07.98 started
;		13.12.98 immediate terminate if dump loading fails
;		02.03.00 expmem stuff added
;			 multiple memory windows
;		12.07.03 registers can be linked to memwin
;		13.06.04 cia window added
;  :Copyright.	All Rights Reserved
;  :Language.	C
;  :Translator.	GCC 2.90.27
*************************************************************************/

#define _CHKSTRLEN__

#include <stdio.h>

#include <exec/memory.h>
#include <libraries/mui.h>

#include <clib/alib_protos.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/muimaster_protos.h>
#include <proto/muimaster.h>

#include "class.h"
#include "whddump.h"
#include "WHDLoadGCI.h"

/************************************************************************/
/* defines								*/
/************************************************************************/

/************************************************************************/
/* extern functions							*/
/************************************************************************/

void	make_win_info	(void);
void	make_win_cia	(void);
void	make_win_cpu	(void);
void	make_win_cust	(void);

void	wmem_make	(int);

void	freedump	(void);
BOOL	loaddump	(STRPTR name);

/************************************************************************/
/* static variables							*/
/************************************************************************/

extern struct Library *SysBase,*DOSBase;
struct Library *IntuitionBase = NULL;
struct Library *MUIMasterBase = NULL;
struct Library *UtilityBase = NULL;

APTR app = NULL;		/* application */
APTR win = NULL;		/* main window */

struct whddump_header	* header = NULL;
char			* term = NULL;
struct whddump_cpu	* cpu = NULL;
struct whddump_custom	* custom = NULL;
struct whddump_cia	* ciaa = NULL;
struct whddump_cia	* ciab = NULL;
APTR			* slave = NULL;
APTR			* mem = NULL;
APTR			* emem = NULL;

/************************************************************************/
/* function declarations						*/
/************************************************************************/

void	main2		(void);

/************************************************************************/

struct NewMenu MenuData[] =
{
	{ NM_TITLE, "Project"			, 0 ,0 ,0 ,(APTR)MEN_PROJECT	},
/*
	{ NM_ITEM ,  "Open"			,"O",0 ,0 ,(APTR)MEN_OPEN	},
	{ NM_ITEM ,  NM_BARLABEL		, 0 ,0 ,0 ,(APTR)0		},
*/
	{ NM_ITEM ,  "About"			,"?",0 ,0 ,(APTR)MEN_ABOUT	},
	{ NM_ITEM ,  "About MUI"		,"M",0 ,0 ,(APTR)MEN_ABOUTMUI	},
	{ NM_ITEM ,  NM_BARLABEL		, 0 ,0 ,0 ,(APTR)0		},
	{ NM_ITEM ,  "Quit"			,"Q",0 ,0 ,(APTR)MEN_QUIT	},
	{ NM_END,NULL,0,0,0,(APTR)0 },
};

/************************************************************************/

#ifdef _DCC
int brkfunc(void) { return(0); }
int wbmain(struct WBStartup *wb_startup) {
	extern int main(int argc, char *argv[]);
	return (main(0, (char **)wb_startup));
}
#endif

#ifdef __SASC
int CXBRK(void) { return(0); }
int _CXBRK(void) { return(0); }
void chkabort(void) {}
#endif

/************************************************************************/

char * dmacon_h (UWORD v) {
	static char s[257];
	sprintf(s,MUIX_C MUIX_B "DMA Control\n" MUIX_N MUIX_R
		"Blitter Busy = %d\n"
		"Blitter Zero = %d\nBlitter Priority = %d\nDMA Enable = %d\n"
		"Bitplane Enable = %d\nCopper Enable = %d\nBlitter Enable = %d\n"
		"Sprite Enable = %d\nDisk Enable = %d\nAudio 3 Enable = %d\n"
		"Audio 2 Enable = %d\nAudio 1 Enable = %d\nAudio 0 Enable = %d",
		btst(v,14),btst(v,13),btst(v,10),btst(v,9),btst(v,8),btst(v,7),btst(v,6),
		btst(v,5),btst(v,4),btst(v,3),btst(v,2),btst(v,1),btst(v,0)
	);
#ifdef __CHKSTRLEN__
	printf("dmacon_h %ld<%ld\n",strlen(s),sizeof(s));
#endif
	return s;
}

void int_h (UWORD v, char *s, const char *name) {
	sprintf(s,MUIX_C MUIX_B "Interrupt %s\n" MUIX_N MUIX_R
		"Interrupt Enable = %d\n"
		"CIA-B, Expansion = %d\nDisk = %d\nSerial full = %d\n"
		"Audio 3 = %d\nAudio 2 = %d\nAudio 1 = %d\nAudio 0 = %d\nBlitter = %d\n"
		"Vertical Blank = %d\nCopper = %d\nCIA-A, Expansion = %d\nSoft = %d\n"
		"Disk = %d\nSerial empty = %d",
		name,btst(v,14),btst(v,13),btst(v,12),btst(v,11),btst(v,10),btst(v,9),
		btst(v,8),btst(v,7),btst(v,6),btst(v,5),btst(v,4),btst(v,3),btst(v,2),
		btst(v,1),btst(v,0)
	);
}
char * intena_h (UWORD v) {
	static char s[238];
	int_h(v,s,"Enable");
#ifdef __CHKSTRLEN__
	printf("intena_h %ld<%ld\n",strlen(s),sizeof(s));
#endif
	return s;
}
char * intreq_h (UWORD v) {
	static char s[239];
	int_h(v,s,"Request");
#ifdef __CHKSTRLEN__
	printf("intreq_h %ld<%ld\n",strlen(s),sizeof(s));
#endif
	return s;
}

char * sr_h (UWORD v) {
	static char s[56];
	sprintf(s,"Status Register\nT=%d S=%d M=%d I=%d X=%d N=%d Z=%d V=%d C=%d",
	(v>>14)&3,btst(v,13),btst(v,12),(v>>8)&7,btst(v,4),
	btst(v,3),btst(v,2),btst(v,1),btst(v,0) );
#ifdef __CHKSTRLEN__
	printf("sr_h %ld<%ld\n",strlen(s),sizeof(s));
#endif
	return s;
}

/*************************************************************************/

int main(int argc,char *argv[]) {

	if ((IntuitionBase = OpenLibrary("intuition.library",39))) {
		if ((UtilityBase = OpenLibrary("utility.library",39))) {
			if ((MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))) {
				if (argc == 2) loaddump(argv[1]); else loaddump(NULL);
				if (header) {
					if (class_init()) {
						main2();
						class_finit();
					}
					freedump();
				}
				CloseLibrary(MUIMasterBase);
			}
			CloseLibrary(UtilityBase);
		}
		CloseLibrary(IntuitionBase);
	}

	exit(0);
}

/*************************************************************************/

void main2() {

	APTR
		mored0,mored1,mored2,mored3,mored4,mored5,mored6,mored7,
		morea0,morea1,morea2,morea3,morea4,morea5,morea6,
		moreusp,moressp,morepc,morecpu,
		morecust,morecia,moremem,moreemem,moreslave,moreinfo,
		a_quit/*,a_restart,a_cont*/;
	ULONG signals;
	BOOL running = TRUE;

	app = ApplicationObject,
		MUIA_Application_Title,		"WHDLoad GCI",
		MUIA_Application_Version,	"$VER: WHDLoad GCI 1.2 (" __DATE__ ")",
		MUIA_Application_Copyright,	"©1998-2004 by Wepl",
		MUIA_Application_Author,	"Wepl",
		MUIA_Application_Description,	"WHDload Visualisation and Debugging.",
		MUIA_Application_Base,		"WHDLoadGCI",
		MUIA_Application_Menustrip,	MUI_MakeObject(MUIO_MenustripNM,MenuData,0),
		MUIA_Application_Window,	win = WindowObject,
			MUIA_Window_Title, "WHDLoad GCI",
			MUIA_Window_ID   , MAKE_ID('M','A','I','N'),
			WindowContents, VGroup,
				Child, HGroup,
					Child, HGroup, MUIA_Weight, 100, GroupFrameT("CPU"), MUIA_Group_Columns, 4,
						Reg32BE(mored0,"D0:",&cpu->wdc_regs[0]),
						Reg32BE(morea0,"A0:",&cpu->wdc_regs[8]),
						Reg32BE(mored1,"D1:",&cpu->wdc_regs[1]),
						Reg32BE(morea1,"A1:",&cpu->wdc_regs[9]),
						Reg32BE(mored2,"D2:",&cpu->wdc_regs[2]),
						Reg32BE(morea2,"A2:",&cpu->wdc_regs[10]),
						Reg32BE(mored3,"D3:",&cpu->wdc_regs[3]),
						Reg32BE(morea3,"A3:",&cpu->wdc_regs[11]),
						Reg32BE(mored4,"D4:",&cpu->wdc_regs[4]),
						Reg32BE(morea4,"A4:",&cpu->wdc_regs[12]),
						Reg32BE(mored5,"D5:",&cpu->wdc_regs[5]),
						Reg32BE(morea5,"A5:",&cpu->wdc_regs[13]),
						Reg32BE(mored6,"D6:",&cpu->wdc_regs[6]),
						Reg32BE(morea6,"A6:",&cpu->wdc_regs[14]),
						Reg32BE(mored7,"D7:",&cpu->wdc_regs[7]),
						Reg32BEH(moreusp,"USP:",&cpu->wdc_usp,"User Stack Pointer"),
						Reg16LEI("SR:",&cpu->wdc_sr,sr_h),
						Reg32BEH(moressp,"SSP:",&cpu->wdc_ssp,"Supervisor Stack Pointer"),
						Reg32BEH(morepc,"PC:",&cpu->wdc_pc,"Program Counter"),
						Child, Label2(""), Child, morecpu = SimpleButton("More"),
    					End,
					Child, VGroup, MUIA_Weight, 40,
						Child, VGroup, GroupFrameT("Custom"),
							Child, HGroup, MUIA_Group_Columns, 2,
								RegCustomWordReadWrite("dmacon:",0x002,0x096,dmacon_h),
								RegCustomWordReadWrite("intena:",0x01c,0x09a,intena_h),
								RegCustomWordReadWrite("intreq:",0x01e,0x09c,intreq_h),
    							End,
    						Child, morecust = SimpleButton("More"),
    						End,
						Child, VGroup, GroupFrameT("Misc"),
							Child, morecia = SimpleButton("Cia's"),
							Child, moremem = SimpleButton("BaseMem"),
							ChildIf(emem), moreemem = SimpleButtonIf(emem,"ExpMem"),
							Child, moreslave = SimpleButton("Slave"),
							Child, moreinfo = SimpleButton("Info"),
							End,
						End,
					End,
    			ChildIf(term), term ? TextObject, TextFrame,
					MUIA_Background, MUII_TextBack,
					MUIA_Text_Contents, term,
					End : NULL,
				Child, HGroup, GroupFrameT("Actions"), MUIA_Group_SameWidth, TRUE,
					Child, a_quit = SimpleButton("Quit"),
					/*Child, a_restart = SimpleButton("Restart"),
					Child, a_cont = SimpleButton("Continue"),*/
					End,
				End,
			End,
		End;

	if (app) {

	DoMethod(win,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	DoMethod(mored0,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED0);
	DoMethod(mored1,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED1);
	DoMethod(mored2,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED2);
	DoMethod(mored3,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED3);
	DoMethod(mored4,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED4);
	DoMethod(mored5,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED5);
	DoMethod(mored6,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED6);
	DoMethod(mored7,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORED7);
	DoMethod(morea0,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA0);
	DoMethod(morea1,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA1);
	DoMethod(morea2,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA2);
	DoMethod(morea3,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA3);
	DoMethod(morea4,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA4);
	DoMethod(morea5,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA5);
	DoMethod(morea6,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREA6);
	DoMethod(moreusp,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREUSP);
	DoMethod(moressp,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORESSP);
	DoMethod(morepc,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREPC);
	DoMethod(morecia,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORECIA);
	DoMethod(morecpu,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORECPU);
	DoMethod(morecust,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORECUST);
	DoMethod(moremem,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREMEM);
	DoMethod(moreemem,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREEMEM);
	DoMethod(moreslave,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MORESLAVE);
	DoMethod(moreinfo,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MAIN_MOREINFO);

	DoMethod(a_quit,MUIM_Notify,MUIA_Pressed,FALSE,app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);

	set(win,MUIA_Window_Open,TRUE);
	
/*
** Input loop...
*/

	while (running)
	{
		ULONG id = DoMethod(app,MUIM_Application_Input,&signals);

		switch (id)
		{
			case MEN_QUIT:
			case MUIV_Application_ReturnID_Quit:
				running = FALSE;
				break;

			case MEN_ABOUT:
				MUI_Request(app,win,0,NULL,"OK","\33cWHDLoad Graphical Coders Interface\n"
					"©1998-2004 Wepl\nAll Rights Reserved.");
				break;
			case MEN_ABOUTMUI:
				DoMethod(app,MUIM_Application_AboutMUI,win);
				break;

			case MAIN_MORECIA:
				make_win_cia();
				break;
			case MAIN_MORECPU:
				make_win_cpu();
				break;
			case MAIN_MORECUST:
				make_win_cust();
				break;
			case MAIN_MOREMEM:
				wmem_make(0);
				break;
			case MAIN_MOREEMEM:
				if (emem) {
					wmem_make(header->wdh_ExpMemLog);
				}
				break;
			case MAIN_MORESLAVE:
				wmem_make(header->wdh_SlaveLog);
				break;
			case MAIN_MOREINFO:
				make_win_info();
				break;
			case MAIN_MORED0:
			case MAIN_MORED1:
			case MAIN_MORED2:
			case MAIN_MORED3:
			case MAIN_MORED4:
			case MAIN_MORED5:
			case MAIN_MORED6:
			case MAIN_MORED7:
			case MAIN_MOREA0:
			case MAIN_MOREA1:
			case MAIN_MOREA2:
			case MAIN_MOREA3:
			case MAIN_MOREA4:
			case MAIN_MOREA5:
			case MAIN_MOREA6:
				wmem_make(cpu->wdc_regs[id-MAIN_MORED0]);
				break;
			case MAIN_MOREUSP:
				wmem_make(cpu->wdc_usp);
				break;
			case MAIN_MORESSP:
				wmem_make(cpu->wdc_ssp);
				break;
			case MAIN_MOREPC:
				wmem_make(cpu->wdc_pc);
				break;
			case MAIN_MORECOP1LC:
				wmem_make(*(ULONG*)(&custom->wdcu_regs[0x080/2]));
				break;
			case MAIN_MORECOP2LC:
				wmem_make(*(ULONG*)(&custom->wdcu_regs[0x084/2]));
				break;
		}
		if (running && signals) Wait(signals);
	}

	set(win,MUIA_Window_Open,FALSE);

/*
** Shut down...
*/

	MUI_DisposeObject(app);

	}
}

