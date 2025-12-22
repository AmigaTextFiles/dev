#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITListBrowser.h>
#include <citra/CITLabel.h>

#include <proto/listbrowser.h>
#include <clib/alib_protos.h>
#include <stdlib.h>

char* col1[] =
{
  "This is a", "test of the", "ListBrowser", "gadget class.",
  "This is like", "a souped-up", "listview", "gadget.  It", "has many",
  "cool new", "features", "though like", "multiple", "columns,",
  "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
  "and much much", "more!",
  "This is a", "test of the", "ListBrowser", "gadget class.",
  "This is like", "a souped-up", "listview", "gadget.  It", "has many",
  "cool new", "features", "though like", "multiple", "columns,",
  "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
  "and much much", "more!",
  "This is a", "test of the", "ListBrowser", "gadget class.",
  "This is like", "a souped-up", "listview", "gadget.  It", "has many",
  "cool new", "features", "though like", "multiple", "columns,",
  "horizontal", "scrolling,", "images in", "nodes,", "columns titles",
  "and much much", "more!", NULL
};

LONG col2[] =
{
  1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
  27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
  39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
  51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62,
  63
};

struct ColumnInfo ci[] =
{
  { 80, "Col 1", 0 },
  { 60, "Col 2", 0 },
  { 60, "Col 3", 0 },
  { -1, (STRPTR)~0, -1 }
};

struct ColumnInfo fancy_ci[] =
{
  { 100, NULL, 0 },
  { -1, (STRPTR)~0, -1 }
};

//
// Some fonts for our fancy list.
//
struct TextAttr helvetica24b = { (STRPTR)"helvetica.font", 24, FSF_BOLD, FPF_DISKFONT };
struct TextAttr times18i = { (STRPTR)"times.font", 18, FSF_ITALIC, FPF_DISKFONT };
struct TextAttr times18 = { (STRPTR)"times.font", 18, 0, FPF_DISKFONT };

List labelList;
List imageList;

CITApp Application;

CITWorkbench   DemoScreen;
CITWindow      DemoWindow;
CITVGroup      winGroup;
CITListBrowser lb;
CITButton      quitButton;
CITLabel       im1,im2;

//
// Function prototypes.
///
struct ClassLibrary * OpenClass(STRPTR, ULONG);
void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventType);
BOOL makeLabelList(struct List*,char**,LONG*);
BOOL makeImageList(struct List*, Image*,Image*);
VOID freeList(struct List*);

int main(void)
{
  BOOL Error=FALSE;

  // Create the images
  im1.Text("C");
    im1.FGPen(1);
    im1.BGPen(2);
    im1.Font("helvetica.font", 24);
    im1.SoftStyle(FSF_BOLD);
  im1.Text("lass ");
    im1.FGPen(1);
    im1.BGPen(2);
    im1.Font("times.font", 18);
    im1.SoftStyle(FSF_ITALIC);
  im1.Text("A");
    im1.FGPen(1);
    im1.BGPen(2);
    im1.Font("helvetica.font", 24);
    im1.SoftStyle(FSF_BOLD);
  im1.Text("ct");
    im1.FGPen(1);
    im1.BGPen(2);
    im1.Font("times.font", 18);
    im1.SoftStyle(FSF_ITALIC);

  im2.Text("by Phantom Development");
    im2.FGPen(2);
    im2.BGPen(0);
    im2.Font("times.font", 18);

  makeLabelList(&labelList,col1,col2);
  makeImageList(&imageList,im1.objectPtr(),im2.objectPtr());

  DemoScreen.InsObject(DemoWindow,Error);
    DemoWindow.Position(WPOS_CENTERSCREEN);
    DemoWindow.CloseGadget();
    DemoWindow.DragBar();
    DemoWindow.SizeGadget();
    DemoWindow.DepthGadget();
    DemoWindow.IconifyGadget();
    DemoWindow.Activate();
    DemoWindow.Caption("<- Click to continue");
    DemoWindow.CloseEventHandler(CloseEvent);
    DemoWindow.InsObject(winGroup,Error);
      winGroup.SpaceOuter();
      winGroup.InsObject(lb,Error);
        lb.MinWidth(275);
        lb.MinHeight(150);
        lb.Labels(&labelList);
        lb.ColumnInfo(ci);
        lb.ColumnTitles();
        lb.Editable();
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.MaxHeight(20);
        quitButton.EventHandler(QuitEvent);

  Application.InsObject(DemoScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  Application.RemObject(DemoScreen);

  freeList(&imageList);
  freeList(&labelList);

  return 0;
}

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}


int repeatCount = 0;

void CloseEvent()
{
  switch( ++repeatCount )
  {
    case 1:
      DemoWindow.Caption("Make Visible 10");
      lb.MakeVisible(10);
      lb.EditNode(8);
      lb.EditColumn(1);
      break;
    case 2:
      DemoWindow.Caption("Show Selected Auto-Fit");
      lb.ShowSelected();
      lb.AutoFit();
      lb.HorizontalProp();
      break;
    case 3:
      DemoWindow.Caption("Multi-select, Virtual Width of 500");
      lb.MultiSelect();
      lb.VirtualWidth(500);
      lb.AutoFit(FALSE);
      break;
    case 4:
      DemoWindow.Caption("Detached list");
      lb.MultiSelect(FALSE);
      lb.Labels((List*)(~0L));
      break;
    case 5:
      DemoWindow.Caption("No separators, no title, 1 column.");
      lb.Labels(&labelList);
      lb.ColumnInfo(fancy_ci);
      lb.VertSeparators(FALSE);
      lb.ColumnTitles(FALSE);
      lb.AutoFit(TRUE);
      break;
    case 6:
      DemoWindow.Caption("Fancy");
      lb.Labels(&imageList);
      lb.ColumnInfo(fancy_ci);
      lb.AutoFit(TRUE);
      break;
    case 7:
      DemoWindow.Caption("Read-only");
      lb.Labels(&labelList);
      lb.ColumnInfo(ci);
      lb.AutoFit(TRUE);
      lb.Selected(-1);
      break;
    case 8:
      DemoWindow.Caption("Disabled");
      lb.Disabled();
      lb.ReadOnly();
      break;
    case 9:
      DemoWindow.Caption("No scrollbars, borderless");
      lb.Disabled(FALSE);
      lb.HorizontalProp(FALSE);
      lb.VerticalProp(FALSE);
      lb.Borderless();
      break;
    default:
      Application.Stop();
    break;
  }
}

// Function to make a List of ListBrowserNodes from a couple of arrays.
// Just to demonstrate things, we make make three columns, 2 with text
// (the same text) and the third with numbers.
//
BOOL makeLabelList(struct List *list, char** labels1, LONG* labels2)
{
  struct Node *node;
  WORD i = 0;

  NewList(list);

  while (*labels1)
  {
    if (node = AllocListBrowserNode(3,
            LBNA_Column, 0,
              LBNCA_CopyText, TRUE,
              LBNCA_Text, *labels1,
              LBNCA_MaxChars, 40,
              LBNCA_Editable, TRUE,
            LBNA_Column, 1,
              LBNCA_CopyText, TRUE,
              LBNCA_Text, *labels1,
              LBNCA_MaxChars, 40,
              LBNCA_Editable, TRUE,
            LBNA_Column, 2,
              LBNCA_Integer, &labels2[i],
              LBNCA_Justification, LCJ_RIGHT,
            TAG_DONE))
    {
      AddTail(list, node);
    }
    else
      break;

    labels1++;
    i++;
  }
  return(TRUE);
}

// Function to make a List of ListBrowserNodes from tw images.
//
BOOL makeImageList(struct List* list, Image* im1,Image* im2)
{
  if( im1 && im2 )
  {
    struct Node *node;
    WORD i = 0;

    NewList(list);

    if (node = AllocListBrowserNode(1,
            LBNA_Column, 0,
              LBNCA_Image, im1,
              LBNCA_Justification, LCJ_CENTRE,
            TAG_DONE))
    {
      AddTail(list, node);
    }
    else
      return FALSE;

    if (node = AllocListBrowserNode(1,
            LBNA_Column, 0,
              LBNCA_Image, im2,
              LBNCA_Justification, LCJ_CENTRE,
            TAG_DONE))
    {
      AddTail(list, node);
    }
    else
      return FALSE;

    return(TRUE);
  }
  return(FALSE);
}

//
// Function to free an Exec List of ListBrowser nodes.
//
VOID freeList(struct List *list)
{
  struct Node *node, *nextnode;

  node = list->lh_Head;
  while (nextnode = node->ln_Succ)
  {
    FreeListBrowserNode(node);
    node = nextnode;
  }
  NewList(list);
}

