OPT NATIVE, FORCENATIVE
PUBLIC MODULE 'target/libraries/id3tag'
MODULE 'target/PEalias/exec', 'target/exec/libraries', 'target/exec/types', 'target/utility/tagitem'
{
#include <proto/id3tag.h>
}
{
struct Library* ID3TagBase = NULL;
struct Id3tagIFace *IId3tag = NULL;
}
NATIVE {CLIB_ID3TAG_PROTOS_H} CONST
NATIVE {PROTO_ID3TAG_H} CONST
NATIVE {INLINE4_ID3TAG_H} CONST
NATIVE {ID3TAG_INTERFACE_DEF_H} CONST

NATIVE {ID3TagBase} DEF id3tagbase:PTR TO lib
NATIVE {IId3tag} DEF

PROC new()
	InitLibrary('id3tag.library', NATIVE {(struct Interface **) &IId3tag} ENDNATIVE !!ARRAY OF PTR TO interface)
ENDPROC


PROC id3tag_Alloc() IS NATIVE {IId3tag->ID3Tag_Alloc()} ENDNATIVE !!PTR TO id3tag
PROC id3tag_Free(id3tag:PTR TO id3tag) IS NATIVE {IId3tag->ID3Tag_Free(} id3tag {)} ENDNATIVE
PROC id3tag_Read(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {IId3tag->ID3Tag_Read(} id3tag {,} file {)} ENDNATIVE !!VALUE
PROC id3tag_Write(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {IId3tag->ID3Tag_Write(} id3tag {,} file {)} ENDNATIVE !!VALUE
PROC id3tag_SetAttrsA(id3tag:PTR TO id3tag, tagList:PTR TO tagitem) IS NATIVE {IId3tag->ID3Tag_SetAttrsA(} id3tag {,} tagList {)} ENDNATIVE !!VALUE
PROC id3tag_SetAttrs(id3tag:PTR TO id3tag, param1=0:ULONG, ...) IS NATIVE {IId3tag->ID3Tag_SetAttrs(} id3tag {,} param1 {,} ... {)} ENDNATIVE !!VALUE
PROC id3tag_GetAttrsA(id3tag:PTR TO id3tag, taglist:PTR TO tagitem) IS NATIVE {IId3tag->ID3Tag_GetAttrsA(} id3tag {,} taglist {)} ENDNATIVE !!VALUE
PROC id3tag_GetAttrs(id3tag:PTR TO id3tag, param1=0:ULONG, ...) IS NATIVE {IId3tag->ID3Tag_GetAttrs(} id3tag {,} param1 {,} ... {)} ENDNATIVE !!VALUE
PROC id3tag_Remove(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {IId3tag->ID3Tag_Remove(} id3tag {,} file {)} ENDNATIVE !!VALUE
PROC id3tag_Clear(id3tag:PTR TO id3tag) IS NATIVE {IId3tag->ID3Tag_Clear(} id3tag {)} ENDNATIVE

PROC id3tag_RemoveType(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR, type:VALUE) IS NATIVE {IId3tag->ID3Tag_RemoveType(} id3tag {,} file {,} type {)} ENDNATIVE !!VALUE

PROC id3tag_ReadVersion(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR, version:VALUE) IS NATIVE {IId3tag->ID3Tag_ReadVersion(} id3tag {,} file {,} version {)} ENDNATIVE !!VALUE
PROC id3tag_WriteVersion(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR, version:VALUE) IS NATIVE {IId3tag->ID3Tag_WriteVersion(} id3tag {,} file {,} version {)} ENDNATIVE !!VALUE
PROC id3tag_ReadTagV2(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR) IS NATIVE {IId3tag->ID3Tag_ReadTagV2(} id3tag {,} file {)} ENDNATIVE !!VALUE
PROC id3tag_WriteTagV2(id3tag:PTR TO id3tag, file:/*STRPTR*/ ARRAY OF CHAR, padding:VALUE) IS NATIVE {IId3tag->ID3Tag_WriteTagV2(} id3tag {,} file {,} padding {)} ENDNATIVE !!VALUE

PROC id3tag_Tag2Buffer(id3tag:PTR TO id3tag, buffer:APTR, buffersize:VALUE, padding:VALUE, version:UINT) IS NATIVE {IId3tag->ID3Tag_Tag2Buffer(} id3tag {,} buffer {,} buffersize {,} padding {,} version {)} ENDNATIVE !!VALUE
PROC id3tag_Buffer2Tag(id3tag:PTR TO id3tag, buffer:APTR, buffersize:VALUE) IS NATIVE {IId3tag->ID3Tag_Buffer2Tag(} id3tag {,} buffer {,} buffersize {)} ENDNATIVE !!VALUE

PROC id3tag_ReLoadPrefs() IS NATIVE {IId3tag->ID3Tag_ReLoadPrefs()} ENDNATIVE

PROC id3tag_LaunchPrefsA(taglist:PTR TO tagitem) IS NATIVE {-IId3tag->ID3Tag_LaunchPrefsA(} taglist {)} ENDNATIVE !!BOOL
PROC id3tag_LaunchPrefs(param1=0:ULONG, ...) IS NATIVE {-IId3tag->ID3Tag_LaunchPrefs(} param1 {,} ... {)} ENDNATIVE !!BOOL
