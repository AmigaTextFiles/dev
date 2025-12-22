/* C Include file for my graphics functions */
/* @ Paul Callaghan 1995 */
/* $VER: Misc_Include v1.002 (22 Oct 1995) */

#ifndef Misc
#define Misc

/// "Initialisation Routines"
VOID __asm Graphics_Init(VOID);
VOID __asm Graphics_Close(VOID);

struct Screen_Store * __asm Open_Screen
(
    register __d0 LONG width,
    register __d1 LONG height,
    register __d2 LONG depth,
    register __d3 LONG vmode,
    register __a0 APTR cmap);

VOID __asm Close_Screen(register __a0 APTR screen);

struct MaskPlane * __asm Init_Mask
(
    register __d0 LONG x_min,
    register __d1 LONG y_min,
    register __d2 LONG x_max,
    register __d3 LONG y_max,
    register __d4 LONG screen_x,
    register __d5 LONG screen_y);

VOID __asm Free_Mask (register __a0 APTR mask);

///

/// "Drawing Routines"
VOID __asm Fill_Polygon
(
    register __a0 APTR screen,
    register __a1 APTR vertex,
    register __d0 LONG npoints,
    register __d1 LONG colour);

VOID __asm Draw_Polygon
(
    register __a0 APTR screen,
    register __a1 APTR vertex,
    register __d0 LONG npoints,
    register __d1 LONG colour);

VOID __asm Draw_Line
(
    register __a0 APTR screen,
    register __d0 LONG x1,
    register __d1 LONG y1,
    register __d2 LONG x2,
    register __d3 LONG y2,
    register __d4 BYTE colour);

VOID __asm Write_Pixel
(
    register __a0 APTR screen,
    register __d0 LONG x,
    register __d1 LONG y,
    register __d2 BYTE colour);

VOID __asm Screen_Clear (register __a0 APTR screen);

VOID __asm Show (register __a0 APTR screen);
///

/// "Fade Routines"
VOID __asm Fade_To_White
(
    register __a0 APTR screen,
    register __a1 APTR cmap);

VOID __asm Fade_To_Black
(
    register __a0 APTR screen,
    register __a1 APTR cmap);

VOID __asm Fade
(
    register __a0 APTR screen,
    register __a1 APTR source_cmap,
    register __a2 APTR dest_cmap);
///

/// "IFF Handling Routines"
VOID __asm Load_IFF
(
    register __a1 APTR screen,
    register __a0 STRPTR file);

VOID __asm Save_IFF
(
    register __a1 APTR screen,
    register __a0 STRPTR file);
///

/// "File Handling Routines"
VOID __asm Load_Data
(
    register __a0 STRPTR file,
    register __d0 LONG length,
    register __a1 APTR dest);

VOID __asm Save_Data
(
    register __a0 STRPTR file,
    register __d0 LONG length,
    register __a1 APTR source);
///

/// "Text Functions"
VOID __asm Write_Text
(
    register __a0 APTR screen,
    register __a1 STRPTR text,
    register __d0 LONG x,
    register __d1 LONG y,
    register __d2 LONG colour,
    register __d3 LONG length);

// May not work anymore !
STRPTR __asm Num_To_String (register __d0 num);
///

/// "Copper Functions"
VOID __asm Add_Copper
(
    register __a0 APTR screen,
    register __a1 APTR copper_stream);

///

/// "Input Procedures"
BYTE __asm GetKey();
///

#endif

