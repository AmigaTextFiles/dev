OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'muimaster','utility/tagitem'

#define MUIC_TWFmultiLED 'TWFmultiLED.mcc'
#define TWFmultiLEDObject Mui_NewObjectA(MUIC_TWFmultiLED,[TAG_IGNORE,0

CONST MUIA_TWFmultiLED_Colour    = $febd0001
CONST MUIA_TWFmultiLED_Custom    = $febd0002
CONST MUIA_TWFmultiLED_Type      = $febd0003
CONST MUIA_TWFmultiLED_Free      = $febd0004
CONST MUIA_TWFmultiLED_TimeDelay = $febd0005
 
CONST MUIV_TWFmultiLED_Colour_Off       = 0
CONST MUIV_TWFmultiLED_Colour_On        = 1
CONST MUIV_TWFmultiLED_Colour_Ok        = 2
CONST MUIV_TWFmultiLED_Colour_Load      = 3
CONST MUIV_TWFmultiLED_Colour_Error     = 4
CONST MUIV_TWFmultiLED_Colour_Panic     = 5
CONST MUIV_TWFmultiLED_Colour_Custom    = 6
CONST MUIV_TWFmultiLED_Colour_Working   = 7
CONST MUIV_TWFmultiLED_Colour_Waiting   = 8
CONST MUIV_TWFmultiLED_Colour_Cancelled = 9
CONST MUIV_TWFmultiLED_Colour_Stopped   = 10

CONST MUIV_TWFmultiLED_TimeDelay_User = 1
CONST MUIV_TWFmultiLED_TimeDelay_Off  = 0

CONST MUIV_TWFmultiLED_Type_Round5   = 0
CONST MUIV_TWFmultiLED_Type_Round11  = 1
CONST MUIV_TWFmultiLED_Type_Square5  = 2
CONST MUIV_TWFmultiLED_Type_Square11 = 3
CONST MUIV_TWFmultiLED_Type_Rect11   = 4
CONST MUIV_TWFmultiLED_Type_Rect15   = 5
CONST MUIV_TWFmultiLED_Type_User     = 6

OBJECT twfmultiled_rgb
  red:LONG
  green:LONG
  blue:LONG
ENDOBJECT