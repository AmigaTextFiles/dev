
; soc03a.s
; a) erklärt Erstellung der Wait-Anweisung in der Copperliste

start:
	SECTION soc,CODE_C

LINE=100

	lea copList,a0
	;movea.l copList,a0		; mit dem Befehl wird der Wert (die Adresse) kopiert 
							; der hier steht und nicht die Adresse des Labels								

; auf den sichtbaren Start warten ($3E) der Zeile (<= 255). 

	move.w #(LINE<<8)!$3E!$0001,(a0)+		; $643F
	move.w #$8000!($7F<<8)!$FE,(a0)+		; $FFFE	--> dc.w $643F,$FFFE

	rts


	section soc,code_c

copList:		
	blk.w 100,$F0
	

	end


(LINE<<8)!$3E!$0001

100						=		00000000.01100100
100<<8					=		01100100.00000000
(100<<8)!$3E			=		01100100.00111110
(LINE<<8)!$3E!$0001		=		01100100.00111111	= $643F		($3E)

$8000!($7F<<8)!$FE

$8000					=		10000000.00000000
$8000!($7F<<8)			=		11111111.00000000
$8000!($7F<<8)!$FE		=		11111111.11111110	= $FFFE