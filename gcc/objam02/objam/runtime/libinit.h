/******************************************************************************/
/*                                                                            */
/* include(s)                                                                 */
/*                                                                            */
/******************************************************************************/

#include <exec/libraries.h>

/******************************************************************************/
/*                                                                            */
/* structure definition for a *** PRIVATE *** library/device base             */
/*                                                                            */
/******************************************************************************/

typedef struct _Library {
  struct Library LibNode;
  UWORD PadWord;
  APTR  SegList;
  APTR  DataSeg;

#ifdef EXTENDED

  ULONG DataSize;
  struct _Library *Parent;

#endif

} _LIB;

#define DevNode LibNode

typedef _LIB _DEV;

/******************************************************************************/
/*                                                                            */
/* prototypes for basic library functions                                     */
/*                                                                            */
/******************************************************************************/

struct Library *LibInit();
struct Library *LibOpen();
APTR LibClose();
APTR LibExpunge();
APTR LibExtFunc();

/******************************************************************************/
/*                                                                            */
/* prototypes for basic device functions                                      */
/*                                                                            */
/******************************************************************************/

struct Library *DevInit();
VOID DevOpen();
APTR DevClose();
APTR DevExpunge();
APTR DevExtFunc();

/******************************************************************************/
/*                                                                            */
/* end of libinit.h                                                           */
/*                                                                            */
/******************************************************************************/
