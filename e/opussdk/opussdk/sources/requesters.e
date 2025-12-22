/*****************************************************************************

 Requesters

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

ENUM    REQTYPE_FILE, REQTYPE_SIMPLE

CONST   AR_Requester    = TAG_USER + 1        -> Pointer to requester

CONST   AR_Window       = TAG_USER + 2        -> Window
CONST   AR_Screen       = TAG_USER + 3        -> Screen
CONST   AR_Message      = TAG_USER + 4        -> Text message
CONST   AR_Button       = TAG_USER + 5        -> Button label
CONST   AR_ButtonCode   = TAG_USER + 6        -> Code for this button
CONST   AR_Title        = TAG_USER + 7        -> Title string
CONST   AR_Buffer       = TAG_USER + 8        -> String buffer
CONST   AR_BufLen       = TAG_USER + 9        -> Buffer length
CONST   AR_History      = TAG_USER + 10       -> History list
CONST   AR_CheckMark    = TAG_USER + 11       -> Check mark text
CONST   AR_CheckPtr     = TAG_USER + 12       -> Check mark data storage
CONST   AR_Flags        = TAG_USER + 13       -> Flags

-> Flags for REQTYPE_SIMPLE
CONST SRF_LONGINT       = 1     -> Integer gadget
CONST SRF_CENTJUST      = 2     -> Center justify
CONST SRF_RIGHTJUST     = 4     -> Right justify
CONST SRF_HISTORY       = $100  -> History supplied
CONST SRF_PATH_FILTER   = $200  -> Filter path characters
CONST SRF_CHECKMARK     = $800  -> Checkmark supplied
CONST SRF_SECURE        = $1000 -> Secure field
CONST SRF_MOUSE_POS     = $2000 -> Position over mouse pointer

-> SelectionList
CONST SLF_DIR_FIELD     = 1  -> Directory field
