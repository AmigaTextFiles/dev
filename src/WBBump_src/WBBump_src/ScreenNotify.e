/* ************** */
/* ScreenNotify.e */
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


/*
	about this module:
	the calls to screennotify.library are made in inline assembler.
	This is because there's no screennotify modules in std. E package
*/



OPT MODULE

OPT PREPROCESS



MODULE	'intuition/screens',

		'exec/ports',

		'amigalib/ports'






DEF screennotifybase



#define SCREENNOTIFY_TYPE_CLOSESCREEN   0 /* CloseScreen() called, snm_Value contains */
                                          /* pointer to Screen structure              */
#define SCREENNOTIFY_TYPE_PUBLICSCREEN  1 /* PubScreenStatus() called to make screen  */
                                          /* public, snm_Value contains pointer to    */
                                          /* PubScreenNode structure                  */
#define SCREENNOTIFY_TYPE_PRIVATESCREEN 2 /* PubScreenStatus() called to make screen  */
                                          /* private, snm_Value contains pointer to   */
                                          /* PubScreenNode structure                  */
#define SCREENNOTIFY_TYPE_WORKBENCH     3 /* snm_Value == FALSE (0): CloseWorkBench() */
                                          /* called, please close windows on WB       */
                                          /* snm_Value == TRUE  (1): OpenWorkBench()  */
                                          /* called, windows can be opened again      */



OBJECT screennotifymessage
	msg		:	mn
	type	:	LONG
	value	:	LONG
ENDOBJECT




OBJECT screennotify
PRIVATE
	s		:	PTR TO screen
	mp		:	PTR TO mp
	handle	:	LONG
ENDOBJECT


PROC screennotify() OF screennotify
	self.s := NIL
	self.mp := NIL
ENDPROC


/* returns bool */
PROC install(scrname) OF screennotify HANDLE
	self.s := LockPubScreen(scrname)
	IF self.s = NIL THEN Raise(-1)

	self.mp := createPort(NIL, 0)
	IF self.mp = NIL THEN Raise(-1)

	self.handle := addCloseScreenClient(self.s, self.mp, 0)
	IF self.handle = NIL THEN Raise(-1)

EXCEPT DO
	IF self.s THEN UnlockPubScreen(NIL, self.s)
	IF exception
		self.remove()
		RETURN FALSE
	ENDIF
ENDPROC TRUE


PROC remove() OF screennotify
	IF self.handle THEN remCloseScreenClient(self.handle)
	self.handle := NIL
	IF self.mp THEN deletePort(self.mp)
	self.mp := NIL
	self.s := NIL
ENDPROC


PROC end() OF screennotify
	self.remove()
ENDPROC


/* returns bool */
PROC closerequest() OF screennotify HANDLE
	DEF	snm=NIL:PTR TO screennotifymessage,
		close=FALSE

	IF self.mp
		IF (snm := GetMsg(self.mp))
			IF snm.type = SCREENNOTIFY_TYPE_CLOSESCREEN
				IF snm.value = self.s THEN close := TRUE
			ENDIF
		ENDIF
	ENDIF

EXCEPT DO
	IF snm THEN ReplyMsg(snm)
ENDPROC close


/* calls to screennotify */
PROC addCloseScreenClient(screen, msgport, priority)
	MOVE.L	screennotifybase,A6
	MOVE.L	screen,A0
	MOVE.L	msgport,A1
	MOVE.L	priority,A2
	JSR		-30(A0)
ENDPROC

PROC remCloseScreenClient(handle)
	MOVE.L	screennotifybase,A6
	MOVE.L	handle,A0
	JSR		-36(A0)
ENDPROC

