head	0.5;
access;
symbols;
locks
	MORB:0.5; strict;
comment	@# @;


0.5
date	98.02.13.13.07.59;	author MORB;	state Exp;
branches;
next	0.4;

0.4
date	97.09.09.00.07.36;	author MORB;	state Exp;
branches;
next	0.3;

0.3
date	97.08.23.00.05.26;	author MORB;	state Exp;
branches;
next	0.2;

0.2
date	97.08.22.18.29.49;	author MORB;	state Exp;
branches;
next	0.1;

0.1
date	97.08.22.15.15.36;	author MORB;	state Exp;
branches;
next	0.0;

0.0
date	97.08.22.15.00.26;	author MORB;	state Exp;
branches;
next	;


desc
@Jeu à la beast avec des scrolls partout
RCS for GoldED · Initial login date: Aujourd'hui
@


0.5
log
@Ajout des buffers clavier
@
text
@*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* BSS Section
* $Id: BSS.s 0.4 1997/09/09 00:07:36 MORB Exp MORB $
*

	 section   gleurp,BSS

KBHBuf:
	 ds.b      KBLENGTH

KBAscBeg:
	 ds.b      KBABLENGTH
KBAscEnd:

KBRawBeg:
	 ds.b      KBRBLENGTH
KBRawEnd:

_MergeCopTmp:
	 ds.l      MaxCopperLayers+1
_CopperRepairBuffer:
	 ds.l      2*MaxCopperDamages

;RMapSize           = NbHorTile*NbVerTile*2
;RTblSize           = NbHorTile*NbVerTile*12+4

RMap1:
	 ds.b      880
RTbl1:
	 ds.b      5284
RMap2:
	 ds.b      880
RTbl2:
	 ds.b      5284
RTbl3:
	 ds.b      5284

_GuiTemp:
	 ds.b      ge_Size*100
_StrBuf:
	 ds.b      1024
_NameBuffer:
	 ds.b      40
_FRBuffer:
	 ds.b      FRBufferSize

_BlitQueue:
	 ds.b      bn_Size*BlitQueueSize

	 section   spouirfl,BSS_C
RipolinBuf:
	 ds.l      (16+4+3)*256
cl12buf:
	 ds.l      100
@


0.4
log
@Ajout du ripolin buf et de deux trois trucs.
@
text
@d4 1
a4 1
* ©1997, CdBS Software (MORB)
d6 1
a6 1
* $Id: BSS.s 0.3 1997/08/23 00:05:26 MORB Exp MORB $
d9 12
a20 1
         section   gleurp,BSS
d23 1
a23 1
         ds.l      MaxCopperLayers+1
d25 1
a25 1
         ds.l      2*MaxCopperDamages
d31 1
a31 1
         ds.b      880
d33 1
a33 1
         ds.b      5284
d35 1
a35 1
         ds.b      880
d37 1
a37 1
         ds.b      5284
d39 1
a39 1
         ds.b      5284
d42 7
a48 1
         ds.b      ge_Size*100
d51 1
a51 1
         ds.b      bn_Size*BlitQueueSize
d53 1
a53 1
         section   spouirfl,BSS_C
d55 1
a55 1
         ds.l      (16+3)*256
d57 1
a57 1
         ds.l      100
@


0.3
log
@Utilisation de BlitQueueSize au lieu de 1000 :^)
@
text
@d6 1
a6 1
* $Id: BSS.s 0.2 1997/08/22 18:29:49 MORB Exp MORB $
d19 1
a19 1
TestRMap:
d21 1
a21 1
TestRTbl:
d23 9
d37 2
@


0.2
log
@Changement RCS ($Id)
@
text
@d6 1
a6 1
* $Id$
d25 1
a25 1
         ds.b      bn_Size*1000
@


0.1
log
@Première version historifiée
@
text
@d2 1
a2 1
* CdBSian Obviously Universal & Interactive Nonsense (COUIN) v0.0
d6 1
a6 1
* $Revision$
@


0.0
log
@*** empty log message ***
@
text
@d6 1
@
