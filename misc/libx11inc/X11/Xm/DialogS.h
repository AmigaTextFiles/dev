/* 
 * (c) Copyright 1989, 1990, 1991, 1992 OPEN SOFTWARE FOUNDATION, INC.
 * ALL RIGHTS RESERVED
*/ 
/*   $RCSfile: DialogS.h,v $ $Revision: 1.12 $ $Date: 92/05/14 12:49:14 $ */
/*
*  (c) Copyright 1989, DIGITAL EQUIPMENT CORPORATION, MAYNARD, MASS. */
/*
*  (c) Copyright 1987, 1988, 1989, 1990, 1991, 1992 HEWLETT-PACKARD COMPANY */
/*
*  (c) Copyright 1988 MASSACHUSETTS INSTITUTE OF TECHNOLOGY  */
/*
*  (c) Copyright 1988 MICROSOFT CORPORATION */
#ifndef _XmDialogShell_h
#define _XmDialogShell_h

#include <Xm/Xm.h>

#ifdef __cplusplus
extern "C" {
#endif


#ifndef XmIsDialogShell
#define XmIsDialogShell(w)	XtIsSubclass(w, xmDialogShellWidgetClass)
#endif /* XmIsDialogShell */

externalref WidgetClass xmDialogShellWidgetClass;

typedef struct _XmDialogShellClassRec       * XmDialogShellWidgetClass;
typedef struct _XmDialogShellRec            * XmDialogShellWidget;


/********    Public Function Declarations    ********/
#ifdef _NO_PROTO

extern Widget XmCreateDialogShell() ;

#else

extern Widget XmCreateDialogShell( 
                        Widget p,
                        char *name,
                        ArgList al,
                        Cardinal ac) ;

#endif /* _NO_PROTO */
/********    End Public Function Declarations    ********/


#ifdef __cplusplus
}  /* Close scope of 'extern "C"' declaration which encloses file. */
#endif

#endif /* _XmDialogShell_h */
/* DON'T ADD STUFF AFTER THIS #endif */
