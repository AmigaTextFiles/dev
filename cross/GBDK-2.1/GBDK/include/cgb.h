/*
 * Support for Color GameBoy.
 */

#ifndef _CGB_H
#define _CGB_H

/*
 * Macro to create a palette entry out of the color components.
 */
#define RGB(r, g, b) \
  ((((UWORD)(b) & 0x1f) << 10) | (((UWORD)(g) & 0x1f) << 5) | (((UWORD)(r) & 0x1f) << 0))

/*
 * Set bkg palette(s).
 */
void
set_bkg_palette(UBYTE first_palette,
                UBYTE nb_palettes,
                UWORD *rgb_data);

/*
 * Set sprite palette(s).
 */
void
set_sprite_palette(UBYTE first_palette,
                   UBYTE nb_palettes,
                   UWORD *rgb_data);

/*
 * Set a bkg palette entry.
 */
void
set_bkg_palette_entry(UBYTE palette,
                      UBYTE entry,
                      UWORD rgb_data);

/*
 * Set a sprite palette entry.
 */
void
set_sprite_palette_entry(UBYTE palette,
                         UBYTE entry,
                         UWORD rgb_data);

#endif /* _CGB_H */
