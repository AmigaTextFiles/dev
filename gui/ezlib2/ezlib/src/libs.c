/*    This file contains the routines for opening and closing libraries.
 * Notice that all the library bases are defined here.	You can access
 * them in your code as extern's if you wish, but they are defined here.
 *
 *    Oh, it *is* important that the library bases be initialized to zero.
 *
 * Dominic Giampaolo © 1991
 */
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


struct GfxBase	     *GfxBase	     = NULL;
struct IntuitionBase *IntuitionBase  = NULL;
struct Library	     *DiskfontBase   = NULL;
struct ArpBase	     *ArpBase	     = NULL;
struct Library	     *TranslatorBase = NULL;
struct RxsLib	     *RexxSysBase    = NULL;

OpenLibs(int which_ones)
{
 register int errs = NULL;
 struct Screen tmp;

 if (which_ones & GFX)
   if ( (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 33)) == NULL)
    {
      if(Output())
	MSG("No Graphics.library.\n");
      errs |= GFX;
    }

 if (which_ones & INTUI)
  {
    if ( (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 33)) == NULL)
     {
       if (Output())
	 MSG("No Intuition.library.\n");
       errs |= INTUI;
     }

    /* we do this so that the highlight colors are chosen correctly */
    GetScreenData((char *)&tmp, sizeof(struct Screen), WBENCHSCREEN, NULL);
    PickHighlightColors(&tmp);
  }

 if (which_ones & ARP)
   if ( (ArpBase = (struct ArpBase *)OpenLibrary("arp.library", 34)) == NULL)
    {
      if (Output())
	MSG("No Arp.library in your LIBS directory.\n");
      errs |= ARP;
    }

 if (which_ones & DISKFONT)
   if ( (DiskfontBase = (struct Library *)OpenLibrary("diskfont.library", 33)) == NULL)
    {
     if (Output())
       MSG("No Diskfont.library in your LIBS: directory.\n");
     errs |= DISKFONT;
    }

 if (which_ones & TRANSLATOR)
   if ( (TranslatorBase = (struct Library *)OpenLibrary("translator.library", 33)) == NULL)
    {
      if (Output())
	MSG("No Translator.library in your LIBS: directory.\n");
      errs |= TRANSLATOR;
    }

 if (which_ones & REXX)
   if ( (RexxSysBase = (struct RxsLib *)OpenLibrary("rexxsyslib.library", 0)) == NULL)
    {
      if (Output())
	MSG("No rexxsyslib.library in your LIBS: directory.\n");

      errs |= REXX;
    }

 if ( errs )
   { CloseLibs(which_ones); return NULL; }

 return 1;
}

void CloseLibs(int which_ones)
{
 if (which_ones & DISKFONT)
   if (DiskfontBase > (struct Library *)100)
     { CloseLibrary((void *)DiskfontBase); DiskfontBase = NULL; }

 if (which_ones & ARP)
   if (ArpBase > (struct ArpBase *)100)
     { CloseLibrary((void *)ArpBase); ArpBase = NULL; }

 if (which_ones & INTUI)
   if (IntuitionBase > (struct IntuitionBase *)100)
     { CloseLibrary((void *)IntuitionBase); IntuitionBase = NULL; }

 if (which_ones & GFX)
   if (GfxBase > (struct GfxBase *)100)
     { CloseLibrary((void *)GfxBase); GfxBase = NULL; }

 if (which_ones & TRANSLATOR)
   if (TranslatorBase > (struct Library *)100)
     { CloseLibrary((void *)TranslatorBase); TranslatorBase = NULL; }

 if (which_ones & REXX)
   if (RexxSysBase > (struct RxsLib *)100)
     { CloseLibrary((void *)RexxSysBase); RexxSysBase = NULL; }
}

