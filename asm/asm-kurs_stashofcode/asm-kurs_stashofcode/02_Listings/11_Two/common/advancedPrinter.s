;*A FAIRE* : _prtStep devrait retourner une combinaison de bits pour signaler (1) la fin d'une ligne (2) la fin d'une page (3) la fin du texte
;A FAIRE : Quelques idées pour de nouveaux effets :
;- Stacker : faire tomber les lignes du caractère une par une dans sa case
;- Rotator : faire tourner le caractère de 90° en 90° dans sa case
;A FAIRE : Assembler n'est pas très intéressant, car les caractères sont trop petits pour qu'on réalise la subtilité de leur déplacement... Mieux vaut faire une animation telle qu'une croix dont les branches se réduisent, c'est moins coûteux en CPU. Peut-être en 16x16 l'effet passe-t-il mieux...
;A FAIRE : Tester une version 16x16 :)
;A VOIR : Pour que plusieurs instances puissent fonctionner ensemble, il faudrait que chacune alloue prtState. De même pour les routines, qui devraient allouer les BLK.B sur lequels elles s'appuient

;-------------------------------------------------------------------------------
; Affichage de pages de texte avec animation des caractères.
;
; Codé par Yragael / Denis Duplan (stashofcode@gmail.com) en août 2018.
;
; Code & documentation on www.stashofcode.com (EN) and www.stashofcode.fr (FR)
;-------------------------------------------------------------------------------

;Ce(tte) oeuvre est mise à disposition selon les termes de la Licence (http://creativecommons.org/licenses/by-nc/4.0/) Creative Commons Attribution - Pas d’Utilisation Commerciale 4.0 International.

;Pour éviter d'assembler des routines inutiles, définir dans le programme utilisateur la constante PRT_PRINTER correspondant à l'afficheur de caractères à utiliser :
;
;0 : Basic
;1 : Roller
;2 : Raiser
;3 : Animator
;4 : Shifter
;5 : Interwiner
;6 : Assembler
;
;Exception faite du premier, chaque afficheur utilise une constante PRT_*_SPEED pour définir la vitesse de l'animation du caractère.

;********** Printer **********

;Pour des explications sur l'algorithme, se reporter à advancedPrinter.html qui a permis de le mettre au point.

PRT_CHAR_SPACE=$20
PRT_CHAR_ENDOFLINE=$00
PRT_CHAR_ENDOFPAGE=$FF

;---------- Initialisation ----------

;Entrée(s) :
;	A0 = Adresse de la structure d'initialisation (sur le modèle de prtSetupData)
;Sortie(s) :
;	(rien)

_prtSetup:
	movem.l d0/a0-a1,-(sp)

	;Sauvegarder la structure d'initialisation

	lea prtState,a1
	move.w #DATASIZE_PRINTERSETUP-1,d0
_prtSetupCopySetup:
	move.b (a0)+,(a1)+
	dbf d0,_prtSetupCopySetup

	;Compléter l'initialisation

	lea prtState,a0
	move.w #-1,OFFSET_PRINTER_PAGEDELAY(a0)
	move.b #0,OFFSET_PRINTER_CHARDELAY(a0)
	move.l OFFSET_PRINTERSETUP_TEXT(a0),OFFSET_PRINTER_CHAR(a0)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a0),OFFSET_PRINTER_BITPLANELINE(a0)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a0),OFFSET_PRINTER_BITPLANECHAR(a0)

	;Initialiser l'afficheur de caractères

	bsr _prtRoutineSetup

	movem.l (sp)+,d0/a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = 1 si le dernier caractère vient d'être affiché, sinon 0
;Notice :
;	Le mode d'adressage est relatif et non absolu, car pour rappel des temps de calcul :
;
;	move.w test,d0			;A500: 5000 itérations -> 288 lignes
;	move.w (a0),d0			;A500: 5000 itérations -> 200 lignes
;	move.w 2(a0),d0			;A500: 5000 itérations -> 244 lignes (quel que soit l'offset)
;	move.w (a0,d0.w),d0		;A500: 5000 itérations -> 266 lignes (quel que soit Dn)
;	move.w 2(a0,d0.w),d0	;A500: 5000 itérations -> 266 lignes (quels que soient l'offset et Dn)
;
;	Quand bien même il ne s'agit que d'effectuer quelques opérations par itérations ici...

_prtStep:
	movem.l d1/a0-a1,-(sp)

	lea prtState,a1

	;Décompter le délai entre deux pages

	tst.w OFFSET_PRINTER_PAGEDELAY(a1)
	ble _prtReadChar
	tst.w OFFSET_PRINTER_NBCHARSTOPRINT(a1)
	bne _prtReadChar
	subi.w #1,OFFSET_PRINTER_PAGEDELAY(a1)
	bne _prtDone
	move.w #-1,OFFSET_PRINTER_PAGEDELAY(a1)
	WAIT_BLITTER
	move.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	;USED=1
	move.w #$0000,BLTCON1(a5)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a1),BLTDPTH(a5)
	move.w OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a1),d0
	lsl.w #6,d0
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d1
	lsr.w #1,d1
	or.w d1,d0
	move.w d0,BLTSIZE(a5)
	bsr _prtRoutineNewPage
	WAIT_BLITTER

	;Traiter le caractère suivant

_prtReadChar:
	tst.w OFFSET_PRINTER_PAGEDELAY(a1)
	bge _prtAnimateChars
	tst.b OFFSET_PRINTER_CHARDELAY(a1)
	beq _prtReadChars
	subi.b #1,OFFSET_PRINTER_CHARDELAY(a1)
	bra _prtAnimateChars

_prtReadChars:
	movea.l OFFSET_PRINTER_CHAR(a1),a0
_prtReadCharsLoop:
	move.b (a0)+,d0
	move.l a0,OFFSET_PRINTER_CHAR(a1)

	cmpi.b #PRT_CHAR_ENDOFLINE,d0
	bne _prtCharNotEOL

	moveq #0,d1
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d1
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d1
	lsl.w #3,d1
	add.l d1,OFFSET_PRINTER_BITPLANELINE(a1)
	move.l OFFSET_PRINTER_BITPLANELINE(a1),OFFSET_PRINTER_BITPLANECHAR(a1)
	bra _prtReadCharsLoop
_prtCharNotEOL:

	cmpi.b #PRT_CHAR_SPACE,d0
	bne _prtCharNotSPACE
	addi.l #1,OFFSET_PRINTER_BITPLANECHAR(a1)
	bra _prtReadCharsLoop
_prtCharNotSPACE:

	cmpi.b #PRT_CHAR_ENDOFPAGE,d0
	bne _prtCharNotEOP
	move.l OFFSET_PRINTERSETUP_BITPLANE(a1),OFFSET_PRINTER_BITPLANELINE(a1)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a1),OFFSET_PRINTER_BITPLANECHAR(a1)
	cmpi.b #PRT_CHAR_ENDOFPAGE,(a0)
	bne _prtCharAfterEOPNotEOP
	move.l OFFSET_PRINTERSETUP_TEXT(a1),OFFSET_PRINTER_CHAR(a1)
_prtCharAfterEOPNotEOP:
	move.w OFFSET_PRINTERSETUP_PAGEDELAY(a1),OFFSET_PRINTER_PAGEDELAY(a1)
	beq _prtNoPageDelay
	tst.w OFFSET_PRINTER_NBCHARSTOPRINT(a1)
	beq _prtAnimateChars
	addi.w #1,OFFSET_PRINTERSETUP_PAGEDELAY(a1)
	bra _prtAnimateChars
_prtNoPageDelay:
	tst.w OFFSET_PRINTER_NBCHARSTOPRINT(a1)
	bne _prtNoCharsToPrint
	WAIT_BLITTER
	move.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),BLTDMOD(a5)
	move.w #$0100,BLTCON0(a5)	;USED=1
	move.w #$0000,BLTCON1(a5)
	move.l OFFSET_PRINTERSETUP_BITPLANE(a1),BLTDPTH(a5)
	move.w OFFSET_PRINTERSETUP_BITPLANEHEIGHT(a1),d0
	lsl.w #6,d0
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d1
	lsr.w #1,d1
	or.w d1,d0
	move.w d0,BLTSIZE(a5)
	WAIT_BLITTER
	bsr _prtRoutineNewPage
	move.w #-1,OFFSET_PRINTER_PAGEDELAY(a1)
	bra _prtReadChars
_prtNoCharsToPrint:
	move.w #1,OFFSET_PRINTER_PAGEDELAY(a1)
	bra _prtAnimateChars
_prtCharNotEOP:

	;Ajouter le caractère à la liste des caractères à afficher et animer

	cmpi.b #PRT_CHAR_ENDOFPAGE,(a0)
	beq _prtCharAfterCharNotEOP
	move.b OFFSET_PRINTERSETUP_CHARDELAY(a1),OFFSET_PRINTER_CHARDELAY(a1)
_prtCharAfterCharNotEOP:
	movea.l OFFSET_PRINTER_BITPLANECHAR(a1),a0
	bsr _prtRoutineNewChar
	addi.l #1,OFFSET_PRINTER_BITPLANECHAR(a1)
	move.w #-1,OFFSET_PRINTER_PAGEDELAY(a1)

	;Animer les caractères

_prtAnimateChars:
	bsr _prtRoutineUpdate
	move.w d0,OFFSET_PRINTER_NBCHARSTOPRINT(a1)
;il faut renvoyer un résultat dans D0

_prtDone:
	movem.l (sp)+,d1/a0-a1
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtEnd:
;	lea prtState,a0
;	movea.l OFFSET_PRINTERSETUP_ROUTINEEND(a0),a0
;	jsr (a0)
;Optimisation
	bsr _prtRoutineEnd
	rts

;---------- Données ----------

prtSetupData:
OFFSET_PRINTERSETUP_BITPLANE=0
OFFSET_PRINTERSETUP_BITPLANEWIDTH=4
OFFSET_PRINTERSETUP_BITPLANEMODULO=6
OFFSET_PRINTERSETUP_BITPLANEHEIGHT=8
OFFSET_PRINTERSETUP_CHARDELAY=10
OFFSET_PRINTERSETUP_PADDING=11
OFFSET_PRINTERSETUP_PAGEDELAY=12
OFFSET_PRINTERSETUP_FONT=14
OFFSET_PRINTERSETUP_TEXT=18
DATASIZE_PRINTERSETUP=22
	BLK.B DATASIZE_PRINTERSETUP,0
prtState:
OFFSET_PRINTER_PRINTERSETUP=0
OFFSET_PRINTER_CHAR=DATASIZE_PRINTERSETUP
OFFSET_PRINTER_BITPLANELINE=DATASIZE_PRINTERSETUP+4
OFFSET_PRINTER_BITPLANECHAR=DATASIZE_PRINTERSETUP+8
OFFSET_PRINTER_CHARDELAY=DATASIZE_PRINTERSETUP+12
OFFSET_PRINTER_PADDING=DATASIZE_PRINTERSETUP+13
OFFSET_PRINTER_PAGEDELAY=DATASIZE_PRINTERSETUP+14
OFFSET_PRINTER_NBCHARSTOPRINT=DATASIZE_PRINTERSETUP+16
DATASIZE_PRINTER=DATASIZE_PRINTERSETUP+18
	BLK.B DATASIZE_PRINTER,0

;********** Afficheur de base **********

;L'afficheur de base se contente d'afficher immédiatement un caractère.

	IFNE PRT_PRINTER=0

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineSetup:
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

_prtRoutineNewChar:

	;Stocker l'état du caractère

	move.b d0,prtRoutineChar
	move.l a0,prtRoutineBitplane

	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

_prtRoutineNewPage:
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés

_prtRoutineUpdate:
	movem.l a0-a1,-(sp)

	;Afficher le caractère courant
	
	moveq #0,d0
	move.b prtRoutineChar,d0
	subi.b #$20,d0
	lsl.w #3,d0
	lea prtState,a0
	movea.l OFFSET_PRINTERSETUP_FONT(a0),a1
	lea (a1,d0.w),a1
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a0),d0
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a0),d0
	movea.l prtRoutineBitplane,a0
	REPT 8
	move.b (a1)+,(a0)
	lea (a0,d0.w),a0
	ENDR

	moveq #0,d0

	movem.l (sp)+,a0-a1
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineEnd:
	rts

prtRoutineChar:		DC.B 0
					EVEN
prtRoutineBitplane:	DC.L 0	

	ENDC

;********** Roller **********

;Le roller consiste simplement à décaler chaque caractère d'un caractère sur droite en cyclant dans le jeu des caractères, jusqu'à atteindre le caractère final. Au départ, le caractère doit donc être décalé par rapport au caractère final.

;Pour chaque caractère, la structure de données est indique le caractère courant, le caractère final, si le caractère final a été atteint (drapeau), l'adresse à laquelle le caractère doit être affiché. Le drapeau est requis, car un caractère est toujours animé lors d'un appel à prtRoutineUpdate et affiché dans son nouvel état lors de l'appel suivant à prtRoutineUpdate.

	IFNE PRT_PRINTER=1

PRT_ROLLER_MAXNBCHARS=(DISPLAY_DY>>3)*(DISPLAY_DX>>3)	;Devrait suffire pour tous les cas : couvre tout un écran basse résolution
PRT_ROLLER_SHIFT=95>>1									;Doit être compris entre 0 et 94 car toute police 8x8 contient 95 caractères (c'est le jeu de 95 caractères ASCII imprimable : de $20 à $7E, $7F étant réservé pour un 96ème caractère, le caractère DEL qui n'est pas imprimable)
PRT_ROLLER_SPEED=0										;Nombre de frames entre deux étapes >= 0

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

prtRoutineSetup:
	movem.l a0-a1,-(sp)

	lea prtRollerData,a0
	move.w #0,OFFSET_ROLLERHEADER_NBCHARS(a0)
	lea DATASIZE_ROLLERHEADER(a0),a1
	move.l a1,OFFSET_ROLLERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

prtRoutineNewChar:
	movem.l d0/a0-a2,-(sp)

	;Récupérer le pointeur de caractères

	lea prtRollerData,a1
	movea.l OFFSET_ROLLERHEADER_POINTER(a1),a2

	;Stocker l'état du caractère. Décaler le caractère de PRT_ROLLER_SHIFT caractères vers la droite (en rebouclant à partir de $20 si nécessaire). Le code d'un caractère est compris en $20 (32) et $7E (32 + 95 - 1 = 126). C'est donc un octet positif qui, suite à l'addition de PRT_ROLLER_SHIFT (compris entre 0 et 94) peut atteindre $7F dans les positifs et au-delà basculer dans les négatifs, ce qui rend compliqué la détection du seuil auquel il faut faire reboucler sur $20. C'est pourquoi on gère tout cela sur un WORD.

	move.b d0,OFFSET_ROLLERCHAR_CHAREND(a2)
	and.w #$00FF,d0
	addi.w #PRT_ROLLER_SHIFT,d0
	cmpi.w #$20+95,d0
	blt _rolletNewCharShifted
	subi.w #95,d0
_rolletNewCharShifted:
	move.b d0,OFFSET_ROLLERCHAR_CHARNOW(a2)
	move.b #PRT_ROLLER_SPEED,OFFSET_ROLLERCHAR_SPEED(a2)
	move.b #0,OFFSET_ROLLERCHAR_FLAGS(a2)
	move.l a0,OFFSET_ROLLERCHAR_BITPLANE(a2)

	;Incrémenter le compteur et le pointeur de caractères
	
	lea DATASIZE_ROLLERCHAR(a2),a2
	move.l a2,OFFSET_ROLLERHEADER_POINTER(a1)
	addi.w #1,OFFSET_ROLLERHEADER_NBCHARS(a1)

	movem.l (sp)+,d0/a0-a2
	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

prtRoutineNewPage:
	movem.l a0-a1,-(sp)

	lea prtRollerData,a0
	move.w #0,OFFSET_ROLLERHEADER_NBCHARS(a0)
	lea DATASIZE_ROLLERHEADER(a0),a1
	move.l a1,OFFSET_ROLLERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés
;Notice :
;	Plutôt que de tester l'état de chaque caractère, sachant qu'ils sont affichés dans l'ordre et qu'ils doivent tous subir un PRT_ROLLER_SHIFT transformations, on pourrait maintenir un pointeur sur le premier caractère encore en transformation, tous les caractéres sauivants étant donc nécéssairement eux-aussi en transformation. Bon... les caractères ne sont pas si nombreux que cela pour qu'on se fatigue à cela, d'autant plus que cela imposerait donc que l'ordre des caractères recoupe celui de leurs transformations - c'est vrai dans le cas présent, mais ça pourrait ne pas l'être dans un autre.

prtRoutineUpdate:
	movem.l d1-d4/a0-a3,-(sp)

	moveq #0,d0

	lea prtRollerData,a0
	move.w OFFSET_ROLLERHEADER_NBCHARS(a0),d1
	beq prtRoutineUpdateDone

	lea DATASIZE_ROLLERHEADER(a0),a0
	lea prtState,a1
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d2
	movea.l OFFSET_PRINTERSETUP_FONT(a1),a1
prtRoutineUpdateChars:

	;Ne rien faire si l'animation du caractère est terminée

	tst.b OFFSET_ROLLERCHAR_FLAGS(a0)
	bne prtRoutineNextChar

	;Comptabiliser le caractère comme restant animer

	addq.w #1,d0

	;Se contenter de décrémenter le compteur de trames du carctère s'il n'est pas nul

	tst.b OFFSET_ROLLERCHAR_SPEED(a0)
	beq prtRoutineDrawChar
	subi.b #1,OFFSET_ROLLERCHAR_SPEED(a0)
	bra prtRoutineNextChar

	;Afficher le caractère courant

prtRoutineDrawChar:
	move.b OFFSET_ROLLERCHAR_CHARNOW(a0),d3
	moveq #0,d4
	move.b d3,d4
	subi.b #$20,d4
	lsl.w #3,d4
	lea (a1,d4.w),a2
	movea.l OFFSET_ROLLERCHAR_BITPLANE(a0),a3
	REPT 8
	move.b (a2)+,(a3)
	lea (a3,d2.w),a3
	ENDR

	;Terminer l'animation du caractère s'il correspond au caractère final

	cmp.b OFFSET_ROLLERCHAR_CHAREND(a0),d3
	bne prtRoutineAnimateChar
	move.b #1,OFFSET_ROLLERCHAR_FLAGS(a0)
	bra prtRoutineNextChar

	;Animer le caractère courant en passant au caractère sur la droite (en rebouclant à partir de $20 si nécessaire)

prtRoutineAnimateChar:
	cmpi.b #$20+95-1,d3
	bne prtRoutineIncrementChar
	move.b #$20,d3
	bra prtRoutineCharAnimated
prtRoutineIncrementChar:
	addq.b #1,d3
prtRoutineCharAnimated:
	move.b d3,OFFSET_ROLLERCHAR_CHARNOW(a0)

	;Réinitiaiser le compteur de trames du caractère

	move.b #PRT_ROLLER_SPEED,OFFSET_ROLLERCHAR_SPEED(a0)

	;Passer au caractère suivant

prtRoutineNextChar:
	lea DATASIZE_ROLLERCHAR(a0),a0
	subq.w #1,d1
	bne prtRoutineUpdateChars

prtRoutineUpdateDone:
	movem.l (sp)+,d1-d4/a0-a3
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

prtRoutineEnd:
	rts

;---------- Données ----------

OFFSET_ROLLERHEADER_NBCHARS=0
OFFSET_ROLLERHEADER_POINTER=2
DATASIZE_ROLLERHEADER=2+4
OFFSET_ROLLERCHAR_CHARNOW=0
OFFSET_ROLLERCHAR_CHAREND=1
OFFSET_ROLLERCHAR_SPEED=2
OFFSET_ROLLERCHAR_FLAGS=3
OFFSET_ROLLERCHAR_BITPLANE=4
DATASIZE_ROLLERCHAR=1+1+1+1+4
prtRollerData:
	BLK.B DATASIZE_ROLLERHEADER+PRT_ROLLER_MAXNBCHARS*DATASIZE_ROLLERCHAR,0

	ENDC

;********** Raiser **********

;Le raiser consiste à faire monter un caractère depuis sa ligne de base jusqu'à ce qu'il soit intégralement affiché.

	IFNE PRT_PRINTER=2

PRT_RAISER_MAXNBCHARS=(DISPLAY_DY>>3)*(DISPLAY_DX>>3)	;Devrait suffire pour tous les cas : couvre tout un écran basse résolution
PRT_RAISER_SPEED=2										;Nombre de frames entre deux étapes >= 0

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineSetup:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_RAISERHEADER_NBCHARS(a0)
	lea DATASIZE_RAISERHEADER(a0),a1
	move.l a1,OFFSET_RAISERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

_prtRoutineNewChar:
	movem.l d0-d1/a0-a3,-(sp)

	;Récupérer le pointeur de caractères

	lea prtRoutineData,a1
	movea.l OFFSET_RAISERHEADER_POINTER(a1),a2

	;Stocker l'état du caractère. Au départ, seule la première ligne du caractère est visible à hauteur de ligne de base.

	move.b d0,OFFSET_RAISERCHAR_CHAR(a2)
	move.b #1,OFFSET_RAISERCHAR_HEIGHT(a2)
	move.b #PRT_RAISER_SPEED,OFFSET_RAISERCHAR_SPEED(a2)
	move.b #0,OFFSET_RAISERCHAR_FLAGS(a2)
	lea prtState,a3
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a3),d0
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a3),d0
	move.w d0,d1
	lsl.w #3,d0
	sub.w d1,d0
	lea (a0,d0.w),a0
	move.l a0,OFFSET_RAISERCHAR_BITPLANE(a2)

	;Incrémenter le compteur et le pointeur de caractères
	
	lea DATASIZE_RAISERCHAR(a2),a2
	move.l a2,OFFSET_RAISERHEADER_POINTER(a1)
	addi.w #1,OFFSET_RAISERHEADER_NBCHARS(a1)

	movem.l (sp)+,d0-d1/a0-a3
	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

_prtRoutineNewPage:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_RAISERHEADER_NBCHARS(a0)
	lea DATASIZE_RAISERHEADER(a0),a1
	move.l a1,OFFSET_RAISERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés
;Notice :
;	Même remarque que pour prtRoutineUpdate.

_prtRoutineUpdate:
	movem.l d1-d3/a0-a3,-(sp)

	moveq #0,d0

	lea prtRoutineData,a0
	move.w OFFSET_RAISERHEADER_NBCHARS(a0),d1
	beq _prtRoutineUpdateDone

	lea DATASIZE_RAISERHEADER(a0),a0
	lea prtState,a1
	moveq #0,d2
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d2
	movea.l OFFSET_PRINTERSETUP_FONT(a1),a1
_prtRoutineUpdateChars:

	;Ne rien faire si l'animation du caractère est terminée

	tst.b OFFSET_RAISERCHAR_FLAGS(a0)
	bne _prtRoutineNextChar

	;Comptabiliser le caractère comme restant animer

	addq.w #1,d0

	;Se contenter de décrémenter le compteur de trames du carctère s'il n'est pas nul

	tst.b OFFSET_RAISERCHAR_SPEED(a0)
	beq _prtRoutineDrawChar
	subi.b #1,OFFSET_RAISERCHAR_SPEED(a0)
	bra _prtRoutineNextChar
	
	;Afficher le caractère à sa hauteur courante

_prtRoutineDrawChar:
	moveq #0,d3
	move.b OFFSET_RAISERCHAR_CHAR(a0),d3
	subi.b #$20,d3
	lsl.w #3,d3
	lea (a1,d3.w),a2
	move.b OFFSET_RAISERCHAR_HEIGHT(a0),d3
	movea.l OFFSET_RAISERCHAR_BITPLANE(a0),a3
_prtRoutineDrawCharRows:
	move.b (a2)+,(a3)
	lea (a3,d2.w),a3
	subq.b #1,d3
	bne _prtRoutineDrawCharRows

	;Terminer l'animation du caractère s'il a atteint sa hauteur finale

	cmpi.b #8,OFFSET_RAISERCHAR_HEIGHT(a0)
	bne _prtRoutineAnimateChar
	move.b #1,OFFSET_RAISERCHAR_FLAGS(a0)
	bra _prtRoutineNextChar

	;Animer le caractère en accroissant sa hauteur

_prtRoutineAnimateChar:
	addi.b #1,OFFSET_RAISERCHAR_HEIGHT(a0)
	sub.l d2,OFFSET_RAISERCHAR_BITPLANE(a0)

	;Réinitiaiser le compteur de trames du caractère

	move.b #PRT_RAISER_SPEED,OFFSET_RAISERCHAR_SPEED(a0)

	;Passer au caractère suivant

_prtRoutineNextChar:
	lea DATASIZE_RAISERCHAR(a0),a0
	subq.w #1,d1
	bne _prtRoutineUpdateChars

_prtRoutineUpdateDone:
	movem.l (sp)+,d1-d3/a0-a3
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineEnd:
	rts

OFFSET_RAISERHEADER_NBCHARS=0
OFFSET_RAISERHEADER_POINTER=2
DATASIZE_RAISERHEADER=2+4
OFFSET_RAISERCHAR_CHAR=0
OFFSET_RAISERCHAR_HEIGHT=1
OFFSET_RAISERCHAR_SPEED=2
OFFSET_RAISERCHAR_FLAGS=3
OFFSET_RAISERCHAR_BITPLANE=4
DATASIZE_RAISERCHAR=1+1+1+1+4
prtRoutineData:
	BLK.B DATASIZE_RAISERHEADER+PRT_RAISER_MAXNBCHARS*DATASIZE_RAISERCHAR,0

	ENDC

;********** Animator **********

;L'animator consiste à combiner logiquement les frames d'une animation au caractère jusqu'à ce que toutes les frames ont été parcourues. Pour créer des animations, s'aider de l'onglet "character mask" de Amiga.xlsm.

	IFNE PRT_PRINTER=3

PRT_ANIMATOR_MAXNBCHARS=(DISPLAY_DY>>3)*(DISPLAY_DX>>3)	;Devrait suffire pour tous les cas : couvre tout un écran basse résolution
PRT_ANIMATOR_SPEED=4									;Nombre de frames entre deux étapes >= 0
PRT_ANIMATOR_NBFRAMES=4

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineSetup:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_ANIMATORHEADER_NBCHARS(a0)
	lea DATASIZE_ANIMATORHEADER(a0),a1
	move.l a1,OFFSET_ANIMATORHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

_prtRoutineNewChar:
	movem.l a1-a2,-(sp)

	;Récupérer le pointeur de caractères

	lea prtRoutineData,a1
	movea.l OFFSET_ANIMATORHEADER_POINTER(a1),a2

	;Stocker l'état du caractère. Au départ, l'image de l'animation du masque du caractère est la première.

	move.b d0,OFFSET_ANIMATORCHAR_CHAR(a2)
	move.b #PRT_ANIMATOR_SPEED,OFFSET_ANIMATORCHAR_SPEED(a2)
	move.b #0,OFFSET_ANIMATORCHAR_FRAME(a2)
	move.b #0,OFFSET_ANIMATORCHAR_FLAGS(a2)
	move.l a0,OFFSET_ANIMATORCHAR_BITPLANE(a2)

	;Incrémenter le compteur et le pointeur de caractères
	
	lea DATASIZE_ANIMATORCHAR(a2),a2
	move.l a2,OFFSET_ANIMATORHEADER_POINTER(a1)
	addi.w #1,OFFSET_ANIMATORHEADER_NBCHARS(a1)

	movem.l (sp)+,a1-a2
	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

_prtRoutineNewPage:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_ANIMATORHEADER_NBCHARS(a0)
	lea DATASIZE_ANIMATORHEADER(a0),a1
	move.l a1,OFFSET_ANIMATORHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés
;Notice :
;	Même remarque que pour prtRoutineUpdate.

_prtRoutineUpdate:
	movem.l d1-d3/a0-a4,-(sp)

	moveq #0,d0

	lea prtRoutineData,a0
	move.w OFFSET_ANIMATORHEADER_NBCHARS(a0),d1
	beq _prtRoutineUpdateDone

	lea DATASIZE_ANIMATORHEADER(a0),a0
	lea prtState,a1
	moveq #0,d2
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d2
	movea.l OFFSET_PRINTERSETUP_FONT(a1),a1
_prtRoutineUpdateChars:

	;Ne rien faire si l'animation du caractère est terminée

	tst.b OFFSET_ANIMATORCHAR_FLAGS(a0)
	bne _prtRoutineNextChar

	;Comptabiliser comme restant animer

	addq.w #1,d0

	;Se contenter de décrémenter le compteur de trames du caractère s'il n'est pas nul

	tst.b OFFSET_ANIMATORCHAR_SPEED(a0)
	beq _prtRoutineDrawChar
	subi.b #1,OFFSET_ANIMATORCHAR_SPEED(a0)
	bra _prtRoutineNextChar
	
	;Afficher le caractère en le masquant par l'image courante de l'animation du masque

_prtRoutineDrawChar:
	moveq #0,d3
	move.b OFFSET_ANIMATORCHAR_CHAR(a0),d3
	subi.b #$20,d3
	lsl.w #3,d3
	lea (a1,d3.w),a2
	moveq #0,d3
	move.b OFFSET_ANIMATORCHAR_FRAME(a0),d3
	lsl.w #3,d3
	lea prtRoutineFrames,a4
	lea (a4,d3.w),a4
	movea.l OFFSET_ANIMATORCHAR_BITPLANE(a0),a3
	REPT 8
	move.b (a2)+,d3
	and.b (a4)+,d3
	move.b d3,(a3)
	lea (a3,d2.w),a3
	ENDR

	;Terminer l'animation du caractère si l'animation du masque a atteint sa dernière image

	cmpi.b #PRT_ANIMATOR_NBFRAMES-1,OFFSET_ANIMATORCHAR_FRAME(a0)
	bne _prtRoutineAnimateChar
	move.b #1,OFFSET_ANIMATORCHAR_FLAGS(a0)
	bra _prtRoutineNextChar

	;Animer le caractère en progressant d'un image dans l'animation du masque

_prtRoutineAnimateChar:
	addi.b #1,OFFSET_ANIMATORCHAR_FRAME(a0)

	;Réinitiaiser le compteur de trames du caractère

	move.b #PRT_ANIMATOR_SPEED,OFFSET_ANIMATORCHAR_SPEED(a0)

	;Passer au caractère suivant

_prtRoutineNextChar:
	lea DATASIZE_ANIMATORCHAR(a0),a0
	subq.w #1,d1
	bne _prtRoutineUpdateChars

_prtRoutineUpdateDone:
	movem.l (sp)+,d1-d3/a0-a4
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineEnd:
	rts

OFFSET_ANIMATORHEADER_NBCHARS=0
OFFSET_ANIMATORHEADER_POINTER=2
DATASIZE_ANIMATORHEADER=2+4
OFFSET_ANIMATORCHAR_CHAR=0
OFFSET_ANIMATORCHAR_FRAME=1
OFFSET_ANIMATORCHAR_SPEED=2
OFFSET_ANIMATORCHAR_FLAGS=3
OFFSET_ANIMATORCHAR_BITPLANE=4
DATASIZE_ANIMATORCHAR=1+1+1+1+4
prtRoutineFrames:
	;Rectangle qui grossit (4 images) (combiner au caractère par AND)
	DC.B $00, $00, $00, $18, $18, $00, $00, $00
	DC.B $00, $00, $3C, $3C, $3C, $3C, $00, $00
	DC.B $00, $7E, $7E, $7E, $7E, $7E, $7E, $00
	DC.B $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
prtRoutineData:
	BLK.B DATASIZE_ANIMATORHEADER+PRT_ANIMATOR_MAXNBCHARS*DATASIZE_ANIMATORCHAR,0

	ENDC

;********** Shifter **********

;Le shifter consiste à décaler un caractère sur la gauche jusqu'à ce qu'il soit intégralement affiché.

	IFNE PRT_PRINTER=4

PRT_SHIFTER_MAXNBCHARS=(DISPLAY_DY>>3)*(DISPLAY_DX>>3)	;Devrait suffire pour tous les cas : couvre tout un écran basse résolution
PRT_SHIFTER_SPEED=2										;Nombre de frames entre deux étapes >= 0

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineSetup:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_SHIFTERHEADER_NBCHARS(a0)
	lea DATASIZE_SHIFTERHEADER(a0),a1
	move.l a1,OFFSET_SHIFTERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

_prtRoutineNewChar:
	movem.l a0-a2,-(sp)

	;Récupérer le pointeur de caractères

	lea prtRoutineData,a1
	movea.l OFFSET_SHIFTERHEADER_POINTER(a1),a2

	;Stocker l'état du caractère. Au départ, seule la première colonne du caractère est visible sur la droite.

	move.b d0,OFFSET_SHIFTERCHAR_CHAR(a2)
	move.b #PRT_SHIFTER_SPEED,OFFSET_SHIFTERCHAR_SPEED(a2)
	move.b #7,OFFSET_SHIFTERCHAR_SHIFT(a2)
	move.b #0,OFFSET_SHIFTERCHAR_FLAGS(a2)
	move.l a0,OFFSET_SHIFTERCHAR_BITPLANE(a2)

	;Incrémenter le compteur et le pointeur de caractères
	
	lea DATASIZE_SHIFTERCHAR(a2),a2
	move.l a2,OFFSET_SHIFTERHEADER_POINTER(a1)
	addi.w #1,OFFSET_SHIFTERHEADER_NBCHARS(a1)

	movem.l (sp)+,a0-a2
	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

_prtRoutineNewPage:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_SHIFTERHEADER_NBCHARS(a0)
	lea DATASIZE_SHIFTERHEADER(a0),a1
	move.l a1,OFFSET_SHIFTERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés
;Notice :
;	Même remarque que pour prtRoutineUpdate.

_prtRoutineUpdate:
	movem.l d1-d4/a0-a3,-(sp)

	moveq #0,d0

	lea prtRoutineData,a0
	move.w OFFSET_SHIFTERHEADER_NBCHARS(a0),d1
	beq _prtRoutineUpdateDone

	lea DATASIZE_SHIFTERHEADER(a0),a0
	lea prtState,a1
	moveq #0,d2
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d2
	movea.l OFFSET_PRINTERSETUP_FONT(a1),a1
_prtRoutineUpdateChars:

	;Ne rien faire si l'animation du caractère est terminée

	tst.b OFFSET_SHIFTERCHAR_FLAGS(a0)
	bne _prtRoutineNextChar

	;Comptabiliser le caractère comme restant animer

	addq.w #1,d0

	;Se contenter de décrémenter le compteur de trames du carctère s'il n'est pas nul

	tst.b OFFSET_SHIFTERCHAR_SPEED(a0)
	beq _prtRoutineDrawChar
	subi.b #1,OFFSET_SHIFTERCHAR_SPEED(a0)
	bra _prtRoutineNextChar
	
	;Afficher le caractère avec son décalage courant

_prtRoutineDrawChar:
	moveq #0,d3
	move.b OFFSET_SHIFTERCHAR_CHAR(a0),d3
	subi.b #$20,d3
	lsl.w #3,d3
	lea (a1,d3.w),a2
	move.b OFFSET_SHIFTERCHAR_SHIFT(a0),d4
	movea.l OFFSET_SHIFTERCHAR_BITPLANE(a0),a3
	REPT 8
	move.b (a2)+,d3
	lsr.b d4,d3
	move.b d3,(a3)
	lea (a3,d2.w),a3
	ENDR

	;Terminer l'animation du caractère s'il son décalage est nul

	tst.b OFFSET_SHIFTERCHAR_SHIFT(a0)
	bne _prtRoutineAnimateChar
	move.b #1,OFFSET_SHIFTERCHAR_FLAGS(a0)
	bra _prtRoutineNextChar

	;Animer le caractère en diminuant son décalage

_prtRoutineAnimateChar:
	subi.b #1,OFFSET_SHIFTERCHAR_SHIFT(a0)

	;Réinitiaiser le compteur de trames du caractère

	move.b #PRT_SHIFTER_SPEED,OFFSET_SHIFTERCHAR_SPEED(a0)

	;Passer au caractère suivant

_prtRoutineNextChar:
	lea DATASIZE_SHIFTERCHAR(a0),a0
	subq.w #1,d1
	bne _prtRoutineUpdateChars

_prtRoutineUpdateDone:
	movem.l (sp)+,d1-d4/a0-a3
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineEnd:
	rts

OFFSET_SHIFTERHEADER_NBCHARS=0
OFFSET_SHIFTERHEADER_POINTER=2
DATASIZE_SHIFTERHEADER=2+4
OFFSET_SHIFTERCHAR_CHAR=0
OFFSET_SHIFTERCHAR_SHIFT=1
OFFSET_SHIFTERCHAR_SPEED=2
OFFSET_SHIFTERCHAR_FLAGS=3
OFFSET_SHIFTERCHAR_BITPLANE=4
DATASIZE_SHIFTERCHAR=1+1+1+1+4
prtRoutineData:
	BLK.B DATASIZE_SHIFTERHEADER+PRT_SHIFTER_MAXNBCHARS*DATASIZE_SHIFTERCHAR,0

	ENDC

;********** Interwiner **********

;L'interwiner consiste à faire décaler les lignes paires d'un caractère sur la droite et ses lignes impaires sur la gauche jusqu'à ce qu'il soit intégralement affiché. C'est une adaptation du shiter (quelques lignes de code modifiées dans _prtRoutineDrawChar, c'est tout !)

	IFNE PRT_PRINTER=5

PRT_INTERWINER_MAXNBCHARS=(DISPLAY_DY>>3)*(DISPLAY_DX>>3)	;Devrait suffire pour tous les cas : couvre tout un écran basse résolution
PRT_INTERWINER_SPEED=2										;Nombre de frames entre deux étapes >= 0

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineSetup:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_INTERWINERHEADER_NBCHARS(a0)
	lea DATASIZE_INTERWINERHEADER(a0),a1
	move.l a1,OFFSET_INTERWINERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

_prtRoutineNewChar:
	movem.l a0-a2,-(sp)

	;Récupérer le pointeur de caractères

	lea prtRoutineData,a1
	movea.l OFFSET_INTERWINERHEADER_POINTER(a1),a2

	;Stocker l'état du caractère. Au départ, seule la première colonne du caractère est visible sur la droite.

	move.b d0,OFFSET_INTERWINERCHAR_CHAR(a2)
	move.b #PRT_INTERWINER_SPEED,OFFSET_INTERWINERCHAR_SPEED(a2)
	move.b #7,OFFSET_INTERWINERCHAR_SHIFT(a2)
	move.b #0,OFFSET_INTERWINERCHAR_FLAGS(a2)
	move.l a0,OFFSET_INTERWINERCHAR_BITPLANE(a2)

	;Incrémenter le compteur et le pointeur de caractères
	
	lea DATASIZE_INTERWINERCHAR(a2),a2
	move.l a2,OFFSET_INTERWINERHEADER_POINTER(a1)
	addi.w #1,OFFSET_INTERWINERHEADER_NBCHARS(a1)

	movem.l (sp)+,a0-a2
	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

_prtRoutineNewPage:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_INTERWINERHEADER_NBCHARS(a0)
	lea DATASIZE_INTERWINERHEADER(a0),a1
	move.l a1,OFFSET_INTERWINERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés
;Notice :
;	Même remarque que pour prtRoutineUpdate.

_prtRoutineUpdate:
	movem.l d1-d4/a0-a3,-(sp)

	moveq #0,d0

	lea prtRoutineData,a0
	move.w OFFSET_INTERWINERHEADER_NBCHARS(a0),d1
	beq _prtRoutineUpdateDone

	lea DATASIZE_INTERWINERHEADER(a0),a0
	lea prtState,a1
	moveq #0,d2
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d2
	movea.l OFFSET_PRINTERSETUP_FONT(a1),a1
_prtRoutineUpdateChars:

	;Ne rien faire si l'animation du caractère est terminée

	tst.b OFFSET_INTERWINERCHAR_FLAGS(a0)
	bne _prtRoutineNextChar

	;Comptabiliser le caractère comme restant animer

	addq.w #1,d0

	;Se contenter de décrémenter le compteur de trames du carctère s'il n'est pas nul

	tst.b OFFSET_INTERWINERCHAR_SPEED(a0)
	beq _prtRoutineDrawChar
	subi.b #1,OFFSET_INTERWINERCHAR_SPEED(a0)
	bra _prtRoutineNextChar
	
	;Afficher le caractère en les décalant de la valeur courante (les paires sur la droite, les impaires sur la gauche)

_prtRoutineDrawChar:
	moveq #0,d3
	move.b OFFSET_INTERWINERCHAR_CHAR(a0),d3
	subi.b #$20,d3
	lsl.w #3,d3
	lea (a1,d3.w),a2
	move.b OFFSET_INTERWINERCHAR_SHIFT(a0),d4
	movea.l OFFSET_INTERWINERCHAR_BITPLANE(a0),a3
	REPT 4
	move.b (a2)+,d3
	lsr.b d4,d3
	move.b d3,(a3)
	lea (a3,d2.w),a3
	move.b (a2)+,d3
	lsl.b d4,d3
	move.b d3,(a3)
	lea (a3,d2.w),a3
	ENDR

	;Terminer l'animation du caractère s'il son décalage est nul

	tst.b OFFSET_INTERWINERCHAR_SHIFT(a0)
	bne _prtRoutineAnimateChar
	move.b #1,OFFSET_INTERWINERCHAR_FLAGS(a0)
	bra _prtRoutineNextChar

	;Animer le caractère en diminuant son décalage

_prtRoutineAnimateChar:
	subi.b #1,OFFSET_INTERWINERCHAR_SHIFT(a0)

	;Réinitiaiser le compteur de trames du caractère

	move.b #PRT_INTERWINER_SPEED,OFFSET_INTERWINERCHAR_SPEED(a0)

	;Passer au caractère suivant

_prtRoutineNextChar:
	lea DATASIZE_INTERWINERCHAR(a0),a0
	subq.w #1,d1
	bne _prtRoutineUpdateChars

_prtRoutineUpdateDone:
	movem.l (sp)+,d1-d4/a0-a3
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineEnd:
	rts

OFFSET_INTERWINERHEADER_NBCHARS=0
OFFSET_INTERWINERHEADER_POINTER=2
DATASIZE_INTERWINERHEADER=2+4
OFFSET_INTERWINERCHAR_CHAR=0
OFFSET_INTERWINERCHAR_SHIFT=1
OFFSET_INTERWINERCHAR_SPEED=2
OFFSET_INTERWINERCHAR_FLAGS=3
OFFSET_INTERWINERCHAR_BITPLANE=4
DATASIZE_INTERWINERCHAR=1+1+1+1+4
prtRoutineData:
	BLK.B DATASIZE_INTERWINERHEADER+PRT_INTERWINER_MAXNBCHARS*DATASIZE_INTERWINERCHAR,0

	ENDC

;********** Assembler **********

;L'assembler consiste à assembler le caractère découpé en 4 morceaux (des quarts) qui se déplacent le long des diagonales ne partant de l'extérieur du caractère jusqu'à ce que ce dernier soit intégralement affiché.

	IFNE PRT_PRINTER=6

PRT_ASSEMBLER_MAXNBCHARS=(DISPLAY_DY>>3)*(DISPLAY_DX>>3)	;Devrait suffire pour tous les cas : couvre tout un écran basse résolution
PRT_ASSEMBLER_SPEED=5										;Nombre de frames entre deux étapes >= 0

;---------- Initialisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineSetup:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_ASSEMBLERHEADER_NBCHARS(a0)
	lea DATASIZE_ASSEMBLERHEADER(a0),a1
	move.l a1,OFFSET_ASSEMBLERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Nouveau caractère ----------

;Entrée(s) :
;	D0 = Nouveau caractère
;	A0 = Adresse dans le bitplane où le caractère doit être affiché à la fin de l'animation
;Sortie(s) :
;	(rien)

_prtRoutineNewChar:
	movem.l a0-a2,-(sp)

	;Récupérer le pointeur de caractères

	lea prtRoutineData,a1
	movea.l OFFSET_ASSEMBLERHEADER_POINTER(a1),a2

	;Stocker l'état du caractère. Au départ, seuls les angles des quarts sont visibles dans les angles du caractère.

	move.b d0,OFFSET_ASSEMBLERCHAR_CHAR(a2)
	move.b #PRT_ASSEMBLER_SPEED,OFFSET_ASSEMBLERCHAR_SPEED(a2)
	move.b #1,OFFSET_ASSEMBLERCHAR_WIDTH(a2)
	move.b #0,OFFSET_ASSEMBLERCHAR_FLAGS(a2)
	move.l a0,OFFSET_ASSEMBLERCHAR_BITPLANE(a2)

	;Incrémenter le compteur et le pointeur de caractères
	
	lea DATASIZE_ASSEMBLERCHAR(a2),a2
	move.l a2,OFFSET_ASSEMBLERHEADER_POINTER(a1)
	addi.w #1,OFFSET_ASSEMBLERHEADER_NBCHARS(a1)

	movem.l (sp)+,a0-a2
	rts

;---------- Nouvelle page de texte ----------

;Entrée(s) :
;	A0 = Adresse de la page de texte
;Sortie(s) :
;	(rien)

_prtRoutineNewPage:
	movem.l a0-a1,-(sp)

	lea prtRoutineData,a0
	move.w #0,OFFSET_ASSEMBLERHEADER_NBCHARS(a0)
	lea DATASIZE_ASSEMBLERHEADER(a0),a1
	move.l a1,OFFSET_ASSEMBLERHEADER_POINTER(a0)

	movem.l (sp)+,a0-a1
	rts

;---------- Itération ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	D0 = # de caractères qui ne sont pas encore définitivement affichés
;Notice :
;	Même remarque que pour prtRoutineUpdate.

_prtRoutineUpdate:
	movem.l d1-d5/a0-a3,-(sp)

	moveq #0,d0

	lea prtRoutineData,a0
	move.w OFFSET_ASSEMBLERHEADER_NBCHARS(a0),d1
	beq _prtRoutineUpdateDone

	lea DATASIZE_ASSEMBLERHEADER(a0),a0
	lea prtState,a1
	moveq #0,d2
	move.w OFFSET_PRINTERSETUP_BITPLANEWIDTH(a1),d2
	add.w OFFSET_PRINTERSETUP_BITPLANEMODULO(a1),d2
	movea.l OFFSET_PRINTERSETUP_FONT(a1),a1
_prtRoutineUpdateChars:

	;Ne rien faire si l'animation du caractère est terminée

	tst.b OFFSET_ASSEMBLERCHAR_FLAGS(a0)
	bne _prtRoutineNextChar

	;Comptabiliser le caractère comme restant animer

	addq.w #1,d0

	;Se contenter de décrémenter le compteur de trames du carctère s'il n'est pas nul

	tst.b OFFSET_ASSEMBLERCHAR_SPEED(a0)
	beq _prtRoutineDrawChar
	subi.b #1,OFFSET_ASSEMBLERCHAR_SPEED(a0)
	bra _prtRoutineNextChar
	
	;Afficher le caractère faisant progresser ses quarts vers son centre

_prtRoutineDrawChar:
	moveq #0,d3
	move.b OFFSET_ASSEMBLERCHAR_CHAR(a0),d3
	subi.b #$20,d3
	lsl.w #3,d3
	lea (a1,d3.w),a2

	movea.l OFFSET_ASSEMBLERCHAR_BITPLANE(a0),a3
	REPT 8
	move.b #$00,(a3)
	lea (a3,d2.w),a3
	ENDR

	move.b OFFSET_ASSEMBLERCHAR_WIDTH(a0),d3
	moveq #4,d4
	sub.b d3,d4

	movea.l OFFSET_ASSEMBLERCHAR_BITPLANE(a0),a3
	lea (a2,d4.w),a4
_prtRoutineTL:
	move.b (a4)+,d5
	and.b #$F0,d5
	lsl.b d4,d5
	or.b d5,(a3)
	lea (a3,d2.w),a3
	subq.b #1,d3
	bne _prtRoutineTL
	
	move.b OFFSET_ASSEMBLERCHAR_WIDTH(a0),d3
	movea.l OFFSET_ASSEMBLERCHAR_BITPLANE(a0),a3
	lea (a2,d4.w),a4
_prtRoutineTR:
	move.b (a4)+,d5
	and.b #$0F,d5
	lsr.b d4,d5
	or.b d5,(a3)
	lea (a3,d2.w),a3
	subq.b #1,d3
	bne _prtRoutineTR

	movea.l OFFSET_ASSEMBLERCHAR_BITPLANE(a0),a3
	move.w d2,d3
	lsl.w #3,d3
	sub.w d2,d3
	lea (a3,d3.w),a3
	move.b OFFSET_ASSEMBLERCHAR_WIDTH(a0),d3
	moveq #3,d5
	add.b d3,d5
	lea (a2,d5.w),a4
_prtRoutineBL:
	move.b (a4),d5
	lea -1(a4),a4
	and.b #$F0,d5
	lsl.b d4,d5
	or.b d5,(a3)
	sub.l d2,a3
	subq.b #1,d3
	bne _prtRoutineBL

	movea.l OFFSET_ASSEMBLERCHAR_BITPLANE(a0),a3
	move.w d2,d3
	lsl.w #3,d3
	sub.w d2,d3
	lea (a3,d3.w),a3
	move.b OFFSET_ASSEMBLERCHAR_WIDTH(a0),d3
	moveq #3,d5
	add.b d3,d5
	lea (a2,d5.w),a4
_prtRoutineBR:
	move.b (a4),d5
	lea -1(a4),a4
	and.b #$0F,d5
	lsr.b d4,d5
	or.b d5,(a3)
	sub.l d2,a3
	subq.b #1,d3
	bne _prtRoutineBR

	;Terminer l'animation du caractère si le côté des quarts est de 4 pixels

	cmpi.b #4,OFFSET_ASSEMBLERCHAR_WIDTH(a0)
	bne _prtRoutineAnimateChar
	move.b #1,OFFSET_ASSEMBLERCHAR_FLAGS(a0)
	bra _prtRoutineNextChar

	;Animer le caractère en augment le côté de ses quarts

_prtRoutineAnimateChar:
	addi.b #1,OFFSET_ASSEMBLERCHAR_WIDTH(a0)

	;Réinitiaiser le compteur de trames du caractère

	move.b #PRT_ASSEMBLER_SPEED,OFFSET_ASSEMBLERCHAR_SPEED(a0)

	;Passer au caractère suivant

_prtRoutineNextChar:
	lea DATASIZE_ASSEMBLERCHAR(a0),a0
	subq.w #1,d1
	bne _prtRoutineUpdateChars

_prtRoutineUpdateDone:
	movem.l (sp)+,d1-d5/a0-a3
	rts

;---------- Finalisation ----------

;Entrée(s) :
;	(rien)
;Sortie(s) :
;	(rien)

_prtRoutineEnd:
	rts

;---------- Données ----------

OFFSET_ASSEMBLERHEADER_NBCHARS=0
OFFSET_ASSEMBLERHEADER_POINTER=2
DATASIZE_ASSEMBLERHEADER=2+4
OFFSET_ASSEMBLERCHAR_CHAR=0
OFFSET_ASSEMBLERCHAR_WIDTH=1
OFFSET_ASSEMBLERCHAR_SPEED=2
OFFSET_ASSEMBLERCHAR_FLAGS=3
OFFSET_ASSEMBLERCHAR_BITPLANE=4
DATASIZE_ASSEMBLERCHAR=1+1+1+1+4
prtRoutineData:
	BLK.B DATASIZE_ASSEMBLERHEADER+PRT_ASSEMBLER_MAXNBCHARS*DATASIZE_ASSEMBLERCHAR,0

	ENDC
