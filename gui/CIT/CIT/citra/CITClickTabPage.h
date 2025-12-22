//
//                  CITClickTabPage include
//
//                          StormC
//
//                     version 2003.02.13
//

#ifndef CITCLICKTABPAGE_H
#define CITCLICKTABPAGE_H TRUE

#include <citra/CITClickTab.h>
#include <citra/CITPage.h>

class CITClickTabPage:public CITClickTab
{
  public:
    CITClickTabPage();
    ~CITClickTabPage();

    virtual void Refresh();
    
    void NewTab(CITGroup& group,char* label,int pen=-1);
    void NewTab(CITGroup& group,struct Image* im,struct Image* selIm = NULL);

  protected:
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void Delete();
    virtual Object* NewObjectA(TagItem* tags);

    TagItem  clickTabPageTag[2];
    CITPage* page;
};

enum
{
  CLICKTABPAGECLASS_FLAGBITUSED = CLICKTABCLASS_FLAGBITUSED
};


#endif
