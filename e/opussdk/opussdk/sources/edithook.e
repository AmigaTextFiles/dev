/*****************************************************************************

 String edit-hook

 *****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

SET EDITF_NO_SELECT_NEXT,      -> Don't select next field
    EDITF_PATH_FILTER,         -> Filter path characters
    EDITF_SECURE               -> Hidden password field

CONST HOOKTYPE_STANDARD = 0

CONST EH_History        = TAG_USER + 33   -> History list pointer
CONST EH_ChangeSigTask  = TAG_USER + 46   -> Task to signal on change
CONST EH_ChangeSigBit   = TAG_USER + 47   -> Signal bit to use
