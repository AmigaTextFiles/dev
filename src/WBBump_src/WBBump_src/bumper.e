/* ******** */
/* bumper.e */
/* ******** */



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


MODULE	'intuition/intuition',		-> window
		'intuition/screens',		-> screen
		'intuition/intuitionbase',	-> intuitionbase

		'graphics/gfx',				-> bitmap
		'graphics/rastport',		-> screen.rastport.bitmap
		'graphics/view',			-> screen.viewport.colormap

		'exec/nodes',
		'exec/lists'


MODULE	'*prefs',
		'*chunkyimage',
		'*errors',
		'*plugin',
		'*pluginmanager'


/* "template" bumper def */
EXPORT OBJECT bumper
	win	    	:	PTR TO window
	width   	:	INT
	height  	:	INT
	backup   	:	PTR TO cimg		-> backup of hidden area of screen (allocated by bumper_xxx)
	blut    	:	PTR TO CHAR		-> brightness lookup table (may be null)
	cusage		:	PTR TO CHAR		-> color usage array [256], cusage[x] = 0 if color x is not used
									-> must be supplied by bumper_xxx.make_backup if .make_blut in
									-> this file is used
	levels  	:	INT				-> levels in above
    levels_bit  :   CHAR
	prefs		:	PTR TO prefs	-> pointer to prefs structure used to create this bumper
	plugins		:	PTR TO pluginlist	-> all the plugins in here
	oldlx		:	LONG
	oldly		:	LONG
ENDOBJECT



/* constructor */
PROC bumper(p:PTR TO prefs, plist:PTR TO pluginlist) OF bumper HANDLE
	DEF	s:PTR TO screen,
		tempstr[1024]:STRING,
		px, py


	/* init local prefs pointer */

	self.prefs := p



	/* init vars */
	self.win := NIL
	self.backup := NIL
	self.blut := NIL
	self.plugins := NIL

	self.levels := p.levels
	self.levels_bit := p.levels_bit


	/* set initial light position out of screen */

	self.oldlx := -1
	self.oldly := -1



	/* load the plugins */

	NEW self.plugins.pluginlist()


	/* load from tooltypes */
	IF p.tooltypes
		self.plugins.addInstancesTT(p.tooltypes, plist)
	ENDIF

	/* if no loaded yet, try with the file of the activated icon */
	IF self.plugins.isEmpty()
		self.plugins.addInstancesTT([StringF(tempstr, 'BUMPMAP=\s', p.fullprjname), 0], plist, FALSE)
	ENDIF

	/* still no? - try default bumpmap */
	IF self.plugins.isEmpty()
		self.plugins.addInstancesTT(['BUMPMAP=PROGDIR:Bumpmaps/Amiga.ilbm', 0], plist)
	ENDIF


	p.width		:= self.plugins.getFirstWidth()
	p.height	:= self.plugins.getFirstHeight()
	self.width	:= p.width
	self.height	:= p.height


	/* lock the public screen */
	s := LockPubScreen(p.scrname)
	IF s = NIL THEN eThrow(ERR_LOCKSCR, 'Uanble to lock public screen: "%s"', [p.scrname])


	/* set or calc position */
	px := p.posx
	py := p.posy

	IF px = POS_CENTER THEN px := (s.width - self.width) / 2
	IF py = POS_CENTER THEN py := (s.height - self.height) / 2


	/* make backup image */
	self.make_backup(s, px, py)



	/* open the window */
	self.win := OpenWindowTagList(NIL, [
		WA_GIMMEZEROZERO, TRUE,
		WA_INNERWIDTH, self.width,
		WA_INNERHEIGHT, self.height,
		WA_LEFT, px,
		WA_TOP, py,
		WA_BORDERLESS, TRUE,
		WA_DRAGBAR, FALSE,
		WA_BACKDROP, TRUE,
		WA_PUBSCREEN, s,
		NIL])
	IF self.win = NIL THEN Raise(ERR_OPENWINDOW)


	/* blit backup bitmap to window rastport */

->	self.backup.write_full(self.win.rport, 0, 0)


	/* create blut (if nessesary) */
	self.make_blut(s)


EXCEPT DO
	IF s THEN UnlockPubScreen(NIL, s)
	IF exception
		self.freeall()
	ENDIF
	ReThrow()
ENDPROC



/* should be overloaded (if nessesary) */
PROC make_blut(s:PTR TO screen) OF bumper HANDLE
	DEF	i, j,
		b=NIL:PTR TO CHAR,
		scol[1024]:ARRAY OF LONG,
		colors,
		or, og, ob,
		nr, ng, nb


	self.blut := NewR(self.levels * 256)

	b := self.blut

	colors := Shl(1, s.rastport.bitmap.depth)
	GetRGB32(s.viewport.colormap, 0, colors-1, scol)
/*
	WriteF('colors: \d\n', colors)
	WriteF('Colors:\n')
	FOR i := 0 TO colors-1
		WriteF('\d[3]: $\h[8], $\h[8], $\h[8]\n', i, scol[i*4], scol[i*4+1], scol[i*4+2])
	ENDFOR
*/
	FOR i := 0 TO colors-1

		IF (self.cusage[i])	-> only if color is actually used

			or := And(Shr(scol[(i*3)+0], 24), $FF)
			og := And(Shr(scol[(i*3)+1], 24), $FF)
			ob := And(Shr(scol[(i*3)+2], 24), $FF)

			FOR j := 0 TO self.levels-1
				nr := Shl(calc_color(or, self.prefs.lightr, j, self.levels-1), 24)
				ng := Shl(calc_color(og, self.prefs.lightg, j, self.levels-1), 24)
				nb := Shl(calc_color(ob, self.prefs.lightb, j, self.levels-1), 24)
				b[Shl(j, 8) + i] := ObtainBestPenA(s.viewport.colormap, nr, ng, nb, [OBP_PRECISION, PRECISION_EXACT, OBP_FAILIFBAD, FALSE, NIL])
->				WriteF('\d[3], \d[3]: $\h[8], $\h[8], $\h[8] (\d)\n', i, j, nr, ng, nb, b[Shl(j, 8) + i])
			ENDFOR

		ENDIF

	ENDFOR

EXCEPT DO
	ReThrow()
ENDPROC



PROC calc_color(val, lightcol, lev, maxlev) IS calc_color3(val, lightcol, lev, maxlev)


/* black -> white */
PROC calc_color2(val, lev, maxlev)
	DEF	temp,
		ml2, ml21

	ml2 := maxlev/2
	ml21 := ml2 - 1

	IF lev < ml2
		RETURN (val * lev) / ml2
	ELSE
		lev := lev - ml2
		temp := val + (Shl(lev, 8) / ml2)
		IF temp > 255 THEN RETURN 255
		IF temp < 0 THEN RETURN 0
	ENDIF
ENDPROC temp


/* original -> white */
PROC calc_color3(val, lightcol, lev, maxlev)
	DEF	temp

	temp := val + Shr(Mul((Shl(lev, 8) / maxlev), lightcol), 8)
	IF temp > 255 THEN RETURN 255
	IF temp < 0 THEN RETURN 0

ENDPROC temp



/* should be overloaded */
PROC make_backup(s:PTR TO screen, px, py) OF bumper HANDLE

	/* allocate backup bitmap */
	NEW self.backup.alloc(self.width, self.height, CIMGTYP_8BIT)

	self.backup.read_full(s.rastport, px, py)

EXCEPT DO
	ReThrow()
ENDPROC




/* stub functions that MUST be overloaded */

PROC update() OF bumper IS Throw(ERR_INTERNAL, 'Function not implemented')




/* in an update needed? */

PROC needUpdate() OF bumper
	DEF	ibase=NIL:PTR TO intuitionbase,
		lightx, lighty

	/* check if screen is the active one */

	ibase := intuitionbase
	IF self.win.wscreen <> ibase.firstscreen THEN RETURN FALSE


	/* light position */

	lightx, lighty := self.getLightSourcePos()

	IF (self.oldlx <> lightx) OR (self.oldly <> lighty)
		self.oldlx := lightx
		self.oldly := lighty
		RETURN TRUE
	ENDIF


	/* does plugins need update? */

	IF self.plugins.needUpdate() THEN RETURN TRUE

ENDPROC FALSE




PROC getLightSourcePos() OF bumper
ENDPROC MouseX(self.win), MouseY(self.win)



PROC freeall() OF bumper
	IF self.win THEN CloseWindow(self.win)
	IF self.blut THEN Dispose(self.blut)
	END self.backup
	END self.plugins
	self.win := NIL
	self.blut := NIL
	self.backup := NIL
ENDPROC



PROC end() OF bumper
	self.freeall()
ENDPROC





