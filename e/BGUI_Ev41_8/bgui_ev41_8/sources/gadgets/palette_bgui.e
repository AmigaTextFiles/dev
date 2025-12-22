/*
 *  $VER: gadgets/palette_bgui.m 2.1 (24.12.95)
 *  AmigaE module for the BOOPSI (BGUI) palette_bgui.gadget class.
 *
 *  (C) Copyright 1995-1996 Jaba Development.
 *  (C) Copyright 1995-1996 Jan van den Baard.
 *      All Rights Reserved.
 *
 *  Modified by Dominique Dutoit, 01.05.96.
 */

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE  'utility/tagitem'

#define BGUIPALETTENAME         'gadgets/palette_bgui.gadget'
CONST   BGUIPALETTEVERSION      = 2

CONST   PALETTE_Depth           = TAG_USER+$70000+41, /* I---- */
        PALETTE_ColorOffset     = TAG_USER+$70000+42, /* I---- */
        PALETTE_PenTable        = TAG_USER+$70000+43, /* I---- */
        PALETTE_CurrentColor    = TAG_USER+$70000+44  /* ISGNU */

CONST   PALETTE_DEPTH           = TAG_USER+$70000+41, /* I---- */
        PALETTE_COLOROFFSET     = TAG_USER+$70000+42, /* I---- */
        PALETTE_PENTABLE        = TAG_USER+$70000+43, /* I---- */
        PALETTE_CURRENTCOLOR    = TAG_USER+$70000+44  /* ISGNU */
