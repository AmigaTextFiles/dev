APTR UtilityBase;
APTR IntuitionBase;
APTR LayersBase;
APTR MultiDesktopBase;
APTR GfxBase;

extern ULONG HookProc();

struct NewWindow nw=
{ 75,75,450,100,0,1,CLOSEWINDOW,WINDOWCLOSE|WINDOWDEPTH|WINDOWDRAG|WINDOWSIZING|ACTIVATE,0L,0L,"BackFill-Hook",0L,0L,200,50,640,400,WBENCHSCREEN};

main()
{
 struct Hook    h;
 struct Window *win;
 struct Layer  *layer;

 UtilityBase=OpenLibrary("utility.library",0L);
 IntuitionBase=OpenLibrary("intuition.library",0L);
 LayersBase=OpenLibrary("layers.library",0L);
 GfxBase=OpenLibrary("graphics.library",0L);
 MultiDesktopBase=OpenLibrary("multidesktop.library",0L);
 if(UtilityBase==NULL) exit(0);
 if(IntuitionBase==NULL) exit(0);
 if(LayersBase==NULL) exit(0);
 if(MultiDesktopBase==NULL) exit(0);
 if(GfxBase==NULL) exit(0);
 InitHook(&h,HookProc,NULL);

 win=OpenWindow(&nw);
 if(win!=NULL)
  {
   layer=win->WLayer;
   InstallLayerHook(win->WLayer,&h);

   WaitPort(win->UserPort);
   CloseWindow(win);
  }
 CloseLibrary(MultiDesktopBase);
 puts("Ende.");
}

