//
//                    CITGadget include
//
//                          StormC
//
//                     version 2003.02.20
//

#ifndef CITGADGET_H
#define CITGADGET_H TRUE

#include <intuition/gadgetclass.h>
#include <gadgets/layout.h>
#include <images/label.h>

#include <citra/CITRootClass.h>

//
// These three enums are for internal use
//
enum
{
  CITGADGET_ID = 0,
  CITGADGET_POSITION_X,
  CITGADGET_POSITION_Y,
  CITGADGET_WIDTH,
  CITGADGET_HEIGHT,
  CITGADGET_DISABLED,
  CITGADGET_SELECTED,
  CITGADGET_TEXT,
  CITGADGET_RELVERIFY,
  CITGADGET_FOLLOWMOUSE,
  CITGADGET_TABCYCLE,
  CITGADGET_GADGETHELP,
  CITGADGET_READONLY,
  CITGADGET_UNDERSCORE,
  CITGADGET_TEXTATTR,
  CITGADGET_LAST
};

enum
{
  CITGADLABEL_FONT,
  CITGADLABEL_FOREGROUNDPEN,
  CITGADLABEL_BACKGROUNDPEN,
  CITGADLABEL_MODE,
  CITGADLABEL_SOFTSTYLE,
  CITGADLABEL_JUSTIFICATION,
  CITGADLABEL_TEXT,
  CITGADLABEL_LAST
};

enum
{
  CITGADCHILD_MINWIDTH,
  CITGADCHILD_MINHEIGHT,
  CITGADCHILD_MAXWIDTH,
  CITGADCHILD_MAXHEIGHT,
  CITGADCHILD_NOMINALSIZE,
  CITGADCHILD_WEIGHTEDWIDTH,
  CITGADCHILD_WEIGHTEDHEIGHT,
  CITGADCHILD_WEIGHTMINIMUM,
  //CITGADCHILD_SCALEDWIDTH,
  //CITGADCHILD_SCALEDHEIGHT,
  CITGADCHILD_LAST
};


class CITGadget:public CITRootClass
{
  public:
    CITGadget();
    ~CITGadget();

    virtual void Refresh();
    
    void Position(int x,int y);
    void Size(int w, int h);
    void Font(char *Name, int Height, int Width = 0);
    void Disabled(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_DISABLED,GA_Disabled,b);}
    void Selected(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_SELECTED,GA_Selected,b);}
    void Activate();
    void Text(char* t)
      {setGadgetTag(CITGADGET_TEXT,GA_Text,ULONG(t));}
    void RelVerify(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_RELVERIFY,GA_RelVerify,b);}
    void FollowMouse(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_FOLLOWMOUSE,GA_FollowMouse,b);}
    void TabCycle(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_TABCYCLE,GA_TabCycle,b);}
    void GadgetHelp(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_GADGETHELP,GA_GadgetHelp,b);}
    void ReadOnly(BOOL b = TRUE)
      {setGadgetTag(CITGADGET_READONLY,GA_ReadOnly,b);}
    void Underscore(char c)
      {setGadgetTag(CITGADGET_UNDERSCORE,GA_Underscore,c);}

    void MinWidth(ULONG w)
      {setChildTag(CITGADCHILD_MINWIDTH,CHILD_MinWidth,w);}
    void MinHeight(ULONG h)
      {setChildTag(CITGADCHILD_MINHEIGHT,CHILD_MinHeight,h);}
    void MaxWidth(ULONG w)
      {setChildTag(CITGADCHILD_MAXWIDTH,CHILD_MaxWidth,w);}
    void MaxHeight(ULONG h)
      {setChildTag(CITGADCHILD_MAXHEIGHT,CHILD_MaxHeight,h);}
    void NominalSize(BOOL b = TRUE)
      {setChildTag(CITGADCHILD_NOMINALSIZE,CHILD_NominalSize,b);}
    void WeightedWidth(ULONG w)
      {setChildTag(CITGADCHILD_WEIGHTEDWIDTH,CHILD_WeightedWidth,w);}
    void WeightedHeight(ULONG h)
      {setChildTag(CITGADCHILD_WEIGHTEDHEIGHT,CHILD_WeightedHeight,h);}
    void WeightMinimum(BOOL b = TRUE)
      {setChildTag(CITGADCHILD_WEIGHTMINIMUM,CHILD_WeightMinimum,b);}
    //void ScaledWidth(UWORD w)
    //  {setChildTag(CITGADCHILD_SCALEDWIDTH,CHILD_ScaledWidth,w);}
    //void ScaledHeight(UWORD h)
    //  {setChildTag(CITGADCHILD_SCALEDHEIGHT,CHILD_ScaledHeight,h);}

    void LabelFont(struct TextAttr* attr)
      {setLabelTag(CITGADLABEL_FONT,IA_Font,ULONG(attr));}
    void LabelForegroundPen(LONG pen)
      {setLabelTag(CITGADLABEL_FOREGROUNDPEN,IA_FGPen,pen);}
    void LabelBackgroundPen(LONG pen)
      {setLabelTag(CITGADLABEL_BACKGROUNDPEN,IA_BGPen,pen);}
    void LabelMode(UBYTE mode);
    void LabelSoftStyle(UBYTE style)
      {setLabelTag(CITGADLABEL_SOFTSTYLE,LABEL_SoftStyle,style);}
    void LabelJustification(UWORD pos)
      {setLabelTag(CITGADLABEL_JUSTIFICATION,LABEL_Justification,pos);}
    void LabelText(char* text)
      {setLabelTag(CITGADLABEL_TEXT,LABEL_Text,ULONG(text));}
    void Id(ULONG GadgetID);

    short width();
    short height();
    short leftEdge();
    short topEdge();

    void CallbackHook(ULONG (*p)(void*,void*,ULONG),ULONG userData);
    void CallbackHook(void *obj,ULONG (*)(void*,void*,void*,ULONG),ULONG userData);
    
    virtual void EventHandler(void (*p)(ULONG Id,ULONG eventType),ULONG eventMask=IDCMP_GADGETUP);
    virtual void EventHandler(void* obj,void (*)(void*,ULONG,ULONG),ULONG eventMask=IDCMP_GADGETUP);

  protected:
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual void Delete();
    virtual Object* NewObjectA(TagItem* tags);

    virtual void HandleEvent(UWORD id,ULONG eventType,UWORD code);
    virtual void GadgetEvent(UWORD id,ULONG eventType,UWORD code);

    virtual ULONG hookEntry(struct Hook* inputHook,void* object,void* msg);
    virtual void  hookSetup(ULONG userData);
    
    struct Hook* createHook(ULONG userData);

    void *eventObj;
    union
    {
      void (*Proc0)(ULONG Id,ULONG eventFlag);
      void (*Proc1)(void* obj,ULONG Id,ULONG eventFlag);
    } event;

    void *callbackObj;
    union
    {
      ULONG (*proc0)(void*,void*,ULONG);
      ULONG (*proc1)(void*,void*,void*,ULONG);
    } callback;

    ULONG   gadgetID;
    
  private:
    friend ULONG cppHookEntry(struct CITGadgetHook*,APTR,APTR);

    void setGadgetTag(int index,ULONG attr,ULONG val);
    void setChildTag(int index,ULONG attr,ULONG val);
    void setLabelTag(int index,ULONG attr,ULONG val);
    void SetUp();
    void CleanUp();

    struct Hook* hook;

    TagItem* gadgetTag;
    TagItem* labelTag;
    TagItem* childTag;
};

typedef ULONG (*CALLBACKHOOK)(void*,void*,ULONG);
typedef ULONG (*MEMBERCALLBACKHOOK)(void*,void*,void*,ULONG);

enum
{
  CONTAINED_IN_PAGE_BIT = ROOTCLASS_FLAGBITUSED,
  GADGETCLASS_FLAGBITUSED
};

#define CONTAINED_IN_PAGE (1<<CONTAINED_IN_PAGE_BIT)

#endif
