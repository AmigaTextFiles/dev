@DATABASE "gg:doc/NDK/Guide/Include/utility/name.h"
@MASTER   "gg:os-include/utility/name.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:33
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "utility/name.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"utility/name.h" LINK File}


@{b}Structures@{ub}

@{"NamedObject" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 25}


@{b}#defines@{ub}

@{"ANO_Flags" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 34}   @{"ANO_NameSpace" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 31}  @{"ANO_Priority" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 33}  @{"ANO_UserSpace" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 32}  @{"NSB_CASE" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 38}
@{"NSB_NODUPS" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 37}  @{"NSF_CASE" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 41}       @{"NSF_NODUPS" LINK "gg:doc/NDK/Guide/Include/utility/name.h/File" 40}    

@ENDNODE
@NODE File "utility/name.h"
#ifndef UTILITY_NAME_H
#define UTILITY_NAME_H
/*
**      $VER: name.h 39.5 (11.8.1993)
**      Includes Release 45.1
**
**      Namespace definitions
**
**      (C) Copyright 1992-2001 Amiga, Inc.
**      All Rights Reserved
**/

/*****************************************************************************/


#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif


/*****************************************************************************/


/* The named object structure */
struct NamedObject
{
    @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} no_Object;     /* Your pointer, for whatever you want */
};

/* Tags for @{"AllocNamedObject()" LINK "gg:doc/NDK/Guide/utility/AllocNamedObjectA"} */
#define ANO_NameSpace   4000    /* Tag to define namespace      */
#define ANO_UserSpace   4001    /* tag to define userspace      */
#define ANO_Priority    4002    /* tag to define priority       */
#define ANO_Flags       4003    /* tag to define flags          */

/* Flags for tag @{"ANO_Flags" LINK File 34} */
#define NSB_NODUPS      0
#define NSB_CASE        1

#define NSF_NODUPS      (1L << @{"NSB_NODUPS" LINK File 37})      /* Default allow duplicates */
#define NSF_CASE        (1L << @{"NSB_CASE" LINK File 38})        /* Default to caseless... */


/*****************************************************************************/


#endif /* UTILITY_NAME_H */
@ENDNODE
