/* $Id: scsidisk.h,v 1.13 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <devices/scsidisk.h>}
NATIVE {DEVICES_SCSIDISK_H} CONST

/*--------------------------------------------------------------------
 *
 *   SCSI Command
 *    Several Amiga SCSI controller manufacturers are converging on
 *    standard ways to talk to their controllers.  This include
 *    file describes an exec-device command (e.g. for hddisk.device)
 *    that can be used to issue SCSI commands
 *
 *   UNIT NUMBERS
 *    Unit numbers to the OpenDevice call have encoded in them which
 *    SCSI device is being referred to.  The three decimal digits of
 *    the unit number refer to the SCSI Target ID (bus address) in
 *    the 1's digit, the SCSI logical unit (LUN) in the 10's digit,
 *    and the controller board in the 100's digit.
 *
 *    Examples:
 *          0    drive at address 0
 *         12    LUN 1 on multiple drive controller at address 2
 *        104    second controller board, address 4
 *         88    not valid: both logical units and addresses
 *            range from 0..7.
 *
 *   CAVEATS
 *    Original 2090 code did not support this command.
 *
 *    Commodore 2090/2090A unit numbers are different.  The SCSI
 *    logical unit is the 100's digit, and the SCSI Target ID
 *    is a permuted 1's digit: Target ID 0..6 maps to unit 3..9
 *    (7 is reserved for the controller).
 *
 *        Examples:
 *          3    drive at address 0
 *        109    drive at address 6, logical unit 1
 *          1    not valid: this is not a SCSI unit.  Perhaps
 *               it's an ST506 unit.
 *
 *    Some controller boards generate a unique name (e.g. 2090A's
 *    iddisk.device) for the second controller board, instead of
 *    implementing the 100's digit.
 *
 *    With the advent of wide SCSI the scheme above fails miserably.
 *    A new scheme was adopted by Phase V, who appear to be the only
 *    source of wide SCSI for the Amiga at this time. Thus their
 *    numbering system kludge is adopted here. When the ID or LUN is
 *    above 7 the new numbering scheme is used.
 *
 *    Unit =
 *        Board * 10 * 1000 * 1000 +
 *        LUN   * 10 * 1000        +
 *        ID    * 10               +
 *        HD_WIDESCSI;
 *
 *    There are optional restrictions on the alignment, bus
 *    accessability, and size of the data for the data phase.
 *    Be conservative to work with all manufacturer's controllers.
 *
 *------------------------------------------------------------------*/

NATIVE {HD_WIDESCSI}  CONST HD_WIDESCSI  = 8 /* Wide SCSI detection bit. */
NATIVE {HD_SCSICMD}  CONST HD_SCSICMD  = 28 /* issue a SCSI command to the unit */
                       /* io_Data points to a SCSICmd */
                       /* io_Length is sizeof(struct SCSICmd) */
                       /* io_Actual and io_Offset are not used */

NATIVE {SCSICmd} OBJECT scsicmd
    {scsi_Data}	data	:PTR TO UINT        /* word aligned data for SCSI Data Phase */
                             /* (optional) data need not be byte aligned */
                             /* (optional) data need not be bus accessable */
    {scsi_Length}	length	:ULONG      /* even length of Data area */
                             /* (optional) data can have odd length */
                             /* (optional) data length can be > 2**24 */
    {scsi_Actual}	actual	:ULONG      /* actual Data used */
    {scsi_Command}	command	:ARRAY OF UBYTE     /* SCSI Command (same options as scsi_Data) */
    {scsi_CmdLength}	cmdlength	:UINT   /* length of Command */
    {scsi_CmdActual}	cmdactual	:UINT   /* actual Command used */
    {scsi_Flags}	flags	:UBYTE       /* includes intended data direction */
    {scsi_Status}	status	:UBYTE      /* SCSI status of command */
    {scsi_SenseData}	sensedata	:ARRAY OF UBYTE   /* sense data: filled if SCSIF_[OLD]AUTOSENSE */
                             /* is set and scsi_Status has CHECK CONDITION */
                             /* (bit 1) set */
    {scsi_SenseLength}	senselength	:UINT /* size of scsi_SenseData, also bytes to */
                             /* request w/ SCSIF_AUTOSENSE, must be 4..255 */
    {scsi_SenseActual}	senseactual	:UINT /* amount actually fetched (0 means no sense) */
ENDOBJECT


/*----- scsi_Flags -----*/
NATIVE {SCSIF_WRITE}        CONST SCSIF_WRITE        = 0 /* intended data direction is out */
NATIVE {SCSIF_READ}         CONST SCSIF_READ         = 1 /* intended data direction is in */
NATIVE {SCSIB_READ_WRITE}   CONST SCSIB_READ_WRITE   = 0 /* (the bit to test) */

NATIVE {SCSIF_NOSENSE}      CONST SCSIF_NOSENSE      = 0 /* no automatic request sense */
NATIVE {SCSIF_AUTOSENSE}    CONST SCSIF_AUTOSENSE    = 2 /* do standard extended request sense */
                             /* on check condition */
NATIVE {SCSIF_OLDAUTOSENSE} CONST SCSIF_OLDAUTOSENSE = 6 /* do 4 byte non-extended request */
                             /* sense on check condition */
NATIVE {SCSIB_AUTOSENSE}    CONST SCSIB_AUTOSENSE    = 1 /* (the bit to test) */
NATIVE {SCSIB_OLDAUTOSENSE} CONST SCSIB_OLDAUTOSENSE = 2 /* (the bit to test) */

/*----- SCSI io_Error values -----*/
NATIVE {HFERR_SelfUnit}   CONST HFERR_SELFUNIT   = 40 /* cannot issue SCSI command to self */
NATIVE {HFERR_DMA}        CONST HFERR_DMA        = 41 /* DMA error */
NATIVE {HFERR_Phase}      CONST HFERR_PHASE      = 42 /* illegal or unexpected SCSI phase */
NATIVE {HFERR_Parity}     CONST HFERR_PARITY     = 43 /* SCSI parity error */
NATIVE {HFERR_SelTimeout} CONST HFERR_SELTIMEOUT = 44 /* Select timed out */
NATIVE {HFERR_BadStatus}  CONST HFERR_BADSTATUS  = 45 /* status and/or sense error */

/*----- OpenDevice io_Error values -----*/
NATIVE {HFERR_NoBoard}  CONST HFERR_NOBOARD  = 50 /* Open failed for non-existant board */
