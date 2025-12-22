
OPT MODULE
OPT EXPORT

MODULE 'rtgmaster/rtgsublibs','rtgmaster/rtgmaster',
       'exec/libraries','exec/types','exec/ports',
       'graphics/gfx','graphics/rastport','graphics/view',
       'intuition/screens'

OBJECT rtgbaseami
    libbase:PTR TO lib
    pad1:INT
    seglist:LONG
    execbase:INT
    utilitybase:INT
    dosbase:INT
    cgxbase:INT
    gfxbase:INT
    intbase:INT
    flags:LONG
    expansionbase:INT
    diskfontbase:INT
ENDOBJECT

OBJECT myport
    port:PTR TO mp
    signal:LONG
    mousex:INT
    mousey:INT
ENDOBJECT

OBJECT rtgscreenami
    header:PTR TO rtgscreen 
    locks:INT
    screenhandle:PTR TO screen 
    planesize:LONG
    dispbuf:LONG
    chipmem1:LONG
    chipmem2:LONG
    chipmem3:LONG
    bitmap1:PTR TO bitmap
    bitmap2:PTR TO bitmap 
    bitmap3:PTR TO bitmap
    flags:LONG
    myrect:PTR TO rectangle
    place[52]:ARRAY
    rastport1:PTR TO rastport
    rastport2:PTR TO rastport
    rastport3:PTR TO rastport
    mywindow:INT
    pointer:INT
    portdata:PTR TO myport  
    dbufinfo:PTR TO dbufinfo 
    dispbuf1:LONG
    dispbuf2:LONG
    dispbuf3:LONG
    safetowrite:LONG
    safetodisp:LONG
    srcmode:LONG
    tempras:INT
    tempbm:INT
    wbcolors:INT
    width:LONG
    height:LONG
    colchanged:LONG
    colarray1:INT
    ccol:INT
ENDOBJECT

