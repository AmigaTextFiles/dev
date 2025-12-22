/* *********** */
/* commodity.e */
/* *********** */

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
OPT PREPROCESS


MODULE	'commodities',

		'amigalib/argarray',
		'amigalib/cx',

		'devices/timer',
		'devices/inputevent',

		'dos/dos',

		'exec/ports',
		'exec/tasks',
		'exec/nodes',

		'libraries/commodities'


MODULE	'*prefs',
		'*version',
		'*errors'


EXPORT CONST	MSG_NO=0,
				MSG_ENABLE	=	CXCMD_ENABLE,
				MSG_DISABLE	=	CXCMD_DISABLE,
				MSG_APPEAR	=	CXCMD_APPEAR,
				MSG_QUIT	=	CXCMD_KILL


EXPORT OBJECT cx
PRIVATE
	broker	:	LONG
	mp		:	PTR TO mp	-> msg port
PUBLIC
	sigflag	:	LONG
ENDOBJECT



PROC cx(p:PTR TO prefs) OF cx HANDLE
	DEF	title=NIL:PTR TO CHAR,
		me=NIL:PTR TO tc

	/* init vars to NIL */

	self.broker := NIL
	self.mp := NIL


	IF cxbase = NIL THEN Raise(ERR_CXLIB)



	/* create messageport */

	self.mp := CreateMsgPort()
	IF self.mp = NIL THEN Raise(ERR_CREATEMSGPORT)
	self.sigflag := Shl(1, self.mp.sigbit)


	/* construct name */

	title := String(1024)
	StringF(title, 'WBBump (\s)', p.prjname)


	/* change task name */

	me := FindTask(NIL)
	me.ln.name := title


	/* Create to Commodities broker */

	self.broker := CxBroker([
		NB_VERSION,
		0,										-> pad
		title,									-> title
		{versionstr}+6,							-> name
		'Bumpmapped image on your Workbench',	-> desc
		0,										-> unique
		COF_SHOW_HIDE,							-> flags
		p.cxpri,								-> pri
		0,	 									-> pad
		self.mp,								-> msg port
		0]:newbroker, NIL)

	IF self.broker = NIL THEN Raise(ERR_CXBROKER)


	/* Activate the CX object */

	ActivateCxObj(self.broker, TRUE)

EXCEPT DO
	ReThrow()
ENDPROC


PROC end() OF cx
	DEF	msg=NIL

	/* delete broker */
	IF self.broker THEN DeleteCxObjAll(self.broker)
	IF self.mp
		/* empty msg queue */
		WHILE (msg := GetMsg(self.mp)) DO ReplyMsg(msg)
		DeleteMsgPort(self.mp)
	ENDIF

ENDPROC





PROC nextmsg() OF cx
	DEF	msg, msgid, msgtype


	IF msg := GetMsg(self.mp)

		msgid := CxMsgID(msg)
		msgtype := CxMsgType(msg)

		ReplyMsg(msg)

		IF msgtype = CXM_COMMAND

			SELECT msgid

				CASE CXCMD_ENABLE
					ActivateCxObj(self.broker, TRUE)
					RETURN MSG_ENABLE

				CASE CXCMD_DISABLE
					ActivateCxObj(self.broker, FALSE)
					RETURN MSG_DISABLE

				CASE CXCMD_APPEAR
					RETURN MSG_APPEAR

				CASE CXCMD_KILL
					RETURN MSG_QUIT

			ENDSELECT

		ENDIF

	ENDIF


ENDPROC MSG_NO





