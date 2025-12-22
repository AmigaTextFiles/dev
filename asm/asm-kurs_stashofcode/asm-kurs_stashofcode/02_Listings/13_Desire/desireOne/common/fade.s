;-------------------------------------------------------------------------------
;                                Fondu de palette
;
; Codé par Yragael / Denis Duplan (stashofcode@gmail.com) en mai 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

;Cette oeuvre est mise à disposition selon les termes de la Licence (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Attribution - Pas d’Utilisation Commerciale 4.0 International.

;---------- Initialisation ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation
;Sortie(s) :
;	(aucune)
;Notice :
;	L'algorithme d'interpolation pour chaque composante de chaque couleur (intégré ici pour limiter les BSR et les mouvements sur la pile d'une factorisation dans interpolator.s) :
;
;	// Initialisation de l'interpolateur (début)
;
;	if (NBSTEPS >= |Vend - Vstart| + 1) {
;		MAX = NBSTEPS
;		MIN = |Vend - Vstart| + 1
;	}
;	else {
;		MIN = NBSTEPS - 1
;		MAX = |Vend - Vstart|
;	}
;	ALPHA = MIN >> 1
;
;	// Initialisation de l'interpolateur (fin)
;
;	Vnow = Vstart
;
;	// Ici, du code pour utiliser Vnow
;
;	for (i = 0; i != NBSTEPS - 1; i ++) {
;
;		// Appel à l'interpolateur (début)
;
;		if (NBSTEPS >= |Vend - Vstart| + 1) {
;			ALPHA += MIN
;			if (ALPHA >= MAX) {
;				ALPHA -= MAX
;				Vnow += DELTA
;			}
;		}
;		else {
;			Vnow -= DELTA
;			while (ALPHA < MAX) {
;				ALPHA += MIN
;				Vnow += DELTA
;			}
;			ALPHA -= MAX
;		}
;
;		// Appel à l'interpolateur (fin)
;
;		// Ici, du code pour utiliser Vnow
;	}
;
;	Ce qui signifie qu'il faut avoir utilisé la valeur intiale de la composante avant d'appeler _fadeStep, car cet appel va d'emblée la faire évoluer.

_fadeSetup:
	movem.l d0-d6/a0-a3,-(sp)

	lea fadeState,a1
	move.w #DATASIZE_FADESETUP-1,d0
_fadeSetupCopySetup:
	move.b (a0)+,(a1)+
	dbf d0,_fadeSetupCopySetup

	lea fadeState,a0
	movea.l OFFSET_FADESETUP_PALETTESTART(a0),a1
	movea.l OFFSET_FADESETUP_PALETTEEND(a0),a2
	lea OFFSET_FADE_PALETTE(a0),a3
	move.w OFFSET_FADESETUP_NBCOLORS(a0),d0
	move.w OFFSET_FADESETUP_NBSTEPS(a0),d1
_fadeSetupBuildPalette:
	move.w (a1)+,d2
	move.w (a2)+,d3

	move.w d2,d4
	and.w #$0F00,d4
	lsr.w #8,d4
	move.b d4,OFFSET_FADERGB_VNOW(a3)
	move.b d4,OFFSET_FADERGB_VSTART(a3)
	move.w d3,d5
	and.w #$0F00,d5
	lsr.w #8,d5
	move.b d5,OFFSET_FADERGB_VEND(a3)
	moveq #1,d6
	sub.b d4,d5
	bge _fadeSetupRVdeltaPositive
	neg.b d6
	neg.b d5
_fadeSetupRVdeltaPositive:
	move.b d6,OFFSET_FADERGB_VSTEP(a3)
	addq.w #1,d5
	move.w d5,OFFSET_FADERGB_VDELTA(a3)
	move.w d1,d6
	cmp.w d6,d5
	ble _fadeSetupRNbColorsSmaller
	exg d6,d5
	subq.w #1,d5
	subq.w #1,d6
_fadeSetupRNbColorsSmaller:
	move.w d5,OFFSET_FADERGB_MIN(a3)
	move.w d6,OFFSET_FADERGB_MAX(a3)
	lsr.w #1,d5
	move.w d5,OFFSET_FADERGB_ALPHA(a3)

	lea DATASIZE_FADERGB(a3),a3

	move.w d2,d4
	and.w #$0F0,d4
	lsr.w #4,d4
	move.b d4,OFFSET_FADERGB_VNOW(a3)
	move.b d4,OFFSET_FADERGB_VSTART(a3)
	move.w d3,d5
	and.w #$00F0,d5
	lsr.w #4,d5
	move.b d5,OFFSET_FADERGB_VEND(a3)
	moveq #1,d6
	sub.b d4,d5
	bge _fadeSetupGVdeltaPositive
	neg.b d6
	neg.b d5
_fadeSetupGVdeltaPositive:
	move.b d6,OFFSET_FADERGB_VSTEP(a3)
	addq.w #1,d5
	move.w d5,OFFSET_FADERGB_VDELTA(a3)
	move.w d1,d6
	cmp.w d6,d5
	ble _fadeSetupGNbColorsSmaller
	exg d6,d5
	subq.w #1,d5
	subq.w #1,d6
_fadeSetupGNbColorsSmaller:
	move.w d5,OFFSET_FADERGB_MIN(a3)
	move.w d6,OFFSET_FADERGB_MAX(a3)
	lsr.w #1,d5
	move.w d5,OFFSET_FADERGB_ALPHA(a3)

	lea DATASIZE_FADERGB(a3),a3

	move.w d2,d4
	and.w #$000F,d4
	move.b d4,OFFSET_FADERGB_VNOW(a3)
	move.b d4,OFFSET_FADERGB_VSTART(a3)
	move.w d3,d5
	and.w #$000F,d5
	move.b d5,OFFSET_FADERGB_VEND(a3)
	moveq #1,d6
	sub.b d4,d5
	bge _fadeSetupBVdeltaPositive
	neg.b d6
	neg.b d5
_fadeSetupBVdeltaPositive:
	move.b d6,OFFSET_FADERGB_VSTEP(a3)
	addq.w #1,d5
	move.w d5,OFFSET_FADERGB_VDELTA(a3)
	move.w d1,d6
	cmp.w d6,d5
	ble _fadeSetupBNbColorsSmaller
	exg d6,d5
	subq.w #1,d5
	subq.w #1,d6
_fadeSetupBNbColorsSmaller:
	move.w d5,OFFSET_FADERGB_MIN(a3)
	move.w d6,OFFSET_FADERGB_MAX(a3)
	lsr.w #1,d5
	move.w d5,OFFSET_FADERGB_ALPHA(a3)

	lea DATASIZE_FADERGB(a3),a3
	
	subq.w #1,d0
	bne _fadeSetupBuildPalette

	movem.l (sp)+,d0-d6/a0-a3
	rts

;---------- Itération ----------

;Entrée(s) :
;	(aucune)
;Sortie(s) :
;	D0 = 1 si le fondu est terminé, sinon 0

FADE_MACRO:		MACRO
	move.b OFFSET_FADERGB_VNOW(a1),d3
	cmp.b OFFSET_FADERGB_VEND(a1),d3
	bne _fadeStepComponentNotAlreadyDone\@
	addq.b #1,d4
	bra _fadeStepComponentEnd\@
_fadeStepComponentNotAlreadyDone\@:
	
	cmp.w OFFSET_FADERGB_VDELTA(a1),d1
	blt _fadeStepNbStepsSmallerThanVdelta\@

	move.w OFFSET_FADERGB_ALPHA(a1),d2
	add.w OFFSET_FADERGB_MIN(a1),d2
	cmp.w OFFSET_FADERGB_MAX(a1),d2
	blt _fadeStepNoStep\@
	sub.w OFFSET_FADERGB_MAX(a1),d2
	add.b OFFSET_FADERGB_VSTEP(a1),d3
	move.b d3,OFFSET_FADERGB_VNOW(a1)
_fadeStepNoStep\@:
	move.w d2,OFFSET_FADERGB_ALPHA(a1)
	bra _fadeStepComponentDone\@
	
_fadeStepNbStepsSmallerThanVdelta\@:
	move.w OFFSET_FADERGB_ALPHA(a1),d2
_fadeStepRun\@:
	add.b OFFSET_FADERGB_VSTEP(a1),d3
	add.w OFFSET_FADERGB_MIN(a1),d2
	cmp.w OFFSET_FADERGB_MAX(a1),d2
	blt _fadeStepRun\@
	sub.w OFFSET_FADERGB_MAX(a1),d2
	move.b d3,OFFSET_FADERGB_VNOW(a1)
	move.w d2,OFFSET_FADERGB_ALPHA(a1)

_fadeStepComponentDone\@:
	cmp.b OFFSET_FADERGB_VEND(a1),d3
	bne _fadeStepComponentEnd\@
	addq.b #1,d4
_fadeStepComponentEnd\@:
	lea DATASIZE_FADERGB(a1),a1
	ENDM

_fadeStep:
	movem.l d1-d5/a0-a2,-(sp)

	;Calculer les nouvelles couleurs

	lea fadeState,a0
	move.w OFFSET_FADESETUP_NBCOLORS(a0),d0
	move.w OFFSET_FADESETUP_NBSTEPS(a0),d1
	lea OFFSET_FADE_PALETTE(a0),a1
	clr.w d5
_fadeStepFadeColor:
	clr.b d4

	FADE_MACRO
	FADE_MACRO
	FADE_MACRO

	cmpi.b #3,d4
	bne _fadeStepColorNotDone
	addq.b #1,d5
_fadeStepColorNotDone:

	subq.w #1,d0
	bne _fadeStepFadeColor

	;Copier les couleurs dans la Copper list

	movea.l OFFSET_FADESETUP_COPPERLIST(a0),a1
	lea 2(a1),a1
	move.w OFFSET_FADESETUP_NBCOLORS(a0),d0
	lea OFFSET_FADE_PALETTE(a0),a2
	moveq #32,d1
_fadeStepSetPalette:
	clr.w d2
	move.b OFFSET_FADERGB_VNOW(a2),d2
	lsl.w #4,d2
	lea DATASIZE_FADERGB(a2),a2
	or.b OFFSET_FADERGB_VNOW(a2),d2
	lsl.w #4,d2
	lea DATASIZE_FADERGB(a2),a2
	or.b OFFSET_FADERGB_VNOW(a2),d2
	lea DATASIZE_FADERGB(a2),a2
	move.w d2,(a1)
	lea 4(a1),a1
	subq.b #1,d1
	bne _fadeStepSamePalette
	lea 4(a1),a1
	moveq #32,d1
_fadeStepSamePalette:
	subq.w #1,d0
	bne _fadeStepSetPalette

	clr.w d0
	cmp.w OFFSET_FADESETUP_NBCOLORS(a0),d5
	bne _fadeStepPaletteNotDone
	moveq #1,d0
_fadeStepPaletteNotDone:
	movem.l (sp)+,d1-d5/a0-a2
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(aucune)
;Sortie(s) :
;	(aucune)

_fadeEnd:
	rts

;---------- Données ----------

fadeSetupData:
OFFSET_FADESETUP_PALETTESTART=0
OFFSET_FADESETUP_PALETTEEND=4
OFFSET_FADESETUP_NBCOLORS=8
OFFSET_FADESETUP_NBSTEPS=10
OFFSET_FADESETUP_COPPERLIST=12
DATASIZE_FADESETUP=4+4+2+2+4
	BLK.B DATASIZE_FADESETUP,0

fadeState:
OFFSET_FADE_FADESETUP=0
OFFSET_FADE_PALETTE=DATASIZE_FADESETUP
;La palette est composée de 256*3 structures FADERGB, une structure pour chacune des composantes R, G et B de chaque couleur
OFFSET_FADERGB_VNOW=0
OFFSET_FADERGB_VSTART=1
OFFSET_FADERGB_VEND=2
OFFSET_FADERGB_VSTEP=3
OFFSET_FADERGB_VDELTA=4
OFFSET_FADERGB_MIN=6
OFFSET_FADERGB_MAX=8
OFFSET_FADERGB_ALPHA=10
DATASIZE_FADERGB=1+1+1+1+2+2+2+2
DATASIZE_FADE=DATASIZE_FADESETUP+256*3*DATASIZE_FADERGB
	BLK.B DATASIZE_FADE,0