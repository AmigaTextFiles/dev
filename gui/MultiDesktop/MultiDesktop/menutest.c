#include <graphics/clip.h>
#include <graphics/layers.h>
#include <intuition/screens.h>
#include <graphics/rastport.h>

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct LayersBase    *LayersBase;

struct NewWindow DummyWin=
{
 50,300,320,61,0,0,0L,BORDERLESS|NOCAREREFRESH,0L,0L,0L,0L,0L,
 640,256,640,256,WBENCHSCREEN
};

struct NewScreen DummyScr=
{
 0,380,640,40,3,0,1,HIRES|LACE,CUSTOMSCREEN,0,"Title",0,0
};

struct NewWindow nw=
{
 75,75,500,80,
 0,1,
 CLOSEWINDOW|MENUPICK|MENUVERIFY,
 WINDOWDEPTH|WINDOWCLOSE|WINDOWDRAG|ACTIVATE|GIMMEZEROZERO,
 0L,0L,"MenüTest!",0L,0L,
 100,20,640,256,
 WBENCHSCREEN
};

struct Screen *ss;

void HelpOn();
void HelpOff();
void Help();

struct IntuiText t1={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 1",0L};
struct IntuiText t2={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 2",0L};
struct IntuiText t3={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 3",0L};
struct IntuiText t4={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 4",0L};
struct IntuiText t5={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 5",0L};
struct IntuiText t6={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 6",0L};
struct IntuiText t7={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 7",0L};
struct IntuiText t8={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 8",0L};
struct IntuiText t9={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 9",0L};
struct IntuiText t0={AUTOFRONTPEN,AUTOBACKPEN,AUTODRAWMODE,AUTOLEFTEDGE,0,0L,"Menu-Item Nummer 10",0L};

struct MenuItem i0={0L,  5, 135, 200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t0,0L,0,NULL,NULL};
struct MenuItem i9={&i0, 5, 120, 200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t9,0L,0,NULL,NULL};
struct MenuItem i8={&i9, 5, 105, 200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t8,0L,0,NULL,NULL};
struct MenuItem i7={&i8, 5, 90,  200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t7,0L,0,NULL,NULL};
struct MenuItem i6={&i7, 5, 75,  200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t6,0L,0,NULL,NULL};
struct MenuItem i5={&i6, 5, 60,  200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t5,0L,0,NULL,NULL};
struct MenuItem i4={&i5, 5, 45,  200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t4,0L,0,NULL,NULL};
struct MenuItem i3={&i4, 5, 30,  200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t3,0L,0,NULL,NULL};
struct MenuItem i2={&i3, 5, 15,  200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t2,0L,0,NULL,NULL};
struct MenuItem i1={&i2, 5, 0,   200, 15, ITEMENABLED|ITEMTEXT|HIGHCOMP,0L,&t1,0L,0,NULL,NULL};

struct Menu m4={0L,   380, 0, 80, 10,  MENUENABLED, "Test #4", &i1};
struct Menu m3={&m4,  270, 0, 80, 10,  MENUENABLED, "Test #3", &i1};
struct Menu m2={&m3,  160, 0, 80, 10,  MENUENABLED, "Test #2", &i1};
struct Menu m1={&m2,  10,  0, 80, 10,  MENUENABLED, "Test #1", &i1};

struct Window   *win;
struct RastPort *rp,*lrp;
struct Layer    *Layer;
struct Window   *Dummy;
struct Layer_Info *li;


main()
{
 BOOL  ende;
 WORD  x,y,b;
 ULONG Class;
 UWORD Code;
 UWORD Qualifier;
 struct IntuiMessage *msg;

 IntuitionBase=OpenLibrary("intuition.library",0L);
 GfxBase=OpenLibrary("graphics.library",0L);
 LayersBase=OpenLibrary("layers.library",0L);
 if((IntuitionBase==NULL)||(GfxBase==NULL)||(LayersBase==NULL)) exit(0);

 win=OpenWindow(&nw);
 if(win!=NULL)
  {
   SetMenuStrip(win,&m1);
   rp=win->RPort;
   SetAPen(rp,7);
   RectFill(rp,20,20,450,60);

   ende=FALSE;
   do
    {
     b=0;
     WaitPort(win->UserPort);
     msg=GetMsg(win->UserPort);
     Class=msg->Class;
     Code=msg->Code;
     Qualifier=msg->Qualifier;
     x=msg->MouseX;
     y=msg->MouseY;
     if(Class==MENUVERIFY)
      {
       ModifyIDCMP(win,INTUITICKS|CLOSEWINDOW|MENUPICK|MENUVERIFY);
       HelpOn();
      }
     ReplyMsg(msg);
     switch(Class)
      {
       case CLOSEWINDOW:
         ende=TRUE;
        break;
       case MENUPICK:
         ModifyIDCMP(win,CLOSEWINDOW|MENUPICK|MENUVERIFY);
         HelpOff();
         x=MENUNUM(Code);
         y=ITEMNUM(Code);
        break;
       case MOUSEMOVE:
        break;
       case INTUITICKS:
         Help(&m1);
        break;
      }
    }
   while(ende==FALSE);

   ClearMenuStrip(win);
   CloseWindow(win);
  }
 else
   puts("FEHLER: Kann Fenster nicht öffnen!");

 CloseLibrary(GfxBase);
 CloseLibrary(IntuitionBase);
 CloseLibrary(LayersBase);
 exit(0);
}

void Help(m)
 struct Menu *m;
{
 UBYTE                 buffer[40];
 UWORD                 i,j,mn,in;
 register struct Menu     *menu;
 struct MenuItem *item;

 if(Layer==NULL) return;
 
 menu=m; i=0; mn=1234; in=1234;
 while(menu!=NULL)
  {
   if(menu->Flags & MIDRAWN)
    {
     mn=i;
     break;
    }
   else
    {
     i++;
     menu=menu->NextMenu;
    }
  }

 if(mn!=1234)
  {
   i=0;
   item=menu->FirstItem;
   while(item!=NULL)
    {
     if(item->Flags & HIGHITEM)  /* SUBs: ISDRAWN */
      {
       in=i;
       break;
      }
     else
      {
       item=item->NextItem;
       i++;
      }
    }
  }
 else
  in=1000;

 sprintf(&buffer,"M=%4ld  I=%4ld",mn,in);
 Move(lrp,20,20);
 Text(lrp,&buffer,strlen(&buffer));
}

void HelpOff()
{
 struct Screen     *scr;
 int                i;
 BOOL               bool;
 scr=win->WScreen;

 Dummy=OpenWindow(&DummyWin);

 if(Layer)
  {
   DeleteLayer(0L,Layer);
   Layer=NULL;
  }
 if(li)
  {
   DisposeLayerInfo(li);
   li=NULL;
  }


 if(Dummy)
  {
   CloseWindow(Dummy);
   Dummy=NULL;
  }

 if(ss) CloseScreen(ss);
}

void HelpOn()
{
 struct Layer_Info *li;
 struct Screen     *scr;
 int                i,j;

 ss=OpenScreen(&DummyScr);
 if(ss==NULL) puts("ERROR");

 scr=win->WScreen;
 li=NewLayerInfo();
 if(li==NULL) return;

 Layer=CreateUpfrontLayer(li,&scr->BitMap,50,300,370,360,LAYERSIMPLE,NULL);
 if(Layer)
  {
   lrp=Layer->rp;

   SetAPen(lrp,3);
   Move(lrp,1,1);
   Draw(lrp,318,1);
   Draw(lrp,318,58);
   Draw(lrp,1,58);
   Draw(lrp,1,1);
   SetAPen(lrp,7);

   Help();
  }

}

