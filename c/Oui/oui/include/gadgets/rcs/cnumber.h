head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@ * @;


1.3
date	97.07.14.04.27.40;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	96.08.28.20.08.37;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.06.07;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.3
log
@*** empty log message ***
@
text
@// $Id: cnumber.h 1.2 1996/08/28 20:08:37 dlorre Exp dlorre $
#ifndef CLASS_CNUMBER_H
#define CLASS_CNUMBER_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#define PLACETEXT_LEFT  0x0001  /* Right-align text on left side */
#endif

#ifndef CLASS_WINDOW_H
class window ;
#endif

#ifndef CLASS_GADGETLIST_H
class gadgetlist ;
#endif

#ifndef CLASS_GADGET_H
#include "gadgets/gadget.h"
#endif

const char  INSIDECNUMBER = 0 ;
const char  RIGHTCNUMBER = 1 ;
const char  BOTTOMCNUMBER = 2 ;
const char  WIDTHCNUMBER = 4 ;
const char  HEIGHTCNUMBER = 8 ;


// ========================================================================
// ==========================  CNUMBER CLASS ==============================
// ========================================================================


class cnumber : public gadget
{
    STRPTR      norm1 ;
    STRPTR      norm2 ;
    STRPTR      under ;

    IntuiText   *it1 ;
    IntuiText   *it2 ;
    IntuiText   *it3 ;

    TextFont    *font ;
    TTextAttr   *underline ;
    TTextAttr   *plain ;
public:
    cnumber(gadgetlist *gl,
            void (window::*func)(gadget *, unsigned long, unsigned short),
            const char* t, long val,
            long border=FALSE, long place=PLACETEXT_LEFT,
            char style=INSIDECNUMBER) ;
    ~cnumber() ;
    void set(LONG val) ;
    void keystroke(BOOL shifted) ;
};

#endif
@


1.2
log
@support proportionnel
@
text
@d1 1
a1 1
// $Id$
d53 1
a53 1
            STRPTR t, long val,
@


1.1
log
@Initial revision
@
text
@d1 1
d25 7
d49 1
d53 3
a55 1
            STRPTR titre, long val, long border=FALSE, long place=PLACETEXT_LEFT) ;
@
