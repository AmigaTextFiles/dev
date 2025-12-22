/* $Id: errors.h,v 1.9 2005/11/10 15:32:20 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <dos/errors.h>}
NATIVE {DOS_ERRORS_H} CONST

/* Errors from IoErr(), etc. */
NATIVE {ERROR_INVALID_PACKET_MESSAGE}     CONST ERROR_INVALID_PACKET_MESSAGE     = 101
NATIVE {ERROR_WRONG_PACKET_RETURNED}      CONST ERROR_WRONG_PACKET_RETURNED      = 102
NATIVE {ERROR_NO_FREE_STORE}              CONST ERROR_NO_FREE_STORE              = 103
NATIVE {ERROR_TASK_TABLE_FULL}            CONST ERROR_TASK_TABLE_FULL            = 105
NATIVE {ERROR_BAD_TEMPLATE}               CONST ERROR_BAD_TEMPLATE               = 114
NATIVE {ERROR_BAD_NUMBER}                 CONST ERROR_BAD_NUMBER                 = 115
NATIVE {ERROR_REQUIRED_ARG_MISSING}       CONST ERROR_REQUIRED_ARG_MISSING       = 116
NATIVE {ERROR_KEY_NEEDS_ARG}              CONST ERROR_KEY_NEEDS_ARG              = 117
NATIVE {ERROR_TOO_MANY_ARGS}              CONST ERROR_TOO_MANY_ARGS              = 118
NATIVE {ERROR_UNMATCHED_QUOTES}           CONST ERROR_UNMATCHED_QUOTES           = 119
NATIVE {ERROR_LINE_TOO_LONG}              CONST ERROR_LINE_TOO_LONG              = 120
NATIVE {ERROR_FILE_NOT_OBJECT}            CONST ERROR_FILE_NOT_OBJECT            = 121
NATIVE {ERROR_INVALID_RESIDENT_LIBRARY}   CONST ERROR_INVALID_RESIDENT_LIBRARY   = 122
NATIVE {ERROR_NO_DEFAULT_DIR}             CONST ERROR_NO_DEFAULT_DIR             = 201
NATIVE {ERROR_OBJECT_IN_USE}              CONST ERROR_OBJECT_IN_USE              = 202
NATIVE {ERROR_OBJECT_EXISTS}              CONST ERROR_OBJECT_EXISTS              = 203
NATIVE {ERROR_DIR_NOT_FOUND}              CONST ERROR_DIR_NOT_FOUND              = 204
NATIVE {ERROR_OBJECT_NOT_FOUND}           CONST ERROR_OBJECT_NOT_FOUND           = 205
NATIVE {ERROR_BAD_STREAM_NAME}            CONST ERROR_BAD_STREAM_NAME            = 206
NATIVE {ERROR_OBJECT_TOO_LARGE}           CONST ERROR_OBJECT_TOO_LARGE           = 207
NATIVE {ERROR_ACTION_NOT_KNOWN}           CONST ERROR_ACTION_NOT_KNOWN           = 209
NATIVE {ERROR_INVALID_COMPONENT_NAME}     CONST ERROR_INVALID_COMPONENT_NAME     = 210
NATIVE {ERROR_INVALID_LOCK}               CONST ERROR_INVALID_LOCK               = 211
NATIVE {ERROR_OBJECT_WRONG_TYPE}          CONST ERROR_OBJECT_WRONG_TYPE          = 212
NATIVE {ERROR_DISK_NOT_VALIDATED}         CONST ERROR_DISK_NOT_VALIDATED         = 213
NATIVE {ERROR_DISK_WRITE_PROTECTED}       CONST ERROR_DISK_WRITE_PROTECTED       = 214
NATIVE {ERROR_RENAME_ACROSS_DEVICES}      CONST ERROR_RENAME_ACROSS_DEVICES      = 215
NATIVE {ERROR_DIRECTORY_NOT_EMPTY}        CONST ERROR_DIRECTORY_NOT_EMPTY        = 216
NATIVE {ERROR_TOO_MANY_LEVELS}            CONST ERROR_TOO_MANY_LEVELS            = 217
NATIVE {ERROR_DEVICE_NOT_MOUNTED}         CONST ERROR_DEVICE_NOT_MOUNTED         = 218
NATIVE {ERROR_SEEK_ERROR}                 CONST ERROR_SEEK_ERROR                 = 219
NATIVE {ERROR_COMMENT_TOO_BIG}            CONST ERROR_COMMENT_TOO_BIG            = 220
NATIVE {ERROR_DISK_FULL}                  CONST ERROR_DISK_FULL                  = 221
NATIVE {ERROR_DELETE_PROTECTED}           CONST ERROR_DELETE_PROTECTED           = 222
NATIVE {ERROR_WRITE_PROTECTED}            CONST ERROR_WRITE_PROTECTED            = 223
NATIVE {ERROR_READ_PROTECTED}             CONST ERROR_READ_PROTECTED             = 224
NATIVE {ERROR_NOT_A_DOS_DISK}             CONST ERROR_NOT_A_DOS_DISK             = 225
NATIVE {ERROR_NO_DISK}                    CONST ERROR_NO_DISK                    = 226
NATIVE {ERROR_NO_MORE_ENTRIES}            CONST ERROR_NO_MORE_ENTRIES            = 232

/****************************************************************************/

/* added for 1.4 */
NATIVE {ERROR_IS_SOFT_LINK}               CONST ERROR_IS_SOFT_LINK               = 233
NATIVE {ERROR_OBJECT_LINKED}              CONST ERROR_OBJECT_LINKED              = 234
NATIVE {ERROR_BAD_HUNK}                   CONST ERROR_BAD_HUNK                   = 235
NATIVE {ERROR_NOT_IMPLEMENTED}            CONST ERROR_NOT_IMPLEMENTED            = 236
NATIVE {ERROR_RECORD_NOT_LOCKED}          CONST ERROR_RECORD_NOT_LOCKED          = 240
NATIVE {ERROR_LOCK_COLLISION}             CONST ERROR_LOCK_COLLISION             = 241
NATIVE {ERROR_LOCK_TIMEOUT}               CONST ERROR_LOCK_TIMEOUT               = 242
NATIVE {ERROR_UNLOCK_ERROR}               CONST ERROR_UNLOCK_ERROR               = 243

/****************************************************************************/

/* ErrorReport() special code, (see dosextens.h) */  
/* #define ABORT_BUSY                    288    "You MUST replace..." */
/* #define ABORT_DISK_ERROR              296    Read/write error */

/****************************************************************************/

NATIVE {ERROR_BUFFER_OVERFLOW}            CONST ERROR_BUFFER_OVERFLOW            = 303    /* User or internal buffer
                                                   overflow */
NATIVE {ERROR_BREAK}                      CONST ERROR_BREAK                      = 304    /* A break character was
                                                   received */
NATIVE {ERROR_NOT_EXECUTABLE}             CONST ERROR_NOT_EXECUTABLE             = 305    /* A file has E bit cleared */

NATIVE {ERROR_IS_PIPE}                    CONST ERROR_IS_PIPE                    = 306    /* Operation is not permitted
                                                   on pipes */
NATIVE {ERROR_BROKEN_PIPE}                CONST ERROR_BROKEN_PIPE                = 307    /* No more data can be read
                                                   from or written to this
                                                   pipe */
NATIVE {ERROR_WOULD_BLOCK}                CONST ERROR_WOULD_BLOCK                = 308    /* Operation cannot complete
                                                   immediately, as requested */

NATIVE {ERROR_BAD_SIGNAL_BIT}             CONST ERROR_BAD_SIGNAL_BIT             = 309    /* An invalid signal bit number
                                                   was specified */

/****************************************************************************/

/* Special error codes that can be set by MountDevice(). */

/* Device to be mounted is neither handler nor file system. */
NATIVE {ERROR_INVALID_DEVICE_TYPE}        CONST ERROR_INVALID_DEVICE_TYPE        = 401

/* Name of device to be mounted does contain more colon characters
   than necessary, or in the wrong place */
NATIVE {ERROR_INVALID_DEVICE_NAME}        CONST ERROR_INVALID_DEVICE_NAME        = 402

/* Name of device to be mounted is longer than 255 characters */
NATIVE {ERROR_DEVICE_NAME_TOO_LONG}       CONST ERROR_DEVICE_NAME_TOO_LONG       = 403

/* Sector size is not a multiple of four */
NATIVE {ERROR_INVALID_SECTOR_SIZE}        CONST ERROR_INVALID_SECTOR_SIZE        = 404

/* Control string for device to be mounted is longer than 255 characters */
NATIVE {ERROR_CONTROL_STRING_TOO_LONG}    CONST ERROR_CONTROL_STRING_TOO_LONG    = 405

/* Exec device driver name for device to be mounted is longer than 255
   characters */
NATIVE {ERROR_EXEC_DEVICE_NAME_TOO_LONG}  CONST ERROR_EXEC_DEVICE_NAME_TOO_LONG  = 406

/* Name of handler to be mounted is longer than 255 characters */
NATIVE {ERROR_HANDLER_STRING_TOO_LONG}    CONST ERROR_HANDLER_STRING_TOO_LONG    = 407

/* Startup string for device to be mounted is longer than 255 characters */
NATIVE {ERROR_STARTUP_STRING_TOO_LONG}    CONST ERROR_STARTUP_STRING_TOO_LONG    = 408

/* Number of surfaces, sector size, number of sectors per block or number
   of sectors per track is zero */
NATIVE {ERROR_SIZE_MISSING}               CONST ERROR_SIZE_MISSING               = 409

/* No exec device driver name was given */
NATIVE {ERROR_DEVICE_NAME_MISSING}        CONST ERROR_DEVICE_NAME_MISSING        = 410

/* Number of cylinders to use is negative */
NATIVE {ERROR_INVALID_NUMBER_OF_CYLINDERS} CONST ERROR_INVALID_NUMBER_OF_CYLINDERS = 411

/* No handler name, segment list or port address was given */
NATIVE {ERROR_HANDLER_CANNOT_BE_STARTED}   CONST ERROR_HANDLER_CANNOT_BE_STARTED   = 412

/* Global vector must be one of -3, -2 or -1 */
NATIVE {ERROR_INVALID_GLOBAL_VECTOR}       CONST ERROR_INVALID_GLOBAL_VECTOR       = 413

/* The task priority is not in the range -128..127 */
NATIVE {ERROR_INVALID_TASK_PRIORITY}       CONST ERROR_INVALID_TASK_PRIORITY       = 414
