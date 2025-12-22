/* Menus.c */
/* Compiled with Lattice C v5.02                                     */
/* Compiler invoked with: lc -b1 -cfist -L -v -ms                    */

/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <libraries/dos.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#ifdef LATTICE
#include <proto/all.h>
int CXBRK(void) {return(0);}
#endif

#include "Menus.h"

/* Use lowest non-obsolete version that supplies the functions you need. */
#define LIB_REV 33

/* prototypes */
UBYTE    handleIDCMP(struct Window *);
VOID     OpenAll(VOID);
VOID     cleanExit(int);

/* prototypes for functions used to determine menu sizing */
BOOL     AdjustMenus(struct Menu *, struct TextAttr *);
VOID     AdjustItems(struct RastPort *, struct MenuItem *, struct TextAttr *,
                     USHORT, USHORT, USHORT, USHORT);
VOID     AdjustText(struct  IntuiText *text, struct  TextAttr *attr);
USHORT   MaxLength(struct RastPort *, struct MenuItem *, USHORT);

/* Globals */
struct   IntuitionBase *IntuitionBase = NULL;
struct   GfxBase       *GfxBase = NULL; 
struct   Window *window = NULL;

VOID     main(int argc, char *argv[])
{
/* Declare variables here */
ULONG  signalmask, signals;
UBYTE  done = 0;

OpenAll();

/* Set up the signals that you want to hear about ... */
signalmask = 1L << window->UserPort->mp_SigBit;

/* And wait to hear from your signals */      
while( !done )
   {
   signals = Wait(signalmask);    
   if(signals & signalmask)
      done = handleIDCMP(window);
   };

/* Exit the program */
cleanExit(RETURN_OK);
}


/* Handle the IDCMP messages */
UBYTE handleIDCMP( struct Window *win )
{
UBYTE  flag = 0;
USHORT code, selection, flags;
struct IntuiMessage *message = NULL;
ULONG  class, menuNum, itemNum, subNum;

/* Examine pending messages */
while(message = (struct IntuiMessage *)GetMsg(win->UserPort))
   {
   class = message->Class;
   code = message->Code;
 
/* When we're through with a message, reply */
   ReplyMsg((struct Message *)message);

/* See what events occurred */
   switch( class )
      {
      case CLOSEWINDOW:
         flag = 1;
         break;
      case MENUPICK:
         selection = code;
         while(selection != MENUNULL)
            {
            menuNum = MENUNUM(selection);
            itemNum = ITEMNUM(selection);
            subNum  = SUBNUM(selection);
            flags = ((struct MenuItem *)
                    ItemAddress(FirstMenu,(LONG)selection))->Flags;
            printf("Selected ");
            if(flags&CHECKED)
                printf("(Checked) ");
            switch( menuNum )
               {
               case 0:    /* Project Menu */
                  switch(itemNum)
                     {
                     case 0:
                        printf("New\n");
                        break;
                     case 1:
                        printf("Open\n");
                        break;
                     case 2:
                        printf("Save\n");
                        break;
                     case 3:
                        printf("Save As\n");
                        break;
                     case 4:
                        printf("Print ");
                        switch(subNum)
                           {
                           case 0:
                              printf("NLQ\n");
                              break;
                           case 1:
                              printf("Draft\n");
                              break;
                           }
                        break;
                     case 5:
                        printf("About\n");
                        break;
                     case 6:
                        printf("Quit\n");
                        flag = 1;
                        break;
                     default:
                        break;
                     } /* end switch */
                  break;
               case 1:    /* Edit Menu */
                  switch(itemNum)
                     {
                     case 0:
                        printf("Undo\n");
                        break;
                     case 1:
                        printf("Cut\n");
                        break;
                     case 2:
                        printf("Copy\n");
                        break;
                     case 3:
                        printf("Paste\n");
                        break;
                     case 4:
                        printf("Erase All\n");
                        break;
                     default:
                        break;
                     } /* end switch */
                  break;
               case 2:    /* Preferences Menu */
                  switch(itemNum)
                     {
                     case 0:
                        printf("Sound\n");
                        break;
                     case 1:
                        printf("Auto Save\n");
                        break;
                     case 2:
                        printf("Have Your Cake\n");
                        break;
                     case 3:
                        printf("Eat It Too\n");
                        break;
                     default:
                        break;
                     }
                  break;
               default:
                  break;
               } /* end switch */
            selection = ((struct MenuItem *)ItemAddress
              (FirstMenu,(LONG)selection))->NextSelect;
         } /* end while */
         break; /* case of MENUPICK */
      default:
         break;
      } /* end switch */
   } /* end while */
return(flag);
}


/* Open the needed libraries, windows, etc. */
VOID     OpenAll(VOID)
{
/* Open the Intuition Library */
IntuitionBase = (struct IntuitionBase *)
    OpenLibrary( "intuition.library",LIB_REV);
if(IntuitionBase == NULL)
    cleanExit(RETURN_WARN);

/* Open the Graphics Library */
GfxBase = (struct GfxBase *)
    OpenLibrary("graphics.library", LIB_REV);
if(GfxBase == NULL)
    cleanExit(RETURN_WARN);

/* Open the window */
window = OpenWindow(&NewWindow);
if(window == NULL)
    cleanExit(RETURN_WARN);

/* Give a brief explanation of the program */
PrintIText(window->RPort,&WinText[1],0,0);

/* Adjust the menu to conform to the font (TextAttr) */
AdjustMenus(FirstMenu, window->WScreen->Font);

/* attach the menu to the window */
SetMenuStrip(window, FirstMenu);
}

/* Free up all the resources that we where using */
VOID     cleanExit(int returnValue)
{
if(window)
   {
/* If there is a menu strip, then remove it */
   if(window->MenuStrip)
      ClearMenuStrip(window);

/* Close the window */
   CloseWindow(window);
   }

/* Close the library, and then exit */
if(GfxBase)
   CloseLibrary((struct Library *)GfxBase);

if(IntuitionBase)
   CloseLibrary((struct Library *)IntuitionBase);
exit(returnValue);
}

/* ----------------------------------------------------------------------
 *  The following routines adjust an entire menu system to conform to
 *  the specified fonts' width and height.  Allows for Proportional Fonts.
 *  This is necessary for a clean look regardless of what the users
 *  preference in Fonts may be.  Using these routines, you don't need to
 *  specify TopEdge, LeftEdge, Width or Height in the MenuItem structures.
 *
 *  This set of routines does NOT check/correct if the menu runs off the
 *  screen due to large fonts, too many items, lo-res screen.
 */

BOOL     AdjustMenus(struct Menu *firstmenu, struct TextAttr *attr)
{
struct  RastPort  textrp = {0};              /* Temporary RastPort */
struct  Menu      *menu;
struct  TextFont  *font;                     /* Font to use */
USHORT            start, width, height, space;
BOOL              retval = FALSE;

/* open the font */
if((font = OpenFont(attr)))
    {
    SetFont(&textrp, font);       /* Put font into temporary RastPort */

    width = font->tf_XSize;       /* Get the Width of the Font */

    /* To prevent crowding of the Amiga key when using COMMSEQ,
     * don't allow the items to be less than 8 pixels high.
     */
    height = (font->tf_YSize < 8) ? 8 : font->tf_YSize;
    height++;

    start = 2;                    /* Set Starting Pixel */

    /* Step thru the menu structure and adjust it */
    menu = firstmenu;
    while(menu)
        {
        menu->LeftEdge = start;
        menu->Width = space =
           TextLength(&textrp, menu->MenuName,
                (LONG)strlen(menu->MenuName)) + width;
        AdjustItems(&textrp, menu->FirstItem, attr, width, height, 0, 0);
        menu = menu->NextMenu;
        start += (space + (width * 2));
        }
    CloseFont(font);              /* Close the Font */
    retval = TRUE;
    }
return(retval);
}

/* Adjust the MenuItems and SubItems */
VOID
AdjustItems(struct RastPort *txtrp, struct MenuItem *fi,
            struct TextAttr *atr, USHORT wdth, USHORT hght,
            USHORT lvl, USHORT edge)
{
struct   MenuItem *item = fi;
register USHORT   num;
USHORT   strip_width, sub_edge;

if(fi==NULL)    return;
strip_width = MaxLength(txtrp, item, wdth);
num = 0;
while(item)
    {
    item->TopEdge = (num * hght) - lvl;
    item->LeftEdge = edge;
    item->Width = strip_width;
    item->Height = hght;
    sub_edge = strip_width - wdth;
    AdjustText((struct IntuiText *)item->ItemFill, atr);
    AdjustItems(txtrp, item->SubItem, atr, wdth, hght, 1, sub_edge);
    item = item->NextItem;
    num++;
    }
}


/* Steps thru each item to determine the maximum width of the strip */
USHORT   MaxLength(struct RastPort *txtrp, struct MenuItem *fi, USHORT width)
{
USHORT   maxval = 0, textlen;
struct   MenuItem  *item = fi;
struct   IntuiText *itext;

while(item)
    {
    if(item->Flags&COMMSEQ)
        {
        width += (width + COMMWIDTH);
        break;
        }
    item = item->NextItem;
    }
item = fi;
while(item)
    {
    itext = (struct IntuiText *)item->ItemFill;
    textlen = itext->LeftEdge +
              TextLength(txtrp, itext->IText,
                          (LONG)strlen(itext->IText)) + width;
/* returns the greater of the two */
    maxval = (textlen<maxval)?maxval:textlen;
    item = item->NextItem;
    }
return(maxval);
}

/* Adjust the MenuItems font attribute */
VOID     AdjustText(struct  IntuiText *text, struct  TextAttr *attr)
{
struct IntuiText *nt;
nt = text;
while(nt)
    {
    nt->ITextFont = attr;
    nt = nt->NextText;
    }
}
