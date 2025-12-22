;-------------------------------------------------------------------------------
;                        Affichage et effacement de BOB
;
; Codé par Yragael / Denis Duplan (stashofcode@gmail.com) en août 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

;Ce(tte) oeuvre est mise à disposition selon les termes de la Licence (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Attribution - Pas d’Utilisation Commerciale 4.0 International.

;---------- Effacement d'un BOB masqué dans une surface en RAWB ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de bobClearBOBData)
;Sortie(s) :
;	(rien)
;Notice:
;	C'est un peu plus que l'effacement d'un BOB, car la largeur de la zone
;	recopiée de la source dans la destination peut être quelconque.
;
;	La largeur de la zone à copier est limitée à DISPLAY_DX (autrement, il faut
;	modifier la taille de copyMaskData).
;
;	Attention ! Pas de WAIT_BLITTER à la fin.

_bobClearBOB:
	movem.l d0-d4/a1,-(sp)

	WAIT_BLITTER

	;++++++++++ Construire le masque (rappel : concernant A, BLTAFWM et BLTALWM seront combinés par AND si le BOB tient sur un mot) ++++++++++

	;Dans tous les cas, le masque comprend au moins un mot, initialisé par défaut à $FFFF et comptabilisé. Noter que le nombre de mots ne dépassant certainement pas 255, la comptabilisation s'effectuera sur un octet (ie : des ADDQ.B et non des ADDQ.W par la suite).
	
	lea bobClearBOBMask,a1
	move.w #$FFFF,(a1)
	moveq #1,d4
	move.w OFFSET_CLEARBOB_X(a0),d0
	move.w OFFSET_CLEARBOB_DX(a0),d1
	move.w d0,d2
	add.w d1,d2

	;Décaler le premier mot du masque si jamais le BOB ne commence pas à une abscisse multiple de 16.

	move.w #$FFFF,d3
	and.w #$000F,d0		;Pour rappel, LSR Dx,Dy = LSR (Dx % 64),Dy : pour LSR (Dx % 16),Dy, il suffirait donc d'effacer les bits 5-4 de D0 par AND.B #$0F,D0, mais D0 va servir pour un ADD.W plus loin, si bien qu'il faut aussi effacer ses 8 bits de poids forts.
	beq _bobCopyAreaNoFirstWordShift
	lsr.w d0,d3
	move.w d3,(a1)
_bobCopyAreaNoFirstWordShift:

	;Réduire le nombre de bits du masque restant à traiter du nombre de bits du masque figurant (ou pouvant figurer, car le masque est peut-être moins large) dans le premier mot : DX -= 16 - X. Cette longueur devient nulle ou négative si jamais le masque tient le seul premier mot. Dans ce cas, entreprendre directement de déterminer le dernier mot.

	subi.w #16,d1
	add.w d0,d1
	ble _bobCopyAreaNoMiddleWords

	;A ce stade, on sait que le masque s'étend au-delà du premier mot, sur au moins un mot supplementaire. Trois cas de figure sont possibles (un mot médian est un mot dont tous les bits sont à 1, le mot final est un mot dont seuls certains bits sont à 1) : (1) des mots médians sans mot final, (2) des mots médians et un mot final, (3) un mot final uniquement. Pour l'heure, comptabiliser un mot de plus et initialiser ce mot à $FFFF.
	
	moveq #2,d4
	lea 2(a1),a1
	move.w #$FFFF,(a1)

	;Dénombrer les mots médians : c'est la longueur restante divisée par 16. S'il n'y a pas de mots médians, entreprendre directement de déterminer le dernier mot.

	lsr.w #4,d1
	beq _bobCopyAreaNoMiddleWords

	;Ajouter le nombre de mots médians au nombre de mots en considérant pour l'heure que le mot final est un mot médian, si bien qu'il aurait déjà été comptabilisé plus tôt (MOVEQ #2,d4).

	add.b d1,d4
	subq.b #1,d4

	;Ajouter les mots médians, qui sont donc des mot à $FFFF.

	move.w #$FFFF,d0
_bobCopyAreaSetMiddleWords:
	move.w d0,(a1)+
	subq.w #1,d1
	bne _bobCopyAreaSetMiddleWords

	;Vérifier si le mot final n'est pas un mot médian...

	and.b #$0F,d2
	beq _bobCopyAreaNoLastWordShift

	;...et si le mot final n'est pas un mot médian, comptabiliser un mot de plus et initialiser ce mot à $FFFF. Comme il sera inutile de refaire ce test, entreprendre directement de décaler le mot final.

	addq.b #1,d4
	move.w #$FFFF,(a1)
	bra _bobCopyAreaShiftLastWord
_bobCopyAreaNoMiddleWords:

	;On arrive ici qu'il y ait des mots médians ou non. Le mot courant est le mot final. Il peut être confondu avec le premier mot. Si tel n'est pas le cas, il a été initialisé à $FFFF. C'est pourquoi le masque calculé ici est combiné par AND avec le mot courant pour produire le mot final.

	move.w #$FFFF,d0
	and.b #$0F,d2
	beq _bobCopyAreaNoLastWordShift
_bobCopyAreaShiftLastWord:
	lsr.w d2,d0
	not.w d0
	and.w d0,(a1)
_bobCopyAreaNoLastWordShift:

	;Incontournables, ces affectations ont été repoussées à la fin pour ne pas avoir à les faire figurer plusieurs fois dans tout ce qui précéde.

	move.w d0,BLTALWM(a5)
	move.w d3,BLTAFWM(a5)

	;++++++++++ Calculer les pointeurs et les modulos ++++++++++

	;Calculer l'offset les pointeurs de la source et de la destination

	moveq #0,d0
	move.w OFFSET_CLEARBOB_X(a0),d0
	lsr.w #3,d0
	and.b #$FE,d0
	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d1
	lsr.w #3,d1
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1
	mulu OFFSET_CLEARBOB_Y(a0),d1
	add.l d1,d0

	movea.l OFFSET_CLEARBOB_SRC(a0),a1
	add.l d0,a1
	move.l a1,BLTAPTH(a5)
	movea.l OFFSET_CLEARBOB_DST(a0),a1
	add.l d0,a1
	move.l a1,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.l #bobClearBOBMask,BLTBPTH(a5)

	;Calculer les modulos

	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d0
	lsr.w #3,d0
	move.w d4,d1
	add.w d1,d1
	sub.w d1,d0
	move.w d0,BLTAMOD(a5)
	move.w d0,BLTCMOD(a5)
	move.w d0,BLTDMOD(a5)
	neg.w d1
	move.w d1,BLTBMOD(a5)

	;++++++++++ Copier ++++++++++

	move.w #$0FF2,BLTCON0(a5)		;ASH3-0=0, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC
	move.w #$0000,BLTCON1(a5)
	move.w OFFSET_CLEARBOB_DY(a0),d1
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1
	lsl.w #6,d1
	or.w d4,d1
	move.w d1,BLTSIZE(a5)

	movem.l (sp)+,d0-d4/a1
	rts

bobClearBOBData:
OFFSET_CLEARBOB_DEPTH=0
OFFSET_CLEARBOB_X=2
OFFSET_CLEARBOB_Y=4
OFFSET_CLEARBOB_DX=6
OFFSET_CLEARBOB_DY=8
OFFSET_CLEARBOB_SRC=10
OFFSET_CLEARBOB_DST=14
OFFSET_CLEARBOB_SRCDSTWIDTH=18
DATASIZE_CLEARBOB=20
	BLK.B DATASIZE_CLEARBOB,0

bobClearBOBMask:
	BLK.W DISPLAY_DX>>4,0

;---------- Effacement d'un BOB non masqué dans une surface en RAWB ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de bobClearBOBData)
;Sortie(s) :
;	(rien)
;Notice:
;	C'est une version optimisée de _bobClearBOB, qui se contente de recopier tous
;	les mots même partiellement occupés par le BOB, sans donc les masquer. La
;	même structure de données est utilisée.
;
;	Attention ! Pas de WAIT_BLITTER à la fin.

_bobClearBOBFast:
	movem.l d0-d3/a1,-(sp)

	WAIT_BLITTER

	;Calculer le nombre de mots partiellement ou intégralement concernés

	moveq #0,d3
	move.w OFFSET_CLEARBOB_X(a0),d0
	move.w OFFSET_CLEARBOB_DX(a0),d1
	move.w d1,d2
	add.w d0,d2

	and.w #$000F,d0
	beq _bobClearBOBFastLeftAligned
	moveq #1,d3
	subi.w #16,d1
	add.w d0,d1
	ble _bobClearBOBFastRightAligned
_bobClearBOBFastLeftAligned:
	lsr.w #4,d1
	add.b d1,d3
	and.b #$0F,d2
	beq _bobClearBOBFastRightAligned
	addq.b #1,d3
_bobClearBOBFastRightAligned:

	;Calculer l'offset des pointeurs de la source et de la destination

	moveq #0,d0
	move.w OFFSET_CLEARBOB_X(a0),d0
	lsr.w #3,d0
	and.b #$FE,d0
	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d1
	lsr.w #3,d1
	mulu OFFSET_CLEARBOB_DEPTH(a0),d1
	mulu OFFSET_CLEARBOB_Y(a0),d1
	add.l d1,d0

	movea.l OFFSET_CLEARBOB_SRC(a0),a1
	add.l d0,a1
	move.l a1,BLTBPTH(a5)
	movea.l OFFSET_CLEARBOB_DST(a0),a1
	add.l d0,a1
	move.l a1,BLTDPTH(a5)

	;Calculer les modulos

	move.w OFFSET_CLEARBOB_SRCDSTWIDTH(a0),d0
	lsr.w #3,d0
	move.w d3,d1
	add.w d1,d1
	sub.w d1,d0
	move.w d0,BLTBMOD(a5)
	move.w d0,BLTDMOD(a5)

	;Copier

	move.w #$05CC,BLTCON0(a5)		;USEA=0, USEB=1, USEC=0, USED=1, D=B
	move.w #$0000,BLTCON1(a5)
	move.w OFFSET_CLEARBOB_DY(a0),d0
	mulu OFFSET_CLEARBOB_DEPTH(a0),d0
	lsl.w #6,d0
	or.w d3,d0
	move.w d0,BLTSIZE(a5)

	movem.l (sp)+,d0-d3/a1
	rts

;---------- Affichage d'un BOB masqué dans une surface en RAWB ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de bobDrawBOBData)
;Sortie(s) :
;	(rien)
;Notice:
;	Le BOB est découpé dans la source à une abscisse multiple de 16, et sa
;	largeur doit être multiple de 16.
;
;	La source et la destination doivent avoir la même profondeur, et leurs
;	données être organisées en RAWB.
;
;	Attention ! Pas de WAIT_BLITTER à la fin.

_bobDrawBOB:
	movem.l d0-d2/a1,-(sp)

	WAIT_BLITTER

	;Calculer le décalage et optimiser le # de WORDs à copier (pas de colonne de WORD à droite si jamais le décalage est nul)

	moveq #2,d2
	move.w OFFSET_DRAWBOB_DX(a0),d0
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)
	move.w OFFSET_DRAWBOB_X(a0),d1
	and.w #$000F,d1
	beq _bobDrawBOBWORDAligned
	addi.w #16,d0
	move.w #$0000,BLTALWM(a5)
	moveq #0,d2
_bobDrawBOBWORDAligned:
	add.w OFFSET_DRAWBOB_MASKMODULO(a0),d2
	move.w d2,BLTBMOD(a5)
	ror.w #4,d1
	move.w d1,BLTCON1(a5)		;BSH3-0=décalage
	or.w #$0FF2,d1
	move.w d1,BLTCON0(a5)		;ASH3-0=décalage, USEA=1, USEB=1, USEC=1, USED=1, D=A+bC

	;Calculer les modulos

	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d1
	sub.w d0,d1
	asr.w #3,d1
	move.w d1,BLTAMOD(a5)
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1
	sub.w d0,d1
	asr.w #3,d1
	move.w d1,BLTCMOD(a5)
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1
	sub.w d0,d1
	lsr.w #3,d1
	move.w d1,BLTDMOD(a5)

	;Récupérer un pointeur sur le BOB à ses coordonnées de départ (son abscisse est multiple de 16)

	movea.l OFFSET_DRAWBOB_SRC(a0),a1
	moveq #0,d1
	move.w OFFSET_DRAWBOB_SRCX(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.l d1,a1
	move.w OFFSET_DRAWBOB_SRCY(a0),d1
	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d2
	lsr.w #3,d2
	mulu OFFSET_DRAWBOB_DEPTH(a0),d2
	mulu d2,d1
	add.l d1,a1
	move.l a1,BLTAPTH(a5)

	;Récupérer un pointeur sur l'emplacement du BOB à ses coordonnées d'arrivée

	movea.l OFFSET_DRAWBOB_DST(a0),a1
	moveq #0,d1
	move.w OFFSET_DRAWBOB_X(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.l d1,a1
	move.w OFFSET_DRAWBOB_Y(a0),d1
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d2
	lsr.w #3,d2
	mulu OFFSET_DRAWBOB_DEPTH(a0),d2
	mulu d2,d1
	add.l d1,a1
	move.l a1,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)

	;Récupérer un pointeur sur le masque

	move.l OFFSET_DRAWBOB_MASK(a0),BLTBPTH(a5)

	;Afficher le BOB

	move.w OFFSET_DRAWBOB_DY(a0),d1
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1
	lsl.w #6,d1
	lsr.w #4,d0
	or.w d1,d0
	move.w d0,BLTSIZE(a5)

	movem.l (sp)+,d0-d2/a1
	rts

bobDrawBOBData:
OFFSET_DRAWBOB_DEPTH=0
OFFSET_DRAWBOB_X=2
OFFSET_DRAWBOB_Y=4
OFFSET_DRAWBOB_DX=6				;Multiple de 16
OFFSET_DRAWBOB_DY=8
OFFSET_DRAWBOB_MASK=10	
OFFSET_DRAWBOB_MASKMODULO=14	;Permet de préciser un modulo négatif si toutes les lignes du masque sont identiques
OFFSET_DRAWBOB_SRC=16
OFFSET_DRAWBOB_SRCWIDTH=20
OFFSET_DRAWBOB_SRCX=22			;Multiple de 16
OFFSET_DRAWBOB_SRCY=24
OFFSET_DRAWBOB_DST=26
OFFSET_DRAWBOB_DSTWIDTH=30
DATASIZE_DRAWBOB=32
	BLK.B DATASIZE_DRAWBOB,0

;---------- Affichage d'un BOB non masqué dans une surface en RAWB ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de bobDrawBOBData)
;Sortie(s) :
;	(rien)
;Notice:
;	C'est une version optimisée de _bobDrawBOB, qui se contente de copier le BOB
;	par OR dans le décor présumé vide. La même structure de données est
;	utilisée, mais ce qui est relatif au masque est ignoré.
;
;	Attention ! Pas de WAIT_BLITTER à la fin.

_bobDrawBOBFast:
	movem.l d0-d2/a1,-(sp)

	WAIT_BLITTER

	;Calculer le décalage et optimiser le # de WORDs à copier (pas de colonne de WORD à droite si jamais le décalage est nul)

	move.w OFFSET_DRAWBOB_DX(a0),d0
	move.w #$FFFF,BLTAFWM(a5)
	move.w #$FFFF,BLTALWM(a5)
	move.w OFFSET_DRAWBOB_X(a0),d1
	and.w #$000F,d1
	beq _bobDrawBOBFastWORDAligned
	addi.w #16,d0
	move.w #$0000,BLTALWM(a5)
_bobDrawBOBFastWORDAligned:
	ror.w #4,d1
	or.w #$0BFA,d1
	move.w d1,BLTCON0(a5)		;ASH3-0=décalage, USEA=1, USEB=1, USEC=1, USED=1, D=A+C
	move.w #$0000,BLTCON1(a5)	;BSH3-0=0

	;Calculer les modulos

	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d1
	sub.w d0,d1
	asr.w #3,d1
	move.w d1,BLTAMOD(a5)
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1
	sub.w d0,d1
	asr.w #3,d1
	move.w d1,BLTCMOD(a5)
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d1
	sub.w d0,d1
	lsr.w #3,d1
	move.w d1,BLTDMOD(a5)

	;Récupérer un pointeur sur le BOB à ses coordonnées de départ (son abscisse est multiple de 16)

	movea.l OFFSET_DRAWBOB_SRC(a0),a1
	moveq #0,d1
	move.w OFFSET_DRAWBOB_SRCX(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.l d1,a1
	move.w OFFSET_DRAWBOB_SRCY(a0),d1
	move.w OFFSET_DRAWBOB_SRCWIDTH(a0),d2
	lsr.w #3,d2
	mulu OFFSET_DRAWBOB_DEPTH(a0),d2
	mulu d2,d1
	add.l d1,a1
	move.l a1,BLTAPTH(a5)

	;Récupérer un pointeur sur l'emplacement du BOB à ses coordonnées d'arrivée

	movea.l OFFSET_DRAWBOB_DST(a0),a1
	moveq #0,d1
	move.w OFFSET_DRAWBOB_X(a0),d1
	lsr.w #3,d1
	and.b #$FE,d1
	add.l d1,a1
	move.w OFFSET_DRAWBOB_Y(a0),d1
	move.w OFFSET_DRAWBOB_DSTWIDTH(a0),d2
	lsr.w #3,d2
	mulu OFFSET_DRAWBOB_DEPTH(a0),d2
	mulu d2,d1
	add.l d1,a1
	move.l a1,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)

	;Afficher le BOB

	move.w OFFSET_DRAWBOB_DY(a0),d1
	mulu OFFSET_DRAWBOB_DEPTH(a0),d1
	lsl.w #6,d1
	lsr.w #4,d0
	or.w d1,d0
	move.w d0,BLTSIZE(a5)

	movem.l (sp)+,d0-d2/a1
	rts