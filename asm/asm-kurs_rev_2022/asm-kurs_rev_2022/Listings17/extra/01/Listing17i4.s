
; Listing174.s = demoaces.S

	section	bau,code_C
*         Demo         A C E S     n°1


*               Programmée par Freddy
*		 Logo de Jean-Michel

*                  Le 06/02/1989


;>extern "datamus",mt_sampleinfo,100000
;>extern "letjm",donneesbrutes,100000
;>extern "sincos",sin,100000
;>extern "aces",dlogo,100000

*   pour le texte : il est a la ligne 202
*			'a' abaisse le "voile"
*			'r' remonte le "voile"
*			'b' couleur bleu
*			'o' couleur rouge
*			'j' couleur jaune
*			'v' couleur vert
*			'i' couleur violet


* ecran : 256*256 ; 32 couleurs *
* $69000 data lettre a $6d000

run:
	move.b	#38,$4000;	($4000)=nb de trait a afficher
	move.l $4,a6
	jsr -132(a6)
	lea $6a000,a0
	move #$3000,d0
clli:	clr (a0)+
	dbf d0,clli
	move #$8000,$40f0
	jsr listescop
	jsr clr ;		efface l'ecran
	jsr trace ;		trace les bandes
	jsr cop ;		initialise le copper
	jsr codagelettre ;	code les lettres
	jsr logo
;	jsr musicon
	move #$7fff,$dff096 ;		"service minimum"
	move #$83cf,$dff096

boucle:	move.l $dff004,d0
	andi.l #$1ff00,d0
	cmpi.l #$2000,d0
	bne boucle

	jsr defile2

	jsr ani3d

	cmpi #0,abai
	beq noab
	jsr abais

noab:	cmpi #0,remo
	beq nore
	jsr remon
nore:	
	jsr tstbsouris
	jmp boucle

abais:	move abai,d0
	asl  #5,d0
	andi.l #$ffff,d0
	move.l #32*224+$78000,a0
	move.l #32*224+$7a000,a1
	suba.l d0,a0
	suba.l d0,a1
	clr $1a(a1)
	clr $1a(a0)
	clr (a1)+
	clr (a0)+
	clr $1a(a1)
	clr $1a(a0)
	clr (a1)+
	clr (a0)+
	clr $1a(a1)
	clr $1a(a0)
	clr (a1)+
	clr (a0)+
	subi #1,abai
	clr remo
	rts

remon:	move remo,d0
	subi #1,d0
	mulu #24,d0
	lea dlogo,a6
	andi.l #$fffe,d0
	adda.l d0,a6
	move remo,d0
	subi #1,d0
	asl #5,d0
	andi.l #$fffe,d0
	addi.l #32*30,d0
	move.l #$78000,a0
	move.l #$7a000,a1
	adda.l d0,a0
	adda.l d0,a1
	move (a6)+,d0
	ori (a6)+,d0
	ori (a6)+,d0
	ori (a6)+,d0
	move d0,$1a(a0)
	move d0,$1a(a1)
	move d0,(a0)+
	move d0,(a1)+
	move (a6)+,d0
	ori (a6)+,d0
	ori (a6)+,d0
	ori (a6)+,d0
	move d0,$1a(a0)
	move d0,$1a(a1)
	move d0,(a0)+
	move d0,(a1)+
	move (a6)+,d0
	ori (a6)+,d0
	ori (a6)+,d0
	ori (a6)+,d0
	move d0,$1a(a0)
	move d0,$1a(a1)
	move d0,(a0)+
	move d0,(a1)+
	subi #1,remo
	clr abai
	rts

abai:dc.w 0
remo:dc.w 0
logo:
	lea dlogo,a6
	move.l #32*30+$70000,a0
	move.l #32*30+$72000,a1
	move.l #32*30+$74000,a2
	move.l #32*30+$76000,a3
	move.l #32*30+$78000,a4
	move.l #32*30+$7a000,a5
	move #194,d7
bbb:	move #2,d6
bbs:	move (a6)+,d0
	move (a6)+,d1
	move (a6)+,d2
	move (a6)+,d3
	move d0,(a0)+
	move d1,(a1)+
	move d2,(a2)+
	move d3,(a3)+
	ori d0,d1
	ori d1,d2
	ori d2,d3
	move d3,(a4)+
	move d3,(a5)+
	dbf d6,bbs
	adda.l #32-6,a0
	adda.l #32-6,a1
	adda.l #32-6,a2
	adda.l #32-6,a3
	adda.l #32-6,a4
	adda.l #32-6,a5
	dbf d7,bbb
	lea dlogo,a6
	move.l #32*30+$7001a,a0
	move.l #32*30+$7201a,a1
	move.l #32*30+$7401a,a2
	move.l #32*30+$7601a,a3
	move.l #32*30+$7801a,a4
	move.l #32*30+$7a01a,a5
	move #194,d7
wbb:	move #2,d6
wbs:	move (a6)+,d0
	move (a6)+,d1
	move (a6)+,d2
	move (a6)+,d3
	move d0,(a0)+
	move d1,(a1)+
	move d2,(a2)+
	move d3,(a3)+
	ori d0,d1
	ori d1,d2
	ori d2,d3
	move d3,(a4)+
	move d3,(a5)+
	dbf d6,wbs
	adda.l #32-6,a0
	adda.l #32-6,a1
	adda.l #32-6,a2
	adda.l #32-6,a3
	adda.l #32-6,a4
	adda.l #32-6,a5
	dbf d7,wbb
	rts

dlogo: ;blk.w 4*3*195,0
	incbin "aces"	;>extern "aces",dlogo,100000

texte:
	dc.b "              a        .    "
	dc.b " ........ "
	dc.b "SALUT vVINCENTb VOICI DONC MA oDEMO 2b $%%%%<> "
	dc.b "COMMENT LA TROUVES-TU ???"
	dc.b " JE L",$27,"AI FINIE LE 05/02/1989 "
	dc.b ". LA LISTE DU iCOPPERb FAIT ... 10 KO !!! "
	dc.b "EN CONNAIS-TU D",$27,"AUSSI LONGUE ?? "
	dc.b ". FIN DE oTiRvrAjNbSjMoIiSvSbIvOjNb ."
	dc.b " oFREDDYb ..... "
	dc.b $ff
even

lettre:	blk.b 15*18*2,0
	even
lign2:	dc.l 0
ptext:	dc.l 0
tabcol1:	dc.w $0,$355,$6,$7,$108,$109,$10a,$20b
	dc.w $222,$444,$555,$777,$999,$aaa,$ccc,$eee
tabcol2:	dc.w $0,$350,$660,$770,$881,$991,$aa1,$bb2
	dc.w $222,$444,$555,$777,$999,$aaa,$ccc,$eee
tabcol3:	dc.w $0,$50,$60,$70,$181,$191,$1a1,$2b2
	dc.w $222,$444,$555,$777,$999,$aaa,$ccc,$eee
tabcol4:	dc.w $0,$305,$606,$707,$818,$919,$a1a,$b2b
	dc.w $222,$444,$555,$777,$999,$aaa,$ccc,$eee
tabcol5:	dc.w $0,$533,$600,$700,$811,$911,$a11,$b22
	dc.w $222,$444,$555,$777,$999,$aaa,$ccc,$eee
addcol:dc.l tabcol1

chalet:
	clr.l lign2
	lea texte,a0
	move.l ptext,d0
	adda.l d0,a0
	move.b (a0),d0
	andi #$ff,d0
	addi.l #1,ptext
	cmpi.b #$ff,d0
	bne ncha
	clr.l ptext
	jmp chalet
ncha:	cmpi.b #"a",d0
	bne nab
	move #194,abai
	jmp chalet
nab:	cmpi.b #"r",d0
	bne nre
	move #194,remo
	jmp chalet

nre:	cmpi.b #"b",d0
	bne nnnb
	move.l #tabcol1,addcol
	jmp chalet
nnnb:	cmpi.b #"j",d0
	bne nnnj
	move.l #tabcol2,addcol
	jmp chalet
nnnj:	cmpi.b #"v",d0
	bne nnnv
	move.l #tabcol3,addcol
	jmp chalet
nnnv:	cmpi.b #"i",d0
	bne nnni
	move.l #tabcol4,addcol
	jmp chalet
nnni:	cmpi.b #"o",d0
	bne nnno
	move.l #tabcol5,addcol
	jmp chalet
nnno:
	subi.b #$20,d0
	andi #$ff,d0
	mulu #15*16,d0
	lea $69000,a0
	lea lettre,a1
	lea lettre,a2
	adda.l #15,a2
	adda.l d0,a0
	move #15,d1
chaa:	move #14,d0
cha:	move.b (a0),(a1)+
	move.b (a0)+,(a2)+
	dbf d0,cha
	adda.l #15,a1
	adda.l #15,a2
	dbf d1,chaa
	rts


defile2:
	btst #14,$dff002
	bne defile2
	move.l #$6d112,$dff050
	move.l #$6d0ce,$dff054
	move #2,$dff064
	move #2,$dff066
	move.l #$ffffffff,$dff044
	move #0,$dff042
	move #$9f0,$dff040
	move #$40*1023+1,$dff058
g:btst #14,$dff002
	bne g
	move #$40*1023+1,$dff058
h:btst #14,$dff002
	bne h
	move #$40*385+1,$dff058
	lea $6f640,a0
	tst (a0)+
	move #$fffe,(a0)+
	tst (a0)+
	move #$fffe,(a0)+
	lea lettre,a1
	move.l addcol,a2
	move.l lign2,d0
	adda.l d0,a1
	move #14,d0
	clr.l d1
afli2:	tst (a0)+
	move.b (a1)+,d1
	bclr #0,d1
	move $0(a2,d1),(a0)+
	dbf d0,afli2
	tst (a0)+
	move #$fffe,(a0)+
	tst (a0)+
	move #$fffe,(a0)+
	lea lettre,a1
	move.l addcol,a2
	move.l lign2,d0
	adda.l d0,a1
	move #14,d0
	clr.l d1
aafli2:	tst (a0)+
	move.b (a1)+,d1
	bclr #0,d1
	move $0(a2,d1),(a0)+
	dbf d0,aafli2
	addi.l #15,lign2
	cmpi.l #15*17*2,lign2
	bne nn2
	jsr chalet
nn2:	rts


listescop: ;		1ere liste $6d000    2eme $6a000
	lea moncop,a0
	move.l #$6d000,a1
	move #51*2-1,d0
li0:	move (a0)+,(a1)+
	dbf d0,li0
	lea donlist1,a0
	clr.l d1
	move #143-1,d0
li1:	move #$30+128,d2
	move (a0)+,d3

	cmpi #$ffff,d3
	bne noblli
	move #$1c0,(a1)+
	move #$fffe,(a1)+
	move #$1c0,(a1)+
	move #$fffe,(a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr (a1)+
	move #$1c0,(a1)+
	clr(a1)+
	bra finli

noblli:	sub d3,d2

	cmpi #$ffb0,d3
	bne rienli
	cmpi #$ffff,d1
	beq rienli
	move.l #$ffdffffe,(a1)+
	swap d2
	clr d2
	asl.l #8,d2
	addi.l #$1fffe,d2
	move.l d2,(a1)+
	move #$ffff,d1
	bra suili
rienli:	swap d2
	clr d2
	asl.l #8,d2
	addi.l #$1fffe,d2
	move.l d2,(a1)+
	move.l #$1c0fffe,(a1)+
suili:	move #$182,(a1)+
	clr (a1)+
	move #$184,(a1)+
	clr (a1)+
	move #$186,(a1)+
	clr (a1)+
	move #$188,(a1)+
	clr (a1)+
	move #$18a,(a1)+
	clr (a1)+
	move #$18c,(a1)+
	clr (a1)+
	move #$18e,(a1)+
	clr (a1)+
	move #$190,(a1)+
	clr (a1)+
	move #$192,(a1)+
	clr (a1)+
	move #$194,(a1)+
	clr (a1)+
	move #$196,(a1)+
	clr (a1)+
	move #$198,(a1)+
	clr (a1)+
	move #$19a,(a1)+
	clr (a1)+
	move #$19c,(a1)+
	clr (a1)+
	move #$19e,(a1)+
	clr (a1)+

finli:	dbf d0,li1

	move.l #$fffffffe,(a1)+

	rts

donlist1:
	dc.w 128,120,112,104,97,92,89,87,84,82,80,78,76
	dc.w 74,72,70,68,66,65,63,61,60,58,57,55,54,53
	dc.w 51,50,49,48,46,45,44,43,42,41,40,39,38,37
	dc.w 36,35,34,$ffff,33,32,31,30,$ffff,29,28,27
	dc.w $ffff,26,25,$ffff,24,23,$ffff,22,$ffff
	dc.w 21,20,18,16,13,10,7,4,0
	dc.w -4,-7,-10,-13,-16,-18,-20,-21
	dc.w $ffff,-22,$ffff,-23,-24,$ffff,-25,-26,$ffff
	dc.w -27,-28,-29,$ffff,-30,-31,-32,-33,$ffff,-34,-35,-36
	dc.w -37,-38,-39,-40,-41,-42,-43,-44,-45,-46,-48,-49,-50,-51
	dc.w -53,-54,-55,-57,-58,-60,-61,-63,-65,-66,-68,-70,-72,-74
	dc.w -76,-78,-80,-82,-84,-87,-89,-92,-97,-104,-112,-120,-128

trace:
	lea tabbandes,a0
	move.l #$70000,a1
	move #128-1,d0
tra0:	move (a0)+,d1 ;		d1 = pas
	asr #1,d1
	andi #$fff,d1
	move #$8000,d2 ;	d2 = abscisse du point
	move #7,d7
tra1:	sub d1,d2
	dbf d7,tra1
	move d1,d7
	asr #1,d7
	add d7,d2
	move #1,d3 ;		d3 = couleur et compteur
tra2:	move d2,d4
	add d1,d4 ;		d4 = prochain changement de couleur
tra3:	move d2,d5
	asr #8,d5
	move d5,d6
	and #7,d6
	asr #3,d5
	clr d7
	eor #7,d6
	bset d6,d7
	andi.l #$1f,d5
	move.l a1,a2
	adda.l d5,a2
	btst #0,d3
	beq tran0
	or.b d7,$0(a2)
tran0:	btst #1,d3
	beq tran1
	or.b d7,$2000(a2)
tran1:	btst #2,d3
	beq tran2
	or.b d7,$4000(a2)
tran2:	btst #3,d3
	beq tran3
	or.b d7,$6000(a2)
tran3:	addi #$100,d2
	move d2,d5
	move d4,d6
	andi #$ff00,d5
	andi #$ff00,d6
	cmp d6,d5
	bne tra3
	addi #1,d3
	move d4,d2
	cmpi #$10,d3
	bne tra2
	adda.l #$20,a1
	dbf d0,tra0
	move.l #$71000,a0
	move.l #$70fe0,a1
	move #127,d0
tra11:	move #15,d1
tra10:	move $6000(a1),$6000(a0)
	move $4000(a1),$4000(a0)
	move $2000(a1),$2000(a0)
	move (a1)+,(a0)+
	dbf d1,tra10
	suba.l #$40,a1
	dbf d0,tra11
	rts

tabbandes: ; largeur des bandes (valeur a virgule !!)
	dc.w $fff,$fff,$fff,$ffe,$ffd,$ffb,$ffa,$ff8
	dc.w $ff6,$ff3,$ff0,$fed,$fea,$fe5,$fe2,$fdd
	dc.w $fd9,$fd4,$fce,$fc9,$fc3,$fbc,$fb6,$fae
	dc.w $fa7,$f9f,$f97,$f8e,$f85,$f7b,$f70,$f64
	dc.w $f58,$f4c,$f3d,$f2e,$f1c,$f08,$ef1,$ed3
	dc.w $eb3,$e96,$e79,$e5c,$e40,$e22,$e06,$de9 
	dc.w $dcd,$db0,$d93,$d76,$d59,$d3d,$d20,$d03
	dc.w $ce6,$cc9,$cad,$c90,$c73,$c56,$c39,$c1d
	dc.w $c00,$be3,$bc6,$ba9,$b8d,$b70,$b53,$b36
	dc.w $b19,$afd,$ae0,$ac3,$aa6,$a89,$a6d,$a50
	dc.w $a33,$a16,$9f9,$9dd,$9c0,$9a3,$986,$969
	dc.w $94c,$930,$913,$8f6,$8d9,$8bc,$8a0,$883
	dc.w $866,$849,$82c,$810,$7f3,$7d6,$7b9,$79c
	dc.w $780,$763,$746,$729,$71a,$711,$709,$703
	dc.w $6fc,$6f8,$6f4,$6f0,$6ec,$6ea,$6e7,$6e4
	dc.w $6e2,$6e1,$6df,$6de,$6dd,$6dc,$6db,$6ba

codagelettre: ;		transforme 4 mots (= 1 ligne de 16 couleurs)
	lea donneesbrutes,a0 ;	en 16 octets (1 octets = couleur d'
	move.l #$69000,a1 ;	un point ) (on aurait pu : 2 points
	move #60*16-1,d0 ;	= 1 octets car 0=< couleur < 16 )
cl:	move.w (a0)+,d2
	move.w (a0)+,d3
	move.w (a0)+,d4
	move.w (a0)+,d5
	move.w #15,d6
cl0:	clr d7
	btst d6,d2
	beq cl1
	addi #1,d7
cl1:	btst d6,d3
	beq cl2
	addi #2,d7
cl2:	btst d6,d4
	beq cl3
	addi #4,d7
cl3:	btst d6,d5
	beq cl4
	addi #8,d7
cl4:	asl #1,d7
	move.b d7,(a1)+
	cmpi.b #1,d6
	beq jm
	dbf d6,cl0
jm:	dbf d0,cl
	rts

; lettre:  origine : $7a000 a $7dc00
;	blk.b 60*16*16 ;col pt1,col pt2,col pt3 ...

donneesbrutes: ;	pour 60 lettres
	;blk.w 16*60*4,$f000 ;	1er mot:plan1 ,2eme mot:plan2 ...
	incbin "letjm" ;>extern "letjm",donneesbrutes,100000

clr:	lea $70000,a0
	move #$3000-1,d0
clr0:	clr.l (a0)+
	dbf d0,clr0
	rts


tstbsouris:
	btst #6,$bfe001
	bne stbs
	jmp fincop
stbs:	rts


execbase=4
openlib=-408
cop:	move.l execbase,a6
	lea grname,a1
	jsr openlib(a6)
	move.l d0,a5
	adda.l #50,a5
	move.l a5,adadcop
	move.l (a5),adcop
	move.l #$6d000,(a5)
	rts

fincop:	move.l adadcop,a5
	move.l adcop,(a5)
	move.l (a7)+,d7
	move #$ffff,$dff096
	move #%0000010000001111,$dff096
;	jsr musicoff
	rts

grname:	dc.b 'graphics.library'
	even
adadcop:dc.l 0
adcop:	dc.l 0
moncop:	dc.w $008e,$3081,$0090,$30c1,$0092,$0048,$0094,$00c0
	dc.w $00e0,$0007,$00e2,$0000,$00e4,$0007,$00e6,$2000
	dc.w $00e8,$0007,$00ea,$4000,$00ec,$0007,$00ee,$6000
	dc.w $00f0,$0007,$00f2,$a000
	dc.w $0100,%0101001000000000
	dc.w $0102,$0000,$0104,$0000,$0108,$0000,$010a,$0000
	dc.w $0180,$0000,$0182,$0111,$0184,$0222,$0186,$0333
	dc.w $0188,$0444,$018a,$0555,$018c,$0666,$018e,$0777
	dc.w $0190,$0888,$0192,$0999,$0194,$0aaa,$0196,$0bbb
	dc.w $0198,$0ccc,$019a,$0ddd,$019c,$0eee,$019e,$0fff
	dc.w $01a0,$0f00,$01a2,$0311,$01a4,$0520,$01a6,$0830
	dc.w $01a8,$0a40,$01aa,$0d60,$01ac,$0f90,$01ae,$0f80
	dc.w $01b0,$0e93,$01b2,$0da5,$01b4,$0443,$01b6,$0554
	dc.w $01b8,$0665,$01ba,$0776,$01bc,$0887
	dc.w $01be,$0aa9
	dc.w $ffff,$fffe

alpha:dc.w 0
beta:dc.w 0
profondeur:dc.w 300

;
;                   FSW Transcrit par FREDDY de
;
;			     PHOENIX
;
;		 Programme : G E N I A L   ! ! ! !
;
;charger sincos en sin

ani3d:	move.l	#$ffffffff,$dff044;= à ne pas oublier !!!! sinon ...
	move.w	#$8000,$dff074
	move.w	#$ffff,$dff072
	move.w	#$20,$dff060
	move.w	#$20,$dff066
	move.w	#7,$dff048
	move.w	#7,$dff054
	moveq	#0,d0
	move.l	d0,d1
	move.l	d0,d2
	move.l	d0,d3
	move.l	d0,d4
	move.l	d0,d5
	lea	sin,a3;		quelques constantes ...
	lea	cos,a4
	move.l	#$dff000,a5
	move.b	#1,$40f2
	move.b	#0,$4002
;			c'est une memoire car en fait c'est ($40f4)
	move profondeur,$40f6
	move alpha,d6
	move beta,d7
;		On commence vraiment ici !

prog:
	jsr affiche
	move.l	#$ffffffff,$dff044;= à ne pas oublier !!!! sinon ...
	cmpi.w	#$8000,$40f0;	alternance des 2 pages graphiques
	bne.s	l28506;    une en $41000, une en $43000 avec effacage
	move.w	#$a000,$40f0; de celle que l'on ne voie pas 
l284ca:	cmpi.b	#$fa,$6(a5);ici:boucle d'attente
;	bne.s	l284ca
	move.w	#$8000,$6d036;pour le copper:prochaine page en $41000
l284da:	btst	#$e,$2(a5);	blitter libre ?
	bne.s	l284da
	move.l	#78*32+$7a006,$54(a5);efface toute la page en $43000
	clr.l	$60(a5);	avec le blitter
	clr.l	$64(a5);	avec le blitter
	clr.w	$42(a5)
	move #12,$66(a5)
	move.w	#$100,$40(a5)
	move.w	#$40*100+10,$58(a5);GO !!!
	move.w	#$a000,$40f0
	bra.s	l28540
l28506:	move.w	#$8000,$40f0
l2850c:	cmpi.b	#$fa,$6(a5); attente=>pour gagner
;	bne.s	l2850c;			4 ou 5 cycles !!!
	move.w	#$a000,$6d036;pour le copper:prochaine page en $43000
l2851c:	btst	#$e,$2(a5);	blitter libre ?
	bne.s	l2851c
	move.l	#78*32+$78006,$54(a5);efface toute la page en $41000
	clr.l	$60(a5);	avec le blitter
	clr.l	$64(a5);	avec le blitter
	clr.w	$42(a5)
	move #12,$66(a5)
	move.w	#$100,$40(a5)
	move.w	#$40*100+10,$58(a5);GO !!!
l28540:
l2855e:	move.w	$0(a4,d6.w),d4;	Et pour une rotation aleatoire ...
	asr.w	#6,d4
	asl.w	#1,d4
	addq.w	#4,d4
	add.w	d4,d7;		d7 est l'angle beta
	move.w	$0(a3,d7.w),d4
	asr.w	#5,d4
	asl.w	#1,d4
	addq.w	#8,d4
	add.w	d4,d6;		d6 est l'angle alpha : axe (ox)
	cmp.w	#$2d0,d7;	si l'angle depasse les bournes
	blt.s	betaok
	move.w	#0,d7
betaok:	cmp.w	#$2d0,d6
	blt.s	alphok	
	move.w	#0,d6
alphok:
	move d6,alpha
	move d7,beta
	rts

;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;			AFFICHAGE
;d6: angle alpha d'axe (ox)
;d7: 2éme angle de rotation
;($40f6): profondeur
;($4000): nombre de trait a afficher
;a0 a1 a2 : xx yy zz
;a3 a4 : sin et cos
;($40f0): bas poids adresse de l'ecran
;-------------------------------------------
affiche:
	move.b	$4000,d0
	move.b	d0,$40f4
	lea	xx,a0
	lea	yy,a1
	lea	zz,a2
	bra.s	l28428
oucle:	move.w	(a2)+,d4;	a2:zz
	cmp.w	(a2),d4
	bne.s	l28424
	move.w	(a1)+,d4;	a1:yy
	cmp.w	(a1),d4
	bne.s	l28426
	move.w	$40d0,d2;	ancienne abscisse 2D
	move.w	$40de,d0;	ancienne ordonnee 2D
	move.w	(a0)+,d4;	a0:xx
	cmp.w	(a0),d4
	bne.s	l2844c;	si zz et yy inchangée => moins de calcule !
	move.w	$40a0,d1;on ne calcule pas 2 fois le meme point !
	move.w	a6,d0
	bra.s	l28484
l28424:	tst.w	(a1)+;		a1:yy
l28426:	tst.w	(a0)+;		a0:xx
l28428:	move.w	(a1),d0
	move.w	d0,d4
	muls	$0(a4,d7.w),d0;	a4:cos
	move.w	(a2),d1
	move.w	d1,d2
	muls	$0(a3,d7.w),d1;	a3:sin
	sub.w	d1,d0
	move.w	d0,$40de
	muls	$0(a3,d7.w),d4;	a3:sin
	muls	$0(a4,d7.w),d2;	a4:cos
	add.w	d4,d2
	move.w	d2,$40d0
l2844c:	move.w	(a0),d1
	move.w	d1,d3
	muls	$0(a4,d6.w),d1;	a4:cos
	move.w	d2,d4
	muls	$0(a3,d6.w),d4;	a3:sin
	asr.l	#7,d4
	add.w	d4,d1
	muls	$0(a4,d6.w),d2;	a4:cos
	asr.l	#7,d2
	move.w	d3,d4
	muls	$0(a3,d6.w),d4;	a3:sin
	sub.w	d4,d2
	ext.l	d2
	asr.w	#8,d2
	add.w	$40f6,d2
	ext.l	d1
	ext.l	d0
	divs	d2,d1
	divs	d2,d0
	addi.w	#$80,d1
	addi.w	#$80,d0
l28484:	cmpi.b	#0,$40f2;($40f2)=0 => trace sinon calcule le 2éme pt
	beq.s	oktrace
	move.w	d1,$40a0;il faut donc calculer le prochain point
	move.w	d0,a6
	move.b	#0,$40f2;le prochain coup on trace c'est sur !
	bra.l	oucle
oktrace:move.w	d0,d3
	move.w	$40a0,d0
	move.w	a6,d2
	move.w	d1,$40a0
	move.w	d3,a6
	bsr.l	race
	move.b	#1,$40f2
	subq.b	#1,$40f4;a-t-on trace le nombre de point demandes ?
	bne.l	oucle;		NON
	rts
;--------------------------------------------
;		Affichage terminé !
;--------------------------------------------

;trace une ligne de d0,d2 a d1,d3 avec le blitter
race:	btst	#$e,$2(a5);	blitter libre ?
	bne.s	race
	move.w	#$20,$66(a5)
	move.w	#7,$54(a5)
	cmp.w	d1,d0
	blt.s	l285dc
	exg	d0,d1
	exg	d2,d3
l285dc:	sub.w	d0,d1
	cmp.w	d2,d3
	blt.s	l285e8
	move.w	d3,d4
	sub.w	d2,d3
	bra.s	l285ee
l285e8:	move.w	d2,d4
	sub.w	d3,d4
	exg	d4,d3
l285ee:	cmp.w	d2,d4
	blt.s	l28612
	cmp.w	d3,d1
	beq.s	l2860a
	bgt.s	l28602
	exg	d1,d3
	move.w	#$41,$42(a5)
	bra.s	l28630
l28602:	move.w	#$51,$42(a5)
	bra.s	l28630
l2860a:	move.w	#$11,$42(a5)
	bra.s	l28630
l28612:	cmp.w	d3,d1
	beq.s	l2862a
	bgt.s	l28622
	exg	d1,d3
	move.w	#$45,$42(a5)
	bra.s	l28630
l28622:	move.w	#$59,$42(a5)
	bra.s	l28630
l2862a:	move.w	#$19,$42(a5)
l28630:	move.w	d3,d4
	asl.w	#1,d4
	move.w	d4,d5
	sub.w	d1,d4
	move.w	d4,$52(a5)
	asl.w	#1,d5
	move.w	d5,$62(a5)
	move.w	d1,d4
	asl.w	#2,d4
	sub.w	d4,d5
	move.w	d5,$64(a5)
	move.w	d0,d4
	lsr.w	#3,d4
	move.w	d2,d5
	asl.w	#5,d2
;	asl.w	#3,d5
;	add.w	d5,d2
	add.w	d2,d4
	add.w	$40f0,d4
	move.w	d4,$4a(a5)
	move.w	d4,$56(a5)
	move.w	d0,d4
	andi.w	#$f,d4
	asl.w	#8,d4
	asl.w	#4,d4
	ori.w	#$bca,d4
	move.w	d4,$40(a5)
	addq.w	#1,d1
	asl.w	#6,d1
	addq.w	#2,d1
	move.w	d1,$58(a5);GO !!!
	rts
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------
;-------------------------------------------------------------------



sin:	;blk.w $168;	tableau des sinus
	incbin "sincos"		;>extern "sincos",sin,100000
cos:	blk.w $168;	tableau des cosinus
xx:	;	abscisse
	dc.w -140,-140,-140,-85,-85,-85,-140,-85
	dc.w -10,-65,-65,-65,-65,-10
	dc.w 65,10,10,10,10,65,10,50
	dc.w 85,140,140,140,140,85,85,85,85,140

	blk.w 44,0

yy:	;	hauteur
	dc.w -10,70,70,70,70,-10,30,30
	dc.w -10,-10,-10,70,70,70
	dc.w -10,-10,-10,70,70,70,30,30
	dc.w -10,-10,-10,30,30,30,30,70,70,70

	dc.w -35,-15,-15,-15,-25,-25
	dc.w -35,-15,-15,-15,-15,-25,-25,-25,-25,-35
	dc.w -35,-35,-35,-15,-15,-15,-25,-25
	dc.w -35,-15,-15,-20,-20,-30,-30,-35
	dc.w -35,-15,-15,-20,-20,-30,-30,-35
	dc.w -15,-35,-15,-25

zz:	blk.w 32,0
	dc.w -72,-72,-72,-52,-72,-62
	dc.w -47,-47,-47,-27,-27,-27,-27,-47,-37,-27
	dc.w -2,-22,-22,-22,-22,-2,-22,-12
	dc.w 3,3,3,23,23,23,23,3
	dc.w 28,28,28,48,48,48,48,28
	dc.w 73,53,53,63

