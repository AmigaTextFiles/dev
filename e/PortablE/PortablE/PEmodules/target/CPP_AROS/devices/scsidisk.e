/* $Id: scsidisk.h 12757 2001-12-08 22:23:57Z chodorowski $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <devices/scsidisk.h>}
NATIVE {DEVICES_SCSIDISK_H} CONST

NATIVE {HD_WIDESCSI} CONST HD_WIDESCSI = 8
NATIVE {HD_SCSICMD}  CONST HD_SCSICMD  = 28

NATIVE {SCSICmd} OBJECT scsicmd
    {scsi_Data}	data	:PTR TO UINT
    {scsi_Length}	length	:ULONG
    {scsi_Actual}	actual	:ULONG
    {scsi_Command}	command	:ARRAY OF UBYTE
    {scsi_CmdLength}	cmdlength	:UINT
    {scsi_CmdActual}	cmdactual	:UINT
    {scsi_Flags}	flags	:UBYTE
    {scsi_Status}	status	:UBYTE
    {scsi_SenseData}	sensedata	:ARRAY OF UBYTE
    {scsi_SenseLength}	senselength	:UINT
    {scsi_SenseActual}	senseactual	:UINT
ENDOBJECT

/* scsi_Flags */

NATIVE {SCSIF_WRITE} 	    CONST SCSIF_WRITE 	    = 0
NATIVE {SCSIF_READ}  	    CONST SCSIF_READ  	    = 1
NATIVE {SCSIB_READ_WRITE}    CONST SCSIB_READ_WRITE    = 0

NATIVE {SCSIF_NOSENSE}	    CONST SCSIF_NOSENSE	    = 0
NATIVE {SCSIF_AUTOSENSE}     CONST SCSIF_AUTOSENSE     = 2

NATIVE {SCSIF_OLDAUTOSENSE}  CONST SCSIF_OLDAUTOSENSE  = 6

NATIVE {SCSIB_AUTOSENSE}     CONST SCSIB_AUTOSENSE     = 1
NATIVE {SCSIB_OLDAUTOSENSE}  CONST SCSIB_OLDAUTOSENSE  = 2

/* SCSI io_Error values */

NATIVE {HFERR_SelfUnit}	    CONST HFERR_SELFUNIT	    = 40
NATIVE {HFERR_DMA}   	    CONST HFERR_DMA   	    = 41
NATIVE {HFERR_Phase} 	    CONST HFERR_PHASE 	    = 42
NATIVE {HFERR_Parity}	    CONST HFERR_PARITY	    = 43
NATIVE {HFERR_SelTimeout}    CONST HFERR_SELTIMEOUT    = 44
NATIVE {HFERR_BadStatus}     CONST HFERR_BADSTATUS     = 45

/* OpenDevice io_Error values */

NATIVE {HFERR_NoBoard}	    CONST HFERR_NOBOARD	    = 50
