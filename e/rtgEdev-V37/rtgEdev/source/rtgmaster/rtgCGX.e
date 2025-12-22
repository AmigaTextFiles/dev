OPT MODULE
OPT EXPORT

MODULE  'rtgmaster/rtgsublibs',
        'exec/libraries','exec/types','exec/ports',
        'graphics/view','graphics/gfx',
        'intuition/intuition'

OBJECT rtgbasecgx
    cgxlibbase:PTR TO lib
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
    linkerdb:INT
ENDOBJECT

OBJECT myport
    port:PTR TO mp
    signal:LONG
    mousex:INT
    mousey:INT
ENDOBJECT

OBJECT rtgscreencgx
    header:PTR TO rtgscreen 
    myscreen:INT
    activemap:LONG
    mapa:INT
    mapb:INT
    mapc:INT
    frontmap:INT
    bytes:LONG
    width:LONG
    height:INT
    numbuf:LONG
    locks:INT
    modeid:LONG
    realmapa:PTR TO bitmap 
    tags[5]:ARRAY
    offa:LONG
    offb:LONG
    offc:LONG
    mywindow:PTR TO window 
    portdata:PTR TO myport 
    bpr:LONG
    dbi:PTR TO dbufinfo 
    safetowrite:LONG
    safetodisp:LONG
    special:LONG
    srcmode:LONG
    tempras:INT
    tempbm:INT
    wbcolors:INT
    colchanged:LONG
    ccol:LONG
    colarray1:INT
    colarray2:INT
ENDOBJECT
