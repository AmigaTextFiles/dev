/*
** $PROJECT: xrefsupport.lib
**
** $VER: scanwindow.c 1.3 (22.09.94) 
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 22.09.94 : 001.003 :  now shows the time correctly (including hours)
** 17.09.94 : 001.002 :  status line added
** 09.09.94 : 001.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "/source/def.h"

#include "xrefsupport.h"

/* ------------------------------- defines -------------------------------- */

#define WIN_FLAGS    (WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_DEPTHGADGET | \
                      WFLG_ACTIVATE)
#define WIN_IDCMP    (IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY)

#define XDISTANCE    10
#define YDISTANCE    3

/* -------------------------- static data items --------------------------- */

static STRPTR gaugetexts[] = {
   "Actual ",
   "Total ",
   NULL};

static STRPTR timestrs[] = {
   "Time used",
   "Exp.:",
   "Left:",
   NULL};

static STRPTR statustxt = "Status";

/* --------------------------- local prototypes --------------------------- */

static void draw_infotexts(struct ScanWindow *swin,STRPTR *texts);

/* ------------------------------ functions ------------------------------- */

BOOL open_scanwindow(struct ScanWindow *swin,STRPTR *texts,STRPTR title,UWORD winwidth)
{
   struct Screen *scr;
   STRPTR *array = texts;
   ULONG num = 1;

   while(*array++)
      num++;

   if((scr = LockPubScreen(NULL)))
   {
      struct DrawInfo *dri;

      UWORD width  = scr->Width;
      UWORD height = scr->Height;

      UWORD winheight; 

      UBYTE shinepen     = 2;
      UBYTE shadowpen    = 1;
      UBYTE highlightpen = 2;

      swin->sw_TextAttr = *scr->Font;
      strcpy(swin->sw_FontName,swin->sw_TextAttr.ta_Name);
      swin->sw_TextAttr.ta_Name = swin->sw_FontName;

      winheight = (swin->sw_TextAttr.ta_YSize + 1) * (num + 7);

      swin->sw_TextPen  = 1;
      swin->sw_BackPen  = 0;

      if((dri = GetScreenDrawInfo(scr)))
      {
         swin->sw_TextPen = dri->dri_Pens[TEXTPEN];
         swin->sw_BackPen = dri->dri_Pens[BACKGROUNDPEN];

         swin->sw_Total.FillPen  =
         swin->sw_Actual.FillPen = dri->dri_Pens[FILLPEN];

         shinepen     = dri->dri_Pens[SHINEPEN];
         shadowpen    = dri->dri_Pens[SHADOWPEN];
         highlightpen = dri->dri_Pens[HIGHLIGHTTEXTPEN];

         FreeScreenDrawInfo(scr,dri);
      }

      if((swin->sw_TextFont = OpenFont(&swin->sw_TextAttr)))
      if((swin->sw_Window = OpenWindowTags(NULL,
                                         WA_Title     ,title,
                                         WA_Width     ,winwidth,
                                         WA_Height    ,winheight,
                                         WA_Left      ,(width  - winwidth ) >> 1,
                                         WA_Top       ,(height - winheight) >> 1,
                                         WA_Flags     ,WIN_FLAGS,
                                         WA_IDCMP     ,WIN_IDCMP,
                                         TAG_DONE)))
      {
         struct Window   *win = swin->sw_Window;
         struct RastPort *rp  = win->RPort;
         ULONG i;
         UWORD x;

         SetFont(rp,swin->sw_TextFont);

         swin->sw_XMax = win->Width - win->BorderRight - XDISTANCE - 1;

         SetAPen(rp,highlightpen);

         draw_infotexts(swin,texts);

         swin->sw_YTime       = swin->sw_YTop + num * swin->sw_YStep + swin->sw_YStep / 2;

         Move(rp,swin->sw_XTop,swin->sw_YTime);
         Text(rp,":",1);

         swin->sw_XTop += TextLength(rp,": ",2);

         swin->sw_XTime       = calctextwidth(rp,timestrs);
         if(swin->sw_XTop > swin->sw_XTime)
            swin->sw_XTime = swin->sw_XTop;

         /* maximal time length in pixel */
         swin->sw_XTimeMax    = 5 * getmaxdigitwidth(rp) + 2 * TextLength(rp,":",1);

         x = swin->sw_XMax / 3;
         for(i = 0 ; i < 3 ; i++)
         {
            Move(rp,i * x + XDISTANCE + ((i > 0) ? (swin->sw_XTimeMax/3) : 0),swin->sw_YTime);
            Text(rp,timestrs[i],strlen(timestrs[i]));
         }

         swin->sw_Total.Left  =
         swin->sw_Actual.Left = calctextwidth(rp,gaugetexts) + XDISTANCE + win->BorderLeft;

         swin->sw_Total.Right  =
         swin->sw_Actual.Right = swin->sw_XMax;

         swin->sw_Actual.Top    = swin->sw_YTop       + (num + 1) * swin->sw_YStep + swin->sw_YStep / 2;
         swin->sw_Actual.Bottom = swin->sw_Actual.Top + swin->sw_YStep;

         swin->sw_Total.Top     = swin->sw_Actual.Bottom + swin->sw_YStep / 2;
         swin->sw_Total.Bottom  = swin->sw_Total.Top     + swin->sw_YStep;

         Move(rp,XDISTANCE,swin->sw_Actual.Top + rp->TxBaseline + 1);
         Text(rp,gaugetexts[0],strlen(gaugetexts[0]));

         Move(rp,XDISTANCE,swin->sw_Total.Top  + rp->TxBaseline + 1);
         Text(rp,gaugetexts[1],strlen(gaugetexts[1]));

         draw_gaugeinit(win,&swin->sw_Actual,shinepen,shadowpen);
         draw_gaugeinit(win,&swin->sw_Total ,shinepen,shadowpen);
      }

      UnlockPubScreen(NULL,scr);
   }

   return((BOOL) swin->sw_Window);
}

void close_scanwindow(struct ScanWindow *swin,BOOL abort)
{
   if(swin->sw_Window)
   {
      if(!abort)
      {
         ULONG mask = (1<<swin->sw_Window->UserPort->mp_SigBit) | SIGBREAKF_CTRL_C;
         ULONG rcvd;
         struct IntuiMessage *msg;
         BOOL end = FALSE;

         draw_scanwindowstatus(swin,"finished !");

         while(!end)
         {
            rcvd = Wait(mask);

            if(rcvd & SIGBREAKF_CTRL_C)
               end = TRUE;
            else
               while((msg = (struct IntuiMessage *) GetMsg(swin->sw_Window->UserPort)))
               {
                  switch(msg->Class)
                  {
                  case IDCMP_VANILLAKEY:
                     end = (msg->Code == 3) || (msg->Code == 27);
                     break;
                  case IDCMP_CLOSEWINDOW:
                     end = TRUE;
                     break;
                  }
                  ReplyMsg((struct Message *) msg);
               }
         }
      }

      if(swin->sw_TextFont)
         CloseFont(swin->sw_TextFont);

      CloseWindow(swin->sw_Window);
   }
}

static void draw_infotexts(struct ScanWindow *swin,STRPTR *texts)
{
   struct Window   *win = swin->sw_Window;
   struct RastPort *rp  = win->RPort;

   STRPTR *array = texts;

   UWORD top = win->BorderTop + rp->TxBaseline + 2;
   UWORD max = TextLength(rp,statustxt,strlen(statustxt));
   UWORD x;

   SetBPen(rp,swin->sw_BackPen);
   SetDrMd(rp,JAM2);

   swin->sw_YStep = rp->TxHeight + 1;
   swin->sw_YTop  = top;

   Move(rp,XDISTANCE,top);
   Text(rp,statustxt,strlen(statustxt));

   top += swin->sw_YStep;

   while(*array)
   {
      if((x = TextLength(rp,*array,strlen(*array))) > max)
         max = x;

      Move(rp,XDISTANCE,top);
      Text(rp,*array,strlen(*array));

      top += swin->sw_YStep;

      array++;
   }

   max += 10 + XDISTANCE;

   array = texts;
   top = swin->sw_YTop;

   Move(rp,max,top);
   Text(rp,":",1);

   while(*array)
   {
      top += swin->sw_YStep;
      Move(rp,max,top);
      Text(rp,":",1);
      array++;
   }
   
   swin->sw_XTop = max;
}

void draw_scanwindowstatus(struct ScanWindow *swin,STRPTR string)
{
   draw_scanwindowtext(swin,-1,string);
}

void draw_scanwindowtext(struct ScanWindow *swin,ULONG num,STRPTR string)
{
   struct TextExtent txtext;
   struct Window   *win = swin->sw_Window;
   struct RastPort *rp  = win->RPort;

   UWORD y     = swin->sw_YTop + (++num) * swin->sw_YStep;
   UWORD width = swin->sw_XMax - swin->sw_XTop;
   ULONG len   = strlen(string);
   UWORD chars;

   SetAPen(rp,swin->sw_TextPen);
   SetBPen(rp,swin->sw_BackPen);
   SetDrMd(rp,JAM2);

   Move(rp,swin->sw_XTop,y);

   if((chars = TextFit(rp,&string[len],len,&txtext,NULL,-1,width,swin->sw_YStep)) > 0)
      Text(rp,&string[len - chars],chars);

   if(rp->cp_x < swin->sw_XMax)
   {
      y -= rp->TxBaseline;
      EraseRect(rp,rp->cp_x,y, swin->sw_XMax , y + swin->sw_YStep - 1);
   }
}

void draw_scanwindowtime(struct ScanWindow *swin,ULONG *secs)
{
   struct RastPort *rp = swin->sw_Window->RPort;
   UBYTE buf[100];
   ULONG i;
   UWORD x;
   UWORD y;

   SetDrMd(rp,JAM2);
   SetAPen(rp,swin->sw_TextPen);
   SetBPen(rp,swin->sw_BackPen);

   for(i = 0 ; i < 3 ; i++)
   {
      sprintf(buf,"%01ld:%02ld:%02ld",((secs[i] / 3600) % 10),((secs[i] / 60) % 60),(secs[i] % 60));

      x = i * swin->sw_XMax / 3 + swin->sw_XTime - ((i) ? (swin->sw_XTimeMax/2) : 0);
      y = swin->sw_YTime;

      Move(rp,x,y);
      Text(rp,buf,strlen(buf));

      if(rp->cp_x < x + swin->sw_XTimeMax)
      {
         y -= rp->TxBaseline;
         EraseRect(rp,rp->cp_x,y, x + swin->sw_XTimeMax , y + swin->sw_YStep - 1);
      }
   }
}

