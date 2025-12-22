/*
@(#)  FILE: opt_util.h  RELEASE: 1.3  DATE: 03/16/95, 12:06:59
*/
/*******************************************************************************

    opt_util.h

    Command Line Option Processing Definitions.

*******************************************************************************/

#ifndef  OPT_UTIL_H		/* Has the file been INCLUDE'd already? */
#define  OPT_UTIL_H  yes

#ifdef __cplusplus
    extern  "C" {
#endif


#include  "ansi_setup.h"		/* ANSI or non-ANSI C? */


/*******************************************************************************
    Option Scan (Client View) and Definitions.
*******************************************************************************/

typedef  struct  _OptContext  *OptContext ;	/* Option scan context. */

/* Values returned by OPT_GET(). */

#define  OPTEND  0			/* End of command line. */
#define  OPTERR  -1			/* Invalid option or missing argument. */
#define  NONOPT  -2			/* Non-option argument. */


/*******************************************************************************
    Miscellaneous declarations.
*******************************************************************************/

extern  int  opt_util_debug ;		/* Global debug switch (1/0 = yes/no). */

/*******************************************************************************
    Function prototypes and external definitions for OPT_UTIL functions.
*******************************************************************************/

extern  int  opt_create_argv P_((const char *program,
                                 const char *command,
                                 int *argc,
                                 char *(*argv[]))) ;

extern  int  opt_delete_argv P_((int argc,
                                 char *argv[])) ;

extern  int  opt_errors P_((OptContext scan,
                            int display_flag)) ;

extern  int  opt_get P_((OptContext scan,
                         char **argument)) ;

extern  int  opt_index P_((OptContext scan)) ;

extern  int  opt_init P_((int argc,
                          char *argv[],
                          int is_list, ...)) ;

extern  char  *opt_name P_((OptContext scan,
                            int index)) ;

extern  int  opt_reset P_((OptContext scan,
                           int argc,
                           char *argv[])) ;

extern  int  opt_set P_((OptContext scan,
                         int new_index)) ;

extern  int  opt_term P_((OptContext scan)) ;


#ifdef __cplusplus
    }
#endif

#endif				/* If this file was not INCLUDE'd previously. */
