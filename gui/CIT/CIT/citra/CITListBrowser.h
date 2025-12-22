//
//                    CITListBrowser include
//
//                          StormC
//
//                     version 2003.02.12
//

#ifndef CITLISTBROWSER_H
#define CITLISTBROWSER_H TRUE

#include <citra/CITGadget.h>

#include <gadgets/listbrowser.h>

//
// This enum is for internal use only
//
enum
{
  CITLISTBROWSER_LABELS = 0,
  CITLISTBROWSER_TOP,
  CITLISTBROWSER_MAKEVISIBLE,
  CITLISTBROWSER_SPACING,
  CITLISTBROWSER_SELECTED,
  CITLISTBROWSER_MULTISELECT,
  CITLISTBROWSER_SHOWSELECTED,
  CITLISTBROWSER_VERTSEPARATORS,
  CITLISTBROWSER_HORIZSEPARATORS,
  CITLISTBROWSER_BORDERLESS,
  CITLISTBROWSER_COLUMNINFO,
  CITLISTBROWSER_COLUMNTITLES,
  CITLISTBROWSER_AUTOFIT,
  CITLISTBROWSER_VIRTUALWIDTH,
  CITLISTBROWSER_LEFT,
  CITLISTBROWSER_VERTICALPROP,
  CITLISTBROWSER_HORIZONTALPROP,
  CITLISTBROWSER_VPROPTOTAL,
  CITLISTBROWSER_VPROPTOP,
  CITLISTBROWSER_VPROPVISIBLE,
  CITLISTBROWSER_HPROPTOTAL,
  CITLISTBROWSER_HPROPTOP,
  CITLISTBROWSER_HPROPVISIBLE,
  CITLISTBROWSER_VIEWPOSITION,
  CITLISTBROWSER_SCROLLRASTER,
  CITLISTBROWSER_HIERARCHICAL,
  CITLISTBROWSER_SHOWIMAGE,
  CITLISTBROWSER_HIDEIMAGE,
  CITLISTBROWSER_LEAFIMAGE,
  CITLISTBROWSER_EDITABLE,
  CITLISTBROWSER_EDITNODE,
  CITLISTBROWSER_EDITCOLUMN,
  CITLISTBROWSER_EDITTAGS,
  CITLISTBROWSER_CHECKIMAGE,
  CITLISTBROWSER_UNCHECKEDIMAGE,
  CITLISTBROWSER_MINNODESIZE,
  CITLISTBROWSER_TITLECLICKABLE,
  CITLISTBROWSER_MINVISIBLE,
  CITLISTBROWSER_PERSISTSELECT,
  CITLISTBROWSER_CURSORSELECT,
  CITLISTBROWSER_FASTRENDER,
  CITLISTBROWSER_WRAPTEXT,
  CITLISTBROWSER_LAST
};

class CITListBrowser:public CITGadget
{
  public:
    CITListBrowser();
    ~CITListBrowser();

    void Labels(char** labels);
    void Labels(List* labels)
           {setTag(CITLISTBROWSER_LABELS,LISTBROWSER_Labels,ULONG(labels));}
    void Top(LONG top)
           {setTag(CITLISTBROWSER_TOP,LISTBROWSER_Top,top);}
    void MakeVisible(LONG mv)
           {setTag(CITLISTBROWSER_MAKEVISIBLE,LISTBROWSER_MakeVisible,mv);}
    void Spacing(WORD spacing)
           {setTag(CITLISTBROWSER_SPACING,LISTBROWSER_Spacing,spacing);}
    void Selected(LONG sel)
           {setTag(CITLISTBROWSER_SELECTED,LISTBROWSER_Selected,sel);}
    void MultiSelect(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_MULTISELECT,LISTBROWSER_MultiSelect,b);}
    void ShowSelected(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_SHOWSELECTED,LISTBROWSER_ShowSelected,b);}
    void VertSeparators(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_VERTSEPARATORS,LISTBROWSER_VertSeparators,b);}
    void HorizSeparators(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_HORIZSEPARATORS,LISTBROWSER_HorizSeparators,b);}
    void Borderless(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_BORDERLESS,LISTBROWSER_Borderless,b);}
    void ColumnInfo(struct ColumnInfo* cInfo)
           {setTag(CITLISTBROWSER_COLUMNINFO,LISTBROWSER_ColumnInfo,ULONG(cInfo));}
    void ColumnTitles(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_COLUMNTITLES,LISTBROWSER_ColumnTitles,b);}
    void AutoFit(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_AUTOFIT,LISTBROWSER_AutoFit,b);}
    void VirtualWidth(WORD width)
           {setTag(CITLISTBROWSER_VIRTUALWIDTH,LISTBROWSER_VirtualWidth,width);}
    void Left(WORD left)
           {setTag(CITLISTBROWSER_LEFT,LISTBROWSER_Left,left);}
    void VerticalProp(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_VERTICALPROP,LISTBROWSER_VerticalProp,b);}
    void HorizontalProp(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_HORIZONTALPROP,LISTBROWSER_HorizontalProp,b);}
    void VPropTotal(WORD total)
           {setTag(CITLISTBROWSER_VPROPTOTAL,LISTBROWSER_VPropTotal,total);}
    void VPropTop(WORD top)
           {setTag(CITLISTBROWSER_VPROPTOP,LISTBROWSER_VPropTop,top);}
    void VPropVisible(WORD visible)
           {setTag(CITLISTBROWSER_VPROPVISIBLE,LISTBROWSER_VPropVisible,visible);}
    void HPropTotal(WORD total)
           {setTag(CITLISTBROWSER_HPROPTOTAL,LISTBROWSER_HPropTotal,total);}
    void HPropTop(WORD top)
           {setTag(CITLISTBROWSER_HPROPTOP,LISTBROWSER_HPropTop,top);}
    void HPropVisible(WORD visible)
           {setTag(CITLISTBROWSER_HPROPVISIBLE,LISTBROWSER_HPropVisible,visible);}
    void ViewPosition(ULONG pos)
           {setTag(CITLISTBROWSER_VIEWPOSITION,LISTBROWSER_Position,pos);}
    void ScrollRaster(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_SCROLLRASTER,LISTBROWSER_ScrollRaster,b);}
    void Hierarchical(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_HIERARCHICAL,LISTBROWSER_Hierarchical,b);}
    void ShowImage(struct Image* im)
           {setTag(CITLISTBROWSER_SHOWIMAGE,LISTBROWSER_ShowImage,ULONG(im));}
    void HideImage(struct Image* im)
           {setTag(CITLISTBROWSER_HIDEIMAGE,LISTBROWSER_HideImage,ULONG(im));}
    void LeafImage(struct Image* im)
           {setTag(CITLISTBROWSER_LEAFIMAGE,LISTBROWSER_LeafImage,ULONG(im));}
    void Editable(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_EDITABLE,LISTBROWSER_Editable,b);}
    void EditNode(LONG node)
           {setTag(CITLISTBROWSER_EDITNODE,LISTBROWSER_EditNode,node);}
    void EditColumn(WORD col)
           {setTag(CITLISTBROWSER_EDITCOLUMN,LISTBROWSER_EditColumn,col);}
    void EditTags(struct TagList* list)
           {setTag(CITLISTBROWSER_EDITTAGS,LISTBROWSER_EditTags,ULONG(list));}
    void CheckImage(struct Image* im)
           {setTag(CITLISTBROWSER_CHECKIMAGE,LISTBROWSER_CheckImage,ULONG(im));}
    void UncheckedImage(struct Image* im)
           {setTag(CITLISTBROWSER_UNCHECKEDIMAGE,LISTBROWSER_UncheckedImage,ULONG(im));}
    void MinNodeSize(LONG nSize)
           {setTag(CITLISTBROWSER_MINNODESIZE,LISTBROWSER_MinNodeSize,nSize);}
    void TitleClickable(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_TITLECLICKABLE,LISTBROWSER_TitleClickable,b);}
    void MinVisible(LONG mVisible)
           {setTag(CITLISTBROWSER_MINVISIBLE,LISTBROWSER_MinVisible,mVisible);}
    void PersistSelect(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_PERSISTSELECT,LISTBROWSER_PersistSelect,b);}
    void CursorSelect(LONG cSelect)
           {setTag(CITLISTBROWSER_CURSORSELECT,LISTBROWSER_CursorSelect,cSelect);}
    void FastRender(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_FASTRENDER,LISTBROWSER_FastRender,b);}
    void WrapText(BOOL b = TRUE)
           {setTag(CITLISTBROWSER_WRAPTEXT,LISTBROWSER_WrapText,b);}

    LONG  Top()
            {return getTag(LISTBROWSER_Top);}
    Node* SelectedNode()
            {return (Node*)getTag(LISTBROWSER_SelectedNode);}
    LONG  Selected()
            {return getTag(LISTBROWSER_Selected);}
    LONG  NumSelected()
            {return getTag(LISTBROWSER_NumSelected);}
    ULONG RelEvent()
            {return getTag(LISTBROWSER_RelEvent);}
    WORD  MouseX()
            {return getTag(LISTBROWSER_MouseX);}
    WORD  MouseY()
            {return getTag(LISTBROWSER_MouseY);}
    WORD  RelColumn()
            {return getTag(LISTBROWSER_RelColumn);}
    LONG  TotalNodes()
            {return getTag(LISTBROWSER_TotalNodes);}
    LONG  CursorSelect()
            {return getTag(LISTBROWSER_CursorSelect);}
    Node* CursorNode()
            {return (Node*)getTag(LISTBROWSER_CursorNode);}
    LONG  TotalVisibleNodes()
            {return getTag(LISTBROWSER_TotalVisibleNodes);}

  protected:
    virtual BOOL    Create(CITWindow* CITWd,CITContainer* parent);
    virtual Object* NewObjectA(TagItem* tags);

  private:
    void  setTag(int index,ULONG attr,ULONG val);
    ULONG getTag(ULONG attr);

    TagItem* listBrowserTag;
    CITList  labelList;
};

enum
{
   LISTBROWSERCLASS_FLAGBITUSED = GADGETCLASS_FLAGBITUSED
};

#endif
