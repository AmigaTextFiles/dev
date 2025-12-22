;
;	Disassembled by:
;		DASMx object code disassembler
;		(c) Copyright 1996-2003   Conquest Consultants
;		Version 1.40 (Oct 18 2003)
;
;	File:		superbug.bin
;
;	Size:		4096 bytes
;	Checksum:	4EF3
;	CRC-32:		FEF2AAE9
;
;	Date:		Thu Jun 04 15:03:21 2009
;
;	CPU:		Signetics 2650 (2650 family)
;
;
;
	org	$0000
;
L0000:
	eorz	r0
	lpsu
	lpsl
	ppsu	$60
	ppsl	$02
	bsta,un	L0684
	eorz	r0
	strz	r1
L000C:
	stra,r0	X17FF,r1
	stra,r0	X19FF,r1
	stra,r0	X18FF,r1
	bdrr,r1	L000C
	bcta,un	L0110
;
	db	$24, $99, $5A, $2D
	db	$6E, $BC, $5A, $81
	db	$24, $19, $DA, $3D
	db	$6E, $AC, $5B, $80
	db	$00, $98, $5B, $BC
	db	$76, $35, $DA, $01
	db	$24, $98, $5A, $BD
	db	$66, $BD, $5A, $01
	db	$A2, $54, $39, $66
	db	$7E, $39, $54, $8A
	db	$A4, $54, $39, $4E
	db	$7E, $39, $54, $4A
	db	$4A, $54, $38, $7E
	db	$4E, $38, $54, $A4
	db	$2A, $54, $39, $6E
	db	$6E, $39, $54, $A8
	db	$81, $5A, $3D, $76
	db	$B4, $5A, $99, $24
	db	$01, $DA, $35, $76
	db	$5C, $5B, $98, $24
	db	$80, $5B, $AC, $6E
	db	$3D, $DA, $19, $00
	db	$80, $5A, $BD, $66
	db	$BD, $5A, $19, $24
	db	$51, $2A, $9C, $7E
	db	$66, $9C, $2A, $45
	db	$4A, $2A, $1C, $3A
	db	$3A, $1C, $2A, $4A
	db	$52, $2A, $9C, $7E
	db	$72, $9C, $2A, $25
	db	$15, $2A, $9C, $76
	db	$76, $9C, $2A
X0099:
	db	$54, $00, $00, $00
	db	$18, $18, $00, $00
	db	$00, $F2, $10, $00
	db	$89, $F1, $0D, $84
	db	$82, $00, $87, $7C
	db	$F2, $07, $7C, $F2
	db	$03, $FF, $85, $00
	db	$87, $F2, $07, $7C
	db	$F2, $05, $85, $F3
	db	$40, $50, $01, $00
	db	$87, $F2, $03, $7C
	db	$F2, $09, $85, $00
	db	$87, $F2, $04, $7C
	db	$F2, $05, $7C, $00
	db	$00, $85, $00, $87
	db	$F2, $0D, $85, $F3
	db	$80, $90, $01, $F3
	db	$40, $A0, $01, $00
	db	$87, $00, $7C, $F2
	db	$09, $7C, $00, $85
	db	$00, $8A, $F1, $0D
	db	$86, $81
X00EF:
	db	$F0, $9A, $00, $D4
	db	$00, $00, $00, $00
	db	$00, $00, $00, $00
	db	$00, $00, $00, $D3
X00FF:
	db	$D0, $6C, $6E, $69
	db	$5E, $6B, $5B, $6E
	db	$60, $00, $A5, $9E
	db	$AF, $9E, $A5, $00
	db	$D1
;
L0110:
	bsta,un	L0705
	bsta,un	L0700
	lodi,r0	$E6
	stra,r0	X18FC
	eorz	r0
	stra,r0	X18FD
	stra,r0	X1A13
	stra,r0	X1A0E
	lodi,r0	$08
	stra,r0	X19F9
	lodi,r3	$10
L012C:
	loda,r0	X00FF,r3
	stra,r0	X185F,r3
	bdrr,r3	L012C
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$0C
	stra,r0	X1A12
L0141:
	bsta,un	L0684
	bsta,un	L05A8
	comi,r0	$FF
	bcfr,eq	L0141
L014B:
	bsta,un	L0705
	bsta,un	L0700
	loda,r0	X1A0B
	addi,r0	$01
	stra,r0	X1A0B
	comi,r0	$FF
	bcta,eq	L01AE
	loda,r0	X1908
	andi,r0	$0F
	comi,r0	$02
	bcta,eq	L0175
	comi,r0	$01
	bcta,eq	L01B5
	lodi,r3	$05
	bsta,un	L0983
	bcta,un	L014B
;
L0175:
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$57
	stra,r0	X1A12
	loda,r0	X186F
	strz	r1
	andi,r0	$0F
	comi,r0	$03
	bcfr,eq	L0197
	eorz	r0
	stra,r0	X1A0E
	lodi,r0	$D1
	stra,r0	X186F
	bctr,un	L01A4
;
L0197:
	addi,r1	$01
	stra,r1	X186F
	loda,r0	X1A0E
	addi,r0	$01
	stra,r0	X1A0E
L01A4:
	eorz	r0
	stra,r0	X1A0B
	bsta,un	L0981
	bcta,un	L014B
;
L01AE:
	lodi,r0	$FF
	stra,r0	X1A0C
	bctr,un	L01C4
;
L01B5:
	eorz	r0
	stra,r0	X1A0C
	stra,r0	X1A0A
	stra,r0	X1A13
	lodi,r0	$70
	stra,r0	X1A09
L01C4:
	lodi,r2	$AA
	lodi,r3	$08
L01C8:
	eorz	r0
	stra,r0	X197F,r3
	loda,r0	X0099,r3
	stra,r0	X1997,r3
	lodz	r2
	stra,r0	X19AF,r3
	bdrr,r3	L01C8
	lodi,r3	$10
L01DA:
	loda,r0	X00EF,r3
	stra,r0	X17FF,r3
	bdrr,r3	L01DA
	bcta,un	L080B
;
L01E5:
	bsta,un	L0705
	bsta,un	L0700
	loda,r0	X19FD
	stra,r0	X18EC
	loda,r0	X18E8
	andi,r0	$01
	bcta,eq	L029C
	loda,r0	X1A0C
	bctr,eq	L021B
	loda,r0	X1A0D
	bctr,eq	L020E
	subi,r0	$01
	stra,r0	X1A0D
	loda,r0	X18D7
	bcta,un	L0266
;
L020E:
	lodi,r0	$0A
	stra,r0	X1A0D
	bsta,un	L0802
	andi,r0	$0F
	bcta,un	L0266
;
L021B:
	loda,r3	X19FF
	loda,r0	X18D0
	eori,r0	$40
	stra,r0	X18D0
	stra,r0	X19F9
	loda,r0	X18D7
	andi,r0	$0F
	strz	r1
	strz	r2
	loda,r0	X18D0
	andi,r0	$40
	bctr,eq	L024F
	eori,r3	$FF
	lodi,r0	$0A
	andz	r2
	strz	r2
	comi,r3	$C8
	bctr,gt	L0247
	comi,r3	$38
	bctr,lt	L024B
	bctr,un	L0266
;
L0247:
	lodi,r0	$01
	bctr,un	L0263
;
L024B:
	lodi,r0	$04
	bctr,un	L0263
;
L024F:
	lodi,r0	$05
	andz	r2
	strz	r2
	comi,r3	$C8
	bctr,gt	L025D
	comi,r3	$38
	bctr,lt	L0261
	bctr,un	L0266
;
L025D:
	lodi,r0	$02
	bctr,un	L0263
;
L0261:
	lodi,r0	$08
L0263:
	iorz	r2
	andi,r0	$0F
L0266:
	stra,r0	X18D7
	iorz	r0
	bcfr,eq	L0276
	lodz	r1
	andi,r0	$0F
	bctr,eq	L029C
	strz	r3
	eorz	r0
	strz	r2
	bctr,un	L0282
;
L0276:
	loda,r2	X18D8
	bsta,un	L067C
	stra,r2	X18D8
	loda,r3	X18D7
L0282:
	stra,r3	X18E9
	lodi,r0	$00
	stra,r0	X18D1
	lodi,r0	$1A
	stra,r0	X18D2
	lodi,r0	$19
	stra,r0	X18D3
	lodi,r0	$80
	stra,r0	X18D4
	bsta,un	L070A
L029C:
	loda,r0	X18E8
	andi,r0	$02
	bcta,eq	L02FE
	loda,r0	X18E8
	andi,r0	$04
	bcfa,eq	L02D1
	loda,r2	X18DA
	bsta,un	L067C
	stra,r2	X18DA
	loda,r3	X18D9
	loda,r0	X18E2
	stra,r0	X18D1
	loda,r0	X18E3
	stra,r0	X18D2
	lodi,r0	$19
	stra,r0	X18D3
	lodi,r0	$88
	stra,r0	X18D4
	bsta,un	L070A
L02D1:
	loda,r0	X18E8
	andi,r0	$08
	bcfa,eq	L02FE
	loda,r2	X18DC
	bsta,un	L067C
	stra,r2	X18DC
	loda,r3	X18DB
	loda,r0	X18E2
	stra,r0	X18D1
	loda,r0	X18E3
	stra,r0	X18D2
	lodi,r0	$19
	stra,r0	X18D3
	lodi,r0	$90
	stra,r0	X18D4
	bsta,un	L070A
L02FE:
	bsta,un	L0705
	bsta,un	L05A8
	loda,r0	X1A06
	addi,r0	$01
	stra,r0	X1A06
	loda,r3	X18EF
	bctr,eq	L0318
	subi,r3	$01
	stra,r3	X18EF
	bctr,un	L033F
;
L0318:
	loda,r0	X180F
	strz	r2
	andi,r0	$0F
	bctr,eq	L0327
	subi,r2	$01
	stra,r2	X180F
	bctr,un	L033A
;
L0327:
	loda,r0	X180E
	strz	r1
	andi,r0	$0F
	bcta,eq	L0A91
	subi,r1	$01
	stra,r1	X180E
	lodi,r0	$59
	stra,r0	X180F
L033A:
	lodi,r0	$32
	stra,r0	X18EF
L033F:
	loda,r3	X18EC
	eori,r3	$FF
	lodi,r0	$10
	andz	r3
	bcta,eq	L0371
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$5C
	stra,r0	X1A12
	eorz	r0
	stra,r0	X18F2
	stra,r0	X18F3
	loda,r0	X18E8
	iori,r0	$04
	stra,r0	X18E8
	bsta,un	L061B
	lodi,r2	$02
	bsta,un	L07BF
	bcta,un	L03A4
;
L0371:
	lodi,r0	$20
	andz	r3
	bcta,eq	L039E
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$5C
	stra,r0	X1A12
	eorz	r0
	stra,r0	X18F5
	stra,r0	X18F4
	loda,r0	X18E8
	iori,r0	$08
	stra,r0	X18E8
	bsta,un	L061B
	lodi,r2	$02
	bsta,un	L07BF
	bcta,un	L03A4
;
L039E:
	lodi,r0	$03
	andz	r3
	bcfa,eq	L0A91
L03A4:
	loda,r0	X18E8
	andi,r0	$10
	bcta,eq	L03F8
	loda,r3	X18EA
	loda,r2	X18F7
	loda,r1	X18F6
	bsta,un	L068D
	comi,r3	$FF
	bctr,eq	L03EA
	comi,r3	$3C
	bctr,lt	L03D7
	comi,r3	$3F
	bctr,eq	L03D7
	loda,r0	X1A00
	andi,r0	$01
	bctr,eq	L03D7
	loda,r3	X18EB
	eorz	r0
	stra,r0	X1800,r3
	lodi,r2	$01
	bsta,un	L07BF
L03D7:
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$64
	stra,r0	X1A12
	bsta,un	L061B
	bcta,un	L0438
;
L03EA:
	stra,r2	X18F7
	stra,r1	X18F6
	comi,r2	$2F
	bsta,lt	L061B
	bcta,un	L0438
;
L03F8:
	eorz	r0
	strz	r3
L03FA:
	loda,r0	X1900,r3
	andi,r0	$0F
	bcfr,eq	L0409
	addi,r3	$01
	comi,r3	$04
	bcfr,eq	L03FA
	bctr,un	L0438
;
L0409:
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$6A
	stra,r0	X1A12
	loda,r0	X18E9
	stra,r0	X18EA
	loda,r0	X18F1
	stra,r0	X18F7
	loda,r0	X18F0
	stra,r0	X18F6
	loda,r0	X18E8
	iori,r0	$10
	stra,r0	X18E8
	loda,r0	X1A06
	addi,r0	$01
	stra,r0	X1A06
L0438:
	loda,r1	X18E8
	andi,r1	$FC
	loda,r0	X18E6
	subi,r0	$01
	stra,r0	X18E6
	bcfr,eq	L044F
	iori,r1	$01
	loda,r0	X18DF
	stra,r0	X18E6
L044F:
	loda,r0	X18E7
	subi,r0	$01
	stra,r0	X18E7
	bcfr,eq	L0461
	iori,r1	$02
	loda,r0	X18E0
	stra,r0	X18E7
L0461:
	stra,r1	X18E8
	loda,r0	X18E8
	andi,r0	$01
	bctr,eq	L0491
	loda,r3	X18D7
	loda,r2	X18F1
	loda,r1	X18F0
	bsta,un	L068D
	comi,r3	$3F
	bcta,eq	L0992
	comi,r3	$3C
	bcta,eq	L0A91
	comi,r3	$3D
	bcta,eq	L0A91
	stra,r2	X18F1
	comi,r2	$2F
	bcta,lt	L09D6
	stra,r1	X18F0
L0491:
	loda,r0	X18E8
	andi,r0	$02
	bcta,eq	L0547
	loda,r0	X18E8
	andi,r0	$04
	bcfa,eq	L04F0
	bsta,un	L0802
	coma,r0	X1A09
	bctr,gt	L04B4
	andi,r0	$0F
	stra,r0	X18D9
	loda,r0	X18E1
	stra,r0	X18E4
L04B4:
	loda,r3	X18F3
	loda,r2	X18F2
	loda,r1	X18D9
	loda,r0	X18E4
	subi,r0	$01
	stra,r0	X18E4
	bctr,eq	L04CC
	bsta,un	L0666
	bctr,un	L04DB
;
L04CC:
	loda,r0	X18E1
	stra,r0	X18E4
	loda,r1	X18DD
	bsta,un	L062C
	stra,r1	X18DD
L04DB:
	stra,r0	X18D9
	loda,r3	X18D9
	loda,r2	X18F3
	loda,r1	X18F2
	bsta,un	L068D
	stra,r2	X18F3
	stra,r1	X18F2
L04F0:
	loda,r0	X18E8
	andi,r0	$08
	bcfa,eq	L0547
	bsta,un	L0802
	coma,r0	X1A09
	bctr,gt	L050B
	andi,r0	$0F
	stra,r0	X18DB
	loda,r0	X18E1
	stra,r0	X18E5
L050B:
	loda,r3	X18F5
	loda,r2	X18F4
	loda,r1	X18DB
	loda,r0	X18E5
	subi,r0	$01
	stra,r0	X18E5
	bctr,eq	L0523
	bsta,un	L0666
	bctr,un	L0532
;
L0523:
	loda,r0	X18E1
	stra,r0	X18E5
	loda,r1	X18DE
	bsta,un	L062C
	stra,r1	X18DE
L0532:
	stra,r0	X18DB
	loda,r3	X18DB
	loda,r2	X18F5
	loda,r1	X18F4
	bsta,un	L068D
	stra,r2	X18F5
	stra,r1	X18F4
L0547:
	loda,r0	X18E8
	andi,r0	$04
	bctr,eq	L0576
	loda,r0	X18ED
	bcfr,eq	L055B
	loda,r0	X1A03
	stra,r0	X18ED
	bctr,un	L0576
;
L055B:
	subi,r0	$01
	stra,r0	X18ED
	bcfr,eq	L0576
	loda,r0	X1A04
	stra,r0	X18F3
	loda,r0	X1A05
	stra,r0	X18F2
	loda,r0	X18E8
	andi,r0	$FB
	stra,r0	X18E8
L0576:
	loda,r0	X18E8
	andi,r0	$08
	bctr,eq	L05A5
	loda,r0	X18EE
	bcfr,eq	L058A
	loda,r0	X1A03
	stra,r0	X18EE
	bctr,un	L05A5
;
L058A:
	subi,r0	$01
	stra,r0	X18EE
	bcfr,eq	L05A5
	loda,r0	X1A04
	stra,r0	X18F5
	loda,r0	X1A05
	stra,r0	X18F4
	loda,r0	X18E8
	andi,r0	$F7
	stra,r0	X18E8
L05A5:
	bcta,un	L01E5
;
L05A8:
	loda,r0	X1A0F
	comi,r0	$F0
	bcta,eq	L0604
	comi,r0	$F1
	bcta,eq	L05CB
	comi,r0	$F2
	bcta,eq	L05BB
	retc,un
;
L05BB:
	lodi,r0	$60
	stra,r0	X18FD
	lodi,r0	$15
	stra,r0	X18FE
	lodi,r0	$FE
	stra,r0	X1A0F
	retc,un
;
L05CB:
	lodi,r0	$0F
	stra,r0	X18FE
	loda,r2	X1A13
	loda,r0	*X1A11,r2
	addi,r2	$01
	stra,r2	X1A13
	comi,r0	$FF
	bcta,eq	L05F4
	stra,r0	X18FD
	loda,r0	*X1A11,r2
	addi,r2	$01
	stra,r2	X1A13
	stra,r0	X1A10
	lodi,r0	$F0
	stra,r0	X1A0F
	retc,un
;
L05F4:
	eorz	r0
	stra,r0	X18FD
	stra,r0	X1A13
	loda,r0	*X1A11,r2
	stra,r0	X1A0F
	lodi,r0	$FF
	retc,un
;
L0604:
	loda,r0	X1A10
	bctr,eq	L0611
	subi,r0	$01
	bctr,eq	L0611
	stra,r0	X1A10
	retc,un
;
L0611:
	eorz	r0
	stra,r0	X18FD
	lodi,r0	$F1
	stra,r0	X1A0F
	retc,un
;
L061B:
	lodi,r0	$FF
	stra,r0	X18F7
	stra,r0	X18F6
	loda,r0	X18E8
	andi,r0	$EF
	stra,r0	X18E8
	retc,un
;
L062C:
	comi,r1	$00
	bctr,eq	L063C
	bsta,un	L064E
	bcfr,eq	L0648
	bsta,un	L065A
	bctr,eq	L0646
	bctr,un	L064B
;
L063C:
	bsta,un	L065A
	bcfr,eq	L064B
	bsta,un	L064E
	bcfr,eq	L0648
L0646:
	eorz	r0
	retc,un
;
L0648:
	lodi,r1	$00
	retc,un
;
L064B:
	lodi,r1	$FF
	retc,un
;
L064E:
	coma,r3	X18F1
	retc,eq
	bctr,gt	L0657
	lodi,r0	$02
	retc,un
;
L0657:
	lodi,r0	$08
	retc,un
;
L065A:
	coma,r2	X18F0
	retc,eq
	bctr,gt	L0663
	lodi,r0	$01
	retc,un
;
L0663:
	lodi,r0	$04
	retc,un
;
L0666:
	coma,r3	X18F1
	bcfr,eq	L066F
	lodi,r0	$05
	bctr,un	L067A
;
L066F:
	coma,r2	X18F0
	bcfr,eq	L0678
	lodi,r0	$0A
	bctr,un	L067A
;
L0678:
	lodi,r0	$0F
L067A:
	andz	r1
	retc,un
;
L067C:
	addi,r2	$08
	comi,r2	$20
	retc,lt
	eorz	r0
	strz	r2
	retc,un
;
L0684:
	tpsu	$80
	bcfr,eq	L0684
L0688:
	tpsu	$80
	bctr,eq	L0688
	retc,un
;
L068D:
	andi,r3	$0F
	retc,eq
	stra,r2	X18D1
	stra,r1	X18D2
	lodi,r0	$01
	andz	r3
	bctr,eq	L069F
	addi,r1	$02
	bctr,un	L06B3
;
L069F:
	bsta,un	L06F9
	bctr,eq	L06A8
	addi,r2	$01
	bctr,un	L06B3
;
L06A8:
	bsta,un	L06F9
	bctr,eq	L06B1
	subi,r1	$02
	bctr,un	L06B3
;
L06B1:
	subi,r2	$01
L06B3:
	bsta,un	L06C8
	comi,r3	$3D
	bctr,lt	L06C1
	loda,r2	X18D3
	loda,r1	X18D4
	retc,un
;
L06C1:
	loda,r2	X18D1
	loda,r1	X18D2
	retc,un
;
L06C8:
	stra,r2	X18D3
	stra,r1	X18D4
	eori,r1	$FF
	addi,r1	$08
	subi,r1	$19
	tpsl	$01
	bctr,lt	L06F6
	andi,r1	$F0
	addi,r2	$04
	subi,r2	$2B
	tpsl	$01
	bctr,lt	L06F6
	rrr,r2
	rrr,r2
	rrr,r2
	andi,r2	$1F
	lodz	r1
	addz	r2
	strz	r3
	stra,r3	X18EB
	loda,r0	X1800,r3
	bctr,eq	L06F6
	andi,r0	$3F
	strz	r3
	retc,un
;
L06F6:
	lodi,r3	$FF
	retc,un
;
L06F9:
	rrr,r3
	andi,r3	$7F
	lodi,r0	$01
	andz	r3
	retc,un
;
L0700:
	tpsu	$80
	bcfr,eq	L0700
	retc,un
;
L0705:
	tpsu	$80
	bctr,eq	L0705
	retc,un
;
L070A:
	lodi,r1	$00
	andi,r3	$0F
	retc,eq
L070F:
	lodi,r0	$01
	andz	r3
	bcfr,eq	L071B
	addi,r1	$20
	bsta,un	L06F9
	bctr,un	L070F
;
L071B:
	lodz	r1
	addz	r2
	strz	r1
	lodi,r3	$00
L0720:
	loda,r0	*X18D1,r1
	stra,r0	*X18D3,r3
	addi,r3	$01
	addi,r1	$01
	comi,r3	$08
	bcfr,eq	L0720
	retc,un
;
L072F:
	eorz	r0
	strz	r3
	lodi,r2	$10
L0733:
	loda,r0	*X18D1,r3
	comi,r0	$F0
	retc,eq
	comi,r0	$F1
	bcta,eq	L0751
	comi,r0	$F2
	bcta,eq	L0768
	comi,r0	$F3
	bcta,eq	L0774
	stra,r0	X1800,r2
	addi,r3	$01
	addi,r2	$01
	bctr,un	L0733
;
L0751:
	addi,r3	$01
	loda,r0	*X18D1,r3
	strz	r1
	addi,r3	$01
	loda,r0	*X18D1,r3
L075C:
	stra,r0	X1800,r2
	addi,r2	$01
	bdrr,r1	L075C
	addi,r3	$01
	bcta,un	L0733
;
L0768:
	addi,r3	$01
	loda,r0	*X18D1,r3
	addz	r2
	strz	r2
	addi,r3	$01
	bcta,un	L0733
;
L0774:
	lodi,r0	$18
	stra,r0	X18D3
	stra,r0	X18D5
	addi,r3	$01
	loda,r0	*X18D1,r3
	stra,r0	X18D4
	addi,r3	$01
	loda,r0	*X18D1,r3
	stra,r0	X18D6
	addi,r3	$01
	loda,r0	*X18D1,r3
	strz	r1
L0792:
	lodi,r2	$00
L0794:
	loda,r0	*X18D3,r2
	stra,r0	*X18D5,r2
	addi,r2	$01
	comi,r2	$10
	bcfr,eq	L0794
	loda,r0	X18D6
	addi,r0	$10
	stra,r0	X18D6
	bdrr,r1	L0792
	loda,r0	X18D6
	subi,r0	$00
	strz	r2
	addi,r3	$01
	bcta,un	L0733
;
L07B5:
	lodi,r0	$F1
	stra,r0	X1A0F
	eorz	r0
	stra,r0	X1A13
	retc,un
;
L07BF:
	lodi,r0	$D0
	stra,r0	X180B
	stra,r0	X180C
	loda,r0	X180A
	addz	r2
	iori,r0	$D0
	stra,r0	X180A
L07D0:
	lodi,r1	$05
L07D2:
	loda,r0	X1805,r1
	strz	r2
	andi,r2	$0F
	comi,r2	$09
	bcfr,gt	L07ED
	subi,r0	$0A
	iori,r0	$D0
	stra,r0	X1805,r1
	loda,r0	X1804,r1
	addi,r0	$01
	iori,r0	$D0
	stra,r0	X1804,r1
L07ED:
	bdrr,r1	L07D2
	lodi,r1	$00
L07F1:
	loda,r0	X1806,r1
	andi,r0	$0F
	bcfr,eq	L0801
	stra,r0	X1806,r1
	addi,r1	$01
	comi,r1	$05
	bcfr,eq	L07F1
L0801:
	retc,un
;
L0802:
	loda,r0	X1A06
	addi,r0	$01
	stra,r0	X1A06
	retc,un
;
L080B:
	lodi,r0	$0B
	stra,r0	X1A01
	lodi,r0	$18
	stra,r0	X1A02
L0815:
	eorz	r0
	stra,r0	X18D8
	stra,r0	X18DA
	stra,r0	X18DC
	stra,r0	X18D9
	stra,r0	X18DB
	stra,r0	X18E8
	strz	r3
	lodi,r2	$C0
L082B:
	stra,r0	X180F,r2
	bdrr,r2	L082B
	lodi,r0	$FF
	stra,r0	X18F6
	stra,r0	X18F7
	lodi,r0	$32
	stra,r0	X18EF
	bsta,un	L0705
	bsta,un	L0700
L0843:
	loda,r0	*X1A01,r3
	stra,r0	X19A0,r3
	stra,r0	X19A8,r3
	addi,r3	$01
	comi,r3	$08
	bcfr,eq	L0843
L0852:
	loda,r0	*X1A01,r3
	stra,r0	X19B0,r3
	addi,r3	$01
	comi,r3	$10
	bcfr,eq	L0852
	loda,r0	*X1A01,r3
	stra,r0	X18F3
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18F2
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18F5
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18F4
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X1A03
	stra,r0	X18ED
	stra,r0	X18EE
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18E2
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18E3
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18DF
	stra,r0	X18E6
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18E0
	stra,r0	X18E7
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18E1
	stra,r0	X18E4
	stra,r0	X18E5
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X1A00
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18D1
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X18D2
	addi,r3	$01
	loda,r0	*X1A01,r3
	loda,r2	X1A0E
	subz	r2
	stra,r0	X180E
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X180F
	bsta,un	L0705
	bsta,un	L0700
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X19FB
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X19FA
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X19F9
	stra,r0	X18D0
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X1A04
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X1A05
	bsta,un	L072F
	loda,r0	X1871
	stra,r0	X18D5
	eorz	r0
	stra,r0	X1871
	lodi,r0	$2B
	stra,r0	X18F1
	lodi,r0	$76
	stra,r0	X18F0
	lodi,r0	$00
	stra,r0	X1A07
	lodi,r0	$3A
	stra,r0	X1A08
	lodi,r2	$04
L093E:
	bsta,un	L0705
	bsta,un	L0700
	lodi,r3	$00
L0946:
	loda,r0	*X1A07,r3
	stra,r0	X1980,r3
	addi,r3	$01
	comi,r3	$08
	bcfr,eq	L0946
	loda,r0	X18F1
	addi,r0	$03
	stra,r0	X18F1
	lodi,r3	$06
	bsta,un	L0983
	loda,r0	X1A08
	addi,r0	$08
	stra,r0	X1A08
	bdrr,r2	L093E
	loda,r0	X18D5
	stra,r0	X1871
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$72
	addi,r0	$0C
	stra,r0	X1A12
	bcta,un	L01E5
;
L0981:
	lodi,r3	$0F
L0983:
	bsta,un	L0684
	bsta,un	L05A8
	bdrr,r3	L0983
	retc,un
;
L098C:
	bsta,un	L0684
	bdrr,r3	L098C
	retc,un
;
L0992:
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$72
	stra,r0	X1A12
	eorz	r0
	loda,r1	X18EB
	stra,r0	X1800,r1
	lodi,r0	$01
	loda,r1	X1809
	addz	r1
	andi,r0	$0F
	iori,r0	$D0
	stra,r0	X1809
	loda,r0	X1A00
	andi,r0	$02
	bctr,eq	L09C5
	loda,r0	X1A00
	andi,r0	$FD
	stra,r0	X1A00
	bcta,un	L01E5
;
L09C5:
	eorz	r0
	stra,r0	X1871
	lodi,r0	$3F
	stra,r0	X1A04
	lodi,r0	$76
	stra,r0	X1A05
	bcta,un	L01E5
;
L09D6:
	bsta,un	L061B
	lodi,r0	$00
	stra,r0	X18FD
	lodi,r0	$00
	stra,r0	X1A07
	lodi,r0	$7A
	stra,r0	X1A08
	lodi,r2	$04
L09EA:
	bsta,un	L0705
	bsta,un	L0700
	lodi,r3	$00
L09F2:
	loda,r0	*X1A07,r3
	stra,r0	X1980,r3
	addi,r3	$01
	comi,r3	$08
	bcfr,eq	L09F2
	loda,r0	X18F1
	subi,r0	$01
	stra,r0	X18F1
	lodi,r3	$04
	bsta,un	L098C
	loda,r0	X1A08
	addi,r0	$08
	stra,r0	X1A08
	bdrr,r2	L09EA
	loda,r0	X1A0A
	addi,r0	$01
	comi,r0	$05
	bcfr,eq	L0A2D
	eorz	r0
	loda,r1	X1A09
	subi,r1	$10
	comi,r1	$10
	bctr,gt	L0A2A
	lodi,r1	$10
L0A2A:
	stra,r1	X1A09
L0A2D:
	stra,r0	X1A0A
	loda,r0	X180F
	andi,r0	$0F
	loda,r1	X1809
	addz	r1
	andi,r0	$0F
	iori,r0	$D0
	stra,r0	X1809
	loda,r0	X180E
	andi,r0	$0F
	loda,r1	X1808
	addz	r1
	andi,r0	$0F
	iori,r0	$D0
	stra,r0	X1808
	bsta,un	L07D0
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$C3
	stra,r0	X1A12
L0A60:
	bsta,un	L0684
	bsta,un	L05A8
	comi,r0	$FF
	bcfr,eq	L0A60
	lodi,r3	$24
	loda,r0	*X1A01,r3
	strz	r2
	addi,r3	$01
	loda,r0	*X1A01,r3
	stra,r0	X1A02
	stra,r2	X1A01
	lodi,r2	$03
	bsta,un	L07BF
	loda,r0	X1800
	addi,r0	$01
	comi,r0	$9F
	bcfr,eq	L0A8B
	lodi,r0	$9A
L0A8B:
	stra,r0	X1800
	bcta,un	L0815
;
L0A91:
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$8C
	stra,r0	X1A12
	bsta,un	L061B
	lodi,r1	$08
L0AA3:
	bsta,un	L0705
	bsta,un	L0700
	eorz	r0
	stra,r0	X197F,r1
	bsta,un	L0981
	bdrr,r1	L0AA3
	eorz	r0
	stra,r0	X18E8
	loda,r0	X1802
	strz	r1
	andi,r1	$0F
	subi,r1	$01
	comi,r1	$FF
	bctr,eq	L0ACA
	subi,r0	$01
	stra,r0	X1802
	bcta,un	L0815
;
L0ACA:
	lodi,r3	$10
L0ACC:
	loda,r0	X0B07,r3
	stra,r0	X185F,r3
	bdrr,r3	L0ACC
	bsta,un	L0705
	bsta,un	L0700
	lodi,r0	$08
	stra,r0	X19F9
	bsta,un	L07B5
	lodi,r0	$0F
	stra,r0	X1A11
	lodi,r0	$A1
	stra,r0	X1A12
L0AEC:
	bsta,un	L0684
	bsta,un	L05A8
	comi,r0	$FF
	bcfr,eq	L0AEC
	loda,r0	X1A0C
	bcfa,eq	L0110
L0AFC:
	loda,r0	X1908
	andi,r0	$0F
	comi,r0	$01
	bcta,eq	L01B5
	bctr,un	L0AFC
;
	db	$00, $C3, $C3, $C3
	db	$E0, $DA, $E6, $DE
	db	$00, $E8, $EF, $DE
	db	$EB, $C3, $C3, $C3
	db	$08, $1C, $2A, $77
	db	$2A, $08, $08, $3E
	db	$10, $38, $6C, $DE
	db	$DE, $5C, $38, $10
	db	$83, $96, $63, $36
	db	$D0, $00, $1A, $03
	db	$02, $08, $00, $00
	db	$A2, $55, $50, $3E
	db	$1A, $00, $73, $76
	db	$0B, $3E, $10, $38
	db	$7C, $FE, $FE, $54
	db	$10, $38, $30, $10
	db	$A6, $FF, $DF, $DF
	db	$6E, $3C, $6B, $B6
	db	$73, $36, $D0, $0B
	db	$64, $03, $02, $08
	db	$00, $0B, $E4, $55
	db	$50, $3C, $32, $08
	db	$83, $76, $0E, $95
	db	$3C, $98, $5A, $BD
	db	$76, $A5, $5A, $01
	db	$24, $98, $5B, $B4
	db	$76, $35, $DA, $19
	db	$18, $99, $5A, $24
	db	$EF, $3C, $DA, $09
	db	$3C, $99, $5A, $2D
	db	$6E, $BC, $5C, $81
	db	$2A, $54, $39, $5F
	db	$4F, $39, $54, $A8
	db	$4A, $54, $39, $FE
	db	$C6, $39, $54, $A4
	db	$52, $54, $38, $67
	db	$F7, $38, $54, $92
	db	$A2, $54, $39, $67
	db	$7F, $39, $54, $8A
	db	$81, $5A, $3D, $76
	db	$B4, $5A, $99, $3C
	db	$90, $5B, $3C, $F7
	db	$24, $5A, $99, $18
	db	$98, $5B, $AC, $6E
	db	$2D, $DA, $19, $24
	db	$80, $5A, $A5, $6E
	db	$BD, $5A, $19, $3C
	db	$15, $2A, $9C, $F2
	db	$FA, $9C, $2A, $54
	db	$25, $2A, $9C, $F2
	db	$7F, $9C, $2A, $52
	db	$49, $2A, $7C, $EF
	db	$E6, $1C, $2A, $4A
	db	$51, $2A, $9C, $FE
	db	$E6, $9C, $2A, $45
	db	$F2, $10, $F2, $04
	db	$01, $F1, $0A, $04
	db	$08, $F2, $03, $01
	db	$F2, $03, $7C, $F2
	db	$06, $7C, $05, $F2
	db	$02, $01, $F2, $0C
	db	$05, $00, $01, $F2
	db	$08, $7C, $F2, $04
	db	$05, $00, $07, $F2
	db	$03, $7C, $F2, $06
	db	$03, $FE, $FE, $05
	db	$00, $07, $F2, $0A
	db	$03, $7F, $FE, $05
	db	$F3, $60, $80, $01
	db	$00, $02, $F2, $08
	db	$7C, $F2, $04, $05
	db	$00, $00, $02, $F2
	db	$0C, $05, $F2, $03
	db	$02, $F2, $03, $7C
	db	$F2, $06, $7C, $05
	db	$F2, $04, $02, $F1
	db	$0A, $06, $0B, $F0
	db	$00, $10, $38, $7C
	db	$FE, $7C, $38, $10
	db	$06, $0C, $18, $64
	db	$B6, $6B, $0F, $06
	db	$83, $96, $7B, $36
	db	$C0, $0C, $62, $03
	db	$02, $08, $03, $0C
	db	$E2, $55, $50, $39
	db	$1A, $00, $8B, $76
	db	$0D, $69, $28, $92
	db	$54, $38, $54, $92
	db	$10, $00, $20, $92
	db	$FE, $38, $D6, $90
	db	$08, $04, $08, $10
	db	$D6, $38, $D6, $12
	db	$20, $40, $28, $92
	db	$FE, $38, $D6, $10
	db	$10, $10, $22, $14
	db	$09, $7E, $09, $14
	db	$22, $00, $36, $14
	db	$0D, $3E, $4C, $94
	db	$16, $00, $14, $94
	db	$48, $3E, $09, $14
	db	$34, $00, $16, $14
	db	$0D, $FE, $0D, $14
	db	$16, $00, $08, $08
	db	$08, $6B, $1C, $7F
	db	$49, $14, $02, $04
	db	$48, $6B, $1C, $6B
	db	$08, $10, $20, $10
	db	$09, $6B, $1C, $7F
	db	$49, $04, $00, $08
	db	$49, $2A, $1C, $2A
	db	$49, $14, $00, $44
	db	$28, $90, $7E, $90
	db	$28, $44, $00, $68
	db	$29, $32, $7C, $B0
	db	$28, $6C, $00, $2C
	db	$28, $90, $7C, $12
	db	$29, $28, $00, $68
	db	$28, $B0, $7F, $B0
	db	$28, $68, $F2, $10
	db	$00, $49, $F1, $04
	db	$44, $47, $00, $45
	db	$F1, $06, $44, $48
	db	$00, $47, $F2, $04
	db	$47, $00, $45, $F2
	db	$03, $BD, $43, $BF
	db	$45, $00, $47, $FD
	db	$F2, $03, $44, $43
	db	$44, $00, $BD, $00
	db	$00, $FD, $FD, $45
	db	$00, $47, $00, $00
	db	$BD, $00, $00, $FD
	db	$F2, $05, $FD, $00
	db	$45, $00, $47, $F2
	db	$04, $BD, $00, $00
	db	$FD, $F2, $04, $BD
	db	$45, $00, $47, $00
	db	$00, $FD, $00, $00
	db	$43, $F2, $07, $45
	db	$00, $47, $00, $BD
	db	$00, $00, $FD, $F2
	db	$03, $BD, $F2, $03
	db	$FD, $45, $F3, $50
	db	$90, $01, $00, $47
	db	$FD, $F2, $03, $46
	db	$43, $46, $F2, $03
	db	$00, $FD, $BD, $45
	db	$00, $47, $F2, $04
	db	$47, $00, $45, $F2
	db	$04, $43, $FF, $45
	db	$00, $4A, $F1, $04
	db	$46, $47, $00, $45
	db	$F1, $06, $46, $4B
	db	$F0, $3C, $6E, $DF
	db	$BF, $BF, $5F, $7F
	db	$3E, $62, $34, $08
	db	$7E, $CF, $DF, $7E
	db	$3C, $3B, $B6, $5B
	db	$36, $C0, $0D, $8F
	db	$03, $02, $08, $03
	db	$0E, $0F, $55, $50
	db	$3A, $32, $08, $8B
	db	$56, $0B, $18, $24
	db	$99, $DB, $FF, $99
	db	$99, $18, $3C, $00
	db	$99, $DB, $FF, $18
	db	$24, $42, $C3, $00
	db	$3C, $18, $FF, $FF
	db	$DB, $99, $24, $24
	db	$99, $DB, $FF, $DB
	db	$99, $24, $66, $3E
	db	$0C, $89, $FE, $FE
	db	$89, $0C, $3E, $8E
	db	$CC, $28, $1E, $1E
	db	$28, $CC, $8E, $78
	db	$38, $9A, $7E, $7E
	db	$9A, $38, $78, $3E
	db	$9C, $C9, $3E, $3E
	db	$C9, $9C, $3E, $66
	db	$24, $99, $DB, $FF
	db	$DB, $99, $24, $24
	db	$99, $DB, $FF, $FF
	db	$18, $3C, $00, $C3
	db	$42, $24, $18, $FF
	db	$DB, $99, $00, $3C
	db	$18, $99, $99, $FF
	db	$DB, $99, $24, $7D
	db	$30, $91, $7F, $7F
	db	$91, $30, $7D, $71
	db	$33, $14, $38, $38
	db	$14, $33, $71, $1E
	db	$1C, $59, $7E, $7E
	db	$59, $1C, $1E, $7D
	db	$39, $93, $7C, $7D
	db	$93, $39, $7D, $F2
	db	$10, $00, $09, $F1
	db	$06, $04, $03, $F1
	db	$06, $04, $08, $00
	db	$07, $F2, $04, $BD
	db	$00, $7F, $00, $BD
	db	$F2, $04, $05, $00
	db	$07, $F2, $03, $7D
	db	$00, $00, $BD, $00
	db	$00, $7D, $F2, $03
	db	$05, $00, $07, $00
	db	$00, $BD, $00, $BD
	db	$00, $03, $00, $BD
	db	$00, $BD, $00, $00
	db	$05, $00, $07, $00
	db	$00, $7D, $03, $00
	db	$7D, $00, $7D, $00
	db	$03, $7D, $00, $00
	db	$05, $00, $07, $F2
	db	$03, $BD, $00, $00
	db	$03, $00, $00, $BD
	db	$F2, $03, $05, $00
	db	$07, $F2, $04, $7D
	db	$00, $03, $00, $7D
	db	$F2, $04, $05, $00
	db	$07, $F2, $05, $BD
	db	$03, $BD, $F2, $05
	db	$05, $00, $07, $F2
	db	$06, $03, $F2, $06
	db	$05, $00, $07, $F2
	db	$06, $03, $F2, $05
	db	$7F, $05, $00, $0A
	db	$F1, $06, $06, $03
	db	$F1, $06, $06, $0B
	db	$F0, $44, $EE, $FE
	db	$FE, $FE, $7C, $38
	db	$10, $0C, $08, $7E
	db	$DB, $F5, $5A, $2C
	db	$18, $73, $B6, $83
	db	$76, $D0, $0D, $8F
	db	$03, $02, $08, $01
	db	$0E, $BB, $55, $50
	db	$3B, $0A, $00, $83
	db	$76, $0C, $3C, $F2
	db	$10, $F2, $08, $F1
	db	$08, $C3, $F2, $04
	db	$F1, $05, $C3, $F2
	db	$06, $C5, $00, $F1
	db	$04, $C3, $F2, $03
	db	$BD, $F2, $04, $BD
	db	$00, $C5, $00, $C7
	db	$F2, $03, $BD, $F2
	db	$04, $BD, $F2, $04
	db	$C5, $00, $C7, $F2
	db	$05, $BD, $F2, $04
	db	$BD, $00, $BD, $C5
	db	$00, $C7, $F2, $04
	db	$C3, $F2, $05, $C3
	db	$7F, $00, $C5, $F3
	db	$60, $80, $01, $F3
	db	$50, $90, $01, $F3
	db	$40, $A0, $01, $F3
	db	$30, $B0, $01, $F3
	db	$20, $C0, $01, $F0
	db	$27, $0E, $1D, $0E
	db	$1D, $0E, $19, $07
	db	$17, $07, $15, $0E
	db	$15, $0E, $13, $07
	db	$15, $07, $17, $07
	db	$19, $07, $17, $0E
	db	$17, $12, $00, $04
	db	$13, $07, $15, $07
	db	$17, $07, $19, $07
	db	$17, $0E, $17, $0E
	db	$13, $07, $15, $07
	db	$17, $07, $19, $07
	db	$1D, $0E, $1D, $0E
	db	$15, $07, $17, $07
	db	$19, $07, $17, $07
	db	$15, $07, $13, $07
	db	$15, $07, $19, $07
	db	$11, $0E, $0F, $0E
	db	$0E, $14, $FF, $10
	db	$04, $08, $05, $FF
	db	$20, $07, $06, $03
	db	$04, $09, $FF, $F2
	db	$06, $03, $09, $03
	db	$FF, $F2, $3B, $02
	db	$1D, $02, $07, $02
	db	$FF, $F2, $0E, $02
	db	$0D, $02, $0C, $02
	db	$0B, $02, $0A, $02
	db	$09, $02, $08, $02
	db	$07, $02, $06, $02
	db	$05, $02, $04, $02
	db	$03, $02, $FF, $F2
	db	$1D, $24, $27, $0C
	db	$00, $01, $27, $0C
	db	$2E, $14, $00, $01
	db	$2E, $0C, $00, $01
	db	$2E, $0C, $3B, $26
	db	$FF, $3B, $26, $17
	db	$09, $13, $09, $13
	db	$09, $13, $09, $15
	db	$09, $11, $09, $11
	db	$09, $11, $09, $0F
	db	$09, $0F, $09, $11
	db	$09, $0F, $09, $0E
	db	$09, $0D, $09, $0E
	db	$0A, $FF, $F2, $13
	db	$14, $17, $0A, $15
	db	$0A, $13, $0A, $0E
	db	$1E, $00, $01, $0F
	db	$06, $0E, $06, $0D
	db	$0A, $0E, $0A, $0F
	db	$0A, $11, $0A, $13
	db	$0F, $00, $0F, $0F
	db	$06, $0E, $06, $0D
	db	$0A, $0E, $0A, $0F
	db	$0A, $11, $0A, $13
	db	$0A, $11, $0A, $13
	db	$0A, $15, $0A, $17
	db	$14, $19, $14, $1D
	db	$1F, $FF, $F2, $00
	db	$00, $00, $00, $00
