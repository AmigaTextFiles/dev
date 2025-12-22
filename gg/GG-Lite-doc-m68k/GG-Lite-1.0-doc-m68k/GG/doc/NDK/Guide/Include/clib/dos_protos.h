@DATABASE "gg:doc/NDK/Guide/Include/clib/dos_protos.h"
@MASTER   "gg:os-include/clib/dos_protos.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:11:37
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "clib/dos_protos.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"clib/dos_protos.h" LINK File}

@ENDNODE
@NODE File "clib/dos_protos.h"
#ifndef  CLIB_DOS_PROTOS_H
#define  CLIB_DOS_PROTOS_H

/*
**      $VER: dos_protos.h 40.2 (6.6.1998)
**
**      C prototypes. For use with 32 bit integers only.
**
**      Copyright © 2001 Amiga, Inc.
**          All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#ifndef  DOS_DOS_H
#include <@{"dos/dos.h" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File"}>
#endif
#ifndef  DOS_DOSEXTENS_H
#include <@{"dos/dosextens.h" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File"}>
#endif
#ifndef  DOS_RECORD_H
#include <@{"dos/record.h" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File"}>
#endif
#ifndef  DOS_RDARGS_H
#include <@{"dos/rdargs.h" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File"}>
#endif
#ifndef  DOS_DOSASL_H
#include <@{"dos/dosasl.h" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File"}>
#endif
#ifndef  DOS_VAR_H
#include <@{"dos/var.h" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File"}>
#endif
#ifndef  DOS_NOTIFY_H
#include <@{"dos/notify.h" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File"}>
#endif
#ifndef  DOS_DATETIME_H
#include <@{"dos/datetime.h" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File"}>
#endif
#ifndef  DOS_EXALL_H
#include <@{"dos/exall.h" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File"}>
#endif
#ifndef  UTILITY_TAGITEM_H
#include <@{"utility/tagitem.h" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File"}>
#endif
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"Open" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 47}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} accessMode );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Close" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 51}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Read" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 55}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} length );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Write" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 59}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} length );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"Input" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 63}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"Output" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 67}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Seek" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 71}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} position, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} offset );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DeleteFile" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 75}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Rename" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 79}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} oldName, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} newName );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"Lock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 83}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} type );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnLock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 87}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"DupLock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 91}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Examine" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 95}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"struct FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61} *fileInfoBlock );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ExNext" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 99}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"struct FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61} *fileInfoBlock );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Info" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 103}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"struct InfoData" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 147} *parameterBlock );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"CreateDir" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 107}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"CurrentDir" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 111}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"IoErr" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 115}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *CreateProc( CONST_STRPTR name, LONG pri, BPTR segList, LONG stackSize );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Exit" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 123}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} returnCode );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"LoadSeg" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 127}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnLoadSeg" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 131}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} seglist );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *DeviceProc( CONST_STRPTR name );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetComment" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 139}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} comment );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetProtection" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 143}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} protect );
@{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52} *DateStamp( struct DateStamp *date );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"Delay" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 151}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} timeout );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WaitForChar" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 155}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} timeout );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"ParentDir" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 159}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"IsInteractive" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 163}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Execute" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 167}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} file2 );
/*--- functions in V36 or higher (Release 2.0) ---*/
/*      DOS Object creation/deletion */
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocDosObject" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 171}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocDosObjectTagList" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 175}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} @{"AllocDosObjectTags" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 178}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tag1type, ... );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeDosObject" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 182}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} type, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} ptr );
/*      Packet Level routines */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DoPkt" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 186}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG action, LONG arg1, LONG arg2, LONG arg3, LONG arg4, LONG arg5 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DoPkt0" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 190}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG action );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DoPkt1" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 194}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG action, LONG arg1 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DoPkt2" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 198}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG action, LONG arg1, LONG arg2 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DoPkt3" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 202}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG action, LONG arg1, LONG arg2, LONG arg3 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DoPkt4" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 206}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, LONG action, LONG arg1, LONG arg2, LONG arg3, LONG arg4 );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"SendPkt" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 210}( @{"struct DosPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 108} *dp, struct MsgPort *port, struct MsgPort *replyport );
@{"struct DosPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 108} *WaitPkt( VOID );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ReplyPkt" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 218}( @{"struct DosPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 108} *dp, LONG res1, LONG res2 );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"AbortPkt" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 222}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, struct DosPacket *pkt );
/*      Record Locking */
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LockRecord" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 226}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} offset, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} mode, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} timeout );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"LockRecords" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 230}( @{"struct RecordLock" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 27} *recArray, ULONG timeout );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"UnLockRecord" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 234}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} offset, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} length );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"UnLockRecords" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 238}( @{"struct RecordLock" LINK "gg:doc/NDK/Guide/Include/dos/record.h/File" 27} *recArray );
/*      Buffered File I/O */
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"SelectInput" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 242}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"SelectOutput" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 246}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FGetC" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 250}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FPutC" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 254}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} ch );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"UnGetC" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 258}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} character );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FRead" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 262}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} block, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} blocklen, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} number );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FWrite" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 266}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} block, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} blocklen, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} number );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"FGets" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 270}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} buflen );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FPuts" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 274}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} str );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"VFWritef" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 278}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} format, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *argarray );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FWritef" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 283}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} format, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"VFPrintf" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 287}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} format, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} argarray );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FPrintf" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 292}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} format, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Flush" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 296}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetVBuf" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 300}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buff, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} type, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} size );
/*      DOS Object Management */
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"DupLockFromFH" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 304}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"OpenFromLock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 308}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"ParentOfFH" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 312}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"ExamineFH" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 316}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"struct FileInfoBlock" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 61} *fib );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetFileDate" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 320}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52} *date );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"NameFromLock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 324}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"NameFromFH" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 328}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len );
@{"WORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 54} @{"SplitName" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 332}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} separator, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} oldpos, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} size );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SameLock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 336}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock1, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock2 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetMode" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 340}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} mode );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ExAll" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 344}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"struct ExAllData" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 45} *buffer, LONG size, LONG data, struct ExAllControl *control );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadLink" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 348}( @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *port, BPTR lock, CONST_STRPTR path, STRPTR buffer, ULONG size );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MakeLink" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 352}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} dest, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} soft );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ChangeMode" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 356}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} type, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} newmode );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetFileSize" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 360}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} pos, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} mode );
/*      Error Handling */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SetIoErr" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 364}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} result );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"Fault" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 368}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} code, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} header, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"PrintFault" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 372}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} code, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} header );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ErrorReport" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 376}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} code, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} type, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} arg1, @{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *device );
/*      Process Management */
@{"struct CommandLineInterface" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 314} *Cli( VOID );
@{"struct Process" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 37} *CreateNewProc( CONST struct TagItem *tags );
@{"struct Process" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 37} *CreateNewProcTagList( CONST struct TagItem *tags );
@{"struct Process" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 37} *CreateNewProcTags( ULONG tag1type, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RunCommand" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 395}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} seg, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} stack, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} paramptr, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} paramlen );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *GetConsoleTask( VOID );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *SetConsoleTask( CONST struct MsgPort *task );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *GetFileSysTask( VOID );
@{"struct MsgPort" LINK "gg:doc/NDK/Guide/Include/exec/ports.h/File" 28} *SetFileSysTask( CONST struct MsgPort *task );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"GetArgStr" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 415}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetArgStr" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 419}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string );
@{"struct Process" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 37} *FindCliProc( ULONG num );
@{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} @{"MaxCli" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 427}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetCurrentDirName" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 431}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetCurrentDirName" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 435}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetProgramName" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 439}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetProgramName" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 443}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetPrompt" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 447}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"GetPrompt" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 451}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} len );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"SetProgramDir" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 455}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"GetProgramDir" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 459}( @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} );
/*      Device List Management */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SystemTagList" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 463}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} command, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"System" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 467}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} command, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"SystemTags" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 470}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} command, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tag1type, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AssignLock" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 474}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AssignLate" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 478}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} path );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AssignPath" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 482}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} path );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AssignAdd" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 486}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RemAssignList" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 490}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock );
@{"struct DevProc" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 421} *GetDeviceProc( CONST_STRPTR name, struct DevProc *dp );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeDeviceProc" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 498}( @{"struct DevProc" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 421} *dp );
@{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *LockDosList( ULONG flags );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"UnLockDosList" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 506}( @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *AttemptLockDosList( ULONG flags );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"RemDosEntry" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 514}( @{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *dlist );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AddDosEntry" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 518}( @{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *dlist );
@{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *FindDosEntry( CONST struct DosList *dlist, CONST_STRPTR name, ULONG flags );
@{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *NextDosEntry( CONST struct DosList *dlist, ULONG flags );
@{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *MakeDosEntry( CONST_STRPTR name, LONG type );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeDosEntry" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 534}( @{"struct DosList" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 372} *dlist );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"IsFileSystem" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 538}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name );
/*      Handler Interface */
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"Format" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 542}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} filesystem, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} volumename, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} dostype );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Relabel" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 546}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} drive, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} newname );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Inhibit" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 550}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} onoff );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AddBuffers" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 554}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} number );
/*      Date, Time Routines */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CompareDates" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 558}( @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct DateStamp" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 52} *date1, CONST struct DateStamp *date2 );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DateToStr" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 562}( @{"struct DateTime" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 25} *datetime );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StrToDate" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 566}( @{"struct DateTime" LINK "gg:doc/NDK/Guide/Include/dos/datetime.h/File" 25} *datetime );
/*      Image Management */
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"InternalLoadSeg" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 570}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} fh, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} table, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *funcarray, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *stack );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"InternalUnLoadSeg" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 574}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} seglist, @{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} (*@{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} freefunc)() );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"NewLoadSeg" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 578}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} file, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"NewLoadSegTagList" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 582}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} file, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"struct TagItem" LINK "gg:doc/NDK/Guide/Include/utility/tagitem.h/File" 32} *tags );
@{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} @{"NewLoadSegTags" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 585}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} file, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} tag1type, ... );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"AddSegment" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 589}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} seg, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} system );
@{"struct Segment" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 299} *FindSegment( CONST_STRPTR name, CONST struct Segment *seg, LONG system );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"RemSegment" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 597}( @{"struct Segment" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 299} *seg );
/*      Command Support */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CheckSignal" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 601}( @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} mask );
@{"struct RDArgs" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 95} *ReadArgs( CONST_STRPTR arg_template, LONG *array, struct RDArgs *args );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"FindArg" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 609}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} keyword, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} arg_template );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ReadItem" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 613}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} maxchars, @{"struct CSource" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 61} *cSource );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"StrToLong" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 617}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} string, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} *value );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MatchFirst" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 621}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} pat, @{"struct AnchorPath" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 52} *anchor );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"MatchNext" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 625}( @{"struct AnchorPath" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 52} *anchor );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"MatchEnd" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 629}( @{"struct AnchorPath" LINK "gg:doc/NDK/Guide/Include/dos/dosasl.h/File" 52} *anchor );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ParsePattern" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 633}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} pat, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buf, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} buflen );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MatchPattern" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 637}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} pat, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} str );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"FreeArgs" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 641}( @{"struct RDArgs" LINK "gg:doc/NDK/Guide/Include/dos/rdargs.h/File" 95} *args );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"FilePart" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 645}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} path );
@{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} @{"PathPart" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 649}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} path );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"AddPart" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 653}( @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} dirname, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} filename, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} size );
/*      Notification */
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"StartNotify" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 657}( @{"struct NotifyRequest" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 51} *notify );
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"EndNotify" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 661}( @{"struct NotifyRequest" LINK "gg:doc/NDK/Guide/Include/dos/notify.h/File" 51} *notify );
/*      Environment Variable functions */
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetVar" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 665}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} size, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} flags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"GetVar" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 669}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} buffer, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} size, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} flags );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"DeleteVar" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 673}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} flags );
@{"struct LocalVar" LINK "gg:doc/NDK/Guide/Include/dos/var.h/File" 25} *FindVar( CONST_STRPTR name, ULONG type );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CliInitNewcli" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 681}( @{"struct DosPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 108} *dp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"CliInitRun" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 685}( @{"struct DosPacket" LINK "gg:doc/NDK/Guide/Include/dos/dosextens.h/File" 108} *dp );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"WriteChars" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 689}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} buf, @{"ULONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 52} buflen );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"PutStr" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 693}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} str );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"VPrintf" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 697}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} format, @{"CONST" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 30} @{"APTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 49} argarray );
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"Printf" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 702}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} format, ... );
/* these were unimplemented until dos 36.147 */
@{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} @{"ParsePatternNoCase" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 706}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} pat, @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62} *buf, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} buflen );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"MatchPatternNoCase" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 710}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} pat, @{"STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 67} str );
/* this was added for V37 dos, returned 0 before then. */
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SameDevice" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 714}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock1, @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock2 );

/* NOTE: the following entries did @{"NOT" LINK "gg:doc/NDK/Guide/Include/intuition/intuition.h/File" 1500} exist before ks 36.303 (2.02) */
/* If you are going to use them, open @{"dos.library" LINK "gg:doc/NDK/Guide/dos/MAIN"} with version 37 */

/* These calls were added for V39 dos: */
@{"VOID" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 24} @{"ExAllEnd" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 718}( @{"BPTR" LINK "gg:doc/NDK/Guide/Include/dos/dos.h/File" 130} lock, @{"struct ExAllData" LINK "gg:doc/NDK/Guide/Include/dos/exall.h/File" 45} *buffer, LONG size, LONG data, struct ExAllControl *control );
@{"BOOL" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 91} @{"SetOwner" LINK "gg:doc/NDK/Guide/Include/inline/dos.h/File" 722}( @{"CONST_STRPTR" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 75} name, @{"LONG" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 51} owner_info );

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif   /* CLIB_DOS_PROTOS_H */
@ENDNODE
