#ifndef DEVICES_DIL_H
#define DEVICES_DIL_H 1

/*
**
**	$VER: dil.h 1.5 (01.08.2008)
**
**	DIL.device structures and definitions
**
**	©2004-2009 Rupert Hausberger
**	All Rights Reserved
**
*/

#ifndef EXEC_DEVICES_H
   #include <exec/devices.h>
#endif /* EXEC_DEVICES_H */

#ifndef EXEC_IO_H
   #include <exec/io.h>
#endif /* EXEC_IO_H */

#ifndef EXEC_SEMAPHORES_H
   #include <exec/semaphores.h>
#endif /* EXEC_SEMAPHORES_H */

#ifndef DOS_FILEHANDLER_H
   #include <dos/filehandler.h>
#endif /* DOS_FILEHANDLER_H */

#if defined(__GNUC__)
   #pragma pack(2)
#endif

/***************************************************************************/

/* Sane ID, changes each time the public structures are updated,
   thus, all plugins need a rebuild. Should not happen that often... */

#define DIL_SANEID          "DILB"

/***************************************************************************/

/* Exec-device io_Command */
#define DIL_REQUEST         (CMD_NONSTD + 657)

/* r_Command */
#define DILC_Unknown        0 /* Unknown command */
#define DILC_Revoke         1 /* Revoke a unit */
#define DILC_GetParams      2 /* Get DILParams structure */

/* r_Error */
#define DILE_None           0 /* No error occurred */
#define DILE_Init           1 /* Initial error, set before DoIO() */
#define DILE_NoCmd          2 /* Command not known */
#define DILE_Unknown        3 /* Unknown error */

#define DILE_Read           4 /* Read error */
#define DILE_Write          5 /* Write error */

#define DILE_BadAddress     6 /* Bad or not initialized r_Data field */

/* Request */
typedef struct DILRequest
{
   UWORD                    r_Command; /* DIL specific command, see above */
   UBYTE                    r_Flags;   /* Currently unused */
   UBYTE                    r_Error;   /* Returned error value, see below */
   APTR                     r_Data;    /* Command specific data */
} DILRequest;

/* Definitions */
#define DILD_SHA256_SIZE    32 /* SHA256 digest size in bytes (1.5) */

/***************************************************************************/

/* Input standard */
#define IS_AUTO             1 /* Automaticaly select the right standard */
#define IS_EXEC             2 /* Only allow Exec from the source (CMD_READ) */
#define IS_NSTY             3 /* Only allow NewStyle from the source (NSCMD_READ64) */
#define IS_SCSI             4 /* Only allow SCSI from the source (HD_SCSICMD) */
#define IS_TD64             5 /* Only allow Trackdisk64 from the source (TD_READ64) */

/* Output standard */
#define OS_SAME             1 /* Use the same standard for output as found on input */
#define OS_EXEC             2 /* Convert to a Exec call (CMD_READ) */
#define OS_NSTY             3 /* Convert to a NewStyle call (NSCMD_READ64) */
#define OS_SCSI             4 /* Convert to a SCSI call (HD_SCSICMD) */
#define OS_TD64             5 /* Convert to a Trackdisk64 call (TD_READ64) */

/* Passphrase */
#define PP_FILE             1 /* Passphrase input is from a file */
#define PP_KEYBOARD         2 /* Passphrase input is from keyboard */

/* Log bits, log to ? */
#define LLB_ERRORS          0 /* Errors are logged */
#define LLB_WARNINGS        1 /* Warings are logged */
#define LLB_DEFAULT         2 /* Default output is logged */
#define LLB_DEBUG           3 /* Debug output is logged */
/* Log flags, log to ? */
#define LLF_ERRORS          (1ul << LLB_ERRORS)
#define LLF_WARNINGS        (1ul << LLB_WARNINGS)
#define LLF_DEFAULT         (1ul << LLB_DEFAULT)
#define LLF_DEBUG           (1ul << LLB_DEBUG)

/* Log bits, what ? */
#define LTB_RAM             8  /* Logging is enabled to kprintf() */
#define LTB_SER             9  /* Logging is enabled to serial.device */
#define LTB_CON             10 /* Logging is enabled to CON: */
#define LTB_DISK            11 /* Logging is enabled to disk */
#define LTB_MULTIPLEFILE    12 /* Log to multiple files  */
/* Log flags, what ? */
#define LTF_GUI             (1ul << LTB_GUI)
#define LTF_RAM             (1ul << LTB_RAM)
#define LTF_SER             (1ul << LTB_SER)
#define LTF_CON             (1ul << LTB_CON)
#define LTF_DISK            (1ul << LTB_DISK)
#define LTF_MULTIPLEFILE    (1ul << LTB_MULTIPLEFILE)

/* DosEnvec bits */
#define DEB_STARTUP         0 /* Whether p_StartupString or p_StartupValue is used */
#define DEB_ACTIVATE        1 /* Activate unit on mount */
#define DEB_FORCELOAD       2 /* Force to load the filesystem, even if it's already in the fssm */
/* DosEnvec flags */
#define DEF_STARTUP         (1ul << DEB_STARTUP)
#define DEF_ACTIVATE        (1ul << DEB_ACTIVATE)
#define DEF_FORCELOAD       (1ul << DEB_FORCELOAD)

typedef struct DILParams
{
   /* Start of parameterPkt */
   ULONG                    p_DosName;       /* Links to p_DosNameString below */
   ULONG                    p_Device;        /* Links to p_DeviceString below */
   ULONG                    p_Unit;          /* Target device unit number */
   ULONG                    p_Flags;         /* if not deciaml, links to p_FlagsString below */
   struct DosEnvec          p_DosEnvec;
   /* End of parameterPkt */

   /* More parameters */
   UBYTE                   *p_DosNameString; /* DosName for dilMount */
   UBYTE                   *p_DeviceString;  /* Target device name */
   UBYTE                   *p_FlagsString;   /* Target device unit falgs */
   UBYTE                   *p_HandlerString;
   UBYTE                   *p_ControlString;
   UBYTE                   *p_StartupString;
   ULONG                    p_StartupValue;
   ULONG                    p_Stacksize;
   LONG                     p_Priority;
   LONG                     p_GlobVec;
   ULONG                    p_DosEnvecFlags; /* DosEnvec flags */
   /* Standards */
   ULONG                    p_InputStd;
   ULONG                    p_OutputStd;
   /* Plugin */
   UBYTE                   *p_PluginString;
   UBYTE                   *p_PDPString;     /* PluginDataPath */
   ULONG                    p_DILUnit;       /* dil.device unit number */
   /* Passphrase */
   UBYTE                   *p_PassphraseString;
   ULONG                    p_PassphraseMode;
   /* Logging */
   UBYTE                   *p_LogPathString;
   UBYTE                   *p_LogFormatString;
   UBYTE                   *p_DateFormatString;
   ULONG                    p_LogFlags;
   /* Public */
   APTR                     p_User;          /* Free for private use */
} DILParams;

/***************************************************************************/

#define DIL_BLOCKSIZE(p) ((p)->p_DosEnvec.de_SizeBlock << 2)

/***************************************************************************/

#if defined(__GNUC__)
   #pragma pack()
#endif

#endif /* DEVICES_DIL_H */

