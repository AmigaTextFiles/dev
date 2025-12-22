/* ***************** */
/* image.wbbplugin.e */
/* ***************** */



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
	Example plugin for WBBump
	loads an image with datatypes and uses it as bumpmap
*/

OPT PREPROCESS



LIBRARY 'image.wbbplugin', 1, 0, 'image.wbbplugin 1.0 (1/5/99)' IS
	pluginInit(A0), pluginCleanup(),
	pluginInitInstance(A0), pluginFreeInstance(A0),
	pluginGetAttr(D1,D2,A0), pluginSetAttr(D1,D2,D3),
	pluginDoAction(A0,A1,A2,A3)





/* just to put flags in top of source */

#define	ARGTEMPLATE	  'NAME/A'
#define	PLUGINTYPE	  PLUGINTYPE_BUMPER
CONST	ISMODIFIER	= FALSE				-> this is not a modifying plugin
CONST	ISSTATIC	= TRUE				-> this is a static plugin (see plugin.e)


/* needed modules */



MODULE	'utility',
		'utility/tagitem',

		'datatypes'


MODULE	'*/plugin_const',
		'*/argparser',
		'*/chunkyimage',
		'*/errors'




OBJECT handle
	width	:	LONG
	height	:	LONG
	args	:	PTR TO CHAR
	rdargs	:	LONG
	picname	:	PTR TO CHAR
	image	:	PTR TO cimg
	firstrun:	LONG		-> bool
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

	IF (datatypesbase := OpenLibrary('datatypes.library', 39)) = NIL THEN RETURN FALSE


ENDPROC TRUE




/* free the "class" */

PROC pluginCleanup()
	/* cleanup things done in pluginInit() */

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


	/* alloc handle */
	NEW h



	/* set global vars */

	IF tags
		width		:= GetTagData(PLUGINTAG_WIDTH, -1, tags)
		height		:= GetTagData(PLUGINTAG_HEIGHT, -1, tags)
		h.args		:= GetTagData(PLUGINTAG_ARGS, NIL, tags)
		args		:= [NIL, 0]
		h.rdargs	:= parseargs(ARGTEMPLATE, args, h.args)
		IF h.rdargs = NIL THEN eThrow(-1, 'Bad arguments, template is %s', [ARGTEMPLATE])
		h.picname	:= args[0]
		h.firstrun	:= TRUE
	ELSE
		RETURN NIL
	ENDIF


	/* load image with cimg class */
	IF getImage(h) = FALSE THEN eThrow(-1, 'Unable to load image "%s" with datatypes', [h.picname])


	/* check size */
	IF	(width <> -1) AND (width <> h.image.width) OR
		(height <> -1) AND (height <> h.image.height)
		eThrow(-1, 'Wrong size: %ldx%ld, for this image %ldx%ld is needed', [width, height, h.image.width, h.image.height])
	ENDIF

	/* return NIL if there was an error */

EXCEPT DO
	IF exception
		IF h THEN pluginFreeInstance(h)
		lasterr := exceptioninfo
		RETURN NIL
	ENDIF
ENDPROC h


/* proc to catch exceptions */
PROC getImage(h:PTR TO handle) HANDLE
	NEW h.image.newfromDT(h.picname)
EXCEPT DO
	IF exception THEN RETURN FALSE
ENDPROC TRUE



/* free an instance */ 

PROC pluginFreeInstance(h:PTR TO handle)
	DEF dummy

	/* cleanup stuff allocated in pluginInitInstance() */

	IF h.rdargs THEN freeargs(h.rdargs)

	END h.image

ENDPROC



/* get an attribute from the instance, or globally if handle = 0 */

PROC pluginGetAttr(h:PTR TO handle, attr, valueptr:PTR TO LONG)

	/* this is where WBBump gets information from the plugin */
	/* look in plugin.e to see what is required */

	IF h
		SELECT attr

		CASE PLUGINTAG_WIDTH
			valueptr[0] := h.image.width	-> return the width
			RETURN TRUE

		CASE PLUGINTAG_HEIGHT
			valueptr[0] := h.image.height	-> return the height
			RETURN TRUE

		CASE PLUGINTAG_NEEDUPDATE
			IF h.firstrun
				valueptr[0] := TRUE
				h.firstrun := FALSE
			ELSE
				valueptr[0] := FALSE
			ENDIF
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
		valueptr[0] := 'BUMPMAP'-> tooltypes command
		RETURN TRUE

	CASE PLUGINTAG_ISSTATIC
		valueptr[0] := ISSTATIC		-> see top of file
		RETURN TRUE

	CASE PLUGINTAG_TYPE
		valueptr[0] := PLUGINTYPE
		RETURN TRUE

	CASE PLUGINTAG_NAME
		valueptr[0] := 'image.wbbplugin'
		RETURN TRUE

	CASE PLUGINTAG_COPYRIGHT
		valueptr[0] := '©1999 Thomas Jensen - dm98411@edb.tietgen.dk'
		RETURN TRUE

	CASE PLUGINTAG_AUTHOR
		valueptr[0] := 'Thomas Jensen - dm98411@edb.tietgen.dk'
		RETURN TRUE

	CASE PLUGINTAG_DESC
		valueptr[0] := 'Image loader using datatypes\nImages must be 8bit'
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
	DEF	mybuf=NIL:PTR TO CHAR

	/* this is the "action" part of the plugin */
	/* it is called each time the plugin's services are needed */
	/* if the plugin says TRUE to ISMODIFIER then inbuf MAY contain an image */
	/* othervise it a NIL pointer */
	/* tags is currently not used */

	IF h.image.lock([CIMGTAG_LOCK_BUF, {mybuf}, TAG_END]) = FALSE THEN eThrow(-1, 'Unable to lock image (internal error)')

	CopyMem(mybuf, outbuf, h.image.width * h.image.height)

	h.image.unlock()


EXCEPT DO
	/* return FALSE if something went wrong */
	IF exception
		lasterr := exceptioninfo
		RETURN FALSE
	ENDIF
ENDPROC TRUE
