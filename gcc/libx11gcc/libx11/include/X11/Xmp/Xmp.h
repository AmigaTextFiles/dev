#ifndef _Xmp_h_
#define _Xmp_h_
#include <X11/Xmp/COPY>

/*
* SCCS_data: @(#) Xmp.h 1.6 92/06/10 06:14:01
*
*	This module contains declarations useful to clients of the
*	Xmp library.
*
*******************************************************************************
*/

#include <X11/Wc/WcCreate.h>	/* for _() macro */

/* XmpRegisterMotif registers all Motif and Xmp widgets.
 * XmpRegisterAll and MriRegisterMotif are aliases for XmpRegisterMotif
 * for backward compatibility.
 */
void XmpRegisterMotif _(( XtAppContext ));
void XmpRegisterAll   _(( XtAppContext ));
void MriRegisterMotif _(( XtAppContext ));

void XmpAddMwmCloseCallback _(( Widget, XtCallbackProc, XtPointer ));

void XmpChangeNavigationType _(( Widget ));

#endif /* _Xmp_h_ */
