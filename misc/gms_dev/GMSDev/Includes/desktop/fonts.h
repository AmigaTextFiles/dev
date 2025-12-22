#ifndef DESKTOP_FONTS_H
#define DESKTOP_FONTS_H TRUE

/*
**  $VER: fonts.h
**
**  Font Definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/***************************************************************************
** Font.
*/

#define TAGS_FONT ((ID_SPCTAGS<<16)|ID_FONT)
#define VER_FONT  1

typedef struct Font {
  struct Head Head;        /* [00] Standard header structure */
  struct FileName *Source; /* [12] Source or Name from the FONTS: dir */
  LONG   Flags;            /* [16] Special flags */
  LONG   Colour;           /* [20] RGB colour of the font */
  WORD   Point;            /* [24] The Point/Height of the font */
  WORD   Gutter;           /* [26] Amount of space for tails on 'g', 'y' etc */
  WORD   Height;           /* [28] Point + Gutter */
  struct FontChar *Char;   /* [30] Pointer to font character array */
} OBJFont;

typedef struct FontChar {
  UBYTE Char;    /* Character code */
  UBYTE Empty;   /* Reserved */
  WORD  Width;   /* Width of character */
} FontChar;

#define FNT_BOLD        0x00000001
#define FNT_ITALICS     0x00000002
#define FNT_SMOOTH      0x00000004
#define FNT_TRANSPARENT 0x00000008

#define FTA_Source (TAPTR|12)
#define FTA_Flags  (TLONG|16)
#define FTA_Colour (TLONG|20)
#define FTA_Point  (TWORD|24)
#define FTA_Gutter (TWORD|26)
#define FTA_Height (TWORD|28)
#define FTA_Char   (TAPTR|30)

#endif /* DESKTOP_FONTS_H */
