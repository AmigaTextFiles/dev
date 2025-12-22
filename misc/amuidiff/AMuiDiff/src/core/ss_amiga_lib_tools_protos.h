#ifndef SS_AMIGA_LIB_TOOLS_PROTOS_H
#define SS_AMIGA_LIB_TOOLS_PROTOS_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :  Librairie d'outils de base
*
*      Nom du module             :  $RCSfile: ss_amiga_lib_tools_protos.h,v $
*      Version du module         :  $Revision: 1.10 $
*      Date de la version        :  $Date: 2004/03/07 19:32:27 $
*
*      Description               :  Librairie d'outils de base pour l'aire au
*				    développement.
*
*      Auteurs                   :
*
*      Materiels necessaires     :
*      Systeme                   :
*
*      Langage de programmation  :  C ansi.
*      Date debut programmation  : Thu Aug 08 10:08:28 2002
*
*      Prefixe utilise           :
*      Taille du code (.o) en KO :
*
*      References                :
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/
// --------------------------------------------------------------------------
// C LIB
// --------------------------------------------------------------------------
#include <stdlib.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <exec/types.h>
#include <utility/hooks.h>

#include "ss_amiga_lib_tools.h"

/*******************************************************************
 * DEFINES
*******************************************************************/
#ifdef __MORPHOS__
#  ifdef DEBUG
#    define SSDEBUG(X...) sskprintf(X)
#  else
#    define SSDEBUG(X...)
#  endif
#else //AmigaOS 3.x
#  ifdef DEBUG
#    define SSDEBUG(X...) kprintf(X)
#  else
#    define SSDEBUG(X...)
#  endif
#endif


/*******************************************************************
 * SIGNATURES DE FONCTIONS
*******************************************************************/

#ifdef __cplusplus
extern "C"
{
#endif

	extern ULONG getFileSize(BPTR pm_file_desc);
	extern char* buildEntirePathWithDirAndFilename(const char *pm_dir, const char *pm_filename);
	extern char* sslib_req_getFile(const char *pm_reqtitle, const char *pm_dir, const struct Hook *pm_intuimsghook, const ULONG pm_requserdata);
	extern int sskprintf(char *fmt, ...);
	extern char* RelativePathToAbsolute(char *pm_rel_path);
	extern LONG sslib_GetStackSizeOfCurrentProcess(void);
	extern LONG sslib_InstallNewStack(ULONG pm_size, void (*pm_func)(void *arg), void *pm_arg);
	extern LONG NewSSStackSwap(struct StackSwapStruct *pm_stackstruct, void (*pm_func)(void *arg), void *pm_arg);
	extern char* sslib_NameFromLock(BPTR pm_lock);

	extern LONG NEW_sslib_filereq(sslib_filereq_t *pm_this, const struct Window *pm_win, const char *pm_reqtitle, const char *pm_dir, const struct Hook *pm_intuimsghook, const ULONG pm_requserdata);
	extern LONG DEL_sslib_filereq(sslib_filereq_t *pm_this);

	extern LONG NEW_sslib_filenotify(	sslib_filenotify_t *pm_this, 
										const struct MsgPort *pm_msgport,
										const struct Task *pm_task,
										const void *pm_userdata);
	extern LONG DEL_sslib_filenotify(sslib_filenotify_t *pm_this);
	extern BPTR CloneWorkbenchPath(struct WBStartup *wbmsg);
	extern void FreeWorkbenchPath(BPTR path);

#ifdef __cplusplus
}
#endif

#endif
