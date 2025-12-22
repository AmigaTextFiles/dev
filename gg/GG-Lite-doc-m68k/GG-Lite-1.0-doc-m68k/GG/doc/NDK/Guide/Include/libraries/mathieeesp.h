@DATABASE "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h"
@MASTER   "gg:os-include/libraries/mathieeesp.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:56
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/mathieeesp.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/mathieeesp.h" LINK File}


@{b}#defines@{ub}

@{"acos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 42}   @{"asin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 44}   @{"atan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 40}    @{"ceil" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 37}   @{"cos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 41}      @{"cosh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 52}    @{"E" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 23}        @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 45}
@{"fabs" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 35}   @{"floor" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 36}  @{"FPHALF" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 29}  @{"FPONE" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 28}  @{"FPTEN" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 27}    @{"FPZERO" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 30}  @{"itof()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 33}   @{"log" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 47}
@{"LOG10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 26}  @{"log10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 48}  @{"PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 15}      @{"PI2" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 19}    @{"PI4" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 20}      @{"pow()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 46}   @{"round()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 32}  @{"sin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 43}
@{"sinh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 51}   @{"sqrt" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 49}   @{"tan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 39}     @{"tanh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 53}   @{"trunc()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 31}  @{"TWO_PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 18}  

@ENDNODE
@NODE File "libraries/mathieeesp.h"
#ifndef LIBRARIES_MATHIEEESP_H
#define LIBRARIES_MATHIEEESP_H
/*
**      $VER: mathieeesp.h 1.1 (13.7.1990)
**      Includes Release 45.1
**
**      Include file to use for <math.h>
**
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef PI
#define @{"PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 14}      ((float)        3.141592653589793))
#endif

#define @{"TWO_PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 16}  (((float)       2)      * @{"PI" LINK File 15})
#define @{"PI2" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 17}     (@{"PI" LINK File 15}/((float)2))
#define @{"PI4" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 18}     (@{"PI" LINK File 15}/((float)4))

#ifndef E
#define @{"E" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 20}       ((float)        2.718281828459045)
#endif

#define @{"LOG10" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 22}   ((float)        2.302585092994046)
#define @{"FPTEN" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 24}   ((float)        10.0)
#define @{"FPONE" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 25}   ((float)        1.0)
#define @{"FPHALF" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 26}  ((float)        0.5)
#define @{"FPZERO" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 27}  ((float)        0.0)
#define @{"trunc" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 29}(x)        ((int)  (x))
#define @{"round" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 30}(x)        ((int)  ((x) + 0.5))
#define @{"itof" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 31}(i)         ((float) (i))

#define @{"fabs" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 33}    IEEESPAbs
#define @{"floor" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 34}   IEEESPFloor
#define @{"ceil" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 35}    IEEESPCeil

#define @{"tan" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 37}     IEEESPTan
#define @{"atan" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 38}    IEEESPAtan
#define @{"cos" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 39}     IEEESPCos
#define @{"acos" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 40}    IEEESPAcos
#define @{"sin" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 41}     IEEESPSin
#define @{"asin" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 42}    IEEESPAsin
#define @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}     IEEESPExp
#define @{"pow" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 44}(a,b)        IEEESPPow((b),(a))
#define @{"log" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 45}     IEEESPLog
#define @{"log10" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 46}   IEEESPLog10
#define @{"sqrt" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 47}    IEEESPSqrt

#define @{"sinh" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 49}    IEEESPSinh
#define @{"cosh" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 50}    IEEESPCosh
#define @{"tanh" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 51}    IEEESPTanh

#if 0 /* Use <clib/mathieeesingbas_protos.h> and <clib/mathieeesingtrans_protos.h> instead. */
float   IEEESPTan(),IEEESPAtan();
float   IEEESPCos(),IEEESPACos();
float   IEEESPSin(),IEEESPASin();
float   IEEESPExp(),IEEESPLog();
float   IEEESPSqrt();
float   IEEESPLog10(),IEEESPPow();
float   IEEESPSincos();
float   IEEESPSinh(),IEEESPCosh(),IEEESPTanh();
float   IEEESPTieee();
float   IEEESPFieee();

int     IEEESPFix();
int     IEEESPCmp(),IEEESPTst();
float   IEEESPFlt();
float   IEEESPAbs();
float   IEEESPNeg();
float   IEEESPAdd();
float   IEEESPSub();
float   IEEESPMul();
float   IEEESPDiv();
float   IEEESPFloor();
float   IEEESPCeil();
#endif

#endif  /* LIBRARIES_MATHIEEESP_H */
@ENDNODE
