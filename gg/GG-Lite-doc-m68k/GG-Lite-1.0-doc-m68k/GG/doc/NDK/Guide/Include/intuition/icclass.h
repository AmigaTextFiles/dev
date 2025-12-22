@DATABASE "gg:doc/NDK/Guide/Include/intuition/icclass.h"
@MASTER   "gg:os-include/intuition/icclass.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:15:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "intuition/icclass.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"intuition/icclass.h" LINK File}


@{b}#defines@{ub}

@{"ICA_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 26}  @{"ICA_MAP" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 29}      @{"ICA_TARGET" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 27}      @{"ICM_CHECKLOOP" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 21}   @{"ICM_CLEARLOOP" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 20}
@{"ICM_Dummy" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 18}  @{"ICM_SETLOOP" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 19}  @{"ICSPECIAL_CODE" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 31}  @{"ICTARGET_IDCMP" LINK "gg:doc/NDK/Guide/Include/intuition/icclass.h/File" 46}  

@ENDNODE
@NODE File "intuition/icclass.h"
#ifndef INTUITION_ICCLASS_H
#define INTUITION_ICCLASS_H
/*
**  $VER: icclass.h 38.1 (11.11.1991)
**  Includes Release 45.1
**
**  Gadget/object interconnection classes
**
**  (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
*/


#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

#define ICM_Dummy       (0x0401L)       /* used for nothing             */
#define ICM_SETLOOP     (0x0402L)       /* set/increment loop counter   */
#define ICM_CLEARLOOP   (0x0403L)       /* clear/decrement loop counter */
#define ICM_CHECKLOOP   (0x0404L)       /* set/increment loop           */

/* no parameters for @{"ICM_SETLOOP" LINK File 19}, @{"ICM_CLEARLOOP" LINK File 20}, @{"ICM_CHECKLOOP" LINK File 21}  */

/* interconnection attributes used by icclass, modelclass, and gadgetclass */
#define ICA_Dummy       (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x40000L)
#define ICA_TARGET      (@{"ICA_Dummy" LINK File 26} + 1)
        /* interconnection target               */
#define ICA_MAP         (@{"ICA_Dummy" LINK File 26} + 2)
        /* interconnection map tagitem list     */
#define ICSPECIAL_CODE  (@{"ICA_Dummy" LINK File 26} + 3)
        /* a "pseudo-attribute", see below.     */

/* Normally, the value for @{"ICA_TARGET" LINK File 27} is some object pointer,
 * but if you specify the special value @{"ICTARGET_IDCMP" LINK File 46}, notification
 * will be send as an @{"IDCMP_IDCMPUPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 856} message to the appropriate window's
 * IDCMP port.  See the definition of @{"IDCMP_IDCMPUPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 856}.
 *
 * When you specify @{"ICTARGET_IDCMP" LINK File 46} for @{"ICA_TARGET" LINK File 27}, the map you
 * specify will be applied to derive the attribute list that is
 * sent with the @{"IDCMP_IDCMPUPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 856} message.  If you specify a map list
 * which results in the attribute tag id @{"ICSPECIAL_CODE" LINK File 31}, the
 * lower sixteen bits of the corresponding ti_Data value will
 * be copied into the Code field of the @{"IDCMP_IDCMPUPDATE" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 856} IntuiMessage.
 */
#define ICTARGET_IDCMP  (~0L)

#endif /* INTUITION_ICCLASS_H */
@ENDNODE
