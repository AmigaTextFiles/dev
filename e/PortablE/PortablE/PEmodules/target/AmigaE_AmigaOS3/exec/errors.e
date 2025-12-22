/* $VER: errors.h 39.0 (15.10.1991) */
OPT NATIVE
{MODULE 'exec/errors'}

NATIVE {IOERR_OPENFAIL}	 CONST IOERR_OPENFAIL	 = (-1) /* device/unit failed to open */
NATIVE {IOERR_ABORTED}	 CONST IOERR_ABORTED	 = (-2) /* request terminated early [after AbortIO()] */
NATIVE {IOERR_NOCMD}	 CONST IOERR_NOCMD	 = (-3) /* command not supported by device */
NATIVE {IOERR_BADLENGTH}	 CONST IOERR_BADLENGTH	 = (-4) /* not a valid length (usually IO_LENGTH) */
NATIVE {IOERR_BADADDRESS} CONST IOERR_BADADDRESS = (-5) /* invalid address (misaligned or bad range) */
NATIVE {IOERR_UNITBUSY}	 CONST IOERR_UNITBUSY	 = (-6) /* device opens ok, but requested unit is busy */
NATIVE {IOERR_SELFTEST}	 CONST IOERR_SELFTEST	 = (-7) /* hardware failed self-test */

NATIVE {ERR_OPENDEVICE}   CONST ERR_OPENDEVICE = IOERR_OPENFAIL
