/* *********** */
/* argparser.e */
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


/*
	helper module for parsing args
*/


OPT MODULE


MODULE	'dos/dos'
MODULE	'dos/rdargs'



EXPORT PROC parseargs(template,array,string) HANDLE
	DEF	rdargs=NIL:PTR TO rdargs,
		tempstr=NIL:PTR TO CHAR,
		templen

	IF string[StrLen(string)-1] <> 10
		templen := StrLen(string)
		tempstr := NewR(templen+2)
		CopyMem(string,tempstr,templen+1)
		tempstr[templen] := 10
	ELSE
		tempstr := string
	ENDIF

	IF (rdargs := AllocDosObject(DOS_RDARGS,NIL)) = NIL THEN Raise("MEM")

	rdargs.source.buffer := tempstr
	rdargs.source.length := StrLen(tempstr)
	rdargs.source.curchr := NIL
	rdargs.dalist := NIL
	rdargs.flags := RDAF_NOPROMPT

	IF ReadArgs(template,array,rdargs) = NIL THEN Raise("ARGS")

EXCEPT DO
	IF exception THEN RETURN 0
ENDPROC rdargs

EXPORT PROC freeargs(rdargs)
	IF rdargs <> NIL
		FreeArgs(rdargs)
		IF rdargs THEN FreeDosObject(DOS_RDARGS,rdargs)
	ENDIF
ENDPROC
