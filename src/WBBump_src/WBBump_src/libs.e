/* ****** */
/* libs.e */
/* ****** */



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


MODULE	'utility',
		'cybergraphics',
		'icon',
		'commodities',
		'datatypes',
		'wb'

MODULE	'*errors'


EXPORT PROC open_libs() HANDLE
	utilitybase := OpenLibrary('utility.library', 39)
	cybergfxbase := OpenLibrary('cybergraphics.library', 39)
	iconbase := OpenLibrary('icon.library', 39)
	cxbase := OpenLibrary('commodities.library', 37)
	datatypesbase := OpenLibrary('datatypes.library', 39)
	workbenchbase := OpenLibrary('workbench.library', 39)

	IF utilitybase = NIL THEN Raise(ERR_UTILLIB)
->	IF cybergfxbase = NIL THEN Raise(ERR_CGXLIB)
	IF iconbase = NIL THEN Raise(ERR_ICONLIB)
	IF cxbase = NIL THEN Raise(ERR_CXLIB)
	IF datatypesbase = NIL THEN Raise(ERR_DTLIB)
	IF workbenchbase = NIL THEN Raise(ERR_WBLIB)
EXCEPT DO
	ReThrow()
ENDPROC


EXPORT PROC close_libs()
	IF utilitybase THEN CloseLibrary(utilitybase)
	IF cybergfxbase THEN CloseLibrary(cybergfxbase)
	IF iconbase THEN CloseLibrary(iconbase)
	IF cxbase THEN CloseLibrary(cxbase)
	IF datatypesbase THEN CloseLibrary(datatypesbase)
	IF workbenchbase THEN CloseLibrary(workbenchbase)
ENDPROC

