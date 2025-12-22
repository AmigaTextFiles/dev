#ifndef FEELIN_RTG_H
#define FEELIN_RTG_H

/*

    This file defines some macros to use Picasso96 or CyberGraphics RTG

*/

#ifdef F_USE_PICASSO96

    #include <proto/Picasso96API.h>

    #ifdef __amigaos4__
    #define IP96_                               IP96 ->
    #else
    #define IP96_
    #endif
    #define RTGFXBASE                           P96Base
    #define RTGFXIFACESTRUCT                    P96IFace
    #define RTGFXIFACE                          IP96
    #define RTGFXLIBNAME                        P96NAME
    #define RTGFXLIBVERS                        2

#else /* CyberGraphics */

    #include <cybergraphx/cybergraphics.h>
    #include <proto/cybergraphics.h>

    #ifdef __amigaos4__
    #define ICYBERGFX                           ICyberGfx ->
    #else
    #define ICYBERGFX
    #endif
    #define RTGFXBASE                           CyberGfxBase
    #define RTGFXIFACESTRUCT                    CyberGfxIFace
    #define RTGFXIFACE                          ICyberGfx
    #define RTGFXLIBNAME                        CYBERGFXNAME
    #define RTGFXLIBVERS                        CYBERGFX_INCLUDE_VERSION

#endif

#endif

