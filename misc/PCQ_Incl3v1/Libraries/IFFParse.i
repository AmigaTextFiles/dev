{ IFFParse.i }

{$I   "Include:Exec/Types.i"}
{$I   "Include:Exec/Lists.i"}
{$I   "Include:Exec/Ports.i"}
{$I   "Include:Exec/IO.i"}
{$I   "Include:Devices/ClipBoard.i"}
{$I   "Include:Utility/Hooks.i"}

VAR IFFParseBase : Address;

{
 * Struct associated with an active IFF stream.
 * "iff_Stream" is a value used by the client's read/write/seek functions -
 * it will not be accessed by the library itself and can have any value
 * (could even be a pointer or a BPTR).
 }
Type
       IFFHandle = Record
        iff_Stream,
        iff_Flags,
        iff_Depth   : Integer;      {  Depth of context stack.  }
        {  There are private fields hiding here.  }
       END;
       IFFHandlePtr = ^IFFHandle;

{
 * Bit masks for "iff_Flags" field.
 }
CONST
 IFFF_READ     =  0;                      { read mode - default }
 IFFF_WRITE    =  1;                      { write mode }
 IFFF_RWBITS   =  (IFFF_READ + IFFF_WRITE);        { read/write bits }
 IFFF_FSEEK    =  2;                 { forward seek only }
 IFFF_RSEEK    =  4;                 { random seek }
 IFFF_RESERVED =  $FFFF0000;             { Don't touch these bits. }

{
 * When the library calls your stream handler, you'll be passed a pointer
 * to this structure as the "message packet".
 }
Type
       IFFStreamCmd = Record
        sc_Command    : Integer;     {  Operation to be performed (IFFCMD_) }
        sc_Buf        : APTR;         {  Pointer to data buffer              }
        sc_NBytes     : Integer;      {  Number of bytes to be affected      }
       END;
       IFFStreamCmdPtr = ^IFFStreamCmd;
{
 * A node associated with a context on the iff_Stack.  Each node
 * represents a chunk, the stack representing the current nesting
 * of chunks in the open IFF file.  Each context node has associated
 * local context items in the (private) LocalItems list.  The ID, type,
 * size and scan values describe the chunk associated with this node.
 }
       ContextNode = Record
        cn_Node         : MinNode;
        cn_ID,
        cn_Type,
        cn_Size,        {  Size of this chunk             }
        cn_Scan  : Integer;        {  # of bytes read/written so far }
        {  There are private fields hiding here.  }
       END;
       ContextNodePtr = ^ContextNode;

{
 * Local context items live in the ContextNode's.  Each class is identified
 * by its lci_Ident code and has a (private) purge vector for when the
 * parent context node is popped.
 }
       LocalContextItem = Record
        lci_Node        : MinNode;
        lci_ID,
        lci_Type,
        lci_Ident       : Integer;
        {  There are private fields hiding here.  }
       END;
       LocalContextItemPtr = ^LocalContextItem;

{
 * StoredProperty: a local context item containing the data stored
 * from a previously encountered property chunk.
 }
       StoredProperty = Record
        sp_Size  : Integer;
        sp_Data  : Address;
       END;
       StoredPropertyPtr = ^StoredProperty;

{
 * Collection Item: the actual node in the collection list at which
 * client will look.  The next pointers cross context boundaries so
 * that the complete list is accessable.
 }
       CollectionItem = Record
        ci_Next                 : ^CollectionItem;
        ci_Size                 : Integer;
        ci_Data                 : Address;
       END;
       CollectionItemPtr = ^CollectionItem;

{
 * Structure returned by OpenClipboard().  You may do CMD_POSTs and such
 * using this structure.  However, once you call OpenIFF(), you may not
 * do any more of your own I/O to the clipboard until you call CloseIFF().
 }
       ClipboardHandle = Record
        cbh_Req                 : IOClipReqPtr;
        cbh_CBport,
        cbh_SatisfyPort         : MsgPortPtr;
       END;
       ClipboardHandlePtr = ^ClipboardHandle;

{
 * IFF return codes.  Most functions return either zero for success or
 * one of these codes.  The exceptions are the read/write functions which
 * return positive values for number of bytes or records read or written,
 * or a negative error code.  Some of these codes are not errors per sae,
 * but valid conditions such as EOF or EOC (End of Chunk).
 }
CONST
 IFFERR_EOF            =  -1 ;    {  Reached logical END of file }
 IFFERR_EOC            =  -2 ;    {  About to leave context      }
 IFFERR_NOSCOPE        =  -3 ;    {  No valid scope for property }
 IFFERR_NOMEM          =  -4 ;    {  Internal memory alloc failed}
 IFFERR_READ           =  -5 ;    {  Stream read error           }
 IFFERR_WRITE          =  -6 ;    {  Stream write error          }
 IFFERR_SEEK           =  -7 ;    {  Stream seek error           }
 IFFERR_MANGLED        =  -8 ;    {  Data in file is corrupt     }
 IFFERR_SYNTAX         =  -9 ;    {  IFF syntax error            }
 IFFERR_NOTIFF         =  -10;    {  Not an IFF file             }
 IFFERR_NOHOOK         =  -11;    {  No call-back hook provided  }
 IFF_RETURN2CLIENT     =  -12;    {  Client handler normal return}

{
 MAKE_ID(a,b,c,d)        \
        ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
     }
{
 * Universal IFF identifiers.
 }
 ID_FORM = 1179603533;
 ID_LIST = 1279873876;
 ID_CAT  = 1128354848;
 ID_PROP = 1347571536;
 ID_NULL = 538976288;

{
 * Ident codes for universally recognized local context items.
 }
 IFFLCI_PROP         = 1886547824;
 IFFLCI_COLLECTION   = 1668246636;
 IFFLCI_ENTRYHANDLER = 1701734500;
 IFFLCI_EXITHANDLER  = 1702389860;


{
 * Control modes for ParseIFF() function.
 }
 IFFPARSE_SCAN         =  0;
 IFFPARSE_STEP         =  1;
 IFFPARSE_RAWSTEP      =  2;

{
 * Control modes for StoreLocalItem().
 }
 IFFSLI_ROOT           =  1;      {  Store in default context       }
 IFFSLI_TOP            =  2;      {  Store in current context       }
 IFFSLI_PROP           =  3;      {  Store in topmost FORM OR LIST  }

{
 * "Flag" for writing functions.  If you pass this value in as a size
 * to PushChunk() when writing a file, the parser will figure out the
 * size of the chunk for you.  (Chunk sizes >= 2**31 are forbidden by the
 * IFF specification, so this works.)
 }
 IFFSIZE_UNKNOWN       =  -1;

{
 * Possible call-back command values.  (Using 0 as the value for IFFCMD_INIT
 * was, in retrospect, probably a bad idea.)
 }
 IFFCMD_INIT    = 0;       {  Prepare the stream for a session    }
 IFFCMD_CLEANUP = 1;       {  Terminate stream session            }
 IFFCMD_READ    = 2;       {  Read bytes from stream              }
 IFFCMD_WRITE   = 3;       {  Write bytes to stream               }
 IFFCMD_SEEK    = 4;       {  Seek on stream                      }
 IFFCMD_ENTRY   = 5;       {  You just entered a new context      }
 IFFCMD_EXIT    = 6;       {  You're about to leave a context     }
 IFFCMD_PURGELCI= 7;       {  Purge a LocalContextItem            }

{  Backward compatibility.  Don't use these in new code.  }
 IFFSCC_INIT    = IFFCMD_INIT;
 IFFSCC_CLEANUP = IFFCMD_CLEANUP;
 IFFSCC_READ    = IFFCMD_READ;
 IFFSCC_WRITE   = IFFCMD_WRITE;
 IFFSCC_SEEK    = IFFCMD_SEEK;




FUNCTION AllocIFF : IFFHandlePtr;
 External;

FUNCTION OpenIFF(Iff : IffHandlePtr; rwMode : Integer) : Integer;
 External;

FUNCTION ParseIFF(Iff : IFFHandlePtr; control : Integer) : Integer;
 External;

PROCEDURE CloseIFF(IFF : IffHandlePtr);
 External;

PROCEDURE FreeIFF(iff : IFFHandlePtr);
 External;


FUNCTION ReadChunkBytes(IFF : IFFHandlePtr; Buf : Address; Size : Integer) : Integer;
 External;

FUNCTION WriteChunkBytes(IFF : IFFHandlePtr; Buf : Address; Size : Integer) : Integer;
 External;

FUNCTION ReadChunkRecords(IFF : IFFHandlePtr; Buf : Address; BytesPerRecord, nRecords : Integer) : Integer;
 External;

FUNCTION WriteChunkRecords(IFF : IFFHandlePtr; Buf : Address; BytesPerRecord, nRecords : Integer) : Integer;
 External;

FUNCTION PushChunk(IFF : IFFHandlePtr; Typ,ID,Size : Integer) : Integer;
 External;

FUNCTION PopChunk(IFF : IFFhandlePtr) : Integer;
 External;

FUNCTION EntryHandler(IFF : IFFHandlePtr; Typ, ID, position : Integer; Handler : HookPtr; Obj : APTR) : Integer;
 External;

FUNCTION ExitHandler(IFF : IFFHandlePtr; Typ, ID, position : Integer; Handler : HookPtr; Obj : APTR) : Integer;
 External;

FUNCTION PropChunk(IFF : IFFHandlePtr; Typ, ID : Integer) : Integer;
 External;

FUNCTION PropChunks(IFF : IFFHandlePtr; PropArray : ListPtr; nProps : Integer) : Integer;
 External;

FUNCTION StopChunk(IFF : IFFHandlePtr; Typ, ID : Integer) : Integer;
 External;

FUNCTION StopChunks(IFF : IFFHandlePtr; PropArray : ListPtr; nProps : Integer) : Integer;
 External;

FUNCTION CollectionChunk(IFF : IFFHandlePtr; Typ, ID : Integer) : Integer;
 External;

FUNCTION CollectionChunks(IFF : IFFHandlePtr; PropArray : ListPtr; nProps : Integer) : Integer;
 External;

FUNCTION StopOnExit(IFF : IFFHandlePtr; Typ, ID : Integer) : Integer;
 External;

FUNCTION FindProp(IFF : IFFHandlePtr; Typ, ID : Integer) : StoredPropertyPtr;
 External;

FUNCTION FindCollection(IFF : IFFHandlePtr; Typ, ID : Integer) : CollectionItemPtr;
 External;

FUNCTION CurrentChunk(IFF : IFFHandlePtr) : ContextNodePtr;
 External;

FUNCTION ParentChunk(cn : ContextNodePtr) : ContextNodePtr;
 External;

FUNCTION AllocLocalItem(Typ,ID,ident,dataSize : Integer) : LocalContextItemPtr;
 External;

FUNCTION LocalItemData(li : LocalContextItemPtr) : Address;
 External;

PROCEDURE SetLocalItemPurge(li : LocalContextItemPtr; purgeHook : HookPtr);
 External;

PROCEDURE FreeLocalItem(li : LocalContextItemPtr);
 External;

FUNCTION FindLocalItem(IFF : IFFHandlePtr; Typ, ID, ident : Integer) : LocalContextItemPtr;
 External;

FUNCTION StoreLocalItem(IFF : IFFHandlePtr; li : LocalContextItemPtr; pos : Integer) : Integer;
 External;

PROCEDURE StoreItemInContext(IFF : IFFHandlePtr; li : LocalContextItemPtr; cn : ContextNodePtr);
 External;

PROCEDURE InitIFF(IFF : IFFHandlePtr; flags : Integer; streamHook : HookPtr);
 External;

PROCEDURE InitIFFasDOS(IFF : IFFHandlePtr);
 External;

PROCEDURE InitIFFasClip(IFF : IFFHandlePtr);
 External;

FUNCTION OpenClipboard(unitnum : Integer) : ClipboardHandlePtr;
 External;

PROCEDURE CloseClipboard(cb : ClipboardHandlePtr);
 External;

FUNCTION GoodID(id : Integer) : Integer;
 External;

FUNCTION GoodType(Typ : Integer) : Integer;
 External;

FUNCTION IDtoStr(id : Integer; VAR buf : String) : String;
 External;



