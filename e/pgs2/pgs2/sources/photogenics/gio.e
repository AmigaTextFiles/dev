/* extended for V2 */

OPT MODULE
OPT EXPORT

MODULE 'intuition/intuitionbase','graphics/gfxbase','graphics/gfx','intuition/screens'

CONST GIOF_LOADER8        = 1
CONST GIOF_LOADER24       = 2
CONST GIOF_SAVER8         = 4
CONST GIOF_SAVER24        = 8
CONST GIOF_LOADFILE       = 16
CONST GIOF_SAVEFILE       = 32
CONST GIOF_PLANAR         = 64      -> data is loaded in planar format
CONST GIOF_NOID           = 128     -> not able to identify file
                                    -> (skip in universial loader search)
CONST GIOF_NOFILEOPEN     = 256     -> do file access internally
                                    -> (giodata->Data and
                                    -> giodata->Filehandle are not set up)

-> 512 - obsolete

CONST GIOF_LOADNOPROGRESS = 1024
CONST GIOF_SAVENOPROGRESS = 2048
CONST GIOF_EXTENDED       = 4096        -> extended features available
CONST GIOF_SAVEPREFS      = 8192        -> has prefs for loading
CONST GIOF_LOADPREFS      = 16384       -> has prefs for saving

-> 32768 - obsolete

CONST GIOF_AREXX          = 65536   -> gio supports Arexx command parsing
CONST GIOF_LOADTRANS      = 131072  -> loads transparency (paintlayer)
CONST GIOF_SAVETRANS      = 262144  -> saves transparency (paintlayer)

OBJECT giodata
    next:PTR TO giodata
    prev:PTR TO giodata
    filename:PTR TO CHAR
    data[64]:ARRAY OF CHAR
    filehandle:LONG
    width:LONG
    height:LONG
    depth:LONG
    prv1:LONG
    prv2:LONG
    prv3:LONG
    prv4:LONG
    vp_mode:LONG
    aspect_x:INT
    aspect_y:INT
    bitmap:PTR TO bitmap
    prv5:LONG
    prv6:LONG
    palette:PTR TO CHAR
    flags:PTR TO LONG
    headerlength:LONG
    error:LONG
    userData:LONG
    userData2:LONG
    userData3:LONG
    pgsbase:PTR TO LONG
    skipBytes:LONG
    dosbase:PTR TO LONG
    gfxbase:PTR TO gfxbase
    intuitionbase:PTR TO intuitionbase
    utilitybase:PTR TO LONG
    gadtoolsbase:PTR TO LONG
    aslbase:PTR TO LONG
    colorwheelbase:PTR TO LONG
    extendedID:LONG
    pgsScreen:PTR TO screen
    prv7:LONG
    prv8:LONG
    prv9:LONG
    windX:INT
    windY:INT
    windWidth:INT
    windHeight:INT
    destWidth:INT
    destHeight:INT
    secondWidth:INT
    secondHeight:INT
    alphaWidth:INT
    alphaHeight:INT
    destDepth:INT
    secondDepth:INT
    alphaDepth:INT
    destPalette:PTR TO CHAR
    secondPalette:PTR TO CHAR
    alphaPalette:PTR TO CHAR
    pgsRexxBase:PTR TO LONG
    rexxString:PTR TO CHAR
    language:LONG
    prv10:LONG
    extensions:PTR TO LONG            -> for specific extensions to gios.
    rexxError:LONG
    red:CHAR
    green:CHAR
    blue:CHAR
    pad0:CHAR
    prv11:LONG
    prv12:LONG
    prv13:LONG
    prv14:LONG
    channels:LONG                            -> channels for buffer (efx use)
    previewData:PTR TO CHAR
    previewWidth:INT
    previewHeight:INT
    cyberbase:PTR TO LONG         -> erk!
    rendermode:LONG
    autosave:LONG
    prv15:LONG
    prv16:LONG
    prv17:LONG
    prv18:LONG
ENDOBJECT

-> for giodata.language field.. Check this field to see what language you
-> should use in your requesters.

CONST LANG_ENGLISH    = 0
CONST LANG_GERMAN     = 1
CONST LANG_FRENCH     = 2
CONST LANG_ITALIAN    = 3
CONST LANG_SPANISH    = 4
CONST LANG_DUTCH      = 5
CONST LANG_POLISH     = 6
CONST LANG_PORTUGESE  = 7
CONST LANG_AMERICAN   = 8
CONST LANG_NORWEGIAN  = 9
CONST LANG_SWEDISH    = 10
CONST LANG_DANISH     = 11
CONST LANG_FINNISH    = 12
CONST LANG_SCOTCH     = 13
CONST LANG_MANDARIN   = 14
CONST LANG_THP        = 15
CONST LANG_LATIN      = 16
CONST LANG_ESPERANTO  = 17
CONST LANG_ARABIC     = 18

-> error msgs for gios & efx.

CONST GIO_OK          = 0
CONST GIO_RAMERR      = 1
CONST GIO_FILEERR     = 2
CONST GIO_WRONGTYPE   = 3
CONST GIO_SYSERR      = 4
CONST GIO_ABORTED     = 5
CONST GIO_UNAVAILABLE = 6
CONST GIO_AREXXERROR  = 7

-> flags to OR with y value in GetSrcLine, etc...

CONST PGVM_READONLY  = $01000000
CONST PGVM_WRITEONLY = $02000000
CONST PGVM_NOCACHE   = $04000000

-> Doubt you'll need these. Not even sure if we still do!

CONST PGTAG_LISTMIN      = $81910050
CONST PGTAG_LISTMAX      = $81910060
CONST PGTAG_ENTRY        = $81900a0
CONST PGTAG_ENTRYID      = $81900b0
CONST PGTAG_ENTRYTEXT    = $81900c0
CONST PGTAG_ENTRYEND     = $81900e0
CONST PGTAG_END          = $8191ffff
