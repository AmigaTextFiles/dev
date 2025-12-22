/* ******** */
/* wbbump.e */
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



MODULE	'dos/dos'	-> SIGBREAKF_CTRL_C


MODULE	'*bumper',
		'*get_bumper',
		'*prefs',
		'*errors',
		'*version',
		'*commodity',
		'*pluginmanager',
		'*libs'


PROC main() HANDLE
	DEF	p=NIL:PTR TO prefs,
		b=NIL:PTR TO bumper,
		cx=NIL:PTR TO cx,
		oldpri="nset",
		enabled=TRUE,
		done=FALSE,
		reload=FALSE,
		plist=NIL:PTR TO pluginlist,
		cmd

	open_libs()

	REPEAT

		NEW plist.pluginlist()
		plist.loadall()

		NEW p.read_prefs()

		NEW cx.cx(p)

		Delay(p.startdelay * 50)

		oldpri := SetTaskPri(FindTask(NIL), p.taskpri)

		b := get_bumper(p, plist)

		reload := FALSE

		REPEAT
			WHILE cmd := cx.nextmsg()
				SELECT cmd
					CASE MSG_QUIT
						done := TRUE
					CASE MSG_ENABLE
						enabled := TRUE
					CASE MSG_DISABLE
						enabled := FALSE
					CASE MSG_APPEAR
						p.edit()
				ENDSELECT
			ENDWHILE

			IF enabled

				b.update()

			ELSE

				Wait(SIGBREAKF_CTRL_C OR cx.sigflag)

			ENDIF

			IF p.haschanged() THEN reload := TRUE

		UNTIL (SetSignal(0,0) AND SIGBREAKF_CTRL_C) OR done OR reload

		END cx;	cx := NIL
		END b;	b := NIL
		END p;	p := NIL
		END plist; plist := NIL

	UNTIL (SetSignal(0,0) AND SIGBREAKF_CTRL_C) OR done

EXCEPT DO
	IF oldpri <> "nset" THEN SetTaskPri(FindTask(NIL), oldpri)

	END cx
	END b
	END p

	END plist

	close_libs()

	IF exception THEN show_error(exception, exceptioninfo)
ENDPROC



