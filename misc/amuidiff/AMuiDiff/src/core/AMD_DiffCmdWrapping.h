#ifndef AMD_DIFFCMDWRAPPING_H
#define AMD_DIFFCMDWRAPPING_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :
*
*      Nom du module             :  $RCSfile: AMD_DiffCmdWrapping.h,v $
*      Version du module         :  $Revision: 1.3 $
*      Date de la version        :  $Date: 2003/05/17 23:40:31 $
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

/*******************************************************************
 * TYPES
*******************************************************************/
typedef enum
{
	AMD_DIFFTYPE_NONE,
	AMD_DIFFTYPE_ADD,
	AMD_DIFFTYPE_DELETE,
	AMD_DIFFTYPE_CHANGE,
	AMD_DIFFTYPE_ERROR
} amd_diff_type_t;
typedef struct
{
	LONG m_line1_begin;
	LONG m_line1_end;
	LONG m_line2_begin;
	LONG m_line2_end;
	amd_diff_type_t m_diff_type;
} amd_difference_t;

#endif //AMD_DIFFCMDWRAPPING_H
