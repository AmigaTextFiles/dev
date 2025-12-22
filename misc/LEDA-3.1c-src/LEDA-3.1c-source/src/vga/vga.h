/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  vga.h
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


#if defined(__MSDOS__) || defined(__ZTC__)

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

#else
// LINUX
struct WORDREGS { unsigned int    ax, bx, cx, dx, si, di, cflag, flags; };
struct BYTEREGS { unsigned char   al, ah, bl, bh, cl, ch, dl, dh; };
union  REGS { struct  WORDREGS x; struct  BYTEREGS h; };

inline int  int86(int, REGS*, REGS*) {}

static inline void port_out( int value, int port )
{
	__asm__ volatile ("outb %0,%1"
	: : "a" ((unsigned char)value), "d" ((unsigned short)port));
}

static inline void port_outw( int value, int port )
{
	__asm__ volatile("outw %0,%1"
	: : "a" ((unsigned short)value), "d" ((unsigned short)port));
}

static inline int port_in( int port )
{
	unsigned char value;
	__asm__ volatile ("inb %1,%0"
		: "=a" (value)
		: "d" ((unsigned short)port));
	return value;
}

extern char getch();

#endif


#define GRA_I 0x3CE
#define GRA_D 0x3CF

#if defined (__ZTC__) || defined(__TURBOC__)
typedef unsigned char far* VIDEO_PTR;
#else
typedef unsigned char* VIDEO_PTR;
#endif

struct vga_window
{
 VIDEO_PTR plane[4];
 int       width;
 int       height;
 int       xpos;
 int       ypos;
 int       x0;
 int       y0;
 int       x1;
 int       y1;
 int       bg_col;
 int       label_col;
 char      header[128];
 char      label[128];
 char      iconized;
 int       save_xpos;
 int       save_ypos;
 int       save_x0;
 int       save_y0;
 int       save_x1;
 int       save_y1;
 int       save_bg_col;
 int       id;
};

typedef vga_window* VgaWindow;


extern VIDEO_PTR  VIDEO;
extern int DISP_WIDTH;
extern int DISP_MAX_X;
extern int LINE_BYTES;

extern int DISP_HEIGHT;
extern int DISP_MAX_Y;

extern int DISP_DEPTH;

extern VgaWindow  win_stack[16];
extern int win_top;

void vga_init(int mode, int root_col);

