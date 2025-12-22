/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  vgalib.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/impl/x_basic.h>
#include <LEDA/bitmaps/leda_icon.xbm>

#include <stdlib.h>
#include <string.h>
#include <math.h>


#if defined(__TURBOC__)
struct WORDREGS { unsigned int    ax, bx, cx, dx, si, di, cflag, flags; };
struct BYTEREGS { unsigned char   al, ah, bl, bh, cl, ch, dl, dh; };
union  REGS { struct  WORDREGS x; struct  BYTEREGS h; };
extern "C" int  int86( int __intno, union REGS _FAR *, union REGS _FAR *);
extern "C" unsigned char inportb(int port_id);
extern "C" void outportb(int portid, unsigned char value);
extern "C" int getch( void );
extern "C" int kbhit( void );
#define MK_FP( seg,ofs )( (void _seg * )( seg ) +( void near * )( ofs ))
#else
#include <dos.h>
#if defined(__GNUG__)
#include <pc.h>
#else
#include <conio.h>
#endif
#endif

#if defined(__GNUG__)
#define port_out(value,port) outportb(port,value)
#define port_in(port)  inportb(port)
#else
#if defined(__TURBOC__)
#define port_out(value,port) outportb(port,value)
#define port_in(port)  inportb(port)
#else
#define port_out(value,port) outp(port,value)
#define port_in(port)  inp(port)
#endif
#endif


#define GRA_I 0x3CE
#define GRA_D 0x3CF

extern VIDEO_PTR  VIDEO;
extern int DISP_WIDTH;
extern int DISP_MAX_X;
extern int LINE_BYTES;

extern int DISP_HEIGHT;
extern int DISP_MAX_Y;

extern int DISP_DEPTH;

void vga_init(int mode, int root_col);

