/* Includes Release 50.1 */
OPT NATIVE
PUBLIC MODULE 'target/libraries/mpega'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types'
{
#include <proto/mpega.h>
#include <inline/mpega.h>
}
{
struct Library* MPEGABase = NULL;
}
NATIVE {CLIB_MPEGA_PROTOS_H} CONST
NATIVE {PROTO_MPEGA_H} CONST

NATIVE {MPEGABase} DEF mpegabase:PTR TO lib

NATIVE {Obtain} PROC
NATIVE {Release} PROC
NATIVE {Expunge} PROC
NATIVE {Clone} PROC
NATIVE {MPEGA_open} PROC
PROC Mpega_open(filename:ARRAY OF CHAR, ctrl:PTR TO mpega_ctrl) IS NATIVE {MPEGA_open(} filename {,} ctrl {)} ENDNATIVE !!PTR TO mpega_stream
NATIVE {MPEGA_close} PROC
PROC Mpega_close(mpds:PTR TO mpega_stream) IS NATIVE {MPEGA_close(} mpds {)} ENDNATIVE
NATIVE {MPEGA_decode_frame} PROC
PROC Mpega_decode_frame(mpds:PTR TO mpega_stream, pcm:ARRAY OF ARRAY OF INT) IS NATIVE {MPEGA_decode_frame(} mpds {,} pcm {)} ENDNATIVE !!VALUE
NATIVE {MPEGA_seek} PROC
PROC Mpega_seek(mpds:PTR TO mpega_stream, ms_time_position:ULONG) IS NATIVE {MPEGA_seek(} mpds {,} ms_time_position {)} ENDNATIVE !!VALUE
NATIVE {MPEGA_time} PROC
PROC Mpega_time(mpds:PTR TO mpega_stream, ms_time_position:PTR TO ULONG) IS NATIVE {MPEGA_time(} mpds {,} ms_time_position {)} ENDNATIVE !!VALUE
NATIVE {MPEGA_find_sync} PROC
PROC Mpega_find_sync(buffer:ARRAY OF BYTE, buffer_size:VALUE) IS NATIVE {MPEGA_find_sync(} buffer {,} buffer_size {)} ENDNATIVE !!VALUE
NATIVE {MPEGA_scale} PROC
PROC Mpega_scale(mpds:PTR TO mpega_stream, scale_percent:VALUE) IS NATIVE {MPEGA_scale(} mpds {,} scale_percent {)} ENDNATIVE !!VALUE
