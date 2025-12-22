#define CATCOMP_ARRAY
#include "ui.h"
#include "locale.h"
#include <proto/locale.h>
#include <proto/utility.h>
//#include "ui.h"

extern struct Catalog *Catalog;

STRPTR GetString(LONG stringNum)
{
  struct CatCompArrayType *CCA;
  STRPTR  builtIn;
  ULONG entries;

  entries=sizeof(CatCompArray)/sizeof(struct CatCompArrayType);
  
  if(!stringNum)
    return(0);

  CCA=CatCompArray;
  
  while (CCA->cca_ID != stringNum && entries)
  {
    CCA++;
    entries--;
  }
  builtIn = CCA->cca_Str;

  if (LocaleBase)
    return(GetCatalogStr(Catalog,stringNum,builtIn));
  return(builtIn);
}
