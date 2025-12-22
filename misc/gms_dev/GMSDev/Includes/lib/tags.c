/* Compile: dcc -c -l0 -mD -mi tags.c -o tags.o */

#include <proto/dpkernel.h>

extern APTR DPKBase;

APTR InitTags(APTR container, unsigned long tag1, ...)
{
  return(InitTagList(container, (struct TagItem *)&tag1));
}

APTR AddSysObjectTags(WORD ClassID, WORD ObjectID, BYTE *Name, unsigned long tag1, ...)
{
  return(AddSysObjectTagList(ClassID, ObjectID, Name, (struct TagItem *)&tag1));
}

void DPrintFTagList(BYTE *Header, struct TagItem *);

void DPrintF(BYTE *Header, const BYTE *tag1, ...)
{
  DPrintFTagList(Header, (struct TagItem *)&tag1);
}

