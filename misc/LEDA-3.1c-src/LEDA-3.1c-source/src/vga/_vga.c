/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _vga.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#if defined(__linux__)
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <sys/termios.h>
#endif

#include "vga.h"

/* 
 * choosing between VGA 640x480x16 color graphics mode or text mode
 * (part of this code is based on "VGAlib" by Tommy Frandsen)
 */

VIDEO_PTR  VIDEO=0;

int DISP_WIDTH = 640;
int DISP_MAX_X = 639;
int DISP_HEIGHT= 480;
int DISP_MAX_Y = 479;
int DISP_DEPTH = 4;

int LINE_BYTES = 80;

#define FONT_SIZE  0x2000

/* VGA index register ports */
#define CRT_IC  0x3D4   /* CRT Controller Index - color emulation */
#define CRT_IM  0x3B4   /* CRT Controller Index - mono emulation */
#define ATT_IW  0x3C0   /* Attribute Controller Index & Data Write Register */
#define GRA_I   0x3CE   /* Graphics Controller Index */
#define SEQ_I   0x3C4   /* Sequencer Index */
#define PEL_IW  0x3C8   /* PEL Write Index */
#define PEL_IR  0x3C7   /* PEL Read Index */

/* VGA data register ports */
#define CRT_DC  0x3D5   /* CRT Controller Data Register - color emulation */
#define CRT_DM  0x3B5   /* CRT Controller Data Register - mono emulation */
#define ATT_R   0x3C1   /* Attribute Controller Data Read Register */
#define GRA_D   0x3CF   /* Graphics Controller Data Register */
#define SEQ_D   0x3C5   /* Sequencer Data Register */
#define MIS_R   0x3CC   /* Misc Output Read Register */
#define MIS_W   0x3C2   /* Misc Output Write Register */
#define IS1_RC  0x3DA   /* Input Status Register 1 - color emulation */
#define IS1_RM  0x3BA   /* Input Status Register 1 - mono emulation */
#define PEL_D   0x3C9   /* PEL Data Register */

/* VGA indexes max counts */
#define CRT_C   24      /* 24 CRT Controller Registers */
#define ATT_C   21      /* 21 Attribute Controller Registers */
#define GRA_C   9       /* 9  Graphics Controller Registers */
#define SEQ_C   5       /* 5  Sequencer Registers */
#define MIS_C   1       /* 1  Misc Output Register */

/* VGA registers saving indexes */
#define CRT     0               /* CRT Controller Registers start */
#define ATT     CRT+CRT_C       /* Attribute Controller Registers start */
#define GRA     ATT+ATT_C       /* Graphics Controller Registers start */
#define SEQ     GRA+GRA_C       /* Sequencer Registers */
#define MIS     SEQ+SEQ_C       /* General Registers */
#define END     MIS+MIS_C       /* last */


/* variables used to shift between monchrome and color emulation */
static int CRT_I;		/* current CRT index register address */
static int CRT_D;		/* current CRT data register address */
static int IS1_R;		/* current input status register address */
static int color_text;		/* true if color text emulation */


/* BIOS mode 12h - 640x480x16 */
static char g640x480x16_regs[60] = {
  0x5F,0x4F,0x50,0x82,0x54,0x80,0x0B,0x3E,0x00,0x40,0x00,0x00,
  0x00,0x00,0x00,0x00,0xEA,0x8C,0xDF,0x28,0x00,0xE7,0x04,0xE3,
  0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,
  0x0C,0x0D,0x0E,0x0F,0x01,0x00,0x0F,0x00,0x00,
  0x00,0x0F,0x00,0x20,0x00,0x00,0x05,0x0F,0xFF,
  0x03,0x01,0x0F,0x00,0x06,
  0xE3
};


/* default RGB values */

//                            white black red  green blue  yellow violet orange
//                            cyan  brown pink green grey1 grey2  grey3  grey4
static char RGB_RED[16]  = {  63,   0,    63,   0,   0,    54,    42,    54,   
                               0,  48,    63,   9,   45,   40,    35,     0};

static char RGB_GREEN[16]= {  63,   0,     0,  54,    0,   54,    21,    36,  
                              63,  28,    26,  35,   45,   40,    35,     0};
 
static char RGB_BLUE[16] = {  63,   0,     0,   0,   63,   18,    63,     0, 
                              63,  18,    47,   9,   45,   40,    35,     0};


static char text_regs[60];   /* VGA registers for saved text mode */

/* saved text mode palette values */
static char text_red[256];
static char text_green[256];
static char text_blue[256];


static int initialized = 0;

static char font_buf1[FONT_SIZE];  /* saved font data - plane 2 */
static char font_buf2[FONT_SIZE];  /* saved font data - plane 3 */


static void set_regs(char regs[])
{
    int i;

    /* disable video */
    port_in(IS1_R);	
    port_out(0x00, ATT_IW);

    /* update misc output register */
    port_out(regs[MIS], MIS_W);

    /* synchronous reset on */
    port_out(0x00,SEQ_I);
    port_out(0x01,SEQ_D);	

    /* write sequencer registers */
    for (i = 1; i < SEQ_C; i++) {
	port_out(i, SEQ_I);
	port_out(regs[SEQ+i], SEQ_D);
    }

    /* synchronous reset off */
    port_out(0x00, SEQ_I);
    port_out(0x03, SEQ_D);	

    /* deprotect CRT registers 0-7 */
    port_out(0x11, CRT_I);		
    port_out(port_in(CRT_D)&0x7F, CRT_D);

    /* write CRT registers */
    for (i = 0; i < CRT_C; i++) {
	port_out(i, CRT_I);
	port_out(regs[CRT+i], CRT_D);
    }

    /* write graphics controller registers */
    for (i = 0; i < GRA_C; i++) {
	port_out(i, GRA_I);
	port_out(regs[GRA+i], GRA_D);
    }

    /* write attribute controller registers */
    for (i = 0; i < ATT_C; i++) {
	port_in(IS1_R);   /* reset flip-flop */
	port_out(i, ATT_IW);
	port_out(regs[ATT+i],ATT_IW);
    }
}

static void vga_initialize()
{
    int  i, j;
    int mem_fd = -1;  /* /dev/mem file descriptor		     */

    if (initialized) return;

    initialized = 1;

#if defined(__linux__)

#define GRAPH_SIZE 0x10000
#define GRAPH_BASE 0xa0000

    /* get I/O permissions for VGA registers */
    if (ioperm(0x3b4, 0x3df - 0x3b4 + 1, 1)) {
	printf("vgalib: Cannot get I/O permissions.\n");
	exit(-1);
    }

    if (( VIDEO = (unsigned char*)valloc(GRAPH_SIZE)) == NULL) {
	printf("vgalib: allocation error \n");
	exit (-1);
     }

    if (mem_fd < 0) 
	if ((mem_fd = open("/dev/mem", O_RDWR) ) < 0) {
	    printf("vgalib: Cannot open /dev/mem.\n");
	    exit (-1);
	}

    VIDEO = (unsigned char *)mmap(
	(caddr_t)VIDEO,
	GRAPH_SIZE,
	PROT_READ|PROT_WRITE,
	MAP_SHARED|MAP_FIXED,
	mem_fd,
	GRAPH_BASE);

#else
#if defined(__GNUG__)
    VIDEO = (VIDEO_PTR)0xd0000000;
#else
#if defined(__ZTC__) && defined(DOS386)
    VIDEO = (VIDEO_PTR)_x386_mk_protected_ptr(0xa0000);
#else
    VIDEO = (VIDEO_PTR)MK_FP(0xa000,0);
#endif
#endif
#endif


    /* color or monochrome text emulation? */
    color_text = port_in(MIS_R)&0x01;

    /* chose registers for color/monochrome emulation */
    if (color_text) {
	CRT_I = CRT_IC;
	CRT_D = CRT_DC;
	IS1_R = IS1_RC;
    } else {
	CRT_I = CRT_IM;
	CRT_D = CRT_DM;
	IS1_R = IS1_RM;
    }

    /* disable video */
    port_in(IS1_R);	
    port_out(0x00, ATT_IW);

    /* save text mode palette - first select palette index 0 */
    port_out(0, PEL_IR);

    /* read RGB components - index is autoincremented */
    for(i = 0; i < 256; i++) {
	for(j = 0; j < 10; j++) ;   /* delay (minimum 240ns) */
	text_red[i] = port_in(PEL_D);
	for(j = 0; j < 10; j++) ;   /* delay (minimum 240ns) */
	text_green[i] = port_in(PEL_D);
	for(j = 0; j < 10; j++) ;   /* delay (minimum 240ns) */
	text_blue[i] = port_in(PEL_D);
    }

    /* save text mode VGA registers */
    for (i = 0; i < CRT_C; i++) {
	 port_out(i, CRT_I);
	 text_regs[CRT+i] = port_in(CRT_D);
    }
    for (i = 0; i < ATT_C; i++) {
      	 port_in(IS1_R);
         port_out(i, ATT_IW);
         text_regs[ATT+i] = port_in(ATT_R);
    }
    for (i = 0; i < GRA_C; i++) {
       	 port_out(i, GRA_I);
       	 text_regs[GRA+i] = port_in(GRA_D);
    }
    for (i = 0; i < SEQ_C; i++) {
       	 port_out(i, SEQ_I);
       	 text_regs[SEQ+i] = port_in(SEQ_D);
    }
    text_regs[MIS] = port_in(MIS_R);

    /* shift to color emulation */
    CRT_I = CRT_IC;
    CRT_D = CRT_DC;
    IS1_R = IS1_RC;
    port_out(port_in(MIS_R)|0x01, MIS_W);

    /* save font data - first select a 16 color graphics mode */
    set_regs(g640x480x16_regs);

    /* save font data in plane 2 */
    port_out(0x04, GRA_I);
    port_out(0x02, GRA_D);
    for(i = 0; i < FONT_SIZE; i++) font_buf1[i] = VIDEO[i];

    /* save font data in plane 3 */
    port_out(0x04, GRA_I);
    port_out(0x03, GRA_D);
    for(i = 0; i < FONT_SIZE; i++) font_buf2[i] = VIDEO[i];
}


void set_palette(int index, int red, int green, int blue)
{
    int i;

    /* select palette register */
    port_out(index, PEL_IW);

    /* write RGB components */
    for(i = 0; i < 10; i++) ;   /* delay (minimum 240ns) */
    port_out(red, PEL_D);
    for(i = 0; i < 10; i++) ;   /* delay (minimum 240ns) */
    port_out(green, PEL_D);
    for(i = 0; i < 10; i++) ;   /* delay (minimum 240ns) */
    port_out(blue, PEL_D);
}


void get_palette(int index, int *red, int *green, int *blue)
{
    int i;

    /* select palette register */
    port_out(index, PEL_IR);

    /* read RGB components */
    for(i = 0; i < 10; i++) ;   /* delay (minimum 240ns) */
    *red = (int) port_in(PEL_D);
    for(i = 0; i < 10; i++) ;   /* delay (minimum 240ns) */
    *green = (int) port_in(PEL_D);
    for(i = 0; i < 10; i++) ;   /* delay (minimum 240ns) */
    *blue = (int) port_in(PEL_D);
}

static void vga_clear(int c)
{
  register VIDEO_PTR p;
  register VIDEO_PTR last;

  /* set color c */
  port_out(c, GRA_I );
  port_out(0, GRA_D );

  /* set mode 0 */
  port_out(0x03, GRA_I );
  port_out(0, GRA_D );

  /* write to all bits */
  port_out(0x08, GRA_I );
  port_out(0xFF, GRA_D );

  last  = VIDEO + DISP_HEIGHT*LINE_BYTES;

  for(p = VIDEO; p < last; p++)  *p = 0;

}


void vga_init(int mode, int root_col)  // mode = 0: Text, 1: 640x480x16 
{
    int i;

    vga_initialize();
    
    if (mode == 0)  // TEXT
      { 
        vga_clear(0);

        /* restore font data - first select a 16 color graphics mode */
        set_regs(g640x480x16_regs);

	/* disable Set/Reset Register */
    	port_out(0x01, GRA_I );
    	port_out(0x00, GRA_D );

        /* restore font data in plane 2 - necessary for all VGA's */
    	port_out(0x02, SEQ_I );
    	port_out(0x04, SEQ_D );
        for(i = 0; i < FONT_SIZE; i++) VIDEO[i] = font_buf1[i];

        /* restore font data in plane 3 - necessary for Trident VGA's */
    	port_out(0x02, SEQ_I );
    	port_out(0x08, SEQ_D );
        for(i = 0; i < FONT_SIZE; i++) VIDEO[i] = font_buf2[i];

        /* change register adresses if monochrome text mode */
        if (!color_text) {
            CRT_I = CRT_IM;
            CRT_D = CRT_DM;
            IS1_R = IS1_RM;
            port_out(port_in(MIS_R)&0xFE, MIS_W);
        }

	/* restore text mode VGA registers */
    	set_regs(text_regs);

        /* restore saved palette */
        for(i = 0; i < 256; i++)
            set_palette(i, text_red[i], text_green[i], text_blue[i]);

        DISP_WIDTH = 80;
        DISP_MAX_X = 79;
        DISP_HEIGHT= 25;
        DISP_MAX_Y = 24;
      }
    else // graphics mode
      { 
        /* shift to color emulation */
        CRT_I = CRT_IC;
        CRT_D = CRT_DC;
        IS1_R = IS1_RC;
        port_out(port_in(MIS_R)|0x01, MIS_W);
        set_regs(g640x480x16_regs);

        /* set default palette */
        for(i = 0; i < 16; i++)
          set_palette(i, RGB_RED[i], RGB_GREEN[i], RGB_BLUE[i]);

        vga_clear(root_col);

        LINE_BYTES = 80;
        DISP_WIDTH = 640;
        DISP_MAX_X = 639;
        DISP_HEIGHT= 480;
        DISP_MAX_Y = 479;
        DISP_DEPTH = 4;
      }

    /* enable video */
    port_in(IS1_R);
    port_out(0x20, ATT_IW);

}


#if defined(__linux__)

char getch() 
{ termio save;
  char c = 0;
  ioctl(fileno(stdin), TCGETA, &save);
  termio t = save;
  t.c_cc[VMIN] = 0;
  t.c_cc[VTIME] = 0;
  t.c_lflag = 0;
  ioctl(fileno(stdin), TCSETA, &t);
  read(fileno(stdin), &c, 1);
  ioctl(fileno(stdin), TCSETA, &save);
  return c;
}

#endif
