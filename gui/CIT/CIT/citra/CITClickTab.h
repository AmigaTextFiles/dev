//
//                    CITClickTab include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITCLICKTAB_H
#define CITCLICKTAB_H TRUE

#include <citra/CITContainer.h>

class CITClickTab:public CITGadget
{
  public:
    CITClickTab();
    ~CITClickTab();

    void NewTab(char* label,int pen=-1);
    void NewTab(struct Image* im,struct Image* selIm = NULL);
    void Current(LONG cur);
    LONG Current();

  protected:
    //virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    //virtual void HandleEvent(UWORD id,ULONG eventType,UWORD code);
    virtual Object* NewObjectA(TagItem* tags);

    CITList  labelList;
    
  private:
    TagItem* clickTabTag;
    int      nodeNum;
};

enum
{
  CLICKTABCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
