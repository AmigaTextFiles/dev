#ifndef SS_LIB_TOOLS_PROTOS_H
#define SS_LIB_TOOLS_PROTOS_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :  Librairie d'outils de base
*
*      Nom du module             :  $RCSfile: ss_lib_tools_protos.h,v $
*      Version du module         :  $Revision: 1.7 $
*      Date de la version        :  $Date: 2004/01/15 17:11:30 $
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
#include <stdarg.h>

// --------------------------------------------------------------------------
// Amiga LIB
// --------------------------------------------------------------------------
#include <exec/types.h>

/*******************************************************************
 * DEFINES
*******************************************************************/
extern int UseDebugLog;
#ifdef DEBUG
#  define SS_DEBUG_ON() (UseDebugLog = 1)
#  if (__STDC_VERSION__ >= 199901L)  //C99 ?
#    define SS_ADDLOG_DEBUG(X...)  if(UseDebugLog == 1)amd_AddLog(X, __VA_ARGS__)
#  else
#    ifdef __GNUC__
#      define SS_ADDLOG_DEBUG(X...)  if(UseDebugLog == 1)amd_AddLog(##X)/* __VA_ARGS__ does not works !!! :( Not C99 ??  amd_AddLog(X, __VA_ARGS__) */
#    endif //#ifdef __GNUC__
#  endif //if (__STDC_VERSION__ >= 199901L)  //C99 ?
#else //#ifdef DEBUG
# define SS_DEBUG_ON()
# define SS_ADDLOG_DEBUG(X...)
#endif //#ifdef DEBUG

/*******************************************************************
 * SIGNATURES DE FONCTIONS
*******************************************************************/

#ifdef __cplusplus
extern "C"
{
#endif

/* Gestion de chaines
**--------------------------------
*/
extern long getOffsetForLine(const char *pm_buffer, const long pm_line_number);
extern long getLineForOffset(const char *pm_buffer, const long pm_offset);

extern unsigned long txtbuf_GetNbColMax(const char *pm_txtbuf);

extern int ss_get_line(char *buf, size_t size, FILE* pm_fd);
extern long ss_atol(const char *pm_str, long *pm_long);
extern long amd_AddLog(char *pm_message, ...);

#ifdef __cplusplus
}
#endif

#endif
