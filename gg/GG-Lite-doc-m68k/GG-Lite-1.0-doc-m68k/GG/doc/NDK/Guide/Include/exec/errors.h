@DATABASE "gg:doc/NDK/Guide/Include/exec/errors.h"
@MASTER   "gg:os-include/exec/errors.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:13:10
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "exec/errors.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"exec/errors.h" LINK File}


@{b}#defines@{ub}

@{"IOERR_ABORTED" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 14}   @{"IOERR_BADADDRESS" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 17}  @{"IOERR_BADLENGTH" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 16}  @{"IOERR_NOCMD" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 15}
@{"IOERR_OPENFAIL" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 13}  @{"IOERR_SELFTEST" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 19}    @{"IOERR_UNITBUSY" LINK "gg:doc/NDK/Guide/Include/exec/errors.h/File" 18}   

@ENDNODE
@NODE File "exec/errors.h"
#ifndef EXEC_ERRORS_H
#define EXEC_ERRORS_H
/*
**      $VER: errors.h 39.0 (15.10.1991)
**      Includes Release 45.1
**
**      Standard Device IO Errors (returned in io_Error)
**
**      (C) Copyright 1985-2001 Amiga, Inc.
**          All Rights Reserved
*/

#define IOERR_OPENFAIL   (-1) /* device/unit failed to open */
#define IOERR_ABORTED    (-2) /* request terminated early [after @{"AbortIO()" LINK "gg:doc/NDK/Guide/exec/AbortIO"}] */
#define IOERR_NOCMD      (-3) /* command not supported by device */
#define IOERR_BADLENGTH  (-4) /* not a valid length (usually IO_LENGTH) */
#define IOERR_BADADDRESS (-5) /* invalid address (misaligned or bad range) */
#define IOERR_UNITBUSY   (-6) /* device opens ok, but requested unit is busy */
#define IOERR_SELFTEST   (-7) /* hardware failed self-test */

#endif  /* EXEC_ERRORS_H */
@ENDNODE
