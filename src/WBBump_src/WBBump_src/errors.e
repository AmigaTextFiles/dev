/* ******** */
/* errors.e */
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



MODULE	'intuition/intuition'


DEF	errorstring


EXPORT ENUM	ERR_NONE,
			ERR_LOCKSCR,
			ERR_OPENWINDOW,
			ERR_INTERNAL,
			ERR_LOCKCIMG,
			ERR_CREATEMSGPORT,
			ERR_CXBROKER,
			ERR_BADSCREEN,
			ERR_CXLIB,
			ERR_ICONLIB,
			ERR_CGXLIB,
			ERR_UTILLIB,
			ERR_DTLIB,
			ERR_WBLIB,
			ERR_DT,
			ERR_CREATEPORT,
			ERR_THREAD,
			ERR_ALLOCSIGNAL,
			ERR_PLUGIN,
			ERR_LOADPLUGIN,
			ERR_PLUGININIT


OBJECT errtab
	err
	desc
ENDOBJECT


EXPORT PROC show_error(id, txt, report=TRUE)
	DEF	str[4096]:STRING,
		table=NIL:PTR TO errtab,
		i

	table := [
		ERR_LOCKSCR, 'Unable to lock specified screen',
		ERR_OPENWINDOW, 'Unable to open window,\nmaybe you''re out of memory',
		ERR_INTERNAL, 'Interal error (please contact author)',
		ERR_LOCKCIMG, 'Unable to lock an internal image buffer\nThis should not happen under normal circumstances,\nplease contact the author',
		ERR_CREATEMSGPORT, 'Unable to create messageport\nMight be a memory problem',
		ERR_CXBROKER, 'Unable to create Commodity',
		ERR_BADSCREEN, 'The chosen screen is not appropriate\n to run WBBump on.\nWBBump needs a CyberGraphics screen',
		ERR_CXLIB, 'This program needs commodities.library V37+',
		ERR_ICONLIB, 'This program needs icon.library V39+',
		ERR_CGXLIB, 'This program needs cybergraphics.library V39+',
		ERR_UTILLIB, 'This program needs utilities.library V39+',
		ERR_DTLIB, 'This program needs datatypes.library V39+',
		ERR_WBLIB, 'Unable to open workbench.library V39+',
		ERR_DT, 'Datatypes error',
		ERR_CREATEPORT, 'Unable to create messageport\nMemory error?',
		ERR_THREAD, 'Thread error',
		ERR_ALLOCSIGNAL, 'Unable to alloc signal\n(internal error)',
		ERR_PLUGIN, 'Plugin error',
		ERR_LOADPLUGIN, 'Unable to load plugin',
		ERR_PLUGININIT, 'Error in plugin initialization',
		0]:errtab


	i := 0
	WHILE (table[i].err <> 0) AND (table[i].err <> id)
		i++
	ENDWHILE


	IF (table[i].err = 0)
		StringF(str,	'An error has occured\n'+
						'ErrorID: \z\h[8]\n'+
						'\s',
						id, txt)
	ELSE
		StringF(str,	'An error has occured\n'+
						'\s\n'+
						'\s\n'+
						'ErrorID: \z\h[8]',
						table[i].desc, txt, id)
	ENDIF


	showWarning('WBBump error', 'Quit', str)

ENDPROC


EXPORT PROC showWarning(wintitle, buttons, fmtstr, argstream=NIL:PTR TO LONG)
	DEF	contents[8192]:ARRAY OF CHAR

	IF argstream
		RawDoFmt(fmtstr, argstream, {putchproc}, contents)
		RETURN EasyRequestArgs(0, [20, 0, wintitle, contents, buttons], 0, [NIL])
	ELSE
		RETURN EasyRequestArgs(0, [20, 0, wintitle, fmtstr, buttons], 0, [NIL])
	ENDIF

ENDPROC NIL


/* enhanced Throw() */
EXPORT PROC eThrow(excid, excinfo, argstream=NIL:PTR TO LONG)
	IF errorstring = NIL THEN errorstring := NewR(4096)

	IF argstream
		RawDoFmt(excinfo, argstream, {putchproc}, errorstring)
		Throw(excid, errorstring)
	ELSE
		Throw(excid, excinfo)
	ENDIF
ENDPROC


putchproc:
	MOVE.B	D0,(A3)+
	RTS

