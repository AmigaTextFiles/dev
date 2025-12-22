/* $VER: scsidisk.h 44.1 (17.04.1999) */
OPT NATIVE
MODULE 'target/exec/types'
{MODULE 'devices/scsidisk'}

CONST HD_WIDESCSI	= 8	/* Wide SCSI detection bit. */
NATIVE {HD_SCSICMD}	CONST HD_SCSICMD	= 28	/* issue a SCSI command to the unit */

NATIVE {scsicmd} OBJECT scsicmd
    {data}	data	:PTR TO UINT		/* word aligned data for SCSI Data Phase */
				/* (optional) data need not be byte aligned */
				/* (optional) data need not be bus accessable */
    {length}	length	:ULONG	/* even length of Data area */
				/* (optional) data can have odd length */
				/* (optional) data length can be > 2**24 */
    {actual}	actual	:ULONG	/* actual Data used */
    {command}	command	:ARRAY OF UBYTE	/* SCSI Command (same options as scsi_Data) */
    {cmdlength}	cmdlength	:UINT	/* length of Command */
    {cmdactual}	cmdactual	:UINT	/* actual Command used */
    {flags}	flags	:UBYTE		/* includes intended data direction */
    {status}	status	:UBYTE	/* SCSI status of command */
    {sensedata}	sensedata	:ARRAY OF UBYTE	/* sense data: filled if SCSIF_[OLD]AUTOSENSE */
				/* is set and scsi_Status has CHECK CONDITION */
				/* (bit 1) set */
    {senselength}	senselength	:UINT	/* size of scsi_SenseData, also bytes to */
				/* request w/ SCSIF_AUTOSENSE, must be 4..255 */
    {senseactual}	senseactual	:UINT	/* amount actually fetched (0 means no sense) */
ENDOBJECT


/*----- scsi_Flags -----*/
NATIVE {SCSIF_WRITE}		CONST SCSIF_WRITE		= 0	/* intended data direction is out */
NATIVE {SCSIF_READ}		CONST SCSIF_READ		= 1	/* intended data direction is in */
NATIVE {SCSIB_READ_WRITE}	CONST SCSIB_READ_WRITE	= 0	/* (the bit to test) */

NATIVE {SCSIF_NOSENSE}		CONST SCSIF_NOSENSE		= 0	/* no automatic request sense */
NATIVE {SCSIF_AUTOSENSE}		CONST SCSIF_AUTOSENSE		= 2	/* do standard extended request sense */
					/* on check condition */
NATIVE {SCSIF_OLDAUTOSENSE}	CONST SCSIF_OLDAUTOSENSE	= 6	/* do 4 byte non-extended request */
					/* sense on check condition */
NATIVE {SCSIB_AUTOSENSE}		CONST SCSIB_AUTOSENSE		= 1	/* (the bit to test) */
NATIVE {SCSIB_OLDAUTOSENSE}	CONST SCSIB_OLDAUTOSENSE	= 2	/* (the bit to test) */

/*----- SCSI io_Error values -----*/
NATIVE {HFERR_SELFUNIT}		CONST HFERR_SELFUNIT		= 40	/* cannot issue SCSI command to self */
NATIVE {HFERR_DMA}		CONST HFERR_DMA		= 41	/* DMA error */
NATIVE {HFERR_PHASE}		CONST HFERR_PHASE		= 42	/* illegal or unexpected SCSI phase */
NATIVE {HFERR_PARITY}		CONST HFERR_PARITY		= 43	/* SCSI parity error */
NATIVE {HFERR_SELTIMEOUT}	CONST HFERR_SELTIMEOUT	= 44	/* Select timed out */
NATIVE {HFERR_BADSTATUS}		CONST HFERR_BADSTATUS		= 45	/* status and/or sense error */

/*----- OpenDevice io_Error values -----*/
NATIVE {HFERR_NOBOARD}		CONST HFERR_NOBOARD		= 50	/* Open failed for non-existant board */
