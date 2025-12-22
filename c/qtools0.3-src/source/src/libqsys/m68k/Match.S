|
| <one line to give the program s name and a brief idea of what it does.>
| Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
|
| This program is free software; you can redistribute it and/or modify
| it under the terms of the GNU General Public License as published by
| the Free Software Foundation; either version 2 of the License, or
| (at your option) any later version.
|
| This program is distributed in the hope that it will be useful,
| but WITHOUT ANY WARRANTY; without even the implied warranty of
| MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
| GNU General Public License for more details.
|
| You should have received a copy of the GNU General Public License
| along with this program; if not, write to the Free Software
| Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
|
	
	
	
	
	
	
	.equ	rawR,a3
	.equ	rawG,a2
	.equ	rawB,a0
	.equ	pal,a1
	.equ	rawpix,a0
	
	.equ	palpix,d4
	.equ	i,d3
	.equ	match,d2
	.equ	thismatch,d1

	.globl	_Match
_Match:	moveml	d2-d4/a2-a3,sp@-
	moveq	#0,d0	
	moveb	rawpix@+,d0
	movel	d0,rawR			| .l -> an faster than .w -> an
	moveb	rawpix@+,d0
	movel	d0,rawG
	moveb	rawpix@+,d0
	movel	d0,rawB
	
	movew	#0x7FFF,match		| match never greater then 765 and ever positive
	movew	#255,i

loopM:	moveq	#0,thismatch
	moveb	pal@+,thismatch
	subl	rawR,thismatch		| an -> .l faster than an -> .w
	bges	.skipR
	negl	thismatch
.skipR:	moveb	pal@+,d0
	subl	rawG,d0
	bges	.skipG
	negl	d0
.skipG:	addl	d0,thismatch
	moveb	pal@+,d0
	subl	rawB,d0
	bges	.skipB
	negl	d0
.skipB:	addl	d0,thismatch
	beqs	fastMatch
	cmpw	match,thismatch
	bges	noMatch
	movew	thismatch,match
	movew	i,palpix
noMatch:
	dbra	i,loopM
	movew	#255,d0
	subw	palpix,d0
	moveml	sp@+,d2-d4/a2-a3
	rts
fastMatch:
	movew	#255,d0
	subw	i,d0
	moveml	sp@+,d2-d4/a2-a3
	rts
