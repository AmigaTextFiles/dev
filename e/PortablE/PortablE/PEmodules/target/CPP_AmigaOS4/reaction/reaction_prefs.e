/* $VER: reaction_prefs.h 53.21 (29.9.2013) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/semaphores'
MODULE 'target/exec/types', 'target/graphics/text'
{#include <reaction/reaction_prefs.h>}
NATIVE {REACTION_REACTION_PREFS_H} CONST

/*
 * Obtain this semaphore while reading the preferences
 */
NATIVE {RAPREFSSEMAPHORE} CONST
#define RAPREFSSEMAPHORE raprefssemaphore
STATIC raprefssemaphore = 'REACTION-PREFS'

/* WARNING: This structure has been changing, and will continue to change.
 * In the future, this structure might possible be accesssed at a higher
 * level via a tag list. For now, except for class authors wishing our
 * support in handling prefs, this is data is to be considered off limits.
 */

NATIVE {ClassActPrefs} CONST

NATIVE {UIPrefs} OBJECT uiprefs
    /* Set PrefsVersion to 1 */
    {cap_Semaphore}	semaphore	:ss
    {cap_PrefsVersion}	prefsversion	:UINT
    {cap_PrefsSize}	prefssize	:UINT
    {cap_BevelType}	beveltype	:UBYTE
    {cap_LayoutSpacing}	layoutspacing	:UINT
    {cap_3DLook}	threedlook	:INT
    {cap_LabelPen}	labelpen	:UINT
    {cap_LabelPlace}	labelplace	:UBYTE
    {cap_3DLabel}	threedlabel	:UBYTE
    {cap_Reserved1}	reserved1	:PTR TO ULONG
    {cap_SimpleRefresh}	simplerefresh	:INT
    {cap_Pattern}	pattern[256]	:ARRAY OF /*TEXT*/ CHAR
    {cap_Reserved2}	reserved2	:PTR TO ULONG

    {cap_3DProp}	threedprop	:INT
    {cap_Reserved3}	reserved3	:INT

    {cap_GlyphType}	glyphtype	:UBYTE /* currently unsupported/unused!! */
    {cap_Reserved4}	reserved4	:UBYTE

    {cap_FallbackAttr}	fallbackattr	:PTR TO textattr
    {cap_LabelAttr}	labelattr	:PTR TO textattr
ENDOBJECT


/* Bevel Types */
NATIVE {BVT_GT}      CONST BVT_GT      = 0 /* GadTools style 2:1 bevels */
NATIVE {BVT_THIN}    CONST BVT_THIN    = 1 /* CA 1:1 bevels */
NATIVE {BVT_THICK}   CONST BVT_THICK   = 2 /* CA 2:1 4 color thick bevels */
NATIVE {BVT_XEN}     CONST BVT_XEN     = 3 /* 4 color Xen-Style inspired 1/2 shine bevels */
NATIVE {BVT_XENTHIN} CONST BVT_XENTHIN = 4 /* 3 color Xen-Style inspired thin 1/2 shine 1:1 bevels */

/* Glyph Types */
NATIVE {GLT_GT}   CONST GLT_GT   = 0
NATIVE {GLT_FLAT} CONST GLT_FLAT = 1
NATIVE {GLT_3D}   CONST GLT_3D   = 2
