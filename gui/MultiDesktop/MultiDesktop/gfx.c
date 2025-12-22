/* Grafik-Funktionen */
#include "multiwindows.h"

extern struct ExecBase         *SysBase;
extern struct MultiWindowsBase *MultiWindowsBase;

extern UWORD INewWidth(),INewHeight();

/* ---- TmpRas erstellen */
BOOL CreateTmpRas(we)
 struct WindowEntry *we;
{
 UBYTE *plane;
 ULONG  w,h,v;

 if(we->TmpRas!=NULL) { we->TmpRasCount++; return(TRUE); }
 w=we->Screen->Width;
 h=we->Screen->Height;
 v=w/8*h;

 plane=AllocRaster(w,h);
 if(plane==NULL)
  {
   ErrorL(1110,"CreateTmpRas(): Not enough chip memory for raster!");
   SetError(MERR_NoMemory);
   return(FALSE);
  }
 BltClear(plane,v,0);

 we->TmpRas=InitTmpRas(&we->TmpRasBuffer,plane,v);
 we->TmpRasCount=1;
 if(!we->Iconify) we->RastPort->TmpRas=we->TmpRas;

 return(TRUE);
}

/* ---- TmpRas entfernen */
void DeleteTmpRas(we)
 struct WindowEntry *we;
{
 we->TmpRasCount--;
 if(we->TmpRasCount==0)
  {
   FreeRaster(we->TmpRas->RasPtr,we->Screen->Width,we->Screen->Height);
   we->TmpRas=NULL;
   if(!we->Iconify) we->RastPort->TmpRas=NULL;
  }
}

/* ---- AreaInfo erstellen */
BOOL CreateAreaInfo(we,count)
 struct WindowEntry *we;
 ULONG               count;
{
 UBYTE *table;

 if(we->AreaInfo!=NULL) return(TRUE);

 table=ALLOC2(count*5);
 if(table==NULL)
  {
   ErrorL(1111,"CreateAreaInfo(): Not enough memory for buffer!");
   SetError(MERR_NoMemory);
   return(FALSE);
  }

 InitArea(&we->AreaInfoBuffer,table,count);
 we->AreaInfo=&we->AreaInfoBuffer;
 we->AreaInfoTable=table;
 if(!we->Iconify) we->RastPort->AreaInfo=we->AreaInfo;

 return(TRUE);
}

/* ---- AreaInfo entfernen */
void DeleteAreaInfo(we)
 struct WindowEntry *we;
{
 if(we->AreaInfo!=NULL)
  {
   if(!we->Iconify) we->RastPort->AreaInfo=NULL;
   we->AreaInfo=NULL;
   FREE2(we->AreaInfoTable);
   we->AreaInfoTable=NULL;
  }
}

/* ---- Aktuellen RastPort ermitteln */
struct RastPort *GetRP()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return(NULL);
 return(we->RastPort);
}

/* ---- Zeichenstifte */
void SetFgPen(pen)
 UBYTE pen;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) SetAPen(rp,pen);
}

/* ---- Zeichenstifte */
void SetOlPen(pen)
 UBYTE pen;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) SetOPen(rp,pen);
}

/* ---- Zeichenstifte */
void SetBgPen(pen)
 UBYTE pen;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) SetBPen(rp,pen);
}

/* ---- Zeichenstifte */
void SetPens(ap,bp)
 UBYTE ap,bp;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   SetAPen(rp,ap);
   SetBPen(rp,bp);
  }
}

/* ---- Zeichenstifte */
void SetFgDrawInfoPen(c)
 UBYTE c;
{
 struct WindowEntry *we;
 struct RastPort    *rp;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp) SetAPen(rp,we->DrawInfo->dri_Pens[c]);
}

/* ---- Zeichenstifte */
void SetBgDrawInfoPen(c)
 UBYTE c;
{
 struct WindowEntry *we;
 struct RastPort    *rp;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp) SetBPen(rp,we->DrawInfo->dri_Pens[c]);
}

/* ---- Zeichenstifte */
void SetOlDrawInfoPen(c)
 UBYTE c;
{
 struct WindowEntry *we;
 struct RastPort    *rp;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp) SetOPen(rp,we->DrawInfo->dri_Pens[c]);
}

/* ---- Zeichenstifte */
UBYTE GetFgPen()
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) return(rp->FgPen);
 return(0);
}

/* ---- Zeichenstifte */
UBYTE GetBgPen()
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) return(rp->BgPen);
 return(0);
}

/* ---- Zeichenstifte */
UBYTE GetOlPen()
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) return(rp->AOlPen);
 return(0);
}

/* ---- Zeichenmodus */
void SetDrawMode(mode)
 UWORD mode;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) SetDrMd(rp,mode);
}

/* ---- Pattern */
void SetLinePattern(pattern)
 UWORD pattern;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) SetDrPt(rp,pattern);
}

/* ---- Pattern */
void SetMonoPattern(pattern,lines)
 UWORD lines;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
   SetAfPt(rp,pattern,lines);
}

/* ---- Pattern */
void SetColorPattern(pattern,lines)
 UWORD lines;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
   SetAfPt(rp,pattern,-lines);
}

/* ---- Pattern */
void SetWriteMask(mask)
 UWORD mask;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) SetWrMsk(rp,mask);
}

/* ---- Zeichenmodus */
UWORD GetDrawMode()
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) return(rp->DrawMode);
 return(0);
}

/* ---- Fontstil */
void SetStyle(style)
 UBYTE style;
{
 UWORD               gfxStyles;
 struct RastPort    *rp;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp)
  {
   gfxStyles=0;
   if(style & ST_BOLD) gfxStyles=FSF_BOLD;
   if(style & ST_ITALIC) gfxStyles=FSF_ITALIC;
   if(style & ST_UNDERLINED) gfxStyles=FSF_UNDERLINED;
   we->GfxStyle=style;
   SetSoftStyle(rp,gfxStyles,AskSoftStyle(rp));
  }
}

/* ---- Fontstil */
BOOL SetWindowFont(name,height)
 UBYTE *name;
 UWORD  height;
{
 struct RastPort    *rp;
 struct WindowEntry *we;
 struct TextFont    *font;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp)
  {
   font=CacheFont(name,height);
   if(font)
    {
     if(we->WindowFont)
      {
       Forbid();
       we->WindowFont->tf_Accessors--;
       Permit();
      }
     we->WindowFont=font;
     Forbid();
     we->WindowFont->tf_Accessors++;
     Permit();
     SetFont(rp,font);
     return(TRUE);
    }
  }
 return(FALSE);
}

/* ---- Fontstil */
UBYTE GetStyle()
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return(0);
 return(we->GfxStyle);
}

/* ---- Koordinaten korrigieren */
void NewXY(xPtr,yPtr)
 WORD *xPtr,*yPtr;
{
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 if(we->GfxFlags==GFXF_NEWXY)
  {
   *xPtr=INewX(we,*xPtr);
   *yPtr=INewY(we,*yPtr);
  }
 *xPtr+=we->InnerLeftEdge;
 *yPtr+=we->InnerTopEdge;
}

/* ---- Zeichenfunktion */
void Plot(x,y)
 WORD x,y;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   NewXY(&x,&y);
   Move(rp,x,y);
   WritePixel(rp,x,y);
  }
}

/* ---- Zeichenfunktion */
void MoveTo(x,y)
 WORD x,y;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   NewXY(&x,&y);
   Move(rp,x,y);
  }
}

/* ---- Zeichenfunktion */
void DrawTo(x,y)
 WORD x,y;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   NewXY(&x,&y);
   Draw(rp,x,y);
  }
}

/* ---- Zeichenfunktion */
void Line(x1,y1,x2,y2)
 WORD x1,y1,x2,y2;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   NewXY(&x1,&y1);
   NewXY(&x2,&y2);
   Move(rp,x1,y1);
   Draw(rp,x2,y2);
  }
}

/* ---- Zeichenfunktion */
void Ellipse(x,y,a,b)
 WORD x,y,a,b;
{
 struct RastPort    *rp;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp)
  {
   NewXY(&x,&y);
   DrawEllipse(rp,x,y,INewWidth(we,a),INewHeight(we,b));
  }
}

/* ---- Zeichenfunktion */
void Circle(x,y,a)
 WORD x,y,a;
{
 struct RastPort    *rp;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp)
  {
   NewXY(&x,&y);
   DrawEllipse(rp,x,y,
               INewWidth(we,a),
               (WORD)((FLOAT)INewHeight(we,a)*we->AspectY));
  }
}

/* ---- Zeichenfunktion */
void Rectangle(x1,y1,x2,y2)
 WORD x1,y1,x2,y2;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   NewXY(&x1,&y1);
   NewXY(&x2,&y2);
   Move(rp,x1,y1);
   Draw(rp,x2,y1);
   Draw(rp,x2,y2);
   Draw(rp,x1,y2);
   Draw(rp,x1,y1);
  }
}

/* ---- Zeichenfunktion */
void FilledRectangle(x1,y1,x2,y2)
 WORD x1,y1,x2,y2;
{
 WORD             h;
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   if(y2>y1) { h=y2; y2=y1; y1=h; }
   if(x2>x1) { h=x2; x2=x1; x1=h; }
   NewXY(&x1,&y1);
   NewXY(&x2,&y2);
   Move(rp,x1,y1);
   Draw(rp,x2,y1);
   Draw(rp,x2,y2);
   Draw(rp,x1,y2);
   Draw(rp,x1,y1);
  }
}

/* ---- Polygon zeichnen */
void DrawPolygon(array,count)
 UWORD *array;
 ULONG  count;
{
 UWORD              *mem;
 ULONG               i;
 struct RastPort    *rp;
 struct WindowEntry *we;

 WE;
 rp=GetRP();
 if(rp)
  {
   if(we->GfxFlags & GFXF_NEWXY)
    {
     mem=AllocVec(count*4+8,MEMF_ANY);
     if(mem!=NULL)
      {
       CopyMemQuick(array,mem,count*4);
       for(i=0;i<(count*2);i+=2)
         NewXY(&mem[i],&mem[i+1]);
       FreeVec(mem);
       PolyDraw(rp,count,mem);
      }
     else
       NoMemory();
    }
   else
     PolyDraw(rp,count,array);
  }
}

/* ---- Zeichenfunktion */
void Paint(x,y)
 WORD x,y;
{
 BOOL                bool;
 struct RastPort    *rp;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp)
  {
   bool=CreateTmpRas(we);
   if(bool)
    {
     NewXY(&x,&y);
     Flood(rp,1,x,y);
     DeleteTmpRas(we);
    }
  }
}

/* ---- Korrektion einschalten */
void CorrectionOn()
{
 struct WindowEntry *we;
 WE;
 if(we) we->GfxFlags=GFXF_NEWXY;
}

/* ---- Korrektion ausschalten */
void CorrectionOff()
{
 struct WindowEntry *we;
 WE;
 if(we) we->GfxFlags=GFXF_OLDXY;
}

/* ---- Text()-Funktion mit Outline-Druck */
void OutlineText(rp,x,y,text,style)
 struct RastPort *rp;
 UWORD            x,y;
 UBYTE           *text;
 UBYTE            style;
{
 WORD a,b;

 if(style & ST_OUTLINE)
  {
   SetDrMd(rp,JAM1);
   for(a=-1;a<=1;a++) {
     for(b=-1;b<=1;b++) {
       Move(rp,x+a,y+b);
       Text(rp,text,strlen(text));
    }}
   SetAPen(rp,0);
  }
 Move(rp,x,y);
 Text(rp,text,strlen(text));
}

/* ---- Textausgabe */
void Print(x,y,text)
 WORD   x,y;
 UBYTE *text;
{
 UBYTE               bgpen,fgpen;
 UWORD               spacing;
 struct WindowEntry *we;
 struct RastPort    *rp;

 WE;
 if(we==NULL) return;
 rp=we->RastPort;
 if(rp)
  {
   NewXY(&x,&y);
   BackupRP(we);
   spacing=rp->TxSpacing;

   rp->TxSpacing=we->TextSpacing;
   if(we->GfxStyle & ST_WIDE)
    {
     rp->TxSpacing=rp->TxSpacing+(((UWORD)TextLength(rp,"A",1))/2);
    }
   if(we->GfxStyle & ST_SHADOW)
    {
     bgpen=rp->BgPen;
     fgpen=rp->FgPen;
     SetAPen(rp,bgpen);
     SetBPen(rp,0);
     SetDrMd(rp,JAM1);
     OutlineText(rp,x+(UWORD)((FLOAT)2*we->FactorX),
                    y+(UWORD)((FLOAT)2*we->FactorY),
                    text,we->GfxStyle);
     SetAPen(rp,fgpen);
     OutlineText(rp,x,y,text,we->GfxStyle);
    }
   else
     OutlineText(rp,x,y,text,we->GfxStyle);

   rp->TxSpacing=spacing;
   RestoreRP(we);
  }
}

/* ---- Zeichenstifte */
UBYTE GetPixel(x,y)
 WORD x,y;
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp)
  {
   NewXY(&x,&y);
   return(ReadPixel(rp,x,y));
  }
 return(0);
}

/* ---- Textabstand */
void SetTextSpacing(spacing)
 WORD spacing;
{
 struct WindowEntry *we;

 WE;
 if(we)
   we->TextSpacing=spacing;
}

/* ---- Textabstand */
WORD GetTextSpacing(spacing)
 WORD spacing;
{
 struct WindowEntry *we;

 WE;
 if(we) return(we->TextSpacing);
 return(0);
}

/* ---- Area-Initialisierung */
struct RastPort *AInit()
{
 BOOL                bool;
 struct WindowEntry *we;

 WE;
 if(we==NULL) return(0L);
 if((we->TmpRas)&&(we->AreaInfo)) return(we->RastPort);

 if(we->TmpRas==NULL)
  {
   bool=CreateTmpRas(we);
   if(bool==FALSE) return(0L);
  }

 if(we->AreaInfo==NULL)
  {
   bool=CreateAreaInfo(we,200);
   if(bool==FALSE) return(0L);
  }

 return(we->RastPort);
}

/* ---- Zeichenfunktion */
void AMoveTo(x,y)
 WORD x,y;
{
 struct RastPort    *rp;

 rp=AInit();
 if(rp)
  {
   NewXY(&x,&y);
   AreaMove(rp,x,y);
  }
}

/* ---- Zeichenfunktion */
void ADrawTo(x,y)
 WORD x,y;
{
 struct RastPort    *rp;

 rp=AInit();
 if(rp)
  {
   NewXY(&x,&y);
   AreaDraw(rp,x,y);
  }
}

/* ---- Zeichenfunktion */
void ADrawPolygon(array,count)
 UWORD *array;
 ULONG  count;
{
 struct RastPort *rp;
 ULONG            i;
 WORD             x,y;
 
 rp=AInit();
 if(rp)
  {
   for(i=0;i<(count*2);i+=2)
    {
     x=array[i]; y=array[i+1];
     NewXY(&x,&y);
     if(i==0)
       AreaMove(rp,x,y);
     else
       AreaDraw(rp,x,y);
    }
   AreaEnd(rp);
  }
}

/* ---- Zeichenfunktion */
void AEllipse(x,y,a,b)
 WORD x,y,a,b;
{
 struct RastPort    *rp;

 rp=AInit();
 if(rp)
  {
   NewXY(&x,&y);
   AreaEllipse(rp,x,y,a,b);
  }
}

/* ---- Zeichenfunktion */
void ACircle(x,y,a,b)
 WORD x,y,a,b;
{
 struct RastPort    *rp;
 struct WindowEntry *we;

 WE;
 rp=AInit();
 if(rp)
  {
   NewXY(&x,&y);
   AreaEllipse(rp,x,y,
               INewWidth(we,a),
               (WORD)((FLOAT)INewHeight(we,a)*we->AspectY));
  }
}

/* ---- Zeichenfunktion */
void AEnd()
{
 struct RastPort    *rp;

 rp=AInit();
 if(rp) AreaEnd(rp);
}

/* ---- Area-Linien darstellen */
void ShowAreaLines()
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) rp->Flags |= AREAOUTLINE;
}

/* ---- Area-Linien nicht darstellen */
void HideAreaLines()
{
 struct RastPort *rp;

 rp=GetRP();
 if(rp) rp->Flags &= ~AREAOUTLINE;
}

/* ---- Palette setzen */
void SetPalette(num,r,g,b)
 UWORD num;
 UBYTE r,g,b;
{
 struct WindowEntry *we;

 WE;
 if(we)
  {
   if(!we->Iconify)
     SetRGB4(we->ViewPort,num,r>>4,g>>4,b>>4);
  }
}

/* ---- Palette setzen */
void SetGreyScale(num,r,g,b)
 UWORD num;
 UBYTE r,g,b;
{
 UWORD               grey;
 struct WindowEntry *we;

 WE;
 if(we)
  {
   if(!we->Iconify)
    {
     grey=(((UWORD)r+(UWORD)g+(UWORD)b)/3)>>4;
     SetRGB4(we->ViewPort,num,grey,grey,grey);
    }
  }
}

/* ---- Palette setzen */
void SetGrey(num,grey)
 UWORD num;
 UBYTE grey;
{
 struct WindowEntry *we;

 WE;
 if(we)
  {
   if(!we->Iconify)
     SetRGB4(we->ViewPort,num,grey>>4,grey>>4,grey>>4);
  }
}

/* ---- Palette ermitteln */
void GetPalette(num,r,g,b)
 UWORD  num;
 UBYTE *r,*g,*b;
{
 ULONG               color;
 struct WindowEntry *we;

 WE;
 if(we)
  {
   if(!we->Iconify)
    {
     color=GetRGB4(we->ViewPort->ColorMap,num);
     *r=((color & 0x0f00)>>8) << 4;
     *g=((color & 0x00f0)>>4) << 4;
     *b=(color & 0x000f) << 4;
    }
   else
     *r=*g=*b=0;
  }
}

/* ---- Palette ermitteln */
UBYTE GetGrey(num)
 UWORD num;
{
 ULONG               color;
 UBYTE               r,g,b,grey;
 struct WindowEntry *we;

 grey=0,
 WE;
 if(we)
  {
   if(!we->Iconify)
    {
     color=GetRGB4(we->ViewPort->ColorMap,num);
     r=((color & 0x0f00)>>8);
     g=((color & 0x00f0)>>4);
     b=(color & 0x000f);
     grey=((r+g+b)/3)<<4;
    }
  }
 return(grey);
}

