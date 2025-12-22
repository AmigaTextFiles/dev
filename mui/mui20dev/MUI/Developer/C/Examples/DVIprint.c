/*
 *			DVIprint MUI Demo
 *              	=================
 *
 *  This is a preview demo of the new DVIprint of PasTeX 1.4.
 *  This demo is absolutly *not functional*. It's only a demo
 *  how easy it is to create a GUI with the help of MUI!
 *
 *  Georg Hessmann.
 *
 */

#include "demo.h"


#define ID_ABOUT  		1
#define ID_NEWFILE		2
#define ID_DOUBLENEWFILE	3
#define ID_NEWVOLUME		4
#define ID_MUTTER		5
#define ID_DVIFILE		6
#define ID_NEWPRT		7
#define ID_RUNPRINT		8
#define ID_CANCELPRINT		9
#define ID_PRTUSE		10
#define ID_PRTCANCEL		11
#define ID_SONUSE		12
#define ID_SONCANCEL		13
#define ID_HOFF			14	/* check of richtige Massangabe */
#define ID_VOFF			15	/* "" */
#define ID_WIDTH		16	/* "" */
#define ID_HEIGHT		17	/* "" */


struct NewMenu Menu[] =
{
	{ NM_TITLE, "Project"  , 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "About..." ,"?",0,0,(APTR)ID_ABOUT     },
	{ NM_ITEM , NM_BARLABEL, 0 ,0,0,(APTR)0            },
	{ NM_ITEM , "Quit"     ,"Q",0,0,(APTR)MUIV_Application_ReturnID_Quit },
	{ NM_END  , NULL       , 0 ,0,0,(APTR)0            },
};





/****************************************************/



int CurPrtNum = 0;


APTR Applic = NULL;
APTR WI_Main, WI_Printer, WI_Sonst, WI_PrtRun;

/*
 * Objecte von: WI_Main
 */
APTR CY_Reihenf, CY_Orient, CY_SeitenM, CY_ZuDruck, CY_Seiten,
            ST_von, ST_bis, ST_num, ST_Kopien;
APTR TX_Drucker, BT_Drucker, BT_MiscPre;
APTR LV_Files, LV_Volumes, BT_Parent, ST_File, IM_File;
APTR BT_Cancel, BT_Print, BT_Save;

/*
 * Objecte von: WI_Printer
 */
APTR LV_PrtLst, TX_Printer;
APTR CY_DrModus, CY_Density, CY_Optimize, CY_Direct, CY_DevMode, CY_Output, ST_Output, IM_Output;
APTR ST_HOffset, ST_VOffset, CY_PgSize, ST_Width, ST_Height, CY_Reso, ST_XReso, ST_YReso, CY_FormFeed;
APTR BT_PRTuse, BT_PRTcancel;

/* 
 * Objecte von: WI_Sonst
 */
APTR ST_FDir, ST_FMem, CY_BMem, ST_BMem, ST_Prio;
APTR IM_PreL, IM_Mark, IM_Stat, IM_Acco, CH_Logf, IM_Logf, ST_Logf;
APTR BT_SONuse, BT_SONcancel;

/* 
 * Objecte von: WI_PrtRun
 */
APTR GA_Gauge, TX_PrtFile, BT_RUNcancel;




static const char * CYA_Reihenf [] = { "vorwärts", "rückwärts", NULL };
static const char * CYA_Orient  [] = { "Hochformat", "Querformat", NULL };
static const char * CYA_SeitenM [] = { "logisch", "physikalisch", NULL };
static const char * CYA_ZuDruck [] = { "durchgehend", "gerade Seiten", "ungerade Seiten", NULL };
static const char * CYA_Seiten  [] = { "alle", "von/bis", NULL };

static const char * CYA_DrModus [] = { "HQ", "Draft", NULL };
static const char * CYA_Density [] = { "den 1", "den 2", "den 3", "den 4", "den 5", "den 6", "den 7", NULL };
static const char * CYA_Optimize[] = { "an", "aus", NULL };
static const char * CYA_Direct  [] = { "hin und her", "nur hin", NULL };
static const char * CYA_DevMode [] = { "normal", "schnell", NULL };
static const char * CYA_Output  [] = { "Drucker", "PRT-File...", "IFF-File...", NULL };
static const char * CYA_PgSize  [] = { "des DVI-Files", "vorab Definition", NULL };
static const char * CYA_Reso    [] = { "des Druckers", "spezielle", NULL };
static const char * CYA_FormFeed[] = { "ausführen", "unterdrücken", NULL };

static const char * CYA_BMem    [] = { "unbegrenzt", "maximal bis...", NULL };

static char * LVT_PrtLst[] = { "generic", "DeskJet", "CheapDJ", "LaserJet", "LaserJet4", "CanonLBP", "NecP6", NULL };


static char DVIFileBuffer[512];
static char DVIpattern[16];



/******************************************************/

#define POP_FILE	1
#define POP_OUTP	2
#define POP_LOGF	3


#define PopupArg(ptr,obj,retimg,img,hook,arg)\
	HGroup, GroupSpacing(1),\
		Child, ptr=obj,\
		Child, retimg = ImageObject,\
			ImageButtonFrame,\
			MUIA_Image_Spec          , img,\
			MUIA_Image_FontMatchWidth, TRUE,\
			MUIA_Image_FreeVert      , TRUE,\
			MUIA_InputMode           , MUIV_InputMode_RelVerify,\
			MUIA_Background          , MUII_BACKGROUND,\
			End,\
		TAG_IGNORE, retimg && ptr ? DoMethod(retimg,MUIM_Notify,MUIA_Pressed,FALSE,ptr,3,MUIM_CallHook,hook,arg) : 0,\
		End


SAVEDS ASM ULONG FilePopupFunc(REG(a0) struct Hook * hook, REG(a1) void * args, REG(a2) APTR obj)
{
  struct Window * window;
  long l, t, w, h;
  struct FileRequester * req;
  char * buf, * cptr, * dir, * file;
  int IsDir, GadType;
  BPTR lock;
  __aligned struct FileInfoBlock fib;
  char device[50];
  char * title = "";
  
  /* put our application to sleep while displaying the requester */
  set(Applic,MUIA_Application_Sleep,TRUE);
  
  GadType = *((long *)args);	/* POP_#? */

  switch (GadType) {
    case POP_FILE:
      title = "Select DVI-File";
      break;
    case POP_OUTP:
      title = "Select Output-File";
      break;
    case POP_LOGF:
      title = "Select Logfile";
      break;
  }

  get(obj,MUIA_String_Contents,&buf);
  strncpy(DVIFileBuffer, buf, sizeof(DVIFileBuffer)-1);
  
  IsDir = FALSE;
  lock = Lock(DVIFileBuffer, ACCESS_READ);
  if (lock) {
    if (Examine(lock, &fib)) {
      if (fib.fib_DirEntryType > 0) IsDir = TRUE;
    }
    UnLock(lock);
  }

  if (IsDir) {
    file = NULL;
    dir  = DVIFileBuffer;
  }
  else {
    cptr = strrchr(DVIFileBuffer, '/');
    if (cptr) {
      dir = DVIFileBuffer;
      *cptr = '\0';
      file  = cptr+1;
    }
    else {
      cptr = strchr(DVIFileBuffer, ':');
      if (cptr) {
        strncpy(device, DVIFileBuffer, cptr-DVIFileBuffer+1);
        device[cptr-DVIFileBuffer+1] = '\0';
        dir  = device;
        file = cptr+1;
      }
      else {
        dir  = NULL;
        file = DVIFileBuffer;
      }
    }
  }
  
  /* get the calling objects window and position */
  get(obj,MUIA_Window  ,&window);
  get(obj,MUIA_LeftEdge,&l);
  get(obj,MUIA_TopEdge ,&t);
  get(obj,MUIA_Width   ,&w);
  get(obj,MUIA_Height  ,&h);

  if (req=MUI_AllocAslRequestTags(ASL_FileRequest,TAG_DONE)) {
    if (MUI_AslRequestTags(req,
         ASLFO_Window         ,window,
         ASLFO_PrivateIDCMP   ,TRUE,
         ASLFO_TitleText      ,title,
         ASLFO_InitialLeftEdge,window->LeftEdge + l,
         ASLFO_InitialTopEdge ,window->TopEdge  + t+h,
         ASLFO_InitialWidth   ,w,
         ASLFO_InitialHeight  ,250,
         ((GadType==POP_FILE) ? ASLFR_InitialPattern : TAG_IGNORE), "#?.dvi",
         ((file)              ? ASLFR_InitialFile    : TAG_IGNORE), file,
         ((dir)               ? ASLFR_InitialDrawer  : TAG_IGNORE), dir,
         TAG_DONE)) {

       /* set the new contents for our string gadget */
       strncpy(DVIFileBuffer, req->fr_Drawer, sizeof(DVIFileBuffer)-1);
       AddPart(DVIFileBuffer, req->fr_File, sizeof(DVIFileBuffer)-1);
       set(obj,MUIA_String_Contents,DVIFileBuffer);

       if (GadType == POP_FILE) {
			set(LV_Files, MUIA_Dirlist_Directory, req->fr_Drawer);
       }
    }
    MUI_FreeAslRequest(req);
  }

  /* wake up our application again */
  set(Applic,MUIA_Application_Sleep,FALSE);

  return(0);
}


static struct Hook FilePopupHook = {
	{NULL, NULL},
	(void *)FilePopupFunc,
	NULL, NULL
};


/******************************************************/




int main(int argc, char * argv[])
{
  init();

  /*InitVars(); */


  { /* Homedirectory in String-Gadget */
    BPTR lock;
    lock = Lock("", ACCESS_READ);
    if (lock) {
      (void)NameFromLock(lock, DVIFileBuffer, sizeof(DVIFileBuffer)-1);
      UnLock(lock);
    }
    else {
      *DVIFileBuffer = '\0';
    }
  }

  (void)ParsePatternNoCase("#?.dvi", DVIpattern, 16);


  Applic = ApplicationObject,
		MUIA_Application_Title         , "DVIprint",
		MUIA_Application_Version       , "$VER: DVIprint 0.5 (02.08.93)",
		MUIA_Application_Copyright     , "Copyright ©1993, Georg Heßmann",
		MUIA_Application_Author        , "Georg Heßmann",
		MUIA_Application_Description   , "MUI DEMO-FrontEnd for DVIprint/PasTeX",
		MUIA_Application_Base          , "DVIPRINT",
		MUIA_Application_Menu          , Menu,
		

		SubWindow,
			WI_Printer = WindowObject,
			MUIA_Window_Title , "DVIprint MUI-Demo",
			MUIA_Window_ID, MAKE_ID('P','R','T','D'),

			WindowContents, VGroup, 
			      Child, HGroup,
  			        Child, VGroup, GroupFrameT("Drucker"),
  			          Child, LV_PrtLst = ListviewObject,
						MUIA_Listview_Input, TRUE,
						MUIA_Listview_List, ListObject, InputListFrame,
						MUIA_List_AdjustWidth, TRUE, End,
					 End,
				  Child, TX_Printer = TextObject, TextFrame, MUIA_Background, MUII_TextBack, End,
				  End,
  			        Child, ColGroup(2), GroupFrameT("Druck Parameter"),
  			          Child, KeyLabel1("Modus:", 'm'),          Child, CY_DrModus  = KeyCycle(CYA_DrModus, 'm'),
  			          Child, KeyLabel1("Druck Dichte:", 'd'),         Child, CY_Density  = KeyCycle(CYA_Density, 'd'),
                                  Child, KeyLabel1("Optimierung:", 'o'),    Child, CY_Optimize = KeyCycle(CYA_Optimize,'o'),
  			          Child, Label2("Seitenposition"),             Child, ColGroup(2),
							Child, Label2("horiz.:"), Child, ST_HOffset = StringObject, MUIA_String_Accept, "1234567890.incmptdb", MUIA_String_MaxLen, 7, StringFrame, MUIA_ControlChar, 'h', End,
							Child, Label2("vert.:"), Child, ST_VOffset = StringObject, MUIA_String_Accept, "1234567890.incmptdb", MUIA_String_MaxLen, 7, StringFrame, MUIA_ControlChar, 'v', End,
							End,
                                  Child, KeyLabel1("Ausgabe auf:", 'e'),    Child, CY_Output   = KeyCycle(CYA_Output,'e'),
                                  Child, HSpace(0),                         Child, PopupArg(ST_Output, String("",100), IM_Output, MUII_PopFile, &FilePopupHook, POP_OUTP),
                                  /*Child, VSpace(0),                         Child, VSpace(0), */
                                  End,
  			        Child, ColGroup(2), GroupFrameT("sonstige Parameter"),
                                  Child, KeyLabel1("Letzter FormFeed:", 'f'), Child, CY_FormFeed = KeyCycle(CYA_FormFeed,'f'),
                                  Child, KeyLabel1("Druck Richtung:", 'r'), Child, CY_Direct   = KeyCycle(CYA_Direct,'r'),
                                  Child, KeyLabel1("Device Modus:", 'v'),   Child, CY_DevMode  = KeyCycle(CYA_DevMode,'v'),
  			          Child, KeyLabel1("Seitengröße:", 'g'),    Child, CY_PgSize   = KeyCycle(CYA_PgSize,'g'),
  			          Child, HSpace(0),                         Child, HGroup,
  			          			Child, Label2("H:"), Child, ST_Width   = StringObject, MUIA_String_Accept, "1234567890.incmptdb", MUIA_String_MaxLen, 7, StringFrame, End,
  			          			Child, Label2("V:"), Child, ST_Height  = StringObject, MUIA_String_Accept, "1234567890.incmptdb", MUIA_String_MaxLen, 7, StringFrame, End,
  			          			End,
  			          Child, KeyLabel1("Auflösung:", 'l'),      Child, CY_Reso    = KeyCycle(CYA_Reso,'l'),
  			          Child, HSpace(0),                         Child, HGroup,
							Child, Label2("H:"), Child, ST_XReso = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 5, StringFrame, End,
							Child, Label2("V:"), Child, ST_YReso = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 5, StringFrame, End,
							End,
                                  Child, VSpace(0),                         Child, VSpace(0),
  			        End,
			    End,

  			  Child, VSpace(2),

			  Child, HGroup,
 			    Child, BT_PRTuse   = KeyButton("Benutzen", 'u'), 
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, BT_PRTcancel = KeyButton("Abbrechen", 'a'), 
 			    End,
			  End,
			End,

		SubWindow,
			WI_Sonst = WindowObject,
			MUIA_Window_Title , "DVIprint MUI-Demo",
			MUIA_Window_ID, MAKE_ID('S','O','N','S'),

			WindowContents, VGroup, 
			  Child, HGroup, GroupFrameT("diverse Einstellungen"),
			    Child, ColGroup(2),
			      Child, Label2("zus. Font Verz.:"), Child, ST_FDir = String(NULL, 50),
			      Child, Label2("Task Priorität:"),  Child, ST_Prio = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 4, StringFrame, End, 
			      Child, HGroup, 
			        Child, HSpace(0),
			        Child, Label2("Logfile:"),
			        Child, CH_Logf = CheckMark(FALSE),
			        End,
			      Child, PopupArg(ST_Logf, String("T:DVIprint.log",50), IM_Logf, MUII_PopFile, &FilePopupHook, POP_LOGF),
			      Child, Label1("Bitmap Speicher:"), Child, CY_BMem = Cycle(CYA_BMem),
			      Child, HSpace(0),                  Child, HGroup, Child, ST_BMem = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 9, StringFrame, End, Child, Label2("Bytes"), End,
			      Child, Label2("Font Speicher:"),   Child, HGroup, Child, ST_FMem = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 9, StringFrame, End, Child, Label2("Bytes"), End,
			      End,
			    Child, HSpace(2),
                            Child, ColGroup(2),
			      Child, Label1("Fonts vorladen:"),      Child, IM_PreL = CheckMark(FALSE),
			      Child, Label1("Fonts markieren:"),     Child, IM_Mark = CheckMark(FALSE),
			      Child, Label1("ausführliches Logf.:"), Child, IM_Stat = CheckMark(FALSE),
			      Child, Label1("Seiten Protokoll:"),    Child, IM_Acco = CheckMark(FALSE),
			      End,
			    End,

  			  Child, VSpace(2),

			  Child, HGroup,
 			    Child, BT_SONuse   = KeyButton("Benutzen", 'u'), 
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, BT_SONcancel = KeyButton("Abbrechen", 'a'), 
 			    End,
			  End,
			End,


		SubWindow,
			WI_PrtRun = WindowObject,
			MUIA_Window_Title , "DVIprint MUI-Demo",
			MUIA_Window_ID, MAKE_ID('P','R','U','N'),

			WindowContents, VGroup, MUIA_Background, MUII_SHINEBACK,
			  Child, VGroup, GroupFrameT("Ausdruck"),
			    Child, TX_PrtFile = TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_PreParse, "\33c\0338", End,
			    Child, VSpace(2),
			    Child, HGroup,
			      Child, HSpace(0),
			      Child, GA_Gauge = GaugeObject, GaugeFrame, MUIA_Gauge_Horiz, TRUE, MUIA_Weight, 300, End,
			      Child, HSpace(0),
			      End,
			    End,
			  Child, VSpace(2),
			  Child, BT_RUNcancel = KeyButton("Abbruch", 'a'),
			  End,
			End,


		SubWindow,
			WI_Main = WindowObject,
			MUIA_Window_Title , "DVIprint MUI-Demo",
			MUIA_Window_ID, MAKE_ID('M','A','I','N'),

	                WindowContents, VGroup, 
			  Child, TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_Contents, "\33c\33b\0338DVIprint - PasTeX\33n\nwritten 1993 by Georg Heßmann\n(non functional, only a MUI demo)",  End,

                          Child, HGroup,
 			    Child, ColGroup(2), GroupFrameT("Ausdruck"),
  			      Child, Label1("Drucke Seiten:"),   Child, CY_Seiten  = KeyCycle(CYA_Seiten, 'p'),
  			      Child, HSpace(0),                  Child, ColGroup(4),
  			                                           Child, Label2("von:"), Child, ST_von = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 5, StringFrame, End,
  			                                           Child, Label2("bis:"), Child, ST_bis = StringObject, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 5, StringFrame, End,
  			                                           End,
     			      Child, VSpace(1),                  Child, VSpace(1),
			      Child, KeyLabel2("Anzahl Seiten:", 'a'), Child, HGroup, Child, ST_num    = StringObject, StringFrame, MUIA_Weight, 20, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 5, End, Child, HSpace(0), End,
		              Child, KeyLabel2("Anzahl Kopien:", 'n'), Child, HGroup, Child, ST_Kopien = StringObject, StringFrame, MUIA_String_Integer,  1, MUIA_Weight, 20, MUIA_String_Accept, "1234567890", MUIA_String_MaxLen, 5, End, Child, HSpace(0), End,
    			      Child, VSpace(1),                  Child, VSpace(1),
  			      Child, KeyLabel1("Seiten drucken:",'u'),  Child, CY_ZuDruck = KeyCycle(CYA_ZuDruck,'u'),
  			      Child, KeyLabel1("Reihenfolge:",   'f'),  Child, CY_Reihenf = KeyCycle(CYA_Reihenf,'f'),
  			      Child, KeyLabel1("Seitenmodus:",   't'),  Child, CY_SeitenM = KeyCycle(CYA_SeitenM,'t'),
  			      Child, KeyLabel1("Orientierung:",  'o'),  Child, CY_Orient  = KeyCycle(CYA_Orient ,'o'),
					Child, VSpace(0), Child, VSpace(0),
  			      End,

  			    Child, VGroup,
                              Child, VGroup, GroupFrameT("Einstellungen"),
			        Child, TX_Drucker = TextObject, TextFrame, MUIA_Background, MUII_TextBack, MUIA_Text_PreParse, "\33c\33b", End,
			        Child, HGroup,
                                  Child, BT_Drucker = KeyButton("Drucker", 'e'),
                                  Child, BT_MiscPre = KeyButton("Sonstiges", 'g'),
                                  End,
  			        End,
  			      Child, VGroup, GroupFrameT("DVI-File"),
				Child, HGroup,
					Child, LV_Files = ListviewObject,
							MUIA_Weight, 300,
							MUIA_Listview_Input, TRUE,
							MUIA_Listview_List, DirlistObject,
							InputListFrame,
							MUIA_Dirlist_Directory, DVIFileBuffer, 
							MUIA_Dirlist_AcceptPattern, DVIpattern,
							MUIA_Dirlist_RejectIcons, TRUE, End,
							End,
					Child, VGroup,
					  Child, LV_Volumes = ListviewObject,
								MUIA_Weight, 200,
								MUIA_Listview_Input, TRUE,
								MUIA_Listview_List, VolumelistObject, 
								InputListFrame, End,
								End,
					  Child, BT_Parent = KeyButton("Mutter", 'm'),
					  End,
					End,
  			        Child, PopupArg(ST_File, String(DVIFileBuffer,sizeof(DVIFileBuffer)), IM_File, MUII_PopFile, &FilePopupHook, POP_FILE),
  			        End,
  			      End,
  			    End,
  			  
  			  Child, VSpace(2),

                          Child, HGroup,
 			    Child, BT_Save   = KeyButton("Speichern", 's'), 
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, BT_Print  = KeyButton("Drucken", 'd'), 
 			    Child, HSpace(0),
 			    Child, HSpace(0),
 			    Child, BT_Cancel = KeyButton("Abbrechen", 'a'), 
 			    End,

	                End,
		End,
		
	   End;


  if (!Applic) fail(Applic, "Failed to create application.");

 
  /*
  ** Ein paar Gadgets disable'n
  */
  set(ST_Output, MUIA_Disabled, TRUE);
  set(IM_Output, MUIA_Disabled, TRUE);
  DoMethod(CY_Output,MUIM_Notify,MUIA_Cycle_Active,0,ST_Output,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_Output,MUIM_Notify,MUIA_Cycle_Active,0,IM_Output,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_Output,MUIM_Notify,MUIA_Cycle_Active,1,ST_Output,3,MUIM_Set,MUIA_Disabled,FALSE);
  DoMethod(CY_Output,MUIM_Notify,MUIA_Cycle_Active,1,IM_Output,3,MUIM_Set,MUIA_Disabled,FALSE);
  DoMethod(CY_Output,MUIM_Notify,MUIA_Cycle_Active,2,ST_Output,3,MUIM_Set,MUIA_Disabled,FALSE);
  DoMethod(CY_Output,MUIM_Notify,MUIA_Cycle_Active,2,IM_Output,3,MUIM_Set,MUIA_Disabled,FALSE);

  set(ST_Width,  MUIA_Disabled, TRUE);	/* in der Initialisierung geht es nicht */
  set(ST_Height, MUIA_Disabled, TRUE);
  DoMethod(CY_PgSize,MUIM_Notify,MUIA_Cycle_Active,0,ST_Width,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_PgSize,MUIM_Notify,MUIA_Cycle_Active,0,ST_Height,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_PgSize,MUIM_Notify,MUIA_Cycle_Active,1,ST_Width,3,MUIM_Set,MUIA_Disabled,FALSE);
  DoMethod(CY_PgSize,MUIM_Notify,MUIA_Cycle_Active,1,ST_Height,3,MUIM_Set,MUIA_Disabled,FALSE);

  set(ST_XReso, MUIA_Disabled, TRUE);
  set(ST_YReso, MUIA_Disabled, TRUE);
  DoMethod(CY_Reso,MUIM_Notify,MUIA_Cycle_Active,0,ST_XReso,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_Reso,MUIM_Notify,MUIA_Cycle_Active,0,ST_YReso,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_Reso,MUIM_Notify,MUIA_Cycle_Active,1,ST_XReso,3,MUIM_Set,MUIA_Disabled,FALSE);
  DoMethod(CY_Reso,MUIM_Notify,MUIA_Cycle_Active,1,ST_YReso,3,MUIM_Set,MUIA_Disabled,FALSE);
  
  set(ST_BMem, MUIA_Disabled, TRUE);
  DoMethod(CY_BMem,MUIM_Notify,MUIA_Cycle_Active,0,ST_BMem,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CY_BMem,MUIM_Notify,MUIA_Cycle_Active,1,ST_BMem,3,MUIM_Set,MUIA_Disabled,FALSE);
  
  set(IM_Logf, MUIA_Disabled, TRUE);
  set(ST_Logf, MUIA_Disabled, TRUE);
  DoMethod(CH_Logf,MUIM_Notify,MUIA_Selected,FALSE,IM_Logf,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CH_Logf,MUIM_Notify,MUIA_Selected,FALSE,ST_Logf,3,MUIM_Set,MUIA_Disabled,TRUE);
  DoMethod(CH_Logf,MUIM_Notify,MUIA_Selected,TRUE,IM_Logf,3,MUIM_Set,MUIA_Disabled,FALSE);
  DoMethod(CH_Logf,MUIM_Notify,MUIA_Selected,TRUE,ST_Logf,3,MUIM_Set,MUIA_Disabled,FALSE);
  
  


  /*
  ** This one makes us receive input ids from several list views.
  */

  DoMethod(LV_PrtLst,MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,Applic,2,MUIM_Application_ReturnID,ID_NEWPRT);


  /*
  ** Now lets set the TAB cycle chain for some of our windows.
  */

  DoMethod(WI_Main,MUIM_Window_SetCycleChain,CY_Seiten,ST_von,ST_bis,ST_num,ST_Kopien,CY_ZuDruck,CY_Reihenf,CY_SeitenM,CY_Orient,BT_Drucker,BT_MiscPre,ST_File,IM_File,LV_Files,BT_Parent,LV_Volumes,NULL);
  DoMethod(WI_Printer,MUIM_Window_SetCycleChain,LV_PrtLst,CY_DrModus,CY_Density,CY_Optimize,ST_HOffset,ST_VOffset,CY_Output,ST_Output,IM_Output,CY_FormFeed,CY_Direct,CY_DevMode,CY_PgSize,ST_Width,ST_Height,CY_Reso,ST_XReso,ST_YReso,NULL);
  DoMethod(WI_Sonst,MUIM_Window_SetCycleChain,ST_FDir,ST_Prio,CH_Logf,ST_Logf,IM_Logf,CY_BMem,ST_BMem,ST_FMem,IM_PreL,IM_Mark,IM_Stat,IM_Acco,NULL);
  
  DoMethod(ST_von, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Main, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_bis);
  DoMethod(ST_bis, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Main, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_num);
  DoMethod(ST_num, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Main, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_Kopien);
  DoMethod(ST_Kopien, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Main, 3, MUIM_Set, MUIA_Window_ActiveObject, CY_ZuDruck);

  DoMethod(ST_von, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, CY_Seiten, 3, MUIM_Set, MUIA_Cycle_Active, 1);
  DoMethod(ST_bis, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, CY_Seiten, 3, MUIM_Set, MUIA_Cycle_Active, 1);

  DoMethod(CY_Seiten, MUIM_Notify, MUIA_Cycle_Active, 0, ST_von, 3, MUIM_Set, MUIA_String_Contents, NULL);
  DoMethod(CY_Seiten, MUIM_Notify, MUIA_Cycle_Active, 0, ST_bis, 3, MUIM_Set, MUIA_String_Contents, NULL);
  DoMethod(CY_Seiten, MUIM_Notify, MUIA_Cycle_Active, 1, WI_Main, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_von);

  DoMethod(ST_HOffset, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Printer, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_VOffset);
  DoMethod(ST_VOffset, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Printer, 3, MUIM_Set, MUIA_Window_ActiveObject, CY_Output);
  DoMethod(ST_Width, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Printer, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_Height);
  DoMethod(ST_Height, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Printer, 3, MUIM_Set, MUIA_Window_ActiveObject, CY_Reso);
  DoMethod(ST_XReso, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Printer, 3, MUIM_Set, MUIA_Window_ActiveObject, ST_YReso);
  DoMethod(ST_YReso, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, WI_Printer, 3, MUIM_Set, MUIA_Window_ActiveObject, LV_PrtLst);


 /*
  ** Lets bind the sub windows to the corresponding button
  ** of the master window.
  */

  DoMethod(BT_Drucker,MUIM_Notify,MUIA_Pressed,FALSE,WI_Printer,3,MUIM_Set,MUIA_Window_Open,TRUE);
  DoMethod(BT_MiscPre,MUIM_Notify,MUIA_Pressed,FALSE,WI_Sonst,3,MUIM_Set,MUIA_Window_Open,TRUE);
  DoMethod(BT_Print,MUIM_Notify,MUIA_Pressed,FALSE,Applic,2,MUIM_Application_ReturnID,ID_RUNPRINT);

  DoMethod(BT_PRTuse,MUIM_Notify,MUIA_Pressed,FALSE,Applic,2,MUIM_Application_ReturnID,ID_PRTUSE);
  DoMethod(BT_SONuse,MUIM_Notify,MUIA_Pressed,FALSE,Applic,2,MUIM_Application_ReturnID,ID_SONUSE);

  DoMethod(BT_PRTcancel,MUIM_Notify,MUIA_Pressed,FALSE,          Applic,2,MUIM_Application_ReturnID,ID_PRTCANCEL);
  DoMethod(BT_SONcancel,MUIM_Notify,MUIA_Pressed,FALSE,          Applic,2,MUIM_Application_ReturnID,ID_SONCANCEL);
  DoMethod(WI_Printer,MUIM_Notify,MUIA_Window_CloseRequest,TRUE, Applic,2,MUIM_Application_ReturnID,ID_PRTCANCEL);
  DoMethod(WI_Sonst,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,   Applic,2,MUIM_Application_ReturnID,ID_SONCANCEL);


  /*
  ** This one makes us receive input ids from several list views.
  */

  DoMethod(LV_Volumes ,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,Applic,2,MUIM_Application_ReturnID,ID_NEWVOLUME);
  DoMethod(LV_Files,MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,Applic,2,MUIM_Application_ReturnID,ID_NEWFILE);
  DoMethod(LV_Files,MUIM_Notify,MUIA_Listview_DoubleClick,TRUE,Applic,2,MUIM_Application_ReturnID,ID_DOUBLENEWFILE);
  DoMethod(BT_Parent,MUIM_Notify,MUIA_Pressed,FALSE,Applic,2,MUIM_Application_ReturnID,ID_MUTTER);
  DoMethod(ST_File,MUIM_Notify,MUIA_String_Acknowledge, MUIV_EveryTime,Applic,2,MUIM_Application_ReturnID,ID_DVIFILE);

  DoMethod(LV_PrtLst,MUIM_Notify,MUIA_List_Active,MUIV_EveryTime,Applic,2,MUIM_Application_ReturnID,ID_NEWPRT);


  DoMethod(ST_HOffset, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, Applic, 2, MUIM_Application_ReturnID, ID_HOFF);
  DoMethod(ST_VOffset, MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, Applic, 2, MUIM_Application_ReturnID, ID_VOFF);
  DoMethod(ST_Width,   MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, Applic, 2, MUIM_Application_ReturnID, ID_WIDTH);
  DoMethod(ST_Height,  MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime, Applic, 2, MUIM_Application_ReturnID, ID_HEIGHT);



 /*
  ** Automagically remove a window when the user hits the close gadget.
  */

  DoMethod(WI_PrtRun,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,  Applic,2,MUIM_Application_ReturnID,ID_CANCELPRINT);


  /*
  ** Closing the master window forces a complete shutdown of the application.
  */

  DoMethod(WI_Main,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,Applic,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
  DoMethod(BT_Cancel,MUIM_Notify,MUIA_Pressed,FALSE,Applic,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
  
  DoMethod(WI_Main,    MUIM_Notify,MUIA_Window_InputEvent, "control c", Applic,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
  DoMethod(WI_Sonst,   MUIM_Notify,MUIA_Window_InputEvent, "control c", Applic,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
  DoMethod(WI_Printer, MUIM_Notify,MUIA_Window_InputEvent, "control c", Applic,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);



  /*
  ** Set some start values for certain objects.
  */


  
  set(TX_PrtFile,MUIA_Text_Contents,"work:diplo/maus.dvi");
  
  /* WI_Main mit defaults belegen */
  /*SetupWIMAIN(); */
  DoMethod(LV_PrtLst,MUIM_List_Insert,LVT_PrtLst,-1,MUIV_List_Insert_Bottom);
  
  set(TX_Drucker, MUIA_Text_Contents, "DeskJet 300 dpi");
  CurPrtNum = 1;
  set(LV_PrtLst, MUIA_List_Active, CurPrtNum);

  /*SetupWIPRINTER(); */

  /*UsePrinter(CurPrtNum); */

	
  /*
  ** Everything's ready, lets launch the application. We will
  ** open the master window now.
  */

  set(WI_Main,MUIA_Window_Open,TRUE);

  {
    ULONG signal, retsig;
    BOOL running = TRUE;
    char * buf, * cptr;
    BPTR lock;
    __aligned struct FileInfoBlock * pfib;
    int id;
    
    while (running) {
      id = DoMethod(Applic,MUIM_Application_Input,&signal);
      switch (id) {
  	  case MUIV_Application_ReturnID_Quit:
 		running = FALSE;
  		break;

  	  case ID_ABOUT:
  		MUI_Request(Applic, WI_Main, 0, NULL, "OK", "DVIprint MUI-Demo\n© 1993 by Georg Heßmann");
  		break;

  	  case ID_NEWFILE:
 	        get(LV_Files,MUIA_Dirlist_Path, &buf);
	        strncpy(DVIFileBuffer, buf, sizeof(DVIFileBuffer)-1);
  	        set(ST_File,MUIA_String_Contents,DVIFileBuffer);
		break;

	  case ID_DOUBLENEWFILE:
		DoMethod(LV_Files,MUIM_List_GetEntry,-1,&pfib);
 	        get(LV_Files,MUIA_Dirlist_Path, &buf);
	        strncpy(DVIFileBuffer, buf, sizeof(DVIFileBuffer)-1);
  	        set(ST_File,MUIA_String_Contents,DVIFileBuffer);
		if (pfib->fib_DirEntryType > 0) {
		  set(LV_Files,MUIA_Dirlist_Directory,buf);
		}
		break;

	  case ID_NEWVOLUME:
		DoMethod(LV_Volumes,MUIM_List_GetEntry,-1,&buf);
		set(LV_Files,MUIA_Dirlist_Directory,buf);
		break;

	  case ID_MUTTER:
		DoMethod(LV_Files,MUIM_List_GetEntry,-1,&pfib);
  	        get(ST_File,MUIA_String_Contents,&buf);
	        strncpy(DVIFileBuffer, buf, sizeof(DVIFileBuffer)-1);
  	        cptr = strrchr(DVIFileBuffer, '/');
		if (pfib->fib_DirEntryType < 0 && cptr) {
		  *cptr = '\0';
		  cptr = strrchr(DVIFileBuffer, '/');
		}
  	        if (!cptr) cptr = strchr(DVIFileBuffer, ':');
  	        if (cptr) {
                  if (*cptr == ':') cptr++;
  	          *cptr = '\0';
  	        }
  	        set(ST_File,MUIA_String_Contents,DVIFileBuffer);
		set(LV_Files,MUIA_Dirlist_Directory,DVIFileBuffer);
		break;

	  case ID_DVIFILE:
  	        get(ST_File,MUIA_String_Contents,&buf);
	        lock = Lock(buf, ACCESS_READ);
	        if (!lock) {
   	          set(ST_File,MUIA_String_Contents,DVIFileBuffer);
	        }
	        else {
	          UnLock(lock);
	          lock = NULL;
	          strncpy(DVIFileBuffer, buf, sizeof(DVIFileBuffer)-1);
	          set(LV_Files, MUIA_Dirlist_Directory, DVIFileBuffer);
	        }
	        break;

	  case ID_NEWPRT:
		get(LV_PrtLst,MUIA_List_Active,&CurPrtNum);
		set(TX_Printer,MUIA_Text_Contents,LVT_PrtLst[CurPrtNum]);
		/*SetPrinterTo(CurPrtNum); */
		break;

	  case ID_PRTUSE:		/* Use Druckereinstellfenster */
	        if (TRUE /*CheckPrinter()*/) {
	          /* all values correct? */
	          /* wenn nicht dann bleibt das Fenster offen und der erste falsche Wert wird aktiv */
		  /*UsePrinter(CurPrtNum); */
		  set(WI_Printer,MUIA_Window_Open,FALSE);
		}
		break;

	  case ID_PRTCANCEL:		/* Cancel Druckereinstellfenster */
	    	set(WI_Printer,MUIA_Window_Open,FALSE);
		/*SetupWIPRINTER(); */
		break;

	  case ID_SONUSE:		/* Use Sonstiges Einstellfenster */
		set(WI_Sonst,MUIA_Window_Open,FALSE);
		break;
	  
	  case ID_SONCANCEL:
	    	set(WI_Sonst,MUIA_Window_Open,FALSE);
	  	break;

	  case ID_RUNPRINT:		/* Starte Ausdruck */
		set(WI_Main,MUIA_Window_Sleep,TRUE);
		set(WI_Printer,MUIA_Window_Sleep,TRUE);
		set(WI_Sonst,MUIA_Window_Sleep,TRUE);
		set(WI_PrtRun,MUIA_Window_Open,TRUE);
		break;

	  case ID_CANCELPRINT:		/* Stoppe Ausdruck */
		set(WI_Main,MUIA_Window_Sleep,FALSE);
		set(WI_Printer,MUIA_Window_Sleep,FALSE);
		set(WI_Sonst,MUIA_Window_Sleep,FALSE);
		set(WI_PrtRun,MUIA_Window_Sleep,FALSE);
		set(WI_PrtRun,MUIA_Window_Open,FALSE);
		break;

	  case ID_HOFF:			/* 'nutzer hat in ST_HOffset... Return geklickt */
	  case ID_VOFF:
	  case ID_WIDTH:
	  case ID_HEIGHT:
	        /* Test ob korrekter Wert... */
	        {
	          /*int i; */
	          /*float f; */
	          APTR obj;
	          
  	          switch (id) {
	            case ID_HOFF:	obj = ST_HOffset; break;
	            case ID_VOFF:	obj = ST_VOffset; break;
	            case ID_WIDTH:	obj = ST_Width;	  break;
	            case ID_HEIGHT:	obj = ST_Height;  break;
	          }
  	          get(obj,MUIA_String_Contents,&buf);
	          if (FALSE /*dimen_to_inch(buf, &f, &i)*/) {	/* test for correct TeX dimension */
	            /* ist kein richtiger Offset! */
	            set(WI_Printer, MUIA_Window_ActiveObject, obj);
	          }
	        }
	        break;
      }
      if (signal) retsig = Wait(signal | SIGBREAKF_CTRL_C);

      if (retsig & SIGBREAKF_CTRL_C) running = FALSE;
    }
  }


  /*
  ** Call the fail function in demos.h, this will dispose the
  ** application object and close "muimaster.library".
  */

  fail(Applic,NULL);
}
