/*
** ObjectiveAmiga: NeXTSTEP NXAtom emulation under AmigaOS
** See GNU:lib/libobjam/ReadMe for details
*/


#include <exec/lists.h>
#include <proto/exec.h>
#include <clib/alib_protos.h>
#include <stddef.h>

#include <libraries/objc.h>
#include <clib/objc_protos.h>

#include "misc.h" /* For the ANSI function emulations */
#include "zone.h" /* For quick access to the default zone */


struct List *__AtomList;


NXAtom __FindAtom(const char *buffer)
{
  struct Node *worknode, *nextnode;

  worknode=(struct Node *)(__AtomList->lh_Head);
  while(nextnode=(struct Node *)(worknode->ln_Succ))
  {
    if(strcmp(buffer,worknode->ln_Name)==0) return (NXAtom)(worknode->ln_Name);
    worknode=nextnode;
  }

  return NULL;
}


NXAtom __AddAtom(const char *buffer, BOOL copyBuffer)
{
  NXAtom atom;
  struct Node *node;

  if(copyBuffer)
  {
    if(!(atom=NXCopyStringBuffer(buffer))) return NULL;
  }
  else atom=(NXAtom)buffer;

  if(!(node=(struct Node *)NXZoneMalloc(__DefaultMallocZone,sizeof(struct Node))))
  {
    if(copyBuffer) NXZoneFree(__DefaultMallocZone,(void *)atom);
    return NULL;
  }
  node->ln_Name=(STRPTR)atom;
  AddTail(__AtomList,node);

  return atom;
}


NXAtom NXUniqueString(const char *buffer)
{
  NXAtom atom;

  if(!buffer) return NULL;
  if(atom=__FindAtom(buffer)) return atom;
  return __AddAtom(buffer,TRUE);
}


NXAtom NXUniqueStringWithLength(const char *buffer, int length)
{
  char *terminatedBuffer;
  NXAtom atom;
  int i;

  if(!buffer) return NULL;
  if(!length) return NULL;
  if(!(terminatedBuffer=(char *)NXZoneMalloc(__DefaultMallocZone,length))) return NULL;

  for(i=0;i<length;i++) terminatedBuffer[i]=buffer[i];
  terminatedBuffer[i+1]=0;

  atom=NXUniqueString(terminatedBuffer);
  NXZoneFree(__DefaultMallocZone,(void *)terminatedBuffer);

  return atom;
}


NXAtom NXUniqueStringNoCopy(const char *buffer)
{
  NXAtom atom;

  if(!buffer) return NULL;
  if(atom=__FindAtom(buffer)) return atom;
  return __AddAtom(buffer,FALSE);
}


char *NXCopyStringBuffer(const char *buffer)
{
  return NXCopyStringBufferFromZone(buffer,__DefaultMallocZone);
}


char *NXCopyStringBufferFromZone(const char *buffer, NXZone *zone)
{
  char *newBuffer;

  if(!buffer) return NULL;

  if(!(newBuffer=(char *)NXZoneMalloc(zone,strlen(buffer)+1))) return NULL;
  strcpy(newBuffer,buffer);

  return newBuffer;
}

