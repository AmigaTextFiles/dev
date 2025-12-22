/* ********************** */
/* wbbump_plugin.wbbplugin.e */
/* ********************** */



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
	dummy code to generate wbbump_plugin.m
*/


LIBRARY 'wbbump_plugin.wbbplugin', 1, 0, 'wbbump_plugin.wbbplugin 1.0 (1/5/99)' IS
	pluginInit(A0), pluginCleanup(),
	pluginInitInstance(A0), pluginFreeInstance(A0),
	pluginGetAttr(D1,D2,A0), pluginSetAttr(D1,D2,D3),
	pluginDoAction(A0,A1,A2,A3)





MODULE	'utility/tagitem'



OBJECT handle
	dummy	:	LONG
ENDOBJECT



PROC main()


ENDPROC



PROC close()

ENDPROC



PROC pluginInit(tags:PTR TO tagitem)
ENDPROC


PROC pluginCleanup()
ENDPROC



PROC pluginInitInstance(tags:PTR TO tagitem)

ENDPROC NIL




PROC pluginFreeInstance(h:PTR TO handle)

ENDPROC



PROC pluginGetAttr(h:PTR TO handle, attr, valueptr:PTR TO LONG)
	DEF	succes=FALSE

ENDPROC succes



PROC pluginSetAttr(h:PTR TO handle, attr, value)
	DEF	succes=FALSE

ENDPROC succes




PROC pluginDoAction(h:PTR TO handle, inbuf:PTR TO CHAR, outbuf:PTR TO CHAR, tags:PTR TO tagitem)
ENDPROC
