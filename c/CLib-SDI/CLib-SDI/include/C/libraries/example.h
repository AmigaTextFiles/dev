/*
**      $VER: example.h 1.1 (21.09.2002)
**
**      main include file for example.library
*/

#ifndef LIBRARIES_EXAMPLE_H
#define LIBRARIES_EXAMPLE_H

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

/* This is the official part of ExampleBase. It has private fields as well. */

struct ExampleBase {
  struct Library         exb_LibNode;
  UWORD                  exb_Unused;       /* better alignment */
  ULONG                  exb_NumCalls;     /* example field */
  ULONG                  exb_NumHookCalls; /* example field */
};

#endif /* LIBRARIES_EXAMPLE_H */
