MODULE 'libraries/iffparse','intuition/intuition'

CONST ID_PALT=$50414C54

OBJECT PalettePrefs
  Reserved[4]:LONG,
  4ColorPens[32]:UWORD,
  8ColorPens[32]:UWORD,
  Colors[32]:ColorSpec
