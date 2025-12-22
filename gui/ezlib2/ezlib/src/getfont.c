/*    This file contains a routine to open a disk based font.  It returns
 * a pointer to a TextFont structure, which if it isn't NULL  can be
 * immediatly SetFont()'ed into your rastport.
 *
 * The arguments are : name : a character string with the name/pathname of
 *		       the font you want to open.
 *
 *		       size : an integer with the size of the font you want
 *
 *    It tries to be smart about font names, taking care if you didn't
 * append a ".font" to the font name.
 *
 *  Dominic Giampaolo © 1991
 */
#include <string.h>
#include "inc.h"    /* make sure to get the amiga includes */

#include "ezlib.h"


extern struct Library *DiskfontBase;


struct TextFont *GetFont(char *name, int size)
{
  struct TextFont *txfont;
  struct TextAttr txattr;
  LONG len;
  char *fontname, *test, *ext = ".font";
  UBYTE pre_opened=FALSE;

  if (name == NULL || size < 1)
    return NULL;

  if (DiskfontBase == NULL)
    DiskfontBase = (struct Library *)OpenLibrary("diskfont.library",0L);
  else
    pre_opened = TRUE;

  if (DiskfontBase == NULL)    /* just a quickie failsafe....  */
    return NULL;

  len = strlen(name) + 6;
  fontname = (char *)AllocMem(len, 0L);
  if (fontname == NULL)
    return NULL;

  strcpy(fontname, name);
  test = strrchr(fontname, '.');
  /* if true, then they are not equal */
  if (test == NULL || strcmp(test, ext))
    strcat(fontname, ext);

  txattr.ta_Name =  (STRPTR)fontname;
  txattr.ta_YSize = (UWORD)size;
  txattr.ta_Style = FS_NORMAL;
  txattr.ta_Flags = FPF_DISKFONT;

  txfont = OpenDiskFont(&txattr);

  FreeMem(fontname, len);

  if (pre_opened == FALSE)
   {
     CloseLibrary(DiskfontBase);
     DiskfontBase = NULL;
   }

  return txfont;
}

