/*
 * MAGIC Image Tester - creates a small public MAGIC image with
 *    a teeny tiny interface.
 *
 * Written by Thomas Krehbiel
 *
 * (This requires 2.0, BTW.)
 *
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/dos.h>
#include <intuition/intuition.h>
#include <libraries/gadtools.h>
#include <clib/exec_protos.h>
#include <clib/alib_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/gadtools_protos.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <stdio.h>

#include <magic/magic.h>
#include <magic/magic_protos.h>
#include <magic/magic_pragmas.h>

struct Library *IntuitionBase;
struct Library *GfxBase;
struct Library *GadToolsBase;

struct MagicBase *MagicBase;

UBYTE *planes[4] = { NULL, NULL, NULL, NULL };
struct MagicImage *mi;
struct MagicHandle *mh;
struct MsgPort *hostport;


void message (char *, ...);


#define WIDTH     320
#define HEIGHT    200
#define DEPTH     3        /* color */

short real_width, real_height;

BOOL alloc_planes (UBYTE **planes, int depth)
{
   int i;

   for (i = 0; i < depth; i++) planes[i] = NULL;

   for (i = 0; i < depth; i++) {
      if (!(planes[i] = AllocMem(WIDTH * HEIGHT, MEMF_CLEAR | MEMF_PUBLIC))) {
         return(FALSE);
      }
   }

   /* gradient from black to light violet */
   for (i = 0; i < HEIGHT; i++) {
      memset(planes[0] + (WIDTH * i), i * 255 / (HEIGHT-1), WIDTH);
      memset(planes[1] + (WIDTH * i), i * 127 / (HEIGHT-1), WIDTH);
      memset(planes[2] + (WIDTH * i), i * 255 / (HEIGHT-1), WIDTH);
   }

   real_width = WIDTH;
   real_height = HEIGHT;

   return(TRUE);
}

void free_planes (UBYTE **planes, int depth)
{
   int i;

   for (i = 0; i < depth; i++) {
      if (planes[i]) {
         FreeMem(planes[i], real_width * real_height);
         planes[i] = NULL;
      }
   }
}


static
BOOL __saveds PutData (struct MagicImage *pi, LONG offset, LONG rows, LONG *tags)
{
   UBYTE *tagdata;
   LONG byte;
   UBYTE *ptr;
   int i;

   while (*tags != TAG_END) {
      tagdata = (UBYTE *)tags[1];
      switch (*tags) {
         case TAG_IGNORE :
            break;
         case GMI_Red :
            CopyMem(tagdata, planes[0] + (offset * WIDTH), WIDTH * rows);
            break;
         case GMI_Green :
            CopyMem(tagdata, planes[1] + (offset * WIDTH), WIDTH * rows);
            break;
         case GMI_Blue :
            CopyMem(tagdata, planes[2] + (offset * WIDTH), WIDTH * rows);
            break;
         case GMI_RGB :
            byte = offset * WIDTH;
            ptr = (UBYTE *)tagdata;
            for (i = 0; i < WIDTH; i++) {
               planes[0][byte] = *ptr++;
               planes[1][byte] = *ptr++;
               planes[2][byte++] = *ptr++;
            }
            break;
         case GMI_ARGB :
            byte = offset * WIDTH;
            ptr = (UBYTE *)tagdata;
            for (i = 0; i < WIDTH; i++) {
               ptr++;   /* skip alpha */
               planes[0][byte] = *ptr++;
               planes[1][byte] = *ptr++;
               planes[2][byte++] = *ptr++;
            }
            break;
         default :
            break;
      }
      tags += 2;
   }
   return(TRUE);
}

static
BOOL __saveds GetData (struct MagicImage *pi, LONG offset, LONG rows, LONG *tags)
{
   UBYTE *tagdata;
   LONG byte;
   UBYTE *ptr;
   int i;

   while (*tags != TAG_END) {
      tagdata = (UBYTE *)tags[1];
      switch (*tags) {
         case TAG_IGNORE :
            break;
         case GMI_Red :
            CopyMem(planes[0] + (offset * WIDTH), tagdata, WIDTH * rows);
            break;
         case GMI_Green :
            CopyMem(planes[1] + (offset * WIDTH), tagdata, WIDTH * rows);
            break;
         case GMI_Blue :
            CopyMem(planes[2] + (offset * WIDTH), tagdata, WIDTH * rows);
            break;
         case GMI_RGB :
            byte = offset * WIDTH;
            ptr = (UBYTE *)tagdata;
            for (i = 0; i < WIDTH; i++) {
               *ptr++ = planes[0][byte];
               *ptr++ = planes[1][byte];
               *ptr++ = planes[2][byte++];
            }
            break;
         case GMI_ARGB :
            byte = offset * WIDTH;
            ptr = (UBYTE *)tagdata;
            for (i = 0; i < WIDTH; i++) {
               *ptr++ = 255;
               *ptr++ = planes[0][byte];
               *ptr++ = planes[1][byte];
               *ptr++ = planes[2][byte++];
            }
            break;
         default :
            break;
      }
      tags += 2;
   }
   return(TRUE);
}

BOOL init_magic (void)
{
   if (!(MagicBase = (struct MagicBase *)OpenLibrary(MAGIC_NAME, 34)))
      return(FALSE);

   return(TRUE);
}

void close_magic (void)
{
   if (mh) {
      CloseMagicImage(mh);
      mh = NULL;
   }
   if (mi) {
      while (!RemMagicImage(mi)) {
         message("Image in use!");
         Delay(50);
      }
      FreeMagicImage(mi);
      free_planes(planes, DEPTH);
      mi = NULL;
   }
}

void cleanup_magic (void)
{
   close_magic();
   CloseLibrary((struct Library *)MagicBase);
}

void new_magic (void)
{
   close_magic();

   if (alloc_planes(planes, DEPTH)) {
      if (mi = AllocMagicImage(AMI_Width, WIDTH,
                                  AMI_Height, HEIGHT,
                                  AMI_Depth, DEPTH,
                                  AMI_Red, planes[0],
                                  AMI_Green, planes[1],
                                  AMI_Blue, planes[2],
                                  AMI_GetDataCode, GetData,
                                  AMI_PutDataCode, PutData,
                                  AMI_OwnerName, "MagicDemo",
                                  TAG_END)) {
         if (AddMagicImage(mi)) {
            /*
             * Even the owner of an image must open it!  Remember to use
             * OMI_OwnerPort instead of OMI_MsgPort.
             */
            if (mh = OpenMagicImage(mi, NULL, OMI_OwnerPort, hostport, TAG_END)) {
               message("Magic image created.");
               return;
            }
            RemMagicImage(mi);
         }
         FreeMagicImage(mi);
      }
      free_planes(planes, DEPTH);
   }

   mi = NULL;
   mh = NULL;
}

struct NewMenu newMenus[] = {
   { NM_TITLE, "Project",        NULL, 0, 0, 0 },
   { NM_ITEM,  "New",            "N",  0, 0, 0 },
   { NM_ITEM,  "Open...",        "O",  0, 0, 0 },
   { NM_ITEM,  NM_BARLABEL,      NULL, 0, 0, 0 },
   { NM_ITEM,  "Manipulate",     "M",  0, 0, 0 },
   { NM_ITEM,  NM_BARLABEL,      NULL, 0, 0, 0 },
   { NM_ITEM,  "Cycle",          "C",  0, 0, 0 },
   { NM_ITEM,  NM_BARLABEL,      NULL, 0, 0, 0 },
   { NM_ITEM,  "Quit",           "Q",  0, 0, 0 },
   { NM_END }
};

struct Window *win;
struct Menu *menus;
APTR vi;

BOOL init_gui (void)
{
   struct Screen *scr;

   IntuitionBase = OpenLibrary("intuition.library", 37);
   GfxBase = OpenLibrary("graphics.library", 37);
   GadToolsBase = OpenLibrary("gadtools.library", 37);
   /* (yes, I know, but it's just a demo) */

   scr = LockPubScreen(NULL);
   if (scr == NULL) return(FALSE);

   if (!(win = OpenWindowTags(NULL,
                              WA_Title, "MAGIC Testerosa",
                              WA_InnerWidth, 200,
                              WA_Height, 115 + scr->WBorTop + scr->Font->ta_YSize + 1 + scr->WBorBottom + scr->RastPort.TxHeight + 2,
                              WA_Left, 20,
                              WA_Top, 20,
                              WA_Flags, WFLG_CLOSEGADGET | WFLG_DRAGBAR |
                                          WFLG_DEPTHGADGET |
                                          WFLG_SMART_REFRESH | WFLG_NOCAREREFRESH |
                                          WFLG_ACTIVATE,
                              WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_MENUPICK,
                              WA_NewLookMenus, TRUE,
                              TAG_END))) goto err1;

   menus = CreateMenus(newMenus, TAG_END);
   if (menus == NULL) goto err2;

   vi = GetVisualInfo(scr, TAG_END);
   if (vi == NULL) goto err3;

   LayoutMenus(menus, vi, GTMN_NewLookMenus, TRUE, TAG_END);

   SetMenuStrip(win, menus);

   UnlockPubScreen(NULL, scr);

   return(TRUE);

err3:
   FreeMenus(menus);
err2:
   CloseWindow(win);
err1:
   UnlockPubScreen(NULL, scr);
   return(FALSE);
}

void cleanup_gui (void)
{
   ClearMenuStrip(win);
   FreeVisualInfo(vi);
   FreeMenus(menus);
   CloseWindow(win);
   CloseLibrary(GadToolsBase);
   CloseLibrary(GfxBase);
   CloseLibrary(IntuitionBase);
}

/* 4x4 dispersed dot ordered dither pattern. */
static
UBYTE dith[4][4] = {
    1, 15,  2, 12,
    9,  5, 10,  7,
    3, 13,  0, 14,
   11,  7,  8,  4
};

void redraw (void)
{
   UBYTE *outpix;
   UBYTE *rgb;
   int w, h, le, te;
   struct MagicImage *mi;
   struct RastPort temprp;
   struct BitMap tempbm;
   int i, j, x, y;
   short v;

   w = win->Width - win->BorderLeft - win->BorderRight - 4;
   h = win->Height - win->BorderTop - win->BorderBottom - 2 - win->RPort->TxHeight - 2;
   le = win->BorderLeft + 2;
   te = win->BorderTop + win->RPort->TxHeight + 3;

   if (!mh) {
      SetAPen(win->RPort, 0);
      RectFill(win->RPort, le, te, le + w - 1, te + h - 1);
      return;
   }

   mi = mh->Object;

   outpix = AllocMem(((w+15)>>4)<<4, MEMF_CLEAR);
   if (outpix == NULL) return;

   rgb = AllocMem(mi->Width * 3, MEMF_CLEAR);
   if (rgb == NULL) return;

   InitRastPort(&temprp);
   InitBitMap(&tempbm, win->RPort->BitMap->Depth, w, 1);
   temprp.BitMap = &tempbm;
   for (i = 0; i < tempbm.Depth; i++) {
      tempbm.Planes[i] = AllocRaster(w, 1);
      /* ick */
   }

   for (j = 0; j < h; j++) {

      y = j * (mi->Height-1) / (h-1);
      GetMagicImageData(mh, y, 1, GMI_RGB, rgb, TAG_END);

      for (i = 0; i < w; i++) {
         x = (i * (mi->Width-1) / (w-1)) * 3;
         v = ((rgb[x] + rgb[x+1] + rgb[x+2]) / 3) >> 4;
         if (v > dith[j&3][i&3]) outpix[i] = 2;
         else                    outpix[i] = 1;
      }

      WritePixelLine8(win->RPort, le, te + j, w, outpix, &temprp);

   }

   for (i = 0; i < tempbm.Depth; i++) {
      FreeRaster(tempbm.Planes[i], w, 1);
   }

   FreeMem(rgb, mi->Width * 3);
   FreeMem(outpix, ((w+15)>>4)<<4);
}

struct MagicImage *pick_magic (void)
{
   struct MagicImage *m = NULL;


   m = PickMagicImage(NULL,
         PMI_ExcludeOwner, "MagicDemo",
         PMI_ShowSize, TRUE,
         PMI_ShowOwner, TRUE,
         TAG_END);

   if (m) {
      close_magic();

      if (mh = OpenMagicImage(m, NULL, OMI_MsgPort, hostport, TAG_END)) {
         message("Magic Image opened.");
      }
   }

   return(m);
}

void message (char *txt, ...)
{
   struct RastPort *rp = win->RPort;
   char buf[80];
   va_list va;

   va_start(va, txt);
   vsprintf(buf, txt, va);
   va_end(va);

   SetAPen(rp, 0);
   SetDrMd(rp, JAM1);
   RectFill(rp,
      win->BorderLeft,
      win->BorderTop,
      win->Width - win->BorderRight - 1,
      win->BorderTop + rp->TxHeight);

   SetAPen(rp, 1);
   SetDrMd(rp, JAM1);
   Move(rp, win->BorderLeft + 2, win->BorderTop + rp->TxBaseline + 1);
   Text(rp, buf, strlen(buf));
}


void __regargs negative (UBYTE *data, int width)
{
   while (width--) {
      *data = 255 - *data;
      data++;
   }
}

/* do something interesting to the image buffer.  yeah, right */

void manipulate (void)
{
   struct MagicImage *mi;
   UBYTE *buf;
   int j, p;
   LONG tag[3] = { GMI_Red, GMI_Green, GMI_Blue };

   if (mh) {
      if (!AttemptLockMagicImage(mh, LMI_Write)) {
         message("Image is locked.");
         return;
      }
      mi = mh->Object;
      if (buf = AllocMem(mi->Width, MEMF_CLEAR)) {

         message("Processing...");
         if (!mi) SaveMagicImage(mh, 0, 0, mi->Width, mi->Height);
         for (j = 0; j < mi->Height; j++) {
            for (p = 0; p < mi->Depth; p++) {
               GetMagicImageData(mh, j, 1, tag[p], buf, TAG_END);
               negative(buf, mi->Width);
               PutMagicImageData(mh, j, 1, tag[p], buf, TAG_END);
            }
         }
         RedrawMagicImage(mh, 0, 0, mi->Width, mi->Height);
         message("Image manipulated.");

         FreeMem(buf, mi->Width);
      }

      UnlockMagicImage(mh);
   }
}

void halve (void)
{
#if 0
   UBYTE *newplane;
   int neww, newh;

   if (mi) {
      neww = real_width / 2;
      newh = real_height / 2;
      for (p = 0; p < 3; p++) {
         newplane = AllocMem(neww * newh, MEMF_CLEAR);
         if (newplane == NULL) break;  /* crash city */
         /* FINISH THIS! */
      }
   }
   else {
      message("Can't resize foreign images.");
   }
#endif
}


void event_loop (void)
{
   struct IntuiMessage *msg;
   struct MagicMessage *mmsg;
   ULONG wsig, hsig, sigs;
   BOOL quit = FALSE;
   int oldpri;

   message("Standing by...");

   wsig = 1 << win->UserPort->mp_SigBit;
   hsig = 1 << hostport->mp_SigBit;

   while (!quit) {

      sigs = Wait(wsig | hsig);

      if (sigs & wsig) {
         while (msg = (struct IntuiMessage *)GetMsg(win->UserPort)) {
            switch(msg->Class) {
               case IDCMP_CLOSEWINDOW :
                  quit = TRUE;
                  break;
               case IDCMP_MENUPICK :
                  switch(ITEMNUM(msg->Code)) {
                     case 0 : new_magic(); redraw(); break;
                     case 1 : pick_magic(); redraw(); break;
                     case 3 : manipulate(); redraw(); break;
                     case 5 : if (mh) CycleMagicImage(mh); break;
                     case 7 : quit = TRUE; break;
                     default: break;
                  }
                  break;
               default :
                  break;
            }
            ReplyMsg((struct Message *)msg);
         }
      }

      if (sigs & hsig) {
         while (mmsg = (struct MagicMessage *)GetMsg(hostport)) {
            mmsg->Result = 0;
            switch(mmsg->Action) {
               case MMSG_UPDATE :
                  message("Update");
                  break;
               case MMSG_REDRAW :
                  message("Redraw %ld %ld %ld %ld",
                     mmsg->Args[0], mmsg->Args[1], mmsg->Args[2], mmsg->Args[3]);
                  oldpri = SetTaskPri(FindTask(NULL), -1);
                  redraw();
                  SetTaskPri(FindTask(NULL), oldpri);
                  break;
               case MMSG_TOFRONT :
                  message("To Front");
                  ScreenToFront(win->WScreen);
                  WindowToFront(win);
                  ActivateWindow(win);
                  break;
               case MMSG_SAVEUNDO :
                  message("Save Undo");
                  break;
               case MMSG_RESTOREUNDO :
                  message("Restore Undo");
                  break;
               case MMSG_CLOSE :
                  message("Hit The Road");
                  close_magic();
                  redraw();
                  break;
               default :
                  mmsg->Result = -1;
                  break;
            }
            ReplyMsg((struct Message *)mmsg);
         }
      }

      if (quit) {
         if (mi && mi->OpenCount > 1) {
            message("No way - image in use.");
            quit = FALSE;
         }
      }

   }
}


void main (int argc, char **argv)
{
   struct Task *task = FindTask(NULL);

   task->tc_Node.ln_Name = "Magic Demo";

   if (hostport = CreatePort(NULL, 0)) {
      if (init_gui()) {
         if (init_magic()) {
            event_loop();
            cleanup_magic();
         }
         cleanup_gui();
      }
      DeletePort(hostport);
   }
}
