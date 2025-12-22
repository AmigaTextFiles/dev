/****************************************************************************
*      Society                   :  -
*      Project                   :  AMuiDiff
*
*      Creation author           :  Stephane SARAGAGLIA
*      Module name               :  $RCSfile: AMD_CHooks.c,v $
*      Module version            :  $Revision: 1.12 $
*      Current version date      :  $Date: 2004/01/14 23:23:52 $
*
*      Description               :  Hooks for MUI in C language
*
*      System                    :  AmigaOS/MorphOS
*
*      Programmation language    :  ISO-C (sometimes)
*      Creation date             :
*
*      Prefixe                   : -
*
*      References                : -
*
*         No Copyright - Please send me a version of
*         any modification of this source...
*                ----------------------------------
*
*      CVS history               :
*         $Log: AMD_CHooks.c,v $
*         Revision 1.12  2004/01/14 23:23:52  sara
*         SS : CHG : Modified AmdReqRefreshHookFunc() to make t hook compliant...
*
*         Revision 1.11  2003/11/15 17:12:42  sara
*         SS : ADD : splint workaround
*         SS : ADD : a requester hook refresh (curently not tested).
*
*         Revision 1.10  2003/09/28 14:55:14  sara
*         SS : ADD : A new Hook handles drag and drop of files on files view...
*
*         Revision 1.9  2003/06/21 16:38:04  sara
*         SS : Replaced the "_MORPHOS_" predefined by the internal one "__MORPHOS__"
*
*         Revision 1.8  2003/06/21 16:25:19  sara
*         SS : Added comments
*         	 Removed unused code
*
*
*****************************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/
// --------------------------------------------------------------------------
// C LIB
// --------------------------------------------------------------------------
#include <stdlib.h>
#include <string.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <exec/memory.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

#include <proto/exec.h>
#include <proto/alib.h>           //HookEntry()
#include <proto/dos.h>
#include <proto/graphics.h>
#include <clib/debug_protos.h> //SS-TBD to be removed

#include <libraries/gadtools.h>
#include <libraries/mui.h>
#include <libraries/asl.h>

#ifdef __MORPHOS__
#include <ppcinline/macros.h>
#endif

#include <MUI/TextEditor_mcc.h>

#include "ss_amiga_lib_tools_protos.h"
   
/*******************************************************************
 * VARIABLES GLOBALES
*******************************************************************/
LONG	    cmap[8]; // ViewPort ColorMap


#ifdef __MORPHOS__  //MorphOS GCC
static ULONG TextEditor_Dispatcher(void);
struct EmulLibEntry GATETextEditor_Dispatcher=
{
    TRAP_LIB, 0, (void (*)(void)) TextEditor_Dispatcher
};
#else //AmigaOS GCC
# ifndef S_SPLINT_S
ULONG __regargs __saveds TextEditor_Dispatcher (register struct IClass *cl __asm("a0"), register Object *obj __asm("a2"), register struct MUIP_TextEditor_HandleError *msg __asm("a1"));
# endif
#endif


/*******************************************************************
 * FONCTIONS IMPORTEES
*******************************************************************/
extern void AmdCycleHookFuncCpp(void *pm_obj, ULONG pm_itemnumber);  //C++ function from AMD_Gui.cpp
extern LONG AmdDragDropHookFuncCpp(void *pm_app, Object *pm_scroll, char *pm_filename); //C++ function from AMD_Gui.cpp

/*******************************************************************
 * DEFINITION DES FONCTIONS LOCALES ET EXPORTEES
*******************************************************************/

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
// Description : Management of the color map...
// **********
//
// *************************************************************************
#ifdef __MORPHOS__
ULONG TextEditor_Dispatcher(void)
{
    struct IClass *cl=(struct IClass*) REG_A0;
	struct MUIP_TextEditor_HandleError *msg=(struct MUIP_TextEditor_HandleError *) REG_A1;
    Object *obj=(Object*) REG_A2;
#else
# ifndef S_SPLINT_S
ULONG __regargs __saveds TextEditor_Dispatcher (register struct IClass *cl __asm("a0"), register Object *obj __asm("a2"), register struct MUIP_TextEditor_HandleError *msg __asm("a1"))
# else
ULONG TextEditor_Dispatcher (register struct IClass *cl __asm("a0"), register Object *obj __asm("a2"), register struct MUIP_TextEditor_HandleError *msg __asm("a1"))
# endif
{
#endif

	switch(msg->MethodID)
	{
		case MUIM_Show:
		{
			struct ColorMap *cm = muiRenderInfo(obj)->mri_Screen->ViewPort.ColorMap;

			cmap[0] = ObtainBestPenA(cm, 0x00<<24, 0x00<<24, 0x00<<24, NULL);    // noir
			cmap[1] = ObtainBestPenA(cm, 0xff<<24, 0xff<<24, 0xff<<24, NULL);    // blanc
			cmap[2] = ObtainBestPenA(cm, 0xff<<24, 0x00<<24, 0x00<<24, NULL);    // rouge
			cmap[3] = ObtainBestPenA(cm, 0x00<<24, 0xff<<24, 0x00<<24, NULL);    // vert
			cmap[4] = ObtainBestPenA(cm, 0x00<<24, 0xff<<24, 0xff<<24, NULL);    // turquoise
			cmap[5] = ObtainBestPenA(cm, 0xff<<24, 0xff<<24, 0x00<<24, NULL);    //
			cmap[6] = ObtainBestPenA(cm, 0x00<<24, 0x00<<24, 0xff<<24, NULL);    // bleu
			cmap[7] = ObtainBestPenA(cm, 0xff<<24, 0x00<<24, 0xff<<24, NULL);    //
			break;
		}

		case MUIM_Hide:
		{
				struct ColorMap *cm = muiRenderInfo(obj)->mri_Screen->ViewPort.ColorMap;
				int c;

			for(c = 0; c < 8; c++)
			{
				if(cmap[c] >= 0)
				{
					ReleasePen(cm, cmap[c]);
				}
			}
			break;
		}

	}

	return(DoSuperMethodA(cl, obj, (Msg)msg));
}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le 26 Avril 2003
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
// Description : Hook called when a new item is selected in the diff cycle.
// **********
//
// *************************************************************************
void AmdCycleHookFunc(struct Hook *hook, Object *obj, LONG *contents)
{
	AmdCycleHookFuncCpp((Object *)(hook->h_Data), *contents); // Call equivalent AMD_Gui.cpp function (C++ management)
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
LONG AmdDragDropHookFunc(struct Hook *hook, Object *obj, struct AppMessage **apmsg)
{
	struct WBArg *wbarg;
	char *filename = NULL;
	char *filename_tmp = NULL;
	APTR app = NULL;
	LONG userdata = 0;

	// -------------------
	// Test args
	// -------------------
	if((apmsg == NULL)||((*apmsg) == NULL)||((*obj) == NULL)) return -1;

	// -------------------
	// Build the file name of the drop icon
	// -------------------
	wbarg = ((*apmsg)->am_ArgList);
	if(wbarg == NULL) return -1;
	filename_tmp = sslib_NameFromLock(wbarg->wa_Lock);
	if((wbarg->wa_Name) != NULL)
	{
		filename = buildEntirePathWithDirAndFilename(filename_tmp, wbarg->wa_Name);
		if(filename_tmp != NULL)free(filename_tmp);
	}
	else
	{
		filename = filename_tmp;
	}

	// -------------------
	// Update the file view
	// -------------------	  
	GetAttr(MUIA_ApplicationObject,obj,(ULONG*)(&app));
	if(app == NULL)
	{
		free(filename);
		return -1;
	}
	GetAttr(MUIA_UserData, (Object*)app,&userdata);
	if(userdata == 0)
	{
		free(filename);
		return -1;
	}
	AmdDragDropHookFuncCpp(userdata, obj, filename);
	
	free(filename);

	return 0;    
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
void AmdReqRefreshHookFunc(struct Hook *hook, struct FileRequester *req, struct IntuiMessage *imsg)
{
	if (imsg->Class==IDCMP_REFRESHWINDOW)
	{
		DoMethod(req->fr_UserData,MUIM_Application_CheckRefresh);
	}
}

