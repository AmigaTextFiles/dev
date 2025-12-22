/***************************************************************************
 * graphics_pak.h - general-purpose graphics functions to make programming *
 *               alot easier!                                              *
 *               This is the header file for graphics_pak.c                *
 * ----------------------------------------------------------------------- *
 * Author: Paul T. Miller                                                  *
 * ----------------------------------------------------------------------- *
 * Modification History:                                                   *
 * ---------------------                                                   *
 * Date     Comment                                                        *
 * -------- -------                                                        *
 * 05-09-90 Bring over AllocBitMap()/FreeBitMap()
 *
 ***************************************************************************/

#ifndef GRAPHICS_PAK_H
#define GRAPHICS_PAK_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif

#include <exec/memory.h>

#ifndef CHIPMEM
#define CHIPMEM      0x00  /* allocate and use CHIP memory (default) */
#define FASTMEM      0x80  /* use FAST memory (download for display) */
#endif

/* Graphics Constants */
#define LORES_WIDTH     320
#define LORES_HEIGHT    200
#define HIRES_WIDTH     640
#define HIRES_HEIGHT    400
#define LORES_OSCAN_W   362
#define LORES_OSCAN_H   240
#define HIRES_OSCAN_W   740
#define HIRES_OSCAN_H   480
#define MAX_COLORS      64

/* Library flags */
#define GFXBASE         0x0001
#define INTUITIONBASE   0x0002
#define LAYERSBASE      0x0004
#define DISKFONTBASE    0x0008
#define MATHTRANSBASE   0x0010

int OpenLibraries(UWORD);
void CloseLibraries(void);
void DrawPixel(struct RastPort *, int, int, int);
void DrawLine(struct RastPort *, int, int, int, int, int);
void DrawBox(struct RastPort *, int, int, int, int, int);
void FillBox(struct RastPort *, int, int, int, int, int);
void WriteText(struct RastPort *, long, long, char *, long);
struct BitMap *AllocBitMap(USHORT, USHORT, UBYTE, UBYTE);
void FreeBitMap(struct BitMap *);
void MoveBitMap(struct BitMap *, int, int, int, int, struct BitMap *, int, int);
void DrawBitMap(struct BitMap *, int, int, int, int, struct BitMap *);
void CopyBitMap(struct BitMap *, int, int, int, int, struct BitMap *);

#endif   /* GRAPHICS_PAK_H */

