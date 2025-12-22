//
//       CITList and CITHook include
//
//						 StormC
//
//            version 2003.02.22
//

#ifndef CITHOOK_H
#define CITHOOK_H TRUE

#include <utility/hooks.h>

extern "C"
{
#ifndef __GNUC__
  extern void* getDataBase();
#else
  #define getDataBase() 0
#endif
}


struct CITHook:public Hook
{
  void* dataBase;
};

#endif
