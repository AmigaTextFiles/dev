/* *************** */
/* pluginmanager.e */
/* *************** */



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
		'exec/lists',

		'utility/tagitem',

		'dos/dos',

		'amigalib/lists'


MODULE	'*plugin',
		'*plugin_const',
		'*errors'



OBJECT pluginnode OF ln
PRIVATE
	theplugin	:	PTR TO plugin
ENDOBJECT


EXPORT OBJECT pluginlist
PRIVATE
	list	:	lh
	current	:	PTR TO pluginnode
ENDOBJECT




/*******************************************************************************
	constructor
*******************************************************************************/

PROC pluginlist() OF pluginlist HANDLE

	/* init list header */
	newList(self.list)

	self.moveFirst()

EXCEPT DO
	ReThrow()
ENDPROC


/*******************************************************************************
	load all plugins
*******************************************************************************/

PROC loadall() OF pluginlist HANDLE

	self.loaddir('PROGDIR:Plugins/')

EXCEPT DO
	ReThrow()
ENDPROC



/******************************************************************************
	load a complete directory of plugins
******************************************************************************/

PROC loaddir(dirname) OF pluginlist HANDLE
	DEF	dirlock=NIL,
		olddirlock=-1,
		match=NIL,
		fib=NIL:PTR TO fileinfoblock


	NEW fib

	match := NewR(100)

	ParsePatternNoCase('#?.wbbplugin', match, 100)

	IF (dirlock := Lock(dirname, ACCESS_READ)) = NIL THEN Raise(-1)
	olddirlock := CurrentDir(dirlock)

	IF Examine(dirlock, fib) = 0 THEN Raise(-1)

	IF fib.direntrytype < 0 THEN Raise(-1)

	WHILE (ExNext(dirlock, fib) <> FALSE)

		IF MatchPatternNoCase(match, fib.filename)

			self.addFile(fib.filename)

		ENDIF

	ENDWHILE

EXCEPT DO
	IF olddirlock <> -1 THEN CurrentDir(olddirlock)
	IF dirlock THEN UnLock(dirlock)
	END fib
	IF exception THEN RETURN FALSE
ENDPROC TRUE




/******************************************************************************
	add a plugin and add it to list
******************************************************************************/

PROC addFile(filename) OF pluginlist HANDLE
	DEF	pl=NIL:PTR TO plugin

	NEW pl.plugin()

	IF pl.load(filename)
		self.addPlugin(pl)
	ELSE
		END pl
	ENDIF

EXCEPT DO
	IF exception THEN RETURN FALSE
ENDPROC TRUE



/******************************************************************************
	add an initialised plugin to list
******************************************************************************/

PROC addPlugin(pl:PTR TO plugin) OF pluginlist HANDLE
	DEF	pn=NIL:PTR TO pluginnode

	NEW pn
	pn.name := String(StrLen(pl.getName())+1)
	StrCopy(pn.name, pl.getName())
	pn.theplugin := pl

	AddTail(self.list, pn)

EXCEPT DO
	IF exception THEN RETURN FALSE
ENDPROC TRUE


/******************************************************************************
	move to the first element in list
******************************************************************************/

PROC moveFirst() OF pluginlist
	IF self.isEmpty()
		self.current := NIL
		RETURN FALSE
	ELSE
		self.current := self.list.head
	ENDIF
ENDPROC TRUE


/******************************************************************************
	move to the next element in the list
******************************************************************************/

PROC moveNext() OF pluginlist
	IF self.current.succ.succ
		self.current := self.current.succ
	ELSE
		self.current := NIL
		RETURN FALSE
	ENDIF
ENDPROC TRUE


/******************************************************************************
	return a pointer to the current plugin
******************************************************************************/

PROC getCurrent() OF pluginlist
	IF self.current THEN RETURN self.current.theplugin
ENDPROC NIL



/******************************************************************************
	is the list empty?
******************************************************************************/

PROC isEmpty() OF pluginlist IS (self.list.head.succ = NIL)


/******************************************************************************
	remove the current element in list
******************************************************************************/

PROC removeCurrent() OF pluginlist
	DEF	pn=NIL:PTR TO pluginnode

	IF self.current
		pn := self.current
		self.moveNext()
->		WriteF('Removing from list : \s :\s\n', IF pn.theplugin.isClass() THEN 'Class' ELSE 'Instance', pn.theplugin.getName())
		END pn.theplugin
		Remove(pn)
	ELSE
		RETURN FALSE
	ENDIF
ENDPROC TRUE





/******************************************************************************
	add a list of instances matching tooltypes found in masterlist
******************************************************************************/

PROC addInstancesTT(tt:PTR TO LONG, masterlist:PTR TO pluginlist, warn=TRUE) OF pluginlist HANDLE
	DEF	pl=NIL:PTR TO plugin,
		newpl=NIL:PTR TO plugin,
		strlen,
		cursizex=-1, cursizey=-1,
		curstr,
		args=-1,
		i=0


	i := 0
	WHILE (tt[i] <> 0)
		curstr := tt[i]
		IF masterlist.moveFirst()

			REPEAT

				IF (pl := masterlist.getCurrent())

					strlen := StrLen(pl.getCommandName())

					IF StrCmp(curstr, pl.getCommandName(), strlen)

						args := -1

						IF (curstr[strlen] = "=")
							args := curstr+strlen+1
						ELSEIF (curstr[strlen] = 0)
							args := NIL
						ENDIF

						IF args <> -1

							IF (newpl := pl.createInstance([

								PLUGINTAG_ARGS, args,
								PLUGINTAG_WIDTH, cursizex,
								PLUGINTAG_HEIGHT, cursizey,
								TAG_END]))

								cursizex := newpl.getWidth()
								cursizey := newpl.getHeight()

								self.addPlugin(newpl)

->								WriteF('***New instance added***\n')
->								newpl.writeinfo()


							ELSE
								IF warn THEN showWarning('WBBump warning', 'Ok', 'CreateInstance failed for "\s"\n  args: "\s"\n  Error was: "\s"\n', [pl.getName(), args, pl.getLastError()])
							ENDIF

						ENDIF

					ENDIF

				ENDIF

			UNTIL (masterlist.moveNext() = FALSE)

		ENDIF
		i++
	ENDWHILE


EXCEPT DO
	IF exception
		RETURN FALSE
	ENDIF
ENDPROC TRUE






/******************************************************************************
	find sizes of first plugin
******************************************************************************/

PROC getFirstWidth() OF pluginlist
	DEF	pl=NIL:PTR TO plugin

	IF self.moveFirst()
		IF (pl := self.getCurrent())
			RETURN pl.getWidth()
		ENDIF
	ENDIF
ENDPROC -1



PROC getFirstHeight() OF pluginlist
	DEF	pl=NIL:PTR TO plugin

	IF self.moveFirst()
		IF (pl := self.getCurrent())
			RETURN pl.getHeight()
		ENDIF
	ENDIF
ENDPROC -1





/******************************************************************************
	returns TRUE if ANY plugin needs update
******************************************************************************/

PROC needUpdate() OF pluginlist
	DEF	pl=NIL:PTR TO plugin

	IF self.moveFirst()
		WHILE (pl := self.getCurrent())
			IF pl.needUpdate() THEN RETURN TRUE
			self.moveNext()
		ENDWHILE
	ENDIF

ENDPROC FALSE





/******************************************************************************
	execute plugins, if needed
******************************************************************************/

PROC doUpdate() OF pluginlist HANDLE
	DEF	pl=NIL:PTR TO plugin,
		updating=FALSE,
		finalbuf=NIL,
		lastbuf=0


	IF self.moveFirst()
		WHILE (pl := self.getCurrent())

			IF pl.getType() = PLUGINTYPE_BUMPER

				IF pl.needUpdate() THEN updating := TRUE

				IF updating
					pl.doAction(lastbuf)
					lastbuf := pl.getOutBuf()
				ENDIF

				finalbuf := pl.getOutBuf()

			ENDIF

			self.moveNext()

		ENDWHILE
	ENDIF

EXCEPT DO
	IF exception THEN RETURN NIL
ENDPROC finalbuf





/******************************************************************************
	destructor
******************************************************************************/

PROC end() OF pluginlist

	IF self.moveFirst()
		REPEAT
			self.removeCurrent()
			self.moveFirst()
		UNTIL (self.isEmpty() = TRUE)
	ENDIF
ENDPROC








