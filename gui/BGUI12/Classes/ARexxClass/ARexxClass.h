#ifndef AREXXCLASS_H
#define AREXXCLASS_H
/*
**      $VER: ARexxClass.h 1.0 (22.7.94)
**      C Header for the BOOPSI ARexx interface class.
**
**      (C) Copyright 1994-1995 Jaba Development.
**      (C) Copyright 1994-1995 Jan van den Baard.
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef DOS_RDARGS_H
#include <dos/rdargs.h>
#endif

#ifndef REXX_STORAGE_H
#include <rexx/storage.h>
#endif

#ifndef REXX_RXSLIB_H
#include <rexx/rxslib.h>
#endif

#ifndef REXX_ERRORS_H
#include <rexx/errors.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

/* Tags */
#define AC_TB                           (TAG_USER+0x30000)

#define AC_HostName                     (AC_TB+1)       /* I-G-- */
#define AC_FileExtention                (AC_TB+2)       /* I---- */
#define AC_CommandList                  (AC_TB+3)       /* I---- */
#define AC_ErrorCode                    (AC_TB+4)       /* I---- */
#define AC_RexxPortMask                 (AC_TB+5)       /* --G-- */

/* Methods */
#define AC_MB                           (0x3000)

/* ARexx class event-handler. */
#define ACM_HANDLE_EVENT                (AC_MB+1)

/* Execute a host command. */
#define ACM_EXECUTE                     (AC_MB+2)

struct acmExecute {
        ULONG                   MethodID;
        UBYTE                  *acme_CommandString;
        LONG                   *acme_RC;
        LONG                   *acme_RC2;
        UBYTE                 **acme_Result;
        BPTR                    acme_IO;
};

/*
**      The routines from the command-list will receive a pointer
**      to this structure. In this structure are the parsed arguments
**      and storage to put the results of the command.
**/
typedef struct {
        ULONG                   *ra_ArgList;      /* Result of ReadArgs(). */
        LONG                     ra_RC;           /* Primary result. */
        LONG                     ra_RC2;          /* Secundary result. */
        UBYTE                   *ra_Result;       /* RESULT variable. */
} REXXARGS;

/*
**      An array of these structures must be passed at object-create time.
**/
typedef struct {
        UBYTE                   *rc_Name;         /* Command name. */
        UBYTE                   *rc_ArgTemplate;  /* DOS-style argument template. */
        VOID                   (*rc_Func)( REXXARGS *, struct RexxMsg * );
} REXXCOMMAND;

/*
**      Possible errors.
**/
#define RXERR_NO_COMMAND_LIST           (1L)
#define RXERR_NO_PORT_NAME              (2L)
#define RXERR_PORT_ALREADY_EXISTS       (3L)
#define RXERR_OUT_OF_MEMORY             (4L)

/*
**      Class routine protos.
**/
Class *InitARexxClass( void );
BOOL FreeARexxClass( Class * );

#endif
