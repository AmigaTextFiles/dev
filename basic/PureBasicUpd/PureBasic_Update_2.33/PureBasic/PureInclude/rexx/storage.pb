;
; ** $VER: storage.h 1.4 (8.11.91)
; ** Includes Release 40.15
; **
; ** Header file to define ARexx data structures.
; **
; ** (C) Copyright 1986,1987,1988,1989,1990 William S. Hawes
; ** (C) Copyright 1990-1993 Commodore-Amiga, Inc.
; **  All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "exec/libraries.pb"

;  The NexxStr structure is used to maintain the internal strings in REXX.
;  * It includes the buffer area for the string and associated attributes.
;  * This is actually a variable-length structure; it is allocated for a
;  * specific length string, and the length is never modified thereafter
;  * (since it's used for recycling).
;

Structure NexxStr
   ns_Ivalue.l         ;  integer value
   ns_Length.w         ;  length in bytes (excl null)
   ns_Flags.b         ;  attribute flags
   ns_Hash.b         ;  hash code
   ns_Buff.b[8]        ;  buffer area for strings
EndStructure           ;  size: 16 bytes (minimum)

#NXADDLEN = 9         ;  offset plus null byte
;#IVALUE(nsPtr) = (nsPtr\ns_Ivalue)

;  String attribute flag bit definitions
#NSB_KEEP     = 0         ;  permanent string?
#NSB_STRING   = 1         ;  string form valid?
#NSB_NOTNUM   = 2         ;  non-numeric?
#NSB_NUMBER   = 3         ;  a valid number?
#NSB_BINARY   = 4         ;  integer value saved?
#NSB_FLOAT    = 5         ;  floating point format?
#NSB_EXT      = 6         ;  an external string?
#NSB_SOURCE   = 7         ;  part of the program source?

;  The flag form of the string attributes
#NSF_KEEP     = (1  <<  #NSB_KEEP  )
#NSF_STRING   = (1  <<  #NSB_STRING)
#NSF_NOTNUM   = (1  <<  #NSB_NOTNUM)
#NSF_NUMBER   = (1  <<  #NSB_NUMBER)
#NSF_BINARY   = (1  <<  #NSB_BINARY)
#NSF_FLOAT    = (1  <<  #NSB_FLOAT )
#NSF_EXT      = (1  <<  #NSB_EXT   )
#NSF_SOURCE   = (1  <<  #NSB_SOURCE)

;  Combinations of flags
#NSF_INTNUM   = (#NSF_NUMBER | #NSF_BINARY | #NSF_STRING)
#NSF_DPNUM    = (#NSF_NUMBER | #NSF_FLOAT)
#NSF_ALPHA    = (#NSF_NOTNUM | #NSF_STRING)
#NSF_OWNED    = (#NSF_SOURCE | #NSF_EXT    | #NSF_KEEP)
#KEEPSTR      = (#NSF_STRING | #NSF_SOURCE | #NSF_NOTNUM)
#KEEPNUM      = (#NSF_STRING | #NSF_SOURCE | #NSF_NUMBER | #NSF_BINARY)

;  The RexxArg structure is identical to the NexxStr structure, but
;  * is allocated from system memory rather than from internal storage.
;  * This structure is used for passing arguments to external programs.
;  * It is usually passed as an "argstring", a pointer to the string buffer.
;

Structure RexxArg
   ra_Size.l         ;  total allocated length
   ra_Length.w         ;  length of string
   ra_Flags.b         ;  attribute flags
   ra_Hash.b         ;  hash code
   ra_Buff.b[8]        ;  buffer area
EndStructure           ;  size: 16 bytes (minimum)

;  The RexxMsg structure is used for all communications with REXX
;  * programs.  It is an EXEC message with a parameter block appended.
;

Structure RexxMsg
   rm_Node.Message        ;  EXEC message structure
   *rm_TaskBlock.l        ;  global structure (private)
   *rm_LibBase.l        ;  library base (private)
   rm_Action.l         ;  command (action) code
   rm_Result1.l        ;  primary result (return code)
   rm_Result2.l        ;  secondary result
   *rm_Args.b[16]        ;  argument block (ARG0-ARG15)

   *rm_PassPort.MsgPort        ;  forwarding port
   *rm_CommAddr.l        ;  host address (port name)
   *rm_FileExt.l        ;  file extension
   rm_Stdin.l         ;  input stream (filehandle)
   rm_Stdout.l         ;  output stream (filehandle)
   rm_avail.l         ;  future expansion
   EndStructure           ;  size: 128 bytes

;  Field definitions
;#ARG0(rmp) = (rmp\rm_Args[0])    ;  start of argblock
;#ARG1(rmp) = (rmp\rm_Args[1])    ;  first argument
;#ARG2(rmp) = (rmp\rm_Args[2])    ;  second argument

#MAXRMARG  = 15         ;  maximum arguments

;  Command (action) codes for message packets
#RXCOMM   = $01000000        ;  a command-level invocation
#RXFUNC   = $02000000        ;  a function call
#RXCLOSE   = $03000000        ;  close the REXX server
#RXQUERY   = $04000000        ;  query for information
#RXADDFH   = $07000000        ;  add a function host
#RXADDLIB  = $08000000        ;  add a function library
#RXREMLIB  = $09000000        ;  remove a function library
#RXADDCON  = $0A000000        ;  add/update a ClipList string
#RXREMCON  = $0B000000        ;  remove a ClipList string
#RXTCOPN   = $0C000000        ;  open the trace console
#RXTCCLS   = $0D000000        ;  close the trace console

;  Command modifier flag bits
#RXFB_NOIO    = 16        ;  suppress I/O inheritance?
#RXFB_RESULT  = 17        ;  result string expected?
#RXFB_STRING  = 18        ;  program is a "string file"?
#RXFB_TOKEN   = 19        ;  tokenize the command line?
#RXFB_NONRET  = 20        ;  a "no-return" message?

;  The flag form of the command modifiers
#RXFF_NOIO    = (1  <<  #RXFB_NOIO  )
#RXFF_RESULT  = (1  <<  #RXFB_RESULT)
#RXFF_STRING  = (1  <<  #RXFB_STRING)
#RXFF_TOKEN   = (1  <<  #RXFB_TOKEN )
#RXFF_NONRET  = (1  <<  #RXFB_NONRET)

#RXCODEMASK   = $FF000000
#RXARGMASK    = $0000000F

;  The RexxRsrc structure is used to manage global resources.  Each node
;  * has a name string created as a RexxArg structure, and the total size
;  * of the node is saved in the "rr_Size" field.  The REXX systems library
;  * provides functions to allocate and release resource nodes.  If special
;  * deletion operations are required, an offset and base can be provided in
;  * "rr_Func" and "rr_Base", respectively.  This "autodelete" function will
;  * be called with the base in register A6 and the node in A0.
;

Structure RexxRsrc
   rr_Node.Node
   rr_Func.w         ;  "auto-delete" offset
   *rr_Base.l         ;  "auto-delete" base
   rr_Size.l         ;  total size of node
   rr_Arg1.l         ;  available ...
   rr_Arg2.l         ;  available ...
EndStructure           ;  size: 32 bytes

;  Resource node types
#RRT_ANY      = 0         ;  any node type ...
#RRT_LIB      = 1         ;  a function library
#RRT_PORT     = 2         ;  a public port
#RRT_FILE     = 3         ;  a file IoBuff
#RRT_HOST     = 4         ;  a function host
#RRT_CLIP     = 5         ;  a Clip List node

;  The RexxTask structure holds the fields used by REXX to communicate with
;  * external processes, including the client task.  It includes the global
;  * data structure (and the base environment).  The structure is passed to
;  * the newly-created task in its "wake-up" message.
;

#GLOBALSZ  = 200         ;  total size of GlobalData

Structure RexxTask
   rt_Global.b[#GLOBALSZ]       ;  global data structure
   rt_MsgPort.MsgPort        ;  global message port
   rt_Flags.b         ;  task flag bits
   rt_SigBit.b         ;  signal bit

   *rt_ClientID.l        ;  the client's task ID
   *rt_MsgPkt.l         ;  the packet being processed
   *rt_TaskID.l         ;  our task ID
   *rt_RexxPort.l        ;  the REXX public port

   *rt_ErrTrap.l        ;  Error trap address
   *rt_StackPtr.l        ;  stack pointer for traps

   rt_Header1.List        ;  Environment list
   rt_Header2.List        ;  Memory freelist
   rt_Header3.List        ;  Memory allocation list
   rt_Header4.List        ;  Files list
   rt_Header5.List        ;  Message Ports List
   EndStructure

;  Definitions for RexxTask flag bits
#RTFB_TRACE   = 0         ;  external trace flag
#RTFB_HALT    = 1         ;  external halt flag
#RTFB_SUSP    = 2         ;  suspend task?
#RTFB_TCUSE   = 3         ;  trace console in use?
#RTFB_WAIT    = 6         ;  waiting for reply?
#RTFB_CLOSE   = 7         ;  task completed?

;  Definitions for memory allocation constants
#MEMQUANT  = 16         ;  quantum of memory space
#MEMMASK   = $FFFFFFF0        ;  mask for rounding the size

#MEMQUICK  = (1  <<  0 )        ;  EXEC flags: MEMF_PUBLIC
#MEMCLEAR  = (1  <<  16)        ;  EXEC flags: MEMF_CLEAR

;  The SrcNode is a temporary structure used to hold values destined for
;  * a segment array.  It is also used to maintain the memory freelist.
;

Structure SrcNode
   *sn_Succ.SrcNode        ;  next node
   *sn_Pred.SrcNode        ;  previous node
   *sn_Ptr.l         ;  pointer value
   sn_Size.l         ;  size of object
EndStructure           ;  size: 16 bytes

