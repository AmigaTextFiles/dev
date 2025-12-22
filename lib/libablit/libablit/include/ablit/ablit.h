/*! @addtogroup ablit
 *  @{
 */

/* @file ablit.h
 *
 * The ABLIT library provides a BltBitMap() compatible function call which adds the missing
 * alpha channel and blend support to AmigaOS. If a src bitmap is 32 bit (rgb + a) the src
 * per pixel alpha channel is used to mix the transparent level into the destination.
 * The destionation can be 16/24/32 bit and does not necessarily need an per pixel alpha channel.
 * A per bitmap alpha value can be defined for an additional alpha blend of the source bitmap.
 * On screen bitmaps are slightly slower then in system bitmaps (video mem read speed sucks).
 * HW acceleration is not supported.
 *
 * 8 bit (indexed) bitmaps are not supported.
 *
 * Supported color formats:
 *   SRC: RGBA32, BGRA32, ARGB32, RGB24, BGR24, RGB565
 *   DST: RGB565 (opt), fallback: RGB24, BGR24, RGBA32, BGRA32, ARGB32
 *
 * 565->565 transfers are slightly faster then the AmigaOS internal BltBitMap() call. Alpha blits
 * are not HW accelerated, though.
 *
 * @author: Jürgen Schober
 *
 * @date: 10/31/2005
 *
 * @history:
 *  - 10/31/2005 Version 0.1
 *      - Halloween release
 *  - 11/01/2005 Version 0.2
 *      - new: started work on separate mask bitmap layer. New function can have a seperate 8 bit
 *             alpha channel layer to be attached to any bitmap
 *  - 11/06/2005
 *      - changed blit modes, added BLM_SRC_COLOR_KEY
 *
 *  - 11/19/2005
 *      - finaly rastport blits work. Added BltAlphaBitMapRastport() function
 *      - added a WriteAlphaPixelArray() function someone mentioned on the UtilityBase forum
 */

#ifndef __ABLIT_H__
#define __ABLIT_H__

#include <exec/types.h>

#include <proto/Picasso96API.h>

#ifdef __cplusplus
extern "C" {
#endif

#define BLM_SRC_BLIT        0   // default mode ( alpha + blend + color key )
#define BLM_SRC_ALPHA       1   // alpha only
#define BLM_SRC_BLEND       2   // blend only
#define BLM_SRC_COPY        4   // copy only (no blend, no alpha, no color key - the fastest copy)
#define BML_SRC_COLOR_KEY   8   // force color key

// currently, only 16/32 bit blits are supported. Pixelsize is exact, however
#define HI_32 ( 32 << 16 )
#define HI_24 ( 24 << 16)
#define HI_16 ( 16 << 16 )
#define HI_8  ( 8  << 16)
#define LO_32 ( 32 )
#define LO_24 ( 24 )
#define LO_16 ( 16 )
#define LO_8  ( 8  ) // 8 bit destination is not supported!

#define MAKE_HI_KEY(a) ( a << 16 )
#define MAKE_LO_KEY(a) ( a )

// fallback pixfmt if you want to avoid P96 dependecies
#ifdef __amigaos4__
# define PIXF_ARGB32 RGBFB_A8R8G8B8
# define PIXF_RGBA32 RGBFB_R8G8B8A8
# define PIXF_BGRA32 RGBFB_B8G8R8A8
# define PIXF_ABGR32 RGBFB_A8B8G8R8
#else
# define PIXF_ARGB32 6
# define PIXF_RGBA32 8
# define PIXF_BGRA32 9
# define PIXF_ABGR32 7
#endif

// Inject Alpha Modes
#define INJM_COPY 0    // copy the maks into the alpha channel
#define INJM_ADD  1    // apply a blend on the alpha channel
#define INJM_SUB  2    // subtract the mask from the current alpha

/////////////////////////////////////////////////////////////
// AmigaOS "main" interface

/*! Blit an bitmap with alpha channel to a destination bitmap
 *  For a per pixel alpha channel, the source must be a 32 bit
 *  RGBA, ARGB or BGRA format. An additional per surface alpha
 *  value can be given to blend the source into the dest.
 *  If the source and the dest are 32 bit, the source alpha channel
 *  (without the blend!) will be copied to the dest.
 */
uint32 BltAlphaBitMap( struct BitMap *src,
                       int32 sx, int32 sy,
                       struct BitMap *dst,
                       int32 dx, int32 dy,
                       uint32 w, uint32 h,
                       uint8 blend,
                       uint32 blt_mode );

/*! same as BltAlphaBitMap but clips against a rastport */
uint32 BltAlphaBitMapRastPort( struct BitMap *src,
                               int32 sx, int32 sy,
                               struct RastPort *rp,
                               int32 dx, int32 dy,
                               uint32 w, uint32 h,
                               uint8 blend,
                               uint32 blt_mode );

/*! Blit a bitmap to destination using the attached 8 bit alpha mask.
 *  The mask must have the same size as the src bitmap and is a 8 bit grey
 *  scale bitmap. An additional blend value can be given to blend the src
 *  into the dest. The src does not need to be a RGBA color format.
 *  If the source has an alpha channel already, its alpha channel will be ignored.
 */
uint32 BltBitMapAlphaMask( struct BitMap *src,
                           int32 sx, int32 sy,
                           struct BitMap *dst,
                           int32 dx, int32 dy,
                           uint32 w, uint32 h,
                           struct BitMap* mask,
                           uint8 blend,
                           uint32 blt_mode );

/*! Extract an alpha channel from a given bitmap and return a
 *  8 bit grey scale bitmap with the extracted alpha information.
 *  The bitmap to read from must be in any RGBA, ARGB, BGRA format.
 *  Any other format returns a NULL pointer */
struct BitMap* ExtractAlphaMask( struct BitMap *bitmap,
                                 int32 x, int32 y,
                                 uint32 w, uint32 h );

/*! Add an alpha mask to an existing bitmap. The existing alpha channel
 *  will be replaced. The bitmap and mask bitmap must have the same size.
 *  Position offsets and sizes are not supported. The destination bitmap
 *  mask be any 32bit ARGB, RGBA, BGRA, ABGR formats.
 *  returns the number pixels written */
uint32 InjectAlphaMask( struct BitMap* bitmap,
                        const uint8* mask, uint32 pitch,
                        int32  x, int32  y,
                        uint32 w, uint32 h,
                        uint32 mode );

/*! A similar call to WritePixelArray on cybergraphics in case people want to use
 *  raw RGBA data. */
uint32 WriteAlphaPixelArray( uint32 *src,
                             int32 sx, int32 sy, uint32 pitch,
                             struct RastPort *rp,
                             int32 dx, int32 dy,
                             uint32 w, uint32 h,
                             uint8 blend,
                             uint8 format );


#ifdef __cplusplus
}
#endif

#endif // __ABLIT_H__

