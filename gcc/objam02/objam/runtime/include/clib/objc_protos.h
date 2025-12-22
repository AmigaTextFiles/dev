/*
** ObjectiveAmiga: objc.library protos
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef  CLIB_OBJC_PROTOS_H
#define  CLIB_OBJC_PROTOS_H

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  LIBRARIES_OBJC_H
#include <libraries/objc.h>
#endif

#include <stddef.h>

/* NXZone emulation functions */
NXZone * NXCreateZone(size_t startSize, size_t granularity, int canFree);
NXZone * NXCreateChildZone(NXZone *parentZone, size_t startSize, size_t granularity, int canFree);
void     NXMergeZone(NXZone *zone);
NXZone * NXZoneFromPtr(void *ptr);
void     NXDestroyZone(NXZone *zone);
void   * NXZoneMalloc(NXZone *zone, int size);
void   * NXZoneCalloc(NXZone *zone, int numElements, int elementSize);
void   * NXZoneRealloc(NXZone *zone, void *block, int size);
void     NXZoneFree(NXZone *zone, void *block);
void     NXNameZone(NXZone *zone, const char *name);
void     NXZonePtrInfo(void *ptr);
NXZone * NXDefaultMallocZone(void);
int      NXMallocCheck(void);

/* NXAtom emulation and string manipulation functions */

NXAtom   NXUniqueString(const char *buffer);
NXAtom   NXUniqueStringWithLength(const char *buffer, int length);
NXAtom   NXUniqueStringNoCopy(const char *buffer);
char   * NXCopyStringBuffer(const char *buffer);
char   * NXCopyStringBufferFromZone(const char *buffer, NXZone *zone);

/* ObjC support functions */
void   * __objc_xmalloc(int size);
void   * __objc_xmalloc_from_zone(int size, NXZone* zone);
void   * __objc_xrealloc(void* mem, int size);
void   * __objc_xcalloc(int nelem, int size);
void     __objc_xfree(void *mem);
void     objc_fatal(const char* msg);
void     __objc_archiving_fatal(const char* format, int arg1);

/* Class related functions */
id       class_create_instance(OCClass* class);
id       class_create_instance_from_zone(OCClass* class, NXZone* zone);
id       object_copy(id object);
id       object_copy_from_zone(id object, NXZone* zone);
id       object_dispose(id object);

/* Type encoding functions */
int      objc_aligned_size(const char* type);
int      objc_sizeof_type(const char* type);
int      objc_alignof_type(const char* type);
int      objc_aligned_size(const char* type);
int      objc_promoted_size(const char* type);
const char * objc_skip_type_qualifiers(const char* type);
const char * objc_skip_typespec(const char* type);
const char * objc_skip_offset(const char* type);
const char * objc_skip_argspec(const char* type);
int      method_get_number_of_arguments(struct objc_method* m);
int      method_get_sizeof_arguments(struct objc_method* m);
char   * method_get_first_argument(struct objc_method* m, arglist_t argframe, const char** type);
char   * method_get_next_argument(arglist_t argframe, const char **type);
char   * method_get_nth_argument(struct objc_method* m, arglist_t argframe, int arg, const char **type);
unsigned objc_get_type_qualifiers(const char* type);

/* Sparse array functions */
struct sarray * sarray_new(int size, void *default_element);
void            sarray_free(struct sarray *array);
struct sarray * sarray_lazy_copy(struct sarray *oarr);
void            sarray_realloc(struct sarray *array, int new_size);
void            sarray_at_put(struct sarray *array, sidx index, void* elem);
void            sarray_at_put_safe(struct sarray *array, sidx index, void* elem);
void            __objc_print_dtable_stats(void);

/* Private functions */
BOOL     __objclib_init(struct __objclib_init_data *data);

#endif /* CLIB_OBJC_PROTOS_H */
