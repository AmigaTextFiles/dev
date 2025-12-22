/*
   amiterm.c           Amiga screen module

   Copyright (C) 1997 Tony Belding, <tlbelding@htcomp.net>

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
#include "logo.h"
#include "globals.h"
#include "amiterm.h"

/*
   version = standard AmigaDOS string for "version" command

   The revision and amiga_revision values are intended mainly
   for internal checking of file formats.  See load_prefs() and
   save_prefs() for an example.
*/
char *version = "$VER: Berkeley_Amiga_Logo 4.01 (13.10.97)";
int revision = 401;
int amiga_revision = 9;

struct Window *conwin_addr();
void conwin_resize();

extern NODE* make_static_strnode();

BPTR console=NULL;   /* pointer of AmigaDOS console device */
struct Window *conwin=NULL;

/*
   This will create an auto-window that will open on the Workbench only if
   text is sent to it.  The standard C I/O, stdout, is directed to it, so
   you can send debugging or error info with printf().  Text directed to
   the Logo text console should go to ndprintf() or ami_print() instead.
*/
__near char __stdiowin[]="CON:40/380/600/100/Logo Debugging";
__near char __stdiov37[]="/AUTO";


#define INTUI_V36_NAMES_ONLY

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <intuition/screens.h>
#include <graphics/displayinfo.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/intuition_protos.h>
#include <clib/layers_protos.h>


/*    struct Library *IntuitionBase;      */

struct Screen *scrn=NULL; /* Points to the Intuition screen */
struct Window *win;       /* Points to the graphics window */
int current_vis;          /* Is the pen writing */


char *prefsname = "logo.cfg";    /* name of Amiga preferences file */
char screenname[20];  /* name of Amiga public screen */

BAL_Prefs prefs;

/* remember which was the last screen layout that was set */
enum Layout { NOSCREEN, TEXTSCREEN, FULLSCREEN, SPLITSCREEN } layout;

void handle_window_events(struct Window *);
void amiga_init(int argc, char *argv[]);
void amiga_deinit(void);
void amiga_noscreen(void);
void amiga_layout(enum Layout);
void announce_closescreen(struct Screen *);

BOOL save_prefs()
{
    BPTR outfile=Open(prefsname,MODE_NEWFILE);
    BOOL success = FALSE;;

    if (outfile) {
        Write(outfile,&amiga_revision,(long)sizeof(revision));
        Write(outfile,&prefs,(long)sizeof(prefs));
        Close(outfile);
        success = TRUE;
    } else
        ami_print("I couldn't open the file to save your preferences!\n");
    return success;
}


BOOL load_prefs()
{
   BPTR infile=Open(prefsname,MODE_OLDFILE);
   BAL_Prefs new_prefs;
   int revcheck;
   BOOL success = FALSE;

   if (infile==NULL)
      ami_print("I couldn't open the file to load your preferences!\n");
   else {
      Read(infile,&revcheck,(long)sizeof(revcheck));
      if (revcheck>=8 && revcheck<=amiga_revision)
         success = Read(infile,&new_prefs,sizeof(prefs))==sizeof(prefs);
      if (success==FALSE)
         ami_print("The preferences file seems to be corrupted.\n");
      Close(infile);
   }
   if (success)  /* here we are going to copy the new_prefs into prefs */
      prefs = new_prefs;
   else
      default_prefs();
   return success;
}


void default_prefs()
{
   /* try for values that will work on any system, even NTSC ECS */
   prefs.DisplayID = HIRES_KEY;
   prefs.DisplayWidth = 640;
   prefs.DisplayHeight = 200;
   prefs.DisplayDepth = 4;
   prefs.OverscanType = OSCAN_STANDARD;
   prefs.font[0]='\0';
   strcpy(prefs.editor,
      "ed %s window \"CON:20/20/600/200/Logo Editor/CLOSE/SCREEN %s\"");
}


void amiga_open_graphics_screen()
{
   short my_pens[] = { ~0 };   /* for the new 3D rendering look */

   /*
      Each public screen I open is given a unique name based on the Amiga
      process address.  It's the same method I use for generating the
      temporary filename in ledit().  So, multiple instances of Berkeley
      Amiga Logo can be running at a given time without conflict.
   */
   sprintf(screenname,"BAL%ld",FindTask(NULL));
   (void)load_prefs();

   /* Open the screen. */
   scrn = OpenScreenTags(NULL,
      SA_Type,       CUSTOMSCREEN,
      SA_DetailPen,  BLACK,
      SA_BlockPen,   WHITE,
      SA_Title,      "Berkeley Amiga Logo",
      SA_PubName,    screenname,
      SA_DisplayID,  prefs.DisplayID,
      SA_Width,      prefs.DisplayWidth,
      SA_Height,     prefs.DisplayHeight,
      SA_AutoScroll, TRUE,
      SA_Depth,      prefs.DisplayDepth,
      SA_Pens,       my_pens,
      TAG_END );

   if (scrn==NULL) {
      printf("I can't open the screen for Logo!\n");
      prepare_to_exit();
      exit(1);
   }

   PubScreenStatus(scrn,0);   /* take it public */

   {
      /*
         I want  to determine the ModeID of the screen, then search the
         display database and calculate the correct aspect ratio from
         that.  I am also calculating magnification here.  This means
         turtle graphics will look about the same, no matter what screen
         mode we are using.  It does assume the user has set his overscan
         prefs correctly.

         It also means Logo programs should not change the scrunch value,
         such as for drawing ellipses or other distorted shapes, then set
         the scrunch back to [1.0 1.0].  They should store the scrunch
         value before messing with it, and then restore to its original
         value when they are through.
      */
      LONG modeid;

      modeid = GetVPModeID(&(scrn->ViewPort));
      x_scale = 1;   y_scale = 1;
      if (modeid!=INVALID_ID) {
         struct DimensionInfo di;

         /*
            The values are taken from "text overscan" mode.  If the user
            has set his overscan prefs correctly, this should most closely
            conform to the actual shape of his screen.  I found it comes
            to about [2.75 2.75] on an 800x600 display.  That gives a visual
            field a little over 200 turtle steps tall, as recommended in
            the docs.
         */
         (void)GetDisplayInfoData(NULL,(UBYTE *)&di,(ULONG)sizeof(di),DTAG_DIMS,modeid);
         x_scale = (di.TxtOScan.MaxX+1)/(800.0/2.75);
         y_scale = (di.TxtOScan.MaxY+1)/(600.0/2.75);
      }
   }

   {
      /*
         We've got to set the base palette of the screen.
      */
      int ctr, maxcolor=18, screen_maxcolor=(1<<scrn->RastPort.BitMap->Depth)-1;
      const int data[]={

         /*** following are fixed colors ***/
         168,  168,  168,  /* 0 WB gray   */
         0,    0,    0,    /* 1 black     */
         255,  255,  255,  /* 2 white     */
         100,  136,  184,  /* 3 WB blue   */
         0,    0,    255,  /* 4 blue      */
         0,    255,  0,    /* 5 green     */
         0,    255,  255,  /* 6 cyan      */
         255,  0,    0,    /* 7 red       */
         255,  0,    200,  /* 8 magenta   */
         255,  255,  0,    /* 9 yellow    */

         /*** following are variable Logo presets ***/
         144,  76,   0,    /* 10 brown    */
         208,  172,  100,  /* 11 tan      */
         0,    100,  0,    /* 12 forest   */
         0,    176,  152,  /* 13 aqua     */
         232,  172,  152,  /* 14 salmon   */
         184,  0,    255,  /* 15 purple   */

         /*** these last two will be cut off on 16-color screens ***/
         255,  108,  0,    /* 16 orange   */
         -1,   -1,   -1,   /* Don't touch!  This is for mouse pointer. */
         120,  120,  120   /* 18 gray     */
      };

      if (maxcolor>screen_maxcolor)
         maxcolor = screen_maxcolor;

      for (ctr=0; ctr<=maxcolor; ctr++) {
         ULONG r, g, b;

         if (data[ctr*3]<0)   /* some colors shouldn't be touched */
            continue;
         /*
            Note that Amiga OS 3.0+ wants a 32-bit value for each color
            gun, so I have to scale them up as per autodocs.
         */
         r = data[ctr*3]<<24 | 0xffffff;
         g = data[ctr*3+1]<<24 | 0xffffff;
         b = data[ctr*3+2]<<24 | 0xffffff;
         SetRGB32(&(scrn->ViewPort),(ULONG)ctr,r,g,b);
      }
   }

}

void amiga_open_graphics_window()
{
   if (win==NULL) {
      /*
         It is a full-screen (except for titlebar), borderless,
         backdrop window.  Thus, it looks like graphics are being
         drawn directly on the public screen bitmap.  However,
         using a backdrop window is cleaner and more flexible.
         It could be easy to adapt this to run on Workbench: most
         of the needed code is already in place.
      */
      win = OpenWindowTags(NULL,
         WA_Top,             scrn->BarHeight,
         WA_Width,           scrn->Width,
         WA_Height,          scrn->Height-scrn->BarHeight,
         WA_Backdrop,        TRUE,
         WA_Borderless,      TRUE,
         WA_IDCMP,           NULL,
         WA_CustomScreen,    scrn,
         TAG_DONE );

      if (win==NULL) {
         /* window failed to open */
         prepare_to_exit();
         exit(1);
      } else {
         /* window successfully opened here */
         /* ClipWindow( win); */
         SetAPen(win->RPort,WHITE);
         SetBPen(win->RPort,BLACK);

         /* handle_window_events(win); */
      }
   }
}

/***** ABOUT COLOR MAPPING

The functions MapColor() and RevMapColor() do conversion between Amiga and
Logo color index numbers.  I have reserved certain colors that Amiga wants
for rendering the gadgets, text console, and pointer, so Logo can't touch
them.  We will need a whole new mapping and allocation system whenever
support for 16-bit or 24-bit color is added.

*****/


ULONG MapColor(FIXNUM logo_color)
{
   /* convert a logo color to an Amiga palette entry */
   int screen_maxcolor=(1<<scrn->RastPort. BitMap->Depth)-1;
   const int table[]={BLACK,BLUE,GREEN,CYAN,RED,MAGENTA,YELLOW,WHITE};
   ULONG newcolor=WHITE;

   if (logo_color>=0 && logo_color<=7)
      newcolor = table[logo_color];
   if (logo_color>7) {
      newcolor = logo_color+2;
      if (newcolor>=17) /* color 17 is reserved for mouse pointer */
         newcolor++;
   }
   if (newcolor>screen_maxcolor)
      newcolor = screen_maxcolor;
   return newcolor;
}

FIXNUM RevMapColor(ULONG ami_color)
{
   /* convert an Amiga palette entry to a Logo color number */

   int screen_maxcolor=(1<<scrn->RastPort.BitMap->Depth)-1;
   const int table[]={-1,0,7,-1,1,2,3,4,5,6};
   int lc=-1;

   /* the -1 indicates a color Logo shouldn't use */

   if (ami_color>screen_maxcolor)
      ami_color = screen_maxcolor;

   if (ami_color>=0 && ami_color<=9)
      lc=table[ami_color];

   if (lc>=0)
      return (FIXNUM)lc;
   else if (ami_color>=18)
      ami_color--;   /* skip over register 17 */
   return (FIXNUM)ami_color-2;
}


void set_palette(slot,r,g,b)
int slot;
unsigned int r,g,b;
{
   ULONG index = MapColor(slot);
   ULONG ar, ag, ab;

   /* note scaling from 16-bit to 32-bit values */
   ar = r<<16 | 0xffff;
   ag = g<<16 | 0xffff;
   ab = b<<16 | 0xffff;
   SetRGB32(&(scrn->ViewPort),index,ar,ag,ab);
}

void get_palette(slot,r,g,b)
int slot;
unsigned int *r, *g, *b;
{
   ULONG index = MapColor(slot);
   ULONG table[3];

   GetRGB32(scrn->ViewPort.ColorMap,index,1L,table);
   /* convert from Amiga 32-bit to Logo 16-bit values */
   *r = table[0]>>16;
   *g = table[1]>>16;
   *b = table[2]>>16;
}

NODE *lam_version()
{
   /*
      This simply converts the AmigaDOS version string into a list and
      outputs it.
   */
   return parser(make_static_strnode(version));
}


NODE *lam_prefs()
{
   struct ScreenModeRequester *aslsm;
   BOOL result;
   ULONG tags[40], i=0L;

   /*
      This primitive brings up the requester(s) for setting the Amiga
      preferences -- currently limited to screen display mode, but there
      will be more options in the future.
   */

   aslsm = AllocAslRequestTags(ASL_ScreenModeRequest,TAG_DONE);
   if (aslsm==NULL) {
      ami_print("I can't open the screen mode requester.\n");
      return (UNBOUND);
   }

   if (scrn) {
      tags[i++]=ASLSM_Screen;    tags[i++]=(ULONG)scrn;
   }
   tags[i++]=ASLSM_PrivateIDCMP;    tags[i++]=TRUE;
   tags[i++]=ASLSM_TitleText;       tags[i++]=(ULONG)"Logo Screen Mode:";
   tags[i++]=ASLSM_InitialDisplayID;      tags[i++]=prefs.DisplayID;
   tags[i++]=ASLSM_InitialDisplayWidth;   tags[i++]=prefs.DisplayWidth;
   tags[i++]=ASLSM_InitialDisplayHeight;  tags[i++]=prefs.DisplayHeight;
   tags[i++]=ASLSM_InitialDisplayDepth;   tags[i++]=prefs.DisplayDepth;
   tags[i++]=ASLSM_InitialOverscanType;   tags[i++]=prefs.OverscanType;
   tags[i++]=ASLSM_DoWidth;   tags[i++]=TRUE;
   tags[i++]=ASLSM_DoHeight;  tags[i++]=TRUE;
   tags[i++]=ASLSM_DoDepth;   tags[i++]=TRUE;
   tags[i++]=ASLSM_DoOverscanType;   tags[i++]=TRUE;
   tags[i++]=ASLSM_MinWidth;   tags[i++]=640L;
   tags[i++]=ASLSM_MinHeight;  tags[i++]=200L;
   tags[i++]=ASLSM_MinDepth;  tags[i++]=4L;
   tags[i++]=ASLSM_MaxDepth;  tags[i++]=8L;

   tags[i++]=TAG_DONE;
   result = AslRequest(aslsm,(struct TagItem *)tags);

   if (result==FALSE)
      ami_print("New screen mode not accepted.\n");
   else {
      /* read the new values from the requester structure */
      prefs.DisplayID      = aslsm->sm_DisplayID;
      prefs.DisplayWidth   = aslsm->sm_DisplayWidth;
      prefs.DisplayHeight  = aslsm->sm_DisplayHeight;
      prefs.DisplayDepth   = aslsm->sm_DisplayDepth;
      prefs.OverscanType   = aslsm->sm_OverscanType;
      if (save_prefs()) {
         enum Layout relay;

         relay = layout;
         amiga_noscreen();
         amiga_layout(relay);
         cs_helper(FALSE);
      }
   }
   FreeAslRequest(aslsm);
   return (UNBOUND);
}


static struct Region* ClipWindow( struct Window* w)
{
   struct Region* new_region;
   struct Rectangle rect;

   /*
      This function is used only if you are going to open a graphics
      window that has a border, to keep from rendering over Intuition's
      stuff.  Since we are currently using a borderless window, the
      function isn't serving any useful purpose.  I'm keeping it in the
      code just in case we need it later.  Same for UnClipWindow().
   */
   rect.MinX = w->BorderLeft;
   rect.MinY = w->BorderTop;
   rect.MaxX = w->Width - w->BorderRight - 1;
   rect.MaxY = w->Height - w->BorderBottom - 1;

   if ( new_region = NewRegion()) {
      if ( !OrRectRegion(new_region, &rect)) {
         DisposeRegion(new_region);
         return 0;
      }
   }
   return InstallClipRegion(w->WLayer, new_region);
}

static void UnClipWindow( struct Window* w)
{
   struct Region* old_region;

   old_region = InstallClipRegion( w->WLayer, 0);
   if (old_region)
        DisposeRegion(old_region);
}


void announce_closescreen(scrn)
struct Screen *scrn;
{
   /*
      I need to use a public screen so I can open the CON: window and Ed
      (for ledit() on it.  This poses a problem, though.  What if someone
      else opened a visitor window on the screen?  Then the screenclose
      might fail.  So, we have to bug the user about it and try again
      until we can close it successfully.

      Unfortunately, Intuition won't let me put up an EasyRequest()
      without a window to tie it to.  So, I have to open a tiny dummy
      window, then EasyRequest(), then close the window.  It's a
      nuisance, but it works.
   */
   struct EasyStruct psx={
      sizeof(struct EasyStruct),
      0,
      "Closing Screen",
      "I need to close this screen, but there\n\
are visitor windows open on it.  Please\n\
close the windows, then TRY AGAIN.",
      "Try Again"
   };
   struct Window *win;

   win = OpenWindowTags(NULL,    /* dummy window for EasyRequest() */
      WA_Width, 1,
      WA_Top, 1,
      WA_CustomScreen, scrn,
      WA_Backdrop, TRUE,
      WA_Borderless, TRUE
   );

   if (win) {
      (void)EasyRequest(win,&psx,NULL,NULL);
      CloseWindow(win);
   }
}


void amiga_noscreen() {
   if (console) {
      Close(console);
      console = NULL;
      conwin = NULL;
   }
   if (win) {
      /*  UnClipWindow( win); */
      CloseWindow(win);
      win = NULL;
   }
   while (scrn) {
      if (CloseScreen(scrn))
         scrn = NULL;
      else
         announce_closescreen(scrn);
   }
   layout = NOSCREEN;
}

void amiga_splitscreen()
{
   if (console) {
      Write(console,"\0",1L);    /* to auto-display it if necessary */
      conwin = conwin_addr(console);

      conwin_resize(SPLITSCREEN);
/*
      if (conwin->TopEdge<40) {
         ZipWindow(conwin);
         layout = SPLITSCREEN;
      }
*/
      return;
   }

   /* make sure screen and window are open */
   if (scrn==NULL)
      amiga_open_graphics_screen();

   if (win==NULL)
      amiga_open_graphics_window();

   {   /* open the text console window */
      char foo[256];

      sprintf(foo,
"CON:0/%d/%d/%d/Berkeley Amiga Logo/ALT0/%d/%d/%d/SIMPLE/NOCLOSE/SCREEN %s",
            scrn->Height*3/4, scrn->Width, scrn->Height/4,
            scrn->BarHeight+1, scrn->Width, scrn->Height-scrn->BarHeight-1,
            screenname);

      console = Open(foo,MODE_NEWFILE);
      conwin = conwin_addr(console);
      SetMode(console,1);  /* turn buffering off */
   }
   layout = SPLITSCREEN;
}

void amiga_fullscreen()
{
   if (console) {
      Close(console);
      console = NULL;
      conwin = NULL;
   }

   if (scrn==NULL)
      amiga_open_graphics_screen();

   if (win==NULL)
      amiga_open_graphics_window();

   {   /* open the text console window */
      char foo[256];

      sprintf(foo,
"CON:0/%d/%d/%d/Berkeley Amiga Logo/ALT0/%d/%d/%d/AUTO/SIMPLE/NOCLOSE/SCREEN %s",
            scrn->Height*3/4, scrn->Width, scrn->Height/4,
            scrn->BarHeight+1, scrn->Width, scrn->Height-scrn->BarHeight-1,
            screenname);

      console = Open(foo,MODE_NEWFILE);
      SetMode(console,1);  /* turn buffering off */
   }
   layout = FULLSCREEN;
}


void amiga_textscreen()
{
   if (console) {
      Write(console,"\0",1L);    /* to auto-display it if necessary */
      conwin = conwin_addr(console);

      conwin_resize(TEXTSCREEN);

/*
      if (conwin->TopEdge>40) {
         ZipWindow(conwin);
         layout = TEXTSCREEN;
      }
*/
      return;
   }

   if (scrn==NULL)
      amiga_open_graphics_screen();

   if (win==NULL)
      amiga_open_graphics_window();

   {   /* open the text console window */
      char foo[256];

      sprintf(foo,
"CON:0/%d/%d/%d/Berkeley Amiga Logo/ALT0/%d/%d/%d/SIMPLE/NOCLOSE/SCREEN %s",
            scrn->BarHeight+1, scrn->Width, scrn->Height-scrn->BarHeight-1,
            scrn->Height*3/4, scrn->Width, scrn->Height/4,
            screenname);

      console = Open(foo,MODE_NEWFILE);
      conwin = conwin_addr(console);
      SetMode(console,1);  /* turn buffering off */
   }
   layout = TEXTSCREEN;
}


void amiga_layout(al)
enum Layout al;
{
   switch (al) {
      case SPLITSCREEN:
         amiga_splitscreen();
         break;
      case FULLSCREEN:
         amiga_fullscreen();
         break;
      case TEXTSCREEN:
         amiga_textscreen();
         break;
      case NOSCREEN:
         amiga_noscreen();
   }
}

int check_amiga_stop()
{
   ULONG signal = CheckSignal(SIGBREAKF_CTRL_C|SIGBREAKF_CTRL_D);

   if (signal&SIGBREAKF_CTRL_C) {
      logo_stop();
      return 1;
   }
   if (signal&SIGBREAKF_CTRL_D) {
      logo_pause();
      return 2;
   }
   return 0;
}


struct Window *conwin_addr(console)
BPTR console;
{
   struct MsgPort *conport;
   struct InfoData *infodata;
   struct IORequest *ioreq;
   struct ConUnit *conunit;
   struct Window *opval=NULL;

   if (!(conport = (struct MsgPort *)(((struct FileHandle *)(console<<2))->fh_Type)))
      return NULL;

   if (!(infodata = AllocVec(sizeof(struct InfoData),MEMF_PUBLIC|MEMF_CLEAR)))
      return NULL;

   if (!DoPkt(conport,ACTION_DISK_INFO,(LONG)infodata>>2,0,0,0)) {
      FreeVec(infodata);
      return NULL;
   }

   if (!(ioreq = (struct IORequest *)infodata->id_InUse)) {
      FreeVec(infodata);
      return NULL;
   }

   if (!(conunit = (struct ConUnit *)ioreq->io_Unit)) {
      FreeVec(infodata);
      return NULL;
   }

   opval = infodata->id_VolumeNode;
   FreeVec(infodata);
   return opval;
}


void conwin_resize(new_layout)
enum Layout new_layout;
{
   int left, top, width, height;
   BOOL changed=FALSE;

   if (console==NULL || conwin==NULL)
      return;

   switch (new_layout) {
      case TEXTSCREEN:
         left   = 0;
         top    = scrn->BarHeight+1;
         width  = scrn->Width;
         height = scrn->Height-scrn->BarHeight-1;
         break;
      case SPLITSCREEN:
         left   = 0;
         top    = scrn->Height*3/4;
         width  = scrn->Width;
         height = scrn->Height/4;
         break;
      default:
         return;
   }
   ChangeWindowBox(conwin,left,top,width,height);
   layout = new_layout;
}


void amiga_wait(time)
unsigned int time;
{
   ULONG chunk, ticks=time*50/60;   /* convert to 50ths of a second */

   while (ticks) {
      chunk = ticks;
      if (chunk>25)
         chunk = 25;
      Delay(chunk);
      ticks -= chunk;
      if (check_amiga_stop()==1)
         break;
   }
}

void amiga_init(int argc, char *argv[])
{
   /* Logo requires Intuition version 39 or greater (Amiga OS 3.0+) */
   IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",39);
   if (IntuitionBase!=NULL) {
      layout = NOSCREEN;
      amiga_textscreen();
      cs_helper(FALSE);
   }
}

void amiga_deinit(void)
{
   if (console) {
      Close(console);
      console = NULL;
      conwin = NULL;
   }
   if (win) {
      /* UnClipWindow( win); */
      CloseWindow(win);
      win = NULL;
   }
   while (scrn) {
      if (CloseScreen(scrn))
         scrn = NULL;
      else
         announce_closescreen(scrn);
   }
   layout = NOSCREEN;
   CloseLibrary((struct Library *)IntuitionBase);
}

/* Normally this routine would contain an event loop like the one given
** in the chapter "Intuition Input and Output Methods".  Here we just
** wait for any messages we requested to appear at the Window's port.
*/
VOID handle_window_events(struct Window *win)
{
    WaitPort(win->UserPort);
}

/* Text IO functions */
#define CSI 0x9B
extern char so_arr[];
extern char se_arr[];

/* Initialization */
void ami_term_init(void)
{
    /* code for green text on black background */
    so_arr[0] = (char)CSI;
    strcpy( &(so_arr[1]), "0;35;41m");

    /* return console to normal */
    se_arr[0] = (char)CSI;
    strcpy( &(se_arr[1]), "0;39;39m");
}


void get_con_position()
{
   int index, len;
   char inbuf[41];

   if (console) {
      Flush(console);
      SetMode(console,1);  /* turn buffering off */
      Write(console,"\x9b\x36\x6e",3L);   /* requesting status */
      len = (int)Read(console,inbuf,40L);
      inbuf[len]='\0';  /* just making sure it's terminated */
      for (index=0; index<40; index++)
         if (inbuf[index]=='\x9b') {
            sscanf(inbuf+index,"\x9b%d;%dR",&y_coord,&x_coord);
            break;
         }
   }
}


/* Clear the window */
void ami_clear_text(void)
{
    char control[20];

    control[0] = 0x0C;
    control[1] = 0;
    if (console) {
        FPuts(console,control);
        Flush(console);
    } else
        puts(control);
}

/* Position in window */
void ami_gotoxy( int x, int y)
{
   char bf[40];
   sprintf(bf,"%c%d;%dH", CSI, y, x);
   if (console) {
      FPuts(console,bf);
      Flush(console);
   } else
      printf(bf);
}

void ami_print(foo)
char *foo;
{
    /*
        Print to AmigaDOS console if it's available, otherwise stdout.
    */
    if (console)
        FPuts(console,foo);
    else
        printf(foo);
}


/************************************************************/

/* NOTE NOTE NOTE:  graphics.c really really believes that the top left
 * corner of the screen has hardware coords (0,0).
 */

/************************************************************/
/* These are the machine-specific graphics definitions.  All versions must
   provide a set of functions analogous to these. */
void erase_screen( void)
{
    SetRast( win->RPort, win->RPort->BgPen);
}

void save_pen(p)
pen_info *p;
{
    p->x =       win->RPort->cp_x;
    p->y =       win->RPort->cp_y;
    p->vis =     pen_vis;
    p->fcolor =  GetAPen(win->RPort);
    p->bcolor =  GetBPen(win->RPort);
    p->pattern = win->RPort->LinePtrn;
    p->mode =    GetDrMd(win->RPort);
}

void restore_pen(p)
pen_info *p;
{
   SetABPenDrMd(win->RPort,p->fcolor,p->bcolor,p->mode);
   Move(win->RPort,p->x,p->y);
   set_pen_vis(p->vis);
   SetDrPt(win->RPort, p->pattern);
}

NODE *Get_node_pen_pattern()
{
    return(cons(make_intnode(-1)), NIL);
}

NODE *Get_node_pen_mode()
{
   if ( 0/* in_erase_mode */)
      return(make_static_strnode("erase"));
   if ( 0 /* current_write_mode == FG_MODE_XOR */ )
      return(make_static_strnode("reverse"));
   return(make_static_strnode("paint"));
}

void logofill()
{
    ; /* fg_fill(ztc_x, MaxY-ztc_y, turtle_color, turtle_color); */
}

/* end of listing */
