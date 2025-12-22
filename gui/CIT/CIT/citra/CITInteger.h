//
//                    CITInteger include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITINTEGER_H
#define CITINTEGER_H TRUE

#include <citra/CITInput.h>

class CITInteger:public CITInput
{
  public:
    CITInteger();
    ~CITInteger();

    void Minimum(LONG min);
    void Maximum(LONG max);
    void Arrows(BOOL b = TRUE);
    void Number(LONG num);
    int  Number();
    
  protected:
    virtual Object* NewObjectA(TagItem* tags);
    
  private:
    void setTag(int index,ULONG attr,ULONG val);
  
    TagItem* integerTag;
};

enum
{
  INTEGERCLASS_FLAGBITUSED = INPUTCLASS_FLAGBITUSED
};


#endif
