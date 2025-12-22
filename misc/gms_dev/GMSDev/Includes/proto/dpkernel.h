#ifndef PROTO_DPKERNEL_H
#define PROTO_DPKERNEL_H

#ifndef DPKNOBASE
 #ifndef DPKLOCAL
  extern struct BLTBase *BLTBase;
  extern struct DPKBase *DPKBase;
  extern struct SCRBase *SCRBase;
  extern struct SNDBase *SNDBase;

  extern struct Module *BLTModule;
  extern struct Module *SCRModule;
  extern struct Module *SNDModule;
 #else
  struct BLTBase *BLTBase;
  struct DPKBase *DPKBase;
  struct SCRBase *SCRBase;
  struct SNDBase *SNDBase;

  struct Module *BLTModule;
  struct Module *SCRModule;
  struct Module *SNDModule;
 #endif
#endif

#include <clib/dpkernel_protos.h>
#include <pragmas/dpkernel_pragmas.h>
#include <pragmas/dpkernel_extras.h>
#include <pragmas/blitter_pragmas.h>
#include <pragmas/screens_pragmas.h>
#include <pragmas/sound_pragmas.h>
#include <pragmas/files_pragmas.h>

#endif

