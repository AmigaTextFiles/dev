@DATABASE "gg:doc/NDK/Guide/Include/images/label.h"
@MASTER   "gg:os-include/images/label.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:14:22
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "images/label.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"images/label.h" LINK File}


@{b}#defines@{ub}

@{"LABEL_CENTER" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 40}  @{"LABEL_CENTRE" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 39}      @{"LABEL_DisposeImage" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 69}     @{"LABEL_DrawInfo" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 49}
@{"LABEL_Dummy" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 47}   @{"LABEL_Image" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 54}       @{"LABEL_Justification" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 60}    @{"LABEL_Key" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 63}
@{"LABEL_LEFT" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 38}    @{"LABEL_Mapping" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 57}     @{"LABEL_RIGHT" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 41}            @{"LABEL_SoftStyle" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 72}
@{"LABEL_Text" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 51}    @{"LABEL_Underscore" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 66}  @{"LABEL_VerticalSpacing" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 75}  @{"LJ_CENTER" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 34}
@{"LJ_CENTRE" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 29}     @{"LJ_LEFT" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 28}           @{"LJ_RIGHT" LINK "gg:doc/NDK/Guide/Include/images/label.h/File" 30}               

@ENDNODE
@NODE File "images/label.h"
#ifndef IMAGES_LABEL_H
#define IMAGES_LABEL_H
/*
**      $VER: label.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the Label BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTRION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/imageclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File"}>
#endif


/*****************************************************************************/

/* Justification modes.
 */
#define LJ_LEFT 0
#define LJ_CENTRE 1
#define LJ_RIGHT 2

/* For those that can't spell :)
 */
#define LJ_CENTER @{"LJ_CENTRE" LINK File 29}

/* Obsolete, DON'T USE THESE!
 */
#define LABEL_LEFT @{"LJ_LEFT" LINK File 28}
#define LABEL_CENTRE @{"LJ_CENTRE" LINK File 29}
#define LABEL_CENTER @{"LJ_CENTRE" LINK File 29}
#define LABEL_RIGHT @{"LJ_RIGHT" LINK File 30}

/*****************************************************************************/

/* Additional attributes defined by the Label class
 */
#define LABEL_Dummy                                     (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26}+0x0006000)

#define LABEL_DrawInfo                          @{"SYSIA_DrawInfo" LINK "gg:doc/NDK/Guide/Include/intuition/imageclass.h/File" 79}

#define LABEL_Text                                      (@{"LABEL_Dummy" LINK File 47}+1)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Text to print in the label. */

#define LABEL_Image                                     (@{"LABEL_Dummy" LINK File 47}+2)
        /* (@{"struct Image" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 705} *) Image to print in the label. */

#define LABEL_Mapping                           (@{"LABEL_Dummy" LINK File 47}+3)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55} *) Mapping array for the next image. */

#define LABEL_Justification                     (@{"LABEL_Dummy" LINK File 47}+4)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Justification modes (see above) */

#define LABEL_Key                                       (@{"LABEL_Dummy" LINK File 47}+5)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Returns the underscored key (if any) */

#define LABEL_Underscore                        (@{"LABEL_Dummy" LINK File 47}+6)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Defaults to '_'. */

#define LABEL_DisposeImage                      (@{"LABEL_Dummy" LINK File 47}+7)
        /* (@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91}) Defaults to @{"FALSE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 98}. */

#define LABEL_SoftStyle                         (@{"LABEL_Dummy" LINK File 47}+8)
        /* (@{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}) Defaults to none. */

#define LABEL_VerticalSpacing           (@{"LABEL_Dummy" LINK File 47}+9)
        /* (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) Vertical spacing between text/image nodes/lines. Defaults to 0. */

/*****************************************************************************/

#endif /* IMAGES_LABEL_H */
@ENDNODE
