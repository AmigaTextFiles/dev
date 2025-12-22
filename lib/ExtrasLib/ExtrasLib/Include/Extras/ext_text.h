#ifndef EXTRAS_EXT_TEXT_H
#define EXTRAS_EXT_TEXT_H

/* RenderText Tags */
#define RT_Dummy         (TAG_USER + 1<<30)

#define RT_Baseline       (RT_Dummy + 0) /* basline of text, default RastPort->cp_y */
#define RT_XPos           (RT_Dummy + 1) /* horiz position of text, default RastPort->cp_x */
#define RT_MaxWidth       (RT_Dummy + 2) /* Maximum pixel space to render text */
#define RT_Justification  (RT_Dummy + 3) /* default RTJ_LEFT */
#define RT_TextFont       (RT_Dummy + 4) /* (struct TextFont *) */
#define RT_Strlen         (RT_Dummy + 5) /* maximum number of characters to print */
#define RT_TextLength     (RT_Dummy + 6) /* (ULONG *) return pixel length of text written to rastport */
#define RT_WordWrap       (RT_Dummy + 7) /* not implemented */

#define RTJ_LEFT    0
#define RTJ_CENTER  1
#define RTJ_RIGHT   2

/* StrLength Tags */
#define SL_Dummy        (TAG_USER + 1<<29)

#define SL_String       (SL_Dummy+1) /* (STRPTR) Use Multiple SL_String tags to get the max length of all */
#define SL_TextFont     (SL_Dummy+2) /* (struct TextFont *) */
#define SL_IgnoreChars  (SL_Dummy+3) /* (STRPTR) Characters that should be ignored  */

#endif /* EXTRAS_EXT_TEXT_H */
