@DATABASE "gg:doc/NDK/Guide/Include/diskfont/oterrors.h"
@MASTER   "gg:os-include/diskfont/oterrors.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:50
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "diskfont/oterrors.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"diskfont/oterrors.h" LINK File}


@{b}#defines@{ub}

@{"OTERR_BadData" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 18}       @{"OTERR_BadFace" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 21}     @{"OTERR_BadGlyph" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 23}  @{"OTERR_BadTag" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 16}
@{"OTERR_Failure" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 14}       @{"OTERR_NoFace" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 20}      @{"OTERR_NoGlyph" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 22}   @{"OTERR_NoMemory" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 19}
@{"OTERR_NoRotate" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 25}      @{"OTERR_NoShear" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 24}     @{"OTERR_Success" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 15}   @{"OTERR_TooSmall" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 26}
@{"OTERR_UnknownGlyph" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 27}  @{"OTERR_UnknownTag" LINK "gg:doc/NDK/Guide/Include/diskfont/oterrors.h/File" 17}  

@ENDNODE
@NODE File "diskfont/oterrors.h"
#ifndef  DISKFONT_OTERRORS_H
#define  DISKFONT_OTERRORS_H
/*
**      $VER: oterrors.h 8.1 (19.6.1992)
**      Includes Release 45.1
**
**      oterrors.h -- error results from outline libraries
**
**      (C) Copyright 1991-1992 Robert R. Burns
**          All Rights Reserved
*/

/* PRELIMINARY */
#define  OTERR_Failure          -1      /* catch-all for error */
#define  OTERR_Success          0       /* no error */
#define  OTERR_BadTag           1       /* inappropriate tag for function */
#define  OTERR_UnknownTag       2       /* unknown tag for function */
#define  OTERR_BadData          3       /* catch-all for bad tag data */
#define  OTERR_NoMemory         4       /* insufficient memory for operation */
#define  OTERR_NoFace           5       /* no typeface currently specified */
#define  OTERR_BadFace          6       /* typeface specification problem */
#define  OTERR_NoGlyph          7       /* no glyph specified */
#define  OTERR_BadGlyph         8       /* bad glyph code or glyph range */
#define  OTERR_NoShear          9       /* shear only partially specified */
#define  OTERR_NoRotate         10      /* rotate only partially specified */
#define  OTERR_TooSmall         11      /* typeface metrics yield tiny glyphs */
#define  OTERR_UnknownGlyph     12      /* glyph not known by engine */

#endif   /* DISKFONT_OTERRORS_H */
@ENDNODE
