/****************************************************************************
*      Projet                    :
*      Fichier                   :
*
*      Nom Prog                  :
*      Version                   :
*      Date de conception        :  19 Octobre 2002
*      Dernière modification     :
*
*      Description               :
*
*      Auteurs                   :  Stephane SARAGAGLIA
*
*      Plateforme                :  A1200 Mc68060/PPC603e
*      Systeme                   :  AmigaOS 3.5
*
*      Programming language      :
*
*          Copyright (C) Stephane SARAGAGLIA - (All rights reserved)
*
****************************************************************************/

/****************************************************************************
 * INCLUDES.
 ****************************************************************************/
// --------------------------------------------------------------------------
// C LIB
// --------------------------------------------------------------------------
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <exec/memory.h>

#include <proto/exec.h>
#include <proto/alib.h>           //HookEntry()
#include <proto/dos.h>
#include <proto/graphics.h>
#include <proto/muimaster.h>

#include <clib/debug_protos.h> //SS-TBD to be removed

#include <libraries/mui.h>
#include <libraries/gadtools.h>


#ifdef __MORPHOS__
#include <ppcinline/muimaster.h>        // PPC MACROS
#endif

#include <mui/Toolbar_mcc.h>

// --------------------------------------------------------------------------
// MUI LIB
// --------------------------------------------------------------------------
#include <MUI/TextEditor_mcc.h>

// --------------------------------------------------------------------------
// SS LIB
// --------------------------------------------------------------------------
#include "SSMisc_protos.h"
#include "SSListLib_protos.h"
#include "SSStrLib_protos.h"

// --------------------------------------------------------------------------
// AMD LIB
// --------------------------------------------------------------------------
#include "ss_amiga_lib_tools_protos.h"
#include "ss_lib_tools_protos.h"
#include "AMD_CatStrings.h"
#include "AMD_Gui.h"

/****************************************************************************
 * DEFINES.
 ****************************************************************************/
#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#ifdef _DCC
#define __inline
#endif

#define AMD_TE_COLS_MIN 50

#ifdef __MORPHOS__
#define AMD_VERSION "AMuiDiff 1.0 MOS Version "
#else
#define AMD_VERSION "AMuiDiff 1.0 AOS 68k Version "
#endif
#define AMD_DATE        "21 Mars 2004"

/****************************************************************************
 * TYPES.
 ****************************************************************************/
typedef struct
{
	long  ce_line;
	char *ce_title;
}cycle_entry_t;

/****************************************************************************
 * VARIABLES GLOBALES .
 ****************************************************************************/
static struct NewMenu MenuData[] =  // Be carefull, labels are inited in the AmdGui constructor
{
	{ NM_TITLE, "" , 0 ,0 ,0             ,(APTR)MEN_PROJET      },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_OUVRIR1     },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_OUVRIR2     },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_RELOAD1     },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_RELOAD2     },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_EDIT1     },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_EDIT2     },
	{ NM_ITEM , "" , 0, 0 ,0             ,(APTR)MEN_APROPOS     },
	{ NM_ITEM , "" ,"Q",0 ,0             ,(APTR)MEN_QUITTER     },
	{ NM_END,NULL,0,0,0,(APTR)0 },
};

typedef enum
{
	AMD_TB_FILE_OPEN   = 0,
	AMD_TB_FILE_RELOAD,
	AMD_TB_FILE_EDIT,
} ToolBarFileId;
typedef enum
{
	AMD_TB_MERGE_SWAP = 0,
} ToolBarMergeId;
static struct MUIP_Toolbar_Description ToolBarFile1[] =        //SS-TBD : voir par quoi remplacer les shortkeys
{
	Toolbar_KeyButton(0, 		(char*)AMD_ToolBarOpen,   'o'),
	Toolbar_KeyButton(0, 		(char*)AMD_ToolBarReload,   'r'),
	Toolbar_KeyButton(0, 		(char*)AMD_ToolBarEdit,   'e'),
//	  Toolbar_KeyButton(TDF_GHOSTED,  (char*)AMD_ToolBarSave,   's'),
	Toolbar_End
};

static struct MUIP_Toolbar_Description ToolBarFile2[] =
{
	Toolbar_KeyButton(0, 		(char*)AMD_ToolBarOpen,   'o'),
	Toolbar_KeyButton(0, 		(char*)AMD_ToolBarReload,   'r'),
	Toolbar_KeyButton(0, 		(char*)AMD_ToolBarEdit,   'e'),
//	  Toolbar_KeyButton(TDF_GHOSTED,  (char*)AMD_ToolBarSave,   's'),
	Toolbar_End
};

static struct MUIP_Toolbar_Description ToolBarMerge[] =
{
	Toolbar_KeyButton(0, "<=>",   'g'),
	Toolbar_End
};


char *StartTeBuffer    = NULL;
char *StrAboutAuthor   = NULL;
char *StrAboutVersion  = NULL;
char *StrAboutCompDate = NULL;



/****************************************************************************
 * HOOKS MUI
 ****************************************************************************/
extern "C"
{
	extern BOOL IsFontFixed;

	extern LONG	       cmap[8];
#ifdef __MORPHOS__
	extern struct EmulLibEntry GATETextEditor_Dispatcher;
#else
	extern ULONG TextEditor_Dispatcher (register struct IClass *cl, register Object *obj, register struct MUIP_TextEditor_HandleError *msg);
#endif


extern void AmdCycleHookFunc(void);
extern LONG AmdDragDropHookFunc(struct Hook *hook, Object *obj, struct AppMessage **apmsg);

extern void AmdReqRefreshHookFunc(struct Hook *hook, struct FileRequester *req, struct IntuiMessage *imsg);
}

/****************************************************************************
 * SIGNATURES DES FONCTIONS
 ****************************************************************************/


static struct Hook AmdCycleHook = { {NULL,NULL}, (HOOKFUNC) HookEntry, (HOOKFUNC)AmdCycleHookFunc, NULL };
static struct Hook DragDropHook = { {NULL,NULL}, (HOOKFUNC) HookEntry, (HOOKFUNC)AmdDragDropHookFunc, NULL };

static const struct Hook ReqRefreshHook = { { 0,0 },(HOOKFUNC)HookEntry,(HOOKFUNC)AmdReqRefreshHookFunc,NULL };



LONG TEmemcpy(char *pm_dest, const char *pm_src, ULONG pm_nbchars, const char *pm_colortoken);

extern "C" void AmdCycleHookFuncCpp(void *pm_obj, ULONG pm_itemnumber);
extern "C" LONG AmdDragDropHookFuncCpp(void *pm_app, Object *pm_scroll, char *pm_filename);
static void AmdFreeCycleEntry(void *pm_cycle_entry);
static void AmdFreeChunkEntry(void *pm_cycle_entry);

/****************************************************************************
 * DEFINITION DES FONCTIONS/METHODES
 ****************************************************************************/

/****************************************************************************
 * Classe AmdGui
 ****************************************************************************/

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
AmdGui::AmdGui()
{
	APTR	GROUP_ROOT_0, GR_acces_differences, GR_vues_la;
	APTR	GR_vues_te, GR_labels, LA_label_ligns_ajoutees;
	APTR	LA_label_ligns_effacees, LA_label_ligns_modifiees;
	Object  *bt_diff = NULL;

	APTR    text1, frame1, scroll1;
	APTR    text2, frame2, scroll2;

	Object	*wi_main_window = NULL;
	Object	*mn_main_menu = NULL;
	Object	*tb_merge = NULL;

	Object  *bt_file1 = NULL;
	Object  *bt_file2 = NULL;

	struct Window *win = NULL;

	amd_slider_vue1_vertical = NULL;
	amd_slider_vue2_vertical = NULL;
	amd_str_fichier1         = NULL;
	amd_str_fichier2         = NULL;
	amd_tb_toolbar1          = NULL;
	amd_tb_toolbar1          = NULL;

	amd_state = AMD_ERROR;

SSDEBUG("AmdGui : entry\n");

	// -------------------
	// Initialisations
	// -------------------

	// Menu labels
	// -------------------
	MenuData[0].nm_Label = (char*)AMD_MenuProject;
	MenuData[1].nm_Label = (char*)AMD_MenuOpenFile1;
	MenuData[2].nm_Label = (char*)AMD_MenuOpenFile2;
	MenuData[3].nm_Label = (char*)AMD_MenuReloadFile1;
	MenuData[4].nm_Label = (char*)AMD_MenuReloadFile2;
	MenuData[5].nm_Label = (char*)AMD_MenuEditFile1;
	MenuData[6].nm_Label = (char*)AMD_MenuEditFile2;
	MenuData[7].nm_Label = (char*)AMD_MenuAbout;
	MenuData[8].nm_Label = (char*)AMD_MenuExit;

	// ToolBar labels
	// -------------------
	ToolBarFile1[0].ToolText = (char*)AMD_ToolBarOpen;
	ToolBarFile1[1].ToolText = (char*)AMD_ToolBarReload;
	ToolBarFile1[2].ToolText = (char*)AMD_ToolBarEdit;
	ToolBarFile1[3].ToolText = (char*)AMD_ToolBarSave;
	ToolBarFile2[0].ToolText = (char*)AMD_ToolBarOpen;
	ToolBarFile2[1].ToolText = (char*)AMD_ToolBarReload;
	ToolBarFile2[2].ToolText = (char*)AMD_ToolBarEdit;
	ToolBarFile2[3].ToolText = (char*)AMD_ToolBarSave;

	// Make the TextEditor.mcc class
	// -------------------
#ifdef __MORPHOS__
	if((amd_editor_mcc = MUI_CreateCustomClass(NULL, "TextEditor.mcc", NULL, 0, &GATETextEditor_Dispatcher)) == NULL)
#else
	if((amd_editor_mcc = MUI_CreateCustomClass(NULL, "TextEditor.mcc", NULL, 0, TextEditor_Dispatcher)) == NULL)
#endif 
	{
		return;
	}
SSDEBUG("AmdGui : pass1\n");

	// ===================
	// Gadgets creation
	// ===================

	// Cycle gadget
	// -------------------
	amd_cy_diff_entries = NULL;
	amd_cy_diff = CycleObject,
		MUIA_HelpNode, AMD_CycleHelp,
		MUIA_Cycle_Entries, amd_cy_diff_entries,
	End;
	reset_cycle(); // To put cycle height to font size
SSDEBUG("AmdGui : pass2\n");

	// -------------------
	// Views
	// -------------------

	// Slider gadget
	// -------------------
	amd_slider_vue1_vertical = ScrollbarObject, End;
	amd_slider_vue2_vertical = ScrollbarObject, End;

	// TextEditor 1 gadgets
	// -------------------
	StartTeBuffer = (char*)ss_strdup5(AMD_VERSION, "\n", (const char*)AMD_Author," : Stéphane SARAGAGLIA\n\n", (const char*)AMD_StartState);
	if(StartTeBuffer == NULL) goto AmdGui_error;
	text1 = NewObject(amd_editor_mcc->mcc_Class, NULL,
										MUIA_TextEditor_ColorMap, cmap,
										MUIA_TextEditor_ReadOnly, TRUE,
										MUIA_TextEditor_Contents, StartTeBuffer,
										MUIA_TextEditor_Slider, amd_slider_vue1_vertical,
										MUIA_TextEditor_Columns, AMD_TE_COLS_MIN,
										MUIA_TextEditor_InVirtualGroup, TRUE,
										MUIA_Font, (IsFontFixed == TRUE) ? MUIV_Font_Fixed : MUIV_Font_Inherit,
			End;
	frame1 = VirtgroupObject,
				NoFrame,
				Child, text1,
			End;
	scroll1 =	ScrollgroupObject,
					MUIA_Scrollgroup_UseWinBorder, TRUE,
					MUIA_Scrollgroup_Contents, frame1,
				End;

	// TextEditor 2 gadgets
	// -------------------
	text2 = NewObject(amd_editor_mcc->mcc_Class, NULL,
										MUIA_TextEditor_ColorMap, cmap,
										MUIA_TextEditor_ReadOnly, TRUE,
										MUIA_TextEditor_Contents, StartTeBuffer,
										MUIA_TextEditor_Slider, amd_slider_vue2_vertical,
										MUIA_TextEditor_Columns, AMD_TE_COLS_MIN,
										MUIA_TextEditor_InVirtualGroup, TRUE,
										MUIA_Font, (IsFontFixed == TRUE) ? MUIV_Font_Fixed : MUIV_Font_Inherit,
			End;
	frame2 = VirtgroupObject,
				NoFrame,
				Child, text2,
			End;
	scroll2 =	ScrollgroupObject,
					MUIA_Scrollgroup_UseWinBorder, TRUE,
					MUIA_Scrollgroup_Contents, frame2,
				End;

SSDEBUG("AmdGui : pass3\n");

	// View Group TextEditors gadget
	// -------------------
	GR_vues_te = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, scroll1,
		Child, amd_slider_vue1_vertical,
		Child, amd_slider_vue2_vertical,
		Child, scroll2,
	End;

	// -------------------
	// Buttons
	// -------------------

	// Gadgets
	// -------------------
	amd_str_fichier1 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_String_Contents, "",
		MUIA_String_MaxLen, 1024,
	End;

    bt_diff = TextObject,
		ButtonFrame,
		MUIA_Weight, 20,
		MUIA_Background, MUII_ButtonBack,
		MUIA_Text_Contents, AMD_ButtonDiff,
		MUIA_Text_PreParse, "\033c",
		MUIA_InputMode, MUIV_InputMode_RelVerify,
	End;

	amd_str_fichier2 = StringObject,
		MUIA_Frame, MUIV_Frame_String,
		MUIA_String_Contents, "",
		MUIA_String_MaxLen, 1024,
	End;

	// View Group Labels gadget
	// -------------------
	GR_vues_la = GroupObject,
		MUIA_Group_Horiz, TRUE,
		Child, amd_str_fichier1,
		Child, bt_file1 = PopButton(MUII_PopFile),
	    Child, bt_diff,
		Child, amd_str_fichier2,
		Child, bt_file2 = PopButton(MUII_PopFile),
	End;

	// -------------------
	// Info labels gadget
	// -------------------
	amd_txt_nbdiffs = NewObject(amd_editor_mcc->mcc_Class, NULL,
										MUIA_Frame, MUIV_Frame_Text,
										MUIA_TextEditor_ColorMap, cmap,
										MUIA_CycleChain, FALSE,
										MUIA_TextEditor_ReadOnly, TRUE,
										MUIA_TextEditor_Contents, AMD_LabelDiffInit,
										MUIA_TextEditor_Rows,     1,
					  End;

 
	LA_label_ligns_ajoutees = NewObject(amd_editor_mcc->mcc_Class, NULL,
										MUIA_Frame, MUIV_Frame_Text,
										MUIA_TextEditor_ColorMap, cmap,
										MUIA_CycleChain, FALSE,
										MUIA_TextEditor_ReadOnly, TRUE,
										MUIA_TextEditor_Contents, AMD_LabelAdded,
										MUIA_TextEditor_Rows,     1,
					  End;

	LA_label_ligns_effacees = NewObject(amd_editor_mcc->mcc_Class, NULL,
										MUIA_Frame, MUIV_Frame_Text,
										MUIA_TextEditor_ColorMap, cmap,
										MUIA_CycleChain, FALSE,
										MUIA_TextEditor_ReadOnly, TRUE,
										MUIA_TextEditor_Contents, AMD_LabelRemoved,
										MUIA_TextEditor_Rows,     1,
					  End;

	LA_label_ligns_modifiees = NewObject(amd_editor_mcc->mcc_Class, NULL,
										MUIA_Frame, MUIV_Frame_Text,
										MUIA_TextEditor_ColorMap, cmap,
										MUIA_CycleChain, FALSE,
										MUIA_TextEditor_ReadOnly, TRUE,
										MUIA_TextEditor_Contents, AMD_LabelChanged,
										MUIA_TextEditor_Rows,     1,
					  End;

	GR_labels = GroupObject,
		MUIA_Frame, MUIV_Frame_Text,
		MUIA_Group_Horiz, TRUE,
		Child, amd_txt_nbdiffs,
		Child, LA_label_ligns_ajoutees,
		Child, LA_label_ligns_effacees,
		Child, LA_label_ligns_modifiees,
	End;

SSDEBUG("AmdGui : pass4\n");
	// -------------------
	// Main vertical group gadget
	// -------------------
	GR_acces_differences = GroupObject,
		Child, amd_cy_diff,
		Child, HGroup,
			Child, amd_tb_toolbar1 = ToolbarObject,
				// Always specify all the filenames. A user might want to make some
				//	nice (perhaps animated) graphics for the select-image or he might
				//	want to make his own ghost-effect.
				//	If a file doesn't exist then the class simply uses the normal image
				//	and adds the effect which is specified by the user in the preferences.
				//	No images have to exist since the toolbar then just changes to textmode..
				//	Remember to specify the filenames in your documentation.

				MUIA_Toolbar_ImageType, 	  MUIV_Toolbar_ImageType_File,
				MUIA_Toolbar_ImageNormal,	  "PROGDIR:Images/ButtonBank1.bsh",
				MUIA_Toolbar_ImageSelect,	  "PROGDIR:Images/ButtonBank1s.bsh",
				MUIA_Toolbar_ImageGhost,	  "PROGDIR:Images/ButtonBank1g.bsh",
				MUIA_Toolbar_Description,	ToolBarFile1,

				// Default font - this is only used if the user has *not* selected
				//   a fonttype in the toolbar preferences 
				MUIA_Font,	MUIV_Font_Tiny,

				MUIA_ShortHelp, FALSE, // Enable/disable bubblehelp
				MUIA_Draggable, FALSE,
			End,
			Child, RectangleObject, End,
			Child, tb_merge = ToolbarObject,
				// Always specify all the filenames. A user might want to make some
				//	nice (perhaps animated) graphics for the select-image or he might
				//	want to make his own ghost-effect.
				//	If a file doesn't exist then the class simply uses the normal image
				//	and adds the effect which is specified by the user in the preferences.
				//	No images have to exist since the toolbar then just changes to textmode..
				//	Remember to specify the filenames in your documentation.

				MUIA_Toolbar_ImageType, 	  MUIV_Toolbar_ImageType_File,
				MUIA_Toolbar_ImageNormal,	  "PROGDIR:Images/ButtonBank1.bsh",
				MUIA_Toolbar_ImageSelect,	  "PROGDIR:Images/ButtonBank1s.bsh",
				MUIA_Toolbar_ImageGhost,	  "PROGDIR:Images/ButtonBank1g.bsh",
				MUIA_Toolbar_Description,	ToolBarMerge,

				// Default font - this is only used if the user has *not* selected
				//   a fonttype in the toolbar preferences
				MUIA_Font,	MUIV_Font_Tiny,

				MUIA_ShortHelp, FALSE, // Enable/disable bubblehelp
				MUIA_Draggable, FALSE,
			End,
			Child, RectangleObject, End,
			Child, amd_tb_toolbar2 = ToolbarObject,
				// Always specify all the filenames. A user might want to make some
				//	nice (perhaps animated) graphics for the select-image or he might
				//	want to make his own ghost-effect.
				//	If a file doesn't exist then the class simply uses the normal image
				//	and adds the effect which is specified by the user in the preferences.
				//	No images have to exist since the toolbar then just changes to textmode..
				//	Remember to specify the filenames in your documentation.

				MUIA_Toolbar_ImageType, 	  MUIV_Toolbar_ImageType_File,
				MUIA_Toolbar_ImageNormal,	  "PROGDIR:Images/ButtonBank1.bsh",
				MUIA_Toolbar_ImageSelect,	  "PROGDIR:Images/ButtonBank1s.bsh",
				MUIA_Toolbar_ImageGhost,	  "PROGDIR:Images/ButtonBank1g.bsh",
				MUIA_Toolbar_Description,	ToolBarFile2,

				// Default font - this is only used if the user has *not* selected
				//   a fonttype in the toolbar preferences
				MUIA_Font,	MUIV_Font_Tiny,

				MUIA_ShortHelp, FALSE, // Enable/disable bubblehelp
				MUIA_Draggable, FALSE,
			End,
			   End,

		Child, GR_vues_te,
		Child, GR_vues_la,
		Child, GR_labels,
	End;

SSDEBUG("AmdGui : pass5\n");
	// -------------------
	// Root gadget
	// -------------------
	GROUP_ROOT_0 = GroupObject,
		Child, GR_acces_differences,
	End;

	// -------------------
	// Window gadget
	// -------------------
	wi_main_window = WindowObject,
		MUIA_Window_Title,    "AMuiDiff",
		MUIA_Window_Menustrip, mn_main_menu = MUI_MakeObject(MUIO_MenustripNM,MenuData,0),
		MUIA_Window_ID, MAKE_ID('0', 'W', 'I', 'N'),
		MUIA_Window_AppWindow, TRUE, //accept drag and drop of icons
		WindowContents, GROUP_ROOT_0,
			MUIA_Window_UseBottomBorderScroller, TRUE,
			MUIA_Window_UseRightBorderScroller, TRUE,
	End;

SSDEBUG("AmdGui : pass6\n");


	StrAboutAuthor   = (char*)ss_strdup2((char*)AMD_Author, " : Stéphane SARAGAGLIA");
	StrAboutVersion  = (char*)ss_strdup3((char*)AMD_Version, " : " , AMD_VERSION);
	StrAboutCompDate = (char*)ss_strdup3((char*)AMD_CompilationDate, " : ", AMD_DATE);
	if((StartTeBuffer == NULL)||(StrAboutVersion == NULL)||(StrAboutCompDate == NULL)) goto AmdGui_error;

	amd_about_win = WindowObject,
	  MUIA_Window_Title, AMD_AboutWinTitle,
      MUIA_Window_ID, MAKE_ID('C','O','P','Y'),
      WindowContents, VGroup,
		 MUIA_Background, MUII_GroupBack,
		   Child, HCenter((VGroup,
			Child, CLabel(StrAboutAuthor),
			   Child, TextObject,
				  MUIA_Text_Contents, "\033c\033u\0335http://aurora.gotdns.org/amiga/",
            End,
			   Child, TextObject,
				  MUIA_Text_Contents, "\033c\033u\0335saragaglia@ifrance.com",
            End,
            Child, RectangleObject,
               MUIA_Rectangle_HBar, TRUE,
               MUIA_FixHeight, 8,
            End,
			   Child, CLabel(StrAboutVersion),
			   Child, CLabel(StrAboutCompDate),
            Child, RectangleObject,
               MUIA_Rectangle_HBar, TRUE,
               MUIA_FixHeight, 8,
            End,
			Child, CLabel(AMD_AboutToolsIntroduction),
			Child, CLabel("\0338Magic User Interface\0332 (Stefan Stuntz)"),
			Child, CLabel("\0338TextEditor.mcc\0332 (Allan Odgaard)"),
			Child, CLabel("\0338Toolbar.mcc\0332 (Benny Kjær Nielsen, Darius Brewka, Jens Langner)"),
			Child, CLabel(AMD_AboutDiffPart),
		 End)),
				End, End;

SSDEBUG("AmdGui : pass7\n");
	// -------------------
	// Application gadget
	// -------------------
	amd_app = ApplicationObject,
		MUIA_Application_Author, 	  "Stéphane SARAGAGLIA",
		MUIA_Application_Base, 		  "AMuiDiff",
		MUIA_Application_Title,       "AMuiDiff",
		MUIA_Application_Version,     "$VER: "AMD_VERSION"("AMD_DATE")",
		MUIA_Application_Copyright,   "Stéphane SARAGAGLIA",
		MUIA_Application_Description, AMD_AppDescription,
	    SubWindow, wi_main_window,
		SubWindow, amd_about_win,
	End;
	if (amd_app == NULL)
	{
		return;
	}
SSDEBUG("AmdGui : pass8\n");

	SetAttrs(amd_app, MUIA_UserData, this, TAG_DONE);

	// ===================
	// -- Notifications --
	// ===================

	// -------------------
	// Tab cycke chain
	// -------------------
	DoMethod(wi_main_window, MUIM_Window_SetCycleChain, (ULONG)amd_cy_diff, amd_str_fichier1, bt_diff, amd_str_fichier2, 0);

    //-------------------------
	// Button events
    //-------------------------

	// Window Close button
    //-------------------------
	DoMethod(wi_main_window,
		MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		amd_app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);
	DoMethod(amd_about_win, MUIM_Notify, MUIA_Window_CloseRequest, TRUE, amd_about_win, 3, MUIM_Set,MUIA_Window_Open, FALSE);

	// File1 button
    //-------------------------
	DoMethod(bt_file1,
		MUIM_Notify,MUIA_Pressed,FALSE,
		amd_app,2,MUIM_Application_ReturnID,AMD_REQ_FILE1);


	DoMethod(amd_str_fichier1,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		amd_app, 2,
		MUIM_Application_ReturnID,  AMD_FILE1);

	// File2 button
    //-------------------------
	DoMethod(bt_file2,
		MUIM_Notify,MUIA_Pressed,FALSE,
		amd_app,2,MUIM_Application_ReturnID,AMD_REQ_FILE2);

	DoMethod(amd_str_fichier2,
		MUIM_Notify, MUIA_String_Acknowledge, MUIV_EveryTime,
		amd_app, 2,
		MUIM_Application_ReturnID,  AMD_FILE2);

	// diff button
    //-------------------------
	DoMethod(bt_diff,
		MUIM_Notify,MUIA_Pressed,FALSE,
		amd_app,2,MUIM_Application_ReturnID,AMD_DIFF);

	// Cycle Hook
    //-------------------------
	AmdCycleHook.h_Data = this;
	DoMethod((Object *)amd_cy_diff, MUIM_Notify, MUIA_Cycle_Active, MUIV_EveryTime,
		amd_app, 3, MUIM_CallHook, &AmdCycleHook, MUIV_TriggerValue);


    //-------------------------
	// Drag and Drop
    //-------------------------
	DoMethod((Object *)scroll1,MUIM_Notify,MUIA_AppMessage,MUIV_EveryTime,
			 scroll1,3,MUIM_CallHook,&DragDropHook,MUIV_TriggerValue);

	DoMethod((Object *)scroll2,MUIM_Notify,MUIA_AppMessage,MUIV_EveryTime,
			 scroll2,3,MUIM_CallHook,&DragDropHook,MUIV_TriggerValue);

SSDEBUG("AmdGui : pass9\n");
    //-------------------------
	// ToolBar
    //-------------------------
	DoMethod(amd_tb_toolbar1, MUIM_Toolbar_Notify, AMD_TB_FILE_OPEN, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_REQ_FILE1);
	DoMethod(amd_tb_toolbar2, MUIM_Toolbar_Notify, AMD_TB_FILE_OPEN, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_REQ_FILE2);
	DoMethod(amd_tb_toolbar1, MUIM_Toolbar_Notify, AMD_TB_FILE_RELOAD, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_RELOAD1);
	DoMethod(amd_tb_toolbar2, MUIM_Toolbar_Notify, AMD_TB_FILE_RELOAD, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_RELOAD2);
	DoMethod(amd_tb_toolbar1, MUIM_Toolbar_Notify, AMD_TB_FILE_EDIT, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_EDIT1);
	DoMethod(amd_tb_toolbar2, MUIM_Toolbar_Notify, AMD_TB_FILE_EDIT, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_EDIT2);
	DoMethod(tb_merge, MUIM_Toolbar_Notify, AMD_TB_MERGE_SWAP, MUIV_Toolbar_Notify_Pressed, FALSE,
			 amd_app, 2, MUIM_Application_ReturnID, AMD_SWAP);

	//-------------------------
	// The cycle gadget is the active gadget
    //-------------------------
	SetAttrs(wi_main_window,MUIA_Window_ActiveObject,amd_cy_diff,TAG_DONE);

	// Init internal lists
    //-------------------------
	ss_lst_Init(&diff_cycle_list);

	// -------------------
	// Init user view area : amd_files
	// -------------------
	amd_file1 = new AmdFile((Object*)scroll1, (Object*)frame1, (Object*)text1, amd_str_fichier1);
	amd_file2 = new AmdFile((Object*)scroll2, (Object*)frame2, (Object*)text2, amd_str_fichier2);
	if((amd_file1 == NULL)||(amd_file2 == NULL))
	{
		return;
	}
SSDEBUG("AmdGui : pass10\n");
	// -------------------
	// Open Windows
	// -------------------
    SetAttrs(wi_main_window, MUIA_Window_Open, TRUE, TAG_DONE);
SSDEBUG("AmdGui : pass10.1\n");
	SetAttrs(amd_about_win, MUIA_Window_Open, FALSE, TAG_DONE);
SSDEBUG("AmdGui : pass10.2\n");

	// -------------------
	// Create requester
	// -------------------
	GetAttr(MUIA_Window_Window, wi_main_window, (ULONG*)(&win)); // Get window struct from window object
SSDEBUG("AmdGui : pass10.3\n");
	if(win == NULL)
		goto AmdGui_error;

	if(NEW_sslib_filereq(&amd_file_req1, win, (const char*)AMD_ReqChoose, NULL, &ReqRefreshHook, (ULONG)amd_app) != 0)
		goto AmdGui_error;
	if(NEW_sslib_filereq(&amd_file_req2, win, (const char*)AMD_ReqChoose, NULL, &ReqRefreshHook, (ULONG)amd_app) != 0)
		goto AmdGui_error;


SSDEBUG("AmdGui : pass11\n");
	amd_state = AMD_OK;
	return;

AmdGui_error:
//SS-TBD handle releasing...
//	  freeCycle();
SSDEBUG("AmdGui : pass12\n");
	amd_state = AMD_ERROR;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
AmdGui::~AmdGui()
{
SSDEBUG("~AmdGui: entry\n");

	DEL_sslib_filereq(&amd_file_req1);
	DEL_sslib_filereq(&amd_file_req2);

SSDEBUG("~AmdGui: pass1\n");

    //-------------------------
	// Release nb cycle diffs
    //-------------------------
	freeCycle();
SSDEBUG("~AmdGui: pass2\n");

    //-------------------------
	// Release old Cycle and Chunk entry list
    //-------------------------
	ss_lst_VideEtLibereNoeuds(&diff_cycle_list, AmdFreeCycleEntry);
	amd_file1->resetViewBufferChunkList();
	amd_file2->resetViewBufferChunkList();
SSDEBUG("~AmdGui: pass3\n");

    //-------------------------
	// Release application and editor_mcc
    //-------------------------
	MUI_DisposeObject((Object *)amd_app);
SSDEBUG("~AmdGui: pass4\n");
	if((amd_editor_mcc) != NULL)  MUI_DeleteCustomClass(amd_editor_mcc);
SSDEBUG("~AmdGui: pass5\n");

	if(amd_file1 != NULL) delete amd_file1;
	if(amd_file2 != NULL) delete amd_file2;

	if(StartTeBuffer != NULL)    {free(StartTeBuffer);    StartTeBuffer = NULL;}
	if(StrAboutAuthor != NULL)   {free(StrAboutAuthor);   StrAboutAuthor = NULL;}
	if(StrAboutVersion != NULL)  {free(StrAboutVersion);  StrAboutVersion = NULL;}
	if(StrAboutCompDate != NULL) {free(StrAboutCompDate); StrAboutCompDate = NULL;}
SSDEBUG("~AmdGui: exit\n");
}

// *************************************************************************
//
//
// ************************************
//
// Date et Auteur :      SS, le 
// ******************
//
// Parametres en ENTREE : 
// ******************              
//
//
// Parametres en ENTREE/SORTIE : -
// ******************
//
//
// Parametres en SORTIE : -
// *******************
//
//
// Codes d'erreur : 
// **************
//
//
// Description : 
// **********
//
// *************************************************************************
LONG AmdGui::doButton1Shine(void)
{
	if(amd_tb_toolbar1 == NULL) return -1;
	
	DoMethod(amd_tb_toolbar1, MUIM_Toolbar_Set, 1, MUIV_Toolbar_Set_Selected, TRUE);
	
	return 0;
}
LONG AmdGui::doButton2Shine(void)
{
	if(amd_tb_toolbar2 == NULL) return -1;
	
	DoMethod(amd_tb_toolbar2, MUIM_Toolbar_Set, 1, MUIV_Toolbar_Set_Selected, TRUE);
	
	return 0;
}
LONG AmdGui::doButton1Background(void)
{
	if(amd_tb_toolbar1 == NULL) return -1;

	DoMethod(amd_tb_toolbar1, MUIM_Toolbar_Set, 1, MUIV_Toolbar_Set_Selected, FALSE);
	
	return 0;
}
LONG AmdGui::doButton2Background(void)
{
	if(amd_tb_toolbar2 == NULL) return -1;

	DoMethod(amd_tb_toolbar2, MUIM_Toolbar_Set, 1, MUIV_Toolbar_Set_Selected, FALSE);
	
	return 0;
}

// *************************************************************************
//
//
// ************************************
//
// Date et Auteur :      SS, le 10 Novembre 2002
// ******************
//
// Parametres en ENTREE : pm_amdf : The view object in which the file is
// ******************               opened.
//
//
// Parametres en ENTREE/SORTIE : -
// ******************
//
//
// Parametres en SORTIE : -
// *******************
//
//
// Codes d'erreur : 0 : Success, -1 : error : parameter/requester/newfile()
// **************
//
//
// Description : Update the File View with the selected file.
// **********
//
// *************************************************************************
LONG AmdGui::openReqFile1(void)
{
	return openReqFile(get_amdf1(), &amd_file_req1);
}

LONG AmdGui::openReqFile2(void)
{
	return openReqFile(get_amdf2(), &amd_file_req2);
}

LONG AmdGui::openReqFile(AmdFile *pm_amdf, sslib_filereq_t *pm_filereq)
{
	char  *file_to_open = NULL;
	ULONG ret = 0;

	if((pm_amdf == NULL)||(pm_filereq == NULL)) return -1;

	// -------------------
	// Get the file to open
	// -------------------
	SetAttrs(amd_app, MUIA_Application_Sleep, TRUE, TAG_DONE);
	file_to_open = pm_filereq->ssfr_OpenFileReq(pm_filereq);
	SetAttrs(amd_app, MUIA_Application_Sleep, FALSE, TAG_DONE);

	// -------------------
	// Update the view with the file
	// -------------------
	ret = openFile(pm_amdf, file_to_open);
	if(file_to_open != NULL) {free(file_to_open); file_to_open = NULL;}

	return ret;
}

LONG AmdGui::openFile1(char *pm_filename)
{
	return openFile(get_amdf1(), pm_filename);
}

LONG AmdGui::openFile2(char *pm_filename)
{
	return openFile(get_amdf2(), pm_filename);
}
LONG AmdGui::openFile(AmdFile *pm_amdf, char *pm_filename)
{
	ULONG ret = 0;
	char *str_tmp = NULL;

	if((pm_amdf == NULL)||(pm_filename == NULL)) return -1;

	SS_ADDLOG_DEBUG("Opening file '%s'", pm_filename);
	str_tmp = RelativePathToAbsolute(pm_filename);
	ret = pm_amdf->newfile(str_tmp);
	if(str_tmp != NULL) free(str_tmp);

	return ret;
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 11 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::makeVerticalSlidersDependent(void)
{
	if((amd_slider_vue1_vertical == NULL)||(amd_slider_vue2_vertical == NULL)) return;
	DoMethod(amd_slider_vue1_vertical,MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,amd_slider_vue2_vertical,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue);
	DoMethod(amd_slider_vue2_vertical,MUIM_Notify,MUIA_Prop_First,MUIV_EveryTime,amd_slider_vue1_vertical,3,MUIM_Set,MUIA_Prop_First,MUIV_TriggerValue);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 11 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::makeVerticalSlidersIndependent(void)
{
	if((amd_slider_vue1_vertical == NULL)||(amd_slider_vue2_vertical == NULL)) return;
	DoMethod(amd_slider_vue1_vertical,MUIM_KillNotifyObj,MUIA_Prop_First,amd_slider_vue2_vertical);
	DoMethod(amd_slider_vue2_vertical,MUIM_KillNotifyObj,MUIA_Prop_First,amd_slider_vue1_vertical);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::freeCycle(void)
{
	char **pstr_tmp = NULL;

SSDEBUG("amd_cy_diff_entries[0]=0x%lx\n", amd_cy_diff_entries[0]);
SSDEBUG("amd_cy_diff_entries[1]=0x%lx\n", amd_cy_diff_entries[1]);

	pstr_tmp = amd_cy_diff_entries;
	while((pstr_tmp != NULL)&&(*pstr_tmp != NULL))
	{SSDEBUG("freeCycle : pass1\n");
		free(*pstr_tmp);SSDEBUG("freeCycle : pass2\n");
		pstr_tmp++;
	}SSDEBUG("freeCycle : pass3\n");
	if(amd_cy_diff_entries != NULL) {free(amd_cy_diff_entries); amd_cy_diff_entries = NULL;}
SSDEBUG("freeCycle : pass4\n");
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 22 Mars 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdGui::reset_cycle(void)
{
	if(amd_cy_diff_entries != NULL)
	{
		freeCycle();
		free(amd_cy_diff_entries);
		amd_cy_diff_entries = NULL;
	}

	amd_cy_diff_entries = (char**)malloc(2*sizeof(char*));
    if(amd_cy_diff_entries == NULL)
	{
		return -1;
    }
	amd_cy_diff_entries[0] = ss_strdup("");
	amd_cy_diff_entries[1] = NULL;

	SetAttrs((void*)amd_cy_diff,MUIA_Cycle_Entries, amd_cy_diff_entries, TAG_DONE);

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 22 Mars 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdGui::set_cycle(void)
{
	unsigned long nb_diffs = 0;
	unsigned long i=0;
	ss_noeud_t *noeud_tmp;

    //-------------------------
	// Free old diff cycle tab
    //-------------------------
	if(amd_cy_diff_entries != NULL)
	{
		free(amd_cy_diff_entries);
		amd_cy_diff_entries = NULL;
	}

    //-------------------------
	// Allocate new tab
    //-------------------------
	nb_diffs = ss_lst_GetNbElt(&diff_cycle_list);
	amd_cy_diff_entries = (char**)malloc((nb_diffs+1)*sizeof(char**));
    if(amd_cy_diff_entries == NULL)
	{
		return -1;
    }

    //-------------------------
	// Update the diff cycle tab
    //-------------------------
	noeud_tmp = SS_LST_LST_GET_TETE(&diff_cycle_list);
	while((noeud_tmp != NULL)&&(i<nb_diffs))
    {
		cycle_entry_t *cycle_entry = (cycle_entry_t*)SS_LST_ND_GET_CONTENU(noeud_tmp);
		if(cycle_entry != NULL)
		{
			amd_cy_diff_entries[i] = ((cycle_entry->ce_title) != NULL ? strdup(cycle_entry->ce_title) : strdup(""));
		}
		else
		{
			amd_cy_diff_entries[i] = NULL;
			break;
		}
		i++;;
		noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }

	amd_cy_diff_entries[i] = NULL;

	SetAttrs((void*)amd_cy_diff,MUIA_Cycle_Entries, amd_cy_diff_entries, TAG_DONE);

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 20 Mars 2004
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::resetNbDiffs(void)
{
	ULONG nbcols_max = 0;

	reset_cycle();
	updategui_WithNbDiff(0);
	nbcols_max = MAX(amd_file1->getVbNbColMax(), amd_file2->getVbNbColMax());
	amd_file1->setVbNbCols(nbcols_max);
	amd_file2->setVbNbCols(nbcols_max);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 21 Decembre 2002
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
LONG AmdGui::update_views_with_diff(ss_list_t *pm_diff_list)
{
	ss_noeud_t *noeud_tmp = NULL;
	amd_difference_t *curr_diff = NULL;
	unsigned long lastligne_filebuffer1_pos = 1;
	unsigned long lastligne_filebuffer2_pos = 1;
	unsigned long nbdiff = 0;
	unsigned long viewbuffer_linepos = 0;
	long tmp_long = 0;
	ss_noeud_t *tmp_node = NULL;
	char str_cycletitle[64];
	ULONG nbcols_max = 0;
	viewbuffer_diff_chunk_t *tmp_chunk = NULL;


    //-------------------------
	// Test d'integrite
    //-------------------------
	if(pm_diff_list == NULL)	return -1;


    //-------------------------
	// Release old Cycle and Chunk entry list
    //-------------------------
	ss_lst_VideEtLibereNoeuds(&diff_cycle_list, AmdFreeCycleEntry);
	amd_file1->resetViewBufferChunkList();
	amd_file2->resetViewBufferChunkList();
	reset_cycle();


    //-------------------------
	// Construction du buffer view
    //-------------------------
	noeud_tmp = SS_LST_LST_GET_TETE(pm_diff_list);
	while(noeud_tmp != NULL)
    {
		unsigned long nb_lignes = 0;
		long nb_ligne_flie1 = 0;
		long nb_ligne_flie2 = 0;


		curr_diff = (amd_difference_t*)(SS_LST_ND_GET_CONTENU(noeud_tmp));

       if((curr_diff->m_diff_type) == AMD_DIFFTYPE_ADD)
		{
			(curr_diff->m_line1_begin)++;
		}
		else if ((curr_diff->m_diff_type) == AMD_DIFFTYPE_DELETE)
		{
			(curr_diff->m_line2_begin)++;
        }

		if((curr_diff->m_line1_end) == -1)
		{
			if((curr_diff->m_diff_type) == AMD_DIFFTYPE_ADD)
			{
				nb_ligne_flie1 = 0;
			}
			else
			{
				nb_ligne_flie1 = 1;
	        }
		}
		else
		{
			nb_ligne_flie1 = (curr_diff->m_line1_end - curr_diff->m_line1_begin) + 1;
		}
		if((curr_diff->m_line2_end) == -1)
		{
			if((curr_diff->m_diff_type) == AMD_DIFFTYPE_DELETE)
			{
				nb_ligne_flie2 = 0;
			}
			else
			{
				nb_ligne_flie2 = 1;
	        }
		}
		else
		{
			nb_ligne_flie2 = (curr_diff->m_line2_end - curr_diff->m_line2_begin) + 1;
		}
		nb_lignes = MAX(nb_ligne_flie1, nb_ligne_flie2);




		//-------------------------
		// Zone de partie commune
		//-------------------------
		if((curr_diff->m_line1_begin) > lastligne_filebuffer1_pos)
		{
			tmp_chunk = amd_file1->addViewBufferChunk(lastligne_filebuffer1_pos,
										  curr_diff->m_line1_begin - lastligne_filebuffer1_pos,
										  curr_diff->m_line1_begin - lastligne_filebuffer1_pos,
                                          AMD_DIFFTYPE_NONE);
			viewbuffer_linepos += (tmp_chunk->vdc_nblines_max) + 1;
		}
		if((curr_diff->m_line2_begin) > lastligne_filebuffer2_pos)
		{
		    amd_file2->addViewBufferChunk(lastligne_filebuffer2_pos,
										  curr_diff->m_line2_begin - lastligne_filebuffer2_pos,
										  curr_diff->m_line2_begin - lastligne_filebuffer2_pos,
										  AMD_DIFFTYPE_NONE);
		}
    
	    //-------------------------
		// Construction de la liste de difference pour le gadget cycle
		//-------------------------
		cycle_entry_t *cycle_entry = (cycle_entry_t*)malloc(sizeof(cycle_entry_t));
		if(cycle_entry != NULL)
		{
			cycle_entry->ce_line = viewbuffer_linepos;
			if((curr_diff->m_diff_type) == AMD_DIFFTYPE_ADD)
//				  sprintf(str_cycletitle, "%d : %s %d", (int)nbdiff, AMD_CycleAdded, (int)(cycle_entry->ce_line));
				sprintf(str_cycletitle, "%d : %s %d, %d", (int)nbdiff, AMD_CycleAdded, (int)(curr_diff->m_line1_begin), (int)(curr_diff->m_line2_begin));
			else if((curr_diff->m_diff_type) == AMD_DIFFTYPE_CHANGE)
//				  sprintf(str_cycletitle, "%d : %s %d", (int)nbdiff, AMD_CycleChanged, (int)(cycle_entry->ce_line));
				sprintf(str_cycletitle, "%d : %s %d, %d", (int)nbdiff, AMD_CycleChanged, (int)(curr_diff->m_line1_begin), (int)(curr_diff->m_line2_begin));
			else if((curr_diff->m_diff_type) == AMD_DIFFTYPE_DELETE)
//				  sprintf(str_cycletitle, "%d : %s %d", (int)nbdiff, AMD_CycleRemoved, (int)(cycle_entry->ce_line));
				sprintf(str_cycletitle, "%d : %s %d, %d", (int)nbdiff, AMD_CycleRemoved, (int)(curr_diff->m_line1_begin), (int)(curr_diff->m_line2_begin));
			else
				sprintf(str_cycletitle, "%d : ??? : ligne %d, %d", (int)nbdiff, (int)(curr_diff->m_line1_begin), (int)(curr_diff->m_line2_begin));
			cycle_entry->ce_title = strdup(str_cycletitle);
			tmp_node = ss_lst_AlloueNoeudAvecElt((void*)(cycle_entry));
			ss_lst_AjouteQueue(&diff_cycle_list, tmp_node);
		}

        //-------------------------
		// Zone de differences
		//-------------------------
		tmp_chunk = amd_file1->addViewBufferChunk(curr_diff->m_line1_begin, nb_ligne_flie1, nb_lignes, curr_diff->m_diff_type);
		viewbuffer_linepos += (tmp_chunk->vdc_nblines_max) + 1;
	    amd_file2->addViewBufferChunk(curr_diff->m_line2_begin, nb_ligne_flie2, nb_lignes, curr_diff->m_diff_type);
		lastligne_filebuffer1_pos = curr_diff->m_line1_begin + nb_ligne_flie1;
	    lastligne_filebuffer2_pos = curr_diff->m_line2_begin + nb_ligne_flie2;

		nbdiff++;

		noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
	} // while(noeud_tmp != NULL)


	
    //-------------------------
	// Mise a jour du gadget cycle avec la liste construite plus haut
	//-------------------------
    set_cycle();

	// Partie commune en fin de fichier ?
	//-------------------------
	tmp_long = amd_file1->getLineForFileBufferOffset(LONG_MAX) - lastligne_filebuffer1_pos;
	if(tmp_long > 0)
	{
		amd_file1->addViewBufferChunk(lastligne_filebuffer1_pos, tmp_long, tmp_long, AMD_DIFFTYPE_NONE);
	}
	tmp_long = amd_file2->getLineForFileBufferOffset(LONG_MAX) - lastligne_filebuffer2_pos;
    if(tmp_long > 0)
	{
	    amd_file2->addViewBufferChunk(lastligne_filebuffer2_pos, tmp_long, tmp_long, AMD_DIFFTYPE_NONE);
	}

	// -------------------
	// Updating ViewBuffer with chunk list
	// -------------------
    amd_file1->updateViewBufferWithChunkList();
	amd_file2->updateViewBufferWithChunkList();

	// -------------------
	// Updating GUI
	// -------------------
	nbcols_max = MAX(amd_file1->getVbNbColMax(), amd_file2->getVbNbColMax());
	amd_file1->setVbNbCols(nbcols_max);
	amd_file2->setVbNbCols(nbcols_max);
	amd_file1->updategui_WithViewBuffer();
	amd_file2->updategui_WithViewBuffer();
    updategui_WithNbDiff(nbdiff);

	if(nbdiff>0)
	{
		AmdCycleHookFuncCpp(this, 0);
	}

	return 0;
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 22 Mars 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::updategui_WithNbDiff(unsigned long pm_nbdiff)
{
	static char strtmp[128];

	if(pm_nbdiff > 1)
	{
		sprintf(strtmp, "\33c%d %s", pm_nbdiff, AMD_LabelDiffMULTI);
	}
	else
	{
		sprintf(strtmp, "\33c%d %s", pm_nbdiff, AMD_LabelDiffSINGLE);
	}
	SetAttrs((void*)amd_txt_nbdiffs,MUIA_TextEditor_Contents, strtmp,TAG_DONE);
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdGui::setCursorOnLigne(unsigned long pm_linenumber)
{
	if((amd_file1 == NULL)||(amd_file2 == NULL)) return -1;
	amd_file1->setCursorOnLigne(pm_linenumber);
	amd_file2->setCursorOnLigne(pm_linenumber);
	
    return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 16 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::openAboutWindow(void)
{
	SetAttrs(amd_about_win, MUIA_Window_Open, TRUE, TAG_DONE);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 16 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdGui::update_views_with_error(char *pm_file_name)
{
	ULONG nbcols_max = 0;

    //-------------------------
	// Release old Cycle and Chunk entry list
    //-------------------------
	ss_lst_VideEtLibereNoeuds(&diff_cycle_list, AmdFreeCycleEntry);
	amd_file1->resetViewBufferChunkList();
	amd_file2->resetViewBufferChunkList();
	reset_cycle();

	// -------------------
	// Build the list chunk with error message
	// -------------------
	amd_file1->update_views_with_error(pm_file_name);
	amd_file2->update_views_with_error(pm_file_name);

	// -------------------
	// Updating ViewBuffer with chunk list
	// -------------------
    amd_file1->updateViewBufferWithChunkList();
	amd_file2->updateViewBufferWithChunkList();

	// -------------------
	// Updating GUI
	// -------------------
	nbcols_max = MAX(amd_file1->getVbNbColMax(), amd_file2->getVbNbColMax());
	amd_file1->setVbNbCols(nbcols_max);
	amd_file2->setVbNbCols(nbcols_max);
	amd_file1->updategui_WithViewBuffer();
	amd_file2->updategui_WithViewBuffer();
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
BOOL AmdGui::is_scroll1(Object *pm_scroll)
{

	if(amd_file1 == NULL) return FALSE;

	return (amd_file1->is_scroll(pm_scroll));
}
BOOL AmdGui::is_scroll2(Object *pm_scroll)
{
	if(amd_file2 == NULL) return FALSE;

	return (amd_file2->is_scroll(pm_scroll));
}



/****************************************************************************
 * Classe AmdFile
 ****************************************************************************/


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
AmdFile::AmdFile()
{
	amdf_file_name         = NULL;
	amdf_filebuffer        = NULL;
	amdf_viewbuffer        = NULL;
	amdf_string            = NULL;
	amdf_txtscroll         = NULL;
	amdf_txtframe          = NULL;
	amdf_txttext           = NULL;

	amdf_filebuffersize    = 0;
	amdf_viewbuffersize    = 0;
	amdf_viewbuffer_nbcols = 0;

	ss_lst_Init(&amdf_viewbuffer_chunks);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
AmdFile::AmdFile(Object *pm_scroll, Object *pm_frame, Object *pm_text, Object *pm_button)
{
	amdf_file_name         = NULL;
	amdf_filebuffer        = NULL;
	amdf_viewbuffer        = NULL;
	amdf_string            = pm_button;
	amdf_txtscroll         = pm_scroll;
	amdf_txtframe          = pm_frame;
	amdf_txttext           = pm_text;

	amdf_filebuffersize    = 0;
	amdf_viewbuffersize    = 0;
	amdf_viewbuffer_nbcols = 0;

	ss_lst_Init(&amdf_viewbuffer_chunks);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
AmdFile::~AmdFile()
{
	if(amdf_file_name != NULL)	 	 free(amdf_file_name);
	if(amdf_filebuffer != NULL)		 free(amdf_filebuffer);
	if(amdf_viewbuffer != NULL)		 free(amdf_viewbuffer);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
LONG AmdFile::newfile(const char *pm_newfile_name)
{
	BPTR fd = NULL;
	ULONG file_size = 0;

	if(pm_newfile_name == NULL)	return -1;

	// -------------------
	// File reading
	// -------------------

	// File opening
	// -------------------
	fd = Open((char*)pm_newfile_name, MODE_OLDFILE);
	if(fd == NULL)
	{
		//SS-TBD : handle error
		return -1;
	}

	// Getting size file
	// -------------------
	file_size = getFileSize(fd);
	if(file_size == 0)	return -1;

	if(amdf_filebuffer != NULL)
	{
		SetAttrs((void*)amdf_txttext,MUIA_Text_Contents,NULL,TAG_DONE);

        free(amdf_filebuffer);
		amdf_filebuffer = NULL;
	}
	if(amdf_file_name != NULL) free(amdf_file_name);
	amdf_file_name = strdup(pm_newfile_name);

	// Reading file
	// -------------------
	amdf_filebuffer = (char*)malloc((file_size+1)*sizeof(char));
	if(amdf_filebuffer == NULL)
	{
		if(fd != NULL) Close(fd);
		return -1;
	}
	Read(fd, amdf_filebuffer, file_size);
	amdf_filebuffer[file_size] = '\0';
   amdf_filebuffersize = file_size+1;
 
	// -------------------
	// Updating GUI
	// -------------------
	updategui_WithFileBuffer();
	if(fd != NULL) Close(fd);

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 20 Mars 2004
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
char* AmdFile::getFileNameFromStringGadget(void)
{
	char *file_name = NULL;

	GetAttr(MUIA_String_Contents, amdf_string, (ULONG*)(&file_name));

	return file_name;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 20 Mars 2004
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdFile::resetFileNameStringGadget(void)
{
	SetAttrs((void*)amdf_string,MUIA_String_Contents, amdf_file_name,TAG_DONE);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdFile::reallocBufferviewWithSize(unsigned long pm_size)
{
	// Maj de la taille du buffer view
	// -------------------
	amdf_viewbuffersize = pm_size;

	// Liberation du buffer view
	// -------------------
	if(amdf_viewbuffer != NULL)
	{
		free(amdf_viewbuffer); amdf_viewbuffer = NULL;
    }

	// Allocation du buffer view avec la nouvelle taille
	// -------------------
	amdf_viewbuffer = (char*)calloc(amdf_viewbuffersize, sizeof(char));
	if(amdf_viewbuffer == NULL)	return -1;

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdFile::updategui_WithFileBuffer(void)
{
	unsigned long nbcols = 0UL;

	if (DoMethod((Object*)amdf_txtframe,MUIM_Group_InitChange))
	{
		DoMethod((Object*)amdf_txtframe,OM_REMMEMBER,amdf_txttext);
	
		nbcols = txtbuf_GetNbColMax(amdf_filebuffer);
	
		if(nbcols == 0UL)
		{
			SetAttrs((void*)amdf_txttext, MUIA_TextEditor_Contents, NULL, TAG_DONE);
		}
		else
		{
			SetAttrs((void*)amdf_txttext, MUIA_TextEditor_Contents, amdf_filebuffer, TAG_DONE);
			SetAttrs((void*)amdf_txttext, MUIA_TextEditor_Columns, (nbcols > AMD_TE_COLS_MIN ? nbcols : AMD_TE_COLS_MIN), TAG_DONE);
		}

	   DoMethod((Object*)amdf_txtframe,OM_ADDMEMBER,amdf_txttext);

	   DoMethod((Object*)amdf_txtframe,MUIM_Group_ExitChange);
	}

	SetAttrs((void*)amdf_txtscroll,MUIA_Scrollgroup_Contents, amdf_txtframe,TAG_DONE);

	//Set the tile of the file button
	resetFileNameStringGadget();
}
// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Octobre 2001
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdFile::updategui_WithViewBuffer(void)
{
	unsigned long nbcols = 0UL;

	if (DoMethod((Object*)amdf_txtframe,MUIM_Group_InitChange))
	{
		DoMethod((Object*)amdf_txtframe,OM_REMMEMBER,amdf_txttext);

		nbcols = MAX(amdf_viewbuffer_nbcols, txtbuf_GetNbColMax(amdf_viewbuffer));

		if(nbcols == 0UL)
		{
			SetAttrs((void*)amdf_txttext, MUIA_TextEditor_Contents, NULL, TAG_DONE);
		}
		else
		{
			SetAttrs((void*)amdf_txttext, MUIA_TextEditor_Contents, amdf_viewbuffer, TAG_DONE);
			SetAttrs((void*)amdf_txttext, MUIA_TextEditor_Columns, (nbcols > AMD_TE_COLS_MIN ? nbcols : AMD_TE_COLS_MIN), TAG_DONE);
		}

		DoMethod((Object*)amdf_txtframe,OM_ADDMEMBER,amdf_txttext);

		DoMethod((Object*)amdf_txtframe,MUIM_Group_ExitChange);
	}

	  SetAttrs((void*)amdf_txtscroll,MUIA_Scrollgroup_Contents, amdf_txtframe,TAG_DONE);
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdFile::setCursorOnLigne(unsigned long pm_linenumber)
{
	if(amdf_txttext == NULL) return -1;
	SetAttrs((void*)amdf_txttext, MUIA_TextEditor_CursorY, pm_linenumber, TAG_DONE);
	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdFile::getLineForFileBufferOffset(long pm_offset)
{
	return getLineForOffset(amdf_filebuffer, (pm_offset >= amdf_filebuffersize ? amdf_filebuffersize-1 : pm_offset));
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
viewbuffer_diff_chunk_t* AmdFile::addViewBufferChunk(unsigned long pm_begin_line, unsigned long pm_nblines, unsigned long pm_maxnblines, amd_diff_type_t pm_diff_type)
{
	char *str_chunk = NULL;
	long start_offset = -1;
	long end_offset = -1;
	long last_line = getLineForOffset(amdf_filebuffer, amdf_filebuffersize);
	unsigned long chunk_size = 0;
	unsigned long end_line = pm_begin_line+pm_nblines;
	viewbuffer_diff_chunk_t *chunk_node = NULL;

	// -------------------
	// Parameters check
	// -------------------
	if((amdf_file_name == NULL)
	  ||(pm_begin_line > last_line)
	  ||(end_line > last_line)
	  ||(pm_begin_line > end_line)
	  ||(pm_nblines>pm_maxnblines))
	{
		return NULL;
	}

	// -------------------
	// Get buffer offset for line number limit
	// -------------------
	start_offset = getOffsetForLine(amdf_filebuffer, pm_begin_line);
	end_offset   = getOffsetForLine(amdf_filebuffer, end_line);
//printf("start_offset=%ld, end_offset=%ld\n", start_offset, end_offset);
	if((start_offset >= amdf_filebuffersize)||(end_offset > amdf_filebuffersize)||(start_offset > end_offset))
	{
		 return NULL;
	}

	// -------------------
	// Copy chunk from file buffer
	// -------------------
	chunk_size = end_offset -  start_offset;
//printf("chunk_size=%lu\n", chunk_size);
	str_chunk = (char*)malloc((chunk_size+1)*sizeof(char));
	if(str_chunk == NULL) return NULL;
if((start_offset+chunk_size) >= amdf_filebuffersize)
printf("amdf_filebuffersize=%ld, start_offset=%ld\n", amdf_filebuffersize, start_offset);
	if(chunk_size > 0) memcpy(str_chunk, &(amdf_filebuffer[start_offset]), chunk_size);
	str_chunk[chunk_size] = '\0';

	// -------------------
	// Fill chunk struct info and add it to chunk list
	// -------------------
	chunk_node = (viewbuffer_diff_chunk_t*)malloc(sizeof(viewbuffer_diff_chunk_t));
	if(chunk_node == NULL)
	{
		if(str_chunk != NULL) free(str_chunk);
		return NULL;
	}
	chunk_node->vdc_difftype    = pm_diff_type;
	chunk_node->vdc_chunk       = str_chunk;
	chunk_node->vdc_nblines     = pm_nblines;
	chunk_node->vdc_nblines_max = pm_maxnblines;
	ss_highlst_AjouteQueue(&amdf_viewbuffer_chunks, chunk_node);

	return chunk_node;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 16 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdFile::update_views_with_error(char *pm_file_name)
{
	viewbuffer_diff_chunk_t *chunk_node = NULL;
	BPTR fh = NULL;
	ULONG file_size = 0;
	char *diff_file_buffer = NULL;
	long nb_lines = 0;

	if(pm_file_name == NULL) return;

	// -------------------
	// Fill chunk struct info and add it to chunk list
	// -------------------
	chunk_node = (viewbuffer_diff_chunk_t*)malloc(sizeof(viewbuffer_diff_chunk_t));
	if(chunk_node == NULL)
	{
		return;
	}
	chunk_node->vdc_difftype    = AMD_DIFFTYPE_NONE;
	chunk_node->vdc_chunk       = (char*)ss_strdup2((const char*)AMD_DiffCmdError, "\n");
	chunk_node->vdc_nblines     = 1;
	chunk_node->vdc_nblines_max = 1;
	ss_highlst_AjouteQueue(&amdf_viewbuffer_chunks, chunk_node);

	// -------------------
	// Fill chunk struct info and add it to chunk list
	// -------------------
	fh = Open(pm_file_name, MODE_OLDFILE);
	if(fh == NULL) return;
	file_size = getFileSize(fh);
	if(file_size == 0)
	{
		if(fh != NULL) Close(fh);
		return;
	}

	diff_file_buffer = (char*)malloc((file_size+1)*sizeof(char));
	if(diff_file_buffer == NULL)
	{
		if(fh != NULL) Close(fh);
		return;
	}
	Read(fh, diff_file_buffer, file_size);
	diff_file_buffer[file_size] = '\0';
	if(fh != NULL) Close(fh);

	nb_lines = getLineForOffset(diff_file_buffer, file_size);
	if(nb_lines == -1) nb_lines = 1;

	chunk_node = (viewbuffer_diff_chunk_t*)malloc(sizeof(viewbuffer_diff_chunk_t));
	if(chunk_node == NULL)
	{
		return;
	}
	chunk_node->vdc_difftype    = AMD_DIFFTYPE_NONE;
	chunk_node->vdc_chunk       = diff_file_buffer;
	chunk_node->vdc_nblines     = nb_lines;
	chunk_node->vdc_nblines_max = nb_lines;
	ss_highlst_AjouteQueue(&amdf_viewbuffer_chunks, chunk_node);
}



// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
unsigned long AmdFile::calculateViewBufferSize(void)
{
  ss_noeud_t *noeud_tmp = NULL;
  viewbuffer_diff_chunk_t *chunk_node = NULL;
  unsigned long ret_size = 0;

  noeud_tmp = SS_LST_LST_GET_TETE(&amdf_viewbuffer_chunks);
  while(noeud_tmp != NULL)
	{
		chunk_node = (viewbuffer_diff_chunk_t*)SS_LST_ND_GET_CONTENU(noeud_tmp);
		if((chunk_node != NULL)&&((chunk_node->vdc_chunk)!= NULL))
		{
			if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_NONE)
			{
				ret_size += strlen(chunk_node->vdc_chunk);
				ret_size += strlen(AMD_STR_SEPARATOR);
			}
			else if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_ADD)
			{
				ret_size += strlen(chunk_node->vdc_chunk);
				ret_size += strlen(AMD_STR_SEPARATOR);
				ret_size += (chunk_node->vdc_nblines_max)-(chunk_node->vdc_nblines);
				if((chunk_node->vdc_nblines) == 0) //SS patch 8 Mai 2003
					ret_size += strlen(AMD_STR_COLORTOKEN_ADD);
				else
					ret_size += ((chunk_node->vdc_nblines)*strlen(AMD_STR_COLORTOKEN_ADD));
			}
			else if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_CHANGE)
			{
				ret_size += strlen(chunk_node->vdc_chunk);
				ret_size += strlen(AMD_STR_SEPARATOR);
				ret_size += (chunk_node->vdc_nblines_max)-(chunk_node->vdc_nblines);
				ret_size += ((chunk_node->vdc_nblines)*strlen(AMD_STR_COLORTOKEN_CHG));
			}
			else if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_DELETE)
			{
				ret_size += strlen(chunk_node->vdc_chunk);
				ret_size += strlen(AMD_STR_SEPARATOR);
				ret_size += (chunk_node->vdc_nblines_max)-(chunk_node->vdc_nblines);
				if((chunk_node->vdc_nblines) == 0) //SS patch 8 Mai 2003
					ret_size += strlen(AMD_STR_COLORTOKEN_REM);
				else
					ret_size += ((chunk_node->vdc_nblines)*strlen(AMD_STR_COLORTOKEN_REM));
			}
		}

		noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }

	return ret_size;
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
long AmdFile::updateViewBufferWithChunkList(void)
{
	unsigned long buffer_pos = 0;
	ss_noeud_t *noeud_tmp = NULL;
	viewbuffer_diff_chunk_t *chunk_node = NULL;
	unsigned long view_buffer_size = calculateViewBufferSize() + 1;
	int i;


	if(view_buffer_size == 0) return -1;

	reallocBufferviewWithSize(view_buffer_size);

	noeud_tmp = SS_LST_LST_GET_TETE(&amdf_viewbuffer_chunks);
	while(noeud_tmp != NULL)
	{
		chunk_node = (viewbuffer_diff_chunk_t*)SS_LST_ND_GET_CONTENU(noeud_tmp);
		if((chunk_node != NULL)&&((chunk_node->vdc_chunk)!= NULL))
		{
			unsigned long chunk_size = strlen(chunk_node->vdc_chunk);
			unsigned long tememcopy_size = 0;
			if((buffer_pos + chunk_size) < view_buffer_size)
			{
				if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_NONE)
				{
					memcpy(&(amdf_viewbuffer[buffer_pos]),
						chunk_node->vdc_chunk, chunk_size);
					buffer_pos += chunk_size;
					memcpy(&(amdf_viewbuffer[buffer_pos]),
						AMD_STR_SEPARATOR, strlen(AMD_STR_SEPARATOR));
					buffer_pos += strlen(AMD_STR_SEPARATOR);
				}
				else if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_ADD)
				{
					tememcopy_size = TEmemcpy(&(amdf_viewbuffer[buffer_pos]),
									chunk_node->vdc_chunk, chunk_size, AMD_STR_COLORTOKEN_ADD);
					buffer_pos += tememcopy_size;
					for(i=0;
						i < (chunk_node->vdc_nblines_max)-(chunk_node->vdc_nblines);
						i++)
					{
						amdf_viewbuffer[buffer_pos] = '\n';
						buffer_pos ++;
					}
					memcpy(&(amdf_viewbuffer[buffer_pos]),
						AMD_STR_SEPARATOR, strlen(AMD_STR_SEPARATOR));
					buffer_pos += strlen(AMD_STR_SEPARATOR);
				}
				else if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_CHANGE)
				{
					tememcopy_size = TEmemcpy(&(amdf_viewbuffer[buffer_pos]),
									chunk_node->vdc_chunk, chunk_size, AMD_STR_COLORTOKEN_CHG);
					buffer_pos += tememcopy_size;
					for(i=0;
						i < (chunk_node->vdc_nblines_max)-(chunk_node->vdc_nblines);
						i++)
					{
						amdf_viewbuffer[buffer_pos] = '\n';
						buffer_pos ++;
					}
					memcpy(&(amdf_viewbuffer[buffer_pos]),
						AMD_STR_SEPARATOR, strlen(AMD_STR_SEPARATOR));
					buffer_pos += strlen(AMD_STR_SEPARATOR);
				}
				else if((chunk_node->vdc_difftype) == AMD_DIFFTYPE_DELETE)
				{
					tememcopy_size = TEmemcpy(&(amdf_viewbuffer[buffer_pos]),
									chunk_node->vdc_chunk, chunk_size, AMD_STR_COLORTOKEN_REM);
					buffer_pos += tememcopy_size;
					for(i=0;
						i < (chunk_node->vdc_nblines_max)-(chunk_node->vdc_nblines);
						i++)
					{
						amdf_viewbuffer[buffer_pos] = '\n';
						buffer_pos ++;
					}
					memcpy(&(amdf_viewbuffer[buffer_pos]),
						AMD_STR_SEPARATOR, strlen(AMD_STR_SEPARATOR));
					buffer_pos += strlen(AMD_STR_SEPARATOR);
				}
			}
		}
		noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }
	if(buffer_pos <= view_buffer_size)
	{
		amdf_viewbuffer[buffer_pos] = '\0';
	}
	else
	{
		amdf_viewbuffer[view_buffer_size-1] = '\0';
	}

#ifdef DEBUG
	if(buffer_pos != (view_buffer_size-1)) SS_ADDLOG_DEBUG("updateViewBufferWithChunkList : error : buffer_pos=%ld, view_buffer_size=%ld", buffer_pos, view_buffer_size);
#endif

	return 0;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
ULONG AmdFile::getVbNbColMax(void)
{
	return txtbuf_GetNbColMax(amdf_viewbuffer);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 11 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
void AmdFile::resetViewBufferChunkList(void)
{
	ss_lst_VideEtLibereNoeuds(&amdf_viewbuffer_chunks, AmdFreeChunkEntry);
}

/****************************************************************************
 * Fonctions
 ****************************************************************************/


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
LONG TEmemcpy(char *pm_dest, const char *pm_src, ULONG pm_nbchars, const char *pm_colortoken)
{
	ULONG i;
	unsigned long dest_pos = 0;

	if(pm_colortoken == NULL)
	{
		memcpy(pm_dest, pm_src, pm_nbchars);
		return (dest_pos+pm_nbchars);
	}

	memcpy(&pm_dest[dest_pos], pm_colortoken, strlen(pm_colortoken));
	dest_pos += strlen(pm_colortoken);
	for(i=0; i<pm_nbchars; i++)
	{
		if((i>0)&&(pm_src[i-1] == '\n'))
		{
			memcpy(&pm_dest[dest_pos], pm_colortoken, strlen(pm_colortoken));
			dest_pos += strlen(pm_colortoken);
		}
		pm_dest[dest_pos] = pm_src[i];
		dest_pos++;
	}

	return dest_pos;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
static void AmdFreeCycleEntry(void *pm_cycle_entry)
{
	cycle_entry_t *cycle_entry = (cycle_entry_t*)pm_cycle_entry;

	if(cycle_entry == NULL) return;

	if((cycle_entry->ce_title) != NULL) free(cycle_entry->ce_title);
	free(cycle_entry);
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 11 Mai 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
static void AmdFreeChunkEntry(void *pm_cycle_entry)
{
	viewbuffer_diff_chunk_t *chunk_node = (viewbuffer_diff_chunk_t*)pm_cycle_entry;

	if(chunk_node == NULL) return;

	if((chunk_node->vdc_chunk) != NULL) free(chunk_node->vdc_chunk);
	free(chunk_node);
}



// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 19 Avril 2003
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
extern "C" void AmdCycleHookFuncCpp(void *pm_obj, ULONG pm_itemnumber)
{
	ss_noeud_t *noeud_tmp = NULL;
	AmdGui *amd_gui = (AmdGui*)pm_obj;
	ULONG current_itemnumber = 0;
	long line_number = -1;

	if(amd_gui == NULL) return;

	noeud_tmp = SS_LST_LST_GET_TETE((amd_gui->get_cyclelist()));
	while((noeud_tmp != NULL)&&(current_itemnumber <= pm_itemnumber))
    {
		cycle_entry_t *cycle_entry = (cycle_entry_t*)SS_LST_ND_GET_CONTENU(noeud_tmp);
		line_number	= (cycle_entry != NULL) ? cycle_entry->ce_line : -1;
		current_itemnumber++;
		noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }

	if(line_number != -1)
	{
		amd_gui->setCursorOnLigne(ULONG_MAX);
		amd_gui->setCursorOnLigne(((line_number - 3)>=0) ? (line_number - 3) : 0);
	}
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :
// ******************
//
// Parametres en ENTREE :
// ******************
//
//
// Parametres en ENTREE/SORTIE :
// ******************
//
//
// Parametres en SORTIE :
// *******************
//
//
// Codes d'erreur :
// **************
//
//
// Description :
// **********
//
// *************************************************************************
//innocente delerium
extern "C" LONG AmdDragDropHookFuncCpp(void *pm_app, Object *pm_scroll, char *pm_filename)
{
	AmdGui *gui = (AmdGui*)pm_app;

	if((gui == NULL)||(pm_scroll == NULL)||(pm_filename == NULL)) return -1;

	if((gui->is_scroll1(pm_scroll)) == TRUE)
	{
		(gui->get_amdf1())->newfile(pm_filename);
		gui->makeVerticalSlidersIndependent();
	}
	else if((gui->is_scroll2(pm_scroll)) == TRUE)
	{
		(gui->get_amdf2())->newfile(pm_filename);
		gui->makeVerticalSlidersIndependent();
	}
	else
	{
		return -1;
	}
	return 0;
}
