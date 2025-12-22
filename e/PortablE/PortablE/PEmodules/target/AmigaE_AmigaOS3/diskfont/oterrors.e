/* $VER: oterrors.h 8.1 (19.6.1992) */
OPT NATIVE
{MODULE 'diskfont/oterrors'}

/* PRELIMINARY */
NATIVE {OTERR_FAILURE}		CONST OTERR_FAILURE		= -1	/* catch-all for error */
NATIVE {OTERR_SUCCESS}		CONST OTERR_SUCCESS		= 0	/* no error */
NATIVE {OTERR_BADTAG}		CONST OTERR_BADTAG		= 1	/* inappropriate tag for function */
NATIVE {OTERR_UNKNOWNTAG}	CONST OTERR_UNKNOWNTAG	= 2	/* unknown tag for function */
NATIVE {OTERR_BADDATA}		CONST OTERR_BADDATA		= 3	/* catch-all for bad tag data */
NATIVE {OTERR_NOMEMORY}		CONST OTERR_NOMEMORY		= 4	/* insufficient memory for operation */
NATIVE {OTERR_NOFACE}		CONST OTERR_NOFACE		= 5	/* no typeface currently specified */
NATIVE {OTERR_BADFACE}		CONST OTERR_BADFACE		= 6	/* typeface specification problem */
NATIVE {OTERR_NOGLYPH}		CONST OTERR_NOGLYPH		= 7	/* no glyph specified */
NATIVE {OTERR_BADGLYPH}		CONST OTERR_BADGLYPH		= 8	/* bad glyph code or glyph range */
NATIVE {OTERR_NOSHEAR}		CONST OTERR_NOSHEAR		= 9	/* shear only partially specified */
NATIVE {OTERR_NOROTATE}		CONST OTERR_NOROTATE		= 10	/* rotate only partially specified */
NATIVE {OTERR_TOOSMALL}		CONST OTERR_TOOSMALL		= 11	/* typeface metrics yield tiny glyphs */
NATIVE {OTERR_UNKNOWNGLYPH}	CONST OTERR_UNKNOWNGLYPH	= 12	/* glyph not known by engine */
