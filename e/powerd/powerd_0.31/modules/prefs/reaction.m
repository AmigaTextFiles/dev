MODULE 'libraries/iffparse','graphics/text'

CONST ID_RACT=$52414354,
 FONTNAMESIZE=128

OBJECT ReactionPrefs
  BevelType:UWORD,
  GlyphType:UWORD,
  LayoutSpacing:UWORD,
  3DProp:BOOL,
  LabelPen:UWORD,
  LabelPlace:UWORD,
  3DLabel:BOOL,
  SimpleRefresh:BOOL,
  3DLook:BOOL,
  FallbackAttr:TextAttr,
  LabelAttr:TextAttr,
  FallbackName[FONTNAMESIZE]:UBYTE,
  LabelName[FONTNAMESIZE]:UBYTE,
  Pattern[256]:UBYTE
