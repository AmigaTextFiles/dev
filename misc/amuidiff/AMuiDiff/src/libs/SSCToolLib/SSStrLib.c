/********************************************************************
*      Society                   : PGES
*      Project                   : SSToolLib
*
*      Creation author           : SS
*      Module name               : $RCSfile: SSStrLib.c,v $
*      Module version            : $Revision: 1.7 $
*      Current version date      : $Date: 2003/06/21 17:13:10 $
*
*      Description               : Strings Tools
*
*      Host                      : C-ANSI
*      Target                    : C-ANSI
*
*      Programmation language    : C-ANSI
*      Creation date             : Tue Apr 08 15:56:51 2003
*
*      Prefixe                   : ss_
*
*      References                : BSD, ...
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*                ----------------------------------
*
*      CVS history               : 
*         $Log: SSStrLib.c,v $
*         Revision 1.7  2003/06/21 17:13:10  sara
*         SS : Added ss_strdup4() and ss_strdup5()
*
*         Revision 1.6  2003/05/18 00:23:31  sara
*         SS : ADD : Added the strdup3() function
*
*         Revision 1.5  2003/05/04 10:23:18  sara
*         SS : CHT : changed strdup2
*         	 CHT : changed AMIGA define
*
*         Revision 1.4  2003/04/16 09:18:41  saragaglia
*         ADD : include : stdio for sprintf
*
*         Revision 1.3  2003/04/15 12:03:11  saragaglia
*         ADD : New function which cat 2 strings : ss_strdup2()
*
*         Revision 1.2  2003/04/15 08:28:38  saragaglia
*         Add : 3 functions for file name management :
*         const char* ss_getPrefixFromFile(const char *pm_filename_withext);
*         const char* ss_getPathBeforeFile(const char *pm_path);
*         const char* ss_getFileAfterPath(const char *pm_path);
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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/*******************************************************************
 * DEFINES
*******************************************************************/
#if (defined(UNIX)||defined(AMIGAOSLIKE))
#   define DIR_TOKEN '/'
#else
#   if defined(WIN)
#      define DIR_TOKEN '\\'
#   else
       YOU MUST DEFINE UNIX, WIN, AMIGAOSLIKE IN YOUR IN YOUR COMPILATOR
       DIRECTIVES
#      define DIR_TOKEN '/'
#   endif
#endif

/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/
/* Classic string management
**--------------------------------
*/
char *ss_strdup(const char *pm_str);
const char* ss_strdup2(const char *pm_str1, const char *pm_str2);
const char* ss_strdup3(const char *pm_str1, const char *pm_str2, const char *pm_str3);
const char* ss_strdup4(const char *pm_str1, const char *pm_str2, const char *pm_str3, const char *pm_str4);
const char* ss_strdup5(const char *pm_str1, const char *pm_str2, const char *pm_str3, const char *pm_str4, const char *pm_str5);
int ss_strcasecmp(const char *s1, const char *s2);

/* File name management
**--------------------------------
*/
const char* ss_getPrefixFromFile(const char *pm_filename_withext);
const char* ss_getPathBeforeFile(const char *pm_path);
const char* ss_getFileAfterPath(const char *pm_path);


/*******************************************************************
 * DEFINITION DES FONCTIONS
*******************************************************************/

/******************************************************************
 * Procedure         : ss_strcasecmp
 *
 * Description       : Compare deux chaines de caracteres sans restriction
 *			de casse.
 *
 * Parametre entree  : s1 et s2 : les deux chaines à comparer.
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : int : 0 si les chaines sont identiques à la casse pres,
 *				1 sinon.
 *
 * Date Fonction     : Thu Aug 08 10:08:33 2002,   

 * Auteur            : BSD
 *
 ******************************************************************/
int ss_strcasecmp(const char *s1, const char *s2)
{
  /*
   * We only consider ASCII chars and don't anticipate
   * control characters (they are invalid in filenames
   * anyway).
   */
  while ((*s1 & 0x5f) == (*s2 & 0x5f)) 
    {
      if (!*s1++)	return 0;
      s2++;
    }
  return 1;
}

/******************************************************************
 * Procedure         : ss_strdup
 *
 * Description       : Alloue une nouvelle chaine de caractères, y copie
 *		       celle passee en parametre.
 *
 * Parametre entree  : pm_str : chaine d'initialisation
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : char* : nouvelle chaine allouee par malloc, 
 *				copie de pm_str.
 *
 * Date Fonction     : Tue Aug 13 11:37:51 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
char *ss_strdup(const char *pm_str)
{
  char *str_tmp = NULL;

  if(pm_str == NULL) return NULL;

  str_tmp = malloc((strlen(pm_str)+1)*sizeof(char));
  if(str_tmp == NULL) return NULL;

  strcpy(str_tmp, pm_str);
  return str_tmp;
}

/******************************************************************
 * Procedure         : ss_strdup2
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Tue Apr 15 14:10:35 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
const char* ss_strdup2(const char *pm_str1, const char *pm_str2)
{
	char *new_str   = NULL;
	size_t new_str_len = 0;

	if((pm_str1 == NULL)&&(pm_str2 == NULL))
	{
		return NULL;
	}

	if(pm_str1 != NULL) new_str_len+= strlen(pm_str1);
	if(pm_str2 != NULL) new_str_len+= strlen(pm_str2);
	new_str_len+= 1; // '\0'
	new_str = calloc(new_str_len, sizeof(char));
	if(new_str == NULL)
	{
		return NULL;
	}
	if(pm_str1 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str1);
	if(pm_str2 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str2);

	return new_str;
}

/******************************************************************
 * Procedure         : ss_strdup3
 *
 * Description       :
 *
 * Parametre entree  :
 *
 * Parametre sortie  :
 *
 * Valeur retournee  :
 *
 * Date Fonction     : Tue Apr 15 14:10:35 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
const char* ss_strdup3(const char *pm_str1, const char *pm_str2, const char *pm_str3)
{
	char *new_str   = NULL;
	size_t new_str_len = 0;

	if((pm_str1 == NULL)&&(pm_str2 == NULL)&&(pm_str3 == NULL))
	{
		return NULL;
	}

	if(pm_str1 != NULL) new_str_len+= strlen(pm_str1);
	if(pm_str2 != NULL) new_str_len+= strlen(pm_str2);
	if(pm_str3 != NULL) new_str_len+= strlen(pm_str3);
	new_str_len+= 1; // '\0'
	new_str = calloc(new_str_len, sizeof(char));
	if(new_str == NULL)
	{
		return NULL;
	}
	if(pm_str1 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str1);
	if(pm_str2 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str2);
	if(pm_str3 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str3);

	return new_str;
}

/******************************************************************
 * Procedure         : ss_strdup4
 *
 * Description       :
 *
 * Parametre entree  :
 *
 * Parametre sortie  :
 *
 * Valeur retournee  :
 *
 * Date Fonction     : Tue Apr 15 14:10:35 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
const char* ss_strdup4(const char *pm_str1, const char *pm_str2, const char *pm_str3, const char *pm_str4)
{
	char *new_str   = NULL;
	size_t new_str_len = 0;

	if((pm_str1 == NULL)&&(pm_str2 == NULL)&&(pm_str3 == NULL)&&(pm_str4 == NULL))
	{
		return NULL;
	}

	if(pm_str1 != NULL) new_str_len+= strlen(pm_str1);
	if(pm_str2 != NULL) new_str_len+= strlen(pm_str2);
	if(pm_str3 != NULL) new_str_len+= strlen(pm_str3);
	if(pm_str4 != NULL) new_str_len+= strlen(pm_str4);
	new_str_len+= 1; // '\0'
	new_str = calloc(new_str_len, sizeof(char));
	if(new_str == NULL)
	{
		return NULL;
	}
	if(pm_str1 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str1);
	if(pm_str2 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str2);
	if(pm_str3 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str3);
	if(pm_str4 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str4);

	return new_str;
}

/******************************************************************
 * Procedure         : ss_strdup5
 *
 * Description       :
 *
 * Parametre entree  :
 *
 * Parametre sortie  :
 *
 * Valeur retournee  :
 *
 * Date Fonction     : Tue Apr 15 14:10:35 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
const char* ss_strdup5(const char *pm_str1, const char *pm_str2, const char *pm_str3, const char *pm_str4, const char *pm_str5)
{
	char *new_str   = NULL;
	size_t new_str_len = 0;

	if((pm_str1 == NULL)&&(pm_str2 == NULL)&&(pm_str3 == NULL)&&(pm_str4 == NULL)&&(pm_str5 == NULL))
	{
		return NULL;
	}

	if(pm_str1 != NULL) new_str_len+= strlen(pm_str1);
	if(pm_str2 != NULL) new_str_len+= strlen(pm_str2);
	if(pm_str3 != NULL) new_str_len+= strlen(pm_str3);
	if(pm_str4 != NULL) new_str_len+= strlen(pm_str4);
	if(pm_str5 != NULL) new_str_len+= strlen(pm_str4);
	new_str_len+= 1; // '\0'
	new_str = calloc(new_str_len, sizeof(char));
	if(new_str == NULL)
	{
		return NULL;
	}
	if(pm_str1 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str1);
	if(pm_str2 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str2);
	if(pm_str3 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str3);
	if(pm_str4 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str4);
	if(pm_str5 != NULL) sprintf((char*)new_str, "%s%s", new_str, pm_str5);

	return new_str;
}

/******************************************************************
 * Procedure         : ss_getFileAfterPath
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Tue Apr 15 10:25:22 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
const char* ss_getFileAfterPath(const char *pm_path)
{
  char *str_tmp = NULL;

  /* Parameter check
  **--------------------------------
  */
  if(pm_path == NULL) return NULL;
  
  /* Find the last DIR_TOKEN in the string
  **--------------------------------
  */
  str_tmp = strrchr(pm_path, DIR_TOKEN);
  if(str_tmp != NULL)
    {
      return (strdup(++str_tmp)); // return the string after DIR_TOKEN
    }
  else
    {
#ifdef AMIGAOSLIKE
      str_tmp = strrchr(pm_path, ':'); // Find the device token
      if(str_tmp != NULL)
	{
	  return (strdup(++str_tmp)); // return the string after the device tok
	}
      else
	{
	  return NULL; // No device token found
	}
#else
      return NULL; // No DIR_TOKEN found
#endif
    }
}

/******************************************************************
 * Procedure         : ss_getPathBeforeFile
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Tue Apr 15 10:25:28 2003
 *
 * Auteur            : SSDIR_TOKEN
 *
 ******************************************************************/
const char* ss_getPathBeforeFile(const char *pm_path)
{
  char *str_tmp = NULL;
  char *new_str = NULL;

  /* Parameter check
  **--------------------------------
  */
  if(pm_path == NULL) return NULL;

  /* If the string end with a DIR_TOKEN, remove it (to obtain last directory)
  **--------------------------------
  */
  new_str = strdup(pm_path);
  if((new_str[strlen(new_str)-1]) == DIR_TOKEN) 
    new_str[strlen(new_str)-1] = '\0';
  if(new_str == NULL)
    {
      return NULL;
    }
  /* Find the last DIR_TOKEN in the string
  **--------------------------------
  */
  str_tmp = strrchr(new_str, DIR_TOKEN);
  if(str_tmp != NULL)
    {
      str_tmp[1] = '\0'; // end the string at the last DIR_TOKEN
      return new_str;
    }
  else
    {
#ifdef AMIGAOSLIKE
      str_tmp = strrchr(new_str, ':'); // Find the device token
      if(str_tmp != NULL)
	{
	  str_tmp[1] = '\0'; // end the string at the last device token
	  return new_str;
	}
      else
	{
	  return NULL; // No device token found
	}
#else
      return NULL; // No DIR_TOKEN found
#endif
    }
}

/******************************************************************
 * Procedure         : ss_getPrefixFromFile
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Tue Apr 15 10:25:34 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
const char* ss_getPrefixFromFile(const char *pm_filename_withext)
{
  char *filename_withoutext = NULL;
  char *str_tmp = NULL;

  /* Parameter check
  **--------------------------------
  */
  if(pm_filename_withext == NULL) return NULL;

  /* Find the last '.' token in the string
  **--------------------------------
  */
  filename_withoutext = strdup(pm_filename_withext);
  str_tmp = strrchr(filename_withoutext, '.');
  if(str_tmp != NULL)
    {
      str_tmp[0] = '\0'; // end the string at the last '.' token
    }

  return filename_withoutext; // return the string whithout extension if there 
                              // was one or as is, if there was not...
}
