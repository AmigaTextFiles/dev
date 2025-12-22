/*
@(#)  FILE: list_util.h  RELEASE: 1.4  DATE: 02/29/96, 14:29:59
*/
/*******************************************************************************

    list_util.h

    List Manipulation Utility Definitions.

*******************************************************************************/

#ifndef  LIST_UTIL_H		/* Has the file been INCLUDE'd already? */
#define  LIST_UTIL_H  yes

#ifdef __cplusplus
    extern  "C" {
#endif


#include  "ansi_setup.h"		/* ANSI or non-ANSI C? */


/*******************************************************************************
    List Structure (Client View) and Definitions.
*******************************************************************************/

typedef  struct  ListNode  *List ;	/* List handle. */


/*******************************************************************************
    Public functions.
*******************************************************************************/

extern  int  listAdd P_((List *list,
                         int position,
                         void *item)) ;

extern  void  *listDelete P_((List *list,
                              int position)) ;

extern  int  listFind P_((List list,
                          void *item)) ;

extern  void  *listGet P_((List list,
                           int position)) ;

extern  int  listLength P_((List list)) ;


#ifdef __cplusplus
    }
#endif

#endif				/* If this file was not INCLUDE'd previously. */
