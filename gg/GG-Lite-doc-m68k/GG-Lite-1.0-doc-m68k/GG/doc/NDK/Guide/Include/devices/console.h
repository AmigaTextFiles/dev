@DATABASE "gg:doc/NDK/Guide/Include/devices/console.h"
@MASTER   "gg:os-include/devices/console.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:21
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/console.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/console.h" LINK File}


@{b}#defines@{ub}

@{"CD_ASKDEFAULTKEYMAP" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 24}  @{"CD_ASKKEYMAP" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 22}     @{"CD_SETDEFAULTKEYMAP" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 25}
@{"CD_SETKEYMAP" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 23}         @{"CTC_HCLRTAB" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 88}      @{"CTC_HCLRTABSALL" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 89}
@{"CTC_HSETTAB" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 87}          @{"DSR_CPR" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 84}          @{"M_ASM" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 97}
@{"M_AWM" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 98}                @{"M_LNM" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 96}            @{"SGR_BLACK" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 41}
@{"SGR_BLACKBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 51}          @{"SGR_BLUE" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 45}         @{"SGR_BLUEBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 55}
@{"SGR_BOLD" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 30}             @{"SGR_CLR0" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 63}         @{"SGR_CLR0BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 72}
@{"SGR_CLR1" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 64}             @{"SGR_CLR1BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 73}       @{"SGR_CLR2" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 65}
@{"SGR_CLR2BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 74}           @{"SGR_CLR3" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 66}         @{"SGR_CLR3BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 75}
@{"SGR_CLR4" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 67}             @{"SGR_CLR4BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 76}       @{"SGR_CLR5" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 68}
@{"SGR_CLR5BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 77}           @{"SGR_CLR6" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 69}         @{"SGR_CLR6BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 78}
@{"SGR_CLR7" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 70}             @{"SGR_CLR7BG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 79}       @{"SGR_CYAN" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 47}
@{"SGR_CYANBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 57}           @{"SGR_DEFAULT" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 49}      @{"SGR_DEFAULTBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 59}
@{"SGR_GREEN" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 43}            @{"SGR_GREENBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 53}      @{"SGR_ITALIC" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 31}
@{"SGR_MAGENTA" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 46}          @{"SGR_MAGENTABG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 56}    @{"SGR_NEGATIVE" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 33}
@{"SGR_NORMAL" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 35}           @{"SGR_NOTITALIC" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 36}    @{"SGR_NOTUNDERSCORE" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 37}
@{"SGR_POSITIVE" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 38}         @{"SGR_PRIMARY" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 29}      @{"SGR_RED" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 42}
@{"SGR_REDBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 52}            @{"SGR_UNDERSCORE" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 32}   @{"SGR_WHITE" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 48}
@{"SGR_WHITEBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 58}          @{"SGR_YELLOW" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 44}       @{"SGR_YELLOWBG" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 54}
@{"TBC_HCLRTAB" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 92}          @{"TBC_HCLRTABSALL" LINK "gg:doc/NDK/Guide/Include/devices/console.h/File" 93}  

@ENDNODE
@NODE File "devices/console.h"
#ifndef DEVICES_CONSOLE_H
#define DEVICES_CONSOLE_H
/*
**      $VER: console.h 36.11 (7.11.1990)
**      Includes Release 45.1
**
**      Console device command definitions
**
**      (C) Copyright 1986-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include        <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef EXEC_IO_H
#include        <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif  /* EXEC_IO_H */

/****** Console commands ******/
#define @{"CD_ASKKEYMAP" LINK "gg:doc/NDK/Guide/console/CD_ASKKEYMAP"}            (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define @{"CD_SETKEYMAP" LINK "gg:doc/NDK/Guide/console/CD_SETKEYMAP"}            (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define @{"CD_ASKDEFAULTKEYMAP" LINK "gg:doc/NDK/Guide/console/CD_ASKDEFAULTKEYMAP"}     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define @{"CD_SETDEFAULTKEYMAP" LINK "gg:doc/NDK/Guide/console/CD_SETDEFAULTKEYMAP"}     (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)

/****** SGR parameters ******/

#define SGR_PRIMARY     0
#define SGR_BOLD        1
#define SGR_ITALIC      3
#define SGR_UNDERSCORE  4
#define SGR_NEGATIVE    7

#define SGR_NORMAL      22      /* default foreground color, not bold */
#define SGR_NOTITALIC   23
#define SGR_NOTUNDERSCORE 24
#define SGR_POSITIVE    27

/* these names refer to the ANSI standard, not the implementation */
#define SGR_BLACK       30
#define SGR_RED         31
#define SGR_GREEN       32
#define SGR_YELLOW      33
#define SGR_BLUE        34
#define SGR_MAGENTA     35
#define SGR_CYAN        36
#define SGR_WHITE       37
#define SGR_DEFAULT     39

#define SGR_BLACKBG     40
#define SGR_REDBG       41
#define SGR_GREENBG     42
#define SGR_YELLOWBG    43
#define SGR_BLUEBG      44
#define SGR_MAGENTABG   45
#define SGR_CYANBG      46
#define SGR_WHITEBG     47
#define SGR_DEFAULTBG   49

/* these names refer to the implementation, they are the preferred */
/* names for use with the Amiga console device. */
#define SGR_CLR0        30
#define SGR_CLR1        31
#define SGR_CLR2        32
#define SGR_CLR3        33
#define SGR_CLR4        34
#define SGR_CLR5        35
#define SGR_CLR6        36
#define SGR_CLR7        37

#define SGR_CLR0BG      40
#define SGR_CLR1BG      41
#define SGR_CLR2BG      42
#define SGR_CLR3BG      43
#define SGR_CLR4BG      44
#define SGR_CLR5BG      45
#define SGR_CLR6BG      46
#define SGR_CLR7BG      47


/****** DSR parameters ******/

#define DSR_CPR         6

/****** CTC parameters ******/
#define CTC_HSETTAB     0
#define CTC_HCLRTAB     2
#define CTC_HCLRTABSALL 5

/****** TBC parameters ******/
#define TBC_HCLRTAB     0
#define TBC_HCLRTABSALL 3

/****** SM and RM parameters ******/
#define M_LNM   20      /* linefeed newline mode */
#define M_ASM   ">1"    /* auto scroll mode */
#define M_AWM   "?7"    /* auto wrap mode */

#endif  /* DEVICES_CONSOLE_H */
@ENDNODE
