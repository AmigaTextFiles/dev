@DATABASE "gg:doc/NDK/Guide/Include/libraries/translator.h"
@MASTER   "gg:os-include/libraries/translator.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:17:01
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/translator.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/translator.h" LINK File}


@{b}#defines@{ub}

@{"TR_MakeBad" LINK "gg:doc/NDK/Guide/Include/libraries/translator.h/File" 18}  @{"TR_NoMem" LINK "gg:doc/NDK/Guide/Include/libraries/translator.h/File" 17}  @{"TR_NotUsed" LINK "gg:doc/NDK/Guide/Include/libraries/translator.h/File" 16}

@ENDNODE
@NODE File "libraries/translator.h"
#ifndef LIBRARIES_TRANSLATOR_H
#define LIBRARIES_TRANSLATOR_H

/*
**      $VER: translator.h 36.1 (13.12.1990)
**      Includes Release 45.1
**
**      Useful definitions for @{"translator.library" LINK "gg:doc/NDK/Guide/translator/MAIN"}
**
**      (C) Copyright 1988-2001 Amiga, Inc. and
**      Joseph Katz/Mark Barton.  All rights reserved.
*/

/*      Translator error return codes   */

#define TR_NotUsed      -1      /* This is an oft used system rc        */
#define TR_NoMem        -2      /* Can't allocate memory                */
#define TR_MakeBad      -4      /* Error in @{"MakeLibrary" LINK "gg:doc/NDK/Guide/exec/MakeLibrary"} call            */

#endif  /* LIBRARIES_TRANSLATOR_H */
@ENDNODE
