/*
**  $VER: reaction_prefs.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Reaction preferences definitions
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
MODULE 'exec/semaphores','graphics/text'
/*
 * Obtain this semaphore while reading the preferences
 */
#define RAPREFSSEMAPHORE  'REACTION-PREFS'
/* WARNING: This structure has been changing, and will continue to change.
 * In the future, this structure might possible be accesssed at a higher
 * level via a tag list. For now, except for class authors wishing our
 * support in handling prefs, this is data is to be considered off limits.
 */
#define ClassActPrefs  UIPrefs
OBJECT UIPrefs
 Semaphore:SignalSemaphore,
 PrefsVersion:UWORD,
 PrefsSize:UWORD,
 BevelType:UBYTE,
 LayoutSpacing:UWORD,
 3DLook:BOOL,
 LabelPen:UWORD,
 LabelPlace:UBYTE,
 3DLabel:UBYTE,
 Reserved1:PTR TO ULONG,
 SimpleRefresh:BOOL,
 Pattern[256]:UBYTE,
 Reserved2:PTR TO ULONG,
 3DProp:BOOL,
 Reserved3:BOOL,
 GlyphType:UBYTE,                 /* currently unsupported/unused!! */
 Reserved4:UBYTE,
 FallbackAttr:PTR TO TextAttr,
 LabelAttr:PTR TO TextAttr

/* Bevel Types */
#define BVT_GT       0  /* GadTools style 2:1 bevels */
#define BVT_THIN     1  /* CA 1:1 bevels */
#define BVT_THICK    2  /* CA 2:1 4 color thick bevels */
#define BVT_XEN      3  /* 4 color Xen-Style inspired 1/2 shine bevels */
#define BVT_XENTHIN  4  /* 3 color Xen-Style inspired thin 1/2 shine 1:1 bevels */
/* Glyph Types */
#define GLT_GT     0
#define GLT_FLAT   1
#define GLT_3D     2
