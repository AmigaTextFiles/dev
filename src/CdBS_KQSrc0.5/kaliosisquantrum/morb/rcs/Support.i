head	0.6;
access;
symbols;
locks
	MORB:0.6; strict;
comment	@* @;


0.6
date	97.09.10.22.27.43;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.09.10.17.44.59;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.09.01.17.53.46;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.24.17.41.35;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.36.46;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.28.24;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.41;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.6
log
@Petite modif sans interêt.
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997, CdBS Software (MORB)
* Support include file
* $Id: Support.i 0.5 1997/09/10 17:44:59 MORB Exp MORB $
*

         rsreset
BlitNode rs.b      0

bn_Next            rs.l      1
bn_Code            rs.l      1
bn_CPUCode         rs.l      1
bn_HData           rs.l      1
bn_Data            rs.l      10

;bn_bltcon0         rs.w      1
;bn_bltcon1         rs.w      1
;bn_bltafwm         rs.w      1
;bn_bltalwm         rs.w      1
;bn_bltcpt          rs.l      1
;bn_bltbpt          rs.l      1
;bn_bltapt          rs.l      1
;bn_bltdpt          rs.l      1
;bn_bltsize         rs.w      1
;bn_bltcon0l        rs.w      1
;bn_bltsizv         rs.w      1
;bn_bltsizh         rs.w      1
;bn_bltcmod         rs.w      1
;bn_bltbmod         rs.w      1
;bn_bltamod         rs.w      1
;bn_bltdmod         rs.w      1

;bn_couin           rs.l      4

;bn_bltcdat         rs.w      1
;bn_bltbdat         rs.w      1
;bn_bltadat         rs.w      1

bn_Size  rs.b      0

         rsreset
GardenDwarf        rs.b      0
gdw_Data           rs.l      1
gdw_Attach         rs.l      1
gdw_X              rs.w      1
gdw_Y              rs.w      1
gdw_Height         rs.w      1
gdw_Size           rs.b      0
@


0.5
log
@Changement GardenDwarfique.
@
text
@d6 1
a6 1
* $Id: Support.i 0.4 1997/09/01 17:53:46 MORB Exp MORB $
d45 6
a50 6
gd_Data            rs.l      1
gd_Attach          rs.l      1
gd_X               rs.w      1
gd_Y               rs.w      1
gd_Height          rs.w      1
gd_Size            rs.b      0
@


0.4
log
@Modifs pour supporter les blits au cpu...
@
text
@d6 1
a6 1
* $Id: Support.i 0.3 1997/08/24 17:41:35 MORB Exp MORB $
d44 7
a50 7
CsSprite rs.b      0
csp_Data           rs.l      1
csp_Attach         rs.l      1
csp_X              rs.w      1
csp_Y              rs.w      1
csp_Height         rs.w      1
csp_Size           rs.b      0
@


0.3
log
@Ajout de la définition de la structure pour les sprite hard
@
text
@d6 1
a6 1
* $Id: Support.i 0.2 1997/08/22 18:36:46 MORB Exp MORB $
d13 2
a14 1
bn_Hook            rs.l      1
d16 1
d18 16
a33 16
bn_bltcon0         rs.w      1
bn_bltcon1         rs.w      1
bn_bltafwm         rs.w      1
bn_bltalwm         rs.w      1
bn_bltcpt          rs.l      1
bn_bltbpt          rs.l      1
bn_bltapt          rs.l      1
bn_bltdpt          rs.l      1
bn_bltsize         rs.w      1
bn_bltcon0l        rs.w      1
bn_bltsizv         rs.w      1
bn_bltsizh         rs.w      1
bn_bltcmod         rs.w      1
bn_bltbmod         rs.w      1
bn_bltamod         rs.w      1
bn_bltdmod         rs.w      1
d35 1
a35 1
bn_couin           rs.l      4
d37 3
a39 3
bn_bltcdat         rs.w      1
bn_bltbdat         rs.w      1
bn_bltadat         rs.w      1
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d40 9
@


0.1
log
@Sprotch
@
text
@d6 1
a6 2
* $Revision$
* $Date$
@


0.0
log
@*** empty log message ***
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d6 2
@
