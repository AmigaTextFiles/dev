/* ******** */
/* Notify.e */
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


MODULE	'dos/notify'


EXPORT OBJECT notify OF notifyrequest
	succes
ENDOBJECT


PROC notify(filename:PTR TO CHAR) OF notify HANDLE
	DEF	signum=-1

	self.succes := TRUE

	self.name := filename
	self.flags := NRF_SEND_SIGNAL
	self.port := FindTask(NIL)
	signum := AllocSignal(-1)
	IF self.signalnum = -1 THEN Raise(-1)
	self.signalnum := signum

	IF StartNotify(self) = FALSE THEN Raise(-1)

EXCEPT DO
	IF exception THEN self.succes := FALSE
ENDPROC


PROC end() OF notify
	IF self.succes THEN EndNotify(self)
ENDPROC


PROC haschanged() OF notify
	IF self.succes
		IF (SetSignal(0, Shl(1, self.signalnum)) AND Shl(1, self.signalnum)) THEN RETURN TRUE
	ENDIF
ENDPROC FALSE

PROC waitchange(othersigs=NIL) OF notify
	IF self.succes
		Wait(othersigs OR Shl(1, self.signalnum))
	ENDIF
ENDPROC

