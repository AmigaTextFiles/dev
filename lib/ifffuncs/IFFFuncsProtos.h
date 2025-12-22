
#ifndef  IFFFUNCSPROTOS_H
# define IFFFUNCSPROTOS_H 1

PRIVATE struct eIFF {

   struct Library          *IFFParseBase;   

#  ifdef __amigaos4__
   struct IFFParseIFace    *IIFFParse;
#  endif

   /* Structure associated with an active IFF stream.
   ** "iff_Stream" is a value used by the client's read/write/seek functions -
   ** it will not be accessed by the library itself and can have any value
   ** (could even be a pointer or a BPTR).
   **
   ** This structure can only be allocated by iffparse.library
   */
   struct IFFHandle        *IFFHandlePtr;

   /* When the library calls your stream handler, you'll be passed a pointer
   ** to this structure as the "message packet".
   */
   struct IFFStreamCmd     *IFFStreamCmdPtr;

   /* A node associated with a context on the iff_Stack. Each node
   ** represents a chunk, the stack representing the current nesting
   ** of chunks in the open IFF file. Each context node has associated
   ** local context items in the (private) LocalItems list.  The ID, type,
   ** size and scan values describe the chunk associated with this node.
   **
   ** This structure can only be allocated by iffparse.library
   */
   struct ContextNode      *ContextNodePtr;

   /* Collection Item: the actual node in the collection list at which
   ** client will look. The next pointer crosses context boundaries so
   ** that the complete list is accessable.
   */
   struct CollectionItem   *CollectionItemPtr;

   /* Local context items live in the ContextNode's.  Each class is identified
   ** by its lci_Ident code and has a (private) purge vector for when the
   ** parent context node is popped.
   **
   ** This structure can only be allocated by iffparse.library
   */
   struct LocalContextItem *LocalContextItemPtr;

   /* StoredProperty: a local context item containing the data stored
   ** from a previously encountered property chunk.
   */
   struct StoredProperty   *StoredPropertyPtr;

   /* Structure returned by OpenClipboard(). You may do CMD_POSTs and such
   ** using this structure. However, once you call OpenIFF(), you may not
   ** do any more of your own I/O to the clipboard until you call CloseIFF().
   */
   struct ClipboardHandle  *ClipboardHandlePtr;

   int                      Status;
   int                      StreamType; // 0 = DOS, 1 = Clipboard, 2 = Other
};

PUBLIC void Close_IFF( struct eIFF *ip );

PUBLIC struct eIFF *Open_IFF( char *iffName, int Type, int Mode );

PUBLIC void Init_IFFHook(    struct eIFF *ip, struct Hook *hook, int flags );
PUBLIC void Init_IFFAsDOS(   struct eIFF *ip );
PUBLIC void Init_IFFAsClip(  struct eIFF *ip );
PUBLIC void Close_Clipboard( struct eIFF *ip );

PUBLIC struct ClipboardHandle *Open_Clipboard( struct eIFF *ip, int unit );

PUBLIC LONG Parse_IFF(        struct eIFF *ip, int mode );
PUBLIC LONG Read_Chunk_Bytes( struct eIFF *ip, APTR buff, LONG numBytes );

PUBLIC LONG Read_Chunk_Records( struct eIFF *ip,
                                APTR         buff,
                                int          numBytes, 
                                int          numRecs
                              );

PUBLIC LONG Write_Chunk_Bytes( struct eIFF *ip, CONST APTR buff, int numBytes );

PUBLIC LONG Write_Chunk_Records( struct eIFF *ip,
                                 CONST APTR   buff,
                                 int          numBytes, 
                                 int          numRecs 
                               );

PUBLIC LONG Stop_Chunk(       struct eIFF *ip, int type, int id );
PUBLIC LONG Prop_Chunk(       struct eIFF *ip, int type, int id );
PUBLIC LONG Collection_Chunk( struct eIFF *ip, int type, int id );
PUBLIC LONG Stop_OnExit(      struct eIFF *ip, int type, int id );

PUBLIC LONG Entry_Handler( struct eIFF *ip,
                           struct Hook *hook,
                           APTR         theObject,
                           int          type, 
                           int          id, 
                           int          position 
                         );

PUBLIC LONG Exit_Handler( struct eIFF *ip, 
                          struct Hook *hook,
                          APTR         theObject,
                          int          type, 
                          int          id, 
                          int          position 
                        );

PUBLIC LONG Stop_Chunks(       struct eIFF *ip, CONST LONG *propArray, int numPairs );
PUBLIC LONG Prop_Chunks(       struct eIFF *ip, CONST LONG *propArray, int numPairs );
PUBLIC LONG Collection_Chunks( struct eIFF *ip, CONST LONG *propArray, int numPairs );

PUBLIC LONG Push_Chunk(      struct eIFF *ip, int type, int id, int size );
PUBLIC LONG Pop_Chunk(       struct eIFF *ip );
PUBLIC LONG Store_LocalItem( struct eIFF *ip, int position );

PUBLIC APTR Local_ItemData(  struct eIFF *ip );

PUBLIC struct StoredProperty *Find_Prop( struct eIFF *ip, int type, int id );

PUBLIC struct CollectionItem *Find_Collection( struct eIFF *ip, int type, int id );

PUBLIC struct ContextNode *Current_Chunk(    struct eIFF *ip );
PUBLIC struct ContextNode *Find_PropContext( struct eIFF *ip );
PUBLIC struct ContextNode *Parent_Chunk(     struct eIFF *ip );

PUBLIC struct LocalContextItem *Find_LocalItem( struct eIFF *ip, 
                                                int          type, 
                                                int          id, 
                                                int          ident
                                              );

PUBLIC struct LocalContextItem *Alloc_LocalItem( struct eIFF *ip,
                                                 int          type, 
                                                 int          id, 
                                                 int          ident, 
                                                 int          dataSize
                                               );

PUBLIC void Store_ItemInContext( struct eIFF *ip );
PUBLIC void Free_LocalItem(      struct eIFF *ip );
PUBLIC void Set_LocalItem_Purge( struct eIFF *ip, struct Hook *hook );
   
PUBLIC char *GetErrorString( int errnum );

PUBLIC STRPTR idToString(    int identifier );

/*

PRIVATE int SetupCatalog( void );

PRIVATE STRPTR CMsg( int strIndex, char *defaultString );

PRIVATE BOOL OpenIFFLibrary( struct eIFF *ip, LONG version );
PRIVATE BOOL AllocateIFF( struct IFFHandle *ip );
PRIVATE BOOL OpenIFF_File( struct eIFF *ip, int type, char *name );
PRIVATE BOOL CheckType_ID( int type, int id );

PRIVATE void CloseIFFLibrary( struct eIFF *ip );
PRIVATE void FreeIFFAllocation( struct IFFHandle *ip );
PRIVATE void CloseIFF_File( struct eIFF *ip, int type );
PRIVATE void MemoryOut(    char *msg );
PRIVATE void FoundNullPtr( char *msg );

PRIVATE int CatalogIFF( void );
PRIVATE char *translateErrNum( int errnum );

*/

#endif

/* ------------- END of IFFFuncsProtos.h file! ---------------- */
