head	0.2;
access;
symbols;
locks
	MORB:0.2; strict;
comment	@* @;


0.2
date	97.08.22.18.30.51;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.18.19;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.28;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.2
log
@Changement RCS ($Id)
@
text
@*
* Macros for copper instructions
* ©1997, CdBS Software (MORB)
* $Id$
*

**** comove src,dest

comove   macro
         dc.w      \2,\1
         endm

**** cowait x,y

cowait   macro
         dc.b      \2,\1|1
         dc.w      $fffe
         endm

**** coskip x,y

coskip   macro
         dc.b      \2,\1|1
         dc.w      $ffff
         endm

**** cocol val,n

cocol    macro
         dc.w      color+\2*2,\1
         endm

**** conop
*** Puts 0 in dmacon, which does nothing but take two words
*** in the copperlist. Useful.

conop    macro
         dc.w      $96,0
         endm

**** coend

coend    macro
         dc.l      $fffffffe
         endm
@


0.1
log
@Première version historifiée
@
text
@d4 1
a4 2
* $Revision$
* $Date$
@


0.0
log
@*** empty log message ***
@
text
@d4 2
@
