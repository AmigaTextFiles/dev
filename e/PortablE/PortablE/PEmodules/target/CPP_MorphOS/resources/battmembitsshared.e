/* $VER: battmembitsshared.h 39.2 (4.6.1993) */
OPT NATIVE
{#include <resources/battmembitsshared.h>}
NATIVE {RESOURCES_BATTMEMBITSSHARED_H} CONST

/*
 * Shared bits in the battery-backedup ram.
 *
 *	Bits 64 and above
 */

/*
 * SHARED_AMNESIA
 *
 *		The battery-backedup memory has had a memory loss.
 *		This bit is used as a flag that the user should be
 *		notified that all battery-backed bit have been
 *		reset and that some attention is required. Zero
 *		indicates that a memory loss has occured.
 */

NATIVE {BATTMEM_SHARED_AMNESIA_ADDR}	CONST BATTMEM_SHARED_AMNESIA_ADDR	= 64
NATIVE {BATTMEM_SHARED_AMNESIA_LEN}	CONST BATTMEM_SHARED_AMNESIA_LEN	= 1


/*
 * SCSI_HOST_ID
 *
 *		a 3 bit field (0-7) that is stored in complemented form
 *		(this is so that default value of 0 really means 7)
 *		It's used to set the A3000 controllers SCSI ID (on reset)
 */

NATIVE {BATTMEM_SCSI_HOST_ID_ADDR}	CONST BATTMEM_SCSI_HOST_ID_ADDR	= 65
NATIVE {BATTMEM_SCSI_HOST_ID_LEN}	CONST BATTMEM_SCSI_HOST_ID_LEN	= 3


/*
 * SCSI_SYNC_XFER
 *
 *		determines if the driver should initiate synchronous
 *		transfer requests or leave it to the drive to send the
 *		first request.	This supports drives that crash or
 *		otherwise get confused when presented with a sync xfer
 *		message.  Default=0=sync xfer not initiated.
 */

NATIVE {BATTMEM_SCSI_SYNC_XFER_ADDR}	CONST BATTMEM_SCSI_SYNC_XFER_ADDR	= 68
NATIVE {BATTMEM_SCSI_SYNC_XFER_LEN}	CONST BATTMEM_SCSI_SYNC_XFER_LEN	= 1

/*
 * SCSI_FAST_SYNC
 *
 *		determines if the driver should initiate fast synchronous
 *		transfer requests (>5MB/s) instead of older <=5MB/s requests.
 *		Note that this has no effect if synchronous transfers are not
 *		negotiated by either side.
 *		Default=0=fast sync xfer used.
 */

NATIVE {BATTMEM_SCSI_FAST_SYNC_ADDR}	CONST BATTMEM_SCSI_FAST_SYNC_ADDR	= 69
NATIVE {BATTMEM_SCSI_FAST_SYNC_LEN}	CONST BATTMEM_SCSI_FAST_SYNC_LEN	= 1

/*
 * SCSI_TAG_QUEUES
 *
 *		determines if the driver should use SCSI-2 tagged queuing
 *		which allows the drive to accept and reorder multiple read
 *		and write requests.
 *		Default=0=tagged queuing NOT enabled
 */

NATIVE {BATTMEM_SCSI_TAG_QUEUES_ADDR}	CONST BATTMEM_SCSI_TAG_QUEUES_ADDR	= 70
NATIVE {BATTMEM_SCSI_TAG_QUEUES_LEN}	CONST BATTMEM_SCSI_TAG_QUEUES_LEN	= 1
