#include <exec/types.h>
#include <intuition/intuitionbase.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>

struct IntuitionBase *ib;

struct Window *win;
struct Screen *scr;
struct Layer  *lay;
struct Hook   *hook;

main()
{
 ib=OpenLibrary("intuition.library",0L);
 scr=ib->FirstScreen;
 win=scr->FirstWindow;
 while(win->NextWindow!=NULL) win=win->NextWindow;
 lay=win->WLayer;
 hook=lay->BackFill;
 printf("s=%lx\nw=%lx\nl=%lx\nhook=%lx\n",scr,win,lay,hook);
 lay->BackFill=NULL;
}

