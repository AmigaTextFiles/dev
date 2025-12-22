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
@/* module filesel.o */

#if !defined( INTUITION_INTUITION_H )
struct IntuiMessage ;
#endif

#if !defined( DEVICES_KEYMAP_H )
struct KeyMap ;
#endif

#if !defined( CLASS_SCREEN_H )
class screen ;
#endif

extern BOOL getfile(screen *screen,  STRPTR s, STRPTR title,  STRPTR drawer,
    STRPTR comment) ;

extern LONG DeadKeyConvert(IntuiMessage *msg, UBYTE *kbuffer, LONG kbsize,
    KeyMap *kmap) ;

extern BOOL getPath(STRPTR , STRPTR );
@
