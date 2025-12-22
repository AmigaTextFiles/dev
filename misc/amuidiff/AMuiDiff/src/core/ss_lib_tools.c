/********************************************************************
*      Societe                   :  
*      Affaire                   :  
*      Tache                     :  Librairie d'outils de base
*
*      Nom du module             :  $RCSfile: ss_lib_tools.c,v $
*      Version du module         :  $Revision: 1.7 $
*      Date de la version        :  $Date: 2003/06/21 16:23:35 $
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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

#include "SSDateLib_protos.h"

/*******************************************************************
 * VARIABLES GLOBALES EXPORTEES
*******************************************************************/
int UseDebugLog = 0; // Var used with AMD_ADDLOG_DEBUG() MACROelse

/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/

/* Gestion de chaines
**--------------------------------
*/
unsigned long txtbuf_GetNbColMax(const char *pm_txtbuf);

long ss_atol(const char *pm_str, long *pm_long);
long getOffsetForLine(const char *pm_buffer, const long pm_line_number);
long getLineForOffset(const char *pm_buffer, const long pm_offset);
long amd_AddLog(char *pm_message, ...);


/*******************************************************************
 * DEFINITION DES FONCTIONS
*******************************************************************/


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le
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
// Parametres en SORTIE : entire_file must be deallocated by calling function
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
long getOffsetForLine(const char *pm_buffer, const long pm_line_number)
{
	char *buffer = (char*)pm_buffer;
	long line_counter = 1;
	if(pm_buffer == NULL)	return -1;

	if(pm_line_number == 1) return 0;

	while((*buffer != NULL)&&(line_counter < pm_line_number))
	{
		if(*buffer == '\n')
		{
			line_counter++;
		}
		buffer++;
	}
	if(line_counter != pm_line_number)
	{
		return -1;
	}
	else
	{
		return ((unsigned long)buffer - (unsigned long)pm_buffer);
	}
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le
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
// Parametres en SORTIE : entire_file must be deallocated by calling function
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
long getLineForOffset(const char *pm_buffer, const long pm_offset)
{
	char *buffer = (char*)pm_buffer;
	long line_counter = 1;
	long off_counter = 0;
	if(pm_buffer == NULL)	return -1;

	while((*buffer != '\0')&&(off_counter < pm_offset))
	{
		if(*buffer == '\n')
		{
			line_counter++;
		}
		buffer++;
		off_counter++;
	}
	return line_counter;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS, le
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
// Parametres en SORTIE : entire_file must be deallocated by calling function
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
unsigned long txtbuf_GetNbColMax(const char *pm_txtbuf)
{
	unsigned long nb_cols = 0UL;
	unsigned long nb_cols_tmp = 0UL;
	if(pm_txtbuf == NULL)	 return 0UL;

	while((*pm_txtbuf) != '\0')
	{
		nb_cols_tmp++;
		if((*pm_txtbuf) == '\n')
		{
			if(nb_cols_tmp > nb_cols)
			{
				nb_cols = nb_cols_tmp;
			}
			nb_cols_tmp = 0UL;
		}
		pm_txtbuf++;
	}

	if(nb_cols_tmp > nb_cols)
	{
		nb_cols = nb_cols_tmp;
	}

	return nb_cols;
}

// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS,
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
long ss_atol(const char *pm_str, long *pm_long)
{
	char str_ligne[32];
	long int_ligne;

	// -------------------
	// Parameter integrity check
	// -------------------
	if((pm_str == NULL)||(pm_long == NULL)) return -1;

	// -------------------
	// atol + coherence check
	// -------------------
	int_ligne = atol(pm_str);
	sprintf(str_ligne, "%ld", int_ligne);
	if(strcmp(str_ligne, pm_str) == 0)
	{
		*pm_long = int_ligne;
		return 0;
	}
	else
	{
		return -1;
	}

}


// *************************************************************************
// ()
//
// ************************************
//
// Date et Auteur :      SS,
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
#define AMD_LOGFILE_FILENAME "PROGDIR:amuidif.log"
#define AMD_LOGFILE_BUFFSIZE 2048
long amd_AddLog(char *pm_message, ...)
{
	FILE *fd = NULL;
	va_list  	ap;
	static char	str_tmp[AMD_LOGFILE_BUFFSIZE];
	char *str_date = NULL;

	if(pm_message == NULL) return -1;

	/* Build message
	**--------------------------------
	*/
	va_start(ap, pm_message);
	vsnprintf(str_tmp, AMD_LOGFILE_BUFFSIZE-1, pm_message, ap);
	va_end(ap);
	str_date = ss_getdate();

	/* Open Log File
	**--------------------------------
	*/
	fd = fopen(AMD_LOGFILE_FILENAME, "a");
	if(fd == NULL)
    {
		return -1;
    }

	/* Write message
	**--------------------------------
	*/
	fprintf(fd, "AMuiDiffLog (%s): %s\n", (str_date != NULL ? str_date : ""), str_tmp);

	/* Close Log File
	**--------------------------------
	*/
	if(fd != NULL) {fclose(fd);fd=NULL;}
	if(str_date != NULL) {free(str_date); str_date = NULL;}
	return 0;
}
#undef AMD_LOGFILE
#undef AMD_LOGFILE_BUFFSIZE
