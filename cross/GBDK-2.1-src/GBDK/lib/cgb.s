	.include "global.s"

	.title	"CGB support"
	.module	CGB

	.area	_CODE

_set_bkg_palette::
	PUSH	BC
	PUSH	DE

	LDA	HL,9(SP)	; Skip return address and registers
	LD	B,(HL)		; BC = rgb_data
	DEC	HL
	LD	C,(HL)
	DEC	HL
	LD	D,(HL)		; D = nb_palettes
	DEC	HL
	LD	E,(HL)		; E = first_palette

	LD	A,D		; A = nb_palettes
	ADD	E
	ADD	A		; A *= 8
	ADD	A
	ADD	A
	LD	D,A

        LD      A,E		; E = first_palette
	ADD	A,A		; A *= 8
	ADD	A,A
	ADD	A,A
	LD	E,A		; A = first BCPS data
2$:
	LDH	A,(.STAT)
	AND	#0x02
	JR	NZ,2$

	LD	A,E
	LDH	(.BCPS),A
	LD	A,(BC)
	LDH	(.BCPD),A
	INC	BC		; next rgb_data
	INC	E		; next BCPS
	LD	A,E
	CP	A,D
	JR	NZ,2$

	POP	DE
	POP	BC
	RET

_set_sprite_palette::
	PUSH	BC
	PUSH	DE

	LDA	HL,9(SP)	; Skip return address and registers
	LD	B,(HL)		; BC = rgb_data
	DEC	HL
	LD	C,(HL)
	DEC	HL
	LD	D,(HL)		; D = nb_palettes
	DEC	HL
	LD	E,(HL)		; E = first_palette

	LD	A,D		; A = nb_palettes
	ADD	E
	ADD	A		; A *= 8
	ADD	A
	ADD	A
	LD	D,A

        LD      A,E		; E = first_palette
	ADD	A,A		; A *= 8
	ADD	A,A
	ADD	A,A
	LD	E,A		; A = first BCPS data
2$:
	LDH	A,(.STAT)
	AND	#0x02
	JR	NZ,2$

	LD	A,E
	LDH	(.OCPS),A
	LD	A,(BC)
	LDH	(.OCPD),A
	INC	BC		; next rgb_data
	INC	E		; next BCPS
	LD	A,E
	CP	A,D
	JR	NZ,2$

	POP	DE
	POP	BC
	RET


_set_bkg_palette_entry::
	PUSH	BC
	PUSH	DE

	LDA	HL,9(SP)	; Skip return address and registers
	LD	B,(HL)		; BC = rgb_data
	DEC	HL
	LD	C,(HL)
	DEC	HL
	LD	D,(HL)		; D = pal_entry
	DEC	HL
	LD	E,(HL)		; E = first_palette

        LD      A,E		; E = first_palette
	ADD	A		; A *= 8
	ADD	A
	ADD	A
	ADD	D		; A += 2 * pal_entry
	ADD	D
	LD	E,A		; A = first BCPS data

2$:
	LDH	A,(.STAT)
	AND	#0x02
	JR	NZ,2$

	LD	A,E
	LDH	(.BCPS),A
	LD	A,C
	LDH	(.BCPD),A
	INC	E		; next BCPS

	LD	A,E
	LDH	(.BCPS),A
	LD	A,B
	LDH	(.BCPD),A

	POP	DE
	POP	BC
	RET

_set_sprite_palette_entry::
	PUSH	BC
	PUSH	DE

	LDA	HL,9(SP)	; Skip return address and registers
	LD	B,(HL)		; BC = rgb_data
	DEC	HL
	LD	C,(HL)
	DEC	HL
	LD	D,(HL)		; D = pal_entry
	DEC	HL
	LD	E,(HL)		; E = first_palette

        LD      A,E		; E = first_palette
	ADD	A		; A *= 8
	ADD	A
	ADD	A
	ADD	D		; A += 2 * pal_entry
	ADD	D
	LD	E,A		; A = first BCPS data

2$:
	LDH	A,(.STAT)
	AND	#0x02
	JR	NZ,2$

	LD	A,E
	LDH	(.OCPS),A
	LD	A,C
	LDH	(.OCPD),A
	INC	E		; next BCPS

	LD	A,E
	LDH	(.OCPS),A
	LD	A,B
	LDH	(.OCPD),A

	POP	DE
	POP	BC
	RET
