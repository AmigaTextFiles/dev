head	0.23;
access;
symbols;
locks
	MORB:0.23; strict;
comment	@# @;


0.23
date	98.02.13.13.23.02;	author MORB;	state Exp;
branches;
next	0.22;

0.22
date	98.02.13.13.16.53;	author MORB;	state Exp;
branches;
next	0.21;

0.21
date	98.02.11.12.04.13;	author MORB;	state Exp;
branches;
next	0.20;

0.20
date	98.01.06.18.18.20;	author MORB;	state Exp;
branches;
next	0.19;

0.19
date	98.01.04.16.42.50;	author MORB;	state Exp;
branches;
next	0.18;

0.18
date	98.01.01.12.02.25;	author MORB;	state Exp;
branches;
next	0.17;

0.17
date	97.12.31.19.28.17;	author MORB;	state Exp;
branches;
next	0.16;

0.16
date	97.12.14.19.58.54;	author MORB;	state Exp;
branches;
next	0.15;

0.15
date	97.11.04.22.09.39;	author MORB;	state Exp;
branches;
next	0.14;

0.14
date	97.11.04.22.05.44;	author MORB;	state Exp;
branches;
next	0.13;

0.13
date	97.11.04.21.54.06;	author MORB;	state Exp;
branches;
next	0.12;

0.12
date	97.09.29.17.48.41;	author MORB;	state Exp;
branches;
next	0.11;

0.11
date	97.09.14.21.58.13;	author MORB;	state Exp;
branches;
next	0.10;

0.10
date	97.09.14.17.06.47;	author MORB;	state Exp;
branches;
next	0.9;

0.9
date	97.09.13.11.51.31;	author MORB;	state Exp;
branches;
next	0.8;

0.8
date	97.09.11.21.42.01;	author MORB;	state Exp;
branches;
next	0.7;

0.7
date	97.09.11.21.25.34;	author MORB;	state Exp;
branches;
next	0.6;

0.6
date	97.09.11.17.22.25;	author MORB;	state Exp;
branches;
next	0.5;

0.5
date	97.09.10.21.29.01;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.08.25.13.38.23;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.22.19.39.39;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.32.45;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.19.42;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.29;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.23
log
@Inclusion de keymap_lib.i
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Main source
* $Id: Couin.s 0.22 1998/02/13 13:16:53 MORB Exp MORB $
*

;fs "Includes"
	 machine   68020
	 incdir    "IncludeIII:"
	 include   "exec/exec_lib.i"
	 include   "exec/memory.i"
	 include   "exec/lists.i"
	 include   "exec/nodes.i"
	 include   "dos/dos_lib.i"
	 include   "dos/dos.i"
	 include   "dos/dosextens.i"
	 include   "dos/exall.i"
	 include   "utility/tagitem.i"
	 include   "intuition/intuition_lib.i"
	 include   "intuition/intuitionbase.i"
	 include   "intuition/intuition.i"
	 include   "intuition/screens.i"
	 include   "graphics/graphics_lib.i"
	 include   "graphics/gfxbase.i"
	 include   "libraries/lowlevel_lib.i"
	 include   "libraries/lowlevel.i"
	 include   "libraries/keymap_lib.i"
	 include   "hardware/custom.i"
	 include   "hardware/dmabits.i"
	 include   "asm:debug.i"
;fe
;fs "Macros"
CALL     macro
	 jsr       _LVO\1(a6)
	 endm

TRUE     = -1
FALSE    = 0

gdwarfpt = sprpt

AbsExecBase        = 4
CustomBase         = $dff000
BlitQueueSize      = 100
;fe
	 include   "KaliosisQuantrum_rev.i"
;fs "Chaîne de version"
	 bra.s     _Init

	 dc.b      0,"$VER: "
	 VERS
	 dc.b      " ("
	 DATE
	 dc.b      ") ©1997-1998, CdBS Software",0
	 even
;fe

DISABLEGUIGFX      SET       0

	 include   "Support.i"
	 include   "Playfield.i"
	 include   "Copper.i"
	 include   "CopIns.i"
	 include   "OO.i"
	 include   "GuiSupport.i"
	 include   "Gui.i"
	 include   "Editor.i"
	 include   "Init.s"
	 include   "Iconify.s"
	 include   "ScreenSwitch.s"
	 include   "Main.s"
	 include   "Keyboard.s"
	 include   "Support.s"
	 include   "Playfield.s"
	 include   "Copper.s"
	 include   "Scrolls.s"
	 include   "Ripolin.s"
	 include   "MapEditor.s"
	 include   "AutoCrop.s"
	 include   "OO.s"
	 include   "GuiSupport.s"
	 include   "Gui.s"
	 include   "Editor.s"
	 include   "Test.s"
	 include   "ChipDats.s"
	 include   "BSS.s"

	 END
@


0.22
log
@Inclusion de keyboard.s
@
text
@d6 1
a6 1
* $Id: Couin.s 0.21 1998/02/11 12:04:13 MORB Exp MORB $
d29 1
@


0.21
log
@Ajout de DISABLEGUIGFX
@
text
@d6 1
a6 1
* $Id: Couin.s 0.20 1998/01/06 18:18:20 MORB Exp MORB $
d73 1
@


0.20
log
@Ajout de Editor.s et Editor.i
@
text
@d6 1
a6 1
* $Id: Couin.s 0.19 1998/01/04 16:42:50 MORB Exp MORB $
d58 2
@


0.19
log
@Quelques changements sans importance de noms de fichiers
@
text
@d6 1
a6 1
* $Id: Couin.s 0.18 1998/01/01 12:02:25 MORB Exp MORB $
d66 1
d81 1
@


0.18
log
@Modif Copyright (newyear=grunt)
@
text
@d6 1
a6 1
* $Id: Couin.s 0.17 1997/12/31 19:28:17 MORB Exp MORB $
d47 1
a47 1
	 include   "KaliosysQuantrum_rev.i"
a58 1
	 incdir    "prj:KaliosysQuantrum"
@


0.17
log
@Petit changement d'ordre des fichiers
@
text
@d4 1
a4 1
* ©1997, CdBS Software (MORB)
d6 1
a6 1
* $Id: Couin.s 0.16 1997/12/14 19:58:54 MORB Exp MORB $
d55 1
a55 1
	 dc.b      ") ©1997, CdBS Software",0
@


0.16
log
@Inclusion de OO.i et OO.s
@
text
@d6 1
a6 1
* $Id: Couin.s 0.15 1997/11/04 22:09:39 MORB Exp MORB $
a75 1
	 include   "Test.s"
d81 1
@


0.15
log
@Ouups
@
text
@d6 1
a6 1
* $Id: Couin.s 0.14 1997/11/04 22:05:44 MORB Exp MORB $
d10 22
a31 22
         machine   68020
         incdir    "IncludeIII:"
         include   "exec/exec_lib.i"
         include   "exec/memory.i"
         include   "exec/lists.i"
         include   "exec/nodes.i"
         include   "dos/dos_lib.i"
         include   "dos/dos.i"
         include   "dos/dosextens.i"
         include   "dos/exall.i"
         include   "utility/tagitem.i"
         include   "intuition/intuition_lib.i"
         include   "intuition/intuitionbase.i"
         include   "intuition/intuition.i"
         include   "intuition/screens.i"
         include   "graphics/graphics_lib.i"
         include   "graphics/gfxbase.i"
         include   "libraries/lowlevel_lib.i"
         include   "libraries/lowlevel.i"
         include   "hardware/custom.i"
         include   "hardware/dmabits.i"
         include   "asm:debug.i"
d35 2
a36 2
         jsr       _LVO\1(a6)
         endm
d47 1
a47 1
         include   "KaliosysQuantrum_rev.i"
d49 1
a49 1
         bra.s     _Init
d51 6
a56 6
         dc.b      0,"$VER: "
         VERS
         dc.b      " ("
         DATE
         dc.b      ") ©1997, CdBS Software",0
         even
d59 25
a83 23
         incdir    "prj:KaliosysQuantrum"
         include   "Support.i"
         include   "Playfield.i"
         include   "Copper.i"
         include   "CopIns.i"
         include   "GuiSupport.i"
         include   "Gui.i"
         include   "Init.s"
         include   "Iconify.s"
         include   "ScreenSwitch.s"
         include   "Main.s"
         include   "Support.s"
         include   "Playfield.s"
         include   "Copper.s"
         include   "Scrolls.s"
         include   "Ripolin.s"
         include   "Test.s"
         include   "MapEditor.s"
         include   "AutoCrop.s"
         include   "GuiSupport.s"
         include   "Gui.s"
         include   "ChipDats.s"
         include   "BSS.s"
d85 1
a85 1
         END
@


0.14
log
@Abandon de version.i et utilisation de bumprev (rcs rulez :-)
@
text
@d6 1
a6 1
* $Id: Couin.s 0.13 1997/11/04 21:54:06 MORB Exp MORB $
d47 1
a59 1
         include   "KaliosysQuantrum_rev.i"
@


0.13
log
@Introduction et utilisation de version.i
@
text
@d6 1
a6 1
* $Id: Couin.s 0.12 1997/09/29 17:48:41 MORB Exp MORB $
d49 6
a54 2
         COUINVSTR
         dc.b      0
d59 1
a59 1
         include   "Version.i"
@


0.12
log
@Plusieurs modifs de trucs
@
text
@d6 1
a6 1
* $Id: Couin.s 0.11 1997/09/14 21:58:13 MORB Exp MORB $
d18 2
d49 2
a50 1
         dc.b      0,"$VER: COUIN 0.0 (22.7.97) ©1997, CdBS Software (MORB) $",0
d55 1
@


0.11
log
@Tout bougeu aléatoirement pour diverses raisons très bonnes.
@
text
@d6 1
a6 1
* $Id: Couin.s 0.10 1997/09/14 17:06:47 MORB Exp MORB $
d14 2
d56 1
d70 1
@


0.10
log
@Intégratu MapEditor.s
@
text
@d6 1
a6 1
* $Id: Couin.s 0.9 1997/09/13 11:51:31 MORB Exp MORB $
d59 5
a67 5
         include   "Copper.s"
         include   "Ripolin.s"
         include   "Scrolls.s"
         include   "Support.s"
         include   "Playfield.s"
@


0.9
log
@Rajoutement de AutoCrop.s
@
text
@d6 1
a6 1
* $Id: Couin.s 0.8 1997/09/11 21:42:01 MORB Exp MORB $
d60 1
@


0.8
log
@Najoutu deux trois trucs.
@
text
@d6 1
a6 1
* $Id: Couin.s 0.7 1997/09/11 21:25:34 MORB Exp MORB $
d60 1
@


0.7
log
@Misenplaçu truc iconify.s bidule. Et tout.
@
text
@d6 1
a6 1
* $Id: Couin.s 0.6 1997/09/11 17:22:25 MORB Exp MORB $
d19 2
d33 3
@


0.6
log
@Nerajoutu truc ScreenSwitch là, machin.
@
text
@d6 1
a6 1
* $Id: Couin.s 0.5 1997/09/10 21:29:01 MORB Exp MORB $
d16 1
d51 1
@


0.5
log
@Nincludu scrolls.s
@
text
@d6 1
a6 1
* $Id: Couin.s 0.4 1997/08/25 13:38:23 MORB Exp MORB $
d50 1
@


0.4
log
@Inclusion de Test.s. A enlever un beau jour...
@
text
@d6 1
a6 1
* $Id: Couin.s 0.3 1997/08/22 19:39:39 MORB Exp MORB $
d31 2
d35 1
a35 1
BlitQueueSize      = 1200
d54 2
@


0.3
log
@Essai RCS truc
@
text
@d6 1
a6 1
* $Id: Couin.s 0.2 1997/08/22 18:32:45 MORB Exp MORB $
d33 1
a33 1
BlitQueueSize      = 1000
d49 1
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d37 1
a37 1
         dc.b      0,"$VER: COUIN 0.0 (22.7.97) ©1997, CdBS Software (MORB)",0
@


0.1
log
@Première version historifiée
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
