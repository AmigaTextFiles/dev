@DATABASE "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h"
@MASTER   "gg:os-include/libraries/mathlibrary.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:57
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/mathlibrary.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/mathlibrary.h" LINK File}


@{b}Structures@{ub}

@{"MathIEEEBase" LINK "gg:doc/NDK/Guide/Include/libraries/mathlibrary.h/File" 19}

@ENDNODE
@NODE File "libraries/mathlibrary.h"
#ifndef LIBRARIES_MATHLIBRARY_H
#define LIBRARIES_MATHLIBRARY_H
/*
**      $VER: mathlibrary.h 1.6 (13.7.1990)
**      Includes Release 45.1
**
**      Data structure returned by @{"OpenLibrary" LINK "gg:doc/NDK/Guide/exec/OpenLibrary"} of:
**      @{"mathieeedoubbas.library" LINK "gg:doc/NDK/Guide/mathieeedoubbas/MAIN"},@{"mathieeedoubtrans.library" LINK "gg:doc/NDK/Guide/mathieeedoubtrans/MAIN"}
**      @{"mathieeesingbas.library" LINK "gg:doc/NDK/Guide/mathieeesingbas/MAIN"},@{"mathieeesingtrans.library" LINK "gg:doc/NDK/Guide/mathieeesingtrans/MAIN"}
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_LIBRARIES_H
#include <@{"exec/libraries.h" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File"}>
#endif

struct MathIEEEBase
{
        @{"struct Library" LINK "gg:doc/NDK/Guide/Include/exec/libraries.h/File" 34} MathIEEEBase_LibNode;
        unsigned char   MathIEEEBase_reserved[18];
        int     (*MathIEEEBase_TaskOpenLib)();
        int     (*MathIEEEBase_TaskCloseLib)();
        /*      This structure may be extended in the future */
};
/*
* Math resources may need to know when a program opens or closes this
* library. The functions TaskOpenLib and TaskCloseLib are called when
* a task opens or closes this library. They are initialized to point to
* local initialization pertaining to 68881 stuff if 68881 resources
* are found. To override the default the vendor must provide appropriate
* hooks in the MathIEEEResource. If specified, these will be called
* when the library initializes.
*/

#endif  /* LIBRARIES_MATHLIBRARY_H */
@ENDNODE
