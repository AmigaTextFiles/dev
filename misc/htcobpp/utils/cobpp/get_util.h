/*
@(#)  FILE: get_util.h  RELEASE: 1.6  DATE: 07/12/96, 15:44:41
*/
/*******************************************************************************

    get_util.h

    "Get Next" Functions.

*******************************************************************************/

#ifndef  GET_UTIL_H		/* Has the file been INCLUDE'd already? */
#define  GET_UTIL_H  yes

#ifdef __cplusplus
    extern  "C" {
#endif


#include  "ansi_setup.h"		/* ANSI or non-ANSI C? */


/*******************************************************************************
    Public functions.
*******************************************************************************/

extern  char  *getarg P_((const char *arg,
                          int *length)) ;

extern  char  *getfield P_((const char *s,
                            int *length)) ;

extern  char  *getstring P_((const char *last_argument,
                             const char *quotes,
                             int *length)) ;

extern  char  *getword P_((const char *string,
                           const char *delimiters,
                           int *length)) ;


#ifdef __cplusplus
    }
#endif

#endif				/* If this file was not INCLUDE'd previously. */
