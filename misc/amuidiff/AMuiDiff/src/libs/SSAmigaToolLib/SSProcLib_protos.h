#ifndef SS_PROC_LIB_PROTOS_H
#define SS_PROC_LIB_PROTOS_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :  Librairie d'outils de base
*
*      Nom du module             :  $RCSfile: SSProcLib_protos.h,v $
*      Version du module         :  $Revision: 1.5 $
*      Date de la version        :  $Date: 2004/01/25 21:03:23 $
*
*      Description               : 
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
#include <utility/tagitem.h>

/*******************************************************************
 * DEFINES
*******************************************************************/


/*******************************************************************
 * SIGNATURES DE FONCTIONS
*******************************************************************/

#ifdef __cplusplus
extern "C"
{
#endif

	extern long CreateProcessExe(char *pm_exe, char *pm_args, struct TagItem *pm_tags);
	extern long CreateProcessFunc(void (*pm_func)(void*), void *pm_arg, struct TagItem *pm_tags);
	extern long ssproc_Init(void);
	extern void ssproc_End(void);

#ifdef __cplusplus
}
#endif

#endif //#ifndef SS_PROC_LIB_PROTOS_H
