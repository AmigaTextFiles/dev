struct WindowNode
{
  struct WindowNode *ln_Succ;
  struct WindowNode *ln_Pred;
  struct Window *Win;
  struct Gadget *WinGList;
  struct Gadget *WinGadgets[10];
  void * WinVisualInfo;
  struct DrawInfo *WinDrawInfo;
};