#ifndef EXTRAS_PACKDATA_H
#define EXTRAS_PACKDATA_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define PD_DUMMY     TAG_USER

/* Applicabiliy -- P PD_PackData,  U PD_UnpackData */

#define PD_Version   (1 + PD_DUMMY) /* (PU) Sets the version of the data */
#define PD_IfVersion (2 + PD_DUMMY) /* (U)  If the data version is at least this value proceed, 
                                            otherwise PD_UnpackData stops processing */

#define PD_BYTE      (3 + PD_DUMMY) /* (PU) */
#define PD_UBYTE     (4 + PD_DUMMY) /* (PU) */
 
#define PD_WORD      (5 + PD_DUMMY) /* (PU) */
#define PD_UWORD     (6 + PD_DUMMY) /* (PU) */

#define PD_LONG      (7 + PD_DUMMY) /* (PU) */
#define PD_ULONG     (8 + PD_DUMMY) /* (PU) */

#define PD_STRPTR           (10 + PD_DUMMY) /* (P) NULL terminated string pointer
                                               (U) Allocates memory with AllocVec
                                                   FreeVec()s existing data if PD_FREESTRPTR is set */
#define PD_UsedSTRPTR       (11 + PD_DUMMY) /* ?? (U) FreeVecs existing string before unpacking newstring */
#define PD_STRPTRBufferSize (12 + PD_DUMMY) 
#define PD_STRPTRBuffer     (13 + PD_DUMMY) /* ?? (U) unpacks string into existing buffer, buffersize must be set */

#define PD_APTRSize  (20 + PD_DUMMY) /* (PU) Length in bytes */ 
#define PD_APTR      (21 + PD_DUMMY) /* (P) Data block to write
                                        (U) Allocates memory with AllocVec() */ 
#define PD_UsedAPTR  (22 + PD_DUMMY) /* (U) ??? When unpacking, the supplied memory pointed to by APTR will be 
                                            FreeVec()ed before APTR is overwritten */

#define PD_BufferSize (30 + PD_DUMMY) /* (PU) Set size of data to pack or unpack */
#define PD_Buffer     (31 + PD_DUMMY) /* (P) Pack BufferSize bytes of data.
                                         (U) Data is read into existing memory */

#define PD_StructSize PD_BufferSize
#define PD_Struct     PD_Buffer

#define PD_MemoryFlags  (100 + PD_DUMMY) /* (PU) Set memory flags for memory allocations */
#define PD_FreeSTRPTR   (101 + PD_DUMMY) /* (U) When unpacking STRPTRs, if the supplied STRPTR address already points to string, FreeVec() it */

/* MACROS */

#define PD_STRUCT(o) PD_BufferSize, sizeof(o), PD_Buffer, &o /* (PU) pack:pack a struct or array - unpack:Reads data into an existing struct */

#define PD_PACK_TEXTATTR(t)\
PD_STRPTR,  ((struct TextAttr *)t)->ta_Name,\
PD_WORD,    ((struct TextAttr *)t)->ta_YSize,\
PD_WORD,    ((struct TextAttr *)t)->ta_Style,\
PD_WORD,    ((struct TextAttr *)t)->ta_Flags,

#define PD_UNPACK_TEXTATTR(t)\
PD_STRPTR,  &((struct TextAttr *)t)->ta_Name,\
PD_WORD,    &((struct TextAttr *)t)->ta_YSize,\
PD_WORD,    &((struct TextAttr *)t)->ta_Style,\
PD_WORD,    &((struct TextAttr *)t)->ta_Flags,


//#define PD_ARRAYMACRO(ARRAY,ELEMENTS) PD_APTRSize, (sizeof((ARRAY)[0]) * (ELEMENTS), PD_APTR, (ARRAY),

/* ex.
  struct cow herd[5];
  

  if(PackedData=PackData(
      PD_Version,     2,
      PD_BYTE,        2,
      PD_BYTE,        3,
      PD_STRPTR,      "WRITE TEST",
      
      PD_ARRAYMACRO(myarray,10),
      PD_ULONG,       longarray,
      
      PD_Array,       5,
      PD_APTRSize,    sizeof(struct cow),
      PD_APTR,        cows,
      
      TAG_DONE,       0))

      
*/

struct PackedData
{
  ULONG pd_DataSize;
  UBYTE *pd_Data;
};


#endif /* EXTRAS_PACKDATA_H */
