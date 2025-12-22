* Simple source to initialize a header and save it as a Studio16 3.0 sample
*
*	Public domain - made by Kenneth "Kenny" Nilsen
*	DEMO purpose ONLY!
*

	incdir	inc:
	include	libraries/studio16file.i
	include	lvo/exec_lib.i
	include	lvo/dos_lib.i
	incdir
	
start:	lea	header(pc),a5

* Initialize Studio16_2.0 sample header:

	move.l	#S16FID,S16F_ID(a5)		;init file ID (KWK3)
	move.l	#S16FILTERINIT,S16F_FILTER(a5)	;set antialias filter to 1

	move.l	#S16_FREQ_CD,S16F_RATE(a5)	;Freq   = 44100 Hz
	move.w	#S16_VOL_0,S16F_VOLUME(a5)	;Volume =    +0 dB
	move.l	#S16_PAN_MID,S16F_PAN(a5)	;Pan    =  Center

;	move.l	#$00120902,S16F_SMPTE(a5)	;DEMO=00:18:09:02  (HH:MM:SS:FF) SMPTE

	move.l	#(End-Sample)/2,S16F_REALSIZE(a5)	;real size of sample
	move.l	#(End-Sample)/2,S16F_EDITSIZE(a5)	;edit size is equal here
	move.l	#(End-Sample)/2-1,S16F_END(a5)		;first SampleClip covers whole sample

; save sample

	move.l	$4.w,a6			;exec base
	lea	LibName(pc),a1
	moveq	#0,d0
	jsr	_LVOOpenLibrary(a6)
	move.l	d0,DosBase		;dos library
	beq	.exit

	move.l	d0,a6
	move.l	#Filename,d1		;filename
	move.l	#MODE_NEWFILE,d2
	jsr	_LVOOpen(a6)		;open new file for write
	move.l	d0,d7
	beq	.cleanup

	move.l	d0,d1
	move.l	#Header,d2
	move.l	#S16F_SIZEOF,d3
	jsr	_LVOWrite(a6)		;write sample header

	move.l	d7,d1
	move.l	#Sample,d2
	move.l	#End-Sample,d3
	jst	_LVOWrite(a6)		;write sample data

	move.l	d7,d1
	jsr	_LVOClose(a6)		;close file

.cleanup
	move.l	a6,a1
	move.l	$4.w,a6
	jsr	_LVOCloseLibrary(a6)	;close dos.library

.exit	moveq	#0,d0			;exit and return 0
	rts

DosBase		dc.l	0
LibName		dc.b	"dos.library",0

Filename	dc.b	"ram:TestSample_mid",0	;change to suit your system
		even

Header		dcb.b	S16F_SIZEOF,0		;space for our header
Sample		incbin	sample_raw		;space for our sample
End
