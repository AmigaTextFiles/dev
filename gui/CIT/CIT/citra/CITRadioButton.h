//
//                    CITRadioButton include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITRADIOBUTTON_H
#define CITRADIOBUTTON_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/radiobutton.h>

//
// This enum is for internal use only
//
enum
{
  CITRADIOBUTTON_LABELS = 0,
  CITRADIOBUTTON_SPACING,
  CITRADIOBUTTON_SELECTED,
  CITRADIOBUTTON_LABELPLACE,
  CITRADIOBUTTON_LAST
};

class CITRadioButton:public CITGadget
{
  public:
    CITRadioButton();
    ~CITRadioButton();

    void Labels(char** labels);
    void Labels(List* labels)
           {setTag(CITRADIOBUTTON_LABELS,RADIOBUTTON_Labels,ULONG(labels));}
    void Spacing(WORD spacing)
           {setTag(CITRADIOBUTTON_SPACING,RADIOBUTTON_Spacing,spacing);}
    void Selected(LONG sel)
           {setTag(CITRADIOBUTTON_SELECTED,RADIOBUTTON_Selected,sel);}
    void LabelPlace(WORD place)
           {setTag(CITRADIOBUTTON_LABELPLACE,RADIOBUTTON_LabelPlace,place);}

    WORD Selected();

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);

    TagItem* radioButtonTag;
    CITList  labelList;
};

enum
{
  RADIOBUTTONCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
