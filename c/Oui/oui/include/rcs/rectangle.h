head	1.1;
access;
symbols;
locks
	dlorre:1.1; strict;
comment	@ * @;


1.1
date	96.08.22.02.05.49;	author dlorre;	state Exp;
branches;
next	;


desc
@Oui.lib -- Object User Interface
Projet créé en 1994
Auteur: Dominique Lorre
@


1.1
log
@Initial revision
@
text
@#ifndef CLASS_RECTANGLE_H
#define CLASS_RECTANGLE_H 1

class rectangle
{
public:
    short maxw ;    // MaxWidth
    short maxh ;    // MaxHeight
    short minw ;    // MinWidth
    short minh ;    // MinHeight

    short left ;    // Left Edge
    short top ;     // Top Edge
    short width ;   // Width
    short height ;  // Height

    rectangle(short l, short, short w, short h) ;
    virtual ~rectangle() {}
    void box(short l, short t, short w, short h) ;
    void relbox(short dx, short dy, short dw, short dh) ;
    virtual void move(short dx, short dy=0) ;
    virtual void size(short dw, short dh=0) ;
    virtual void limits(short wmin, short hmin, short wmax, short hmax) ;
 };
#endif
@
