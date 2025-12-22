#ifndef SS_PROC_LIB_H
#define SS_PROC_LIB_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :  Librairie d'outils de base
*
*      Nom du module             :  $RCSfile: SSProcLib.h,v $
*      Version du module         :  $Revision: 1.1 $
*      Date de la version        :  $Date: 2004/01/25 21:04:06 $
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

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <utility/tagitem.h>

/*******************************************************************
 * DEFINES
*******************************************************************/

typedef enum
{
	SSPT_STACK = TAG_USER,
	SSPT_PRIORITY,
}ssproc_tags_t;

#endif //#ifndef SS_PROC_LIB_H
