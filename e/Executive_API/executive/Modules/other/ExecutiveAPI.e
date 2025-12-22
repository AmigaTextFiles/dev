/*
**      $VER: ExecutiveAPI.h 1.00 (03.09.96)
**      ExecutiveAPI Release 1.00
**
**      ExecutiveAPI definitions
**
**      Copyright © 1996 Petri Nordlund. All rights reserved.
**      Conversion to E-module by Jaco Schoonen (jaco@stack.urc.tue.nl)
**
**      $Id: ExecutiveAPI.h 1.1 1996/10/01 23:08:16 petrin Exp petrin $
**
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'exec/types','exec/ports','exec/tasks'


/*
 * Public message port to send messages to
 *
 */
#define EXECUTIVEAPI_PORTNAME 'Executive_server'


/*
 * ExecutiveMessage
 *
 */
OBJECT executivemessage
    message:mn
    ident:INT                       -> This must always be 0

    command:INT                     -> Command to be sent, see below
    task:PTR TO tc                  -> Task address
    taskname:PTR TO CHAR            -> Task name
    value1                          -> Depends on command
    value2                          -> Depends on command
    value3                          -> Depends on command
    value4                          -> Depends on command
    error:INT                       -> Non-zero IF error, see below

    reserved[4]:ARRAY OF LONG       -> Reserved FOR future use
ENDOBJECT


/*
 * Commands
 *
 */
ENUM    EXAPI_CMD_ADD_CLIENT = 0,       /* Add new client                               */
	EXAPI_CMD_REM_CLIENT,           /* Remove client                                */

	EXAPI_CMD_GET_NICE,             /* Get nice-value                               */
	EXAPI_CMD_SET_NICE,             /* Set nice-value                               */

	EXAPI_CMD_GET_PRIORITY,         /* Get task's correct (not scheduling) priority */

	EXAPI_CMD_WATCH                 /* Schedule, don't schedule etc. See below        */



/*
 * These are used with EXAPI_CMD_WATCH
 *
 */

/* --> value1 */
ENUM    EXAPI_WHICH_TASK = 0,           /* Current task                                 */
	EXAPI_WHICH_CHILDTASKS          /* Childtasks of this task                      */


/* --> value2 */
ENUM    EXAPI_TYPE_SCHEDULE = 0,        /* Schedule     this task / childtasks          */
	EXAPI_TYPE_NOSCHEDULE,          /* Don't schedule this task / childtasks        */
	EXAPI_TYPE_RELATIVE             /* Childtasks' priority relative TO parent's    */
					/* priority.                                    */

/* --> value3 */
/* These are only used with EXAPI_TYPE_NOSCHEDULE */
ENUM    EXAPI_PRI_LEAVE_ALONE = 0,      /* Ignore task priority                         */
	EXAPI_PRI_ABOVE,                /* Task's priority kept above scheduled tasks   */
	EXAPI_PRI_BELOW,                /* Task's priority kept below scheduled tasks   */
	EXAPI_PRI_SET                   /* Set priority to given value (value4)         */


/*
 * Errors
 *
 */
ENUM    EXAPI_OK = 0,                   /* No error                                     */
	EXAPI_ERROR_TASK_NOT_FOUND,     /* Specified task wasn't found                  */
	EXAPI_ERROR_NO_SERVER,          /* Server not available (quitting)              */
	EXAPI_ERROR_INTERNAL,           /* Misc. error (e.g. no memory)                 */
	EXAPI_ERROR_ALREADY_WATCHED     /* Task is already being watched, meaning that  */
					/* user has put the task to "Executive.prefs".  */

