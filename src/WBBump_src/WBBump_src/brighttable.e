/* ************* */
/* brigthtable.e */
/* ************* */



/*
    WBBump - Bumpmapping on the Workbench!

    Copyright (C) 1999  Thomas Jensen - dm98411@edb.tietgen.dk

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/




OPT MODULE



EXPORT PROC get_brighttable()
	DEF	i,
		ix, iy, temp,
		scale,
		btab=NIL

	scale := 2.5

	btab := NewR(256*256)

	i := 0
	FOR iy := 0 TO 255
		FOR ix := 0 TO 255
			temp := dist_fp(0, 0, ix, iy, scale)
			btab[i] := (IF temp<256 THEN temp ELSE 255)
			i++
		ENDFOR
	ENDFOR
ENDPROC btab


PROC dist_fp(x1, y1, x2, y2, scale /* float */)
	DEF	dx, dy, d

	dx := x1 - x2
	dy := y1 - y2

	d := !Fsqrt((dx*dx!*scale!) + (dy*dy!*scale!)!)!

ENDPROC IF (d>255) THEN 255 ELSE d

