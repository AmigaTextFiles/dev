
; Listing13b5.s	; zusammengefasst
; Zeile 604

start:
	;move.w #$4000,$dff09a	; Interrupts disable
waitmouse:  
	btst	#6,$bfe001		; left mousebutton?
	bne.s	Waitmouse	
	
	bra zus11					; 10 (Abkürzung)
	
;------------------------------------------------------------------------------	
; asl.b #2,dy -> 	add.b dy,dy	; d0*4	(byte)
;					add.b dy,dy
zus1:
	moveq	#13,d0				; 4
	asl.b	#2,d0				; 10		; d0=34
		
	moveq	#13,d0				; 4
	add.b	d0,d0				; 4
	add.b	d0,d0				; 4			; d0=34
;------------------------------------------------------------------------------
; asl.l #16,dx ->	swap dx		; d0*65536 ; *2^16
; 					clr.w dx

	moveq	#13,d0				; 4
	;asl.l #16,d0				; out of range 3 bit
	asl.l	#8,d0				; 24
	asl.l	#8,d0				; 24
zus2:
	moveq	#13,d0				; 4
	swap	d0					; 4	
	clr.w	d0					; 4			; d0=000D0000
;------------------------------------------------------------------------------
; asl.w #2,dy -> 	add.w dy,dy	; d0*4	(word)
;					add.w dy,dy
zus3:
	moveq	#13,d0				; 4
	asl.w	#2,d0				; 10		; d0=34
		
	moveq	#13,d0				; 4
	add.w	d0,d0				; 4
	add.w	d0,d0				; 4			; d0=34
;------------------------------------------------------------------------------
; asl.x #1,dy -> 	add.x dy,dy	; d0*2	(word)
zus4:
	moveq	#13,d0				; 4
	asl.w	#1,d0				; 8			; d0=$1a

	moveq	#13,d0				; 4
	add.w	 d0,d0				; 4			; d0=$1a
;------------------------------------------------------------------------------
; asr.l #16,dx -> swap dx		; d0/65536 ; /2^16
;				ext.l dx

;>?65536*!-13
;0xFFF30000 = %11111111111100110000000000000000 = 4294115328 = -851968
;>
	move.l	#$fff30000,d0		; 4			; d0=$fff30000
;	asr.l	#16,d0				; out of range 3 bit
	asr.l	#8,d0				; 24		; d0=$fffff300
	asr.l	#8,d0				; 24		; d0=$fffffff3
zus5:
	move.l	#$fff30000,d0		; 4			; d0=$fff30000
	swap	d0					; 4			; d0=$0000fff3
	ext.l	d0					; 4			; d0=$fffffff3
;------------------------------------------------------------------------------
; bsr label -> 	bra label
;				rts
zus6:
;------------------------------------------------------------------------------
; clr.x n(ax,rx) -> move.x ds,n(ax,rx)	; ds muss natürlich 0 sein!
zus7:
	move.w		#13,$200012		; 20
	movea.l		#$20000,a1		; 12
	move.w		#10,d1			; 8

	clr.b		2(a1,d1)		; 18		clr.b (a1,d1.W,$02) == $0002000c [09]

	move.w		#13,$200012		; 20
	movea.l		#$20000,a1		; 12
	move.w		#10,d1			; 8
	moveq		#0,d0			; 4
	
	move.b		d0,2(a1,d1)		; 14		move.b d0,(a1,d1.W,$02) == $0002000c [00]
;------------------------------------------------------------------------------
;lsl.l #16,dx -> swap dx		; d0*65536 ; *2^16
;				clr.w dx
zus8:
	;lsl.l #16,dx				; out of range 3 bit
	
	moveq	#13,d0				; 4
	swap	d0					; 4
	clr.w	d0					; 4		; d0=000D0000
;------------------------------------------------------------------------------
; move.b #-1,(ax) -> st (ax)
; move.b #-1,dest -> st dest
zus9:

	movea.l		#$20000,a1		; 12
	move.b		#-1,(a1)		; 12	 

	movea.l		#$20000,a1		; 12
	st (a1)						; 12	 st.b (a1) [ff] (T)
;------------------------------------------------------------------------------
;	move.b #-1,dest -> st dest
zus10:	
	move.b #-1,dest				; 20	move.b #$ff,$000221b4 [00]

	st dest						; 20	st.b $000221b4 [ff] (T)
;------------------------------------------------------------------------------
; move.b #x,mn ->	move.w #xy,mn									; ???
;					move.b #y,mn+1
zus11:
	move.b #2,$20000			; 20																
	
	move.w #21,$20000			; 20
	move.b #5,$20000+1			; 20

;>m $20000 1
;00020000 0005 ....
;------------------------------------------------------------------------------
;move.x ax,ay -> lea n(ax),ay			; -32767 <= n <= 32767		; ???
;				 add.x #n,ay
zus12:
	movea.l a0,a1				; 4		; A0 00020000   A1 00020000
		
	lea 0(a0),a1				; 4		lea.l (a0,$0000) == $00020000,a1
	add.w #2,a1					; 12	adda.w #$0002,a1	; A0 00020000   A1 00020002
;------------------------------------------------------------------------------
;move.x ax,az -> lea n(ax,ay),az		;  az=n+ax+ay, n<=32767		; ???
;				add.x #n,az
;				add.x ay,az
zus13:
	movea.l		#$20000,a0		; 12
	movea.l		#$20002,a1		; 12
	movea.l		#$20004,a2		; 12

	movea.l		a0,a2			; 4		

	lea		10(a0,a1),a2		; 12	; lea.l (a0,a1.W,$0a) == $0002000c,a2
	add.w	#10,a2				; 12	; A1 00020002   A2 00020016
	add.w	a1,a2				; 8		; A1 00020002   A2 00020018

;------------------------------------------------------------------------------
;sub.x #n,ax -> 	lea -n(ax),ax		; -32767 <= n <= -9, 9 <= n <= 32767
zus14:	
	movea.l		#$20000,a1		; 12
	sub			#2,a1			; 12	; A1 0001FFFE			

	movea.l		#$20000,a1		; 12
	lea			-2(a1),a1		; 8		; A1 0001FFFE
;------------------------------------------------------------------------------
	nop
	;move.w #$C000,$dff09a	; Interrupts enable

	rts

dest:
	dc.b	0


	end

;------------------------------------------------------------------------------
r
Filename: Listing13b5.s
>a
Pass1
Pass2
No Errors
>ad		; asmone Debugger





zusammengefasst:

asl.x #2,dy -> 	add.x dy,dy
				add.x dy,dy
------------------------------------
asl.l #16,dx -> swap dx
				clr.w dx
------------------------------------
asl.w #2,dy -> 	add.w dy,dy
				add.w dy,dy
------------------------------------
asl.x #1,dy -> 	add.x dy,dy
------------------------------------
asr.l #16,dx -> swap dx
				ext.l dx
------------------------------------
bsr label -> 	bra label
				rts
------------------------------------
clr.x n(ax,rx) -> move.x ds,n(ax,rx)	; ds muss natürlich 0 sein!
------------------------------------
lsl.l #16,dx -> swap dx
				clr.w dx
------------------------------------
move.b #-1,(ax) -> st (ax)
------------------------------------
move.b #-1,dest -> st dest
------------------------------------
move.b #x,mn ->	move.w #xy,mn
				move.b #y,mn+1
------------------------------------
move.x ax,ay -> lea n(ax),ay			; -32767 <= n <= 32767
				add.x #n,ay
------------------------------------
move.x ax,az -> lea n(ax,ay),az			;  az=n+ax+ay, n<=32767
				add.x #n,az
				add.x ay,az
------------------------------------
sub.x #n,ax -> 	lea -n(ax),ax			; -32767 <= n <= -9, 9 <= n <= 32767
------------------------------------