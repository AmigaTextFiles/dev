//
//                  CITButton include
//
//                          StormC
//
//                  version 2003.02.12
//

#ifndef CITBUTTON_H
#define CITBUTTON_H TRUE

#include <gadgets/button.h>

#include <citra/CITGadget.h>

//
// This enum for internal use
//
enum
{
  CITBUTTON_RENDERIMAGE,
  CITBUTTON_SELECTIMAGE,
  CITBUTTON_AUTOBUTTON,
  CITBUTTON_PUSHBUTTON,
  CITBUTTON_TEXTPEN,
  CITBUTTON_BACKGROUNDPEN,
  CITBUTTON_FILLTEXTPEN,
  CITBUTTON_FILLPEN,
  CITBUTTON_BEVELSTYLE,
  CITBUTTON_TRANSPARENT,
  CITBUTTON_JUSTIFICATION,
  CITBUTTON_SOFTSTYLE,
  CITBUTTON_VARARGS,
  CITBUTTON_DOMAINSTRING,
  CITBUTTON_INTEGER,
  CITBUTTON_BITMAP,
  CITBUTTON_ANIMBUTTON,
  CITBUTTON_ANIMIMAGES,
  CITBUTTON_SELANIMIMAGES,
  CITBUTTON_MAXANIMIMAGES,
  CITBUTTON_ANIMIMAGENUMBER,
  CITBUTTON_LAST
};

class CITButton:public CITGadget
{
  public:
    CITButton();
    ~CITButton();

    void RenderImage(struct Image* im)
      {setTag(CITBUTTON_RENDERIMAGE,BUTTON_RenderImage,ULONG(im));}
    void SelectImage(struct Image* im)
      {setTag(CITBUTTON_SELECTIMAGE,BUTTON_SelectImage,ULONG(im));}
    void AutoButton(UWORD type)
      {setTag(CITBUTTON_AUTOBUTTON,BUTTON_AutoButton,type);}
    void PushButton(BOOL b = TRUE)
      {setTag(CITBUTTON_PUSHBUTTON,BUTTON_PushButton,b);}
    void TextPen(LONG pen)
      {setTag(CITBUTTON_TEXTPEN,BUTTON_TextPen,pen);}
    void BackgroundPen(LONG pen)
      {setTag(CITBUTTON_BACKGROUNDPEN,BUTTON_BackgroundPen,pen);}
    void FillTextPen(LONG pen)
      {setTag(CITBUTTON_FILLTEXTPEN,BUTTON_FillTextPen,pen);}
    void FillPen(LONG pen)
      {setTag(CITBUTTON_FILLPEN,BUTTON_FillPen,pen);}
    void BevelStyle(WORD style)
      {setTag(CITBUTTON_BEVELSTYLE,BUTTON_BevelStyle,style);}
    void Transparent(BOOL b)
      {setTag(CITBUTTON_TRANSPARENT,BUTTON_Transparent,b);}
    void Justification(WORD pos)
      {setTag(CITBUTTON_JUSTIFICATION,BUTTON_Justification,pos);}
    void SoftStyle(WORD style)
      {setTag(CITBUTTON_SOFTSTYLE,BUTTON_SoftStyle,style);}
    void VarArgs(APTR arg)
      {setTag(CITBUTTON_VARARGS,BUTTON_VarArgs,ULONG(arg));}
    void DomainString(char* t)
      {setTag(CITBUTTON_DOMAINSTRING,BUTTON_DomainString,ULONG(t));}
    void Integer(int val)
      {setTag(CITBUTTON_INTEGER,BUTTON_Integer,val);}
    void BitMap(struct BitMap* bm)
      {setTag(CITBUTTON_BITMAP,BUTTON_BitMap,ULONG(bm));}
    void AnimButton(BOOL b = TRUE)
      {setTag(CITBUTTON_ANIMBUTTON,BUTTON_AnimButton,b);}
    void AnimImages(struct Image* im)
      {setTag(CITBUTTON_ANIMIMAGES,BUTTON_AnimImages,ULONG(im));}
    void SelAnimImages(struct Image* im)
      {setTag(CITBUTTON_SELANIMIMAGES,BUTTON_SelAnimImages,ULONG(im));}
    void MaxAnimImages(LONG max)
      {setTag(CITBUTTON_MAXANIMIMAGES,BUTTON_MaxAnimImages,max);}
    void AnimImageNumber(LONG num)
      {setTag(CITBUTTON_ANIMIMAGENUMBER,BUTTON_AnimImageNumber,num);}
    void AddAnimImageNumber(ULONG num);
    void SubAnimImageNumber(ULONG num);
    
  protected:
    virtual Object* NewObjectA(TagItem* tags);
    
  private:
    void setTag(int index,ULONG attr,ULONG val);
  
    TagItem* buttonTag;
};

enum
{
   BUTTONCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};


#endif
