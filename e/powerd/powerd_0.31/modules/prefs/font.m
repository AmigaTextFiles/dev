MODULE 'libraries/iffparse','graphics/text'

CONST FP_WBFONT=0,
      FP_SYSFONT=1,
      FP_SCREENFONT=2,
      ID_FONT=$464F4E54,
      FONTNAMESIZE=128

OBJECT FontPrefs
  Reserved[3]:LONG,
  Reserved2:UWORD,
  Type:UWORD,
  FrontPen:UBYTE,
  BackPen:UBYTE,
  DrawMode:UBYTE,
  TextAttr:TextAttr,
  Name[FONTNAMESIZE]:BYTE
