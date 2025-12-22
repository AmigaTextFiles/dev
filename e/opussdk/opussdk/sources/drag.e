/*****************************************************************************

 Drag routines

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'graphics/view', 'graphics/gels', 'graphics/gfx', 'graphics/rastport', 'intuition/intuition'

OBJECT dragInfo
    rastport:PTR TO rastport    -> Stores RastPort this bob belongs to
    viewport:PTR TO viewport    -> Stores ViewPort

    width:INT                   -> Bob width
    height:INT                  -> Bob height

    sprite:vs                   -> VSprite structure
    bob:bob                     -> BOB structure

    flags:LONG                  -> Flags

    drag_rp:rastport            -> RastPort we can draw into
    drag_bm:bitmap              -> BitMap we can draw into

    window:PTR TO window        -> Window pointer
ENDOBJECT

OBJECT dragInfoExtra
    head:vs            -> GEL list head sprite
    tail:vs            -> GEL list tail sprite
    info:gelsinfo      -> GEL info
ENDOBJECT

SET DRAGF_VALID,        -> Bob is valid
    DRAGF_OPAQUE,       -> Bob should be opaque
    DRAGF_DONE_GELS,    -> Installed GelsInfo
    DRAGF_NO_LOCK,      -> Don't lock layers
    DRAGF_TRANSPARENT   -> Bob should be transparent (use with opaque)
