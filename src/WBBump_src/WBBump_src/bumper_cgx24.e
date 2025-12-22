/* ************** */
/* bumper_cgx24.e */
/* ************** */


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
OPT	PREPROCESS



MODULE	'intuition/intuition',
		'intuition/screens',
		'intuition/intuitionbase',

		'graphics/gfx',
		'graphics/rastport'


MODULE	'*bumper',
		'*prefs',
		'*hmap2true',
		'*brighttable',
		'*chunkyimage',
		'*errors',
		'*pluginmanager'



EXPORT OBJECT bumper_cgx24 OF bumper
PRIVATE
	outbuf	:	PTR TO cimg
	btab	:	PTR TO CHAR
ENDOBJECT




/* constructor */
PROC bumper_cgx24(p:PTR TO prefs, plist) OF bumper_cgx24 HANDLE

	/* call super constructor */

	self.bumper(p, plist)


	/* allocate the brightness table */
	/* really a distance table */

	self.btab := get_brighttable()



EXCEPT DO
	IF exception
		self.freeall()
	ENDIF
	ReThrow()
ENDPROC



/* disable "make_blut" */
PROC make_blut(s:PTR TO screen) OF bumper_cgx24 IS NIL



PROC make_backup(s:PTR TO screen, px, py) OF bumper_cgx24 HANDLE


	/* allocate backup bitmap */

	NEW self.backup.alloc(self.width, self.height, CIMGTYP_RGB)
	self.backup.read_full(s.rastport, px, py)

	/* the output buffer must also contain the original image */
	/* this is because the bumpmapper will write if there's a change */

	NEW self.outbuf.alloc(self.width, self.height, CIMGTYP_RGB)
	self.outbuf.read_full(s.rastport, px, py)

EXCEPT DO
	ReThrow()
ENDPROC


PROC freeall() OF bumper_cgx24
	END self.outbuf
	END self.backup
	self.backup := NIL
	self.outbuf := NIL
	SUPER self.freeall()
ENDPROC



PROC end() OF bumper_cgx24
	self.freeall()
	SUPER self.end()
ENDPROC





PROC update() OF bumper_cgx24 HANDLE
	DEF	inbuf=NIL, outbuf=NIL, bumpbuf=NIL,
		lightx, lighty



	/* is an update needed? */

	IF self.needUpdate() = FALSE
		Delay(1)
		Raise("skip")
	ENDIF



	/* position of light*/

	lightx, lighty := self.getLightSourcePos()



	/* lock bitmaps to do direct draw */

	IF self.backup.lock([CIMGTAG_LOCK_BUF, {inbuf}, NIL]) = FALSE THEN Raise(ERR_LOCKCIMG)
	IF self.outbuf.lock([CIMGTAG_LOCK_BUF, {outbuf}, NIL]) = FALSE THEN Raise(ERR_LOCKCIMG)

	bumpbuf := self.plugins.doUpdate()

	IF bumpbuf

		/* heightmap to truecolor conversion (hmap2true.asm) */

		hmap2true(self.btab, bumpbuf, inbuf, outbuf, 0, self.width, self.height, lightx, lighty)


		self.outbuf.write_full(self.win.rport, 0, 0, [CIMG_WRITE_ASYNC, TRUE, CIMG_WRITE_LPB, 10, NIL])

	ENDIF

EXCEPT DO
	self.backup.unlock()
	self.outbuf.unlock()

	/* free stuf */
	self.backup.unlock()
	self.outbuf.unlock()
	IF exception <> "skip" THEN ReThrow()
ENDPROC




