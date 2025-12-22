@DATABASE "gg:doc/NDK/Guide/Include/clib/aml_protos.h"
@MASTER   "gg:os-include/clib/aml_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/aml_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/aml_protos.h" LINK File}

@ENDNODE
@NODE File "clib/aml_protos.h"
#ifndef  CLIB_AML_PROTOS_H
#define  CLIB_AML_PROTOS_H

/*
**      $VER: aml_protos.h 1.2 (6.10.1999)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
#ifndef  UTILITY_HOOKS_H
#include <@{"utility/hooks.h" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File"}>
#endif
#ifndef  REXX_STORAGE_H
#include <@{"rexx/storage.h" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File"}>
#endif
#ifndef  LIBRARIES_AML_H
#include <@{"libraries/aml.h" LINK "gg:doc/NDK/Guide/Include/libraries/aml.h/File"}>
#endif
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RexxDispatcher" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 29}( @{"struct RexxMsg" LINK "gg:doc/NDK/Guide/Include/rexx/storage.h/File" 98} *rxm );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateServerA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 33}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateServer" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 38}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} firstTag, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeServer" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 42}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetServerAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 46}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetServerAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 51}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetServerAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 55}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetServerAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 60}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetServerHeaders" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 64}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetServerArticles" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 68}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, ULONG flags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateFolderA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 72}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateFolder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 77}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DisposeFolder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 81}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenFolderA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 85}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenFolder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 90}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SaveFolder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 94}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemFolder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 98}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetFolderAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 102}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetFolderAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 107}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetFolderAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 111}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetFolderAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 116}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddFolderArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 120}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} data );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemFolderArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 124}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ReadFolderSpool" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 128}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} importfile, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"WriteFolderSpool" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 132}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} exportfile, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ScanFolderIndex" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 136}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, ULONG flags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ExpungeFolder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 140}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} trash, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"CreateFolderIndex" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 144}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SortFolderIndex" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 148}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} field );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateArticleA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 152}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 157}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DisposeArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 161}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 165}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} msgID, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"CopyArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 169}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} folder, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetArticleAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 173}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetArticleAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 178}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetArticleAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 182}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetArticleAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 187}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SendArticle" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 191}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *from_file );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddArticlePartA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 195}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddArticlePart" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 200}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"RemArticlePart" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 204}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"GetArticlePart" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 208}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} partnum );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetArticlePartAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 212}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetArticlePartAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 217}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetArticlePartAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 221}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetArticlePartAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 226}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, ... );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateArticlePartA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 230}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateArticlePart" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 235}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeArticlePart" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 239}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetArticlePartDataA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 243}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetArticlePartData" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 248}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} article, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetArticlePartDataA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 252}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetArticlePartData" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 257}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} part, ... );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateAddressEntryA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 261}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 266}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} firstTag, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"DisposeAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 270}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"OpenAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 274}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} fileid );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SaveAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 278}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 282}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetAddressEntryAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 286}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetAddressEntryAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 291}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetAddressEntryAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 295}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetAddressEntryAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 300}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, ... );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MatchAddressA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 304}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MatchAddress" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 309}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, ... );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"FindAddressEntryA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 313}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"FindAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 318}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, ... );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"HuntAddressEntryA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 322}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"HuntAddressEntry" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 327}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"ScanAddressIndex" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 331}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} server, @{"struct Hook" LINK "gg:doc/NDK/Guide/Include/utility/hooks.h/File" 28} *hook, ULONG type, ULONG flags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddCustomField" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 335}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} field, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} data );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemCustomField" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 339}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} field );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"GetCustomFieldData" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 343}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} addr, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} field );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateDecoderA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 347}( @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"CreateDecoder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 352}( @{"Tag" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 30} firstTag, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"DisposeDecoder" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 356}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetDecoderAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 360}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"GetDecoderAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 365}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec, ... );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetDecoderAttrsA" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 369}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec, @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"SetDecoderAttrs" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 374}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Decode" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 378}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Encode" LINK "gg:doc/NDK/Guide/Include/inline/aml.h/File" 382}( @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} dec, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_AML_PROTOS_H */
@ENDNODE
