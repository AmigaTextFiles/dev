/* Includes Release 50.1 */
OPT NATIVE
PUBLIC MODULE 'target/libraries/mpega'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types'
{MODULE 'mpega'}
NATIVE {mpegabase} DEF mpegabase:NATIVE {LONG} PTR TO lib

NATIVE {Mpega_open} PROC
PROC Mpega_open(filename:ARRAY OF CHAR, ctrl:PTR TO mpega_ctrl) IS NATIVE {Mpega_open(} filename {,} ctrl {)} ENDNATIVE !!PTR TO mpega_stream
NATIVE {Mpega_close} PROC
PROC Mpega_close(mpds:PTR TO mpega_stream) IS NATIVE {Mpega_close(} mpds {)} ENDNATIVE
NATIVE {Mpega_decode_frame} PROC
PROC Mpega_decode_frame(mpds:PTR TO mpega_stream, pcm:ARRAY OF ARRAY OF INT) IS NATIVE {Mpega_decode_frame(} mpds {, } pcm {)} ENDNATIVE !!VALUE
NATIVE {Mpega_seek} PROC
PROC Mpega_seek(mpds:PTR TO mpega_stream, ms_time_position:ULONG) IS NATIVE {Mpega_seek(} mpds {,} ms_time_position {)} ENDNATIVE !!VALUE
NATIVE {Mpega_time} PROC
PROC Mpega_time(mpds:PTR TO mpega_stream, ms_time_position:PTR TO ULONG) IS NATIVE {Mpega_time(} mpds {,} ms_time_position {)} ENDNATIVE !!VALUE
NATIVE {Mpega_find_sync} PROC
PROC Mpega_find_sync(buffer:ARRAY OF BYTE, buffer_size:VALUE) IS NATIVE {Mpega_find_sync(} buffer {,} buffer_size {)} ENDNATIVE !!VALUE
NATIVE {Mpega_scale} PROC
PROC Mpega_scale(mpds:PTR TO mpega_stream, scale_percent:VALUE) IS NATIVE {Mpega_scale(} mpds {,} scale_percent {)} ENDNATIVE !!VALUE
