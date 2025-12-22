//
//                    CITChooser include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITCHOOSER_H
#define CITCHOOSER_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/chooser.h>

//
// This enum is for internal use only
//
enum
{
  CITCHOOSER_LABELS = 0,
  CITCHOOSER_POPUP,
  CITCHOOSER_DROPDOWN,
  CITCHOOSER_TITLE,
  CITCHOOSER_SELECTED,
  CITCHOOSER_WIDTH,
  CITCHOOSER_AUTOFIT,
  CITCHOOSER_MAXLABELS,
  CITCHOOSER_OFFSET,
  CITCHOOSER_HIDDEN,
  CITCHOOSER_LAST
};

class CITChooser:public CITGadget
{
  public:
    CITChooser();
    ~CITChooser();


    void Labels(char** labels);
    void Labels(List* labels)
           {setTag(CITCHOOSER_LABELS,CHOOSER_Labels,ULONG(labels));}
    void PopUp(BOOL b = TRUE)
           {setTag(CITCHOOSER_POPUP,CHOOSER_PopUp,b);}
    void DropDown(BOOL b = TRUE)
           {setTag(CITCHOOSER_DROPDOWN,CHOOSER_DropDown,b);}
    void Title(char* title)
           {setTag(CITCHOOSER_TITLE,CHOOSER_Title,ULONG(title));}
    void Selected(WORD sel)
           {setTag(CITCHOOSER_SELECTED,CHOOSER_Selected,sel);}
    void Width(WORD w)
           {setTag(CITCHOOSER_WIDTH,CHOOSER_Width,w);}
    void AutoFit(BOOL b = TRUE)
           {setTag(CITCHOOSER_AUTOFIT,CHOOSER_AutoFit,b);}
    void MaxLabels(WORD max)
           {setTag(CITCHOOSER_MAXLABELS,CHOOSER_MaxLabels,max);}
    void Offset(WORD off)
           {setTag(CITCHOOSER_OFFSET,CHOOSER_Offset,off);}
    void Hidden(BOOL b = TRUE)
           {setTag(CITCHOOSER_HIDDEN,CHOOSER_Hidden,b);}

    WORD Selected();

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);

    TagItem* chooserTag;
    CITList  labelList;
};

enum
{
   CHOOSERCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
