/* ramdev.h 50.1 (04.09.2003) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/io'
{#include <devices/ramdev.h>}
NATIVE {DEVICES_RAMDEV_H} CONST

NATIVE {RAMDEVNAME} CONST
#define RAMDEVNAME ramdevname
STATIC ramdevname = 'ramdev.device'

NATIVE {RamDevGeometry} OBJECT ramdevgeometry
	{BytesPerBlock}	bytesperblock	:ULONG		/* Number of bytes per Block, usually 512 */
    {BlocksPerTrack}	blockspertrack	:ULONG		/* Number of Blocks per virtual Track, usually 11 */
    {NumberOfTracks}	numberoftracks	:ULONG		/* Number of virtual tracks */
    {DataSize}	datasize	:ULONG			/* Size of the data */
    {DataPtr}	dataptr	:APTR			/* Pointer to the disk data */
ENDOBJECT

NATIVE {enRamDevError} DEF
NATIVE {RAMDEVERR_NO_ERROR} 			CONST RAMDEVERR_NO_ERROR 			= $00		/* Operation was successfull */
NATIVE {RAMDEVERR_UNIT_NOT_MOUNTED} 	CONST RAMDEVERR_UNIT_NOT_MOUNTED 	= $01		/* Unit requested was not mounted  (but needs to be) */
NATIVE {RAMDEVERR_UNIT_MOUNTED}		CONST RAMDEVERR_UNIT_MOUNTED		= $02		/* Unit was mounted (but should not be) */
NATIVE {RAMDEVERR_OUT_OF_MEMORY}		CONST RAMDEVERR_OUT_OF_MEMORY		= $03		/* Requested operation ran out of memory */
NATIVE {RAMDEVERR_INVALID_UNIT}		CONST RAMDEVERR_INVALID_UNIT		= $04		/* Invalid Unit */
NATIVE {RAMDEVERR_MOUNT_ERROR}		CONST RAMDEVERR_MOUNT_ERROR		= $05		/* Error encountered while mounting the device */
NATIVE {RAMDEVERR_EXPANSION_FAILED}	CONST RAMDEVERR_EXPANSION_FAILED	= $06		/* Failed to open expansion library */


NATIVE {enRamDevOpenFlags} DEF
NATIVE {RDOFLAG_NO_MOUNT}			CONST RDOFLAG_NO_MOUNT			= $01		/* Don't mount unit */
