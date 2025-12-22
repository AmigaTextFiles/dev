/* ************ */
/* get_bumper.e */
/* ************ */



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
OPT	PREPROCESS


#define CYBRMATTR_XMOD        $80000001 /* function returns BytesPerRow if its called with this parameter */
#define CYBRMATTR_BPPIX       $80000002 /* BytesPerPixel shall be returned */
#define CYBRMATTR_DISPADR     $80000003 /* do not use this ! private tag */
#define CYBRMATTR_PIXFMT      $80000004 /* the pixel format is returned */
#define CYBRMATTR_WIDTH       $80000005 /* returns width in pixels */
#define CYBRMATTR_HEIGHT      $80000006 /* returns height in lines */
#define CYBRMATTR_DEPTH       $80000007 /* returns bits per pixel */
#define CYBRMATTR_ISCYBERGFX  $80000008 /* returns -1 if supplied bitmap is a cybergfx one */
#define CYBRMATTR_ISLINEARMEM $80000009 /* returns -1 if supplied bitmap is linear accessable */


MODULE	'cybergraphics',
		'libraries/cybergraphics',

		'intuition/intuition',
		'intuition/screens',

		'graphics/gfx',
		'graphics/rastport'


MODULE	'*bumper',
		'*bumper_cgx8',
		'*bumper_cgx24',
		'*prefs',
		'*plugin',
		'*pluginmanager',
		'*errors'



EXPORT PROC get_bumper(p:PTR TO prefs, plist:PTR TO pluginlist) HANDLE
	DEF	b_cgx8=NIL:PTR TO bumper_cgx8,
		b_cgx24=NIL:PTR TO bumper_cgx24,
		s=NIL:PTR TO screen

	s := LockPubScreen(p.scrname)
	IF s=NIL THEN eThrow(ERR_LOCKSCR, 'Unable to lock screen: "%s"', [p.scrname])

	IF (cybergfxbase <> NIL)

		IF GetCyberMapAttr(s.rastport.bitmap, CYBRMATTR_ISCYBERGFX)

			IF GetCyberMapAttr(s.rastport.bitmap, CYBRMATTR_PIXFMT) <> PIXFMT_LUT8

				UnlockPubScreen(NIL, s); s := NIL
				NEW b_cgx24.bumper_cgx24(p, plist)
				RETURN b_cgx24

			ENDIF

		ENDIF

	ENDIF

	UnlockPubScreen(NIL, s); s := NIL
	NEW b_cgx8.bumper_cgx8(p, plist)
	RETURN b_cgx8

	eThrow(ERR_BADSCREEN, 'Bad screen: "%s"', [p.scrname])

EXCEPT DO
	IF s THEN UnlockPubScreen(NIL, s)
	IF exception
		END b_cgx8
	ENDIF
	ReThrow()
ENDPROC 0



