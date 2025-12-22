/* ************* */
/* chunkyimage.e */
/* ************* */



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
	NOTE:
		cgx library must be open!

		utility.library must be open

		datatypes.library must be open
*/


OPT MODULE




MODULE	'intuition/intuition',
		'intuition/screens',
		'intuition/gadgetclass',

		'exec/memory',

		'graphics/gfx',
		'graphics/rastport',
		'graphics/view',

		'utility',
		'utility/tagitem',

		'cybergraphics',
		'cybergraphx/cybergraphics',

		'datatypes',
		'datatypes/datatypes',
		'datatypes/datatypesclass',
		'datatypes/pictureclass',

		'amigalib/boopsi',

		'dos/dos'


MODULE	'*errors',
		'*threads',
		'*chunkytools'



EXPORT CONST	CIMGTYP_8BIT	= RECTFMT_LUT8,
				CIMGTYP_RGB		= RECTFMT_RGB



EXPORT ENUM	CIMGTAG_LOCK_BUF=TAG_USER

EXPORT ENUM	CIMG_WRITE_ASYNC=TAG_USER,
			CIMG_WRITE_LPB


ENUM	CIMG_TCMD_WRITEFULL = TCMD_USER


EXPORT OBJECT cimg
PRIVATE
	buffer	:	PTR TO CHAR

	/* next two are only used if async calls are made */
	thread	:	PTR TO thread
	job		:	PTR TO job

	temprp	:	PTR TO rastport
	
PUBLIC
	type	:	LONG
	width	:	LONG	-> in pixels
	height	:	LONG	-> in pixels
	bpp		:	INT		-> bytes per pixel
ENDOBJECT



/* allocate a new chunky image */
PROC alloc(width, height, type, tags=NIL:PTR TO tagitem) OF cimg HANDLE

	self.thread := NIL
	self.job := NIL


	SELECT type
	CASE CIMGTYP_8BIT
		self.bpp := 1
	CASE CIMGTYP_RGB
		self.bpp := 3
	DEFAULT
		eThrow(ERR_INTERNAL, 'Unsupported chunky format in .alloc() (type was %ld)', [type])
	ENDSELECT

	self.type := type
	self.width := width
	self.height := height
	self.buffer := NewR(self.bpp * self.width * self.height)
EXCEPT DO
	ReThrow()
ENDPROC




PROC createthread() OF cimg HANDLE
	IF self.thread = NIL
		NEW self.thread.create({cimg_thread}, 'blit thread', [
			TTAG_CREATE_APENDNAME, TRUE,
			TTAG_CREATE_RELATIVEPRI, 1,
			NIL])
	ENDIF
EXCEPT DO
	ReThrow()
ENDPROC



PROC read_full(rp:PTR TO rastport, x, y) OF cimg HANDLE
	DEF	type,
		temprp=NIL


	type := self.type
	SELECT type
	CASE CIMGTYP_8BIT

		temprp := alloc_temprp(rp, self.width)

		rastport2chunky(rp, self.buffer, x, y, self.width, self.height, temprp)

	CASE CIMGTYP_RGB
		ReadPixelArray(self.buffer, 0, 0, self.bpp * self.width, rp, x, y, self.width, self.height,	RECTFMT_RGB)

	DEFAULT
		eThrow(ERR_INTERNAL, 'Unsuported cimg.type (%ld)', [type])

	ENDSELECT
			

EXCEPT DO
	IF temprp THEN free_temprp(temprp)
	ReThrow()
ENDPROC


PROC write_full(rp, x, y, tags=NIL:PTR TO tagitem) OF cimg HANDLE
	DEF	async=FALSE,
		lines_per_blit=0,
		type,
		iy,
		the_rest,
		temprp=NIL

	IF tags
		async := GetTagData(CIMG_WRITE_ASYNC, FALSE, tags)
		lines_per_blit := GetTagData(CIMG_WRITE_LPB, 0, tags)
	ENDIF

/* testing */
async := FALSE

	IF async

		IF self.thread = NIL THEN self.createthread()

		IF self.job THEN self.thread.waitjob(self.job)

		self.job := self.thread.sendjob(CIMG_TCMD_WRITEFULL, [self, rp, x, y, lines_per_blit])

	ELSE

		type := self.type

		SELECT type
		CASE CIMGTYP_8BIT

			temprp := alloc_temprp(rp, self.width)

			chunky2rastport(rp, self.buffer, 0, 0, self.width, self.height, temprp)

		CASE CIMGTYP_RGB

			IF lines_per_blit < 1
				WritePixelArray(self.buffer, 0, 0, self.width * self.bpp, rp, x, y, self.width, self.height, self.type)
			ELSE
				the_rest := Mod(self.height, lines_per_blit)
				FOR iy := 0 TO (self.height / lines_per_blit)-1
					WritePixelArray(self.buffer, 0, iy * lines_per_blit, self.width * self.bpp, rp, x, y + (iy * lines_per_blit), self.width, lines_per_blit, self.type)
				ENDFOR
				WritePixelArray(self.buffer, 0, self.height - the_rest - 1, self.width * self.bpp, rp, x, y + self.height - the_rest - 1, self.width, the_rest, self.type)
			ENDIF

		DEFAULT
			eThrow(ERR_INTERNAL, 'Unsupported chunky format in .write_full() (type was %ld)', [type])
		ENDSELECT

	ENDIF

EXCEPT DO
	IF temprp THEN free_temprp(temprp)
	ReThrow()
ENDPROC





PROC newfromDT(filename) OF cimg HANDLE
	DEF	dto=NIL,						-> datatype object
		bm=NIL:PTR TO bitmap,			-> bitmap of datatype object
		bmh=NIL:PTR TO bitmapheader,	-> bitmapheader of datatype object
		gpl=NIL:PTR TO gplayout,
		ncol,							-> number of colors in dt picture
		buf=NIL,
		width, height



	self.thread := NIL
	self.job := NIL


	/* load the freak'n picture */

	dto := NewDTObjectA(filename, [

		DTA_GROUPID, GID_PICTURE,

		PDTA_REMAP, FALSE,

		NIL])

	IF dto = NIL THEN eThrow(ERR_DT, 'Unable to load file: "%s"', [filename])


	/* perform gplayout method (else we wont get a bitmap) */

	NEW gpl
	gpl.methodid := DTM_PROCLAYOUT
	gpl.ginfo := NIL
	gpl.initial := 1

	IF doMethodA(dto, gpl) = 0 THEN Throw(ERR_DT, 'Error during ProcLayout method')



	/* get attrs */

	GetDTAttrsA(dto, [
		PDTA_BITMAPHEADER,	{bmh},
		PDTA_BITMAP,		{bm},
		PDTA_NUMCOLORS,		{ncol},
		DTA_NOMINALHORIZ,	{width},
		DTA_NOMINALVERT,	{height},
		NIL])


	/* alloc a buffer of needed dimensions */

	self.alloc(bmh.width, bmh.height, CIMGTYP_8BIT)


	/* get direct access */

	IF self.lock([CIMGTAG_LOCK_BUF, {buf}, NIL]) = FALSE THEN Raise(ERR_LOCKCIMG)


	/* convert to chunky */

	bitmap2chunky(bm, buf, 0, 0, self.width, self.height)


EXCEPT DO
	IF dto THEN DisposeDTObject(dto)
	IF buf THEN self.unlock()
	ReThrow()
ENDPROC











PROC lock(tags:PTR TO tagitem) OF cimg
	DEF	buf:PTR TO LONG

	buf := GetTagData(CIMGTAG_LOCK_BUF, 0, tags)

	IF buf THEN buf[0] := self.buffer
ENDPROC TRUE


PROC unlock() OF cimg IS NIL





PROC end() OF cimg
	END self.thread
	IF self.buffer THEN Dispose(self.buffer)
ENDPROC










/* thread code */


PROC cimg_thread(thread:PTR TO thread, job:PTR TO job)
	DEF	cmd,
		iy,
		type,
		lines_per_blit,
		the_rest,
		temprp=NIL,
		cimg:PTR TO cimg,
		rp,
		x, y

	cimg := job.input[0]
	rp := job.input[1]
	x := job.input[2]
	y := job.input[3]
	lines_per_blit := job.input[4]

	cmd := job.command

	SELECT cmd
	CASE CIMG_TCMD_WRITEFULL
		type := cimg.type

		SELECT type
		CASE CIMGTYP_8BIT

			temprp := alloc_temprp(rp, cimg.width)

			chunky2rastport(rp, cimg.buffer, 0, 0, cimg.width, cimg.height, temprp)

		CASE CIMGTYP_RGB

			IF lines_per_blit < 1
				WritePixelArray(cimg.buffer, 0, 0,  cimg.width * cimg.bpp, rp, x, y, cimg.width, cimg.height, cimg.type)
			ELSE
				the_rest := Mod(cimg.height, lines_per_blit)
				FOR iy := 0 TO (cimg.height / lines_per_blit)-1
					WritePixelArray(cimg.buffer, 0, iy * lines_per_blit,  cimg.width * cimg.bpp, rp, x, y + (iy * lines_per_blit), cimg.width, lines_per_blit, cimg.type)
				ENDFOR
				WritePixelArray(cimg.buffer, 0, cimg.height - the_rest - 1, cimg.width * cimg.bpp, rp, x, y + cimg.height - the_rest - 1, cimg.width, the_rest, cimg.type)
			ENDIF

		DEFAULT
			eThrow(ERR_INTERNAL, 'Unsupported chunky format in .write_full() (type was %ld)', [type])
		ENDSELECT

	ENDSELECT

	free_temprp(temprp)

ENDPROC TRUE


