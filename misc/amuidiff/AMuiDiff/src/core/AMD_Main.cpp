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

// objdump --section-headers --all-headers --reloc --syms --disassemble-all AMuiDiff >ram:objdump.log
//

/****************************************************************************
 * INCLUDES.
 ****************************************************************************/

// --------------------------------------------------------------------------
// C LIB
// --------------------------------------------------------------------------
#include <stdlib.h>
#include <stdio.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <exec/types.h>
#include <proto/exec.h>
#include <proto/alib.h>
#include <proto/dos.h>
#include <proto/asl.h>
#include <clib/debug_protos.h> //SS-TBD to be removed

#include <libraries/mui.h>

// --------------------------------------------------------------------------
// SS TOOL KIT LIB
// --------------------------------------------------------------------------
#include "ss_lib_tools_protos.h"
#include "ss_amiga_lib_tools_protos.h"
#include "SSStrLib_protos.h"
#include "SSProcLib_protos.h"

// --------------------------------------------------------------------------
// AmuiDiff
// --------------------------------------------------------------------------
#include "AMD_Gui.h"
#include "AMD_DiffCmdWrapping_protos.h"
#include "AMD_CatStrings.h"


/****************************************************************************
 * DEFINES.
 ****************************************************************************/
#define	AMD_STACKSIZE		 16384
 //8192

#define AMD_ARGS_TEMPLATE 	 "FILE1,FILE2,OPTIONS,DEBUG/S"
#define AMD_NOTIF_VIEW1 	 1
#define AMD_NOTIF_VIEW2 	 2

#define AMD_CONF_DEF_EDITOR	 "golded:golded"
#define AMD_CONF_FFONT_TRUE  "TRUE"
#define AMD_ENV_EDITOR       "AMuiDiff/EDITOR"
#define AMD_ENV_FIXEDFONT    "AMuiDiff/FIXEDFONT"

#ifdef __MORPHOS__
#  define SSOpenLibrary(X, Y) OpenLibrary((CONST_STRPTR)X, Y)
#else //Amigaos
//#  define SSOpenLibrary(X, Y) OpenLibrary((CONST_STRPTR)X, Y)
#  define SSOpenLibrary(X, Y) OpenLibrary((UBYTE*)X, Y)
#endif //#ifdef __MORPHOS__

/****************************************************************************
 * VARIABLES GLOBALES EXPORTEES.
 ****************************************************************************/

struct Library        *IntuitionBase = NULL;
struct Library        *GfxBase       = NULL;
struct Library        *MUIMasterBase = NULL;
struct Library        *AslBase       = NULL;
extern struct Library        *LocaleBase;//    = NULL;


struct WBStartup * WBmsg = NULL;
BOOL               IsFontFixed = FALSE;

static int IsDiffPerformed = FALSE;


/****************************************************************************
 * SIGNATURES.
 ****************************************************************************/
static long amd_OpenLibs(void);
static void amd_CloseLibs(void);
static long amd_PerformDiffCB(AmdGui* pm_amd_gui, char *pm_options);
static void amd_main(void *pm_arg); // Main fonction called by NewPPCStackSwap
static LONG amd_SwapFiles(AmdGui *pm_amdgui, char *pm_argoptions);


/****************************************************************************
 * MAIN.
 ****************************************************************************/

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS,
// ******************
//
// Parametres en ENTREE : -
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
// Codes d'erreur : -
// **************
//
//
// Description : main() !!
// **********
//
// *************************************************************************
int main(int argc, char **argv)
{
    WBmsg = (struct WBStartup *)(0 == argc ? argv : NULL);
	return sslib_InstallNewStack(AMD_STACKSIZE, amd_main, NULL); // Change stack size
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS,
// ******************
//
// Parametres en ENTREE : -
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
// Codes d'erreur : -
// **************
//
//
// Description : main() !!
// **********
//
// *************************************************************************
static void	amd_main(void *pm_arg)
{
	AmdGui         *amd_gui     = NULL;
	ULONG          sigs         = 0;
	BYTE           continuer    = TRUE;
	ULONG          id           = 0;
	struct RDArgs  *rdargs      = NULL;
	LONG           result[4]    = {0};
	char           *arg_file1   = NULL;
	char           *arg_file2   = NULL;
	char           *arg_options = NULL;
	sslib_filenotify_t filenotify1;
	sslib_filenotify_t filenotify2;
	struct MsgPort *notif_port  = NULL;
	char 		   *editor_name = NULL;;
	char 		   *type_font   = NULL;;

	// -------------------
	// INITIALISATIONS
	// -------------------
SSDEBUG("amd_main : entry\n");
	// Args management
	// -------------------
	rdargs = ReadArgs(AMD_ARGS_TEMPLATE, result, NULL);
	if(rdargs == NULL)
	{
		SS_DEBUG_ON();
		SS_ADDLOG_DEBUG("AMuiDiff error : ReadArgs");
		printf("AMuiDiff error : ReadArgs\n");
		exit(EXIT_FAILURE);
    }
	arg_file1   = (char *)(result[0]);
	arg_file2   = (char *)(result[1]);
	arg_options = (char *)(result[2]);
	UseDebugLog = ((int)(result[3]) != 0) ? 1 : 0; //If DEBUG switch is enabled, set UseDebugLog to 1, else to 0
SSDEBUG("amd_main : pass1\n");

	// Libraries initialisations
	// -------------------
	if(amd_OpenLibs() != 0)
	{
		if(rdargs != NULL) FreeArgs(rdargs);
		
		exit(EXIT_FAILURE);
    }
SSDEBUG("amd_main : pass2\n");

	// Load Config
	// -------------------
	editor_name = ss_strdup(getenv(AMD_ENV_EDITOR));
	if(editor_name == NULL)
	{

		editor_name = ss_strdup(AMD_CONF_DEF_EDITOR);
	}

	type_font = ss_strdup(getenv(AMD_ENV_FIXEDFONT));
	if((type_font != NULL) && (ss_strcasecmp(type_font, AMD_CONF_FFONT_TRUE) == 0))
	{
		IsFontFixed = TRUE;
		free(type_font); type_font = NULL;
	}

	// Open catalog
	// -------------------
	OpenAMD_CatStringsCatalog();

	// Task Manager initialisation
	// -------------------
	if(ssproc_Init() != 0)
	{
		if(editor_name != NULL) {free(editor_name); editor_name = NULL;}
		if(rdargs != NULL) FreeArgs(rdargs);
		amd_CloseLibs();
		CloseAMD_CatStringsCatalog();
		
		exit(EXIT_FAILURE);
	}
SSDEBUG("amd_main : pass3\n");

	// File notification initialisation
	// -------------------
	notif_port = CreateMsgPort();
	if(notif_port == NULL)
	{
		if(editor_name != NULL) {free(editor_name); editor_name = NULL;}
		if(rdargs != NULL) FreeArgs(rdargs);
		amd_CloseLibs();
		CloseAMD_CatStringsCatalog();
		ssproc_End();

		exit(EXIT_FAILURE);
	}
	NEW_sslib_filenotify(&filenotify1, notif_port, FindTask(NULL), (void*)AMD_NOTIF_VIEW1);
	NEW_sslib_filenotify(&filenotify2, notif_port, FindTask(NULL), (void*)AMD_NOTIF_VIEW2);


	// -------------------
	// Create GUI
	// -------------------
	amd_gui = new AmdGui();
	if((amd_gui == NULL)||(amd_gui->get_state() == AmdGui::AMD_ERROR))
    {
		if(editor_name != NULL) {free(editor_name); editor_name = NULL;}
		if(rdargs != NULL) FreeArgs(rdargs);
		amd_CloseLibs();
		CloseAMD_CatStringsCatalog();
		ssproc_End();
		DEL_sslib_filenotify(&filenotify1);
		DEL_sslib_filenotify(&filenotify2);
		if(notif_port != NULL) DeleteMsgPort(notif_port);

		exit(EXIT_FAILURE);
    }
SSDEBUG("amd_main : pass4\n");
   
	// -------------------
	// Args Processing
	// -------------------
	if(arg_file1 != NULL)
	{
		char *filename = NULL;

		amd_gui->openFile1(arg_file1);

		filename = (char*)(amd_gui->get_filename1());
		if(filename != NULL)
		{
			filenotify1.ssfn_StartWithFile(&filenotify1, filename);
			amd_gui->doButton1Background();
		}
		else
		{
			filenotify1.ssfn_Stop(&filenotify1);
		}
    }
	if(arg_file2 != NULL)
	{
		char *filename = NULL;

		amd_gui->openFile2(arg_file2);


		filename = (char*)(amd_gui->get_filename2());
		if(filename != NULL)
		{
			filenotify2.ssfn_StartWithFile(&filenotify2, filename);
			amd_gui->doButton2Background();
		}
		else
		{
			filenotify2.ssfn_Stop(&filenotify2);
		}
    }
	if((arg_file2 != NULL)&&(arg_file2 != NULL))
	{
		amd_PerformDiffCB(amd_gui, arg_options);
		amd_gui->makeVerticalSlidersDependent();
		IsDiffPerformed = TRUE;
	}

SSDEBUG("amd_main : pass5\n");

	// -------------------
	// Handle Events
	// -------------------
    while (continuer == TRUE)
    {
		id = DoMethod((Object*)(amd_gui->get_app()), MUIM_Application_NewInput,&sigs);

		switch(id)
		{
		    case (ULONG)MEN_QUITTER:
			case (ULONG)MUIV_Application_ReturnID_Quit:
				continuer = FALSE;
			break;
			case (ULONG)MEN_EDIT1:
			case AmdGui::AMD_EDIT1:
				{
					char *editor = (char*)ss_strdup3("\"", editor_name, "\"");
					char *file   = (char*)ss_strdup3("\"", (char*)(amd_gui->get_filename1()), "\"");
					if((editor != NULL)&&(file != NULL))
					{
						CreateProcessExe(editor, file, NULL);
					}
					if(editor != NULL) 	free(editor);
					if(file != NULL) 	free(file);
				}
			break;
			case (ULONG)MEN_RELOAD1:
			case AmdGui::AMD_RELOAD1:
			{
				char *filename = (char*)(amd_gui->get_filename1());  printf("filename='%s'\n", filename);
				if(filename == NULL) break;

				amd_gui->openFile1(filename);

				if(filename != NULL)
				{
					filenotify1.ssfn_StartWithFile(&filenotify1, filename);
					amd_gui->doButton1Background();
				}
				else
				{
					filenotify1.ssfn_Stop(&filenotify1);
				}

				if(IsDiffPerformed == TRUE)
				{
        			amd_PerformDiffCB(amd_gui, arg_options);
				}			
			}	
		    break;
		    case (ULONG)MEN_OUVRIR1:
			case AmdGui::AMD_REQ_FILE1:
			{
				char *filename = NULL;
				long ret1      = 0;
				ret1 = amd_gui->openReqFile1();

				if(ret1 == 0)
				{
					amd_gui->makeVerticalSlidersIndependent();
					IsDiffPerformed = FALSE;
					filename = (char*)(amd_gui->get_filename1());
					if(filename != NULL)
					{
						filenotify1.ssfn_StartWithFile(&filenotify1, filename);
						amd_gui->doButton1Background();
					}
					else
					{
						filenotify1.ssfn_Stop(&filenotify1);
					}
					amd_gui->resetNbDiffs();
				}
			}
		    break;
			case AmdGui::AMD_FILE1:
			{
				char *filename = amd_gui->getFileName1FromStringGadget();

				if(filename != NULL)
				{
					amd_gui->openFile1(filename);
					amd_gui->resetFileNameStringGadget1();

					amd_gui->makeVerticalSlidersIndependent();
					IsDiffPerformed = FALSE;
					filename = (char*)(amd_gui->get_filename1());
					if(filename != NULL)
					{
						filenotify1.ssfn_StartWithFile(&filenotify1, filename);
						amd_gui->doButton1Background();
					}
					else
					{
						filenotify1.ssfn_Stop(&filenotify1);
					}
					amd_gui->resetNbDiffs();
				}
			}
		    break;
			case (ULONG)MEN_EDIT2:
			case AmdGui::AMD_EDIT2:
				{
					char *editor = (char*)ss_strdup3("\"", editor_name, "\"");
					char *file   = (char*)ss_strdup3("\"", (char*)(amd_gui->get_filename2()), "\"");
					if((editor != NULL)&&(file != NULL))
					{
						CreateProcessExe(editor, file, NULL);
					}
					if(editor != NULL) 	free(editor);
					if(file != NULL) 	free(file);
				}
			break;
			case (ULONG)MEN_RELOAD2:
			case AmdGui::AMD_RELOAD2:
			{
				char *filename = (char*)(amd_gui->get_filename2());
				if(filename == NULL) break;

				amd_gui->openFile2(filename);

				if(filename != NULL)
				{
					filenotify2.ssfn_StartWithFile(&filenotify2, filename);
					amd_gui->doButton2Background();
				}
				else
				{
					filenotify2.ssfn_Stop(&filenotify2);
				}

				if(IsDiffPerformed == TRUE)
				{
        			amd_PerformDiffCB(amd_gui, arg_options);
				}			
			}	
		    break;
			case (ULONG)MEN_OUVRIR2:
			case AmdGui::AMD_REQ_FILE2:
			{
				char *filename = NULL;
				long ret2      = 0;

				ret2 = amd_gui->openReqFile2();
				if(ret2 == 0)
				{
					amd_gui->makeVerticalSlidersIndependent();
					IsDiffPerformed = FALSE;
					filename = (char*)(amd_gui->get_filename2());
					if(filename != NULL)
					{
						filenotify2.ssfn_StartWithFile(&filenotify2, filename);
						amd_gui->doButton2Background();
					}
					else
					{
						filenotify2.ssfn_Stop(&filenotify2);
					}
					amd_gui->resetNbDiffs();
				}
			}
		    break;
			case AmdGui::AMD_FILE2:
			{
				char *filename = amd_gui->getFileName2FromStringGadget();

				if(filename != NULL)
				{
					amd_gui->openFile2(filename);
					amd_gui->resetFileNameStringGadget2();

					amd_gui->makeVerticalSlidersIndependent();
					IsDiffPerformed = FALSE;
					filename = (char*)(amd_gui->get_filename2());
					if(filename != NULL)
					{
						filenotify2.ssfn_StartWithFile(&filenotify2, filename);
						amd_gui->doButton2Background();
					}
					else
					{
						filenotify2.ssfn_Stop(&filenotify2);
					}
					amd_gui->resetNbDiffs();
				}
			}
		    break;
			case AmdGui::AMD_DIFF:

SSDEBUG("amd_main : AMD_DIFF1\n");
				amd_PerformDiffCB(amd_gui, arg_options);
SSDEBUG("amd_main : AMD_DIFF2\n");
				amd_gui->makeVerticalSlidersDependent();
SSDEBUG("amd_main : AMD_DIFF3\n");
				IsDiffPerformed = TRUE;
				break;
			case (ULONG)MEN_APROPOS:
				amd_gui->openAboutWindow();
				break;

			case AmdGui::AMD_SWAP:
				amd_SwapFiles(amd_gui, arg_options);
				break;

			default:
//				  SSDEBUG("default\n");
			break;
		}

//SSDEBUG("amd_main : pass5.3\n");

		if ((sigs != 0) && (continuer == TRUE))
		{
			sigs = Wait(sigs | SIGBREAKF_CTRL_C | (1L<<(notif_port->mp_SigBit)));
			if(sigs & SIGBREAKF_CTRL_C) break;
			if(sigs & (1L<<(notif_port->mp_SigBit)))
			{
				struct NotifyMessage *notif_msg = (struct NotifyMessage*)GetMsg(notif_port);

				if((long)(notif_msg->nm_NReq->nr_UserData) == AMD_NOTIF_VIEW1)
				{
					amd_gui->doButton1Shine();
				}
				else if((long)(notif_msg->nm_NReq->nr_UserData) == AMD_NOTIF_VIEW2)
				{
					amd_gui->doButton2Shine();
				}
				if(notif_msg != NULL) ReplyMsg((struct Message*)notif_msg);
			}
		}
//SSDEBUG("amd_main : pass5.4\n");
    }

	// -------------------
	// RELEASES
	// -------------------

	// Release GUI
	// -------------------
SSDEBUG("amd_main : pass6\n");
	delete amd_gui;
	amd_gui = NULL;

	// Release Task manager
	// -------------------
	ssproc_End();

	// Release File notification system
	// -------------------
	DEL_sslib_filenotify(&filenotify1);
	DEL_sslib_filenotify(&filenotify2);
	if(notif_port != NULL) DeleteMsgPort(notif_port);

	// Close catalog
	// -------------------
SSDEBUG("amd_main : pass7\n");
	CloseAMD_CatStringsCatalog();

	// Release Libs
	// -------------------
SSDEBUG("amd_main : pass8\n");
	amd_CloseLibs();
SSDEBUG("amd_main : pass9\n");

	// Release ARGS
	// -------------------
	if(rdargs != NULL) FreeArgs(rdargs);

	if(editor_name != NULL) {free(editor_name); editor_name = NULL;}
	
SSDEBUG("amd_main : exit\n");
	exit(EXIT_SUCCESS);
}



// *************************************************************************
// amd_OpenLibs()
//
// ************************************
//
// Date et Auteur :      SS, le 06 Juillet 2002
// ******************
//
// Parametres en ENTREE : -
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
// Codes d'erreur : 0 : SUCCESS, -1 : error opening libs
// **************
//
//
// Description : This function open all libraries needed by AMuiDiff
// **********
//
// *************************************************************************
static long amd_OpenLibs(void)
{
	 GfxBase = SSOpenLibrary(("graphics.library"), 0);
    if(GfxBase == NULL)
    {
		printf("AMuiDiff error : Opening graphics.library\n");
		SS_ADDLOG_DEBUG("AMuiDiff error : Opening graphics.library");
		return(-1);
    }
	 IntuitionBase = SSOpenLibrary(("intuition.library"), 0);
    if(IntuitionBase == NULL)
    {
		if(GfxBase != NULL)       {CloseLibrary(GfxBase); GfxBase = NULL;}
		printf("AMuiDiff error : Opening intuition.library\n");
		SS_ADDLOG_DEBUG("AMuiDiff error : Opening intuition.library");
		return(-1);
    }
	 AslBase = SSOpenLibrary(("asl.library"), 0);
    if(AslBase == NULL)
    {
		if(IntuitionBase != NULL) {CloseLibrary(IntuitionBase); IntuitionBase = NULL;}
		if(GfxBase != NULL)       {CloseLibrary(GfxBase); GfxBase = NULL;}
		printf("AMuiDiff error : Opening asl.library\n");
		SS_ADDLOG_DEBUG("AMuiDiff error : Opening asl.library");
		return(-1);
    }
	 MUIMasterBase = SSOpenLibrary(("muimaster.library"), 0);
    if(MUIMasterBase == NULL)
    {
		if(AslBase != NULL)       {CloseLibrary(AslBase); AslBase = NULL;}
		if(IntuitionBase != NULL) {CloseLibrary(IntuitionBase); IntuitionBase = NULL;}
		if(GfxBase != NULL)       {CloseLibrary(GfxBase); GfxBase = NULL;}
		printf("AMuiDiff error : Opening muimaster.library\n");
		SS_ADDLOG_DEBUG("AMuiDiff error : Opening muimaster.library");
		return(-1);
    }
	 LocaleBase = SSOpenLibrary(("locale.library"), 0);
    if(LocaleBase == NULL)
    {
		if(MUIMasterBase != NULL) {CloseLibrary(MUIMasterBase); MUIMasterBase = NULL;}
		if(AslBase != NULL)       {CloseLibrary(AslBase); AslBase = NULL;}
		if(IntuitionBase != NULL) {CloseLibrary(IntuitionBase); IntuitionBase = NULL;}
		if(GfxBase != NULL)       {CloseLibrary(GfxBase); GfxBase = NULL;}
		printf("AMuiDiff error : Opening locale.library\n");
		SS_ADDLOG_DEBUG("AMuiDiff error : Opening locale.library");
		return(-1);
    }

	return 0;
}

// *************************************************************************
// amd_CloseLibs()
//
// ************************************
//
// Date et Auteur :      SS, le 06 Juillet 2002
// ******************
//
// Parametres en ENTREE : -
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
// Codes d'erreur : -
// **************
//
//
// Description : This function close all libraries opened by AMuiDiff
// **********
//
// *************************************************************************
static void amd_CloseLibs(void)
{
	if(LocaleBase != NULL)    {CloseLibrary(LocaleBase);    LocaleBase = NULL;}
	if(MUIMasterBase != NULL) {CloseLibrary(MUIMasterBase); MUIMasterBase = NULL;}
	if(AslBase != NULL)       {CloseLibrary(AslBase);       AslBase = NULL;}
	if(IntuitionBase != NULL) {CloseLibrary(IntuitionBase); IntuitionBase = NULL;}
	if(GfxBase != NULL)       {CloseLibrary(GfxBase);       GfxBase = NULL;}
}


// *************************************************************************
// amd_SwapFiles()
//
// ************************************
//
// Date et Auteur :      SS, le 13 Octobre 2003
// ******************
//
// Parametres en ENTREE : -
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
// Codes d'erreur : -
// **************
//
//
// Description :
// **********
//
// *************************************************************************
static LONG amd_SwapFiles(AmdGui *pm_amdgui, char *pm_argoptions)
{
	AmdFile *amdfile1 = NULL;
	AmdFile *amdfile2 = NULL;
	char *strfile1    = NULL;
	char *strfile2    = NULL;

	// -------------------
	// Args Check
	// -------------------
	if(pm_amdgui == NULL) return -1;
	amdfile1 = pm_amdgui->get_amdf1();
	amdfile2 = pm_amdgui->get_amdf2();
	if((amdfile1 == NULL) || (amdfile2 == NULL)) return -2;

	// Get files currently displayed
	// -------------------
	strfile1 = ss_strdup(amdfile1->get_file_name());
	strfile2 = ss_strdup(amdfile2->get_file_name());

	// Display new files
	// -------------------
	if(strfile1 != NULL)
	{
		amdfile2->newfile(strfile1);
	}

	if(strfile2 != NULL)
	{
		amdfile1->newfile(strfile2);
	}

	// Perform diff if diff was performed
	// -------------------
	if(IsDiffPerformed == TRUE)
	{
        amd_PerformDiffCB(pm_amdgui, pm_argoptions);
	}

	free(strfile1);
	free(strfile2);

	return 0;
}

// *************************************************************************
// amd_PerformDiffCB()
//
// ************************************
//
// Date et Auteur :      SS, le 10 Novembre 2002
// ******************
//
// Parametres en ENTREE : pm_amd_gui : gui object to update
// ******************     pm_options : diff options (ARGS)
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
// Codes d'erreur : 0 : success, -1 : error (param)
// **************
//
//
// Description : Function called when a diff action is performed
// **********
//
// *************************************************************************
static long amd_PerformDiffCB(AmdGui* pm_amd_gui, char *pm_options)
{
	ss_list_t *diff_list = NULL;
	ss_noeud_t *noeud = NULL;
	char *resultfile = NULL;
	amd_difference_t *curr_diff = NULL;

SSDEBUG("amd_PerformDiffCB : entry\n");

	if(pm_amd_gui == NULL)	return -1;

	// -------------------
	// Call an external "diff" cmd (in the path) to build the diff information
	// -------------------
	SS_ADDLOG_DEBUG("Perform Diff : file1='%s', file2='%s', options='%s'", (char*)(pm_amd_gui->get_filename1()), (char*)(pm_amd_gui->get_filename2()), pm_options);
SSDEBUG("amd_PerformDiffCB : pass1\n");
	diff_list = amd_analyse_files((char*)(pm_amd_gui->get_filename1()), (char*)(pm_amd_gui->get_filename2()), pm_options, &resultfile);
SSDEBUG("amd_PerformDiffCB : pass2\n");
	// -------------------
	// Update the GUI with the built diff information
	// -------------------
	if(diff_list != NULL) noeud = SS_LST_LST_GET_TETE(diff_list);
	if(noeud != NULL)
	{
		curr_diff = (amd_difference_t*)SS_LST_ND_GET_CONTENU(noeud);
		if((curr_diff == NULL)||(curr_diff->m_diff_type) == AMD_DIFFTYPE_ERROR)
		{
			pm_amd_gui->update_views_with_error(resultfile);
		}
		else
		{
			pm_amd_gui->update_views_with_diff(diff_list);
		}
	}
SSDEBUG("amd_PerformDiffCB : pass3\n");

	// -------------------
	// Release built diff information
	// -------------------
	amd_af_release_result_list(diff_list);

SSDEBUG("amd_PerformDiffCB : exit\n");
	return 0;
}

