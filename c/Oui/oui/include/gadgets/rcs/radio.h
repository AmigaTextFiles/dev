head	1.3;
access;
symbols;
locks
	dlorre:1.3; strict;
comment	@ * @;


1.3
date	97.09.17.08.17.06;	author dlorre;	state Exp;
branches;
next	1.2;

1.2
date	97.07.14.04.27.19;	author dlorre;	state Exp;
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
@// $Id: radio.h 1.2 1997/07/14 04:27:19 dlorre Exp dlorre $
#ifndef CLASS_RADIO_H
#define CLASS_RADIO_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#if !defined( UTILITY_TAGITEM_H )
#include <utility/tagitem.h>
#endif

#ifndef CLASS_WINDOW_H
class window ;
#endif

#ifndef CLASS_GADGETLIST_H
class gadgetlist ;
#endif

#ifndef CLASS_GAGDET_H
#include "gadgets/gadget.h"
#endif


#define ORADIO_Base         (TAG_USER+100)
#define ORADIO_Active       (ORADIO_Base+0)
#define ORADIO_Flags        (ORADIO_Base+1)
#define ORADIO_Spacing      (ORADIO_Base+2)
#define ORADIO_Text         (ORADIO_Base+3)
#define ORADIO_TextArray    (ORADIO_Base+4)


// ========================================================================
// ==========================  RADIO CLASS ================================
// ========================================================================


class radio : public gadget
{
    STRPTR *mxlabs ;
    LONG   labsize ;
    LONG    spacing ;
public:
    LONG cursel ;
    STRPTR curstring ;
    radio(gadgetlist *gl,
          void (window::*func)(gadget *, unsigned long, unsigned short),
          TagItem *tags) ;

    radio(gadgetlist *gl,
          void (window::*func)(gadget *, unsigned long, unsigned short),
          ULONG tag1, ...) ;

    ~radio() ;
    void init(TagItem *tags) ;
    void action(unsigned long, unsigned short) ;
    void keystroke(BOOL shifted) ;
};

#endif
@


1.2
log
@*** empty log message ***
@
text
@d1 1
a1 1
// $Id$
d9 4
d25 9
d42 2
a43 1
    int     labsize ;
d45 1
a45 1
    int cursel ;
d49 1
a49 1
          long active, unsigned long flags, long spacing, const char **text) ;
d53 2
a54 1
          long active, unsigned long flags, long spacing, const char *t, ...) ;
d56 1
@


1.1
log
@Initial revision
@
text
@d1 1
d35 1
a35 1
          long active, unsigned long flags, long spacing, STRPTR *text) ;
d39 1
a39 1
          long active, unsigned long flags, long spacing, STRPTR t, ...) ;
@
