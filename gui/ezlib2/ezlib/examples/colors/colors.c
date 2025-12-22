/* This program uses EzLib to make a custom screen and open a color requestor
 * window.  I've kept things simple and straightforward so that I can
 * demonstrate how to use EzLib, not how to write the worlds greatest color
 * requestor.
 *
 *  Dominic Giampaolo, July 1991
 */
#include "/inc.h"      /* use the include file one level up */
#include <ezlib.h>

/* forward declarations */
void setup_colors(struct Screen *screen);
void setup_sliders(int cur_color);
void draw_colors(struct Window *win, int left_edge, int top_edge, int width, int height);
void quit(void);
void set_red(), set_green(), set_blue();

struct color
{
  UBYTE red, green, blue;
};

struct color colors[4]; 	 /* we'll make a 2 bitplane screen */


#define MY_FLAGS  (WINDOWDRAG | ACTIVATE)
#define MY_IDCMP  (MOUSEBUTTONS | GADGETUP | GADGETDOWN)

struct Screen *screen;
struct Window *win;
struct Gadget *red_slider   = NULL,
	      *green_slider = NULL,
	      *blue_slider  = NULL,
	      *quit_gadg    = NULL;

main()
{
 struct Gadget *gadg;
 struct IntuiMessage *msg;

 SHORT top_edge, left_edge, width, height;
 SHORT x,y, box_le, box_te, box_w, box_h;
 int cur_color, new_val;

 screen = CreateScreen(HIRES, 2);
 if (screen == NULL)
   { MSG("Can't open screen.\n"); exit(10); }

 setup_colors(screen);

 /* make the window */
 win = CreateWindow(screen, 0,0, 300,100, MY_FLAGS, MY_IDCMP);
 if (win == NULL)
   {
     KillScreen(screen);
     MSG("Can't open window.\n");
     exit(20);
   }
 SetWindowTitles(win, "Color Chooser done with EzLib", (char *)-1);

 top_edge  = win->BorderTop + win->RPort->TxHeight + win->RPort->TxBaseline;
 left_edge = win->BorderLeft + 5;
 width	   = 20;
 height    = 50;
 cur_color = 0;

 red_slider = MakePropGadget(win, left_edge,top_edge,width,height, FREEVERT, 1);
 Move(win->RPort, left_edge+4, top_edge - win->RPort->TxBaseline);
 Print(win->RPort, "R");

 left_edge +=  width + 10;
 green_slider = MakePropGadget(win, left_edge,top_edge,width,height, FREEVERT, 2);
 Move(win->RPort, left_edge+4, top_edge - win->RPort->TxBaseline);
 Print(win->RPort, "G");

 left_edge +=  width + 10;
 blue_slider = MakePropGadget(win, left_edge,top_edge,width,height, FREEVERT, 3);
 Move(win->RPort, left_edge+4, top_edge - win->RPort->TxBaseline);
 Print(win->RPort, "B");

 if (red_slider == NULL || green_slider == NULL || blue_slider == NULL)
   quit();

 /* now setup the sliders for the current color */
 setup_sliders(cur_color);

 /* now draw the box and its colors */
 box_le = left_edge += width + 10;
 box_te = top_edge;
 box_w	= width  = 50;
 box_h	= height = 60;

 draw_colors(win, box_le, box_te, box_w, box_h);

 left_edge += width + 10;
 quit_gadg = MakeBoolGadget(win, left_edge,top_edge, "Quit", 4);
 if (quit_gadg == NULL)
   quit();

 /* display is now set up, let's get to the main event loop */
 while(1)
  {
    WaitPort(win->UserPort);

    while((msg = (struct IntuiMessage *)GetMsg(win->UserPort)) != NULL)
      {
	switch(msg->Class)
	 {
	   case GADGETDOWN : gadg = (struct Gadget *)msg->IAddress;
			     if (gadg->GadgetID == 1)  /* red_slider */
			       {
				 RealtimeProp(win, red_slider, set_red, &cur_color);
			       }
			     else if (gadg->GadgetID == 2) /* green_slider */
			       {
				 RealtimeProp(win, green_slider, set_green, &cur_color);
			       }
			     else if (gadg->GadgetID == 3) /* blue_slider */
			       {
				 RealtimeProp(win, blue_slider, set_blue, &cur_color);
			       }
			     break;

	   case GADGETUP : gadg = (struct Gadget *)msg->IAddress;
			   if (gadg->GadgetID == 1)  /* red_slider */
			     {
			       new_val = GetPropValue(red_slider);
			       set_red(win, &cur_color, new_val);
			     }
			   else if (gadg->GadgetID == 2) /* green_slider */
			     {
			       new_val = GetPropValue(green_slider);
			       set_green(win, &cur_color, new_val);
			     }
			   else if (gadg->GadgetID == 3) /* blue_slider */
			     {
			       new_val = GetPropValue(blue_slider);
			       set_blue(win, &cur_color, new_val);
			     }
			   else if (gadg->GadgetID == 4)  /* quit gadget */
			     {
			       ReplyMsg((struct Message *)msg);
			       quit();
			     }
			   break;

	   case MOUSEBUTTONS : x = msg->MouseX; y = msg->MouseY;
			       if(x < box_le || x > box_le+box_w)
				 break;
			       if(y < box_te || y > box_te+box_h)
				 break;
			       y -= box_te;

			       if (y > 0 && y < 15)
				 cur_color = 0;
			       else if (y >= 15 && y < 30)
				 cur_color = 1;
			       else if (y >= 30 && y < 45)
				 cur_color = 2;
			       else if (y >= 45 && y < 60)
				 cur_color = 3;
			       setup_sliders(cur_color);
			       break;

	   default : break;

	 } /* end of switch */

	ReplyMsg((struct Message *)msg);
      }  /* end of while GetMsg */

  } /* end of while(1) */
}

void set_red(struct Window *win, int *cur_color, int new_val)
{
  char buff[] = "  ";
  int x, y;

  if (new_val < 10)
    { buff[0] = ' '; buff[1] = '0' + new_val; }
  else
    { buff[0] = '1'; buff[1] = '0' + (new_val - 10); }

  x = red_slider->LeftEdge;
  y = red_slider->TopEdge + red_slider->Height + win->RPort->TxHeight;
  Move(win->RPort, x, y);
  Text(win->RPort, buff, 2);

  colors[*cur_color].red = new_val;
  SetRGB4(&win->WScreen->ViewPort, *cur_color,
	  colors[*cur_color].red,
	  colors[*cur_color].green,
	  colors[*cur_color].blue);
}

void set_green(struct Window *win, int *cur_color, int new_val)
{
  char buff[] = "  ";
  int x, y;

  if (new_val < 10)
    { buff[0] = ' '; buff[1] = '0' + new_val; }
  else
    { buff[0] = '1'; buff[1] = '0' + (new_val - 10); }

  x = green_slider->LeftEdge;
  y = green_slider->TopEdge + green_slider->Height + win->RPort->TxHeight;
  Move(win->RPort, x, y);
  Text(win->RPort, buff, 2);

  colors[*cur_color].green = new_val;
  SetRGB4(&win->WScreen->ViewPort, *cur_color,
	  colors[*cur_color].red,
	  colors[*cur_color].green,
	  colors[*cur_color].blue);
}

void set_blue(struct Window *win, int *cur_color, int new_val)
{
  char buff[] = "  ";
  int x, y;

  if (new_val < 10)
    { buff[0] = ' '; buff[1] = '0' + new_val; }
  else
    { buff[0] = '1'; buff[1] = '0' + (new_val - 10); }

  x = blue_slider->LeftEdge;
  y = blue_slider->TopEdge + blue_slider->Height + win->RPort->TxHeight;
  Move(win->RPort, x, y);
  Text(win->RPort, buff, 2);

  colors[*cur_color].blue = new_val;
  SetRGB4(&win->WScreen->ViewPort, *cur_color,
	  colors[*cur_color].red,
	  colors[*cur_color].green,
	  colors[*cur_color].blue);
}


void setup_colors(struct Screen *screen)
{
 PickHighlightColors(screen);

 /* set up some garish colors the user will want to change */
 SetColor(screen, 0, BLUE);
 colors[0].red = 0; colors[0].green = 0; colors[0].blue = 15;

 SetColor(screen, 1, BLACK);
 colors[1].red = 0; colors[1].green = 0; colors[1].blue = 0;

 SetColor(screen, 2, WHITE);
 colors[2].red = 15; colors[2].green = 15; colors[2].blue = 15;

 SetColor(screen, 3, RED);
 colors[3].red = 15; colors[3].green = 0; colors[3].blue = 0;
}


void setup_sliders(int cur_color)
{
 SetPropGadg(win, red_slider, colors[cur_color].red, 1, 16);
 set_red(win, &cur_color, colors[cur_color].red);

 SetPropGadg(win, green_slider, colors[cur_color].green, 1, 16);
 set_green(win, &cur_color, colors[cur_color].green);

 SetPropGadg(win, blue_slider, colors[cur_color].blue, 1, 16);
 set_blue(win, &cur_color, colors[cur_color].blue);
}


void draw_colors(struct Window *win, int left_edge, int top_edge, int width, int height)
{
 Move(win->RPort, left_edge, top_edge);
 Draw(win->RPort, left_edge + width, top_edge);
 Draw(win->RPort, left_edge + width, top_edge + height);
 Draw(win->RPort, left_edge, top_edge + height);
 Draw(win->RPort, left_edge, top_edge);
 SetAPen(win->RPort, 1);
 RectFill(win->RPort, left_edge+2,top_edge+15, left_edge+width-2, top_edge+30);
 SetAPen(win->RPort, 2);
 RectFill(win->RPort, left_edge+2,top_edge+30, left_edge+width-2, top_edge+45);
 SetAPen(win->RPort, 3);
 RectFill(win->RPort, left_edge+2,top_edge+45, left_edge+width-2, top_edge+59);
}


void quit(void)
{
  KillGadget(win, quit_gadg);
  KillGadget(win, blue_slider);
  KillGadget(win, green_slider);
  KillGadget(win, red_slider);
  KillWindow(win);
  KillScreen(screen);
  exit(0);
}

