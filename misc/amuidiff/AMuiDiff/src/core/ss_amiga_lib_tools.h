#ifndef SS_AMIGA_LIB_TOOLS_H
#define SS_AMIGA_LIB_TOOLS_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :  Librairie d'outils de base
*
*      Nom du module             :  $RCSfile: ss_amiga_lib_tools.h,v $
*      Version du module         :  $Revision: 1.2 $
*      Date de la version        :  $Date: 2004/01/15 17:07:58 $
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
#include <dos/notify.h>

/*******************************************************************
 * TYPES
*******************************************************************/
typedef struct SSLIB_FILEREQ_T
{
	struct FileRequester *ssfr_req;

	char* (*ssfr_OpenFileReq)(struct SSLIB_FILEREQ_T *pm_this);
}sslib_filereq_t;

typedef struct SSLIB_FILENOTIFY_T
{
	struct NotifyRequest *ssfn_not;
	BOOL                 ssfn_isStarted;

	BOOL (*ssfn_StartWithFile)(struct SSLIB_FILENOTIFY_T *pm_this, char* pm_filename);
	BOOL (*ssfn_Stop)(struct SSLIB_FILENOTIFY_T *pm_this);
}sslib_filenotify_t;


/*******************************************************************
 * SIGNATURES DE FONCTIONS
*******************************************************************/

#endif
