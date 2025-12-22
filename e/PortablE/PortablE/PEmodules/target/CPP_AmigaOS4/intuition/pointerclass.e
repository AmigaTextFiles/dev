/* $Id: pointerclass.h,v 1.10 2005/11/10 15:39:41 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types', 'target/intuition/intuition', 'target/utility/tagitem'
{#include <intuition/pointerclass.h>}
NATIVE {INTUITION_POINTERCLASS_H} CONST

/* The following tags are recognized at NewObject() time by
 * pointerclass:
 *
 * POINTERA_BitMap (struct BitMap *) - Pointer to bitmap to
 *    get pointer imagery from.  Bitplane data need not be
 *    in chip RAM.
 * POINTERA_XOffset (LONG) - X-offset of the pointer hotspot.
 * POINTERA_YOffset (LONG) - Y-offset of the pointer hotspot.
 * POINTERA_WordWidth (ULONG) - designed width of the pointer in words
 * POINTERA_XResolution (ULONG) - one of the POINTERXRESN_ flags below
 * POINTERA_YResolution (ULONG) - one of the POINTERYRESN_ flags below
 *
 */

NATIVE {POINTERA_Dummy}       CONST POINTERA_DUMMY       = (TAG_USER + $39000)

NATIVE {POINTERA_BitMap}      CONST POINTERA_BITMAP      = (POINTERA_DUMMY + $01)
NATIVE {POINTERA_XOffset}     CONST POINTERA_XOFFSET     = (POINTERA_DUMMY + $02)
NATIVE {POINTERA_YOffset}     CONST POINTERA_YOFFSET     = (POINTERA_DUMMY + $03)
NATIVE {POINTERA_WordWidth}   CONST POINTERA_WORDWIDTH   = (POINTERA_DUMMY + $04)
NATIVE {POINTERA_XResolution} CONST POINTERA_XRESOLUTION = (POINTERA_DUMMY + $05)
NATIVE {POINTERA_YResolution} CONST POINTERA_YRESOLUTION = (POINTERA_DUMMY + $06)

/* These are the choices for the POINTERA_XResolution attribute which
 * will determine what resolution pixels are used for this pointer.
 *
 * POINTERXRESN_DEFAULT (ECS-compatible pointer width)
 *    = 70 ns if SUPERHIRES-type mode, 140 ns if not
 *
 * POINTERXRESN_SCREENRES
 *    = Same as pixel speed of screen
 *
 * POINTERXRESN_LORES (pointer always in lores-like pixels)
 *    = 140 ns in 15kHz modes, 70 ns in 31kHz modes
 *
 * POINTERXRESN_HIRES (pointer always in hires-like pixels)
 *    = 70 ns in 15kHz modes, 35 ns in 31kHz modes
 *
 * POINTERXRESN_140NS (pointer always in 140 ns pixels)
 *    = 140 ns always
 *
 * POINTERXRESN_70NS (pointer always in 70 ns pixels)
 *    = 70 ns always
 *
 * POINTERXRESN_35NS (pointer always in 35 ns pixels)
 *    = 35 ns always
 */

NATIVE {POINTERXRESN_DEFAULT}   CONST POINTERXRESN_DEFAULT   = 0
NATIVE {POINTERXRESN_140NS}     CONST POINTERXRESN_140NS     = 1
NATIVE {POINTERXRESN_70NS}      CONST POINTERXRESN_70NS      = 2
NATIVE {POINTERXRESN_35NS}      CONST POINTERXRESN_35NS      = 3

NATIVE {POINTERXRESN_SCREENRES} CONST POINTERXRESN_SCREENRES = 4
NATIVE {POINTERXRESN_LORES}     CONST POINTERXRESN_LORES     = 5
NATIVE {POINTERXRESN_HIRES}     CONST POINTERXRESN_HIRES     = 6

/* These are the choices for the POINTERA_YResolution attribute which
 * will determine what vertical resolution is used for this pointer.
 *
 * POINTERYRESN_DEFAULT
 *    = In 15 kHz modes, the pointer resolution will be the same
 *      as a non-interlaced screen.  In 31 kHz modes, the pointer
 *      will be doubled vertically.  This means there will be about
 *      200-256 pointer lines per screen.
 *
 * POINTERYRESN_HIGH
 * POINTERYRESN_HIGHASPECT
 *    = Where the hardware/software supports it, the pointer resolution
 *      will be high.  This means there will be about 400-480 pointer
 *      lines per screen.  POINTERYRESN_HIGHASPECT also means that
 *      when the pointer comes out double-height due to hardware/software
 *      restrictions, its width would be doubled as well, if possible
 *      (to preserve aspect).
 *
 * POINTERYRESN_SCREENRES
 * POINTERYRESN_SCREENRESASPECT
 *    = Will attempt to match the vertical resolution of the pointer
 *      to the screen's vertical resolution.    POINTERYRESN_SCREENASPECT also
 *      means that when the pointer comes out double-height due to
 *      hardware/software restrictions, its width would be doubled as well,
 *      if possible (to preserve aspect).
 *
 */

NATIVE {POINTERYRESN_DEFAULT}         CONST POINTERYRESN_DEFAULT         = 0
NATIVE {POINTERYRESN_HIGH}            CONST POINTERYRESN_HIGH            = 2
NATIVE {POINTERYRESN_HIGHASPECT}      CONST POINTERYRESN_HIGHASPECT      = 3
NATIVE {POINTERYRESN_SCREENRES}       CONST POINTERYRESN_SCREENRES       = 4
NATIVE {POINTERYRESN_SCREENRESASPECT} CONST POINTERYRESN_SCREENRESASPECT = 5

/* Compatibility note:
 *
 * The AA chipset supports variable sprite width and resolution, but
 * the setting of width and resolution is global for all sprites.
 * When no other sprites are in use, Intuition controls the sprite
 * width and sprite resolution for correctness based on pointerclass
 * attributes specified by the creator of the pointer.    Intuition
 * controls sprite resolution with the VTAG_DEFSPRITERESN_SET tag
 * to VideoControl().  Applications can override this on a per-viewport
 * basis with the VTAG_SPRITERESN_SET tag to VideoControl().
 *
 * If an application uses a sprite other than the pointer sprite,
 * Intuition will automatically regenerate the pointer sprite's image in
 * a compatible width.    This might involve BitMap scaling of the imagery
 * you supply.
 *
 * If any sprites other than the pointer sprite were obtained with the
 * old GetSprite() call, Intuition assumes that the owner of those
 * sprites is unaware of sprite resolution, hence Intuition will set the
 * default sprite resolution (VTAG_DEFSPRITERESN_SET) to ECS-compatible,
 * instead of as requested by the various pointerclass attributes.
 *
 * No resolution fallback occurs when applications use ExtSprites.
 * Such applications are expected to use VTAG_SPRITERESN_SET tag if
 * necessary.
 *
 * NB:    Under release V39, only sprite width compatibility is implemented.
 * Sprite resolution compatibility was added for V40.
 */
