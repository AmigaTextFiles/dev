//
//                    CITGroup include
//
//                        StormC
//
//                   version 2003.02.13
//

#ifndef CITGROUP_H
#define CITGROUP_H TRUE

#include <citra/CITContainer.h>

//
// This enum for internal use only
//
enum
{
  CITGROUP_FIXEDHORIZ,
  CITGROUP_FIXEDVERT,
  CITGROUP_HORIZALIGNMENT,
  CITGROUP_VERTALIGNMENT,
  CITGROUP_SHRINKWRAP,
  CITGROUP_EVENSIZE,
  CITGROUP_SPACEINNER,
  CITGROUP_SPACEOUTER,
  CITGROUP_INNERSPACING,
  CITGROUP_TOPSPACING,
  CITGROUP_BOTTOMSPACING,
  CITGROUP_LEFTSPACING,
  CITGROUP_RIGHTSPACING,
  CITGROUP_BEVELSTYLE,
  CITGROUP_BEVELSTATE,
  CITGROUP_BEVELLABEL,
  CITGROUP_BEVELLABELPLACE,
  CITGROUP_TEXTPEN,
  CITGROUP_FILLPEN,
  CITGROUP_FILLPATTERN,
  CITGROUP_LABELCOLUMN,
  CITGROUP_LABELWIDTH,
  CITGROUP_ORIENTATION,
  CITGROUP_DEFERLAYOUT,
  CITGROUP_LAST
};

class CITGroup:public CITContainer
{
  public:
    CITGroup();
    ~CITGroup();

    void InsObject(CITWindowClass &winClass,BOOL &Err);

    void Orientation(ULONG o)
      { gOrientation = o;}
    void FixedHoriz(BOOL b = TRUE)
      {setTag(CITGROUP_FIXEDHORIZ,LAYOUT_FixedHoriz,b);}
    void FixedVert(BOOL b = TRUE)
      {setTag(CITGROUP_FIXEDVERT,LAYOUT_FixedVert,b);}
    void HorizAlignment(ULONG align)
      {setTag(CITGROUP_HORIZALIGNMENT,LAYOUT_HorizAlignment,align);}
    void VertAlignment(ULONG align)
      {setTag(CITGROUP_VERTALIGNMENT,LAYOUT_VertAlignment,align);}
    void ShrinkWrap(BOOL b = TRUE)
      {setTag(CITGROUP_SHRINKWRAP,LAYOUT_ShrinkWrap,b);}
    void EvenSize(BOOL b = TRUE)
      {setTag(CITGROUP_EVENSIZE,LAYOUT_EvenSize,b);}
    void SpaceInner(BOOL b = TRUE)
      {setTag(CITGROUP_SPACEINNER,LAYOUT_SpaceInner,b);}
    void SpaceOuter(BOOL b = TRUE)
      {setTag(CITGROUP_SPACEOUTER,LAYOUT_SpaceOuter,b);}
    void InnerSpacing(ULONG spacing)
      {setTag(CITGROUP_INNERSPACING,LAYOUT_InnerSpacing,spacing);}
    void TopSpacing(ULONG spacing)
      {setTag(CITGROUP_TOPSPACING,LAYOUT_TopSpacing,spacing);}
    void BottomSpacing(ULONG spacing)
      {setTag(CITGROUP_BOTTOMSPACING,LAYOUT_BottomSpacing,spacing);}
    void LeftSpacing(ULONG spacing)
      {setTag(CITGROUP_LEFTSPACING,LAYOUT_LeftSpacing,spacing);}
    void RightSpacing(ULONG spacing)
      {setTag(CITGROUP_RIGHTSPACING,LAYOUT_RightSpacing,spacing);}
    void BevelStyle(ULONG style = 2) // 2 = BVS_GROUP
      {setTag(CITGROUP_BEVELSTYLE,LAYOUT_BevelStyle,style);}
    void BevelState(ULONG state)
      {setTag(CITGROUP_BEVELSTATE,LAYOUT_BevelState,state);}
    void BevelLabel(char* text,UWORD place = 0); // 0 = BVJ_TOP_CENTER
    void TextPen(WORD pen)
      {setTag(CITGROUP_TEXTPEN,LAYOUT_TextPen,pen);}
    void FillPen(WORD pen)
      {setTag(CITGROUP_FILLPEN,LAYOUT_FillPen,pen);}
    void FillPattern(UWORD* pat)
      {setTag(CITGROUP_FILLPATTERN,LAYOUT_FillPattern,ULONG(pat));}
    void LabelColumn(ULONG column)
      {setTag(CITGROUP_LABELCOLUMN,LAYOUT_LabelColumn,column);}
    void LabelWidth(ULONG w)
      {setTag(CITGROUP_LABELWIDTH,LAYOUT_LabelWidth,w);}
       
    virtual BOOL Attach(Object* child,TagItem* tag,WORD first=FALSE);
    virtual void Detach(Object* child);
    
  protected:  
    virtual BOOL Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);
    
    ULONG gOrientation;

  private:
    void setTag(int index,ULONG attr,ULONG val);

    TagItem* groupTag;
};

class CITHGroup:public CITGroup
{
  public:
    CITHGroup() {gOrientation = 0;} // 0 = LAYOUT_HORIZONTAL
};

typedef CITGroup CITVGroup;

enum
{
  GROUPCLASS_FLAGBITUSED = CONTAINERCLASS_FLAGBITUSED
};

#endif
