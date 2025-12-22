@DATABASE "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h"
@MASTER   "gg:os-include/libraries/mathieeedp.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/mathieeedp.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/mathieeedp.h" LINK File}


@{b}#defines@{ub}

@{"acos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 40}   @{"asin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 42}   @{"atan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 38}    @{"ceil" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 35}   @{"cos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 39}      @{"cosh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 50}    @{"E" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 21}        @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 43}
@{"fabs" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 33}   @{"floor" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 34}  @{"FPHALF" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 27}  @{"FPONE" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 26}  @{"FPTEN" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 25}    @{"FPZERO" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 28}  @{"itof()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 31}   @{"log" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 45}
@{"LOG10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 24}  @{"log10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 46}  @{"PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 13}      @{"PI2" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 17}    @{"PI4" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 18}      @{"pow()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 44}   @{"round()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 30}  @{"sin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 41}
@{"sinh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 49}   @{"sqrt" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 47}   @{"tan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 37}     @{"tanh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 51}   @{"trunc()" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 29}  @{"TWO_PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 16}  

@ENDNODE
@NODE File "libraries/mathieeedp.h"
#ifndef LIBRARIES_MATHIEEEDP_H
#define LIBRARIES_MATHIEEEDP_H
/*
**      $VER: mathieeedp.h 1.1 (13.7.1990)
**      Includes Release 45.1
**      Include file to use for <math.h>
**
**      (C) Copyright 1987-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef PI
#define @{"PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 15}      ((double)       3.141592653589793))
#endif

#define @{"TWO_PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 18}  (((double)      2)      * @{"PI" LINK File 13})
#define @{"PI2" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 19}     (@{"PI" LINK File 13}/((double)2))
#define @{"PI4" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 20}     (@{"PI" LINK File 13}/((double)4))

#ifndef E
#define @{"E" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 23}       ((double)       2.718281828459045)
#endif

#define @{"LOG10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 26}   ((double)       2.302585092994046)
#define @{"FPTEN" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 27}   ((double)       10.0)
#define @{"FPONE" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 28}   ((double)       1.0)
#define @{"FPHALF" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 29}  ((double)       0.5)
#define @{"FPZERO" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 30}  ((double)       0.0)
#define @{"trunc" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 31}(x)        ((int)  (x))
#define @{"round" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 32}(x)        ((int)  ((x) + 0.5))
#define @{"itof" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 33}(i)         ((double) (i))

#define @{"fabs" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 35}    IEEEDPAbs
#define @{"floor" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 36}   IEEEDPFloor
#define @{"ceil" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 37}    IEEEDPCeil

#define @{"tan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 39}     IEEEDPTan
#define @{"atan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 40}    IEEEDPAtan
#define @{"cos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 41}     IEEEDPCos
#define @{"acos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 42}    IEEEDPAcos
#define @{"sin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 43}     IEEEDPSin
#define @{"asin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 44}    IEEEDPAsin
#define @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 45}     IEEEDPExp
#define @{"pow" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 46}(a,b)        IEEEDPPow((b),(a))
#define @{"log" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 47}     IEEEDPLog
#define @{"log10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 48}   IEEEDPLog10
#define @{"sqrt" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 49}    IEEEDPSqrt

#define @{"sinh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 51}    IEEEDPSinh
#define @{"cosh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 52}    IEEEDPCosh
#define @{"tanh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeesp.h/File" 53}    IEEEDPTanh


#if 0 /* Use <clib/mathieeedoubbas_protos.h> and <clib/mathieeedoubtrans_protos.h> instead. */
double  IEEEDPTan(),IEEEDPAtan();
double  IEEEDPCos(),IEEEDPACos();
double  IEEEDPSin(),IEEEDPASin();
double  IEEEDPExp(),IEEEDPLog();
double  IEEEDPSqrt();
double  IEEEDPLog10(),IEEEDPPow();
double  IEEEDPSincos();
double  IEEEDPSinh(),IEEEDPCosh(),IEEEDPTanh();
float   IEEEDPTieee();
double  IEEEDPFieee();

int     IEEEDPFix();
int     IEEEDPCmp(),IEEEDPTst();
double  IEEEDPFlt();
double  IEEEDPAbs();
double  IEEEDPNeg();
double  IEEEDPAdd();
double  IEEEDPSub();
double  IEEEDPMul();
double  IEEEDPDiv();
double  IEEEDPFloor();
double  IEEEDPCeil();
#endif

#endif  /* LIBRARIES_MATHIEEEDP_H */
@ENDNODE
