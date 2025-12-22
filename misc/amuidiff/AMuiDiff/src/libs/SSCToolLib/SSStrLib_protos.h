#ifndef SSSTRLIB_PROTOS_H
#define SSSTRLIB_PROTOS_H
/********************************************************************
*      Society                   : PGES
*      Project                   : SSToolLib
*
*      Creation author           : SS
*      Module name               : $RCSfile: SSStrLib_protos.h,v $
*      Module version            : $Revision: 1.5 $
*      Current version date      : $Date: 2003/06/21 17:13:10 $
*
*      Description               : Strings Tools
*                                  WARNING : IN THE COMPILATOR DEFINES, YOU 
*                                  MUST DEFINE UNIX, WIN, AMIGAOS
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
*         $Log: SSStrLib_protos.h,v $
*         Revision 1.5  2003/06/21 17:13:10  sara
*         SS : Added ss_strdup4() and ss_strdup5()
*
*         Revision 1.4  2003/05/18 00:23:52  sara
*         SS : ADD : Added the strdup3() function
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

/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/
#ifdef __cplusplus
extern "C"
{
#endif
  
  /* Classic string management
  **--------------------------------
  */
  extern char *ss_strdup(const char *pm_str);
  extern int ss_strcasecmp(const char *s1, const char *s2);
  extern const char* ss_strdup2(const char *pm_str1, const char *pm_str2);
  extern const char* ss_strdup3(const char *pm_str1, const char *pm_str2, const char *pm_str3);
  extern const char* ss_strdup4(const char *pm_str1, const char *pm_str2, const char *pm_str3, const char *pm_str4);
  extern const char* ss_strdup5(const char *pm_str1, const char *pm_str2, const char *pm_str3, const char *pm_str4, const char *pm_str5);

  /* File name management
  **--------------------------------
  */
  extern const char* ss_getPrefixFromFile(const char *pm_filename_withext);
  extern const char* ss_getPathBeforeFile(const char *pm_path);
  extern const char* ss_getFileAfterPath(const char *pm_path);

#ifdef __cplusplus
}
#endif

#endif //#ifndef SSSTRLIB_PROTOS_H
