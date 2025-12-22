//
//                    CITPage include
//
//                        StormC
//
//                   version 2003.02.13
//

#ifndef CITPAGE_H
#define CITPAGE_H TRUE

#include <citra/CITContainer.h>

//
// This enum for internal use only
//
enum
{
  CITPAGE_CURRENT,
  CITPAGE_FIXEDHORIZ,
  CITPAGE_FIXEDVERT,
  CITPAGE_LAST
};

class CITPage:public CITContainer
{
  public:
    CITPage();
    ~CITPage();

    void InsObject(CITWindowClass &winClass,BOOL &Err);

    void FixedHoriz(BOOL b = TRUE)
      {setTag(CITPAGE_FIXEDHORIZ,PAGE_FixedHoriz,b);}
    void FixedVert(BOOL b = TRUE)
      {setTag(CITPAGE_FIXEDVERT,PAGE_FixedVert,b);}
    void Current(ULONG curr);
       
    ULONG Current()
      {return getTag(PAGE_Current);}
       
    virtual BOOL Attach(Object* child,TagItem* tag,WORD first=FALSE);
    virtual void Detach(Object* child);
    
  protected:  
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void HandleEvent(UWORD id,ULONG eventType,UWORD code);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* pageTag;
    ULONG    currPage;
};

enum
{
  PAGECLASS_FLAGBITUSED = CONTAINERCLASS_FLAGBITUSED
};

#endif
