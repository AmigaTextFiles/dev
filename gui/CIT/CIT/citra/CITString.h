//
//                    CITString include
//
//                          StormC
//
//                     version 2003.02.11
//

#ifndef CITSTRING_H
#define CITSTRING_H TRUE

#include <citra/CITInput.h>

class CITString:public CITInput
{
  public:
    CITString();
    ~CITString();

    void  TextVal(char* text);
    char* TextVal();
    
  protected:
    virtual Object* NewObjectA(TagItem* tags);
    
  private:
    TagItem* stringTag;
};

enum
{
  STRINGCLASS_FLAGBITUSED = INPUTCLASS_FLAGBITUSED
};

#endif
