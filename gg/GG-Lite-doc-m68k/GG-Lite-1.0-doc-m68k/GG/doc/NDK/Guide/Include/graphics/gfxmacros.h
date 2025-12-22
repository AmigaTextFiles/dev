@DATABASE "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h"
@MASTER   "gg:os-include/graphics/gfxmacros.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:58
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "graphics/gfxmacros.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"graphics/gfxmacros.h" LINK File}


@{b}#defines@{ub}

@{"AreaCircle()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 69}  @{"BNDRYOFF()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 61}  @{"CEND()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 66}               @{"CINIT()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 63}
@{"CMOVE()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 64}       @{"CWAIT()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 65}     @{"DrawCircle()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 68}         @{"GetOutlinePen()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 59}
@{"OFF_DISPLAY" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 40}   @{"OFF_SPRITE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 42}  @{"OFF_VBLANK" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 45}           @{"ON_DISPLAY" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 39}
@{"ON_SPRITE" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 41}     @{"ON_VBLANK" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 44}   @{"SafeSetOutlinePen()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 55}  @{"SafeSetWriteMask()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 56}
@{"SetAfPt()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 48}     @{"SetDrPt()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 47}   @{"SetOPen()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 50}            @{"SetWrMsk()" LINK "gg:doc/NDK/Guide/Include/graphics/gfxmacros.h/File" 51}

@ENDNODE
@NODE File "graphics/gfxmacros.h"
#ifndef GRAPHICS_GFXMACROS_H
#define GRAPHICS_GFXMACROS_H
/*
**      $VER: gfxmacros.h 39.3 (31.5.1993)
**      Includes Release 45.1
**
**
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifndef EXEC_TYPES_H
#include <@{"exec/types.h" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File"}>
#endif

#ifndef  GRAPHICS_RASTPORT_H
#include <@{"graphics/rastport.h" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File"}>
#endif

#ifndef  GRAPHICS_GFXBASE_H
#include <@{"graphics/gfxbase.h" LINK "gg:doc/NDK/Guide/Include/graphics/gfxbase.h/File"}>
#endif

#ifndef  HARDWARE_CUSTOM_H
#include <@{"hardware/custom.h" LINK "gg:doc/NDK/Guide/Include/hardware/custom.h/File"}>
#endif

#ifndef  HARDWARE_DMABITS_H
#include <@{"hardware/dmabits.h" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File"}>
#endif

/* NOTE: Define the following symbol in your source code
 *       if you need the old style macros defined below.
 *       Otherwise you will get the more robust versions
 *       instead.
 */
#ifdef OLD_GRAPHICS_GFXMACROS_H
#define @{"ON_DISPLAY" LINK "File" 73}      custom.dmacon = @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}|@{"DMAF_RASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 24};
#define @{"OFF_DISPLAY" LINK "File" 74}     custom.dmacon = @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}|@{"DMAF_RASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 24};
#define @{"ON_SPRITE" LINK "File" 75}       custom.dmacon = @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}|@{"DMAF_SPRITE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 21};
#define @{"OFF_SPRITE" LINK "File" 76}      custom.dmacon = @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}|@{"DMAF_SPRITE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 21};

#define @{"ON_VBLANK" LINK "File" 78}       custom.intena = @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}|@{"INTF_VERTB" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 44};
#define @{"OFF_VBLANK" LINK "File" 79}      custom.intena = @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}|@{"INTF_VERTB" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 44};

#define @{"SetDrPt" LINK "File" 82}(w,p)    {(w)->LinePtrn = p;(w)->Flags |= @{"FRST_DOT" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 96};(w)->linpatcnt=15;}
#define @{"SetAfPt" LINK "File" 88}(w,p,n)  {(w)->AreaPtrn = p;(w)->AreaPtSz = n;}

#define @{"SetOPen" LINK "File" 93}(w,c)    {(w)->AOlPen = c;(w)->Flags |= @{"AREAOUTLINE" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 103};}
#define @{"SetWrMsk" LINK "File" 98}(w,m)   {(w)->Mask = m;}

/* the SafeSetxxx macros are backwards (pre V39 graphics) compatible versions */
/* using these macros will make your code do the right thing under V39 AND V37 */
#define @{"SafeSetOutlinePen" LINK "File" 105}(w,c)    {if (GfxBase->LibNode.lib_Version<39) { (w)->AOlPen = c;(w)->Flags |= @{"AREAOUTLINE" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 103};} else @{"SetOutlinePen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 669}(w,c); }
#define @{"SafeSetWriteMask" LINK "File" 112}(w,m)   {if (GfxBase->LibNode.lib_Version<39) { (w)->Mask = (m);} else @{"SetWriteMask" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 673}(w,m); }

/* synonym for @{"GetOPen" LINK "gg:doc/NDK/Guide/graphics/GetOPen"} for consistency with @{"SetOutlinePen" LINK "gg:doc/NDK/Guide/graphics/SetOutlinePen"} */
#define @{"GetOutlinePen" LINK "File" 120}(rp) GetOPen(rp)

#define @{"BNDRYOFF" LINK "File" 123}(w)     {(w)->Flags &= ~@{"AREAOUTLINE" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 103};}

#define @{"CINIT" LINK "File" 128}(c,n)        @{"UCopperListInit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 429}(c,n);
#define @{"CMOVE" LINK "File" 130}(c,a,b)    { @{"CMove" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 281}(c,&a,b);@{"CBump" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 277}(c); }
#define @{"CWAIT" LINK "File" 135}(c,a,b)    { @{"CWait" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 285}(c,a,b);@{"CBump" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 277}(c); }
#define @{"CEND" LINK "File" 140}(c) { @{"CWAIT" LINK File 65}(c,10000,255); }

#define @{"DrawCircle" LINK "File" 145}(rp,cx,cy,r)  @{"DrawEllipse" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 153}(rp,cx,cy,r,r);
#define @{"AreaCircle" LINK "File" 146}(rp,cx,cy,r)  @{"AreaEllipse" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 157}(rp,cx,cy,r,r);

#else /* OLD_GRAPHICS_GFXMACROS_H */

#define @{"ON_DISPLAY" LINK "File" 39}      custom.dmacon = @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}|@{"DMAF_RASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 24}
#define @{"OFF_DISPLAY" LINK "File" 40}     custom.dmacon = @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}|@{"DMAF_RASTER" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 24}
#define @{"ON_SPRITE" LINK "File" 41}       custom.dmacon = @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}|@{"DMAF_SPRITE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 21}
#define @{"OFF_SPRITE" LINK "File" 42}      custom.dmacon = @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}|@{"DMAF_SPRITE" LINK "gg:doc/NDK/Guide/Include/hardware/dmabits.h/File" 21}

#define @{"ON_VBLANK" LINK "File" 44}       custom.intena = @{"BITSET" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 17}|@{"INTF_VERTB" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 44}
#define @{"OFF_VBLANK" LINK "File" 45}      custom.intena = @{"BITCLR" LINK "gg:doc/NDK/Guide/Include/graphics/gfx.h/File" 18}|@{"INTF_VERTB" LINK "gg:doc/NDK/Guide/Include/hardware/intbits.h/File" 44}


#define @{"SetDrPt" LINK "File" 47}(w,p)    do { \\
                                (w)->LinePtrn = (p); \\
                                (w)->Flags |= @{"FRST_DOT" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 96}; \\
                                (w)->linpatcnt = 15; \\
                        } while (0)

#define @{"SetAfPt" LINK "File" 48}(w,p,n)  do { \\
                                (w)->AreaPtrn = p; \\
                                (w)->AreaPtSz = n; \\
                        } while (0)

#define @{"SetOPen" LINK "gg:doc/NDK/Guide/graphics/SetOPen"}(w,c)    do { \\
                                (w)->AOlPen = c; \\
                                (w)->Flags |= @{"AREAOUTLINE" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 103}; \\
                        } while (0)

#define @{"SetWrMsk" LINK "File" 51}(w,m)   do { \\
                                (w)->Mask = m; \\
                        } while (0)

/* the SafeSetxxx macros are backwards (pre V39 graphics) compatible versions */
/* using these macros will make your code do the right thing under V39 AND V37 */

#define @{"SafeSetOutlinePen" LINK "File" 55}(w,c)  do { \\
                                        if (GfxBase->LibNode.lib_Version < 39) \\
                                                @{"SetOPen" LINK File 50}(w,c); \\
                                        else \\
                                                @{"SetOutlinePen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 669}(w,c); \\
                                } while (0)

#define @{"SafeSetWriteMask" LINK "File" 56}(w,m)   do { \\
                                        if (GfxBase->LibNode.lib_Version < 39) \\
                                                @{"SetWrMsk" LINK File 51}(w,m); \\
                                        else \\
                                                @{"SetWriteMask" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 673}(w,m); \\
                                } while (0)

/* synonym for @{"GetOPen" LINK "gg:doc/NDK/Guide/graphics/GetOPen"} for consistency with @{"SetOutlinePen" LINK "gg:doc/NDK/Guide/graphics/SetOutlinePen"} */
#define @{"GetOutlinePen" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 604}(rp) GetOPen(rp)


#define @{"BNDRYOFF" LINK "File" 61}(w)     do { \\
                                (w)->Flags &= ~@{"AREAOUTLINE" LINK "gg:doc/NDK/Guide/Include/graphics/rastport.h/File" 103}; \\
                        } while (0)


#define @{"CINIT" LINK "gg:doc/NDK/Guide/graphics/CINIT"}(c,n)      @{"UCopperListInit" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 429}(c,n)

#define @{"CMOVE" LINK "gg:doc/NDK/Guide/graphics/CMOVE"}(c,a,b)    do { \\
                                @{"CMove" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 281}(c,&a,b); \\
                                @{"CBump" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 277}(c); \\
                        } while (0)

#define @{"CWAIT" LINK "gg:doc/NDK/Guide/graphics/CWAIT"}(c,a,b)    do { \\
                                @{"CWait" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 285}(c,a,b); \\
                                @{"CBump" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 277}(c); \\
                        } while (0)

#define @{"CEND" LINK "gg:doc/NDK/Guide/graphics/CEND"}(c)         do { \\
                                @{"CWAIT" LINK File 65}(c,10000,255); \\
                        } while (0)


#define @{"DrawCircle" LINK "File" 68}(rp,cx,cy,r)  @{"DrawEllipse" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 153}(rp,cx,cy,r,r)
#define @{"AreaCircle" LINK "gg:doc/NDK/Guide/graphics/AreaCircle"}(rp,cx,cy,r)  @{"AreaEllipse" LINK "gg:doc/NDK/Guide/Include/inline/graphics.h/File" 157}(rp,cx,cy,r,r)


#endif /* OLD_GRAPHICS_GFXMACROS_H */

#endif  /* GRAPHICS_GFXMACROS_H */
@ENDNODE
