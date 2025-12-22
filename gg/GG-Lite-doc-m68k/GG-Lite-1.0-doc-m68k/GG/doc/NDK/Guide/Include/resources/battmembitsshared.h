@DATABASE "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h"
@MASTER   "gg:os-include/resources/battmembitsshared.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:18:21
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "resources/battmembitsshared.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"resources/battmembitsshared.h" LINK File}


@{b}#defines@{ub}

@{"BATTMEM_SCSI_FAST_SYNC_ADDR" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 69}   @{"BATTMEM_SCSI_FAST_SYNC_LEN" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 70}
@{"BATTMEM_SCSI_HOST_ID_ADDR" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 42}     @{"BATTMEM_SCSI_HOST_ID_LEN" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 43}
@{"BATTMEM_SCSI_SYNC_XFER_ADDR" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 56}   @{"BATTMEM_SCSI_SYNC_XFER_LEN" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 57}
@{"BATTMEM_SCSI_TAG_QUEUES_ADDR" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 81}  @{"BATTMEM_SCSI_TAG_QUEUES_LEN" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 82}
@{"BATTMEM_SHARED_AMNESIA_ADDR" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 30}   @{"BATTMEM_SHARED_AMNESIA_LEN" LINK "gg:doc/NDK/Guide/Include/resources/battmembitsshared.h/File" 31}

@ENDNODE
@NODE File "resources/battmembitsshared.h"
#ifndef RESOURCES_BATTMEMBITSSHARED_H
#define RESOURCES_BATTMEMBITSSHARED_H 1
/*
**      $VER: battmembitsshared.h 39.2 (4.6.1993)
**      Includes Release 45.1
**
**      BattMem shared specific bit definitions.
**
**      (C) Copyright 1989-2001 Amiga, Inc.
**              All Rights Reserved
*/


/*
 * Shared bits in the battery-backedup ram.
 *
 *      Bits 64 and above
 */

/*
 * SHARED_AMNESIA
 *
 *              The battery-backedup memory has had a memory loss.
 *              This bit is used as a flag that the user should be
 *              notified that all battery-backed bit have been
 *              reset and that some attention is required. Zero
 *              indicates that a memory loss has occured.
 */

#define BATTMEM_SHARED_AMNESIA_ADDR     64
#define BATTMEM_SHARED_AMNESIA_LEN      1


/*
 * SCSI_HOST_ID
 *
 *              a 3 bit field (0-7) that is stored in complemented form
 *              (this is so that default value of 0 really means 7)
 *              It's used to set the A3000 controllers SCSI ID (on reset)
 */

#define BATTMEM_SCSI_HOST_ID_ADDR       65
#define BATTMEM_SCSI_HOST_ID_LEN        3


/*
 * SCSI_SYNC_XFER
 *
 *              determines if the driver should initiate synchronous
 *              transfer requests or leave it to the drive to send the
 *              first request.  This supports drives that crash or
 *              otherwise get confused when presented with a sync xfer
 *              message.  Default=0=sync xfer not initiated.
 */

#define BATTMEM_SCSI_SYNC_XFER_ADDR     68
#define BATTMEM_SCSI_SYNC_XFER_LEN      1

/*
 * SCSI_FAST_SYNC
 *
 *              determines if the driver should initiate fast synchronous
 *              transfer requests (>5MB/s) instead of older <=5MB/s requests.
 *              Note that this has no effect if synchronous transfers are not
 *              negotiated by either side.
 *              Default=0=fast sync xfer used.
 */

#define BATTMEM_SCSI_FAST_SYNC_ADDR     69
#define BATTMEM_SCSI_FAST_SYNC_LEN      1

/*
 * SCSI_TAG_QUEUES
 *
 *              determines if the driver should use SCSI-2 tagged queuing
 *              which allows the drive to accept and reorder multiple read
 *              and write requests.
 *              Default=0=tagged queuing @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} enabled
 */

#define BATTMEM_SCSI_TAG_QUEUES_ADDR    70
#define BATTMEM_SCSI_TAG_QUEUES_LEN     1

#endif /* RESOURCES_BATTMEMBITSSHARED_H */
@ENDNODE
