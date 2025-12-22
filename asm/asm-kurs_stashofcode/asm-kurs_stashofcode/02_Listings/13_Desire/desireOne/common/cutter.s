;A VOIR : Pour que plusieurs instances puissent fonctionner ensemble, il faudrait que chacune alloue cutState

;-------------------------------------------------------------------------------
; Dessin de square de 16x16 animés sur tout la surface d'un bitplane.
;
; Codé par Denis Duplan a.k.a. Yragael (stashofcode@gmail.com, stashofcode@gmail.com) en septembre 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

;Cette oeuvre est mise à disposition selon les termes de la Licence (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Attribution - Pas d’Utilisation Commerciale 4.0 International.

;L'effet se déroule en deux phases :
;
;1/ Afficher les carrés animés. Les carrés sont animés tous les OFFSET_CUTTERSETUP_SQUAREDELAY appels à _cutStep. L'animation proprement dite (changement d'image) d'un carré ne démarre que lorsque son retard au démarrage est réduit à 0. Elle comprend CUT_NBFRAMES images. Cette animation du carré ne doit pas s'arrêter tant que l'image n'est pas l'image finale (image 0) et qu'une durée de OFFSET_CUTTERSETUP_DURATION s'est écoulée depuis le démarrage de l'animation (noter que spécifier -1 fait répéter le cutter à l'infini, ce qui peut être utile quand ce n'est pas lui qui doit mener la danse). Bref, la durée totale de l'animation est difficile à calculer : elle dépend de OFFSET_CUTTERSETUP_SQUAREDELAY, de OFFSET_CUTTERSETUP_DURATION, du retard initial du carré, et de CUT_NBFRAMES, et pour finir OFFSET_CUTTERSETUP_FINALDELAY vient s'y ajouter. Pourquoi ne pas faire plus précis ? Car c'est impossible.
;
;En pseudo-code, sans respecter d'homologie de type dans les comparaisons, cela doit donner :
;
;	function _cutReset () {
;		for (i = 0; i != OFFSET_CUTTERSETUP_WALLDX * OFFSET_CUTTERSETUP_WALLDY; i ++)
;			OFFSET_CUTTER_WALL[i].OFFSET_CUTTERTILE_FRAME = CUT_FIRSTFRAME
;		OFFSET_CUTTER_DELAY = OFFSET_CUTTERSETUP_SQUAREDELAY
;		OFFSET_CUTTER_DURATION = OFFSET_CUTTERSETUP_DURATION
;	}
;
;	function _cutStep () {
;		if (!OFFSET_CUTTER_DELAY) {
;			OFFSET_CUTTER_DELAY = OFFSET_CUTTERSETUP_SQUAREDELAY
;			OFFSET_CUTTER_DURATION --;
;			nbTilesDone = 0;
;			for (i = 0; i != OFFSET_CUTTERSETUP_WALLDX * OFFSET_CUTTERSETUP_WALLDY; i ++) {
;				if (OFFSET_CUTTER_WALL[i].OFFSET_CUTTERTILE_DELAY)
;					OFFSET_CUTTER_WALL[i].OFFSET_CUTTERTILE_DELAY --;
;				else {
;					if (!OFFSET_CUTTER_WALL[i].OFFSET_CUTTERTILE_FRAME) {
;						if (OFFSET_CUTTER_DURATION <= 0)
;							nbTilesDone ++;
;						else
;							OFFSET_CUTTER_WALL[i].OFFSET_CUTTERTILE_FRAME = CUT_NBFRAMES-1;
;					}
;					else
;						OFFSET_CUTTER_WALL[i].OFFSET_CUTTERTILE_FRAME --;
;				}
;			}
;			if (nbTilesDone == OFFSET_CUTTERSETUP_WALLDX * OFFSET_CUTTERSETUP_WALLDY)
;				// Basculer sur la phase d'attente
;		}
;		else
;			OFFSET_CUTTER_DELAY --;
;	}
;
;2/ Attendre ne faisant rien durant OFFSET_CUTTERSETUP_FINALDELAY appels à _cutStep.

;********** Cutter **********
	
CUT_NBFRAMES=14
CUT_FIRSTFRAME=7
CUT_SIDE=16
CUT_PHASE_ANIMATION=0
CUT_PHASE_WAIT=1
CUT_PHASE_DONE=2

;---------- Initialisation ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de cutSetupData)
;Sortie(s) :
;	(rien)

_cutSetup:
	movem.l d0-d7/a0-a6,-(sp)

	;Sauvegarder la structure d'initialisation

	lea cutState,a1
	move.w #DATASIZE_CUTTERSETUP-1,d0
_cutSetupCopySetup:
	move.b (a0)+,(a1)+
	dbf d0,_cutSetupCopySetup

	;########## Compléter l'initialisation ##########

	;Dimensions du mur

	lea cutState,a0
	move.w OFFSET_CUTTERSETUP_BITPLANEWIDTH(a0),d0
	lsr.w #4,d0			;Pour éviter DIVU #CUT_SIDE,D0
	move.w d0,OFFSET_CUTTER_WALLDX(a0)
	move.w OFFSET_CUTTERSETUP_BITPLANEHEIGHT(a0),d1
	lsr.w #4,d1			;Pour éviter DIVU #CUT_SIDE,D1
	move.w d1,OFFSET_CUTTER_WALLDY(a0)

	;Allouer un espace en mémoire quelconque pour le mur

	mulu d1,d0
	mulu #DATASIZE_CUTTERTILE,d0
	move.l #$10000,d1
	movea.l $4,a6
	jsr -198(a6)
	lea cutState,a0
	move.l d0,OFFSET_CUTTER_WALL(a0)

	movea.l OFFSET_CUTTERSETUP_PATTERN(a0),a0
	bsr _cutReset

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Réinitialisation ----------

;Entrée(s) :
;	A0 = Adresse du nouveau pattern
;Sortie(s) :
;	(rien)

_cutReset:
	movem.l d0-d2/a0-a2,-(sp)

	;Mémoriser le nouveau pattern de mur

	lea cutState,a1
	move.l a0,OFFSET_CUTTERSETUP_PATTERN(a1)
	move.l a1,a0			;Par convention dans les routines, A0 pointe toujours sur l'état

	;Construire le mur

	move.w OFFSET_CUTTER_WALLDX(a0),d0
	mulu OFFSET_CUTTER_WALLDY(a0),d0
	move.l OFFSET_CUTTERSETUP_PATTERN(a0),a1
	move.l OFFSET_CUTTER_WALL(a0),a2
_cutResetCopyPattern:
	move.b (a1)+,OFFSET_CUTTERTILE_DELAY(a2)
	move.b #0,OFFSET_CUTTERTILE_RESERVED(a2)
	move.w #CUT_FIRSTFRAME*CUT_SIDE*(CUT_SIDE>>3),OFFSET_CUTTERTILE_FRAME(a2)
	lea DATASIZE_CUTTERTILE(a2),a2
	subq.w #1,d0
	bne _cutResetCopyPattern

	;Initialiser la phase

	move.w #CUT_PHASE_ANIMATION,OFFSET_CUTTER_PHASE(a0)
	move.b OFFSET_CUTTERSETUP_SQUAREDELAY(a0),OFFSET_CUTTER_DELAY(a0)
	move.w OFFSET_CUTTERSETUP_DURATION(a0),OFFSET_CUTTER_DURATION(a0)

	movem.l (sp)+,d0-d2/a0-a2
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = 1 si le délai final a expiré, sinon 0

_cutStep:
	movem.l d1-d3/a0-a4,-(sp)
	lea cutState,a0

	;########## Phase d'animation du mur (début) ##########

	cmpi.b #CUT_PHASE_ANIMATION,OFFSET_CUTTER_PHASE(a0)
	bne _cutStepPhaseNotANIMATION

	;Décrémenter le délai

	subi.b #1,OFFSET_CUTTER_DELAY(a0)
	bne _cutStepDelayNotExpired
	move.b OFFSET_CUTTERSETUP_SQUAREDELAY(a0),OFFSET_CUTTER_DELAY(a0)

	;Dessiner les carrés (pas d'optimisation : tous les carrés sont dessinés même si leur animation est terminée)

	;Détail des calculs retrouver certaines valeurs, par exemple en RAWB où le modulo vaut (DISPLAY_DEPTH-1)*(DISPLAY_DX>>3)
	;
	;DISPLAY_DEPTH*(DISPLAY_DX>>3)-(CUT_SIDE>>3) = (DISPLAY_DX>>3)-(CUT_SIDE>>3)+modulo
	;
	;(DISPLAY_DEPTH*CUT_SIDE-1)*(DISPLAY_DX>>3) = CUT_SIDE*modulo+(CUT_SIDE-1)*(DISPLAY_DX>>3)

	move.w #0,BLTCMOD(a5)
	move.w OFFSET_CUTTERSETUP_BITPLANEWIDTH(a0),d0
	lsr.w #3,d0
	move.w d0,d1
	subq.w #CUT_SIDE>>3,d1
	add.w OFFSET_CUTTERSETUP_BITPLANEMODULO(a0),d1	;Par exemple, en RAWB : D0 = DISPLAY_DEPTH*(DISPLAY_DX>>3)-(CUT_SIDE>>3)
	move.w d1,BLTDMOD(a5)
	mulu #CUT_SIDE-1,d0
	move.w OFFSET_CUTTERSETUP_BITPLANEMODULO(a0),d1
	mulu #CUT_SIDE,d1
	add.w d1,d0										;Par exemple (RAWB) : D0 = (DISPLAY_DEPTH*CUT_SIDE-1)*(DISPLAY_DX>>3)
	move.w #$03AA,BLTCON0(a5)	;USEA=0, USEB=0, USEC=1, USED=1, D=C
	move.w #$0000,BLTCON1(a5)
	movea.l OFFSET_CUTTERSETUP_BITPLANE(a0),a1
	movea.l OFFSET_CUTTER_WALL(a0),a2
	lea cutSquaresStart,a3
	move.w OFFSET_CUTTER_WALLDY(a0),d1
_cutStepDrawRows:
	move.w OFFSET_CUTTER_WALLDX(a0),d2
_cutStepDrawColumns:
	move.w OFFSET_CUTTERTILE_FRAME(a2),d3
	lea DATASIZE_CUTTERTILE(a2),a2
	lea (a3,d3.w),a4
	WAIT_BLITTER
	move.l a4,BLTCPTH(a5)
	move.l a1,BLTDPTH(a5)
	move.w #(CUT_SIDE<<6)!(CUT_SIDE>>4),BLTSIZE(a5)
	lea CUT_SIDE>>3(a1),a1
	subq.w #1,d2
	bne _cutStepDrawColumns
	lea (a1,d0.w),a1
	subq.w #1,d1
	bne _cutStepDrawRows
	WAIT_BLITTER

	;Animer les carrés
	
	subi.w #1,OFFSET_CUTTER_DURATION(a0)

	move.w OFFSET_CUTTER_WALLDX(a0),d0
	mulu OFFSET_CUTTER_WALLDY(a0),d0
	move.w d0,d1
	movea.l OFFSET_CUTTER_WALL(a0),a1
_cutStepAnimationLoop:
	tst.b OFFSET_CUTTERTILE_DELAY(a1)
	beq _cutStepAnimationDelayExpired
	subi.b #1,OFFSET_CUTTERTILE_DELAY(a1)
	bra _cutStepAnimationDone
_cutStepAnimationDelayExpired:
	tst.w OFFSET_CUTTERTILE_FRAME(a1)
	bne _cutStepAnimate
	tst.w OFFSET_CUTTER_DURATION(a0)
	bgt _cutStepAnimationDurationNotExpired
	subq.w #1,d1
	bra _cutStepAnimationDone
_cutStepAnimationDurationNotExpired:
	move.w #(CUT_NBFRAMES-1)*CUT_SIDE*(CUT_SIDE>>3),OFFSET_CUTTERTILE_FRAME(a1)
	bra _cutStepAnimationDone
_cutStepAnimate:
	subi.w #CUT_SIDE*(CUT_SIDE>>3),OFFSET_CUTTERTILE_FRAME(a1)
_cutStepAnimationDone:
	lea DATASIZE_CUTTERTILE(a1),a1
	subq.w #1,d0
	bne _cutStepAnimationLoop

	;Changer de phase

	tst.w d1
	bne _cutStepPhaseANIMATIONNotDone
	move.b OFFSET_CUTTERSETUP_FINALDELAY(a0),OFFSET_CUTTER_DELAY(a0)
	move.b #CUT_PHASE_WAIT,OFFSET_CUTTER_PHASE(a0)
_cutStepPhaseANIMATIONNotDone:

	;Finaliser la phase

_cutStepDelayNotExpired:
	moveq #0,d0
	bra _cutStepPhaseCompleted

	;########## Phase d'animation du mur (fin) ##########

	;########## Phase d'attente finale (début) ##########

_cutStepPhaseNotANIMATION:
	cmpi.b #CUT_PHASE_WAIT,OFFSET_CUTTER_PHASE(a0)
	bne _cutStepPhaseNotWAIT

	;Décrémenter le délai

	subi.b #1,OFFSET_CUTTER_DELAY(a0)
	bne _cutStepWaitDelayNotExpired

	;Changer de phase

	move.b #CUT_PHASE_DONE,OFFSET_CUTTER_PHASE(a0)

	;Finaliser la phase

	moveq #1,d0
	bra _cutStepPhaseCompleted
_cutStepWaitDelayNotExpired:
	moveq #0,d0
	bra _cutStepPhaseCompleted

	;########## Phase d'attente finale (fin) ##########

_cutStepPhaseNotWAIT:

_cutStepPhaseCompleted:
	movem.l (sp)+,d1-d3/a0-a4
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_cutEnd:
	movem.l d0-d7/a0-a6,-(sp)

	lea cutState,a0
	movea.l OFFSET_CUTTER_WALL(a0),a1
	move.w OFFSET_CUTTER_WALLDX(a0),d0
	mulu OFFSET_CUTTER_WALLDY(a0),d0
	mulu #DATASIZE_CUTTERTILE,d0
	movea.l $4,a6
	jsr -210(a6)

	movem.l (sp)+,d0-d7/a0-a6
	rts

;---------- Données ----------

	SECTION cutterData,DATA

cutSetupData:
OFFSET_CUTTERSETUP_BITPLANE=0
OFFSET_CUTTERSETUP_BITPLANEWIDTH=4
OFFSET_CUTTERSETUP_BITPLANEHEIGHT=6
OFFSET_CUTTERSETUP_BITPLANEMODULO=8
OFFSET_CUTTERSETUP_PATTERN=10
OFFSET_CUTTERSETUP_SQUAREDELAY=14
OFFSET_CUTTERSETUP_FINALDELAY=15
OFFSET_CUTTERSETUP_DURATION=16
DATASIZE_CUTTERSETUP=18
	BLK.B DATASIZE_CUTTERSETUP,0
cutState:
OFFSET_CUTTER_CUTTERSETUP=0
OFFSET_CUTTER_WALLDX=DATASIZE_CUTTERSETUP
OFFSET_CUTTER_WALLDY=DATASIZE_CUTTERSETUP+2
OFFSET_CUTTER_WALL=DATASIZE_CUTTERSETUP+4
OFFSET_CUTTER_PHASE=DATASIZE_CUTTERSETUP+8
OFFSET_CUTTER_DELAY=DATASIZE_CUTTERSETUP+9
OFFSET_CUTTER_DURATION=DATASIZE_CUTTERSETUP+10
DATASIZE_CUTTER=DATASIZE_CUTTERSETUP+12
	BLK.B DATASIZE_CUTTER,0

OFFSET_CUTTERTILE_DELAY=0
OFFSET_CUTTERTILE_RESERVED=1
OFFSET_CUTTERTILE_FRAME=2
DATASIZE_CUTTERTILE=1+1+2

cutPatternsStart:	;Généré avec un outil (feuille "patterns" dans cutter.xlsx)
					;Diamond
					DC.B 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7,7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7,6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6,5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5,4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4,3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3,2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2,1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1,0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0
					;Spiral
					DC.B 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 0, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 6, 1, 5, 6, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 7, 2, 4, 5, 8, 3, 4, 5, 6, 7, 8, 9, 0, 1, 2, 3, 4, 5, 4, 5, 8, 3, 3, 4, 7, 2, 9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 6, 5, 6, 9, 4, 2, 3, 6, 1, 8, 7, 8, 9, 0, 1, 2, 3, 4, 5, 0, 7, 6, 7, 0, 5, 1, 2, 5, 0, 7, 6, 7, 8, 9, 0, 1, 2, 3, 6, 1, 8, 7, 8, 1, 6,0, 1, 4, 9, 6, 5, 6, 9, 8, 7, 6, 5, 4, 7, 2, 9, 8, 9, 2, 7,9, 0, 3, 8, 5, 4, 5, 4, 3, 2, 1, 0, 9, 8, 3, 0, 9, 0, 3, 8,8, 9, 2, 7, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 1, 0, 1, 4, 9,7, 8, 1, 6, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 5, 0,6, 7, 0, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 3, 6, 1,5, 6, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 7, 2,4, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 8, 3,3, 2, 1, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 9, 8, 7, 6, 5, 4
cutPatternsEnd:

	SECTION cutterData_c,DATA_C

cutSquaresStart:	;Généré avec un outil (squares.html), puis adapté
					;Ne pas oublier d'ajuster CUT_NBFRAMES
					DC.W $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF, $FFFF
					DC.W $0000, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $0000
					DC.W $0000, $0000, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $0000, $0000
					DC.W $0000, $0000, $0000, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0000, $07E0, $07E0, $07E0, $07E0, $07E0, $07E0, $0000, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0000, $0000, $03C0, $03C0, $03C0, $03C0, $0000, $0000, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0180, $0180, $0000, $0000, $0000, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0000, $0000, $03C0, $03C0, $03C0, $03C0, $0000, $0000, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0000, $07E0, $07E0, $07E0, $07E0, $07E0, $07E0, $0000, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $0000, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0FF0, $0000, $0000, $0000, $0000
					DC.W $0000, $0000, $0000, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $1FF8, $0000, $0000, $0000
					DC.W $0000, $0000, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $3FFC, $0000, $0000
					DC.W $0000, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $7FFE, $0000
cutSquaresEnd:
