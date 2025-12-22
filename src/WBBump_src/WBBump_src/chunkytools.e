/* ************* */
/* chunkytools.e */
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


MODULE	'graphics/gfx',
		'graphics/rastport',

		'exec/memory'




EXPORT PROC alloc_temprp(rp, width)
	DEF	temprp=NIL:PTR TO rastport,
		i


	NEW temprp

	CopyMem(rp, temprp, SIZEOF rastport)

	temprp.layer := NIL

	temprp.bitmap := NewR(SIZEOF bitmap)

	temprp.bitmap.bytesperrow := Shl(Shr(width + 15, 4), 1)
	temprp.bitmap.rows := 1
	temprp.bitmap.flags := BMF_STANDARD
	temprp.bitmap.depth := 8
	FOR i := 0 TO 7
		/* Under what circumstances can planes be allocated in FAST ??? */
		temprp.bitmap.planes[i] := NewM(temprp.bitmap.bytesperrow, MEMF_CHIP)
	ENDFOR
	
ENDPROC temprp


EXPORT PROC free_temprp(temprp:PTR TO rastport)
	DEF	i

	IF temprp
		IF temprp.bitmap
			FOR i := 0 TO 7
				IF temprp.bitmap.planes[i] THEN Dispose(temprp.bitmap.planes[i])
			ENDFOR
			Dispose(temprp.bitmap)
		ENDIF
		END temprp
	ENDIF
ENDPROC




EXPORT PROC bitmap2chunky(bm:PTR TO bitmap, buf, x, y, w, h) HANDLE
	DEF	rp=NIL:PTR TO rastport,
		temprp

	NEW rp
	InitRastPort(rp)
	rp.bitmap := bm

	temprp := alloc_temprp(rp, w)

	rastport2chunky(rp, buf, x, y, w, h, temprp)

EXCEPT DO
	IF temprp THEN free_temprp(temprp)
	END rp
ENDPROC



EXPORT PROC rastport2chunky(rp:PTR TO rastport, buf, x, y, w, h, temprp) HANDLE
	DEF	tempbuf=NIL:PTR TO CHAR,
		lineadr=0,
		iy

	
	tempbuf := NewR(w + 16)


	lineadr := 0
	FOR iy := 0 TO h-1
		ReadPixelLine8(rp, x, y+iy, w, tempbuf, temprp)
		CopyMem(tempbuf, buf + lineadr, w)
		lineadr := lineadr + w
	ENDFOR


EXCEPT DO
	IF tempbuf THEN Dispose(tempbuf)
	ReThrow()
ENDPROC




EXPORT PROC chunky2bitmap(bm:PTR TO bitmap, buf, x, y, w, h) HANDLE
	DEF	rp=NIL:PTR TO rastport,
		temprp=NIL

	NEW rp
	InitRastPort(rp)
	rp.bitmap := bm

	temprp := alloc_temprp(rp, w)

	IF chunky2rastport(rp, buf, x, y, w, h, temprp) = FALSE THEN Raise(-1)

EXCEPT DO
	IF temprp THEN free_temprp(temprp)
	END rp
	IF exception THEN RETURN FALSE
ENDPROC TRUE





EXPORT PROC chunky2rastport(rp:PTR TO rastport, buf, x, y, w, h, temprp) HANDLE
	DEF	lineadr=0,
		iy


	lineadr := 0
	FOR iy := 0 TO h-1
		WritePixelLine8(rp, x, y+iy, w, buf + lineadr, temprp)
		lineadr := lineadr + w
	ENDFOR


EXCEPT DO
	IF exception THEN RETURN FALSE
ENDPROC TRUE




