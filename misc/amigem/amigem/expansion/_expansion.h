#ifndef __expansion_h_
#define __expansion_h_
#include <libraries/configvars.h>
#include <dos/dos.h>
struct ExpansionBase;
  void  _AddConfigDev (struct ExpansionBase * , struct ConfigDev *configDev );
#define  AddConfigDev(b1) _AddConfigDev (ExpansionBase ,b1)
  struct ConfigDev *  _AllocConfigDev (struct ExpansionBase * );
#define  AllocConfigDev() _AllocConfigDev (ExpansionBase )
  struct ConfigDev *  _FindConfigDev (struct ExpansionBase * , struct ConfigDev *oldConfigDev , LONG manufacturer , LONG product );
#define  FindConfigDev(b1,b2,b3) _FindConfigDev (ExpansionBase ,b1,b2,b3)
  void  _FreeConfigDev (struct ExpansionBase * , struct ConfigDev *configDev );
#define  FreeConfigDev(b1) _FreeConfigDev (ExpansionBase ,b1)
  void  _SetCurrentBinding (struct ExpansionBase * , struct CurrentBinding *currentBinding , ULONG size );
#define  SetCurrentBinding(b1,b2) _SetCurrentBinding (ExpansionBase ,b1,b2)
  ULONG  _GetCurrentBinding (struct ExpansionBase * , struct CurrentBinding *currentBinding , ULONG size );
#define  GetCurrentBinding(b1,b2) _GetCurrentBinding (ExpansionBase ,b1,b2)
  void  _ObtainConfigBinding (struct ExpansionBase * );
#define  ObtainConfigBinding() _ObtainConfigBinding (ExpansionBase )
  void  _ReleaseConfigBinding (struct ExpansionBase * );
#define  ReleaseConfigBinding() _ReleaseConfigBinding (ExpansionBase )
  struct Library *  _Expansion_Open (struct ExpansionBase * , ULONG version );
#define  Expansion_Open(b1) _Expansion_Open (ExpansionBase ,b1)
  BPTR  _Expansion_Close (struct ExpansionBase * );
#define  Expansion_Close() _Expansion_Close (ExpansionBase )
  BPTR  _Expansion_Expunge (struct ExpansionBase * );
#define  Expansion_Expunge() _Expansion_Expunge (ExpansionBase )
  ULONG  _Expansion_Null (struct ExpansionBase * );
#define  Expansion_Null() _Expansion_Null (ExpansionBase )
 #endif