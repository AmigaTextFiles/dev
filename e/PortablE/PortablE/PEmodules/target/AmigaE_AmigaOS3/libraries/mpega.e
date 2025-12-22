/* $VER:   MPEGA.h  2.0  (21/06/1998) */
OPT NATIVE
MODULE 'target/exec/types', 'target/utility/hooks'
->{MODULE 'libraries/mpega'}

CONST MPEGA_VERSION = 2 /* #1 */

/* Controls for decoding */

/* Qualities */
CONST MPEGA_QUALITY_LOW    = 0
CONST MPEGA_QUALITY_MEDIUM = 1
CONST MPEGA_QUALITY_HIGH   = 2

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

CONST MPEGA_BSFUNC_OPEN  = 0
CONST MPEGA_BSFUNC_CLOSE = 1
CONST MPEGA_BSFUNC_READ  = 2
CONST MPEGA_BSFUNC_SEEK  = 3

OBJECT mpega_access

	func	:VALUE           /* MPEGA_BSFUNC_xxx */
	stream_name	:ARRAY OF CHAR /* in */
	buffer_size	:VALUE  /* in */
	stream_size	:VALUE  /* out */
	buffer	:PTR      /* in/out */
	num_bytes	:VALUE    /* in */
	abs_byte_seek_pos	:VALUE /* out */

ENDOBJECT

/* Decoding output settings */

OBJECT mpega_output
	freq_div	:INT    /* 1, 2 or 4 */
	quality	:INT     /* 0 (low) .. 2 (high) */
	freq_max	:VALUE    /* for automatic freq_div (if mono_freq_div == 0) */
ENDOBJECT

/* Decoding layer settings */
OBJECT mpega_layer
	force_mono	:INT        /* 1 to decode stereo stream in mono, 0 otherwise */
	mono	:mpega_output      /* mono settings */
	stereo	:mpega_output    /* stereo settings */
ENDOBJECT

/* Full control structure of MPEG Audio decoding */
OBJECT mpega_ctrl
	bs_access	:PTR TO hook    /* NULL for default access (file I/O) or give your own bitstream access */
	layer_1_2	:mpega_layer     /* Layer I & II settings */
	layer_3	:mpega_layer       /* Layer III settings */
	check_mpeg	:INT           /* 1 to check for mpeg audio validity at start of stream, 0 otherwise */
	stream_buffer_size	:VALUE   /* size of bitstream buffer in bytes (0 -> default size) */
                              /* NOTE: stream_buffer_size must be multiple of 4 bytes */
ENDOBJECT

/* MPEG Audio modes */

CONST MPEGA_MODE_STEREO   = 0
CONST MPEGA_MODE_J_STEREO = 1
CONST MPEGA_MODE_DUAL     = 2
CONST MPEGA_MODE_MONO     = 3

OBJECT mpega_stream
   /* Public data (read only) */
   /* Stream info */
	norm	:INT          /* 1 or 2 */
	layer	:INT         /* 1..3 */
	mode	:INT          /* 0..3  (MPEGA_MODE_xxx) */
	bitrate	:INT       /* in kbps */
	frequency	:VALUE     /* in Hz */
	channels	:INT      /* 1 or 2 */
	ms_duration	:ULONG   /* stream duration in ms */
	private_bit	:INT   /* 0 or 1 */
	copyright	:INT     /* 0 or 1 */
	original	:INT      /* 0 or 1 */
   /* Decoding info according to MPEG control */
	dec_channels	:INT  /* decoded channels 1 or 2 */
	dec_quality	:INT   /* decoding quality 0..2 */
	dec_frequency	:VALUE /* decoding frequency in Hz */

   /* Private data */
	handle	:PTR
ENDOBJECT

CONST MPEGA_MAX_CHANNELS = 2    -> Max channels
CONST MPEGA_PCM_SIZE     = 1152 -> Max samples per frame

/* Error codes */

CONST MPEGA_ERR_NONE     = 0
CONST MPEGA_ERR_BASE     = 0
CONST MPEGA_ERR_EOF      = (MPEGA_ERR_BASE-1)
CONST MPEGA_ERR_BADFRAME = (MPEGA_ERR_BASE-2)
CONST MPEGA_ERR_MEM      = (MPEGA_ERR_BASE-3)
CONST MPEGA_ERR_NO_SYNC  = (MPEGA_ERR_BASE-4)
CONST MPEGA_ERR_BADVALUE = (MPEGA_ERR_BASE-5) /* #1 */
