@DATABASE "gg:doc/NDK/Guide/Include/exec/initializers.h"
@MASTER   "gg:os-include/exec/initializers.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:12
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/initializers.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/initializers.h" LINK File}


@{b}#defines@{ub}

@{"INITBYTE()" LINK "gg:doc/NDK/Guide/Include/exec/initializers.h/File" 15}  @{"INITLONG()" LINK "gg:doc/NDK/Guide/Include/exec/initializers.h/File" 17}  @{"INITSTRUCT()" LINK "gg:doc/NDK/Guide/Include/exec/initializers.h/File" 20}  @{"INITWORD()" LINK "gg:doc/NDK/Guide/Include/exec/initializers.h/File" 16}  @{"OFFSET()" LINK "gg:doc/NDK/Guide/Include/exec/initializers.h/File" 13}

@ENDNODE
@NODE File "exec/initializers.h"
#ifndef EXEC_INITIALIZERS_H
#define EXEC_INITIALIZERS_H
/*
**      $VER: initializers.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Macros for use with the @{"InitStruct()" LINK "gg:doc/NDK/Guide/exec/InitStruct"} function.
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#define OFFSET(structName, structEntry) \\
                                (&(((struct structName *) 0)->structEntry))
#define INITBYTE(offset,value)  0xe000,(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (offset),(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) ((value)<<8)
#define INITWORD(offset,value)  0xd000,(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (offset),(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (value)
#define INITLONG(offset,value)  0xc000,(@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (offset), \\
                                (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) ((value)>>16), \\
                                (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) ((value) & 0xffff)
#define INITSTRUCT(size,offset,value,count) \\
                                (@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (0xc000|(size<<12)|(count<<8)| \\
                                ((@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) ((offset)>>16)), \\
                                ((@{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}) (offset)) & 0xffff)
#endif /* EXEC_INITIALIZERS_H */
@ENDNODE
