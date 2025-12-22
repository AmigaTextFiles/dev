/********************************************************************
*      Society                   : PGES
*      Project                   : SSToolLib
*
*      Creation author           : SS
*      Module name               : $RCSfile: SSDateLib.c,v $
*      Module version            : $Revision: 1.1.1.1 $
*      Current version date      : $Date: 2003/04/08 15:03:45 $
*
*      Description               : I/O Tools (stdin, files, ...)
*
*      Host                      : C-ANSI
*      Target                    : C-ANSI
*
*      Programmation language    : C-ANSI
*      Creation date             : Tue Apr 08 15:56:51 2003
*
*      Prefixe                   : ss_
*
*      References                : -
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*                ----------------------------------
*
*      CVS history               : 
*         $Log: SSDateLib.c,v $
*         Revision 1.1.1.1  2003/04/08 15:03:45  saragaglia
*         First insertion in CVS.
*         Contains String, Date, and I/O libs
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/
#include <time.h>
#include <string.h>

/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/
char* ss_getdate(void);

/*******************************************************************
 * DEFINITION DES FONCTIONS
*******************************************************************/

/******************************************************************
 * Procedure         : ss_getdate()
 *
 * Description       : Retourne une chaine de la date courante
 *
 * Parametre entree  : -
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : char* : chaine de la date à liberer par un free par
 *                     l'appelant.
 *
 * Date Fonction     : Thu Aug 08 10:08:33 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
char* ss_getdate(void) 
{
  time_t now;
  char *str_ctime = NULL;
  char *str_ret   = NULL;
  char *str_tmp   = NULL;

  time(&now);
  str_ctime = ctime(&now);
  if(str_ctime == NULL)	return NULL;

  str_ret = strdup(str_ctime);
  if(str_ret == NULL)	return NULL;
  str_tmp = strchr(str_ret, '\n'); /* search '\n'... */
  if (str_tmp != NULL) 
    {
      *str_tmp = 0; /* ... and kill it */
    }

  //printf("Il est %.24s.\n", ctime(&now));
  return str_ret;
}
