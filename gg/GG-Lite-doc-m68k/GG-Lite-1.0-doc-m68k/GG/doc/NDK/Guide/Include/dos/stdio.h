@DATABASE "gg:doc/NDK/Guide/Include/dos/stdio.h"
@MASTER   "gg:os-include/dos/stdio.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:06
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "dos/stdio.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"dos/stdio.h" LINK File}


@{b}#defines@{ub}

@{"BUF_FULL" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 26}  @{"BUF_LINE" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 25}      @{"BUF_NONE" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 27}   @{"ENDSTREAMCH" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 30}  @{"ReadChar()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 15}  @{"ReadChars()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 19}
@{"ReadLn()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 20}  @{"UnReadChar()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 17}  @{"VWritef()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 22}  @{"WriteChar()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 16}  @{"WriteStr()" LINK "gg:doc/NDK/Guide/Include/dos/stdio.h/File" 21}  

@ENDNODE
@NODE File "dos/stdio.h"
#ifndef DOS_STDIO_H
#define DOS_STDIO_H
/*
**
**      $VER: stdio.h 36.6 (1.11.1991)
**      Includes Release 45.1
**
**      ANSI-like stdio defines for dos buffered I/O
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**          All Rights Reserved
**
*/

#define ReadChar()              @{"FGetC" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 250}(@{"Input" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 63}())
#define WriteChar(c)            @{"FPutC" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 254}(@{"Output" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 67}(),(c))
#define UnReadChar(c)           @{"UnGetC" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 258}(@{"Input" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 63}(),(c))
/* next one is inefficient */
#define ReadChars(buf,num)      @{"FRead" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 262}(@{"Input" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 63}(),(buf),1,(num))
#define ReadLn(buf,len)         @{"FGets" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 270}(@{"Input" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 63}(),(buf),(len))
#define WriteStr(s)             @{"FPuts" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 274}(@{"Output" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 67}(),(s))
#define VWritef(format,argv)    @{"VFWritef" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 278}(@{"Output" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 67}(),(format),(argv))

/* types for @{"SetVBuf" LINK "gg:doc/NDK/Guide/dos/SetVBuf"} */
#define BUF_LINE        0       /* flush on \\n, etc */
#define BUF_FULL        1       /* never flush except when needed */
#define BUF_NONE        2       /* no buffering */

/* EOF return value */
#define ENDSTREAMCH     -1

#endif  /* DOS_STDIO_H */
@ENDNODE
