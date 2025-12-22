OPT NATIVE
MODULE 'target/exec/types', 'target/exec/ports', 'target/workbench/startup'
{#include <workbench/handler.h>}
NATIVE {WORKBENCH_HANDLER_H} CONST

NATIVE {WBHM_Type} DEF
NATIVE {WBHM_TYPE_SHOW}	CONST WBHM_TYPE_SHOW = $0   /* Open all windows */
NATIVE {WBHM_TYPE_HIDE}	CONST WBHM_TYPE_HIDE = $1   /* Close all windows */
NATIVE {WBHM_TYPE_OPEN}	CONST WBHM_TYPE_OPEN = $2   /* Open a drawer */
NATIVE {WBHM_TYPE_UPDATE}  CONST WBHM_TYPE_UPDATE = $3  /* Update an object */

NATIVE {WBHandlerMessage} OBJECT wbhandlermessage
    {wbhm_Message}	message	:mn
    {wbhm_Type}	type	:NATIVE {enum WBHM_Type} VALUE       /* Type of message (see above) */
    {wbhm_Data.Open.Name}	open_name	:CONST_STRPTR    /* Name of drawer */
    {wbhm_Data.Update.Name}	update_name	:CONST_STRPTR    /* Name of object */
    {wbhm_Data.Update.Type}	update_type	:VALUE    /* Type of object (WBDRAWER, WBPROJECT, ...) */
ENDOBJECT

NATIVE {WBHM_SIZE} CONST ->WBHM_SIZE = (sizeof(struct WBHandlerMessage))
NATIVE {WBHM} CONST	->WBHM(msg) ((struct WBHandlerMessage *) (msg))
