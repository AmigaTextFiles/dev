head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@ * @;


1.2
date	97.07.14.04.26.33;	author dlorre;	state Exp;
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


1.2
log
@*** empty log message ***
@
text
@#ifndef CLASS_CSTRING_H
#define CLASS_CSTRING_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#if !defined( PLACETEXT_LEFT )
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


const char  INSIDECSTRING = 0 ;
const char  RIGHTCSTRING = 1 ;
const char  BOTTOMCSTRING = 2 ;
const char  WIDTHCSTRING = 4 ;
const char  HEIGHTCSTRING = 8 ;


// ========================================================================
// ==========================  CSTRING CLASS ==============================
// ========================================================================


class cstring : public gadget
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
    cstring(gadgetlist *gl,
            void (window::*func)(gadget *, unsigned long, unsigned short),
            const char*t, const char* text, long border=FALSE, long place=PLACETEXT_LEFT,
            char style=INSIDECSTRING) ;
    ~cstring() ;
    void set(const char *text) ;
    void keystroke(BOOL shifted) ;
};

#endif
@


1.1
log
@Initial revision
@
text
@d53 1
a53 1
            STRPTR t, STRPTR text, long border=FALSE, long place=PLACETEXT_LEFT, 
d56 1
a56 1
    void set(STRPTR text) ;
@
