//
//                    CITImage include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITIMAGE_H
#define CITIMAGE_H TRUE

#include <citra/CITRootClass.h>

class CITContainer;

class CITImage:public CITRootClass
{
  public:
    CITImage();
    ~CITImage();

    struct Image* objectPtr();

  protected:
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void Delete();
    virtual Object* NewObjectA(TagItem* tags);

    LONG  fgPen;
    LONG  bgPen;
    UBYTE textMode;
    
  private:
    TagItem* imageTag;
};

enum
{
  IMAGECLASS_FLAGBITUSED = WINCLASS_FLAGBITUSED
};

#endif
