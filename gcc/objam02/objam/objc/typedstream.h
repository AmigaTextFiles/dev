/*
** ObjectiveAmiga: GNU Objective-C Typed Streams interface
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef __typedstream_INCLUDE_GNU
#define __typedstream_INCLUDE_GNU

#include <objc/objc.h>
#include <objc/hash.h>
#include <libraries/dos.h>

#define OBJC_READONLY   0x01
#define OBJC_WRITEONLY  0x02

typedef int (*objc_typed_read_func)(void*, char*, int);
typedef int (*objc_typed_write_func)(void*, const char*, int);
typedef int (*objc_typed_flush_func)(void*);
typedef int (*objc_typed_eof_func)(void*);


typedef struct objc_typed_stream {
  void* physical;
  cache_ptr object_table;	/* read/written objects */
  cache_ptr stream_table;	/* other read/written but shared things.. */
  cache_ptr class_table;	/* class version mapping */
  cache_ptr object_refs;	/* forward references */
  int mode;			/* OBJC_READONLY or OBJC_WRITEONLY */
  int type;			/* MANAGED, FILE, MEMORY etc bit string */
  int version;			/* version used when writing */
  int writing_root_p;
  objc_typed_read_func read;
  objc_typed_write_func write;
  objc_typed_eof_func eof;
  objc_typed_flush_func flush;
} TypedStream;


/*
** Read and write objects as specified by TYPE.  All the `last'
** arguments are pointers to the objects to read/write.  
*/

int objc_write_type (TypedStream* stream, const char* type, const void* data);
int objc_read_type (TypedStream* stream, const char* type, void* data);

int objc_write_types (TypedStream* stream, const char* type, ...);
int objc_read_types (TypedStream* stream, const char* type, ...);

int objc_write_object_reference (TypedStream* stream, id object);
int objc_write_root_object (TypedStream* stream, id object);

int objc_get_stream_class_version (TypedStream* stream, OCClass* class);


/*
** Convenience funtions
*/

int objc_write_array (TypedStream* stream, const char* type, int count, const void* data);
int objc_read_array (TypedStream* stream, const char* type, int count, void* data);

int objc_write_object (TypedStream* stream, id object);
int objc_read_object (TypedStream* stream, id* object);


/*
** Open a typed stream for reading or writing.  MODE may be either of OBJC_READONLY or OBJC_WRITEONLY.
*/

TypedStream* objc_amigaopen_typedstream (BPTR physical, int mode);
TypedStream* objc_open_typed_stream_for_file (const char* file_name, int mode);

void objc_close_typed_stream (TypedStream* stream);

BOOL objc_end_of_typed_stream (TypedStream* stream);
void objc_flush_typed_stream (TypedStream* stream);


/*
** NeXTSTEP compatibility
*/

typedef TypedStream NXTypedStream;

#define NXWriteType               objc_write_type
#define NXReadType                objc_read_type
#define NXWriteTypes              objc_write_types
#define NXReadTypes               objc_read_types
#define NXWriteObjectReference    objc_write_object_reference
#define NXWriteRootObject         objc_write_root_object
#define NXGetStreamClassVersion   objc_get_stream_class_version
#define NXWriteArray              objc_write_array
#define NXReadArray               objc_read_array
#define NXWriteObject             objc_write_object
#define NXOpenTypedStreamForFile  objc_open_typed_stream_for_file
#define NXCloseTypedStream        objc_close_typed_stream
#define NXEndOfTypedStream        objc_end_of_typed_stream
#define NXFlushTypedStream        objc_flush_typed_stream

static inline id NXReadObject(NXTypedStream *s) {id o=nil; objc_read_object(s,&o); return o;}

#define NX_READONLY               OBJC_READONLY
#define NX_WRITEONLY              OBJC_WRITEONLY


#endif /* not __typedstream_INCLUDE_GNU */
