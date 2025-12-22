/* This program "demos" most of the features of EzLib.  It's pretty dumb
 * about laying things out in a pleasing manner, but I don't want to
 * obscure the code with all kinds of layout calculations.  The intent
 * is for you to get the idea of how to use the EzLib functions.
 *
 * The big thing to notice is how much EzLib abstracts the code you are
 * writing.  You no longer have to write gobs and gobs of redundant
 * code to deal with screens, and windows.
 *
 * Also notice, that you still should error check results from the ez.lib
 * functions.  This is the Amiga and not a protected memory environment,
 * so failure to check the return values could be dangerous.
 *
 *    Dominic Giampaolo
 */
#include "inc.h"            /* get all the amiga includes needed */

#include <ezlib.h>	    /* get in the door with ez.lib */

/* proto */
void draw_stuff(struct Window *win);

#define DEPTH 2



void main(void)
{
 struct Screen *screen=NULL;	 /* our custom screen		*/
 struct Window *wind=NULL;	 /* our window			*/
 struct Gadget *gadg=NULL;	 /* do-nothing gadget		*/
 struct Gadget *gadg2=NULL;	 /* do-nothing gadget		*/
 struct RastPort *rp;		 /* rastport for Gfx calls	*/
 struct TextFont *tf=NULL;	 /* disk font ptr		*/
 char		 *string=NULL;	 /* return ptr from GetString() */


 /* in reality, this call to OpenLibs() isn't even needed as it will happen
  * in CreateScreen() or MakeWindow().  However it makes things look more
  * symetric with the CloseLibs() call at the end (which you really should
  * make).
  */
 if (OpenLibs(GFX|INTUI) == NULL)
   {  MSG("No libraries?\n"); exit(10L); }


 screen = CreateScreen(HIRES, DEPTH); /* gets a 640x200 4 color screen */
 if (screen == NULL)
  { CloseLibs(ALL_LIBS); exit(20); }  /* safe exit just in case... */

 /* set up some some nice colors */
 SetColor(screen, 0, GREY);   SetColor(screen, 2, BLACK);
 SetColor(screen, 1, WHITE);  SetColor(screen, 3, INDIGO);

 /* You should do this on any custom screen you want to use EzLib
  * gadgets on.  It picks the highlight colors for EzLib to use on
  * a custom screen.
  */
 PickHighlightColors(screen);

 /* notice that even though these window dimensions are totally off, they
  * are corrected in MakeWindow()
  */
 wind = MakeWindow(screen, 0,0, -1,-1);
 if (wind == NULL)
  { KillScreen(screen); CloseLibs(ALL_LIBS); exit(60); }   /* exit path */

 SetWindowTitles(wind, "EzLib Demo Program", (char *)-1);

 rp = wind->RPort;

 /* if you happen to have this font in your fonts: directory, you're all
  * set.  If not, no biggie - we'll just use the default font.
  *
  * Also note that the .font extenstion is optional...
  */
 tf = GetFont("times.font", 12);
 if (tf != NULL)
   SetFont(rp, tf);

 /* get an input string from the user. */
 string = GetString(wind, "Enter a string here:", "A default string");

 if (string != NULL)
  {
    Move(rp, 220, 80);
    Print(rp, "You typed :");   /* ezlib #define for printing window text */
    Print(rp, string);
    FreeMem(string, strlen(string)+1);
  }


 draw_stuff(wind);       /* draw some simple graphics in the window */


 /* create two simple do-nothing gagdet */
 gadg  = MakeBoolGadget(wind,   190, 175, "Don't have a cow dude!", 43);
 gadg2 = MakeStringGadget(wind, 190, 150, 200, "EzLib is fun, man", 44);


 SetAPen(rp, 1);
 Move(rp, 200, 110);
 Print(rp, "Ezlib makes programming fun.");     /* be obnoxious here */
 Move(rp, 190, 130);
 Print(rp, "Click the close gadget to exit");


 /* since the window has a close gadget, the first message will be from
  * the user clicking the CLOSE gadget.  Soooooo, we can just exit.
  */
 WaitPort(wind->UserPort);

 GetYN(wind, "Boy this sure is neat huh?");   /* just be annoying */

 /* here we go through the motions of closing up shop */

 if (tf)
   CloseFont(tf);  /* close the font we opened with the call to getfont() */


 /* error checking is done for us (i.e. killgadget handles NULL values) */
 KillGadget(wind, gadg);
 KillGadget(wind, gadg2);

 KillWindow(wind);           /* close the window with error checking       */
 KillScreen(screen);         /* do same for the screen                     */

 CloseLibs(ALL_LIBS);        /* close any opened libraries here            */

 exit(0);                    /* and finally call the normal exit() routine */
}


/* this function will draw some simple graphics into your rastport.
 * Some numbers are hardcoded, yes, but this is just a demo....
 */
void draw_stuff(struct Window *win)
{
 int i;
 int le, te, width, height;
 struct RastPort *rp;

 if (win == NULL)
   return;

 rp = win->RPort;

 le = win->BorderLeft;
 te = win->BorderTop;
 width = win->Width - win->BorderLeft - win->BorderRight;
 height = win->Height - win->BorderTop - win->BorderBottom;

 /* lets just draw some stuff on the screen */
 for(i=te; i < (height - te); i++ )
  {
    /* ezlib #define for drawing lines */
    Line(rp, le, i, width, (height - i) );

    /* change colors for each line */
    SetAPen(rp, i % 4);
  }

 for(i=te*2; i < te+50; i++)
  {
    Line(rp, le, i, width, i);
    Circle(rp, width/2, i, te);       /* ezlib #define for drawing circles */
    SetAPen(rp, i % 4);
 }
}

