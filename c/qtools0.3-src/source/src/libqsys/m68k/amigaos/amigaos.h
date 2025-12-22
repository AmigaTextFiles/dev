/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#ifndef	AMIGAOS_H
#define	AMIGAOS_H

#define	BASEWIDTH	80
#define	BASEHEIGHT	50
#define	MAXWIDTH	1280
#define	MAXHEIGHT	800

#define	DRIVER_8BIT
#define	DRIVER_16BIT
#define	DRIVER_24BIT
/* #define	DRIVER_32BIT */
#define	DRIVER_DEFAULT	8

#ifdef LIBQSYS_DRIVER
#include <clib/alib_protos.h>
#ifndef	NOASM
#include <inline/asl.h>
#include <inline/dos.h>
#include <inline/cybergraphx.h>
#include <inline/exec.h>
#include <inline/graphics.h>
#include <inline/intuition.h>
#include <inline/timer.h>
#else
#include <clib/asl_protos.h>
#include <clib/dos_protos.h>
#include <clib/cybergraphx_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/timer_protos.h>
#endif

#include <cybergraphx/cybergraphx.h>				/* CyberGraphics display */
#include <devices/input.h>
#include <devices/inputevent.h>
#include <devices/timer.h>
#include <dos/dos.h>						/* Lock() */
#include <dos/dosextens.h>					/* Lock() */
#include <exec/execbase.h>
#include <exec/interrupts.h>
#include <exec/memory.h>
#include <exec/nodes.h>
#include <exec/ports.h>
#include <exec/types.h>
#include <graphics/gfx.h>					/* BitMap funtions */
#include <graphics/gfxbase.h>
#include <graphics/modeid.h>
#include <hardware/blit.h>
#include <intuition/screens.h>					/* OpenScreen() */
#include <intuition/intuition.h>				/* OpenWindow() */
#include <intuition/intuitionbase.h>
#include <libraries/asl.h>					/* ASLRequester */
#include <utility/hooks.h>
#endif

#if defined(REPLACE_STDIO)
# undef		 FILE
# define	 FILE BPTR
# undef 	 READ_BINARY
# define	 READ_BINARY MODE_OLDFILE
# undef 	 WRITE_BINARY
# define	 WRITE_BINARY MODE_NEWFILE
# undef 	 READ_BINARY_NEW
# define	 READ_BINARY_NEW MODE_READWRITE
# undef 	 WRITE_BINARY_NEW
# define	 WRITE_BINARY_NEW MODE_READWRITE
# undef 	 SEEK_SET
# define	 SEEK_SET OFFSET_BEGINNING
# undef 	 SEEK_CUR
# define	 SEEK_CUR OFFSET_CURRENT
# undef 	 SEEK_END
# define	 SEEK_END OFFSET_END
# undef 	 fopen
# define	 fopen(name, mode) Open(name, mode)
# undef 	 fclose
# define	 fclose(handle) Close(handle)
# undef 	 fread
# define	 fread(buffer, length1, length2, handle) Read(handle, buffer, length1 * length2)
# undef 	 fwrite
# define	 fwrite(buffer, length1, length2, handle) Write(handle, buffer, length1 * length2)
# undef 	 fseek
# define	 fseek(handle, position, mode) Seek(handle, position, mode)
#endif

#if defined(REPLACE_MEMPOOLS)
# include <inline/exec.h>
# include <exec/memory.h>
extern struct ExecBase *SysBase;
extern void *__memPool;

# undef		malloc
# define	malloc(size) AllocVecPooled(__memPool, size);
# undef		free
# define	free(ptr) FreeVecPooled(__memPool, ptr);
#endif

#define	OPENDISPLAY
#define	SWAPDISPLAY
#define	UPDATEDISPLAY
#define	CHANGEDISPLAY
#define	CLOSEDISPLAY

#define	OPENKEYS
#define	GETKEYS
#define	CLOSEKEYS

/*
 * ============================================================================
 * structures
 * ============================================================================
 */

struct driverPrivate {
  struct nnode drvNode;
  struct DisplayDimension *displayDim;

  short int ScreenLeft;
  short int ScreenTop;
  short int ScreenWidth;
  short int ScreenHeight;
  char ScreenDepth;
  char ScreenLog;

  void *FrameBuffer;					/* actual framebufferaddress */
  struct BitMap *FrameBitMap;				/* actual framebufferbitmap */
  void *FrameHandle;

#ifdef	USE_ZBUFFER
  unsigned short int *ZBuffer;
#endif
  int FrameSize;					/* size of updateregion in bytes */
  unsigned char FrameFormat;				/* default RECTFMT_LUT8   ? */
  short int BytesPerRow;				/* default            8/8 ? */
  short int BytesPerPel;				/* default            8/8 ? */

  struct Screen *Screen;
  struct Window *Window;
  struct ViewPort *ViewPort;
  struct RastPort *RastPort;

#define SAVEBACK_COLORS (256 * 3)
  unsigned short int oldNFree, oldShareable;
  long unsigned int OldColorMap[1 + (256 * 3) + SAVEBACK_COLORS];
  long unsigned int NewColorMap[1 + (256 * 3) + SAVEBACK_COLORS];	/* LoadRGB32-Palette */

  struct MsgPort *inputPort;
};

/*
 * ============================================================================
 * globals
 * ============================================================================
 */

/*
 * ============================================================================
 * prototypes
 * ============================================================================
 */

#endif
