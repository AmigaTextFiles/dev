/*
EditList.h

(C) Copyright 1993 Justin Miller
	This file is part of the IntuiGen package.
	Use of this code is pursuant to the license outlined in
	COPYRIGHT.txt, included with the IntuiGen package.

    As per COPYRIGHT.txt:

	1)  This file may be freely distributed providing that
	    it is unmodified, and included in a complete IntuiGen
	    2.0 package (it may not be distributed alone).

	2)  Programs using this code may not be distributed unless
	    their author has paid the Shareware fee for IntuiGen 2.0.
*/



#ifndef EDITLIST_H
#define EDITLIST_H

#include <IntuiGen/ListViewKind.h>
#include <IntuiGen/GTRequest.h>

/***********************************************************************/
/*  Set a GTPKind's Create field to this function to establish a       */
/*  Edit List pseudokind.					       */
/***********************************************************************/

__far struct Gadget *CreateEditListKind(struct GTPKind *kclass,struct Gadget *gad,
				  struct GTControl *gtc,struct GTRequest *req,
				  struct VisualInfo *vinfo);

#endif /* EDITLIST_H */


