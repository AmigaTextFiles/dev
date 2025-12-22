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






void draw_spans8wire(register int y __asm__("a4"), register int ey __asm__("d5"));

	__asm ("

	.equ	y,a4
	.equ	dest,a3
	.equ	mults,a2
	.equ	scan,a1
	.equ	buf,a0		| parameter ...
	
	.equ	ey,d5
	.equ	len,d1
	.equ	sx,d0

.text
	.globl	_draw_spans8wire
| void draw_spans8wire(register int y __asm__ (a4), register int ey __asm__ (d5))
_draw_spans8wire:
	subl	y,ey			| y < ey
	subql	#1,ey			| (y - 1) <= ey
	blt	.bigEnd8wire

	moveml	a2-a3,sp@-
	movel	_localDim+26,dest	| localDim.frameBuffer

	lea	@(_scan, y:l:8), scan	| scan[y][]
	movel	_multRows,mults
	lea	mults@(y:l:4),mults
.bigLoop8wire:
	movel	mults@+,buf		| multRows[y]
	movel	scan@+,sx		| FIX_INT(scan[y][0])
	movel	scan@+,len		| FIX_INT(scan[y][1])
	subl	sx,len			| scan[y][1] - sx
	bles	.noSpan8wire		| len > 0
	addl	dest,buf		| localDim.frameBuffer + multRows[y]
	moveb	#0x15,buf@(sx)
	moveb	#0x15,buf@(len)
.noSpan8wire:
	dbra	ey,.bigLoop8wire
	moveml	sp@+,a2-a3
.bigEnd8wire:
	rts
	.even
	");
