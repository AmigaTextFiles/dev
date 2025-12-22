/* C Include file for my graphics functions */
/* @ Paul Callaghan 1995 */
/* $VER: Misc_Include v1.002 (22 Oct 1995) */

#ifndef Misc
#define Misc

////*Initialisation Routines*/

extern __inline VOID Graphics_Init(VOID);
extern __inline VOID Graphics_Close(VOID);

extern __inline struct Screen_Store *
Open_Screen (LONG width,LONG height,LONG depth,LONG vmode,APTR cmap)
{
    register struct Screen_Store * _res  __asm("d0");
    register LONG d0 __asm("d0") = width;       /* the incoming data */
    register LONG d1 __asm("d1") = height;
    register LONG d2 __asm("d2") = depth;
    register LONG d3 __asm("d3") = vmode;
    register APTR a0 __asm("a0") = cmap;
    __asm __volatile ("bsr _Open_Screen"        /* the function call */
    : "=r" (_res)                               /* the return value */
    : "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (a0)     /* the registers used by the call */
    : "a0","a1","d0","d1","d2","d3");      /* not quite sure */
    return _res;
}

extern __inline VOID
Close_Screen (APTR screen)
{
    register APTR a0 __asm("a0") = screen;       /* the incoming data */
    __asm __volatile ("bsr _Close_Screen"        /* the function call */
    : /* no output */
    : "r" (a0)     /* the registers used by the call */
    : "a0","a1","d0","d1");      /* not quite sure */
}

extern __inline struct MaskPlane *
Init_Mask (LONG x_min,LONG y_min,LONG x_max,LONG y_max, LONG screen_x,LONG screen_y)
{
    register struct MaskPlane * _res  __asm("d0");
    register LONG d0 __asm("d0") = x_min;
    register LONG d1 __asm("d1") = y_min;
    register LONG d2 __asm("d2") = x_max;
    register LONG d3 __asm("d3") = y_max;
    register LONG d4 __asm("d4") = screen_x;
    register LONG d5 __asm("d5") = screen_y;
    __asm __volatile ("bsr _Init_Mask"
    : "=r" (_res)                               /* the return value */
    : "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4), "r" (d5)   /* the registers used by the call */
    : "a0","a1","d0","d1","d2","d3","d4","d5");      /* not quite sure */
    return _res;
}

extern __inline VOID
Free_Mask (APTR mask)
{
    register APTR a0 __asm("a0") = mask;       /* the incoming data */
    __asm __volatile ("bsr _Free_Mask"        /* the function call */
    : /* no output */
    : "r" (a0)     /* the registers used by the call */
    : "a0","a1","d0","d1");      /* not quite sure */
}
///

////*Drawing Routines*/
extern __inline VOID
Fill_Polygon (APTR screen, APTR vertex, LONG npoints, LONG colour)
{
    register APTR a0 __asm("a0") = screen;
    register APTR a1 __asm("a1") = vertex;
    register LONG d0 __asm("d0") = npoints;
    register LONG d1 __asm("d1") = colour;
    __asm __volatile ("bsr _Fill_Polygon"
    : /* no output */
    : "r" (a0), "r" (a1), "r" (d0), "r" (d1)
    : "a0","a1","d0","d1");
}

extern __inline VOID
Draw_Polygon (APTR screen, APTR vertex, LONG npoints, LONG colour)
{
    register APTR a0 __asm("a0") = screen;
    register APTR a1 __asm("a1") = vertex;
    register LONG d0 __asm("d0") = npoints;
    register LONG d1 __asm("d1") = colour;
    __asm __volatile ("bsr _Draw_Polygon"
    : /* no output */
    : "r" (a0), "r" (a1), "r" (d0), "r" (d1)
    : "a0","a1","d0","d1");
}

extern __inline VOID
Draw_Line (APTR screen, LONG x1, LONG y1, LONG x2, LONG y2, BYTE colour)
{
    register APTR a0 __asm("a0") = screen;
    register LONG d0 __asm("d0") = x1;
    register LONG d1 __asm("d1") = y1;
    register LONG d2 __asm("d2") = x2;
    register LONG d3 __asm("d3") = y2;
    register BYTE d4 __asm("d4") = colour;
    __asm __volatile ("bsr _Draw_Line"
    : /* no output */
    : "r" (a0), "r" (d0), "r" (d1), "r" (d2), "r" (d3), "r" (d4)
    : "d0","d1","d2","d3","d4","a0","a1");
}

extern __inline VOID
Write_Pixel (APTR screen, LONG x, LONG y, BYTE colour)
{
    register APTR a0 __asm("a0") = screen;
    register LONG d0 __asm("d0") = x;
    register LONG d1 __asm("d1") = y;
    register BYTE d2 __asm("d2") = colour;
    __asm __volatile ("bsr _Write_Pixel"
    : /* no output */
    : "r" (a0), "r" (d0), "r" (d1), "r" (d2)
    : "a0","d0","d1","d2");
}

extern __inline VOID
Screen_Clear (APTR screen)
{
    register APTR a0 __asm("a0") = screen;
    __asm __volatile ("bsr _Screen_Clear"
    : /* no output */
    : "r" (a0)
    : "a0","a1","d0","d1");
}

extern __inline VOID
Show (APTR screen)
{
    register APTR __asm("a0") = screen;
    __asm __volatile "bsr _Show"
    : /* no output */
    : "r" (a0)
    : "a0","a1","d0","d1");
}


///

////*Fade Routines*/
extern __inline VOID
Fade_To_White (APTR screen, APTR cmap)
{
    register APTR a0 __asm("a0") = screen;
    register APTR a1 __asm("a1") = cmap;
    __asm __volatile ("bsr _Fade_To_White"
    : /* no output */
    : "r" (a0), "r" (a1)
    : "a0","a1","d0","d1");
}

extern __inline VOID
Fade_To_Black (APTR screen, APTR cmap)
{
    register APTR a0 __asm("a0") = screen;
    register APTR a1 __asm("a1") = cmap;
    __asm __volatile ("bsr _Fade_To_Black"
    : /* no output */
    : "r" (a0), "r" (a1)
    : "a0","a1","d0","d1");
}

extern __inline VOID
Fade (APTR screen, APTR source_cmap, APTR dest_cmap)
{
    register APTR a0 __asm("a0") = screen;
    register APTR a1 __asm("a1") = source_cmap;
    register APTR a2 __asm("a2") = dest_cmap;
    __asm __volatile ("bsr _Fade"
    : /* no output */
    : "r" (a0), "r" (a1), "r" (a2)
    : "a0","a1","a2","d0","d1");
}

///

////*IFF File routines*/
extern __inline VOID
Load_IFF (APTR screen, STRPTR file)
{
    register APTR a1 __asm("a1") = screen;
    register STRPTR a0 __asm("a0") = file;
    __asm __volatile ("bsr _Load_IFF"
    : /* no output */
    : "r" (a0), "r" (a1)
    : "d0","d1","a0","a1");
}

extern __inline VOID
Save_IFF (APTR screen, STRPTR file)
{
    register APTR a1 __asm("a1") = screen;
    register STRPTR a0 __asm("a0") = file;
    __asm __volatile ("bsr _Save_IFF"
    : /* no output */
    : "r" (a0), "r" (a1)
    : "d0","d1","a0","a1");
}
///

////*File Handline Routines*/
extern __inline VOID
Load_Data (STRPTR file, LONG length, APTR dest)
{
    register STRPTR a0 __asm("a0") = file;
    register LONG d0 __asm("d0") = length;
    register APTR a1 __asm("a1") = dest;
    __asm __volatile ("bsr _Load_Data"
    : /* no output */
    : "r" (a0), "r" (d0), "r" (a1)
    : "d0","d1","a0","a1");
}

extern __inline VOID
Save_Data (STRPTR file, LONG length, APTR source)
{
    register STRPTR a0 __asm("a0") = file;
    register LONG d0 __asm("d0") = length;
    register APTR a1 __asm("a1") = source;
    __asm __volatile ("bsr _Save_Data"
    : /* no output */
    : "r" (a0), "r" (d0), "r" (a1)
    : "d0","d1","a0","a1");
}
///

////*Text Functions*/
extern __inline VOID
Write_Text(APTR screen, STRPTR text, LONG x, LONG y, LONG colour, LONG length)
{
    register APTR a0 __asm("a0") = screen;
    register STRPTR a1 __asm("a1") = text;
    register LONG d0 __asm("d0") = x;
    register LONG d1 __asm("d1") = y;
    register LONG d2 __asm("d2") = colour;
    register LONG d3 __asm("d3") = length;
    __asm __volatile ("bsr _Write_Text"
    : /* no output */
    : "r" (a0), "r" (a1), "r" (d0), "r" (d1), "r" (d2), "r" (d3)
    : "a0","a1","d0","d1","d2","d3");
}

extern __inline STRPTR
Num_To_String (WORD num)
{
    register STRPTR _res __asm("a1");
    register WORD d0 __asm("d0") = num;
    __asm __volatile ("bsr _Num_To_String"
    : "=r" (_res)
    : "r" (d0)
    : "a0","a1","d0","d1");
    return _res;
}
///

////*Copper Functions*/
extern __inline VOID
Add_Copper (APTR screen, APTR copper)
{
    register APTR a0 __asm("a0") = screen;
    register APTR a1 __asm("a1") = copper;
    __asm __volatile ("bsr _Add_Copper"
    : /* no output */
    : "r" (a0), "r" (a1)
    : "a0","a1","d0","d1");
}
///

////*Input Functions*/
extern __inline BYTE
GetKey (VOID)
{
    register BYTE _res __asm("d0");
    __asm __volatile ("bsr _GetKey"
    : "=r" (_res)
    : /* no input */
    : "a0","a1","d0","d1");
    return _res;
}
///

#endif

