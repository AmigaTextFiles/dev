@DATABASE "gg:doc/NDK/Guide/Include/devices/printer.h"
@MASTER   "gg:os-include/devices/printer.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:32
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/printer.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/printer.h" LINK File}


@{b}Structures@{ub}

@{"DRPSourceMsg" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 315}  @{"IODRPReq" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 174}       @{"IODRPTagsReq" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 197}  @{"IOPrefsReq" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 400}  @{"IOPrtCmdReq" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 156}
@{"IOPrtErrReq" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 362}   @{"IOPrtPrefsReq" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 340}  @{"PrtErrMsg" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 384}     


@{b}#defines@{ub}

@{"aBMS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 136}                  @{"aCAM" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 139}                    @{"aDEN1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 78}
@{"aDEN2" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 77}                 @{"aDEN3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 76}                   @{"aDEN4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 75}
@{"aDEN5" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 74}                 @{"aDEN6" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 73}                   @{"aEXTEND" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 149}
@{"aFNT0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 88}                 @{"aFNT1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 89}                   @{"aFNT10" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 98}
@{"aFNT2" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 90}                 @{"aFNT3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 91}                   @{"aFNT4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 92}
@{"aFNT5" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 93}                 @{"aFNT6" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 94}                   @{"aFNT7" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 95}
@{"aFNT8" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 96}                 @{"aFNT9" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 97}                   @{"aHTS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 141}
@{"aIND" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 51}                  @{"aJFY0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 123}                   @{"aJFY1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 125}
@{"aJFY3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 124}                 @{"aJFY5" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 120}                   @{"aJFY6" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 122}
@{"aJFY7" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 121}                 @{"aLMS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 133}                    @{"aNEL" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 52}
@{"aPERF" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 130}                 @{"aPERF0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 131}                  @{"aPLD" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 86}
@{"aPLU" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 85}                  @{"aPROP0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 118}                  @{"aPROP1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 117}
@{"aPROP2" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 116}                @{"aRAW" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 151}                    @{"aRI" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 53}
@{"aRIN" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 50}                  @{"aRIS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 49}                    @{"aRMS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 134}
@{"aSBC" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 63}                  @{"aSFC" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 62}                    @{"aSGR0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 55}
@{"aSGR1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 60}                 @{"aSGR22" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 61}                  @{"aSGR23" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 57}
@{"aSGR24" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 59}                @{"aSGR3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 56}                   @{"aSGR4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 58}
@{"aSHORP0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 65}               @{"aSHORP1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 67}                 @{"aSHORP2" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 66}
@{"aSHORP3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 69}               @{"aSHORP4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 68}                 @{"aSHORP5" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 71}
@{"aSHORP6" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 70}               @{"aSLPP" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 129}                   @{"aSLRM" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 138}
@{"aSTBM" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 137}                 @{"aSUS0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 84}                   @{"aSUS1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 81}
@{"aSUS2" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 80}                 @{"aSUS3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 83}                   @{"aSUS4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 82}
@{"aTBC0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 143}                 @{"aTBC1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 145}                   @{"aTBC3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 144}
@{"aTBC4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 146}                 @{"aTBCALL" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 147}                 @{"aTBSALL" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 148}
@{"aTMS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 135}                  @{"aTSS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 119}                    @{"aVERP0" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 127}
@{"aVERP1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 128}                @{"aVTS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 142}                    @{"DRPA_AspectX" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 327}
@{"DRPA_AspectY" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 328}          @{"DRPA_Dummy" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 291}              @{"DRPA_ICCName" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 298}
@{"DRPA_ICCProfile" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 297}       @{"DRPA_NoColCorrect" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 299}       @{"DRPA_SourceHook" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 306}
@{"PDERR_BADDIMENSION" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 255}    @{"PDERR_BADPREFERENCES" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 269}    @{"PDERR_BUFFERMEMORY" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 258}
@{"PDERR_CANCEL" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 252}          @{"PDERR_DIMENSIONOVFLOW" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 256}   @{"PDERR_FIRSTCUSTOM" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 278}
@{"PDERR_INTERNALMEMORY" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 257}  @{"PDERR_INVERTHAM" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 254}         @{"PDERR_LASTCUSTOM" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 279}
@{"PDERR_LASTSTANDARD" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 277}    @{"PDERR_NOERR" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 251}             @{"PDERR_NOTGRAPHICS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 253}
@{"PDERR_TOOKCONTROL" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 267}     @{"PDHOOK_NONE" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 359}             @{"PDHOOK_STD" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 360}
@{"PDHOOK_VERSION" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 394}        @{"PPRA_Dummy" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 334}              @{"PPRA_PubScreen" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 353}
@{"PPRA_Screen" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 352}           @{"PPRA_Window" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 351}             @{"PRD_DUMPRPORT" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 31}
@{"PRD_DUMPRPORTTAGS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 43}     @{"PRD_EDITPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 41}           @{"PRD_LOADPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 36}
@{"PRD_PRTCOMMAND" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 30}        @{"PRD_QUERY" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 32}               @{"PRD_RAWWRITE" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 29}
@{"PRD_READPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 39}         @{"PRD_RESETPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 35}          @{"PRD_SAVEPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 38}
@{"PRD_SETERRHOOK" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 42}        @{"PRD_USEPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 37}            @{"PRD_WRITEPREFS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 40}
@{"SPECIAL_ASPECT" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 227}        @{"SPECIAL_CENTER" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 226}          @{"SPECIAL_DENSITY1" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 228}
@{"SPECIAL_DENSITY2" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 229}      @{"SPECIAL_DENSITY3" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 230}        @{"SPECIAL_DENSITY4" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 231}
@{"SPECIAL_DENSITY5" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 232}      @{"SPECIAL_DENSITY6" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 233}        @{"SPECIAL_DENSITY7" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 234}
@{"SPECIAL_DENSITYMASK" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 282}   @{"SPECIAL_DIMENSIONSMASK" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 283}  @{"SPECIAL_FRACCOLS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 224}
@{"SPECIAL_FRACROWS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 225}      @{"SPECIAL_FULLCOLS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 222}        @{"SPECIAL_FULLROWS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 223}
@{"SPECIAL_MILCOLS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 220}       @{"SPECIAL_MILROWS" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 221}         @{"SPECIAL_NOFORMFEED" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 235}
@{"SPECIAL_NOPRINT" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 247}       @{"SPECIAL_TRUSTME" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 236}         

@ENDNODE
@NODE File "devices/printer.h"
#ifndef DEVICES_PRINTER_H
#define DEVICES_PRINTER_H
/*
**      $VER: printer.h 44.1 (19.10.1999)
**      Includes Release 45.1
**
**      @{"printer.device" LINK "gg:doc/NDK/Guide/printer/MAIN"} structure definitions
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/


#ifndef EXEC_DEVICES_H
#include <@{"exec/devices.h" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File"}>
#endif

#ifndef INTUITION_INTUITION_H
#include <@{"intuition/intuition.h" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File"}>
#endif

#ifndef UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif

/****************************************************************************/

/* V34-V40 commands */
#define @{"PRD_RAWWRITE" LINK "gg:doc/NDK/Guide/printer/PRD_RAWWRITE"}            (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+0)
#define @{"PRD_PRTCOMMAND" LINK "gg:doc/NDK/Guide/printer/PRD_PRTCOMMAND"}          (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+1)
#define @{"PRD_DUMPRPORT" LINK "gg:doc/NDK/Guide/printer/PRD_DUMPRPORT"}           (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+2)
#define @{"PRD_QUERY" LINK "gg:doc/NDK/Guide/printer/PRD_QUERY"}               (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+3)

/* V44 commands */
#define PRD_RESETPREFS          (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+4)  /* PRIVATE: do not use! */
#define PRD_LOADPREFS           (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+5)  /* PRIVATE: do not use! */
#define PRD_USEPREFS            (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+6)  /* PRIVATE: do not use! */
#define PRD_SAVEPREFS           (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+7)  /* PRIVATE: do not use! */
#define @{"PRD_READPREFS" LINK "gg:doc/NDK/Guide/printer/PRD_READPREFS"}           (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+8)
#define @{"PRD_WRITEPREFS" LINK "gg:doc/NDK/Guide/printer/PRD_WRITEPREFS"}          (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+9)
#define @{"PRD_EDITPREFS" LINK "gg:doc/NDK/Guide/printer/PRD_EDITPREFS"}           (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+10)
#define @{"PRD_SETERRHOOK" LINK "gg:doc/NDK/Guide/printer/PRD_SETERRHOOK"}          (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+11)
#define @{"PRD_DUMPRPORTTAGS" LINK "gg:doc/NDK/Guide/printer/PRD_DUMPRPORTTAGS"}       (@{"CMD_NONSTD" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 59}+12)

/****************************************************************************/

/* printer command definitions */

#define aRIS    0       /* ESCc  reset                    ISO */
#define aRIN    1       /* ESC#1 initialize               +++ */
#define aIND    2       /* ESCD  lf                       ISO */
#define aNEL    3       /* ESCE  return,lf                ISO */
#define aRI     4       /* ESCM  reverse lf               ISO */

#define aSGR0   5       /* ESC[0m normal char set         ISO */
#define aSGR3   6       /* ESC[3m italics on              ISO */
#define aSGR23  7       /* ESC[23m italics off            ISO */
#define aSGR4   8       /* ESC[4m underline on            ISO */
#define aSGR24  9       /* ESC[24m underline off          ISO */
#define aSGR1   10      /* ESC[1m boldface on             ISO */
#define aSGR22  11      /* ESC[22m boldface off           ISO */
#define aSFC    12      /* SGR30-39  set foreground color ISO */
#define aSBC    13      /* SGR40-49  set background color ISO */

#define aSHORP0 14      /* ESC[0w normal pitch            DEC */
#define aSHORP2 15      /* ESC[2w elite on                DEC */
#define aSHORP1 16      /* ESC[1w elite off               DEC */
#define aSHORP4 17      /* ESC[4w condensed fine on       DEC */
#define aSHORP3 18      /* ESC[3w condensed off           DEC */
#define aSHORP6 19      /* ESC[6w enlarged on             DEC */
#define aSHORP5 20      /* ESC[5w enlarged off            DEC */

#define aDEN6   21      /* ESC[6"z shadow print on        DEC (sort of) */
#define aDEN5   22      /* ESC[5"z shadow print off       DEC */
#define aDEN4   23      /* ESC[4"z doublestrike on        DEC */
#define aDEN3   24      /* ESC[3"z doublestrike off       DEC */
#define aDEN2   25      /* ESC[2"z  NLQ on                DEC */
#define aDEN1   26      /* ESC[1"z  NLQ off               DEC */

#define aSUS2   27      /* ESC[2v superscript on          +++ */
#define aSUS1   28      /* ESC[1v superscript off         +++ */
#define aSUS4   29      /* ESC[4v subscript on            +++ */
#define aSUS3   30      /* ESC[3v subscript off           +++ */
#define aSUS0   31      /* ESC[0v normalize the line      +++ */
#define aPLU    32      /* ESCL  partial line up          ISO */
#define aPLD    33      /* ESCK  partial line down        ISO */

#define aFNT0   34      /* ESC(B US char set        or Typeface  0 (default) */
#define aFNT1   35      /* ESC(R French char set    or Typeface  1 */
#define aFNT2   36      /* ESC(K German char set    or Typeface  2 */
#define aFNT3   37      /* ESC(A UK char set        or Typeface  3 */
#define aFNT4   38      /* ESC(E Danish I char set  or Typeface  4 */
#define aFNT5   39      /* ESC(H Sweden char set    or Typeface  5 */
#define aFNT6   40      /* ESC(Y Italian char set   or Typeface  6 */
#define aFNT7   41      /* ESC(Z Spanish char set   or Typeface  7 */
#define aFNT8   42      /* ESC(J Japanese char set  or Typeface  8 */
#define aFNT9   43      /* ESC(6 Norweign char set  or Typeface  9 */
#define aFNT10  44      /* ESC(C Danish II char set or Typeface 10 */

/*
        Suggested typefaces are:

         0 - default typeface.
         1 - Line Printer or equiv.
         2 - Pica or equiv.
         3 - Elite or equiv.
         4 - Helvetica or equiv.
         5 - Times Roman or equiv.
         6 - Gothic or equiv.
         7 - Script or equiv.
         8 - Prestige or equiv.
         9 - Caslon or equiv.
        10 - Orator or equiv.
*/

#define aPROP2  45      /* ESC[2p  proportional on        +++ */
#define aPROP1  46      /* ESC[1p  proportional off       +++ */
#define aPROP0  47      /* ESC[0p  proportional clear     +++ */
#define aTSS    48      /* ESC[n E set proportional offset ISO */
#define aJFY5   49      /* ESC[5 F auto left justify      ISO */
#define aJFY7   50      /* ESC[7 F auto right justify     ISO */
#define aJFY6   51      /* ESC[6 F auto full justify      ISO */
#define aJFY0   52      /* ESC[0 F auto justify off       ISO */
#define aJFY3   53      /* ESC[3 F letter space (justify) ISO (special) */
#define aJFY1   54      /* ESC[1 F word fill(auto center) ISO (special) */

#define aVERP0  55      /* ESC[0z  1/8" line spacing      +++ */
#define aVERP1  56      /* ESC[1z  1/6" line spacing      +++ */
#define aSLPP   57      /* ESC[nt  set form length n      DEC */
#define aPERF   58      /* ESC[nq  perf skip n (n>0)      +++ */
#define aPERF0  59      /* ESC[0q  perf skip off          +++ */

#define aLMS    60      /* ESC#9   Left margin set        +++ */
#define aRMS    61      /* ESC#0   Right margin set       +++ */
#define aTMS    62      /* ESC#8   Top margin set         +++ */
#define aBMS    63      /* ESC#2   Bottom marg set        +++ */
#define aSTBM   64      /* ESC[Pn1;Pn2r  T&B margins      DEC */
#define aSLRM   65      /* ESC[Pn1;Pn2s  L&R margin       DEC */
#define aCAM    66      /* ESC#3   Clear margins          +++ */

#define aHTS    67      /* ESCH    Set horiz tab          ISO */
#define aVTS    68      /* ESCJ    Set vertical tabs      ISO */
#define aTBC0   69      /* ESC[0g  Clr horiz tab          ISO */
#define aTBC3   70      /* ESC[3g  Clear all h tab        ISO */
#define aTBC1   71      /* ESC[1g  Clr vertical tabs      ISO */
#define aTBC4   72      /* ESC[4g  Clr all v tabs         ISO */
#define aTBCALL 73      /* ESC#4   Clr all h & v tabs     +++ */
#define aTBSALL 74      /* ESC#5   Set default tabs       +++ */
#define aEXTEND 75      /* ESC[Pn"x extended commands     +++ */

#define aRAW    76      /*      ESC[Pn"r        Next    'Pn' chars are raw +++ */

/****************************************************************************/

/* For @{"PRD_PRTCOMMAND" LINK "gg:doc/NDK/Guide/printer/PRD_PRTCOMMAND"} */
struct IOPrtCmdReq
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}  io_Message;
        @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} * io_Device;      /* device node pointer  */
        @{"struct Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} *   io_Unit;        /* unit (driver private)*/
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           io_Command;     /* device command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           io_Flags;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}            io_Error;       /* error or warning num */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           io_PrtCommand;  /* printer command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           io_Parm0;       /* first command parameter */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           io_Parm1;       /* second command parameter */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           io_Parm2;       /* third command parameter */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           io_Parm3;       /* fourth command parameter */
};

/****************************************************************************/

/* For @{"PRD_DUMPRPORT" LINK "gg:doc/NDK/Guide/printer/PRD_DUMPRPORT"} */
struct IODRPReq
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}          io_Message;
        @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *         io_Device;      /* device node pointer  */
        @{"struct Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} *           io_Unit;        /* unit (driver private)*/
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_Command;     /* device command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                   io_Flags;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                    io_Error;       /* error or warning num */
        @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *       io_RastPort;    /* raster port */
        @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *       io_ColorMap;    /* color map */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   io_Modes;       /* graphics viewport modes */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcX;        /* source x origin */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcY;        /* source y origin */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcWidth;    /* source x width */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcHeight;   /* source x height */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    io_DestCols;    /* destination x width */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    io_DestRows;    /* destination y height */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_Special;     /* option flags */
};

/****************************************************************************/

/* For @{"PRD_DUMPRPORTTAGS" LINK "gg:doc/NDK/Guide/printer/PRD_DUMPRPORTTAGS"} (V44) */
struct IODRPTagsReq
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}          io_Message;
        @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *         io_Device;      /* device node pointer  */
        @{"struct Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} *           io_Unit;        /* unit (driver private)*/
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_Command;     /* device command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                   io_Flags;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                    io_Error;       /* error or warning num */
        @{"struct RastPort" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 52} *       io_RastPort;    /* raster port */
        @{"struct ColorMap" LINK "gg:doc/NDK/Guide/Include/graphics/view.h/File" 143} *       io_ColorMap;    /* color map */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   io_Modes;       /* graphics viewport modes */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcX;        /* source x origin */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcY;        /* source y origin */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcWidth;    /* source x width */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_SrcHeight;   /* source x height */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    io_DestCols;    /* destination x width */
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51}                    io_DestRows;    /* destination y height */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_Special;     /* option flags */
        @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *        io_TagList;     /* tag list with additional info */
};

/****************************************************************************/

#define SPECIAL_MILCOLS         0x0001  /* DestCols specified in 1/1000" */
#define SPECIAL_MILROWS         0x0002  /* DestRows specified in 1/1000" */
#define SPECIAL_FULLCOLS        0x0004  /* make DestCols maximum possible */
#define SPECIAL_FULLROWS        0x0008  /* make DestRows maximum possible */
#define SPECIAL_FRACCOLS        0x0010  /* DestCols is fraction of FULLCOLS */
#define SPECIAL_FRACROWS        0x0020  /* DestRows is fraction of FULLROWS */
#define SPECIAL_CENTER          0x0040  /* center image on paper */
#define SPECIAL_ASPECT          0x0080  /* ensure correct aspect ratio */
#define SPECIAL_DENSITY1        0x0100  /* lowest resolution (dpi) */
#define SPECIAL_DENSITY2        0x0200  /* next res */
#define SPECIAL_DENSITY3        0x0300  /* next res */
#define SPECIAL_DENSITY4        0x0400  /* next res */
#define SPECIAL_DENSITY5        0x0500  /* next res */
#define SPECIAL_DENSITY6        0x0600  /* next res */
#define SPECIAL_DENSITY7        0x0700  /* highest res */
#define SPECIAL_NOFORMFEED      0x0800  /* don't eject paper on gfx prints */
#define SPECIAL_TRUSTME         0x1000  /* don't reset on gfx prints */

/*
        Compute print size, set 'io_DestCols' and 'io_DestRows' in the calling
        program's 'IODRPReq' structure and exit, DON'T PRINT.  This allows the
        calling program to see what the final print size would be in printer
        pixels.  Note that it modifies the 'io_DestCols' and 'io_DestRows'
        fields of your 'IODRPReq' structure.  Also, set the print density and
        update the 'MaxXDots', 'MaxYDots', 'XDotsInch', and 'YDotsInch' fields
        of the 'PrinterExtendedData' structure.
*/
#define SPECIAL_NOPRINT         0x2000  /* see above */

/****************************************************************************/

#define PDERR_NOERR             0       /* clean exit, no errors */
#define PDERR_CANCEL            1       /* user cancelled print */
#define PDERR_NOTGRAPHICS       2       /* printer cannot output graphics */
#define PDERR_INVERTHAM         3       /* OBSOLETE */
#define PDERR_BADDIMENSION      4       /* print dimensions illegal */
#define PDERR_DIMENSIONOVFLOW   5       /* OBSOLETE */
#define PDERR_INTERNALMEMORY    6       /* no memory for internal variables */
#define PDERR_BUFFERMEMORY      7       /* no memory for print buffer */

/*
        Note : this is an internal error that can be returned from the render
        function to the printer device.  It is NEVER returned to the user.
        If the printer device sees this error it converts it '@{"PDERR_NOERR" LINK File 251}'
        and exits gracefully.  Refer to the document on
        'How to Write a Graphics Printer Driver' for more info.
*/
#define PDERR_TOOKCONTROL       8       /* Took control in case 0 of render */

#define PDERR_BADPREFERENCES    9       /* preferences file corrupt */

/*
        Note: all error codes < 32 are reserved for @{"printer.device" LINK "gg:doc/NDK/Guide/printer/MAIN"}.
        All error codes >= 32 and < 127 are reserved for driver specific
        errors. Negative errors are reserved for system use (standard I/O
        errors) and error code 127 is reserved for future expansion.
*/
#define PDERR_LASTSTANDARD      31
#define PDERR_FIRSTCUSTOM       32
#define PDERR_LASTCUSTOM        126

/* internal use */
#define SPECIAL_DENSITYMASK     0x0700  /* masks out density values */
#define SPECIAL_DIMENSIONSMASK \\
        (@{"SPECIAL_MILCOLS" LINK File 220}|@{"SPECIAL_MILROWS" LINK File 221}|@{"SPECIAL_FULLCOLS" LINK File 222}|@{"SPECIAL_FULLROWS" LINK File 223}\\
        |@{"SPECIAL_FRACCOLS" LINK File 224}|@{"SPECIAL_FRACROWS" LINK File 225}|@{"SPECIAL_ASPECT" LINK File 227})

/****************************************************************************/

/* The following tags are used for @{"PRD_DUMPRPORTTAGS" LINK "gg:doc/NDK/Guide/printer/PRD_DUMPRPORTTAGS"} */

#define DRPA_Dummy (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 0x60000)

/****************************************************************************/

/* The following tags are not implemented but reserved for future use. */

#define DRPA_ICCProfile         (@{"DRPA_Dummy" LINK File 291}+1) /* @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} */
#define DRPA_ICCName            (@{"DRPA_Dummy" LINK File 291}+2) /* @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} */
#define DRPA_NoColCorrect       (@{"DRPA_Dummy" LINK File 291}+3) /* LBOOL */

/****************************************************************************/

/* If the following tag is used io_RastPort and io_ColorMap are
   ignored.
*/
#define DRPA_SourceHook   (@{"DRPA_Dummy" LINK File 291}+4) /* @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} * */

/* The source hook (@{"DRPA_SourceHook" LINK File 306}) is called with object @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101} and
   message is a pointer to the following struct.

                @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} hook(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} * hook,
                          @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dummy,
                          @{"struct DRPSourceMsg" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 315} * drpm);
*/
struct DRPSourceMsg {
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} x;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} y;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} width;
        @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} height;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *buf; /* fill this buffer with 0x00RRGGBB pixels */
};

/****************************************************************************/

/* If these tags are used io_Modes is ignored for aspect ratio */

#define DRPA_AspectX      (@{"DRPA_Dummy" LINK File 291}+5) /* @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} */
#define DRPA_AspectY      (@{"DRPA_Dummy" LINK File 291}+6) /* @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} */

/****************************************************************************/

/* The following tags are used for @{"PRD_EDITPREFS" LINK "gg:doc/NDK/Guide/printer/PRD_EDITPREFS"} */

#define PPRA_Dummy (@{"TAG_USER" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 48} + 0x70000)

/****************************************************************************/

/* Request to edit prefs (for @{"PRD_EDITPREFS" LINK "gg:doc/NDK/Guide/printer/PRD_EDITPREFS"}; V44) */

struct IOPrtPrefsReq
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}          io_Message;
        @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *         io_Device;      /* device node pointer  */
        @{"struct Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} *           io_Unit;        /* unit (driver private)*/
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                   io_Command;     /* device command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                   io_Flags;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                    io_Error;       /* error or warning num */
        @{"struct  TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *       io_TagList;     /* requester tag list */
};

#define PPRA_Window     (@{"PPRA_Dummy" LINK File 334}+1) /* @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} * */
#define PPRA_Screen     (@{"PPRA_Dummy" LINK File 334}+2) /* @{"struct Screen" LINK "gg:doc/NDK/Guide/Include/intuition/screens.h/File" 133} * */
#define PPRA_PubScreen  (@{"PPRA_Dummy" LINK File 334}+3) /* @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} */

/****************************************************************************/

/* Request to set error hook (for @{"PRD_SETERRHOOK" LINK "gg:doc/NDK/Guide/printer/PRD_SETERRHOOK"}; V44)*/

#define PDHOOK_NONE     ((@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) @{"NULL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 101})
#define PDHOOK_STD      ((@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *) 1)

struct IOPrtErrReq
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}  io_Message;
        @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} * io_Device;      /* device node pointer  */
        @{"struct Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} *   io_Unit;        /* unit (driver private)*/
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}           io_Command;     /* device command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}           io_Flags;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}            io_Error;       /* error or warning num */
        @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *   io_Hook;
};

/****************************************************************************/

/*
        The error hook is called with the IORequest that caused the error as
        object (2nd Parameter) and a pointer to @{"struct PrtErrMsg" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 384} as message
        (3rd Parameter):

                @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} hook(@{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} * hook,
                          struct printerIO * ior,
                          @{"struct PrtErrMsg" LINK "gg:doc/NDK/Guide/Include/devices/printer.h/File" 384} * pem);
*/
struct PrtErrMsg
{
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   pe_Version;     /* Version of this struct */
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52}                   pe_ErrorLevel;  /* @{"RETURN_WARN" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 233}, @{"RETURN_ERROR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 234}, @{"RETURN_FAIL" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 235} */
        @{"struct Window" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 909} *         pe_Window;      /* window for @{"EasyRequest()" LINK "gg:doc/NDK/Guide/intuition/EasyRequestArgs"} */
        @{"struct EasyStruct" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1457} *     pe_ES;
        @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} *                 pe_IDCMP;
        @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49}                    pe_ArgList;
};

#define PDHOOK_VERSION 1

/****************************************************************************/

/* PRIVATE: Request to change prefs temporary. DO @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} USE! */

struct IOPrefsReq
{
        @{"struct Message" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 47}                  io_Message;
        @{"struct Device" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 24} *                 io_Device;      /* device node pointer  */
        @{"struct Unit" LINK "gg:doc/NDK/Guide/Include/exec/devices.h/File" 31} *                   io_Unit;        /* unit (driver private)*/
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}                           io_Command;     /* device command */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}                           io_Flags;
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}                            io_Error;       /* error or warning num */
        @{"struct PrinterTxtPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 29} *        io_TxtPrefs;
        @{"struct PrinterUnitPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 87} *       io_UnitPrefs;
        @{"struct PrinterDeviceUnitPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printertxt.h/File" 98} * io_DevUnitPrefs;
        @{"struct PrinterGfxPrefs" LINK "gg:doc/NDK/Guide/Include/prefs/printergfx.h/File" 31} *        io_GfxPrefs;
};

#endif /* DEVICES_PRINTER_H */
@ENDNODE
