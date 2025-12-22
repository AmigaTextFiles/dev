/* $VER:   MPEGA.h  2.0  (21/06/1998) */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/hooks'
{#include <libraries/mpega.h>}
NATIVE {LIBRARIES_MPEGA_H} CONST

NATIVE {MPEGA_VERSION} CONST MPEGA_VERSION = 2 /* #1 */

/* Controls for decoding */

/* Qualities */
NATIVE {MPEGA_QUALITY_LOW}    CONST MPEGA_QUALITY_LOW    = 0
NATIVE {MPEGA_QUALITY_MEDIUM} CONST MPEGA_QUALITY_MEDIUM = 1
NATIVE {MPEGA_QUALITY_HIGH}   CONST MPEGA_QUALITY_HIGH   = 2

/*
   Bitstream Hook function is called like (SAS/C syntax):


   ULONG __saveds __asm HookFunc( register __a0 struct Hook  *hook,
                                  register __a2 APTR          handle,
                                  register __a1 MPEGA_ACCESS *access );

   MPEGA_ACCESS struct specify bitstream access function & parameters

   access->func == MPEGA_BSFUNC_OPEN
      open the bitstream
      access->data.open.buffer_size is the i/o block size your read function can use
      access->data.open.stream_size is the total size of the current stream
                                    (in bytes, set it to 0 if unknown)
      return your file handle (or NULL if failed)
   access->func == MPEGA_BSFUNC_CLOSE
      close the bitstream
      return 0 if ok
   access->func == MPEGA_BSFUNC_READ
      read bytes from bitstream.
      access->data.read.buffer is the destination buffer.
      access->data.read.num_bytes is the number of bytes requested for read.
      return # of bytes read or 0 if EOF.
   access->func == MPEGA_BSFUNC_SEEK
      seek into the bitstream
      access->data.seek.abs_byte_seek_pos is the absolute byte position to reach.
      return 0 if ok
*/

NATIVE {MPEGA_BSFUNC_OPEN}  CONST MPEGA_BSFUNC_OPEN  = 0
NATIVE {MPEGA_BSFUNC_CLOSE} CONST MPEGA_BSFUNC_CLOSE = 1
NATIVE {MPEGA_BSFUNC_READ}  CONST MPEGA_BSFUNC_READ  = 2
NATIVE {MPEGA_BSFUNC_SEEK}  CONST MPEGA_BSFUNC_SEEK  = 3

NATIVE {MPEGA_ACCESS} OBJECT mpega_access

   {func}	func	:VALUE           /* MPEGA_BSFUNC_xxx */
   {data.open.stream_name}	stream_name	:ARRAY OF CHAR /* in */
   {data.open.buffer_size}	buffer_size	:VALUE  /* in */
   {data.open.stream_size}	stream_size	:VALUE  /* out */
   {data.read.buffer}	buffer	:PTR      /* in/out */
   {data.read.num_bytes}	num_bytes	:VALUE    /* in */
   {data.seek.abs_byte_seek_pos}	abs_byte_seek_pos	:VALUE /* out */

ENDOBJECT

/* Decoding output settings */

NATIVE {MPEGA_OUTPUT} OBJECT mpega_output
   {freq_div}	freq_div	:INT    /* 1, 2 or 4 */
   {quality}	quality	:INT     /* 0 (low) .. 2 (high) */
   {freq_max}	freq_max	:VALUE    /* for automatic freq_div (if mono_freq_div == 0) */
ENDOBJECT

/* Decoding layer settings */
NATIVE {MPEGA_LAYER} OBJECT mpega_layer
   {force_mono}	force_mono	:INT        /* 1 to decode stereo stream in mono, 0 otherwise */
   {mono}	mono	:mpega_output      /* mono settings */
   {stereo}	stereo	:mpega_output    /* stereo settings */
ENDOBJECT

/* Full control structure of MPEG Audio decoding */
NATIVE {MPEGA_CTRL Typedef} OBJECT mpega_ctrl
   {bs_access}	bs_access	:PTR TO hook    /* NULL for default access (file I/O) or give your own bitstream access */
   {layer_1_2}	layer_1_2	:mpega_layer     /* Layer I & II settings */
   {layer_3}	layer_3	:mpega_layer       /* Layer III settings */
   {check_mpeg}	check_mpeg	:INT           /* 1 to check for mpeg audio validity at start of stream, 0 otherwise */
   {stream_buffer_size}	stream_buffer_size	:VALUE   /* size of bitstream buffer in bytes (0 -> default size) */
                              /* NOTE: stream_buffer_size must be multiple of 4 bytes */
ENDOBJECT

/* MPEG Audio modes */

NATIVE {MPEGA_MODE_STEREO}   CONST MPEGA_MODE_STEREO   = 0
NATIVE {MPEGA_MODE_J_STEREO} CONST MPEGA_MODE_J_STEREO = 1
NATIVE {MPEGA_MODE_DUAL}     CONST MPEGA_MODE_DUAL     = 2
NATIVE {MPEGA_MODE_MONO}     CONST MPEGA_MODE_MONO     = 3

NATIVE {MPEGA_STREAM Typedef} OBJECT mpega_stream
   /* Public data (read only) */
   /* Stream info */
   {norm}	norm	:INT          /* 1 or 2 */
   {layer}	layer	:INT         /* 1..3 */
   {mode}	mode	:INT          /* 0..3  (MPEGA_MODE_xxx) */
   {bitrate}	bitrate	:INT       /* in kbps */
   {frequency}	frequency	:VALUE     /* in Hz */
   {channels}	channels	:INT      /* 1 or 2 */
   {ms_duration}	ms_duration	:ULONG   /* stream duration in ms */
   {private_bit}	private_bit	:INT   /* 0 or 1 */
   {copyright}	copyright	:INT     /* 0 or 1 */
   {original}	original	:INT      /* 0 or 1 */
   /* Decoding info according to MPEG control */
   {dec_channels}	dec_channels	:INT  /* decoded channels 1 or 2 */
   {dec_quality}	dec_quality	:INT   /* decoding quality 0..2 */
   {dec_frequency}	dec_frequency	:VALUE /* decoding frequency in Hz */

   /* Private data */
   {handle}	handle	:PTR
ENDOBJECT

NATIVE {MPEGA_MAX_CHANNELS} CONST MPEGA_MAX_CHANNELS = 2    -> Max channels
NATIVE {MPEGA_PCM_SIZE}     CONST MPEGA_PCM_SIZE     = 1152 -> Max samples per frame

/* Error codes */

NATIVE {MPEGA_ERR_NONE}     CONST MPEGA_ERR_NONE     = 0
NATIVE {MPEGA_ERR_BASE}     CONST MPEGA_ERR_BASE     = 0
NATIVE {MPEGA_ERR_EOF}      CONST MPEGA_ERR_EOF      = (MPEGA_ERR_BASE-1)
NATIVE {MPEGA_ERR_BADFRAME} CONST MPEGA_ERR_BADFRAME = (MPEGA_ERR_BASE-2)
NATIVE {MPEGA_ERR_MEM}      CONST MPEGA_ERR_MEM      = (MPEGA_ERR_BASE-3)
NATIVE {MPEGA_ERR_NO_SYNC}  CONST MPEGA_ERR_NO_SYNC  = (MPEGA_ERR_BASE-4)
NATIVE {MPEGA_ERR_BADVALUE} CONST MPEGA_ERR_BADVALUE = (MPEGA_ERR_BASE-5) /* #1 */
