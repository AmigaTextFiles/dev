include "inc/exec/types.inc";
include "inc/libraries/iffparse.inc";
include "inc/intuition/intuition.inc";

struct PalettePrefs is
  pap_Reserved[4]:long;
  pap_4ColorPens[32]:uword;
  pap_8ColorPens[32]:uword;
  pap_Colors[32]:ColorSpec;
;

