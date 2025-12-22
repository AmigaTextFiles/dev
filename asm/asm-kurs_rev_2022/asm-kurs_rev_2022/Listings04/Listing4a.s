
; Listing4a.s	UNIVERSELLE ROUTINE ZUM POINTEN DER BITPLANES

	SECTION CiriBiri,CODE

Anfang:
	MOVE.L	#PIC,d0			; in d0 kommt die Adresse von unserer PIC
							; bzw. wo ihre erste Bitplane beginnt

	LEA	BPLPOINTERS,A1		; in a1 kommt die Adresse der Bitplane-
							; Pointer der Copperlist
	MOVEQ	#2,D1			; Anzahl der Bitplanes -1 (hier sind es 3)
							; für den DBRA - Zyklus
POINTBP:
	move.w	d0,6(a1)		; kopiert das niederwertige Word der Plane-
							; Adresse ins richtige Word der Copperlist
	swap	d0				; vertauscht die 2 Word in d0 (Z.B.: 1234 > 3412)
							; dadurch kommt das hochwertige Word an die
							; Stelle des niederwertigen, wodurch das
							; kopieren mit dem Move.w ermöglicht wird!!
	move.w	d0,2(a1)		; kopiert das hochwertige Word der Adresse des 
							; Plane in das richtige Word in der Copperlist
	swap	d0				; vertauscht erneut die 2 Word von d0 (3412 > 1234)
							; damit wird die orginale Adresse wieder hergestellt
	ADD.L	#40*256,d0		; Zählen 10240 zu D0 dazu, somit zeigen wir
							; auf die zweite Bitplane (befindet sich direkt
							; nach der ersten), wir zählen praktisch die Länge
							; einer Plane dazu
							; In den nächsten Durchgängen werden wir dann auf die
							; dritte, vierte... Bitplane zeigen

	addq.w	#8,a1			; a1 enthält nun die Adresse der nächsten
							; bplpointer in der Copperlist, die es
							; einzutragen gilt
	dbra	d1,POINTBP		; Wiederhole D1 mal POINTBP (D1=num of bitplanes)

	rts						; ENDE!!



COPPERLIST:
;	....	; hier setzen wir die nötigen Register eim...

;	Wir lassen die Bitplanes direkt anpointen, indem wir die Register 
;	$dff0e0 und folgende direkt in die Copperlist geben, gefolgt von
;	den Adressen der Bitplanes. Diese werden von der Routine POINTBP
;	eingesetzt.

BPLPOINTERS:
	dc.w	$e0,$0000,$e2,$0000	; erste  Bitplane - BPL0PT
	dc.w	$e4,$0000,$e6,$0000	; zweite Bitplane - BPL1PT
	dc.w	$e8,$0000,$ea,$0000	; dritte Bitplane - BPL2PT
;	....
	dc.w	$FFFF,$FFFE			; Ende der Copperlist

;	Erinnert euch, die Directory auszuwählen, in der das Bild zu
;	finden ist, in diesem Fall: "V df0:LISTINGS2"


PIC:
	incbin  "/Sources/Amiga_320_256_3.raw"	
							; hier laden wir das Bild im RAW
							; Format, das zuvor mit dem
							; KEFCON konvertiert wurde, es
							; besteht aus drei Bitplanes
							; nacheinander

						
	dc.w	$0180,$0010,$0182,$0111,$0184,$0022,$0186,$0222
	dc.w	$0188,$0333,$018a,$0043,$018c,$0333,$018e,$0154
	dc.w	$0190,$0444,$0192,$0455,$0194,$0165,$0196,$0655
	dc.w	$0198,$0376,$019a,$0666,$019c,$0387,$019e,$0766
	dc.w	$01a0,$0777,$01a2,$0598,$01a4,$0498,$01a6,$0877
	dc.w	$01a8,$0888,$01aa,$05a9,$01ac,$0988,$01ae,$0999
	dc.w	$01b0,$06ba,$01b2,$0a9a,$01b4,$0baa,$01b6,$07cb

	end

Probiert ein "AD", also ein DEBUG, dieser Routine zu machen. Dabei  achtet
vor  allem auf den Wert in d0, rechts oben sichtbar, in dem Moment, in dem
das SWAP ausgeführt wird. Um die Funktionalität  zu  überprüfen,  probiert
mit  einem  "M BPLPOINTERS" zu schauen, ob nach Abarbeitung des Programmes
die Adressen von PIC: geändert wurden, also GESWAPPT. Mit  einem  "M  PIC"
kann  man  die  Adresse sehen, wohin das INCBIN das Bild geladen hat, das,
wie vorausgesehen, 30720 Bytes lang war: 40*256*2.

