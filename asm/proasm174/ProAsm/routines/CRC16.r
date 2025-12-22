
;---;  CRC16.r  ;--------------------------------------------------------------
*
*	****	ANSI CRC16    ****
*
*	Author		Daniel Weber
*	Version		1.20
*	Last Revision	23.06.93
*	Identifier	c16_defined
*       Prefix		c16_	(CRC16)
*				 ¯   ¯¯
*	Functions	CRC16
*			GenCRC16Table	(only available if CRC16.GenTable is
*					 defined)
*
*	Table		CRC16table	used by the 'CalcCRC16' routine
*					(512 bytes).
*
*	Flags		CRC16.GenTable	enable 'GenCRC16Table', disable
*					'CRC16table'.
*
;------------------------------------------------------------------------------

;------------------
	ifnd	c16_defined
c16_defined	SET	1

;------------------
c16_oldbase	equ __BASE
	base	c16_base
c16_base:

;------------------
	opt	sto,o+,ow-		;all optimisations on

;------------------


;------------------------------------------------------------------------------
*
* CRC16		calculate a CRC16 checksum
* CRC16D0	calculate a CRC16 checksum (partial)
*
* INPUT:	d0: checksum of the last part (only for CRC16D0!!)
*		d7: #of bytes to be checksumed (size of area)
*		a0: start of area
*
* RESULT:	d0: CRC16checksum
*
* NOTE:		CRC16D0 might be used to calculate a crc16 checksum in more
*		than one step. D0 must be set to the checksum of the last
*		part (or to zero for the first part).
*
;------------------------------------------------------------------------------

CRC16:
	moveq	#0,d0
;------------------
CRC16D0:
	movem.l	d1-a6,-(a7)
	lea	CRC16table(pc),a1	;CRC16 table for speed up
	move.w	#$ff,d1
	moveq	#0,d2
	moveq	#1,d3
\crcloop:
	move.b	(a0)+,d2		;take a byte
	eor.w	d2,d0
	move.w	d0,d5
	and.w	d1,d0
	add.w	d0,d0
	move.w	(a1,d0.w),d0
	lsr.w	#8,d5
	eor.w	d5,d0
	subq.l	#1,d7
	bne.s	\crcloop
	movem.l	(a7)+,d1-a6
	rts




;------------------------------------------------------------------------------
*
* GenCRC16Table	- generate a 512 byte table for the CRC16 checksumer
*
;------------------------------------------------------------------------------
	IFD	CRC16.GenTale
GenCRC16Table:
;------------------
	lea	CRC16table(pc),a0		;space for the table
	move	#0,d7

\loop:	move.w	d7,d6
	moveq	#7,d5

\loop2:	lsr.w	#1,d6
	bcc.s	1$
	eor.w	#$a001,d6
1$:	dbra	d5,\loop2
	move.w	d6,(a0)+
	addq.w	#1,d7
	cmp.w	#256,d7
	blt.s	\loop
	rts
	ENDC


;------------------------------------------------------------------------------
*
* Table to calculate the CRC16 checksum (512 bytes)
*
;------------------------------------------------------------------------------

	IFND	CRC16.GenTable
CRC16table:
	dc.w  $0000,$c0c1,$c181,$0140,$c301,$03c0,$0280,$c241
	dc.w  $c601,$06c0,$0780,$c741,$0500,$c5c1,$c481,$0440
	dc.w  $cc01,$0cc0,$0d80,$cd41,$0f00,$cfc1,$ce81,$0e40
	dc.w  $0a00,$cac1,$cb81,$0b40,$c901,$09c0,$0880,$c841
	dc.w  $d801,$18c0,$1980,$d941,$1b00,$dbc1,$da81,$1a40
	dc.w  $1e00,$dec1,$df81,$1f40,$dd01,$1dc0,$1c80,$dc41
	dc.w  $1400,$d4c1,$d581,$1540,$d701,$17c0,$1680,$d641
	dc.w  $d201,$12c0,$1380,$d341,$1100,$d1c1,$d081,$1040
	dc.w  $f001,$30c0,$3180,$f141,$3300,$f3c1,$f281,$3240
	dc.w  $3600,$f6c1,$f781,$3740,$f501,$35c0,$3480,$f441
	dc.w  $3c00,$fcc1,$fd81,$3d40,$ff01,$3fc0,$3e80,$fe41
	dc.w  $fa01,$3ac0,$3b80,$fb41,$3900,$f9c1,$f881,$3840
	dc.w  $2800,$e8c1,$e981,$2940,$eb01,$2bc0,$2a80,$ea41
	dc.w  $ee01,$2ec0,$2f80,$ef41,$2d00,$edc1,$ec81,$2c40
	dc.w  $e401,$24c0,$2580,$e541,$2700,$e7c1,$e681,$2640
	dc.w  $2200,$e2c1,$e381,$2340,$e101,$21c0,$2080,$e041
	dc.w  $a001,$60c0,$6180,$a141,$6300,$a3c1,$a281,$6240
	dc.w  $6600,$a6c1,$a781,$6740,$a501,$65c0,$6480,$a441
	dc.w  $6c00,$acc1,$ad81,$6d40,$af01,$6fc0,$6e80,$ae41
	dc.w  $aa01,$6ac0,$6b80,$ab41,$6900,$a9c1,$a881,$6840
	dc.w  $7800,$b8c1,$b981,$7940,$bb01,$7bc0,$7a80,$ba41
	dc.w  $be01,$7ec0,$7f80,$bf41,$7d00,$bdc1,$bc81,$7c40
	dc.w  $b401,$74c0,$7580,$b541,$7700,$b7c1,$b681,$7640
	dc.w  $7200,$b2c1,$b381,$7340,$b101,$71c0,$7080,$b041
	dc.w  $5000,$90c1,$9181,$5140,$9301,$53c0,$5280,$9241
	dc.w  $9601,$56c0,$5780,$9741,$5500,$95c1,$9481,$5440
	dc.w  $9c01,$5cc0,$5d80,$9d41,$5f00,$9fc1,$9e81,$5e40
	dc.w  $5a00,$9ac1,$9b81,$5b40,$9901,$59c0,$5880,$9841
	dc.w  $8801,$48c0,$4980,$8941,$4b00,$8bc1,$8a81,$4a40
	dc.w  $4e00,$8ec1,$8f81,$4f40,$8d01,$4dc0,$4c80,$8c41
	dc.w  $4400,$84c1,$8581,$4540,$8701,$47c0,$4680,$8641
	dc.w  $8201,$42c0,$4380,$8341,$4100,$81c1,$8081,$4040
	ENDC

;--------------------------------------------------------------------

;------------------
	base	c16_oldbase

;------------------
	opt	rcl

;------------------
	endif

 end

