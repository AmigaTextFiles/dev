OPT NATIVE
PUBLIC MODULE 'target/libraries/mpega'
MODULE 'target/aros/libcall', 'target/libraries/mpega'
MODULE 'target/exec/libraries', 'target/exec/types'
{
#include <proto/mpega.h>
}
{
struct Library* MPEGABase = NULL;
}
NATIVE {CLIB_MPEGA_PROTOS_H} CONST
NATIVE {PROTO_MPEGA_H} CONST
NATIVE {DEFINES_MPEGA_PROTOS_H} CONST

NATIVE {MPEGABase} DEF mpegabase:PTR TO lib

/*->this is an alternative fix, which does not require a modified <libraries/mpega.h> file for AROS, but instead requires modified E code for all targets (which will not be backwards compatible)
TYPE PTR_TO_mpega_access IS NATIVE {MPEGA_ACCESS*} PTR TO mpega_access
TYPE PTR_TO_mpega_output IS NATIVE {MPEGA_ACCESS*} PTR TO mpega_output
TYPE PTR_TO_mpega_layer IS NATIVE {MPEGA_ACCESS*} PTR TO mpega_layer
TYPE PTR_TO_mpega_ctrl IS NATIVE {MPEGA_ACCESS*} PTR TO mpega_ctrl
TYPE PTR_TO_mpega_stream IS NATIVE {MPEGA_ACCESS*} PTR TO mpega_stream
*/

NATIVE {MPEGA_open} PROC
PROC Mpega_open(stream_name:ARRAY OF CHAR, ctrl:PTR TO mpega_ctrl) IS NATIVE {MPEGA_open(} stream_name {,} ctrl {)} ENDNATIVE !!PTR TO mpega_stream
    
NATIVE {MPEGA_close} PROC
PROC Mpega_close(mpega_stream:PTR TO mpega_stream) IS NATIVE {MPEGA_close(} mpega_stream {)} ENDNATIVE
    
NATIVE {MPEGA_decode_frame} PROC
PROC Mpega_decode_frame(mpega_stream:PTR TO mpega_stream, pcm:ARRAY OF ARRAY OF INT) IS NATIVE {MPEGA_decode_frame(} mpega_stream {, (WORD *) } pcm {)} ENDNATIVE !!VALUE
    
NATIVE {MPEGA_seek} PROC
PROC Mpega_seek(mpega_stream:PTR TO mpega_stream, ms_time_position:ULONG) IS NATIVE {MPEGA_seek(} mpega_stream {,} ms_time_position {)} ENDNATIVE !!VALUE
    
NATIVE {MPEGA_time} PROC
PROC Mpega_time(mpega_stream:PTR TO mpega_stream, ms_time_position:PTR TO ULONG) IS NATIVE {MPEGA_time(} mpega_stream {,} ms_time_position {)} ENDNATIVE !!VALUE

NATIVE {MPEGA_find_sync} PROC
PROC Mpega_find_sync(buffer:ARRAY OF UBYTE, buffer_size:VALUE) IS NATIVE {MPEGA_find_sync(} buffer {,} buffer_size {)} ENDNATIVE !!VALUE

NATIVE {MPEGA_scale} PROC
PROC Mpega_scale(mpega_stream:PTR TO mpega_stream, scale_percent:VALUE) IS NATIVE {MPEGA_scale(} mpega_stream {,} scale_percent {)} ENDNATIVE !!VALUE
