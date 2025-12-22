head	0.1;
access;
symbols;
locks; strict;
comment	@# @;


0.1
date	97.12.05.14.29.57;	author Troll;	state Exp;
branches;
next	;


desc
@Ground Mapper for Kaliosys Quantrum
RCS for GoldED · Initial login date: 12/05/97
@


0.1
log
@*** empty log message ***
@
text
@;$Id
;fs "Includes"
	incdir    "include:"
	include   "Libraries/GadTools_lib.i"
	include   "Libraries/GadTools.i"
	include   "exec/exec_lib.i"
	include   "exec/exec.i"
	include   "exec/memory.i"
	include   "devices/timer.i"
	include   "dos/dos_lib.i"
	include   "dos/dos.i"
	include   "dos/dosextens.i"
	include   "dos/dostags.i"
	include   "intuition/intuition_lib.i"
	include   "intuition/intuition.i"
	include   "intuition/screens.i"
	include   "graphics/graphics_lib.i"
	include   "graphics/rastport.i"
	include   "graphics/rpattr.i"
	include   "graphics/text.i"
	include   "graphics/layers_lib.i"

;fe
;fs "Equates"
exec_base EQU       4
TRUE      EQU       -1
FALSE     EQU       0
	machine   68020
;fe
;fs "Macros"
Call      macro
	IFGT      NARG-1
	Move.l    \2_base,a6
	ENDC
	Jsr       _LVO\1(a6)
	endm

OpenLib   macro     ;         OpenLib   name, rev, ?fail->
	Bra       \1_next
	IFND      \1_base
\1_base:  Ds.l      1
	ENDC
\1_name:  Dc.b      "\1.library",0
	Even
\1_next:  Lea       \1_name(pc),a1
	Moveq.l   \2,d0
	Call      OpenLibrary,exec
	Move.l    d0,\1_base
	Beq       \3
	endm

CloseLib  macro
	Move.l    \1_base(pc),a1
	Call      CloseLibrary,exec
	endm
;fe
;fs "chaine de version"
VERSION:  bra.s     Init
	Dc.b      "$VER: Ground Mapper for Kaliosys Quantrum 0.1 (06/12/97) ©1997, CdBS (Troll)"
	Even
;fe
;fs "Code"
;fe
@
