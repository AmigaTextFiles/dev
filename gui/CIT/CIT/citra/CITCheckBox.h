//
//                  CITButtonGadget include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITCHECKBOX_H
#define CITCHECKBOX_H TRUE

#include <citra/CITGadget.h>

class CITCheckBox:public CITGadget
{
  public:
    CITCheckBox();
    ~CITCheckBox();

    void TextPen(WORD pen);
    void BackgroundPen(WORD pen);
    void TextPlace(WORD pen);
    void Checked(BOOL b);
    BOOL Checked();

  protected:
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void setTag(int index,ULONG attr,ULONG val);

    TagItem* checkBoxTag;
};

enum
{
   CHECKBOXCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};


#endif
