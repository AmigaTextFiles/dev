head	1.2;
access;
symbols;
locks
	dlorre:1.2; strict;
comment	@// @;


1.2
date	97.07.14.04.23.26;	author dlorre;	state Exp;
branches;
next	1.1;

1.1
date	96.08.22.02.05.10;	author dlorre;	state Exp;
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
@// $Id$
#include <clib/macros.h>
#include "rectangle.h"

rectangle::rectangle(short l, short t, short w, short h)
{
    left = MAX(l, short(0)) ;
    top = MAX(t, short(0)) ;
    width = MAX(w, short(0));
    height = MAX(h, short(0)) ;
    minw = maxw = 0 ;
    minh = maxh = 0 ;
}
void rectangle::box(short l, short t, short w, short h)
{
    left = l ;
    top = t ;
    width = w ;
    height = h ;
    if ((left+width) > maxw) maxw = short(left+width) ;
    if ((top+height) > maxh) maxh = short(top+height) ;
}

void rectangle::relbox(short dx, short dy, short dw, short dh)
{
    box(dx+left, dy+top, dw+width, dh+height) ;
}

void rectangle::move(short dx, short dy) {
    box(dx+left, dy+top, width, height) ;
}


void rectangle::size(short dw, short dh) {
    box(left, top, dw+width, dh+height) ;
}

void rectangle::limits(short wmin, short hmin, short wmax, short hmax) {
    minw = MAX(wmin, short(0)) ;
    minh = MAX(hmin, short(0)) ;
    maxw = MAX(wmax, minw) ;
    maxh = MAX(hmax, minh) ;
}
@


1.1
log
@Initial revision
@
text
@d1 1
@
