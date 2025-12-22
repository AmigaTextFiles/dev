;
; ** $VER: iffparse.h 39.1 (1.6.92)
; ** Includes Release 40.15
; **
; ** iffparse.library structures and constants
; **
; ** (C) Copyright 1989-1993 Commodore-Amiga Inc.
; ** (C) Copyright 1989-1990 Stuart Ferguson and Leo L. Schwab
; ** All Rights Reserved
;

; ***************************************************************************


IncludePath   "PureInclude:"
XIncludeFile "exec/lists.pb"
XIncludeFile "exec/ports.pb"
XIncludeFile "devices/clipboard.pb"

; ***************************************************************************


;  Structure associated with an active IFF stream.
;  * "iff_Stream" is a value used by the client's read/write/seek functions -
;  * it will not be accessed by the library itself and can have any value
;  * (could even be a pointer or a BPTR).
;  *
;  * This structure can only be allocated by iffparse.library
;
Structure IFFHandle
    iff_Stream.l
    iff_Flags.l
    iff_Depth.l ;   Depth of context stack
EndStructure

;  bit masks for "iff_Flags" field
#IFFF_READ = 0    ;  read mode - default
#IFFF_WRITE = 1    ;  write mode
#IFFF_RWBITS = (#IFFF_READ | #IFFF_WRITE) ;  read/write bits
#IFFF_FSEEK = (1 << 1)   ;  forward seek only
#IFFF_RSEEK = (1 << 2)   ;  random seek
#IFFF_RESERVED = $FFFF0000   ;  Don't touch these bits


; ***************************************************************************


;  When the library calls your stream handler, you'll be passed a pointer
;  * to this structure as the "message packet".
;
Structure IFFStreamCmd

    sc_Command.l ;  Operation to be performed (IFFCMD_)
   *sc_Buf.l ;  Pointer to data buffer
    sc_NBytes.l ;  Number of bytes to be affected
EndStructure


; ***************************************************************************


;  A node associated with a context on the iff_Stack. Each node
;  * represents a chunk, the stack representing the current nesting
;  * of chunks in the open IFF file. Each context node has associated
;  * local context items in the (private) LocalItems list.  The ID, type,
;  * size and scan values describe the chunk associated with this node.
;  *
;  * This structure can only be allocated by iffparse.library
;
Structure ContextNode

    cn_Node.MinNode
    cn_ID.l
    cn_Type.l
    cn_Size.l ;   Size of this chunk
    cn_Scan.l ;   # of bytes read/written so far
EndStructure


; ***************************************************************************


;  Local context items live in the ContextNode's.  Each class is identified
;  * by its lci_Ident code and has a (private) purge vector for when the
;  * parent context node is popped.
;  *
;  * This structure can only be allocated by iffparse.library
;
Structure LocalContextItem

    lci_Node.MinNode
    lci_ID.l
    lci_Type.l
    lci_Ident.l
EndStructure


; ***************************************************************************


;  StoredProperty: a local context item containing the data stored
;  * from a previously encountered property chunk.
;
Structure StoredProperty

    sp_Size.l
    *sp_Data.l
EndStructure


; ***************************************************************************


;  Collection Item: the actual node in the collection list at which
;  * client will look. The next pointers cross context boundaries so
;  * that the complete list is accessable.
;
Structure CollectionItem

    *ci_Next.CollectionItem
    ci_Size.l
    ci_Data.l
EndStructure


; ***************************************************************************


;  Structure returned by OpenClipboard(). You may do CMD_POSTs and such
;  * using this structure. However, once you call OpenIFF(), you may not
;  * do any more of your own I/O to the clipboard until you call CloseIFF().
;
Structure ClipboardHandle

    cbh_Req.IOClipReq
    cbh_CBport.MsgPort
    cbh_SatisfyPort.MsgPort
EndStructure


; ***************************************************************************


;  IFF return codes. Most functions return either zero for success or
;  * one of these codes. The exceptions are the read/write functions which
;  * return positive values for number of bytes or records read or written,
;  * or a negative error code. Some of these codes are not errors per sae,
;  * but valid conditions such as EOF or EOC (End of Chunk).
;
#IFFERR_EOF   = -1 ;  Reached logical end of file
#IFFERR_EOC   = -2 ;  About to leave context
#IFFERR_NOSCOPE   = -3 ;  No valid scope for property
#IFFERR_NOMEM   = -4 ;  Internal memory alloc failed
#IFFERR_READ   = -5 ;  Stream read error
#IFFERR_WRITE   = -6 ;  Stream write error
#IFFERR_SEEK   = -7 ;  Stream seek error
#IFFERR_MANGLED   = -8 ;  Data in file is corrupt
#IFFERR_SYNTAX   = -9 ;  IFF syntax error
#IFFERR_NOTIFF   = -10 ;  Not an IFF file
#IFFERR_NOHOOK   = -11 ;  No call-back hook provided
#IFF_RETURN2CLIENT = -12 ;  Client handler normal return


; ***************************************************************************


;#MAKE_ID(a,b,c,d) = \
; ( (a) << 24 |  (b) << 16 |  (c) << 8 |  (d))

;  Universal IFF identifiers
#ID_FORM  = $464F524D ; MAKE_ID('F','O','R','M')
#ID_LIST  = $4C495354 ; MAKE_ID('L','I','S','T')
#ID_CAT   = $43415420 ; MAKE_ID('C','A','T',' ')
#ID_PROP  = $50524F50 ; MAKE_ID('P','R','O','P')
#ID_NULL  = $20202020 ; MAKE_ID(' ',' ',' ',' ')


;  Identifier codes for universally recognized local context items
#IFFLCI_PROP  = $70726F70 ; MAKE_ID('p','r','o','p')
#IFFLCI_COLLECTION = $636F6C6C ; MAKE_ID('c','o','l','l')
#IFFLCI_ENTRYHANDLER = $656E6864; MAKE_ID('e','n','h','d')
#IFFLCI_EXITHANDLER = $65786864 ; MAKE_ID('e','x','h','d')

; ***************************************************************************


;  Control modes for ParseIFF() function
#IFFPARSE_SCAN  = 0
#IFFPARSE_STEP  = 1
#IFFPARSE_RAWSTEP = 2


; ***************************************************************************


;  Control modes for StoreLocalItem() function
#IFFSLI_ROOT  = 1  ;  Store in default context
#IFFSLI_TOP   = 2  ;  Store in current context
#IFFSLI_PROP  = 3  ;  Store in topmost FORM or LIST


; ***************************************************************************


;  Magic value for writing functions. If you pass this value in as a size
;  * to PushChunk() when writing a file, the parser will figure out the
;  * size of the chunk for you. If you know the size, is it better to
;  * provide as it makes things faster.
;
#IFFSIZE_UNKNOWN = -1


; ***************************************************************************


;  Possible call-back command values
#IFFCMD_INIT = 0 ;  Prepare the stream for a session
#IFFCMD_CLEANUP = 1 ;  Terminate stream session
#IFFCMD_READ = 2 ;  Read bytes from stream
#IFFCMD_WRITE = 3 ;  Write bytes to stream
#IFFCMD_SEEK = 4 ;  Seek on stream
#IFFCMD_ENTRY = 5 ;  You just entered a new context
#IFFCMD_EXIT = 6 ;  You're about to leave a context
#IFFCMD_PURGELCI = 7 ;  Purge a LocalContextItem


; ***************************************************************************


;  Obsolete IFFParse definitions, here for source code compatibility only.
;  * Please do NOT use in new code.
;  *
;  * #define IFFPARSE_V37_NAMES_ONLY to remove these older names
;
#IFFSCC_INIT = #IFFCMD_INIT
#IFFSCC_CLEANUP = #IFFCMD_CLEANUP
#IFFSCC_READ = #IFFCMD_READ
#IFFSCC_WRITE = #IFFCMD_WRITE
#IFFSCC_SEEK = #IFFCMD_SEEK


; ***************************************************************************


