/*! @addtogroup ablit
 *  @{
 */

/* @file ablit_sdl.h
 *
 * ABLIT support library to integrate SDL surfaces into AmigaOS bitmap calls.
 * It also extends SDL_BlitSurface() with a compatible call SDL_BlitAlphaSurface()
 * which is faster under AmigaOS and supports and per surface alpha value together
 * with an per pixel alpha channel (which SDL does not).
 *
 * @author: Jürgen Schober
 *
 * @date: 10/31/2005
 *
 * @history:
 *  - 10/31/2005 - Halloween release
 *
 *  - 11/19/2005 - finaly rastport blits work. Added SDL_BlitAlphaSurfaceRastport() function
 *
 */

#ifndef __ABLIT_SDL_H__
#define __ABLIT_SDL_H__

#include <ablit/ablit.h>

#include <SDL/SDL.h> // remove SDL dependency from main interface

#ifdef __cplusplus
extern "C" {
#endif

/////////////////////////////////////////////////////////////77
// "sdl" SDL interface

/*! Blit an SDL surface to an AmigaOS BitMap
 *  Use a standard SDL surface to blit into a standard Amiga OS struct BitMap.
 *  Bitmap clipping is performed. If the SDL surface has the flag SDL_SRC_ALPHA
 *  set to 1, the src->format->alpha value is used as a alpha blend value.
 *  This will always be the case and differs from the SDL_BlitSurface() function call,
 *  in the way, that in this case, the src pixel format is not relevant.
 *  Per pixel alpha channel (RGB32) with an additional per surface alpha value is
 *  allowed. However, a RGB32 SDL surface always has this flag set to 1 but defaults
 *  the surface->format->alpha to 0 (SDL_ALPHA_TRANSPARENT). This might lead to
 *  the side effect, that our call will not do anything if the alpha is 0.
 *  Always make sure, you call the function with the proper alpha value set!
 *  On 32->32 blits, the per pixel src alpha channel is copied (not the blend value!).
 *
 *  8 bit bitmaps/surfaces as well as RLE surfaces are not supported.
 *
 *  NOTE: blt_mode is ignored for now. Set it to 0L to avoid future incompatibilities.
 *
 */
uint32 SDL_BlitAlphaSurfaceBitMap( SDL_Surface *src,
                                   int32 sx, int32 sy,
                                   struct BitMap *dst,
                                   int32 dx, int32 dy,
                              	   uint32 w, uint32 h,
                                   uint32 blt_mode );

/*! same as SDL_BlitAlphaSurfaceBitmap but clips against a rastport */
uint32 SDL_BlitAlphaSurfaceRastPort( SDL_Surface *src,
                                     int32 sx, int32 sy,
                                     struct RastPort *rp,
                                     int32 dx, int32 dy,
                               	     uint32 w, uint32 h,
                                     uint32 blt_mode );

/*! Same as above (SDL_BlitAlphaSirfaceBitMap), but blits a AmigaOS BitMap into a
 *  SDL_Surface. The per pixel alpha channel is read from an RGB32 bitmap. Make sure you
 *  have no garbage in that layer ! Also, a per bitmap alpha blend value can be given
 *  by an additional parameter "blend". Blend can be used for any src color type (e.g. 16/24/32 bit
 *  depth) and is compined with a per pixel alpha channel, if available.
 *
 *  8 bit bitmaps/surfaces as well as RLE surfaces are not supported.
 *
 *  NOTE: The blt_mode is not used. set it to 0 for now.
 *
 */
uint32 SDL_BlitAlphaBitMapSurface( struct BitMap *src,
                                   int32 sx, int32 sy,
                                   SDL_Surface *dst,
                                   int32 dx, int32 dy,
                                   uint32 w, uint32 h,
                                   uint8 blend,
                                   uint32 blt_mode );

/*! SDL_BlitSurface compatible call using alpha channel and blend.
 *  Warning! This call differs in the way, it allows alpha blend in combination
 *  with an per pixel alpha channel. If the SDL_SRCALPHA flag is set, the
 *  surface->format->alpha value is interpreted as an alpha blend value.
 *  On rgba32 surfaces, this is always true by default but the alpha blend value
 *  is normaly set to 0x00. Which means, without setting that value to SDL_OPAQUE
 *  the surface will not be drawn!
 *
 *  This function is about 2 to 5 times faster than SDL_LowerBlit - and provide bitmap clipping.
 *  Also, it is allowed to pass NULL pointers into *sr and/or *dr. In this case, the bitmap
 *  size will be used, the position will falback to 0/0.
 *
 *  8 bit surfaces as well as RLE surfaces are not supported.
 *
 */
uint32 SDL_BlitAlphaSurface( SDL_Surface *src, SDL_Rect *sr,
                             SDL_Surface *dst, SDL_Rect *dr );

#ifdef __cplusplus
}
#endif

#endif // __ABLIT_SDL_H__

/*! @} */

