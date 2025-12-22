OPT NATIVE, INLINE
MODULE 'target/aros/system', 'target/defines/arossupport', 'target/exec/types', 'target/aros/arossupportbase', 'target/exec/execbase', 'target/dos/dos', 'target/utility/hooks', 'target/exec'
{#include <proto/arossupport.h>}
NATIVE {CLIB_AROSSUPPORT_PROTOS_H} CONST

NATIVE {CalcChecksum} PROC
->PROC CalcChecksum(mem:APTR, size:ULONG) IS NATIVE {CalcChecksum(} mem {,} size {)} ENDNATIVE !!ULONG
NATIVE {kprintf} PROC
PROC kprintf(fmt:PTR TO UBYTE, fmt2=0:ULONG, ...) IS NATIVE {kprintf( (const char*)} fmt {,} fmt2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {vkprintf} PROC
->PROC vkprintf(fmt:PTR TO UBYTE, ap:va_list) IS NATIVE {vkprintf(} fmt {,} ap {)} ENDNATIVE !!VALUE
NATIVE {rkprintf} PROC
PROC rkprintf(param1:/*STRPTR*/ ARRAY OF CHAR, param2:/*STRPTR*/ ARRAY OF CHAR, param3:VALUE, fmt:PTR TO UBYTE, fmt2=0:ULONG, ...) IS NATIVE {rkprintf(} param1 {,} param2 {, (int) } param3 {, (const char*)} fmt {,} fmt2 {,} ... {)} ENDNATIVE !!VALUE
NATIVE {NastyFreeMem} PROC
->PROC NastyFreeMem(mem:APTR, size:ULONG) IS NATIVE {NastyFreeMem(} mem {,} size {)} ENDNATIVE
NATIVE {RemoveSList} PROC
->PROC RemoveSList(list:PTR TO APTR, node:APTR) IS NATIVE {RemoveSList(} list {,} node {)} ENDNATIVE !!APTR
NATIVE {hexdump} PROC
->PROC hexdump(data:PTR, offset:IPTR, count:ULONG) IS NATIVE {hexdump(} data {,} offset {,} count {)} ENDNATIVE
NATIVE {strrncasecmp} PROC
->PROC strrncasecmp(param1:PTR TO CHAR, param2:PTR TO CHAR, param3:VALUE) IS NATIVE {strrncasecmp(} param1 {,} param2 {, (int) } param3 {)} ENDNATIVE !!VALUE
NATIVE {RawPutChars} PROC
->PROC RawPutChars(string:PTR TO UBYTE, len:VALUE) IS NATIVE {RawPutChars(} string {, (int) } len {)} ENDNATIVE
NATIVE {IsDosEntryA} PROC
->PROC IsDosEntryA(Name:PTR TO CHAR, Flags:ULONG) IS NATIVE {-IsDosEntryA(} Name {,} Flags {)} ENDNATIVE !!INT

/* AROS enhancements */
NATIVE {ReadByte} PROC
->PROC ReadByte(param1:PTR TO hook, dataptr:PTR TO UBYTE, stream:PTR) IS NATIVE {-ReadByte(} param1 {,} dataptr {,} stream {)} ENDNATIVE !!INT
NATIVE {ReadWord} PROC
->PROC ReadWord(param1:PTR TO hook, dataptr:PTR TO UINT, stream:PTR) IS NATIVE {-ReadWord(} param1 {,} dataptr {,} stream {)} ENDNATIVE !!INT
NATIVE {ReadLong} PROC
->PROC ReadLong(param1:PTR TO hook, dataptr:PTR TO ULONG, stream:PTR) IS NATIVE {-ReadLong(} param1 {,} dataptr {,} stream {)} ENDNATIVE !!INT
NATIVE {ReadFloat} PROC
->PROC ReadFloat(param1:PTR TO hook, dataptr:PTR TO FLOAT, stream:PTR) IS NATIVE {-ReadFloat(} param1 {,} dataptr {,} stream {)} ENDNATIVE !!INT
NATIVE {ReadDouble} PROC
->PROC ReadDouble(param1:PTR TO hook, dataptr:PTR TO DOUBLE, stream:PTR) IS NATIVE {-ReadDouble(} param1 {,} dataptr {,} stream {)} ENDNATIVE !!INT
NATIVE {ReadString} PROC
->PROC ReadString(param1:PTR TO hook, dataptr:ARRAY OF /*STRPTR*/ ARRAY OF CHAR, stream:PTR) IS NATIVE {-ReadString(} param1 {,} dataptr {,} stream {)} ENDNATIVE !!INT
NATIVE {ReadStruct} PROC
->PROC ReadStruct(param1:PTR TO hook, dataptr:PTR TO APTR, stream:PTR, desc:PTR TO IPTR) IS NATIVE {-ReadStruct(} param1 {,} dataptr {,} stream {,} desc {)} ENDNATIVE !!INT
NATIVE {WriteByte} PROC
->PROC WriteByte(param1:PTR TO hook, data:UBYTE, stream:PTR) IS NATIVE {-WriteByte(} param1 {,} data {,} stream {)} ENDNATIVE !!INT
NATIVE {WriteWord} PROC
->PROC WriteWord(param1:PTR TO hook, data:UINT, stream:PTR) IS NATIVE {-WriteWord(} param1 {,} data {,} stream {)} ENDNATIVE !!INT
NATIVE {WriteLong} PROC
->PROC WriteLong(param1:PTR TO hook, data:ULONG, stream:PTR) IS NATIVE {-WriteLong(} param1 {,} data {,} stream {)} ENDNATIVE !!INT
NATIVE {WriteFloat} PROC
->PROC WriteFloat(param1:PTR TO hook, data:FLOAT, stream:PTR) IS NATIVE {-WriteFloat(} param1 {,} data {,} stream {)} ENDNATIVE !!INT
NATIVE {WriteDouble} PROC
->PROC WriteDouble(param1:PTR TO hook, data:DOUBLE, stream:PTR) IS NATIVE {-WriteDouble(} param1 {,} data {,} stream {)} ENDNATIVE !!INT
NATIVE {WriteString} PROC
->PROC WriteString(param1:PTR TO hook, data:/*STRPTR*/ ARRAY OF CHAR, stream:PTR) IS NATIVE {-WriteString(} param1 {,} data {,} stream {)} ENDNATIVE !!INT
NATIVE {WriteStruct} PROC
->PROC WriteStruct(param1:PTR TO hook, data:APTR, stream:PTR, desc:PTR TO IPTR) IS NATIVE {-WriteStruct(} param1 {,} data {,} stream {,} desc {)} ENDNATIVE !!INT
NATIVE {FreeStruct} PROC
->PROC FreeStruct(s:APTR,  desc:PTR TO IPTR) IS NATIVE {FreeStruct(} s {,} desc {)} ENDNATIVE
