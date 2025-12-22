(*
(*
**  Amiga Oberon Interface Module:
**  $VER: IFFParse.mod 40.15 (28.12.93) Oberon 3.1
**
**   © 1993 by Fridtjof Siebert
**   updated for V39, V40 by hartmut Goebel
*)
*)

MODULE IFFParse;

IMPORT
  e * := Exec,
  cb* := ClipBoard,
  u * := Utility,
  y * := SYSTEM;

CONST
  iffparseName * = "iffparse.library";

(* Struct associated with an active IFF stream.
 * "IFFHandle.stream" is a value used by the client's read/write/seek functions -
 * it will not be accessed by the library itself and can have any value
 * (could even be a pointer or a BPTR).
 *
 * This structure can only be allocated by iffparse.library
 *)

TYPE
  IFFHandlePtr * = UNTRACED POINTER TO IFFHandle;
  IFFHandle * = STRUCT
    stream * : LONGINT;
    flags * : LONGSET;
    depth * : LONGINT;      (* Depth of context stack *)
  END;

CONST
(* bit masks for "IFFHandle.flags" field *)
  read      * = LONGSET{};           (* read mode - default *)
  write     * = LONGSET{0};          (* write mode *)
  rwBits    * = read + write;        (* read/write bits *)
  fSeek     * = LONGSET{1};          (* forward seek only *)
  rSeek     * = LONGSET{2};          (* random seek *)
  reserved  * = LONGSET{16..31};     (* Don't touch these bits *)


TYPE
(*****************************************************************************)
(* When the library calls your stream handler, you'll be passed a pointer
 * to this structure as the "message packet".
 *)
  IFFStreamCmdPtr * = UNTRACED POINTER TO IFFStreamCmd;
  IFFStreamCmd * = STRUCT
    command * : LONGINT;     (*  Operation to be performed (IFFCMD_) *)
    buf * : e.APTR;          (*  Pointer to data buffer              *)
    nBytes * : LONGINT;      (*  Number of bytes to be affected      *)
  END;


(*****************************************************************************)

(* A node associated with a context on the iff_Stack.  Each node
 * represents a chunk, the stack representing the current nesting
 * of chunks in the open IFF file.  Each context node has associated
 * local context items in the (private) LocalItems list.  The ID, type,
 * size and scan values describe the chunk associated with this node.
 *
 * This structure can only be allocated by iffparse.library
 *)
  ContextNodePtr * = UNTRACED POINTER TO ContextNode;
  ContextNode * = STRUCT (node *: e.MinNode)
    id   *: LONGINT;
    type *: LONGINT;
    size *: LONGINT;        (*  Size of this chunk             *)
    scan *: LONGINT;        (*  # of bytes read/written so far *)
  END;


(*****************************************************************************)

(* Local context items live in the ContextNode's.  Each class is identified
 * by its lci_Ident code and has a (private) purge vector for when the
 * parent context node is popped.
 *
 * This structure can only be allocated by iffparse.library
 *)
  LocalContextItemPtr * = UNTRACED POINTER TO LocalContextItem;
  LocalContextItem * = STRUCT (node *: e.MinNode)
    id    *: LONGINT;
    type  *: LONGINT;
    ident *: LONGINT;
  END;


(*****************************************************************************)

(* StoredProperty: a local context item containing the data stored
 * from a previously encountered property chunk.
 *)
  StoredPropertyPtr * = UNTRACED POINTER TO StoredProperty;
  StoredProperty * = STRUCT
    size * : LONGINT;
    data * : e.APTR;
  END;

(*****************************************************************************)

(* Collection Item: the actual node in the collection list at which
 * client will look.  The next pointers cross context boundaries so
 * that the complete list is accessable.
 *)
  CollectionItemPtr * = UNTRACED POINTER TO CollectionItem;
  CollectionItem * = STRUCT
    next * : CollectionItemPtr;
    size * : LONGINT;
    data * : e.APTR;
  END;

(*****************************************************************************)

(* Structure returned by OpenClipboard().  You may do CMD_POSTs and such
 * using this structure.  However, once you call OpenIFF(), you may not
 * do any more of your own I/O to the clipboard until you call CloseIFF().
 *)
  ClipboardHandlePtr * = UNTRACED POINTER TO ClipboardHandle;
  ClipboardHandle * = STRUCT (req * : cb.IOClipReq)
    cbport * : e.MsgPort;
    satisfyPort * : e.MsgPort;
  END;

(*****************************************************************************)
CONST
(* IFF return codes.  Most functions return either zero for success or
 * one of these codes.  The exceptions are the read/write functions which
 * return positive values for number of bytes or records read or written,
 * or a negative error code.  Some of these codes are not errors per sae,
 * but valid conditions such as EOF or EOC (End of Chunk).
 *)
  errEOF          * = -1;     (*  Reached logical end of file *)
  errEOC          * = -2;     (*  About to leave context      *)
  errNoScope      * = -3;     (*  No valid scope for property *)
  errNoMem        * = -4;     (*  Internal memory alloc failed*)
  errRead         * = -5;     (*  Stream read error           *)
  errWrite        * = -6;     (*  Stream write error          *)
  errSeek         * = -7;     (*  Stream seek error           *)
  errMangled      * = -8;     (*  Data in file is corrupt     *)
  errSyntax       * = -9;     (*  IFF syntax error            *)
  errNotIFF       * = -10;    (*  Not an IFF file             *)
  errNoHook       * = -11;    (*  No call-back hook provided  *)
  return2Client   * = -12;    (*  Client handler normal return*)

(*****************************************************************************)

(* Universal IFF identifiers *)
  idFORM   * = y.VAL(LONGINT,"FORM");
  idLIST   * = y.VAL(LONGINT,"LIST");
  idCAT    * = y.VAL(LONGINT,"CAT ");
  idPROP   * = y.VAL(LONGINT,"PROP");
  idNULL   * = y.VAL(LONGINT,"    ");

(* Identifier codes for universally recognized local context items *)
  lciPROP         * = y.VAL(LONGINT,"prop");
  lciCOLLECTION   * = y.VAL(LONGINT,"coll");
  lciENTRYHANDLER * = y.VAL(LONGINT,"enhd");
  lciEXITHANDLER  * = y.VAL(LONGINT,"exhd");


(*****************************************************************************)

(* Control modes for ParseIFF() function *)
  parseScan       * = 0;
  parseStep       * = 1;
  parseRawStep    * = 2;


(*****************************************************************************)

(* Control modes for StoreLocalItem() function *)
  sliRoot         * = 1;      (*  Store in default context       *)
  sliTop          * = 2;      (*  Store in current context       *)
  sliProp         * = 3;      (*  Store in topmost FORM or LIST  *)

(*****************************************************************************)

(* Magic value for writing functions. If you pass this value in as a size
 * to PushChunk() when writing a file, the parser will figure out the
 * size of the chunk for you. If you know the size, is it better to
 * provide as it makes things faster.
 *)

  sizeUnknown     * = -1;

(*****************************************************************************)

(* Possible call-back command values *)
  cmdInit     * = 0;       (*  Prepare the stream for a session    *)
  cmdCleanup  * = 1;       (*  Terminate stream session            *)
  cmdRead     * = 2;       (*  Read bytes from stream              *)
  cmdWrite    * = 3;       (*  Write bytes to stream               *)
  cmdSeek     * = 4;       (*  Seek on stream                      *)
  cmdEntry    * = 5;       (*  You just entered a new context      *)
  cmdExit     * = 6;       (*  You're about to leave a context     *)
  cmdPurgeLCI * = 7;       (*  Purge a LocalContextItem            *)

VAR
  base * : e.LibraryPtr;

(*--- functions in V36 or higher (Release 2.0) ---*)

(*------ Basic functions ------*)

PROCEDURE AllocIFF          *{base,- 30}(): IFFHandlePtr;
PROCEDURE OpenIFF           *{base,- 36}(iff{8}            : IFFHandlePtr;
                                         rwMode{0}         : LONGSET): LONGINT;
PROCEDURE ParseIFF          *{base,- 42}(iff{8}            : IFFHandlePtr;
                                         control{0}        : LONGINT): LONGINT;
PROCEDURE CloseIFF          *{base,- 48}(iff{8}            : IFFHandlePtr);
PROCEDURE FreeIFF           *{base,- 54}(ifff{8}           : IFFHandlePtr);

(*------ Read/Write functions ------*)

PROCEDURE ReadChunkBytes    *{base,- 60}(iff{8}            : IFFHandlePtr;
                                         VAR buf{9}        : ARRAY OF e.BYTE;
                                         numBytes{0}       : LONGINT): LONGINT;
PROCEDURE WriteChunkBytes   *{base,- 66}(iff{8}            : IFFHandlePtr;
                                         buf{9}            : ARRAY OF e.BYTE;
                                         numBytes{0}       : LONGINT): LONGINT;
PROCEDURE ReadChunkRecords  *{base,- 72}(iff{8}            : IFFHandlePtr;
                                         VAR buf{9}        : ARRAY OF e.BYTE;
                                         bytesPerRecord{0} : LONGINT;
                                         numRecords{1}     : LONGINT): LONGINT;
PROCEDURE WriteChunkRecords *{base,- 78}(iff{8}            : IFFHandlePtr;
                                         buf{9}            : ARRAY OF e.BYTE;
                                         bytesPerRecord{0} : LONGINT;
                                         numRecords{1}     : LONGINT): LONGINT;

(*------ Context entry/exit ------*)

PROCEDURE PushChunk         *{base,- 84}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT;
                                         size{2}           : LONGINT): LONGINT;
PROCEDURE PopChunk          *{base,- 90}(iff{8}            : IFFHandlePtr): LONGINT;

(*------ Low-level handler installation ------*)

PROCEDURE EntryHandler      *{base,-102}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT;
                                         position{2}       : LONGINT;
                                         handler{9}        : u.HookPtr;
                                         object{10}        : e.APTR): LONGINT;
PROCEDURE ExitHandler       *{base,-108}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT;
                                         position{2}       : LONGINT;
                                         handler{9}        : u.HookPtr;
                                         object{10}        : e.APTR): LONGINT;

(*------ Built-in chunk/property handlers ------*)

PROCEDURE PropChunk         *{base,-114}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT): LONGINT;
PROCEDURE PropChunks        *{base,-120}(iff{8}            : IFFHandlePtr;
                                         propArray{9}      : ARRAY OF LONGINT;
                                         numPairs{0}       : LONGINT): LONGINT;
PROCEDURE StopChunk         *{base,-126}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT): LONGINT;
PROCEDURE StopChunks        *{base,-132}(iff{8}            : IFFHandlePtr;
                                         propArray{9}      : ARRAY OF LONGINT;
                                         numPairs{0}       : LONGINT): LONGINT;
PROCEDURE CollectionChunk   *{base,-138}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT): LONGINT;
PROCEDURE CollectionChunks  *{base,-144}(iff{8}            : IFFHandlePtr;
                                         propArray{9}      : ARRAY OF LONGINT;
                                         numPairs{0}       : LONGINT): LONGINT;
PROCEDURE StopOnExit        *{base,-150}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT): LONGINT;

(*------ Context utilities ------*)

PROCEDURE FindProp          *{base,-156}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT): StoredPropertyPtr;
PROCEDURE FindCollection    *{base,-162}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{0}             : LONGINT): CollectionItemPtr;
PROCEDURE FindPropContext   *{base,-168}(iff{8}            : IFFHandlePtr): ContextNodePtr;
PROCEDURE CurrentChunk      *{base,-174}(iff{8}            : IFFHandlePtr): ContextNodePtr;
PROCEDURE ParentChunk       *{base,-180}(contextNode{8}    : ContextNodePtr): ContextNodePtr;

(*------ LocalContextItem support functions ------*)

PROCEDURE AllocLocalItem    *{base,-186}(type{0}           : LONGINT;
                                         id{1}             : LONGINT;
                                         ident{2}          : LONGINT;
                                         dataSize{3}       : LONGINT): LocalContextItemPtr;
PROCEDURE LocalItemData     *{base,-192}(localItem{8}      : LocalContextItemPtr): e.APTR;
PROCEDURE SetLocalItemPurge *{base,-198}(localItem{8}      : LocalContextItemPtr;
                                         purgeHook{9}      : u.HookPtr);
PROCEDURE FreeLocalItem     *{base,-204}(localItem{8}      : LocalContextItemPtr);
PROCEDURE FindLocalItem     *{base,-210}(iff{8}            : IFFHandlePtr;
                                         type{0}           : LONGINT;
                                         id{1}             : LONGINT;
                                         ident{2}          : LONGINT ): LocalContextItemPtr;
PROCEDURE StoreLocalItem    *{base,-216}(iff{8}            : IFFHandlePtr;
                                         localItem{9}      : LocalContextItemPtr;
                                         position{0}       : LONGINT): LONGINT;
PROCEDURE StoreItemInContext*{base,-222}(iff{8}            : IFFHandlePtr;
                                         localItem{8}      : LocalContextItemPtr;
                                         contextNode{10}   : ContextNodePtr);

(*------ IFFHandle initialization ------*)

PROCEDURE InitIFF           *{base,-228}(iff{8}            : IFFHandlePtr;
                                         flags{0}          : LONGSET;
                                         streamHook{9}     : u.HookPtr);
PROCEDURE InitIFFasDOS      *{base,-234}(iff{8}            : IFFHandlePtr);
PROCEDURE InitIFFasClip     *{base,-240}(iff{8}            : IFFHandlePtr);

(*------ Internal clipboard support ------*)

PROCEDURE OpenClipboard     *{base,-246}(unitNumber{0}     : LONGINT): ClipboardHandlePtr;
PROCEDURE CloseClipboard    *{base,-252}(clipHandle{8}     : ClipboardHandlePtr);

(*------ Miscellaneous ------*)

PROCEDURE GoodID            *{base,-258}(id{0}             : LONGINT): LONGINT;
PROCEDURE GoodType          *{base,-264}(type{0}           : LONGINT): LONGINT;
PROCEDURE IDtoStr           *{base,-270}(id{0}             : LONGINT;
                                         VAR buf{8}        : ARRAY OF CHAR);


(* $OvflChk- $RangeChk- $StackChk- $NilChk- $ReturnChk- $CaseChk- *)

BEGIN
  base :=  e.OpenLibrary(iffparseName,37);

CLOSE
  IF base#NIL THEN e.CloseLibrary(base) END;

END IFFParse.
