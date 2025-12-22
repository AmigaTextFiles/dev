/* ****************** */
/* invert.wbbplugin.e */
/* ****************** */



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



LIBRARY 'invert.wbbplugin', 1, 0, 'invert.wbbplugin 1.0 (7/5/99)' IS
	pluginInit(A0), pluginCleanup(),
	pluginInitInstance(A0), pluginFreeInstance(A0),
	pluginGetAttr(D1,D2,A0), pluginSetAttr(D1,D2,D3),
	pluginDoAction(A0,A1,A2,A3)





/* just to put flags in top of source */

#define	ARGTEMPLATE	  ''
#define	PLUGINTYPE	  PLUGINTYPE_BUMPER
CONST	ISMODIFIER	= TRUE				-> this is a modifying plugin
CONST	ISSTATIC	= TRUE				-> this is a static plugin (see plugin.e)


/* needed modules */



MODULE	'utility',
		'utility/tagitem'


MODULE	'*/plugin_const',

		'*invert_supp'




OBJECT handle
	width	:	LONG
	height	:	LONG
	args	:	PTR TO CHAR
ENDOBJECT




DEF	lasterr=NIL




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

ENDPROC TRUE




/* free the "class" */

PROC pluginCleanup()
	/* cleanup things done in pluginInit() */

ENDPROC









/* init an instance */

PROC pluginInitInstance(tags:PTR TO tagitem) HANDLE
	DEF	h=NIL:PTR TO handle

	/* this function is allways called by WBBump */
	/* use it to allocate buffers, etc */

	/* return a handle to an "instance" */


	/* alloc handle */
	NEW h



	/* set global vars */

	IF tags
		h.width		:= GetTagData(PLUGINTAG_WIDTH, -1, tags)
		h.height	:= GetTagData(PLUGINTAG_HEIGHT, -1, tags)
		h.args		:= GetTagData(PLUGINTAG_ARGS, NIL, tags)
	ELSE
		RETURN NIL
	ENDIF



	/* check size */
	IF	(h.width <= 0) OR (h.height <= 0)
		Throw(-1, 'No or wrong size given')
	ENDIF

	/* return NIL if there was an error */

EXCEPT DO
	IF exception
		IF h THEN pluginFreeInstance(h)
		lasterr := exceptioninfo
		RETURN NIL
	ENDIF
ENDPROC h





/* free an instance */ 

PROC pluginFreeInstance(h:PTR TO handle)

	/* cleanup stuff allocated in pluginInitInstance() */

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
			valueptr[0] := FALSE
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
		valueptr[0] := 'PLUGIN_INVERT'	-> tooltypes command
		RETURN TRUE

	CASE PLUGINTAG_ISSTATIC
		valueptr[0] := ISSTATIC		-> see top of file
		RETURN TRUE

	CASE PLUGINTAG_TYPE
		valueptr[0] := PLUGINTYPE
		RETURN TRUE

	CASE PLUGINTAG_NAME
		valueptr[0] := 'invert.wbbplugin'
		RETURN TRUE

	CASE PLUGINTAG_COPYRIGHT
		valueptr[0] := '©1999 Thomas Jensen - dm98411@edb.tietgen.dk'
		RETURN TRUE

	CASE PLUGINTAG_AUTHOR
		valueptr[0] := 'Thomas Jensen - dm98411@edb.tietgen.dk'
		RETURN TRUE

	CASE PLUGINTAG_DESC
		valueptr[0] := 'Inverts the input image'
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
	DEF	i

	/* this is the "action" part of the plugin */
	/* it is called each time the plugin's services are needed */
	/* if the plugin says TRUE to ISMODIFIER then inbuf MAY contain an image */
	/* othervise it a NIL pointer */
	/* tags is currently not used */

	IF inbuf <> NIL
		invert_buffer(inbuf, outbuf, Mul(h.width, h.height))
	ELSE
		FOR i := 0 TO Mul(h.width, h.height)-1 DO outbuf[i] := $FF
	ENDIF


EXCEPT DO
	/* return FALSE if something went wrong */
	IF exception
		lasterr := exceptioninfo
		RETURN FALSE
	ENDIF
ENDPROC TRUE
