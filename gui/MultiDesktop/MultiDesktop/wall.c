/* Wallpaper-Verwaltung */
#include "multiwindows.h"
#include "iff-ilbm.h"

extern struct MultiWindowsBase *MultiWindowsBase;
extern struct ExecBase         *SysBase;

BOOL LoadBODY();
BOOL SetWindowWallpaper();
void ShowWallpaperRastPort();

/* ---- Wallpaper im Fenster darstellen */
void ShowWallpaperWindow(win,wp)
 struct Window    *win;
 struct Wallpaper *wp;
{
 int innerLeftEdge,innerTopEdge,
     innerWidth,innerHeight;

 if(wp==NULL) return;

 innerTopEdge=win->BorderTop;
 innerLeftEdge=win->BorderLeft;
 innerWidth=win->Width-win->BorderLeft-win->BorderRight;
 innerHeight=win->Height-win->BorderTop-win->BorderBottom;
 ShowWallpaperRastPort(win->RPort,wp,innerLeftEdge,innerTopEdge,innerWidth,innerHeight);
}

/* ---- Wallpaper im RastPort darstellen */
void ShowWallpaperRastPort(rp,wp,innerLeftEdge,innerTopEdge,innerWidth,innerHeight)
 struct RastPort  *rp;
 struct Wallpaper *wp;
 int               innerLeftEdge,innerTopEdge,
                   innerWidth,innerHeight;
{
 int               x,y;
 int               x1,y1,x2,y2,w,h;

 if(wp==NULL) return;
 x2=innerWidth+innerLeftEdge;
 y2=innerHeight+innerTopEdge;
 for(x=0;x<innerWidth;x+=wp->Width)
  {
   for(y=0;y<innerHeight;y+=wp->Height)
    {
     x1=x+innerLeftEdge;
     y1=y+innerTopEdge;
     w=wp->Width;
     if(x1+w>x2) w=x2-x1;
     h=wp->Height;
     if(y1+h>y2) h=y2-y1;
     BltBitMapRastPort(&wp->BitMap,0,0,rp,x1,y1,w,h,0xc0);
    }
  }
}

/* ---- Wallpaper entfernen */
void UnLoadWallpaper(wp)
 struct Wallpaper *wp;
{
 int i;

 if(wp)
  {
   i=0;
   Forbid();
   wp->UserCount--;
   if(wp->UserCount==0) {
     if(wp->Node.ln_Succ!=NULL)
       { Remove(wp); MultiWindowsBase->WallpaperCount--; i=1; }}
   Permit();

   if(i==1)
    {
     for(i=0;i<8;i++)
      {
       if(wp->BitMap.Planes[i])
         FreeRaster(wp->BitMap.Planes[i],wp->Width,wp->Height);
      }
     FreeVec(wp);
    }
  }
}

/* ---- Wallpaper laden */
struct Wallpaper *LoadWallpaper(name)
 UBYTE *name;
{
 struct Wallpaper  *wp;
 struct FileLock   *lock,*syslock;
 struct FileHandle *fh;
 struct BMHD        bmhd;
 BOOL               HasBMHD,HasBODY,okay;
 UBYTE              id[60];
 ULONG              size,res;
 int                i;

 for(i=0;i<strlen(name);i++)
   id[i]=tolower(name[i]);
 id[i]=0x00;
 Forbid();
 wp=FindName(&MultiWindowsBase->WallpaperList,&id);
 if(wp) wp->UserCount++;
 Permit();
 if(wp) return(wp);

 lock=Lock(MultiWindowsBase->WallpaperDir,ACCESS_READ);
 if(lock) syslock=CurrentDir(lock); else syslock=NULL;
 fh=Open(name,MODE_OLDFILE);
 if(syslock) CurrentDir(syslock);
 if(lock) UnLock(lock);
 if(fh==NULL) return(NULL);

 wp=AllocVec(sizeof(struct Wallpaper)+strlen(name)+2,MEMF_CLEAR|MEMF_PUBLIC);
 if(wp!=NULL)
  {
   wp->UserCount=1;
   strcpy(&wp->Name,&id);
   wp->Node.ln_Name=&wp->Name;

   Read(fh,&id,4L);
   if(!(strncmp(&id,"FORM",4L)))
    {
     Read(fh,&size,4L);
     Read(fh,&id,4L);
     if(!(strncmp(&id,"ILBM",4L)))
      {
       HasBMHD=HasBODY=FALSE;
       res=Read(fh,&id,4L);
       while((res==4)&&(HasBODY==FALSE))
        {
         Read(fh,&size,4L);
         if(!(strncmp(&id,"BMHD",4L)))
          {
           Read(fh,&bmhd,sizeof(struct BMHD));
           Seek(fh,-sizeof(struct BMHD),OFFSET_CURRENT);
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
           HasBMHD=TRUE;
          }
         else if(!(strncmp(&id,"BODY",4L)))
           HasBODY=TRUE;
         else
          {
           if((size % 2)==1) size++;
           Seek(fh,size,OFFSET_CURRENT);
          }

         res=Read(fh,&id,4L);
        }
       Seek(fh,-4,OFFSET_CURRENT);

       if((HasBODY)&&(HasBMHD))
        {
         if(bmhd.Compression<=1)
          {
           if(bmhd.Depth>8) bmhd.Depth=8;
           wp->Width=bmhd.Width;
           wp->Height=bmhd.Height;
           okay=TRUE;
           for(i=0;i<bmhd.Depth;i++)
            {
             wp->BitMap.Planes[i]=AllocRaster(wp->Width,wp->Height);
             if(wp->BitMap.Planes[i]==NULL) okay=FALSE;
            }
           if(okay)
            {
             InitBitMap(&wp->BitMap,bmhd.Depth,wp->Width,wp->Height);
             okay=LoadBODY(fh,wp,size,bmhd.Compression);
             if(okay==FALSE)
              {
               ErrorL(1023,"LoadWallpaper():\nUnable to allocate temporary buffer!");
               UnLoadWallpaper(wp);
               wp=NULL;
              }
            }
           else
            {
             ErrorL(1028,"LoadWallpaper():\nNot enough chip memory!");
             UnLoadWallpaper(wp);
             wp=NULL;
            }
          }
         else
          {
           ErrorL(1024,"LoadWallpaper():\nUnknown ILBM compression!");
           UnLoadWallpaper(wp);
           wp=NULL;
          }
        }
       else
        {
         ErrorL(1025,"LoadWallpaper():\nInvalid ILBM file!");
         UnLoadWallpaper(wp);
         wp=NULL;
        }
      }
     else
      {
       ErrorL(1026,"LoadWallpaper():\nNo IFF-ILBM file!");
       UnLoadWallpaper(wp);
       wp=NULL;
      }
    }
   else
    {
     ErrorL(1027,"LoadWallpaper():\nNo IFF file format!");
     UnLoadWallpaper(wp);
     wp=NULL;
    }
  }
 else
  {
   ErrorL(0,0);
   UnLoadWallpaper(wp);
   wp=NULL;
  }

 Close(fh);
 if(wp)
  {
   Forbid();
   AddTail(&MultiWindowsBase->WallpaperList,wp);
   MultiWindowsBase->WallpaperCount++;
   Permit();
  }
 return(wp);
}

void CopyByte(a,b)
 UBYTE *a,*b;
{ b[0]=a[0]; }

BOOL LoadBODY(fh,wp,size,compression)
 struct FileHandle *fh;
 struct Wallpaper  *wp;
 ULONG              size;
 UBYTE              compression;
{
 ULONG           bb;
 UBYTE          *dest;
 UBYTE           ch1,ch2;
 REGISTER ULONG  body;
 REGISTER UWORD  y,b,i,byteCount,bpr;

 bb=body=AllocMem(size,MEMF_ANY);
 if(body==NULL) return(FALSE);
 Read(fh,body,size);

 bpr=wp->BitMap.BytesPerRow;
 for(y=0;y<wp->Height;y++)
  {
   for(b=0;b<wp->BitMap.Depth;b++)
    {
     byteCount=0;
     dest=(UBYTE *) ( (ULONG)wp->BitMap.Planes[b]+((ULONG)y*(ULONG)bpr) );

     if(compression==0)
      {
       CopyMem(body,dest,bpr); body+=bpr;
      }
     else
      {
       while(byteCount<bpr)
        {
         CopyByte(body,&ch1); body++;
         if(ch1<128)
          {
           CopyMem(body,(UBYTE *)dest+(UBYTE *)byteCount,ch1+1);
           body+=ch1+1;
           byteCount+=ch1+1;
          }
         if(ch1>128)
          {
           CopyByte(body,&ch2); body++;
           for(i=byteCount;i<(byteCount+(257-ch1));i++)
             { *(dest+(UBYTE *)i) = ch2; }
           byteCount+=257-ch1;
          }
        }
      }
    }
  }
 FreeMem(bb,size);
 return(TRUE);
}

/* ---- Wallpaper benutzen */
void UseWallpaper(we,wp)
 struct WindowEntry *we;
 struct Wallpaper   *wp;
{
 struct Node     *node;
 struct MWGadget *gad;

 we->Wallpaper=wp;
 if(we->Iconify) return;

 if(wp)
   ShowWallpaperWindow(we->Window,wp);
 else
  {
   BackupRP(we);
   SetAPen(we->RastPort,0);
   RectFill(we->RastPort,we->InnerLeftEdge,we->InnerTopEdge,
            we->InnerLeftEdge+we->InnerWidth,we->InnerTopEdge+we->InnerHeight);
   RestoreRP(we);
  }

  BackupRP(we);
  SetAPen(we->RastPort,0);
  for(node=we->GadgetList.lh_Head;node!=&we->GadgetList.lh_Tail;node=node->ln_Succ)
   {
    gad=node;
    RectFill(we->RastPort,
             gad->NewGadget.ng_LeftEdge,
             gad->NewGadget.ng_TopEdge,
             gad->NewGadget.ng_LeftEdge+gad->NewGadget.ng_Width-1,
             gad->NewGadget.ng_TopEdge+gad->NewGadget.ng_Height-1);
   }
  RestoreRP(we);

 if(we->Window->FirstGadget)
   RefreshGList(we->Window->FirstGadget,we->Window,NULL,-1L);
 RefreshSGadgets(we);
 GTRefreshWindow(we->Window,NULL);
}

/* ---- Wallpaper laden und im aktuellen Fenster darstellen */
BOOL Wallpaper(name)
 UBYTE *name;
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return(FALSE);
 return(SetWindowWallpaper(we->WindowID,name));
}

/* ---- Wallpaper laden und in einem Fenster darstellen */
BOOL SetWindowWallpaper(windowID,name)
 UBYTE  windowID;
 UBYTE *name;
{
 struct WindowEntry *we;
 struct Wallpaper   *wp;

 we=FindWindowEntry(windowID);
 if(we==NULL) return(FALSE);

 wp=LoadWallpaper(name);
 if(wp)
  {
   UseWallpaper(we,wp);
   if(we->SysWPAddress) UnLoadWallpaper(we->SysWPAddress);
   we->SysWPAddress=wp;
   return(TRUE);
  }
 return(FALSE);
}

/* ---- Wallpaper laden und in einem Screen-Backdrop darstellen */
BOOL SetScreenWallpaper(screenID,name)
 UBYTE  screenID;
 UBYTE *name;
{
 struct ScreenEntry *se;
 struct Wallpaper   *wp;

 se=FindScreenEntry(screenID);
 if(se==NULL) return(FALSE);

 wp=LoadWallpaper(name);
 if(wp)
  {
   if(se->BgWindow==NULL) InitBackdrop(se);
   if(se->BgWindow!=NULL) ShowWallpaperWindow(se->BgWindow,wp);
   if(se->BgWallpaper) UnLoadWallpaper(se->BgWallpaper);
   se->BgWallpaper=wp;
   return(TRUE);
  }
 return(FALSE);
}

/* ---- Hintergrund wiederherstellen */
void RestoreBackground(we,x,y,w,h)
 struct WindowEntry *we;
 UWORD               x,y,w,h;
{
 struct Wallpaper *wp;
 struct RastPort  *rp;
 int               xa,ya,xs,ys,xp,yp;
 int               x1,y1,x2,y2;
 int               x3,y3,x4,y4;
 UBYTE             pen;

 BackupRP(we);
 rp=we->RastPort;
 wp=we->Wallpaper;

 if(wp==NULL)
  {
   SetDrMd(rp,JAM1);
   SetAPen(rp,0);
   x1=x;
   y1=y;
   x2=x+w;
   y2=y+h;
   if(x1>we->Window->Width) x1=we->Window->Width;
   if(x2>we->Window->Width) x2=we->Window->Width;
   if(y1>we->Window->Height) y1=we->Window->Height;
   if(y2>we->Window->Height) y2=we->Window->Height;
   RectFill(rp,x1,y1,x2,y2);
  }
 else
  {
   xs=((x-we->InnerLeftEdge)/wp->Width)*wp->Width+we->InnerLeftEdge;
   ys=((y-we->InnerTopEdge)/wp->Height)*wp->Height+we->InnerTopEdge;
   xp=((((x-we->InnerLeftEdge)+w)/wp->Width)+1)*wp->Width+we->InnerLeftEdge;
   yp=((((y-we->InnerTopEdge)+h)/wp->Height)+1)*wp->Height+we->InnerTopEdge;

   for(xa=xs;xa<xp;xa+=wp->Width)
    {
     for(ya=ys;ya<yp;ya+=wp->Height)
      {
       x1=xa; y1=ya; x2=x1+wp->Width; y2=y1+wp->Height;
       /* ------------------------------------------ */

       if(x>x1)   x3=x;   else x3=x1;
       if(y>y1)   y3=y;   else y3=y1;
       if(x+w<x2) x4=x+w; else x4=x2;
       if(y+h<y2) y4=y+h; else y4=y2;

       if(!((x4-x3)<=0)) {
         if(!((y4-y3)<=0)) {
           BltBitMapRastPort(&wp->BitMap,
                (x3-we->InnerLeftEdge) % wp->Width,
                (y3-we->InnerTopEdge) % wp->Height,
                rp,x3,y3,x4-x3,y4-y3,0xc0);
         }}

       /* ------------------------------------------ */
      }
    }
  }
 RestoreRP(we);
}

