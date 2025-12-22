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
  cap_Semaphore:SignalSemaphore,
  cap_PrefsVersion:UWORD,
  cap_PrefsSize:UWORD,
  cap_BevelType:UBYTE,
  cap_LayoutSpacing:UWORD,
  cap_3DLook:BOOL,
  cap_LabelPen:UWORD,
  cap_LabelPlace:UBYTE,
  cap_3DLabel:UBYTE,
  cap_Reserved1:PTR TO ULONG,
  cap_SimpleRefresh:BOOL,
  cap_Pattern[256]:UBYTE,
  cap_Reserved2:PTR TO ULONG,
  cap_3DProp:BOOL,
  cap_Reserved3:BOOL,
  cap_GlyphType:UBYTE,                 /* currently unsupported/unused!! */
  cap_Reserved4:UBYTE,
  cap_FallbackAttr:PTR TO TextAttr,
  cap_LabelAttr:PTR TO TextAttr

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
