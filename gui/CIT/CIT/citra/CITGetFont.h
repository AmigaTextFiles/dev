//
//                    CITGetFont include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITGETFONT_H
#define CITGETFONT_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/getfont.h>

//
// This enum is for internal use only
//
enum
{
  CITGETFONT_TEXTATTR = 0,
  CITGETFONT_DOFRONTPEN,
  CITGETFONT_DOBACKPEN,
  CITGETFONT_DOSTYLE,
  CITGETFONT_DODRAWMODE,
  CITGETFONT_MINHEIGHT,
  CITGETFONT_MAXHEIGHT,
  CITGETFONT_FIXEDWIDTHONLY,
  CITGETFONT_TITLETEXT,
  CITGETFONT_HEIGHT,
  CITGETFONT_WIDTH,
  CITGETFONT_LEFTEDGE,
  CITGETFONT_TOPEDGE,
  CITGETFONT_FRONTPEN,
  CITGETFONT_BACKPEN,
  CITGETFONT_DRAWMODE,
  CITGETFONT_MAXFRONTPEN,
  CITGETFONT_MAXBACKPEN,
  CITGETFONT_MODELIST,
  CITGETFONT_FRONTPENS,
  CITGETFONT_BACKPENS,
  CITGETFONT_LAST
};

class CITGetFont:public CITGadget
{
  public:
    CITGetFont();
    ~CITGetFont();

    void TextAttr(struct TextAttr* attr)
           {setTag(CITGETFONT_TEXTATTR,GETFONT_TextAttr,ULONG(attr));}
    void DoFrontPen(BOOL b = TRUE)
           {setTag(CITGETFONT_DOFRONTPEN,GETFONT_DoFrontPen,b);}
    void DoBackPen(BOOL b = TRUE)
           {setTag(CITGETFONT_DOBACKPEN,GETFONT_DoBackPen,b);}
    void DoStyle(BOOL b = TRUE)
           {setTag(CITGETFONT_DOSTYLE,GETFONT_DoStyle,b);}
    void DoDrawMode(BOOL b = TRUE)
           {setTag(CITGETFONT_DODRAWMODE,GETFONT_DoDrawMode,b);}
    void FontMinHeight(UWORD min)
           {setTag(CITGETFONT_MINHEIGHT,GETFONT_MinHeight,min);}
    void FontMaxHeight(UWORD max)
           {setTag(CITGETFONT_MAXHEIGHT,GETFONT_MaxHeight,max);}
    void FixedWidthOnly(BOOL b = TRUE)
           {setTag(CITGETFONT_FIXEDWIDTHONLY,GETFONT_FixedWidthOnly,b);}
    void RequesterTitleText(char* text)
           {setTag(CITGETFONT_TITLETEXT,GETFONT_TitleText,ULONG(text));}
    void RequesterLeftEdge(WORD x)
           {setTag(CITGETFONT_LEFTEDGE,GETFONT_LeftEdge,x);}
    void RequesterTopEdge(WORD y)
           {setTag(CITGETFONT_TOPEDGE,GETFONT_TopEdge,y);}
    void RequesterWidth(WORD w)
           {setTag(CITGETFONT_WIDTH,GETFONT_Width,w);}
    void RequesterHeight(WORD h)
           {setTag(CITGETFONT_HEIGHT,GETFONT_Height,h);}
    void FrontPen(UBYTE pen)
           {setTag(CITGETFONT_FRONTPEN,GETFONT_FrontPen,pen);}
    void BackPen(UBYTE pen)
           {setTag(CITGETFONT_BACKPEN,GETFONT_BackPen,pen);}
    void DrawMode(UBYTE mode)
           {setTag(CITGETFONT_DRAWMODE,GETFONT_DrawMode,mode);}
    void MaxFrontPen(UBYTE pen)
           {setTag(CITGETFONT_MAXFRONTPEN,GETFONT_MaxFrontPen,pen);}
    void MaxBackPen(UBYTE pen)
           {setTag(CITGETFONT_MAXBACKPEN,GETFONT_MaxBackPen,pen);}
    void ModeList(char** mode)
           {setTag(CITGETFONT_MODELIST,GETFONT_ModeList,ULONG(mode));}
    void FrontPens(UBYTE* pens)
           {setTag(CITGETFONT_FRONTPENS,GETFONT_FrontPens,ULONG(pens));}
    void BackPens(UBYTE* pens)
           {setTag(CITGETFONT_BACKPENS,GETFONT_BackPens,ULONG(pens));}

    struct TextAttr*  TextAttr()
           { return (struct TextAttr*)getTag(GETFONT_TextAttr); }
    WORD  RequesterLeftEdge()
           { return getTag(GETFONT_LeftEdge); }
    WORD  RequesterTopEdge()
           { return getTag(GETFONT_TopEdge); }
    WORD  RequesterWidth()
           { return getTag(GETFONT_Width); }
    WORD  RequesterHeight()
           { return getTag(GETFONT_Height); }
    WORD  FrontPen()
           { return getTag(GETFONT_FrontPen); }
    WORD  BackPen()
           { return getTag(GETFONT_BackPen); }
    WORD  DrawMode()
           { return getTag(GETFONT_DrawMode); }
    WORD  SoftStyle()
           { return getTag(GETFONT_SoftStyle); }

    void RequestFont();

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* getFontTag;
};

enum
{
  GETFONTCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
