/********************************************************************
 *      Society                   : PGES
 *      Project                   : SSToolLib
 *
 *      Creation author           : SS
 *      Module name               : $RCSfile: SSIoLib.c,v $
 *      Module version            : $Revision: 1.2 $
 *      Current version date      : $Date: 2003/04/09 14:18:59 $
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
 *      References                : fclc (usenet)
 *
 *         PGES proprietary and confidential information
 *          Copyright (C) PGES - (All rights reserved)
 *                ----------------------------------
 *
 *      CVS history               : 
 *         $Log: SSIoLib.c,v $
 *         Revision 1.2  2003/04/09 14:18:59  saragaglia
 *         Add : New function ss_fgetline() which read an entire line from a file, allocate a string which contains it, and return it...
 *         Modification : changed returned error-codes
 *
 *         Revision 1.1.1.1  2003/04/08 15:03:45  saragaglia
 *         First insertion in CVS.
 *         Contains String, Date, and I/O libs
 *
 *
 *******************************************************************/

/*******************************************************************
 * INCLUDES
 *******************************************************************/
/* C Lib
**--------------------------------
*/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* SS Tool Lib
**--------------------------------
*/
#include "SSMisc_protos.h"


/*******************************************************************
 * SIGNATURE DES FONCTIONS
 *******************************************************************/
int ss_getline(char *buf, size_t size);
char* ss_fgetline(FILE *pm_fd);

/*******************************************************************
 * DEFINITION DES FONCTIONS
 *******************************************************************/

/******************************************************************
 * Procedure         : ss_getline
 *
 * Description       : Lit une ligne de stdin avec fgets (+ controles).
 *
 * Parametre entree  : size_t size : taille maximum a lire dans stdin
 *
 * Parametre sortie  : char *buf : buffer alloua de taille au moins 
 *                     egale a size. Va etre rempli avec donnees
 *                     en provenance de stdin (moins '\n').
 *
 * Valeur retournee  : 0=Ok 1=Err 2=Incomplet
 *
 * Date Fonction     : Thu Aug 08 10:08:33 2002,   

 * Auteur            : usenet : fclc
 *
 ******************************************************************/
int ss_getline(char *pm_buf, size_t pm_size)
{
  int ret; /* 0=Ok -1=Err 1=Incomplet */
  
  if(pm_buf == NULL) return -1;

  if (fgets(pm_buf, pm_size, stdin) != NULL) 
    {
      char *p = strchr(pm_buf, '\n'); /* search '\n'... */
      if (p != NULL) 
        {
          *p = 0; /* ... and kill it */
          ret = 0;
        }
      else 
        {
          ret = 1;
        }
    }
  else 
    {
      ret = -1;
    }
  return ret;
}

/******************************************************************
 * Procedure         : ss_fgetline
 *
 * Description       : Return the whole current line in pm_fd (FILE*).
 *                     The Entire line is returned. Several fgets are performed
 *                     until the line is read. Warning : realloc is used...
 *
 * Parametre entree  : FILE *pm_fd : the open file in which the line is read.
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : char* : the read line. This line MUST be allocated by
 *                             the caller !!!!
 *
 * Date Fonction     : Wed Apr 09 11:10:01 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
#define SSFGET_BUF_NBMAX 1024
char* ss_fgetline(FILE *pm_fd)
{
  char *buf = NULL;
  int nb_alloc = 1;
  int is_complete = FALSE;
  
  /*--------------------------------
  ** INITIALISATION
  **--------------------------------
  */
  /* Allocation of the buffer
  **--------------------------------
  */
  buf = malloc((SSFGET_BUF_NBMAX+1)*sizeof(char));
  buf[0] = '\0';
  
  /* Parameter and buffer check
  **--------------------------------
  */
  if((pm_fd == NULL)||(buf == NULL)) return NULL;
  
  /*--------------------------------
  ** fgets read chunks of SSFGET_BUF_NBMAX bytes
  ** until the entire line is read.
  **--------------------------------
  */
  while(is_complete == FALSE)
    {
      /* The chunk is read without error
      **--------------------------------
      */
      if (fgets(&(buf[(nb_alloc-1)*SSFGET_BUF_NBMAX]), 
                SSFGET_BUF_NBMAX+1, pm_fd) != NULL) 
        {
          char *p = strchr(buf, '\n'); // search '\n'...
          if (p != NULL) 
            {
              *p = 0; // ... and kill it
              is_complete = TRUE; // End of line has been found...
            }
          else // etheir line not read until end, etheir EOF at end of line...
            {  // We try to read again.
              nb_alloc++;
              buf = realloc(buf, ((nb_alloc*SSFGET_BUF_NBMAX)+1)*sizeof(char));
            }
        }

      /* An error occured when reading the chunk.
      **--------------------------------
      */
      else 
        {
	  if(buf != NULL) 
	    {
	      if(strlen(buf) <= 0) // No chunk has been read...
		{
		  free(buf);       // ... we can free the buffer
		  buf = NULL;
		}
              is_complete = TRUE;
	    }
        }
    }
  
  return buf;
}
