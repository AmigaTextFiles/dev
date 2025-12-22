;A FAIRE : A revoir. Le bon algorithme est dans R:\Documents\Projets\interpolation\interpolator.html et il est implémenté dans fade.s. Pas sûr que ce soit le bon ici. En particulier je note que l'accumulateur n'est pas initialisé à MIN (DX,DY) >> 1

;-------------------------------------------------------------------------------
;                            Interpolateur linéaire
;
; Codé par Yragael / Denis Duplan (stashofcode@gmail.com) en mai 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

;Ce(tte) oeuvre est mise à disposition selon les termes de la Licence (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Attribution - Pas d’Utilisation Commerciale 4.0 International.

;---------- Interpolateur linéaire ----------

;Entrée(s) :
;	D0 = Valeur initiale
;	D1 = Valeur finale (éventuellement identique à la valeur initiale)
;	D2 = Nombre d'étapes (au minimum il y a deux étapes V = Vi et V = Vf, donc au minimum D2 = 1)
;	D3 = Accumulateur (-1 pour initialiser)
;	D4 = Valeur à l'étape courante
;Sortie(s) :
;	D3 = Nouvelle valeur de l'accumulateur
;	D4 = Valeur à l'étape suivante
;Utilisation des registres :
;	*D0 *D1 *D2 *D3 *D4 *D5 *D6 =D7 =A0 =A1 =A2 =A3 =A4 =A5 =A6
;Notice :
;	Usage de l'interpolateur :
;
;		move.w #VALUE_START,d0
;		move.w #VALUE_END,d1
;		move.w #NB_STEPS-1,d2	;Au minimum NB_STEPS = 2  : V = Vi et V = Vf, même si Vi == Vf
;		moveq #-1,d3
;		move.w d0,d4
;
;		Puis version DBF (l'objectif et de ne pas faire de boucle inutile) :
;
;		move.w #NB_STEPS-2,d5
;		or.w d4,d4				;Utilisation de D4 (exemple)
;	_interpolation:
;		jsr _interpolate
;		or.w d4,d4				;Utilisation de D4 (exemple)
;		dbf d5,_interpolation
;
;		Ou version BNE (même objectif) :
;
;		move.w #NB_STEPS,d5
;	_interpolation:
;		or.w d4,d4				;Utilisation de D4 (exemple)
;		subq.w #1,d5
;		beq _interpolateEnd
;		jsr _interpolate
;		bra _interpolation
;	_interpolateEnd:
;
;	Il n'est pas gênant d'appeler trop de fois l'interpolateur, car il ne fait rien si Vf == Vi par sécurité.

_interpolate:
	cmp.w d1,d4
	bne _interpolateNotDone
	rts
_interpolateNotDone:
	movem.l d2/d5/d6,-(sp)

	move.w d1,d5
	sub.w d0,d5
	bgt _interpolateDVPositive
	neg.w d5
	moveq #-1,d6
	bra _interpolateDVNegative
_interpolateDVPositive:
	moveq #1,d6
_interpolateDVNegative:
	addq.w #1,d5		;D5 = |valeur finale - valeur initiale| + 1
	cmp.w d5,d2
	bge _interpolateNbStepsGreater

	;(|valeur finale - valeur initiale| + 1) > # étapes
	
	;Dans ce cas, il s'agit de tracer une droite dans un repère en pixels dont l'axe des abscisses est celui des étapes dont le nombre est réduit de 1, et l'axe des ordonnées est celui des valeurs. L'accumulateur est toujours en avance d'un pixel sur la droite pour quitter la routine quand on sait que le prochaine pixel change d'abscisse. On est ainsi certain de quiter la routine en butée du segment de pixels de même abscisse.

	subq.w #1,d2
	tst.w d3
	bge _interpolateAccumulatorAlreadyInitialized0
	clr.w d3				;NB : Pourquoi pas # étapes >> 1 pour équilibrer ?
	move.w d0,d4
	sub.w d6,d4
_interpolateAccumulatorAlreadyInitialized0:
	add.w d6,d4
	add.w d2,d3
	cmp.w d5,d3
	blt _interpolateAccumulatorNoOverflow0
	sub.w d5,d3
	movem.l (sp)+,d2/d5/d6
	rts
_interpolateAccumulatorNoOverflow0:
	bra _interpolateAccumulatorAlreadyInitialized0

	;(|valeur finale - valeur initiale| + 1) <= # étapes

	;Dans ce cas, il s'agit de tracer une droite dans un repère en pixels dont l'axe des abscisses est celui des valeurs, et l'axe des ordonnées est celui des étapes. Les choses sont plus simples, car il n'est pas nécessaire d'attendre d'être en butée pour quitter la routine.
	
_interpolateNbStepsGreater:
	tst.w d3
	bge _interpolateAccumulatorAlreadyInitialized1
	clr.w d3				;NB : Pourquoi pas (|valeur finale - valeur initiale| + 1) >> 1 pour équilibrer ?
	move.w d0,d4
_interpolateAccumulatorAlreadyInitialized1:
	add.w d5,d3
	cmp.w d2,d3
	blt _interpolateNoAccumulatorOverflow1
	sub.w d2,d3
	add.w d6,d4
_interpolateNoAccumulatorOverflow1:
	movem.l (sp)+,d2/d5/d6
	rts
