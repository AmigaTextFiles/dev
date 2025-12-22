/*
@(#)  FILE: str_util.h  RELEASE: 1.7  DATE: 01/03/97, 14:42:07
*/
/*******************************************************************************

    str_util.h

    String Manipulation Functions.

*******************************************************************************/

#ifndef  STR_UTIL_H		/* Has the file been INCLUDE'd already? */
#define  STR_UTIL_H  yes

#ifdef __cplusplus
    extern  "C" {
#endif


#include  <stddef.h>			/* Standard C definitions. */
#ifndef NO_STRDUP
#    include  <string.h>		/* Standard C string functions. */
#endif
#include  "ansi_setup.h"		/* ANSI or non-ANSI C? */


/*******************************************************************************
    Miscellaneous declarations.
*******************************************************************************/

extern  int  str_util_debug ;		/* Global debug switch (1/0 = yes/no). */


/*******************************************************************************
    Public functions.
*******************************************************************************/

extern  char  *strCat P_((const char *source,
                          int length,
                          char destination[],
                          size_t maxLength)) ;

extern  char  *strConvert P_((char *string)) ;

extern  char  *strCopy P_((const char *source,
                           int length,
                           char destination[],
                           size_t maxLength)) ;

extern  char  *strDestring P_((char *string,
                               int length,
                               const char *quotes)) ;

extern  size_t  strDetab P_((char *stringWithTabs,
                             int length,
                             int tabStops,
                             char *stringWithoutTabs,
                             size_t maxLength)) ;

extern  void  strEnv P_((const char *string,
                         int length,
                         char *translation,
                         size_t maxLength)) ;

extern  char  *strEtoA P_((char *string,
                           int length)) ;

extern  size_t  strInsert P_((const char *substring,
                              int subLength,
                              size_t offset,
                              char *string,
                              size_t maxLength)) ;

extern  int  strMatch P_((const char *target,
                          const char *model)) ;

extern  size_t  strRemove P_((size_t numChars,
                              size_t offset,
                              char *string)) ;

extern  char  *strToLower P_((char *string,
                              int length)) ;

extern  char  *strToUpper P_((char *string,
                              int length)) ;

extern  size_t  strTrim P_((char *string,
                            int length)) ;

#ifdef NO_STRDUP
    extern  char  *strdup P_((const char *string)) ;
#endif

extern  char  *strndup P_((const char *string,
                           size_t length)) ;


#ifdef __cplusplus
    }
#endif

#endif				/* If this file was not INCLUDE'd previously. */
