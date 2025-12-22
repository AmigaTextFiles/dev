/* ******** */
/* plugin.e */
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


MODULE	'exec/nodes',
		'exec/libraries',

		'utility/tagitem'


MODULE	'*wbbump_plugin',
		'*plugin_const',
		'*errors'





EXPORT OBJECT plugin
PRIVATE
	libbase		:	PTR TO lib
	filename	:	PTR TO CHAR
	instance	:	LONG
	outbuf		:	PTR TO CHAR
ENDOBJECT



/* constructor */

PROC plugin(copyfrom=NIL:PTR TO plugin) OF plugin
	IF copyfrom
		self.libbase := copyfrom.libbase
		self.filename := copyfrom.filename
		self.instance := NIL
	ELSE
		self.libbase := NIL
		self.filename := NIL
		self.instance := 0
	ENDIF
ENDPROC


/* loads and initializes the plugin */
PROC load(pluginname, minver=1) OF plugin HANDLE
	DEF	lib

	self.plugin()

	self.filename := String(StrLen(pluginname)+1)
	StrCopy(self.filename, pluginname)

	IF (lib := OpenLibrary(self.filename, minver)) = NIL THEN Raise(-1)

	self.libbase := lib

	wbbump_pluginbase := self.libbase

	IF PluginInit(NIL) = FALSE THEN Raise(-1)

EXCEPT DO
	IF exception THEN RETURN FALSE
ENDPROC TRUE





/* create an instance of the class */

PROC createInstance(tags=NIL:PTR TO tagitem) OF plugin HANDLE
	DEF	newinstance=NIL:PTR TO plugin

	NEW newinstance.plugin(self)	-> copy our attrs

	IF newinstance.initInstance(tags) = FALSE THEN Raise(-1)

	newinstance.outbuf := NewR(newinstance.getWidth() * newinstance.getHeight())

EXCEPT DO
	IF exception
		END newinstance
		RETURN NIL
	ENDIF
ENDPROC newinstance


/* init rutine used in createInstance() */

PROC initInstance(tags=NIL:PTR TO tagitem) OF plugin HANDLE
	DEF instance=NIL

	wbbump_pluginbase := self.libbase

	IF (instance := PluginInitInstance(tags)) = NIL THEN Raise(-1)

	self.instance := instance

EXCEPT DO
	IF exception
		self.libbase := NIL
		RETURN FALSE
	ENDIF
ENDPROC TRUE






/* get a plugin attr (PLUGINTAG_xxx with [  G ]) */
PROC getAttr(attr) OF plugin
	DEF res

	wbbump_pluginbase := self.libbase

	IF wbbump_pluginbase=NIL THEN RETURN NIL

	IF PluginGetAttr(self.instance, attr, {res}) = FALSE THEN RETURN 0, FALSE

ENDPROC res, TRUE



/* is this the "class" handler or an instance? */
PROC isClass() OF plugin IS IF self.instance THEN FALSE ELSE TRUE


/* is the plugin a modifier? */
PROC isModifier() OF plugin IS self.getAttr(PLUGINTAG_ISMODIFIER)


/* get the type of plugin */
PROC getType() OF plugin IS self.getAttr(PLUGINTAG_TYPE)


/* get width of plugin */
PROC getWidth() OF plugin IS self.getAttr(PLUGINTAG_WIDTH)

/* get height of plugin */
PROC getHeight() OF plugin IS self.getAttr(PLUGINTAG_HEIGHT)


/* get the name of the plugin */
PROC getName() OF plugin IS self.getAttr(PLUGINTAG_NAME)


/* get the tooltypes command that activates this plugin */
PROC getCommandName() OF plugin IS self.getAttr(PLUGINTAG_COMMANDNAME)


/* get isstatic attribute */
PROC isStatic() OF plugin IS self.getAttr(PLUGINTAG_ISSTATIC)


/* get NeedUpdate attribute */
PROC needUpdate() OF plugin IS self.getAttr(PLUGINTAG_NEEDUPDATE)


/* get the output buffer */
PROC getOutBuf() OF plugin IS self.outbuf


/* get copyright info */
PROC getCopyright() OF plugin IS self.getAttr(PLUGINTAG_COPYRIGHT)


/* get the author name / email */
PROC getAuthor() OF plugin IS self.getAttr(PLUGINTAG_AUTHOR)


/* get the plugin description */
PROC getDescription() OF plugin IS self.getAttr(PLUGINTAG_DESC)


/* get the author name / email */
PROC getLastError() OF plugin IS self.getAttr(PLUGINTAG_LASTERROR)


/* do the action! */
PROC doAction(inbuf, tags=NIL:PTR TO tagitem) OF plugin
	DEF	res

	wbbump_pluginbase := self.libbase

	res := PluginDoAction(self.instance, inbuf, self.outbuf, tags)

ENDPROC res




/* debug function */
PROC writeinfo() OF plugin
	WriteF(	'  Instance  Plugin name                   modifier  class     type commandname         size\n'+
			'  \l$\z\h[8] \s[30]\s[10]\s[10]\d[5]\s[20]\d[3]x\d[3]\n',
			self.instance,
			self.getName(),
			IF self.isModifier() THEN '*' ELSE ' ',
			IF self.isClass() THEN '*' ELSE ' ',
			self.getType(),
			self.getCommandName(),
			self.getWidth(),
			self.getHeight())
ENDPROC


/* close and free all plugin resources */
PROC end() OF plugin
	self.freeall()
ENDPROC


/* close and free all plugin resources */
PROC freeall() OF plugin

	wbbump_pluginbase := self.libbase

	IF self.libbase

		IF self.instance
			PluginFreeInstance(self.instance)
		ELSE
			PluginCleanup()				-> cleanup rutine in plugin
			CloseLibrary(self.libbase)

			IF self.libbase.opencnt = 0
				RemLibrary(self.libbase)	-> flush library if opencount = 0
			ENDIF

		ENDIF

	ENDIF

	IF self.outbuf THEN Dispose(self.outbuf)

	self.filename := NIL
	self.libbase := NIL
	self.instance := NIL
	self.outbuf := NIL


ENDPROC


