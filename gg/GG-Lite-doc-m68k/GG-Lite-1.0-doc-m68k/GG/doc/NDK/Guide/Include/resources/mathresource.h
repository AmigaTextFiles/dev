@DATABASE "gg:doc/NDK/Guide/Include/resources/mathresource.h"
@MASTER   "gg:os-include/resources/mathresource.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:25
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "resources/mathresource.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"resources/mathresource.h" LINK File}


@{b}Structures@{ub}

@{"MathIEEEResource" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 33}


@{b}#defines@{ub}

@{"MATHIEEERESOURCEF_DBLBAS" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 47}  @{"MATHIEEERESOURCEF_DBLTRANS" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 48}
@{"MATHIEEERESOURCEF_EXTBAS" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 51}  @{"MATHIEEERESOURCEF_EXTTRANS" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 52}
@{"MATHIEEERESOURCEF_SGLBAS" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 49}  @{"MATHIEEERESOURCEF_SGLTRANS" LINK "gg:doc/NDK/Guide/Include/resources/mathresource.h/File" 50}

@ENDNODE
@NODE File "resources/mathresource.h"
#ifndef RESOURCES_MATHRESOURCE_H
#define RESOURCES_MATHRESOURCE_H
/*
**      $VER: mathresource.h 1.2 (13.7.1990)
**      Includes Release 45.1
**
**      Data structure returned by @{"OpenResource" LINK "gg:doc/NDK/Guide/exec/OpenResource"} of:
**      "MathIEEE.resource"
**
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_NODES_H
#include <@{"exec/nodes.h" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File"}>
#endif

/*
*       The 'Init' entries are only used if the corresponding
*       bit is set in the Flags field.
*
*       So if you are just a 68881, you do not need the Init stuff
*       just make sure you have cleared the Flags field.
*
*       This should allow us to add Extended Precision later.
*
*       For Init users, if you need to be called whenever a task
*       opens this library for use, you need to change the appropriate
*       entries in MathIEEELibrary.
*/

struct @{"MathIEEEResource" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 33}
{
        @{"struct  Node" LINK "gg:doc/NDK/Guide/Include/exec/nodes.h/File" 22}    MathIEEEResource_Node;
        unsigned short  MathIEEEResource_Flags;
        unsigned short  *MathIEEEResource_BaseAddr; /* ptr to 881 if exists */
        void    (*MathIEEEResource_DblBasInit)();
        void    (*MathIEEEResource_DblTransInit)();
        void    (*MathIEEEResource_SglBasInit)();
        void    (*MathIEEEResource_SglTransInit)();
        void    (*MathIEEEResource_ExtBasInit)();
        void    (*MathIEEEResource_ExtTransInit)();
};

/* definations for MathIEEEResource_FLAGS */
#define @{"MATHIEEERESOURCEF_DBLBAS" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 47}        (1<<0)
#define @{"MATHIEEERESOURCEF_DBLTRANS" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 48}      (1<<1)
#define @{"MATHIEEERESOURCEF_SGLBAS" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 49}        (1<<2)
#define @{"MATHIEEERESOURCEF_SGLTRANS" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 50}      (1<<3)
#define @{"MATHIEEERESOURCEF_EXTBAS" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 51}        (1<<4)
#define @{"MATHIEEERESOURCEF_EXTTRANS" LINK "gg:doc/NDK/Guide/Include/libraries/mathresource.h/File" 52}      (1<<5)

#endif  /* RESOURCES_MATHRESOURCE_H */
@ENDNODE
