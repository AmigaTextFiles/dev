/*
@(#)  FILE: ansi_setup.h  RELEASE: 1.3  DATE: 04/24/96, 11:47:29
*/
/*******************************************************************************

    ansi_setup.h

    ANSI/Non-ANSI C Configuration.

*******************************************************************************/

#ifndef  ANSI_SETUP_H		/* Has the file been INCLUDE'd already? */
#define  ANSI_SETUP_H  yes


/* Configure the handling of function prototypes. */

#ifndef P_
#    if (__STDC__ == 1) || defined(__cplusplus) || defined(vaxc)
#        define  P_(s)  s
#    else
#        define  P_(s)  ()
#        define  const
#        define  volatile
#    endif
#endif


/* Supply the ANSI strerror(3) function on systems that don't support it. */

#if __STDC__
    /* Okay! */
#elif defined(VMS)
#    define  strerror(code)  strerror (code, vaxc$errno)
#else
    extern  int  sys_nerr ;		/* Number of system error messages. */
    extern  char  *sys_errlist[] ;	/* Text of system error messages. */
#    define  strerror(code) \
        (((code < 0) || (code >= sys_nerr)) ? "unknown error code" \
                                            : sys_errlist[code])
#endif


#endif				/* If this file was not INCLUDE'd previously. */
