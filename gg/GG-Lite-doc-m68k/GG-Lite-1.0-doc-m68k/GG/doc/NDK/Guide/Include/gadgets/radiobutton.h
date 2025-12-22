@DATABASE "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h"
@MASTER   "gg:os-include/gadgets/radiobutton.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:40
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "gadgets/radiobutton.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"gadgets/radiobutton.h" LINK File}


@{b}#defines@{ub}

@{"RADIOBUTTON_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 39}     @{"RADIOBUTTON_LabelPlace" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 53}  @{"RADIOBUTTON_Labels" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 41}
@{"RADIOBUTTON_Selected" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 50}  @{"RADIOBUTTON_Spacing" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 47}     @{"RADIOBUTTON_Strings" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 44}
@{"RBNA_Dummy" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 27}            @{"RBNA_Labels" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 32}             @{"RBNA_UserData" LINK "gg:doc/NDK/Guide/Include/gadgets/radiobutton.h/File" 29}

@ENDNODE
@NODE File "gadgets/radiobutton.h"
#ifndef GADGETS_RADIOBUTTON_H
#define GADGETS_RADIOBUTTON_H
/*
**      $VER: radiobutton.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      Definitions for the radiobutton.gadget BOOPSI class
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

/*****************************************************************************/

#ifndef REACTION_REACTION_H
#include <@{"reaction/reaction.h" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File"}>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <@{"intuition/gadgetclass.h" LINK "gg:doc/NDK/Guide/Include/intuition/gadgetclass.h/File"}>
#endif

/*****************************************************************************/

/* Defines for the radiobutton node attributes.
 */
#define RBNA_Dummy              (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48}+0x020000)

#define RBNA_UserData   (@{"RBNA_Dummy" LINK File 27}+1)
        /* (@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}) User Data. */

#define RBNA_Labels             (@{"RBNA_Dummy" LINK File 27}+2)
        /* (@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67}) Text string array of labels for MX buttons. */

/*****************************************************************************/

/* Additional attributes defined by the RadioButton class
 */
#define RADIOBUTTON_Dummy                       (@{"REACTION_Dummy" LINK "gg:doc/NDK/Guide/Include/reaction/reaction.h/File" 26} + 0x14000)

#define RADIOBUTTON_Labels                      (@{"RADIOBUTTON_Dummy" LINK File 39}+1)
        /* (@{"struct List" LINK "gg:doc/NDK/Guide/Include/exec/lists.h/File" 20} *) Radio Button Label List. */

#define RADIOBUTTON_Strings                     (@{"RADIOBUTTON_Dummy" LINK File 39}+2)
        /* RESERVED - presently unsupported */

#define RADIOBUTTON_Spacing                     (@{"RADIOBUTTON_Dummy" LINK File 39}+3)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) Spacing between radio buttons */

#define RADIOBUTTON_Selected            (@{"RADIOBUTTON_Dummy" LINK File 39}+4)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) selected radio button (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}/@{"OM_NOTIFY" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 69}) */

#define RADIOBUTTON_LabelPlace          (@{"RADIOBUTTON_Dummy" LINK File 39}+5)
        /* (@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54}) label location (@{"OM_GET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 66}/@{"OM_SET" LINK "gg:doc/NDK/Guide/Include/intuition/classusr.h/File" 65}) */

/*****************************************************************************/

#endif /* GADGETS_RADIOBUTTON_H */
@ENDNODE
