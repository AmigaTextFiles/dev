/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */






void draw_spans8(register int y __asm__("a4"), register int ey __asm__("d5"));

	__asm ("

	.equ	len,a6
	.equ	dest,a5
	.equ	y,a4
	.equ	storev,a3
	.equ	storeu,a2
	.equ	buf,a0		| parameter ...
	
	.equ	prew,fp7
	.equ	prev,fp6
	.equ	preu,fp5
	.equ	w0,fp4
	.equ	v0,fp3
	.equ	u0,fp2
	
	.equ	slen,d7
	.equ	sx,d6
	.equ	ey,d5

	.equ	count,d4	| parameter ...
	.equ	dv,d3		|
	.equ	du,d2		|
	.equ	v,d1		|
	.equ	u,d0		|

.text
	.globl	_draw_spans8
| void draw_spans8(register int y __asm__ (a4), register int ey __asm__ (d5))
_draw_spans8:
	moveml	d2-d4/d6-d7/a2-a3/a5-a6,sp@-
	fmovem	fp2-fp7,sp@-

	movel	_localDim+26,dest	| localDim.frameBuffer

	movel	y,d0
	fmovel	d0,preu

	fmoves	_tmap+32,prew		| tmap[8]
	fsglmulx preu,prew		| y * tmap[8]
	fadds	_tmap+24,prew		| tmap[6] + y * tmap[8]

	fmoves	_tmap+20,prev
	fsglmulx preu,prev
	fadds	_tmap+12,prev

	fsglmuls _tmap+8,preu
	fadds	_tmap+0,preu
	
	subl	y,ey			| y < ey
	subql	#1,ey			| (y - 1) <= ey
	blt	.bigEnd8
.bigLoop8:
	lea	@(_scan, y:l:8), a0	| scan[y][]
	movel	a0@+,sx			| FIX_INT(scan[y][0])
	|addl	#65535,sx
	|swap	sx
	movel	a0@,d0			| FIX_INT(scan[y][1])
	|addl	#65535,d0
	|swap	d0
	subw	sx,d0			| scan[y][1] - sx
	ble	.noSpan8		| len > 0
	movew	d0,len
	
	movel	_multRows,buf
	movel	buf@(y:l:4),buf		| multRows[y]
	addl	dest,buf		| localDim.frameBuffer + multRows[y]
	addw	sx,buf			| localDim.frameBuffer + multRows[y] + sx
	
	fmovew	sx,u0
	fmoves	#0r65536.0,w0		| 1.0
	fmoves	_tmap+28,fp0		| tmap[7]
	fsglmulx u0,fp0			| sx * tmap[7]
	faddx	prew,fp0		| prew + sx * tmap[7]
	fsgldivx fp0,w0			| 1 / (prew + sx * tmap[7])

	fmoves	_tmap+16,v0		| tmap[4]
	fsglmulx u0,v0			| sx * tmap[4]

	fsglmuls _tmap+4,u0

	faddx	prev,v0			| prev + sx * tmap[4]
	faddx	preu,u0

	fsglmulx w0,v0			| (prev + sx * tmap[4]) * w0
	fsglmulx w0,u0
	
	fmovel	v0,v
	fmovel	u0,u
	
	movew	len,slen
	lsrw	#4,slen
	subqw	#1,slen			| dbge if not blts ???
	blt	.noSub8
.sub8:	addw	#16,sx

	fmovew	sx,u0
	fmoves	#0r65536.0,w0
	fmoves	_tmap+28,fp0
	fsglmulx u0,fp0
	faddx	prew,fp0
	fsgldivx fp0,w0

	fmoves	_tmap+16,v0
	fsglmulx u0,v0

	fsglmuls _tmap+4,u0

	faddx	prev,v0
	faddx	preu,u0

	fsglmulx w0,v0
	fsglmulx w0,u0
	
	fmovel	v0,dv
	fmovel	u0,du

	movel	dv,storev
	movel	du,storeu

	subl	v,dv
	asrl	#4,dv
	subl	u,du
	asrl	#4,du
	
	|moveq	#16,count
	moveq	#15,count
	bsr	_draw_affine8

	movel	storev,v
	movel	storeu,u
	
	dbra	slen,.sub8
.noSub8:
	|moveq	#0,count	| sometimes something in upper word
	movew	len,count
	andw	#0x000F,count
	subqw	#1,count
	blts	.noSpan8	| nothing to do
	beqs	.noRest8	| avoid division by 0
	addw	count,sx	| count is near 15 and sx smaller than 32767

	fmovew	sx,fp1
	fmoves	#0r65536.0,w0	| v0 and u0 are scaled by 65536.0 on entry
	fmoves	_tmap+28,fp0
	fsglmulx fp1,fp0
	faddx	prew,fp0
	fsgldivx fp0,w0

	fmoves	_tmap+16,fp0	| tmap[4]
	fsglmulx fp1,fp0	| sx * tmap[4]

	fsglmuls _tmap+4,fp1

	faddx	prev,fp0	| prev + sx * tmap[4]
	faddx	preu,fp1

	fsglmulx w0,fp0		| (prev + sx * tmap[4]) * w1
	fsglmulx w0,fp1

	fsubx	v0,fp0		| v1 - v0
	fsubx	u0,fp1

	fsgldivw count,fp0
	fsgldivw count,fp1

	fmovel	fp0,dv
	fmovel	fp1,du
	
.noRest8:
	|addqw	#1,count
	bsrs	_draw_affine8
.noSpan8:
	fadds	_tmap+32,prew
	fadds	_tmap+20,prev
	fadds	_tmap+8,preu
	addql	#1,y		| y++
	dbra	ey,.bigLoop8
.bigEnd8:
	fmovem	sp@+,fp2-fp7
	moveml	sp@+,d2-d4/d6-d7/a2-a3/a5-a6
	rts
	.even

_draw_affine8:
	movew	_textureType,a1
	cmpw	#1,a1
	bnes	.noWall8
	moveml	d5-d7,sp@-
	movel	_texture,a1
	movel	#0x0000FF00,d7			| from tables.h		,MAX_MASKX
	asrl	#8,v				| inaccurate but fast	,16-MAX_LOGX
	asrl	#8,dv				| inaccurate but fast	,16-MAX_LOGX
.wall8:
	movel	u,d6
	movel	v,d5
	clrw	d6
	swap	d6
	andl	d7,d5				| nessecary? -> yep
	moveb	_textureRow+3,d5
	addl	@(_multTMap, d5:l:4),d6
	moveb	a1@(d6:l:1),buf@+
	addl	du,u
	addl	dv,v	
	dbra	count,.wall8
	moveml	sp@+,d5-d7
	rts
.noWall8:
	cmpw	#5,a1
	bnes	.noSky8
	moveml	d5-d7,sp@-
	movel	_texture,a1
	movew	#0x7F7F,d7
	asrl	#8,u				| inaccurate but fast
	asrl	#8,du				| inaccurate but fast
.sky8:
	movel	u,d6
	movel	v,d5
	swap	d5
	moveb	d5,d6
	movew	d6,d5
	addw	_skyMovementX1+2,d6
	addw	_skyMovementX2+2,d5
	addb	_skyMovementY1+3,d6
	addb	_skyMovementY2+3,d5
	andw	d7,d6
	andw	d7,d5
	moveb	a1@(0x80, d6:w:1),d6
	moveb	a1@(d5:w:1),d5
	beqs	.skipSky8
	moveb	d5,d6
.skipSky8:
	moveb	d6,buf@+
	addl	du,u
	addl	dv,v	
	dbra	count,.sky8
	moveml	sp@+,d5-d7
	rts
.noSky8:
	moveml	a2/d5-d7,sp@-
	movel	_texture,a1
	movel	_preTransparency,a2
	moveq	#0,d7			| nessecary ? (asr is faster then)
.liquid8:
	movew	_textureShift2,d7
	movel	u,d6			| bfextu	u{d7:8},d6
	movel	v,d5			| bfextu	v{d7:8},d5
	asrl	d7,d6			| ...
	asrl	d7,d5			| ...
	andw	#0x00FF,d6		| ...
	andw	#0x00FF,d5		| ...
	movel	@(_swim_v, d6:w:4),d6
	movel	@(_swim_u, d5:w:4),d5
	movew	_textureMip,d7
	asrl	d7,d6
	asrl	d7,d5
	addl	v,d6
	addl	u,d5
	movew	_textureShift1,d7
	swap	d6
	asrl	d7,d5
	andl	_textureMask2,d6
	andl	_textureMask1,d5
	orl	d6,d5
	|moveq	#0,d6			| d6 is not greater than 64*64, so the upper bits are 0
	movew	buf@,d6
	moveb	a1@(d5:w:1),d6
	moveb	a2@(d6:l:1),buf@+
	addl	du,u
	addl	dv,v	
	dbra	count,.liquid8
	moveml	sp@+,a2/d5-d7
	rts
	");
