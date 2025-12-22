\ AMIGA JForth Include file.
decimal
EXISTS? OPAL_REQ_LIB_H NOT .IF
: OPAL_REQ_LIB_H ;

EXISTS? EXEC_LIBRARIES_H NOT .IF
include ji:exec/libraries.j
.THEN

EXISTS? OPALLIB_H NOT .IF
include ji:opal/opallib.j
.THEN

:STRUCT OpalReq
   ( %M JForth prefix )
   USHORT   or_TopEdge
   APTR     or_Hail
   APTR     or_File
   APTR     or_Dir
   APTR     or_Extension
   APTR     or_Window
   APTR     or_OScrn
   APTR     or_Pointer
   SHORT    or_OKHit
   SHORT    or_NeedRefresh
   LONG     or_Flags
   SHORT    or_BackPen
   SHORT    or_PrimaryPen
	SHORT    or_SecondaryPen
;STRUCT


$ 1   constant NO_INFO
$ 2   constant LASTPATH

1   constant OR_ERR_OUTOFMEM
2   constant OR_ERR_INUSE

345   constant OPALREQ_HEIGHT

.THEN

