;-------------------------------------------------------------------------------
;           Affichage de pages de texte avec animation des caractères
;
; Codé par Yragael / Denis Duplan (stashofcode@gmail.com) en mai 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

;Ce(tte) oeuvre est mise à disposition selon les termes de la Licence (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Attribution - Pas d’Utilisation Commerciale 4.0 International.

;---------- Initialisation ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de prtPrinterSetupData)
;Sortie(s) :
;	(aucune)

_prtSetup:
	movem.l d0/a0-a1,-(sp)

	lea prtPrinterState,a1
	move.w #DATASIZE_PRINTERSETUP-1,d0
_prtSetupCopySetup:
	move.b (a0)+,(a1)+
	dbf d0,_prtSetupCopySetup

	lea prtPrinterState,a0
	move.b #1,OFFSET_PRINTER_PAGEDELAY(a0)
	move.l OFFSET_PRINTERSETUP_TEXT(a0),OFFSET_PRINTER_CHAR(a0)

	movem.l (sp)+,d0/a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(aucune)
;Sortie(s) :
;	D0 = 1 si le dernier caractère vient d'être affiché, sinon 0

_prtPrint:
	movem.l d1/a0-a4,-(sp)

	;########## Tester si le délai entre deux pages s'est écoulé ##########

	lea prtPrinterState,a0
	move.b OFFSET_PRINTER_PAGEDELAY(a0),d0
	blt _prtNoPageDelay		;Le délai est inhibé par -1 tant que toutes les lignes de la page ne sont pas affichées
	subq.b #1,d0
	bne _prtPageDelayNotElapsed		;BNE qui fait que si PAGEDELAY a été passé à 1, l'affichage débute immédiatement

	;Effacer la page

	WAIT_BLITTER
	move.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a0),BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	;USED=1
	move.w #$0000,BLTCON1(a5)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a0),BLTDPTH(a5)
	move.w OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a0),d0
	lsl.w #6,d0
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0),d1
	lsr.w #1,d1
	or.w d1,d0
	move.w d0,BLTSIZE(a5)
	WAIT_BLITTER

	;Passer à la page suivante (cycler les pages)

	movea.l OFFSET_PRINTER_CHAR(a0),a1
	move.b (a1),d0
	bge _prtNoPagesLoop	;Tous les caractères vont de $20 (32) à $20 + 95 - 1 (126), donc seul EOP est < 0
	move.l OFFSET_PRINTERSETUP_TEXT(a0),OFFSET_PRINTER_CHAR(a0)
_prtNoPagesLoop:
	move.b #-1,OFFSET_PRINTER_PAGEDELAY(a0)		;Nouvelle page, donc le délai entre pages est inhibé
	move.b #1,OFFSET_PRINTER_CHARDELAY(a0)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a0),OFFSET_PRINTER_BITPLANELINE(a0)
	move.l OFFSET_PRINTER_BITPLANELINE(a0),OFFSET_PRINTER_BITPLANECHAR(a0)
	bra _prtNoPageDelay		;Commencer à afficher tout de suite la nouvelle page

_prtPageDelayNotElapsed:
	move.b d0,OFFSET_PRINTER_PAGEDELAY(a0)
	bra _prtDone
_prtNoPageDelay:

	;########## Tester si le délai entre caractères s'est écoulé ##########

	move.b OFFSET_PRINTER_CHARDELAY(a0),d0
	subq.b #1,d0
	bne _prtCharDelayNoElapsed

	;Afficher un caractère (en sautant des lignes et des espaces autant que nécessaire)

	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a0),d2
	movea.l OFFSET_PRINTER_BITPLANECHAR(a0),a1
	movea.l OFFSET_PRINTER_CHAR(a0),a2
_prtNextChar:
	move.b (a2)+,d1

	;Sauter les lignes ($00) consécutifs

	bne _prtNoNewLine
	move.l OFFSET_PRINTER_BITPLANELINE(a0),a1
	lsl.w #3,d2
_prtSkipLines:
	lea (a1,d2.w),a1
	move.b (a2)+,d1
	beq _prtSkipLines
	move.l a1,OFFSET_PRINTER_BITPLANELINE(a0)
	move.l a1,OFFSET_PRINTER_BITPLANECHAR(a0)
	lsr.w #3,d2
_prtNoNewLine:

	;Tester la fin de la page

	tst.b d1
	bge _prtNoEndOfLine	;Tous les caractères vont de $20 (32) à $20 + 95 - 1 (126), donc seul EOP est < 0
	move.l a2,OFFSET_PRINTER_CHAR(a0)
	move.b OFFSET_PRINTERSETUP_PAGEDELAY(a0),OFFSET_PRINTER_PAGEDELAY(a0)
	bra _prtDone
_prtNoEndOfLine:

	;Sauter les espaces ($20) consécutifs

	subi.b #$20,d1
	bne _prtNoSpace
_prtSkipSpaces:
	lea 1(a1),a1
	move.b (a2)+,d1			;ça pourrait être un -1 ou un 0.... on voit pas l'intérêt, mais bon : rajouter la gestion de ces cas
	subi.b #$20,d1
	beq _prtSkipSpaces
_prtNoSpace:

	movea.l OFFSET_PRINTERSETUP_FONT(a0),a3
	and.w #$00FF,d1
	lsl.w #3,d1
	lea (a3,d1.w),a3
	movea.l a1,a4
	REPT 8
	move.b (a3)+,(a4)
	lea (a4,d2.w),a4
	ENDR
	lea 1(a1),a1

	move.l a2,OFFSET_PRINTER_CHAR(a0)
	move.l a1,OFFSET_PRINTER_BITPLANECHAR(a0)
	move.b OFFSET_PRINTERSETUP_CHARDELAY(a0),d0

_prtCharDelayNoElapsed:
	move.b d0,OFFSET_PRINTER_CHARDELAY(a0)

_prtDone:
	movem.l (sp)+,d1/a0-a4
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(aucune)
;Sortie(s) :
;	(aucune)

_prtEnd:
	rts

;---------- Données ----------

prtPrinterSetupData:
OFFSET_PRINTERSETUP_BITPLANE=0
OFFSET_PRINTERSETUP_BITPLANEWIDTH=4
OFFSET_PRINTERSETUP_BITPLANEMODULO=6
OFFSET_PRINTERSETUP_BITPLANEHEIGHT=8
OFFSET_PRINTERSETUP_CHARDELAY=10
OFFSET_PRINTERSETUP_PAGEDELAY=11
OFFSET_PRINTERSETUP_FONT=12
OFFSET_PRINTERSETUP_TEXT=16
DATASIZE_PRINTERSETUP=4+2+2+2+1+1+4+4
	BLK.B DATASIZE_PRINTERSETUP,0
prtPrinterState:
OFFSET_PRINTER_PRINTERSETUP=0
OFFSET_PRINTER_CHAR=DATASIZE_PRINTERSETUP
OFFSET_PRINTER_BITPLANELINE=DATASIZE_PRINTERSETUP+4
OFFSET_PRINTER_BITPLANECHAR=DATASIZE_PRINTERSETUP+8
OFFSET_PRINTER_CHARDELAY=DATASIZE_PRINTERSETUP+12
OFFSET_PRINTER_PAGEDELAY=DATASIZE_PRINTERSETUP+13
DATASIZE_PRINTER=DATASIZE_PRINTERSETUP+4+4+4+1+1
	BLK.B DATASIZE_PRINTER,0
