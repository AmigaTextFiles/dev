//
//                    CITDouble include
//
//                          StormC
//
//                     version 2003.01.28
//

#ifndef CITDOUBLE_H
#define CITDOUBLE_H TRUE

#include <citra/CITString.h>

class CITDouble:public CITString
{
  public:
    CITDouble();
    ~CITDouble();

    void   Format(char* f) { formatStr = f; }
    void   Number(double num);
    double Number();
    
  protected:
    virtual Object* NewObjectA(TagItem* tags);
    virtual ULONG hookEntry(struct Hook* inputHook,APTR object,APTR msg);

    char* formatStr;
    char  outputStr[32];
    
  private:
    TagItem* floatTag;
};

enum
{
  DOUBLECLASS_FLAGBITUSED = STRINGCLASS_FLAGBITUSED
};

#endif
