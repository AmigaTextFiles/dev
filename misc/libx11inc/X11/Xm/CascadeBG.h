/* 
 * (c) Copyright 1989, 1990, 1991, 1992 OPEN SOFTWARE FOUNDATION, INC.
 * ALL RIGHTS RESERVED
*/ 
/*   $RCSfile: CascadeBG.h,v $ $Revision: 1.10 $ $Date: 92/05/14 12:48:34 $ */
/*
*  (c) Copyright 1989, DIGITAL EQUIPMENT CORPORATION, MAYNARD, MASS. */
/*
*  (c) Copyright 1987, 1988, 1989, 1990, 1991, 1992 HEWLETT-PACKARD COMPANY */
#ifndef _XmCascadeBG_h
#define _XmCascadeBG_h

#include <Xm/Xm.h>

#ifdef __cplusplus
extern "C" {
#endif

externalref WidgetClass xmCascadeButtonGadgetClass;

typedef struct _XmCascadeButtonGadgetClassRec    * XmCascadeButtonGadgetClass;
typedef struct _XmCascadeButtonGadgetRec         * XmCascadeButtonGadget;
typedef struct _XmCascadeButtonGCacheObjRec      * XmCascadeButtonGCacheObject;

/*fast subclass define */
#ifndef XmIsCascadeButtonGadget
#define XmIsCascadeButtonGadget(w)     XtIsSubclass(w, xmCascadeButtonGadgetClass)
#endif /* XmIsCascadeButtonGadget */


/********    Public Function Declarations    ********/
#ifdef _NO_PROTO

extern Widget XmCreateCascadeButtonGadget() ;
extern void XmCascadeButtonGadgetHighlight() ;

#else

extern Widget XmCreateCascadeButtonGadget( 
                        Widget parent,
                        char *name,
                        ArgList al,
                        Cardinal ac) ;
extern void XmCascadeButtonGadgetHighlight( 
                        Widget wid,
#if NeedWidePrototypes
                        int highlight) ;
#else
                        Boolean highlight) ;
#endif /* NeedWidePrototypes */

#endif /* _NO_PROTO */
/********    End Public Function Declarations    ********/


#ifdef __cplusplus
}  /* Close scope of 'extern "C"' declaration which encloses file. */
#endif

#endif /* _XmCascadeBG_h */
/* DON'T ADD ANYTHING AFTER THIS #endif */
