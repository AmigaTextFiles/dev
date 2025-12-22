OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE  'exec/types', 'intuition/classes', 'utility/tagitem', 'graphics/gfx'

#define BGUIMAGNIFYNAME         'gadgets/magnify_bgui.gadget'
CONST   BGUIMAGNIFYVERSION      = 1

CONST   MAGNIFY_MAGFACTOR       = TAG_USER+$70010,
        MAGNIFY_EDIT            = TAG_USER+$70011,
        MAGNIFY_SPECIALFRAME    = TAG_USER+$70012,
        MAGNIFY_GRAPHWIDTH      = TAG_USER+$70013,
        MAGNIFY_GRAPHHEIGHT     = TAG_USER+$70014,
        MAGNIFY_FRAMECOORDSX    = TAG_USER+$70015,
        MAGNIFY_FRAMECOORDSY    = TAG_USER+$70016,
        MAGNIFY_PICAREA         = TAG_USER+$70017,
        MAGNIFY_CURRENTPEN      = TAG_USER+$70018,
        MAGNIFY_GRID            = TAG_USER+$70019,
        MAGNIFY_GRIDPEN         = TAG_USER+$70020,
        MAGNIFY_SELECTREGIONX   = TAG_USER+$70021,
        MAGNIFY_SELECTREGIONY   = TAG_USER+$70022

CONST   MAGM_UNDO               = $70000,
        MAGM_ALLOCBITMAP        = $70001,
        MAGM_FREEBITMAP         = $70002

OBJECT magmbitmap
    methodid:LONG
    mbm:PTR TO bitmap
    sbm:PTR TO bitmap
ENDOBJECT

CONST   MAGERR_OK               = $0,
        MAGERR_ALLOCFAIL        = $5,
        MAGERR_NOBITMAP         = $7,
        MAGERR_FATAL            = $10
