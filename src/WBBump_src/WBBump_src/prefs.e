/* ******* */
/* prefs.e */
/* ******* */

OPT MODULE


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


MODULE	'icon',

		'workbench/startup',
		'workbench/workbench',

		'wb',

		'exec/lists',
		'exec/nodes',

		'amigalib/lists'


MODULE	'*errors',
		'*notify'


CONST	DEF_WIDTH=200,
		DEF_HEIGHT=75,
		DEF_LEVELS_BIT=4,
		DEF_TASKPRI=-100,
		DEF_STARTDELAY=0,
		DEF_CX_PRI=0

EXPORT CONST POS_CENTER = -1

EXPORT OBJECT prefs
	scrname 	:	PTR TO CHAR
	bumpmapname	:	PTR TO CHAR
	prjname		:	PTR TO CHAR		-> name of the project
	fullprjname	:	PTR TO CHAR		-> name of the project (with path)
	width   	:	INT
	height  	:	INT
	posx    	:	INT
	posy    	:	INT
	bumpname    :	PTR TO CHAR
	levels	    :	INT
	levels_bit	:	CHAR
	taskpri		:	CHAR
	cxpri		:	CHAR
	startdelay	:	LONG
	notifyreq	:	PTR TO notify
	dirlock		:	LONG
	tooltypes	:	PTR TO LONG
	lightr		:	INT			->	\
	lightg		:	INT			->	 > light color
	lightb		:	INT			->	/
ENDOBJECT


PROC get_def() OF prefs
	self.scrname	:= NIL					-> default = default pub screen
	self.bumpmapname:= 'PROGDIR:Bumpmaps/Amiga.ilbm'
	self.prjname	:= NIL
	self.fullprjname:= NIL
	self.width		:= DEF_WIDTH
	self.height		:= DEF_HEIGHT
	self.posx		:= POS_CENTER
	self.posy		:= POS_CENTER
	self.bumpname	:= NIL			-> internal default
	self.levels_bit	:= DEF_LEVELS_BIT
	self.levels 	:= Shl(1, DEF_LEVELS_BIT)
	self.taskpri	:= DEF_TASKPRI
	self.cxpri		:= DEF_CX_PRI
	self.startdelay	:= DEF_STARTDELAY
	self.notifyreq	:= NIL
	self.dirlock	:= NIL
	self.tooltypes	:= NIL
	self.lightr		:= 256
	self.lightg		:= 256
	self.lightb		:= 256
ENDPROC


PROC read_prefs() OF prefs HANDLE

	/* set defaults */
	self.get_def()


	/* use right method */
	IF wbmessage = NIL /* started from cli */
		self.read_cli_args()
	ELSE
		self.read_icon()
	ENDIF


EXCEPT DO
	ReThrow()
ENDPROC





PROC read_icon() OF prefs HANDLE
	DEF	wbmsg=NIL:PTR TO wbstartup,
		wbarg=NIL:PTR TO wbarg,
		dobj=NIL:PTR TO diskobject,
		iconname=NIL:PTR TO CHAR,
		n=NIL:PTR TO notify,
		tr, tg, tb,
		olddirlock=NIL



	self.get_def()

	/* E supplies wbmessage */
	wbmsg := wbmessage

	/* get last argument */
	wbarg := wbmsg.arglist[wbmsg.numargs-1]


	IF wbarg.name = NIL THEN Raise(ERR_INTERNAL)

	self.prjname := String(StrLen(wbarg.name)+1)
	StrCopy(self.prjname, wbarg.name)


	self.dirlock := wbarg.lock

	/* cd into executable directory */
	IF self.dirlock THEN olddirlock := CurrentDir(self.dirlock)


	/* get project name with path */
	self.fullprjname := String(1024)
	IF GetCurrentDirName(self.fullprjname, 1024) = FALSE THEN Throw(ERR_INTERNAL, 'Internal path buffer to small')
	IF AddPart(self.fullprjname, self.prjname, 1024) = FALSE THEN Throw(ERR_INTERNAL, 'Internal path buffer to small')


	/* get diskobject (ie. icon) */
	IF (dobj := GetDiskObject(self.prjname)) = NIL THEN Raise("cont")


	/* get copy of tooltypes */
	self.tooltypes := copytooltypes(dobj.tooltypes)


	/* setup notification request for icon */
	iconname := String(StrLen(self.prjname)+6)
	StringF(iconname, '\s.info', self.prjname)
	NEW n.notify(iconname)
	self.notifyreq := n




	/* parse tooltypes */

	self.scrname := stringFindToolType(self.tooltypes, 'SCREENNAME', NIL)


	self.bumpmapname := stringFindToolType(self.tooltypes, 'BUMPMAP', NIL)


	self.taskpri := intFindToolType(self.tooltypes, 'TASKPRI', -128, 127, -100)


	self.levels_bit := intFindToolType(self.tooltypes, 'DEPTH', 1, 8, 3)
	self.levels := Shl(1, self.levels_bit)


	self.startdelay := intFindToolType(self.tooltypes, 'STARTDELAY', 0, 100, 0)


	self.posx := intFindToolType(self.tooltypes, 'POSITIONX', 0, 32000, POS_CENTER)

	self.posy := intFindToolType(self.tooltypes, 'POSITIONY', 0, 32000, POS_CENTER)


	tr, tg, tb := rgbFindToolType(self.tooltypes, 'LIGHTCOLOR', 256, 256, 256)
	self.lightr := tr
	self.lightg := tg
	self.lightb := tb

EXCEPT DO
	IF olddirlock THEN CurrentDir(olddirlock)
	IF dobj THEN FreeDiskObject(dobj)
	IF exception <> "cont" THEN ReThrow()
ENDPROC



PROC read_cli_args() OF prefs HANDLE

	self.get_def()

EXCEPT DO
	ReThrow()
ENDPROC


PROC haschanged() OF prefs
	IF self.notifyreq THEN RETURN self.notifyreq.haschanged()
ENDPROC FALSE



PROC edit() OF prefs HANDLE
	DEF	scr=NIL

	IF (self.prjname) AND (self.dirlock)
		IF (scr := LockPubScreen(self.scrname))
			IF WbInfo(self.dirlock, self.prjname, scr) = FALSE THEN DisplayBeep(NIL)
		ENDIF
	ENDIF

EXCEPT DO
	IF scr THEN UnlockPubScreen(NIL, scr)
ENDPROC


PROC end() OF prefs
	END self.notifyreq
ENDPROC















/* support functions */
PROC stringFindToolType(tt, typename, def)
	DEF	strptr, str=NIL
	strptr := FindToolType(tt, typename)
	IF strptr
		str := String(StrLen(strptr)+1)
		StrCopy(str, strptr)
	ELSE
		str := def
	ENDIF
ENDPROC str


PROC intFindToolType(tt, typename, min, max, def)
	DEF	int, val, read,
		strptr

	int := def

	strptr := FindToolType(tt, typename)
	IF strptr
		val, read := Val(strptr)
		IF read > 0
			IF (val >= min) AND (val <= max) THEN int := val
		ENDIF
	ENDIF
ENDPROC int



PROC rgbFindToolType(tt, typename, defr, defg, defb)
	DEF	val, read,
		r, g, b,
		strptr

	r := defr
	g := defg
	b := defb

	strptr := FindToolType(tt, typename)
	IF strptr
		val, read := Val(strptr)
		IF read > 0
			r := val

			strptr := strptr + read
			val, read := Val(strptr)
			IF read > 0
				g := val

				strptr := strptr + read
				val, read := Val(strptr)
				IF read > 0 THEN b := val
			ENDIF
		ENDIF
	ENDIF
ENDPROC r, g, b




PROC copytooltypes(tt:PTR TO LONG)
	DEF	newtt=NIL:PTR TO LONG,
		count=0,
		i

	WHILE tt[count] <> 0
		count++
	ENDWHILE

	newtt := NewR((count+1) * SIZEOF LONG)

	FOR i := 0 TO count-1
		newtt[i] := String(StrLen(tt[i])+1)
		StrCopy(newtt[i], tt[i])
	ENDFOR

	newtt[count] := 0
ENDPROC newtt


