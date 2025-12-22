OPT NATIVE
MODULE 'target/exec/types', 'target/utility/hooks'
{#include <libraries/mpega.h>}
NATIVE {LIBRARIES_MPEGA_H} CONST

/*
   Header recreated. Original one from mpega_library.lha on Aminet may
   likely not be distributed outside that archive. You can replace this
   header with the original one from mpega_library.lha on Aminet, if you
   want. It contains some comments and docs.
*/

NATIVE {MPEGA_VERSION} CONST MPEGA_VERSION = 2

NATIVE {MPEGA_QUALITY_LOW}   	CONST MPEGA_QUALITY_LOW   	= 0
NATIVE {MPEGA_QUALITY_MEDIUM}	CONST MPEGA_QUALITY_MEDIUM	= 1
NATIVE {MPEGA_QUALITY_HIGH}  	CONST MPEGA_QUALITY_HIGH  	= 2

NATIVE {MPEGA_BSFUNC_OPEN}   	CONST MPEGA_BSFUNC_OPEN   	= 0
NATIVE {MPEGA_BSFUNC_CLOSE}  	CONST MPEGA_BSFUNC_CLOSE  	= 1
NATIVE {MPEGA_BSFUNC_READ}   	CONST MPEGA_BSFUNC_READ   	= 2
NATIVE {MPEGA_BSFUNC_SEEK}   	CONST MPEGA_BSFUNC_SEEK   	= 3

NATIVE {MPEGA_ACCESS} OBJECT mpega_access
    {func}	func	:VALUE
	{data.open.stream_name}	stream_name	:PTR TO CHAR
	{data.open.buffer_size}	buffer_size	:VALUE
	{data.open.stream_size}	stream_size	:VALUE
	{data.read.buffer}	buffer	:PTR
	{data.read.num_bytes}	num_bytes	:VALUE
	{data.seek.abs_byte_seek_pos}	abs_byte_seek_pos	:VALUE
ENDOBJECT

NATIVE {MPEGA_OUTPUT} OBJECT mpega_output
    {freq_div}	freq_div	:INT
    {quality}	quality	:INT
    {freq_max}	freq_max	:VALUE
ENDOBJECT

NATIVE {MPEGA_LAYER} OBJECT mpega_layer
    {force_mono}	force_mono	:INT
    {mono}	mono	:mpega_output
    {stereo}	stereo	:mpega_output
ENDOBJECT

NATIVE {MPEGA_CTRL} OBJECT mpega_ctrl
    {bs_access}	bs_access	:PTR TO hook
    {layer_1_2}	layer_1_2	:mpega_layer
    {layer_3}	layer_3	:mpega_layer
    {check_mpeg}	check_mpeg	:INT
    {stream_buffer_size}	stream_buffer_size	:VALUE
ENDOBJECT

NATIVE {MPEGA_MODE_STEREO}   CONST MPEGA_MODE_STEREO   = 0
NATIVE {MPEGA_MODE_J_STEREO} CONST MPEGA_MODE_J_STEREO = 1
NATIVE {MPEGA_MODE_DUAL}     CONST MPEGA_MODE_DUAL     = 2
NATIVE {MPEGA_MODE_MONO}     CONST MPEGA_MODE_MONO     = 3

NATIVE {MPEGA_STREAM} OBJECT mpega_stream
    {norm}	norm	:INT
    {layer}	layer	:INT
    {mode}	mode	:INT
    {bitrate}	bitrate	:INT
    {frequency}	frequency	:VALUE
    {channels}	channels	:INT
    {ms_duration}	ms_duration	:ULONG
    {private_bit}	private_bit	:INT
    {copyright}	copyright	:INT
    {original}	original	:INT
    {dec_channels}	dec_channels	:INT
    {dec_quality}	dec_quality	:INT
    {dec_frequency}	dec_frequency	:VALUE
    {handle}	handle	:PTR
ENDOBJECT

NATIVE {MPEGA_MAX_CHANNELS}  CONST MPEGA_MAX_CHANNELS  = 2
NATIVE {MPEGA_PCM_SIZE}	    CONST MPEGA_PCM_SIZE	    = 1152

NATIVE {MPEGA_ERR_NONE}      CONST MPEGA_ERR_NONE      = 0
NATIVE {MPEGA_ERR_BASE}      CONST MPEGA_ERR_BASE      = 0
NATIVE {MPEGA_ERR_EOF}       CONST MPEGA_ERR_EOF       = (MPEGA_ERR_BASE - 1)
NATIVE {MPEGA_ERR_BADFRAME}  CONST MPEGA_ERR_BADFRAME  = (MPEGA_ERR_BASE - 2)
NATIVE {MPEGA_ERR_MEM}       CONST MPEGA_ERR_MEM       = (MPEGA_ERR_BASE - 3)
NATIVE {MPEGA_ERR_NO_SYNC}   CONST MPEGA_ERR_NO_SYNC   = (MPEGA_ERR_BASE - 4)
NATIVE {MPEGA_ERR_BADVALUE}  CONST MPEGA_ERR_BADVALUE  = (MPEGA_ERR_BASE - 5)
