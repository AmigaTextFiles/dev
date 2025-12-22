OPT MODULE
OPT EXPORT

MODULE  'rtgmaster/rtgsublibs',
        'exec/libraries',
        'exec/types','exec/ports'

OBJECT rtgbaseegs
    egslibbase:PTR TO lib
    pad1:INT
    seglist:LONG
    execbase:INT
    utilitybase:INT
    dosbase:INT
    egsbase:INT
    egsblitbase:INT
    gfxbase:INT
    flags:LONG
    egsgfxbase:INT
    expansionbase:INT
ENDOBJECT

OBJECT myport
    port:PTR TO mp
    signal:LONG
    mousex:INT
    mousey:INT
ENDOBJECT

OBJECT rtgscreenegs
    header:PTR TO rtgscreen 
    myscreen:INT
    activemap:LONG
    mapa:INT
    mapb:INT
    mapc:INT
    frontmap:INT
    bytes:LONG
    width:LONG
    type:LONG
    numbuf:LONG
    locks:INT
    rastport1:INT
    rastport2:INT
    rastport3:INT
    pointer[28]:ARRAY
    pointera[256]:ARRAY
    pointerb[1024]:ARRAY
    pointerc[28]:ARRAY
    portdata:PTR TO myport 
ENDOBJECT
