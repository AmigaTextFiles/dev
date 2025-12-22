/* **************** */
/* clock.wbbplugin.e */
/* **************** */



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



/*
*/

OPT PREPROCESS



LIBRARY 'clock.wbbplugin', 1, 0, 'clock.wbbplugin 1.0 (7/5/99)' IS
	pluginInit(A0), pluginCleanup(),
	pluginInitInstance(A0), pluginFreeInstance(A0),
	pluginGetAttr(D1,D2,A0), pluginSetAttr(D1,D2,D3),
	pluginDoAction(A0,A1,A2,A3)





/* just to put flags in top of source */

#define	ARGTEMPLATE	  'SIT/S,CET_OFFSET/N,SUMMERTIME/S'
#define	PLUGINTYPE	  PLUGINTYPE_BUMPER
CONST	ISMODIFIER	= FALSE				-> this is not a modifying plugin
CONST	ISSTATIC	= FALSE				-> this is not a static plugin (see plugin.e)


/* needed modules */



MODULE	'utility',
		'utility/tagitem',

		'datatypes',

		'dos/dos'


MODULE	'*/plugin_const',
		'*/errors',
		'*/chunkyimage',
		'*/argparser'


/* time modes */
ENUM	MODE_NORMAL,
		MODE_SIT



OBJECT handle
	width		:	LONG
	height		:	LONG
	args		:	PTR TO CHAR
	rdargs		:	LONG
	mode		:	LONG		-> MODE_xxx
	secs		:	LONG		-> secs since midnight
	secs_last	:	LONG		-> last reading
	sit			:	INT			-> SIT ticks
	sit_last	:	INT			-> SIT ticks last time
	offset		:	INT			-> offset in hours from CET
	time[5]		:	ARRAY OF CHAR
ENDOBJECT


DEF	digits_png_size=1353


DEF	lasterr=NIL


/* offsets into image */
DEF	offsets=NIL:PTR TO LONG
/* widths of digits */
DEF	widths=NIL:PTR TO LONG

DEF	max_width_num=-1


/* global image of digits */
DEF	digits=NIL:PTR TO cimg



PROC main()
	/* library init code here */
	/* this is executed in Forbid() so be carefull */
	/* better use pluginInit() for most things */

	/* we need utility.library for GetTagData() */
	IF (utilitybase := OpenLibrary('utility.library', 37)) = NIL THEN RETURN FALSE


ENDPROC



PROC close()
	/* free stuff allocated in main() here */

	IF utilitybase THEN CloseLibrary(utilitybase)

ENDPROC




/* init the "class" */

PROC pluginInit(tags:PTR TO tagitem)
	/* do initializations that can't be done in main() here */
	/* read files, open libs, etc. */

	DEF	i

	IF (datatypesbase := OpenLibrary('datatypes.library', 39)) = NIL THEN RETURN FALSE


	offsets	:= [0, 35, 68, 104, 137, 173, 207, 244, 277, 312, 347, 365, 414]:LONG

	/* calc witdhs */
	widths := New(12*4)
	FOR i := 0 TO 11 DO widths[i] := offsets[i+1] - offsets[i]

	/* get max width */
	max_width_num := -1
	FOR i := 0 TO 9
		IF widths[i] > max_width_num THEN max_width_num := widths[i]
	ENDFOR

ENDPROC TRUE




/* free the "class" */

PROC pluginCleanup()
	/* cleanup things done in pluginInit() */

	END digits

	IF datatypesbase THEN CloseLibrary(datatypesbase)

ENDPROC









/* init an instance */

PROC pluginInitInstance(tags:PTR TO tagitem) HANDLE
	DEF	h=NIL:PTR TO handle,
		args=NIL:PTR TO LONG,
		width, height

	/* this function is allways called by WBBump */
	/* use it to allocate buffers, etc */

	/* return a handle to an "instance" */


	IF digits = NIL
		getDigits()
	ENDIF


	/* alloc handle */
	NEW h



	/* set global vars */

	IF tags
		width		:= GetTagData(PLUGINTAG_WIDTH, -1, tags)
		height		:= GetTagData(PLUGINTAG_HEIGHT, -1, tags)
		h.args		:= GetTagData(PLUGINTAG_ARGS, NIL, tags)
		args		:= NEW [0, 0, 0, 0]
		IF h.args
			h.rdargs	:= parseargs(ARGTEMPLATE, args, h.args)
			IF h.rdargs = NIL THEN eThrow(-1, 'Bad arguments, template is %s', NEW [ARGTEMPLATE])
		ENDIF
		h.mode		:= IF args[0] THEN MODE_SIT ELSE MODE_NORMAL
		h.offset	:= IF args[1] THEN Long(args[1]) ELSE 0
		IF args[2] THEN h.offset := h.offset - 1
		IF h.offset < 0 THEN h.offset := h.offset + 24
	ELSE
		RETURN NIL
	ENDIF



	/* check size */
	IF	(width <= 0) OR (height <= 0)
		h.width := h.maxwidth() + 10
		h.height := 50 + 10
	ELSE
		IF (width < h.maxwidth()) OR (height < 50) THEN eThrow(-1, 'Initial size too small, Clock plugin needs %ld x %ld in this mode', NEW [h.maxwidth(), 50])
		h.width := width
		h.height := height
	ENDIF

	/* return NIL if there was an error */

EXCEPT DO
	IF exception
		IF h THEN pluginFreeInstance(h)
		lasterr := exceptioninfo
		RETURN NIL
	ENDIF
ENDPROC h




/* load image */
PROC getDigits() HANDLE
	DEF	fh=NIL,
		fname[256]:STRING


	StringF(fname, 'T:WBB.clock.temp.png.\z\h[8]', FindTask(0))

	IF (fh := Open(fname, MODE_NEWFILE)) = NIL THEN eThrow(-1, 'Unable to create temp image in T:')

	IF Write(fh, {digits_png}, digits_png_size) <> digits_png_size THEN eThrow(-1, 'Write error on file: %s', NEW [fname])

	Close(fh); fh := NIL

	NEW digits.newfromDT(fname)

	DeleteFile(fname)

EXCEPT DO
	IF fh THEN Close(fh)
	ReThrow()
ENDPROC TRUE




/* free an instance */ 

PROC pluginFreeInstance(h:PTR TO handle)

	/* cleanup stuff allocated in pluginInitInstance() */

	IF h.rdargs THEN freeargs(h.rdargs)

ENDPROC



/* get an attribute from the instance, or globally if handle = 0 */

PROC pluginGetAttr(h:PTR TO handle, attr, valueptr:PTR TO LONG)

	/* this is where WBBump gets information from the plugin */
	/* look in plugin.e to see what is required */

	IF h
		SELECT attr

		CASE PLUGINTAG_WIDTH
			valueptr[0] := h.width	-> return the width
			RETURN TRUE

		CASE PLUGINTAG_HEIGHT
			valueptr[0] := h.height	-> return the height
			RETURN TRUE

		CASE PLUGINTAG_NEEDUPDATE
			valueptr[0] := h.needupdate()
			RETURN TRUE

		ENDSELECT
	ENDIF

	SELECT attr

	CASE PLUGINTAG_WIDTH
		valueptr[0] := -1
		RETURN TRUE

	CASE PLUGINTAG_HEIGHT
		valueptr[0] := -1
		RETURN TRUE

	CASE PLUGINTAG_ISMODIFIER
		valueptr[0] := ISMODIFIER	-> see top of file
		RETURN TRUE

	CASE PLUGINTAG_COMMANDNAME
		valueptr[0] := 'PLUGIN_CLOCK'	-> tooltypes command
		RETURN TRUE

	CASE PLUGINTAG_ISSTATIC
		valueptr[0] := ISSTATIC		-> see top of file
		RETURN TRUE

	CASE PLUGINTAG_TYPE
		valueptr[0] := PLUGINTYPE
		RETURN TRUE

	CASE PLUGINTAG_NAME
		valueptr[0] := 'clock.wbbplugin'
		RETURN TRUE

	CASE PLUGINTAG_COPYRIGHT
		valueptr[0] := '©1999 Thomas Jensen - dm98411@edb.tietgen.dk'
		RETURN TRUE

	CASE PLUGINTAG_AUTHOR
		valueptr[0] := 'Thomas Jensen - dm98411@edb.tietgen.dk'
		RETURN TRUE

	CASE PLUGINTAG_DESC
		valueptr[0] := 'Shows clock as bumpmap\nKnows "normal" clock and Internet time'
		RETURN TRUE

	CASE PLUGINTAG_LASTERROR
		valueptr[0] := lasterr
		RETURN TRUE

	DEFAULT
		lasterr := 'Unknown tag'
		RETURN FALSE			-> return false if the tag is unknown

	ENDSELECT

ENDPROC FALSE



PROC pluginSetAttr(h:PTR TO handle, attr, value)

	/* later this may be used to set plugin attributes */
	/* if there's no attributes to set, return FALSE */

ENDPROC FALSE




PROC pluginDoAction(h:PTR TO handle, inbuf:PTR TO CHAR, outbuf:PTR TO CHAR, tags:PTR TO tagitem) HANDLE

	/* this is the "action" part of the plugin */
	/* it is called each time the plugin's services are needed */
	/* if the plugin says TRUE to ISMODIFIER then inbuf MAY contain an image */
	/* othervise it a NIL pointer */
	/* tags is currently not used */


	h.updatetime()

	h.drawdigits(outbuf)

EXCEPT DO
	/* return FALSE if something went wrong */
	IF exception
		lasterr := exceptioninfo
		RETURN FALSE
	ENDIF
ENDPROC TRUE




/* handle methods */

PROC updatetime() OF handle HANDLE
	DEF	ds:PTR TO datestamp,
		sit_secs,
		h,m,s

	NEW ds

	DateStamp(ds)

	self.secs := (ds.minute * 60) + (ds.tick / 50)

	h := Div(self.secs, 60*60)
	m := Div(self.secs, 60) - (h * 60)
	s := self.secs - (h*60*60) - (m*60)

	sit_secs := self.secs + (self.offset * 60 * 60)

	self.sit := Mod(Div(Mul(sit_secs, 1000), (60*60*24)), 1000)

	IF self.mode = MODE_NORMAL
		self.time[0] := h / 10
		self.time[1] := Mod(h, 10)
		self.time[2] := 10						-> ':'
		self.time[3] := m / 10
		self.time[4] := Mod(m, 10)
	ELSE
		self.time[0] := 11						-> '@'
		self.time[1] := self.sit / 100
		self.time[2] := Mod(self.sit / 10, 10)
		self.time[3] := Mod(self.sit, 10)
	ENDIF

EXCEPT DO
	END ds
	ReThrow()
ENDPROC



PROC needupdate() OF handle
	DEF	mode


	self.updatetime()

	mode := self.mode	

	SELECT mode
	CASE MODE_NORMAL
		RETURN IF Div(self.secs_last, 60) = Div(self.secs, 60) THEN FALSE ELSE TRUE
	CASE MODE_SIT
		RETURN IF self.sit = self.sit_last THEN FALSE ELSE TRUE
	ENDSELECT

ENDPROC FALSE


PROC maxwidth() OF handle
	DEF	mode

	mode := self.mode

	SELECT mode
	CASE MODE_NORMAL
		RETURN  (max_width_num * 4) + widths[10] /* : */
	CASE MODE_SIT
		RETURN (max_width_num * 3) + widths[11] /* @ */
	ENDSELECT

ENDPROC


PROC curwidth() OF handle
	DEF	mode

	mode := self.mode

	SELECT mode
	CASE MODE_NORMAL
		RETURN  widths[self.time[0]] + widths[self.time[1]] + widths[self.time[2]] + widths[self.time[3]] + widths[self.time[4]]
	CASE MODE_SIT
		RETURN widths[self.time[0]] + widths[self.time[1]] + widths[self.time[2]] + widths[self.time[3]]
	ENDSELECT

ENDPROC



PROC drawdigit(dignum, x, y, buf, width) OF handle HANDLE
	DEF	ix, iy,
		index,
		digbuf=NIL

	IF digits.lock(NEW [CIMGTAG_LOCK_BUF, {digbuf}, 0]) = FALSE THEN eThrow(-1, 'Internal error in digits.lock()')

	index := x + (y * width)
	FOR iy := 0 TO 49
		FOR ix := 0 TO widths[dignum]-1
			buf[index + ix + (iy * width)] := digbuf[offsets[dignum] + ix + (iy * digits.width)]
		ENDFOR
	ENDFOR

EXCEPT DO
	digits.unlock()
	ReThrow()
ENDPROC


PROC drawdigits(buf) OF handle
	DEF	i,
		num,
		curx,
		offx, offy


	self.secs_last := self.secs
	self.sit_last := self.sit


	IF self.mode = MODE_NORMAL THEN num := 5 ELSE num := 4

	offx := (self.width - self.curwidth()) / 2
	offy := (self.height - 50) / 2

	curx := offx

	FOR i := 0 TO num-1
		self.drawdigit(self.time[i], curx, offy, buf, self.width)
		curx := curx + widths[self.time[i]]
	ENDFOR
ENDPROC






digits_png:
	INCBIN	'Clock.png'
digits_png_end:





