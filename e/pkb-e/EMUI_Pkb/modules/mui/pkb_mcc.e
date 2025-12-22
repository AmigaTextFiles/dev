OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'muimaster','utility/tagitem'

#define MUIC_Pkb 'Pkb.mcc'
#define PkbObject Mui_NewObjectA(MUIC_Pkb,[TAG_IGNORE,0

CONST MUIM_Pkb_Reset         = $fec1001a
CONST MUIM_Pkb_Refresh       = $fec1001b
CONST MUIM_Pkb_Range         = $fec1001c
CONST MUIM_Pkb_Range_Reset   = $fec1001d
CONST MUIM_Pkb_Range_Refresh = $fec1001e
CONST MUIM_Pkb_Jump          = $fec1001f

OBJECT muip_range
  methodid:LONG
  start:LONG
  end:LONG
ENDOBJECT

OBJECT muip_jump
  methodid:LONG
  ncode:LONG
ENDOBJECT

CONST MUIA_Pkb_Mode           = $fec10020
CONST MUIA_Pkb_AutoRelease    = $fec10021
CONST MUIA_Pkb_Current        = $fec10022
CONST MUIA_Pkb_Quiet          = $fec10023
CONST MUIA_Pkb_Pool           = $fec10024
CONST MUIA_Pkb_PoolPuddleSize = $fec10025
CONST MUIA_Pkb_PoolThreshSize = $fec10026
CONST MUIA_Pkb_Octv_Name      = $fec10027
CONST MUIA_Pkb_Octv_Base      = $fec10028
CONST MUIA_Pkb_Octv_Range     = $fec10029
CONST MUIA_Pkb_Octv_Start     = $fec1002a
CONST MUIA_Pkb_Key_Release    = $fec1002b
CONST MUIA_Pkb_Key_Press      = $fec1002c
CONST MUIA_Pkb_Range_Head     = $fec1002d
CONST MUIA_Pkb_Range_Start    = $fec1002e
CONST MUIA_Pkb_Range_End      = $fec1002f
CONST MUIA_Pkb_Low            = $fec10030
CONST MUIA_Pkb_High           = $fec10031

CONST MUIV_Pkb_Mode_NORMAL  = 0
CONST MUIV_Pkb_Mode_RANGE   = 1
CONST MUIV_Pkb_Mode_SPECIAL = 2

CONST MUIV_Pkb_Range_Head_OFF = 0
CONST MUIV_Pkb_Range_Head_TOP = 1
CONST MUIV_Pkb_Range_Head_BOT = 2

