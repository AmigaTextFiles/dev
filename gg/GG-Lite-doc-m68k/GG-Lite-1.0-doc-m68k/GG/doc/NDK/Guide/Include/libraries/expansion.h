@DATABASE "gg:doc/NDK/Guide/Include/libraries/expansion.h"
@MASTER   "gg:os-include/libraries/expansion.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:39
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/expansion.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/expansion.h" LINK File}


@{b}#defines@{ub}

@{"ADNB_STARTPROC" LINK "gg:doc/NDK/Guide/Include/libraries/expansion.h/File" 16}  @{"ADNF_STARTPROC" LINK "gg:doc/NDK/Guide/Include/libraries/expansion.h/File" 17}  @{"EXPANSIONNAME" LINK "gg:doc/NDK/Guide/Include/libraries/expansion.h/File" 13}

@ENDNODE
@NODE File "libraries/expansion.h"
#ifndef LIBRARIES_EXPANSION_H
#define LIBRARIES_EXPANSION_H
/*
**      $VER: expansion.h 36.7 (28.5.1990)
**      Includes Release 45.1
**
**      External definitions for @{"expansion.library" LINK "gg:doc/NDK/Guide/expansion/MAIN"}
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#define EXPANSIONNAME   "expansion.library"

/* flags for the @{"AddDosNode()" LINK "gg:doc/NDK/Guide/expansion/AddDosNode"} call */
#define ADNB_STARTPROC  0
#define ADNF_STARTPROC  (1L<<0)

#endif /* LIBRARIES_EXPANSION_H */
@ENDNODE
