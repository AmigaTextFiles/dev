/* 
 * (c) Copyright 1989, 1990, 1991, 1992 OPEN SOFTWARE FOUNDATION, INC.
 * ALL RIGHTS RESERVED
*/ 
/*   $RCSfile: DragOverS.h,v $ $Revision: 1.13 $ $Date: 92/05/14 12:50:25 $ */
/*
*  (c) Copyright 1990, 1991, 1992 HEWLETT-PACKARD COMPANY */
#ifndef _XmDragOverS_h
#define _XmDragOverS_h

#include <Xm/Xm.h>
#include <Xm/DragC.h>
#include <Xm/DragIcon.h>

#ifdef __cplusplus
extern "C" {
#endif


/***********************************************************************
 *
 * DragOverShell Widget
 *
 ***********************************************************************/

/* Class record constants */

typedef struct _XmDragOverShellRec 	*XmDragOverShellWidget;
typedef struct _XmDragOverShellClassRec 	*XmDragOverShellWidgetClass;

extern WidgetClass	xmDragOverShellWidgetClass;

#ifdef __cplusplus
}  /* Close scope of 'extern "C"' declaration which encloses file. */
#endif

#endif /* _XmDragOverS_h */
/* DON'T ADD STUFF AFTER THIS #endif */
