;
; ** $VER: rexxio.h 1.4 (8.11.91)
; ** Includes Release 40.15
; **
; ** Header file for ARexx Input/Output related structures
; **
; ** (C) Copyright 1986,1987,1988,1989,1990 William S. Hawes
; ** (C) Copyright 1990-1993 Commodore-Amiga, Inc.
; **  All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "rexx/storage.pb"

#RXBUFFSZ  = 204         ;  buffer length

;
;  * The IoBuff is a resource node used to maintain the File List.  Nodes
;  * are allocated and linked into the list whenever a file is opened.
;
Structure IoBuff
   iobNode.RexxRsrc        ;  structure for files/strings
   *iobRpt.l         ;  read/write pointer
   iobRct.l         ;  character count
   iobDFH.l         ;  DOS filehandle
   *iobLock.l         ;  DOS lock
   iobBct.l         ;  buffer length
   iobArea.b[#RXBUFFSZ]        ;  buffer area
   EndStructure           ;  size: 256 bytes

;  Access mode definitions
#RXIO_EXIST   = -1        ;  an external filehandle
#RXIO_STRF    = 0         ;  a "string file"
#RXIO_READ    = 1         ;  read-only access
#RXIO_WRITE   = 2         ;  write mode
#RXIO_APPEND  = 3         ;  append mode (existing file)

;
;  * Offset anchors for SeekF()
;
#RXIO_BEGIN   = -1        ;  relative to start
#RXIO_CURR    = 0        ;  relative to current position
#RXIO_END     = 1        ;  relative to end

;  The Library List contains just plain resource nodes.

;#LLOFFSET(rrp) = (rrp\rr_Arg1)   ;  "Query" offset
;#LLVERS(rrp)   = (rrp\rr_Arg2)   ;  library version

;
;  * The RexxClipNode structure is used to maintain the Clip List.  The value
;  * string is stored as an argstring in the rr_Arg1 field.
;
;#CLVALUE(rrp) = ((STRPTR) rrp\rr_Arg1)

;
;  * A message port structure, maintained as a resource node.  The ReplyList
;  * holds packets that have been received but haven't been replied.
;
Structure RexxMsgPort
   rmp_Node.RexxRsrc        ;  linkage node
   rmp_Port.MsgPort        ;  the message port
   rmp_ReplyList.List      ;  messages awaiting reply
EndStructure

;
;  * DOS Device types
;
#DT_DEV   = 0         ;  a device
#DT_DIR   = 1         ;  an ASSIGNed directory
#DT_VOL   = 2         ;  a volume

;
;  * Private DOS packet types
;
#ACTION_STACK = 2002        ;  stack a line
#ACTION_QUEUE = 2003        ;  queue a line

