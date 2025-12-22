head	1.1;
access;
symbols;
locks
	dlorre:1.1; strict;
comment	@ * @;


1.1
date	97.07.14.04.23.43;	author dlorre;	state Exp;
branches;
next	;


desc
@compiler definitions (SASC/GNUC)
@


1.1
log
@Initial revision
@
text
@// $Id$
// compiler.h : this file handles hopefully your favorite compiler

#if defined( __SASC__ ) || defined( __STORMC__ )
#define GETA4   /* */
#define SAVEDS  __saveds
#define FAR     __far
#define ALIGNED __aligned
#define STDARGS __stdargs
#endif

#if defined( __GNUG__ )
#include "GNU/stabs.h"
#define GETA4   geta4()
#define SAVEDS  /* */
#define FAR     /* */
#define ALIGNED /* */
#define STDARGS /* */
extern "C" void geta4(void) ;
#endif
@
