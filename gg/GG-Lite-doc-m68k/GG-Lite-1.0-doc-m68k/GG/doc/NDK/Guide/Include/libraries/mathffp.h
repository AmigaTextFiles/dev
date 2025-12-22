@DATABASE "gg:doc/NDK/Guide/Include/libraries/mathffp.h"
@MASTER   "gg:os-include/libraries/mathffp.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:16:55
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "libraries/mathffp.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"libraries/mathffp.h" LINK File}


@{b}#defines@{ub}

@{"acos" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 40}   @{"asin" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 42}   @{"atan" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 38}    @{"ceil" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 35}   @{"cos" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 39}      @{"cosh" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 50}    @{"E" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 20}        @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 43}
@{"fabs" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 33}   @{"floor" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 34}  @{"FPHALF" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 26}  @{"FPONE" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 25}  @{"FPTEN" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 24}    @{"FPZERO" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 27}  @{"itof()" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 31}   @{"log" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 45}
@{"LOG10" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 22}  @{"log10" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 46}  @{"PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 14}      @{"PI2" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 17}    @{"PI4" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 18}      @{"pow()" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 44}   @{"round()" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 30}  @{"sin" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 41}
@{"sinh" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 49}   @{"sqrt" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 47}   @{"tan" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 37}     @{"tanh" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 51}   @{"trunc()" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 29}  @{"TWO_PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathffp.h/File" 16}  

@ENDNODE
@NODE File "libraries/mathffp.h"
#ifndef LIBRARIES_MATHFFP_H
#define LIBRARIES_MATHFFP_H 1
/*
**      $VER: mathffp.h 36.2 (1.5.1990)
**      Includes Release 45.1
**
**      general floating point declarations
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef PI
#define @{"PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 13}        ((float) 3.141592653589793)
#endif
#define @{"TWO_PI" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 16}    (((float) 2) * @{"PI" LINK File 14})
#define @{"PI2" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 17}       (@{"PI" LINK File 14} / ((float) 2))
#define @{"PI4" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 18}       (@{"PI" LINK File 14} / ((float) 4))
#ifndef E
#define @{"E" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 21}         ((float) 2.718281828459045)
#endif
#define @{"LOG10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 24}     ((float) 2.302585092994046)

#define @{"FPTEN" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 25}     ((float) 10.0)
#define @{"FPONE" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 26}     ((float) 1.0)
#define @{"FPHALF" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 27}    ((float) 0.5)
#define @{"FPZERO" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 28}    ((float) 0.0)

#define @{"trunc" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 29}(x)  ((int) (x))
#define @{"round" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 30}(x)  ((int) ((x) + 0.5))
#define @{"itof" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 31}(i)   ((float) (i))

#define @{"fabs" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 33}    SPAbs
#define @{"floor" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 34}   SPFloor
#define @{"ceil" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 35}    SPCeil

#define @{"tan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 37}     SPTan
#define @{"atan" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 38}    SPAtan
#define @{"cos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 39}     SPCos
#define @{"acos" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 40}    SPAcos
#define @{"sin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 41}     SPSin
#define @{"asin" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 42}    SPAsin
#define @{"exp" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 43}     SPExp
#define @{"pow" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 44}(a,b)        SPPow((b),(a))
#define @{"log" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 45}     SPLog
#define @{"log10" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 46}   SPLog10
#define @{"sqrt" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 47}    SPSqrt

#define @{"sinh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 49}    SPSinh
#define @{"cosh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 50}    SPCosh
#define @{"tanh" LINK "gg:doc/NDK/Guide/Include/libraries/mathieeedp.h/File" 51}    SPTanh

#endif  /* LIBRARIES_MATHFFP_H */
@ENDNODE
