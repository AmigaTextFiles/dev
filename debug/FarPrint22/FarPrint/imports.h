/* $Revision Header *** Header built automatically - do not edit! ***********
 *
 *	(C) Copyright 1992 by Torsten Jürgeleit
 *
 *	Name .....: imports.h
 *	Created ..: Wednesday 12-Feb-92 21:26:46
 *	Revision .: 0
 *
 *	Date        Author                 Comment
 *	=========   ====================   ====================
 *	12-Feb-92   Torsten Jürgeleit      Created this file!
 *
 ****************************************************************************
 *
 *	Imports
 *
 * $Revision Header ********************************************************/

	/* Import from main.c */

IMPORT struct GfxBase		*GfxBase;		/* from arpdetach */
IMPORT struct IntuitionBase	*IntuitionBase;		/* from arpdetach */
IMPORT struct ArpBase		*ArpBase;		/* from arpdetach */
IMPORT struct Library		*IntuiSupBase;

IMPORT struct MsgPort		*far_port;
IMPORT struct FarMessage	*far_req;
IMPORT struct List		far_list;
IMPORT struct FileRequester	*far_fr;
IMPORT struct Window		*far_win;
IMPORT struct TextAttr		topaz60_attr, topaz80_attr;
IMPORT APTR   far_ri, far_ml, far_gl;
IMPORT USHORT far_width, far_height, far_flags;
