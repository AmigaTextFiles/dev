/* 
 * (c) Copyright 1989, 1990, 1991, 1992 OPEN SOFTWARE FOUNDATION, INC.
 * ALL RIGHTS RESERVED
*/ 
/*   $RCSfile: DrawingA.h,v $ $Revision: 1.18 $ $Date: 92/05/14 12:50:47 $ */
/*
*  (c) Copyright 1987, 1988, 1989, 1990, 1991, 1992 HEWLETT-PACKARD COMPANY */
#ifndef _XmDrawingArea_h
#define _XmDrawingArea_h

#include <Xm/Xm.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Class record constants */

externalref WidgetClass xmDrawingAreaWidgetClass;

typedef struct _XmDrawingAreaClassRec * XmDrawingAreaWidgetClass;
typedef struct _XmDrawingAreaRec      * XmDrawingAreaWidget;


#ifndef XmIsDrawingArea
#define XmIsDrawingArea(w)  (XtIsSubclass (w, xmDrawingAreaWidgetClass))
#endif



/********    Public Function Declarations    ********/
#ifdef _NO_PROTO

extern Widget XmCreateDrawingArea() ;

#else

extern Widget XmCreateDrawingArea( 
                        Widget p,
                        String name,
                        ArgList args,
                        Cardinal n) ;

#endif /* _NO_PROTO */
/********    End Public Function Declarations    ********/


#ifdef __cplusplus
}  /* Close scope of 'extern "C"' declaration which encloses file. */
#endif

#endif /* _XmDrawingArea_h */
/* DON'T ADD ANYTHING AFTER THIS #endif */
