//
//                    CITContainer include
//
//                        StormC
//
//                   version 2003.02.13
//

#ifndef CITCONTAINER_H
#define CITCONTAINER_H TRUE

#include <citra/CITGadget.h>

class CITContainer:public CITGadget
{
  public:
    void InsObject(CITWindowClass &winClass,BOOL &Err);
    void RemObject(CITWindowClass &winClass);

    virtual void Refresh();
    
  protected:
    void Delete();

    CITList childList;
};

class ContainerObjectNode:public CITNode
{
  public:
    class CITWindowClass* cop;
};

enum
{
  CONTAINERCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif // CITCONTAINER_H
