//
//                     CITText include
//
//                         StormC
//
//                    version 2002.11.23
//

#ifndef CIT_TEXT_H
#define CIT_TEXT_H TRUE

#ifndef CIT_BUTTON_H
#include <citra/CITButton.h>
#endif

class CITText:public CITButton
{
  public:
    CITText() { ReadOnly(); BevelStyle(4); }
};

#endif
