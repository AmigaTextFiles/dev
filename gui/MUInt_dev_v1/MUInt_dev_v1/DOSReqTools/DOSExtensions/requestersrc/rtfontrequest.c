
#include <dos/dos.h>
#include <dos/rdargs.h>
#include <graphics/text.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/reqtools_protos.h>
#include <stdio.h>
#include <string.h>
#include <exec/lists.h>

#include <libraries/reqtools.h>

#ifdef AZTEC_C
#include <functions.h>
#endif

static char version_string[] = "$VER: rtFontRequest 2.5 (17.1.95)";

char MyExtHelp[] =
"\n"
"Usage : rtFontRequest\n"
"\n"
"  TITLE/A,NOBUFFER/S,FIXEDWIDTH/S,COLORFONTS/S,CHANGEPALETTE/S,LEAVEPALETTE/S,\n"
"  SCALE/S,STYLE/S,HEIGHT/N/K,OKTEXT/K,SAMPLEHEIGHT/N/K,MINHEIGHT/N/K,\n"
"  MAXHEIGHT/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFFTOFFSET=LEFT/N/K,\n"
"  TO/K,PUBSCREEN/K\n"
"\n"
"Arguments:\n"
"\n"
"  TITLE    <text> - Title text for requester window.\n"
"  NOBUFFER        - Do not buffer the font list for subsequent calls.\n"
"  FIXEDWIDTH      - Only show fixed-width fonts.\n"
"  COLORFONTS      - Show color fonts also.\n"
"  CHANGEPALETTE   - Change the screen's palette to match that of a selected\n"
"                    color font.\n"
"  LEAVEPALETTE    - Leave the palette as it is when exiting rtFontRequest.\n"
"                    Useful in combination with CHANGEPALETTE.\n"
"  SCALE           - Allow fonts to be scaled when they don't exist in the\n"
"                    requested size. (works on Kickstart 2.0 only, has no\n"
"                    effect on 1.2/1.3).\n"
"  STYLE           - Include gadgets so the user may select the font's style.\n"
"  HEIGHT    <num> - Suggested height of font requester window.\n"
"  OKTEXT   <text> - Replacement text for \"Ok\" gadget.  Maximum 6 chars.\n"
"  SAMPLEHEIGHT <num> - Height of font sample display in pixels (default 24).\n"
"  MINHEIGHT    <num> - Minimum font size displayed.\n"
"  MAXHEIGHT    <num> - Maximum font size displayed.\n"
"  POSITION     <pos> - Open requester window at <pos>.  Permissible values are:\n"
" >or POS               CENTERSCR, TOPLEFTSCR, CENTERWIN, TOPLEFTWIN, POINTER.\n"
"  TOPOFFSET    <num> - Offset position relative to above.\n"
" >or TOP\n"
"  LEFFTOFFSET  <num> - Offset position relative to above.\n"
" >or LEFT\n"
"  TO          <file> - Send result to <file>.\n"
"  PUBSCREEN <screen> - Public screen name.\n";

#define TEMPLATE "TITLE/A,NOBUFFER/S,FIXEDWIDTH/S,COLORFONTS/S,CHANGEPALETTE/S,LEAVEPALETTE/S,SCALE/S,STYLE/S,HEIGHT/N/K,OKTEXT/K,SAMPLEHEIGHT/N/K,MINHEIGHT/N/K,MAXHEIGHT/N/K,POSITION=POS/K,TOPOFFSET=TOP/N/K,LEFFTOFFSET=LEFT/N/K,TO/K,PUBSCREEN/K"

#define OPT_TITLE 0
#define OPT_NOBUFFER 1
#define OPT_FIXEDWIDTH 2
#define OPT_COLORFONTS 3
#define OPT_CHANGEPALETTE 4
#define OPT_LEAVEPALETTE 5
#define OPT_SCALE 6
#define OPT_STYLE 7
#define OPT_HEIGHT 8
#define OPT_OKTEXT 9
#define OPT_SAMPLEHEIGHT 10
#define OPT_MINHEIGHT 11
#define OPT_MAXHEIGHT 12
#define OPT_POSITION 13
#define OPT_TOPOFFSET 14
#define OPT_LEFTOFFSET 15
#define OPT_TO 16
#define OPT_PUBSCREEN 17
#define OPT_COUNT 18

struct Library *ReqToolsBase;

int
main (int argc, char **argv)
{
  int retval = 0;

  if (argc)
    {
      if ((argc == 2) && (stricmp (argv[1], "HELP") == 0))
     {
       fprintf (stdout, "%s", MyExtHelp);
     }
      else
     {
       /* My custom RDArgs */
       struct RDArgs *myrda;

       /* Need to ask DOS for a RDArgs structure */
       if (myrda = (struct RDArgs *) AllocDosObject (DOS_RDARGS, NULL))
         {
           /*
            * The array of LONGs where ReadArgs() will store the data from
            * the command line arguments.  C guarantees that all the array
            * entries will be set to zero.
            */
           LONG result[OPT_COUNT] =
           {NULL};

           /* parse my command line */
           if (ReadArgs (TEMPLATE, result, myrda))
          {
            if (ReqToolsBase = (struct Library *) OpenLibrary ("reqtools.library", LIBRARY_MINIMUM))
              {
                struct rtFontRequester *requester;

                if (requester = (struct rtFontRequester *) rtAllocRequest (RT_FONTREQ, NULL))
               {
                 /*
                  * Take care of requester positioning -
                  * These flags common to most rt requesters
                  */
                 if (stricmp ((char *) result[OPT_POSITION], "POINTER") == 0)
                   requester->ReqPos = REQPOS_POINTER;
                 else if (stricmp ((char *) result[OPT_POSITION], "CENTERSCR") == 0)
                   requester->ReqPos = REQPOS_CENTERSCR;
                 else if (stricmp ((char *) result[OPT_POSITION], "TOPLEFTSCR") == 0)
                   requester->ReqPos = REQPOS_TOPLEFTSCR;
                 else if (stricmp ((char *) result[OPT_POSITION], "CENTERWIN") == 0)
                   requester->ReqPos = REQPOS_CENTERWIN;
                 else if (stricmp ((char *) result[OPT_POSITION], "TOPLEFTWIN") == 0)
                   requester->ReqPos = REQPOS_TOPLEFTWIN;
                 else
                   requester->ReqPos = REQPOS_CENTERSCR;


                 /*
                  * take care of some rtFontRequest () specific flags
                  */
                 requester->Flags =
                   ((result[OPT_NOBUFFER]) ? FREQF_NOBUFFER : NULL) |
                   ((result[OPT_FIXEDWIDTH]) ? FREQF_FIXEDWIDTH : NULL) |
                   ((result[OPT_COLORFONTS]) ? FREQF_COLORFONTS : NULL) |
                   ((result[OPT_CHANGEPALETTE]) ? FREQF_CHANGEPALETTE : NULL) |
                   ((result[OPT_LEAVEPALETTE]) ? FREQF_LEAVEPALETTE : NULL) |
                   ((result[OPT_SCALE]) ? FREQF_SCALE : NULL) |
                   ((result[OPT_STYLE]) ? FREQF_STYLE : NULL);

                 {
                   struct Process *process = (struct Process *) FindTask (NULL);
                   APTR windowptr = process->pr_WindowPtr;

                   /* APTR func_return; */

                   /*
                    * Tags will be used to take care ofattributes not directly
                    * settable in the rtReqInfo structure
                    */

                   if (retval = rtFontRequest (requester, (char *) result[OPT_TITLE],

                   (result[OPT_HEIGHT]) ? RTFO_Height : TAG_IGNORE,
                              *((LONG *) result[OPT_HEIGHT]),
                   (result[OPT_OKTEXT]) ? RTFO_OkText : TAG_IGNORE,
                              (char *) result[OPT_OKTEXT],

                                   (result[OPT_SAMPLEHEIGHT]) ? RTFO_SampleHeight : TAG_IGNORE,
                           *((LONG *) result[OPT_SAMPLEHEIGHT]),
                                   (result[OPT_MINHEIGHT]) ? RTFO_MinHeight : TAG_IGNORE,
                           *((LONG *) result[OPT_MINHEIGHT]),
                                   (result[OPT_MAXHEIGHT]) ? RTFO_MaxHeight : TAG_IGNORE,
                           *((LONG *) result[OPT_MAXHEIGHT]),
                   /*
                    * Finally,
                    * set some more general tags shared by most requesters
                    */
                                   RT_Underscore, '_',

                                   (result[OPT_TOPOFFSET]) ? RT_TopOffset : TAG_IGNORE,
                           *((LONG *) result[OPT_TOPOFFSET]),
                                   (result[OPT_LEFTOFFSET]) ? RT_LeftOffset : TAG_IGNORE,
                          *((LONG *) result[OPT_LEFTOFFSET]),
                           (windowptr) ? RT_Window : TAG_IGNORE,
                                   windowptr,
                                   (result[OPT_PUBSCREEN]) ? RT_PubScrName : TAG_IGNORE,
                              (char *) result[OPT_PUBSCREEN],
                                   TAG_END))

                     {
                    struct TextAttr *TextAttr = (struct TextAttr *) &requester->Attr;

                    if (result[OPT_TO])
                      {
                        FILE *fd;

                        if (fd = fopen ((char *) result[OPT_TO], "w"))
                          {
                         fprintf (fd, "%s ", TextAttr->ta_Name);
                         fprintf (fd, "%d ", TextAttr->ta_YSize);

                         if (TextAttr->ta_Style & FSF_UNDERLINED)
                           fprintf (fd, "UNDERLINED ");

                         if (TextAttr->ta_Style & FSF_BOLD)
                           fprintf (fd, "BOLD ");

                         if (TextAttr->ta_Style & FSF_ITALIC)
                           fprintf (fd, "ITALIC ");

                         if (TextAttr->ta_Style & FSF_EXTENDED)
                           fprintf (fd, "EXTENDED ");

                         fclose (fd);
                          }
                        else
                          {
                         fprintf (stderr, "unable to open output file - %s", result[OPT_TO]);
                         retval = 21;
                          }
                      }
                    else
                      {
                        printf ("%s ", TextAttr->ta_Name);
                        printf ("%d ", TextAttr->ta_YSize);

                        if (TextAttr->ta_Style & FSF_UNDERLINED)
                          printf ("UNDERLINED ");

                        if (TextAttr->ta_Style & FSF_BOLD)
                          printf ("BOLD ");

                        if (TextAttr->ta_Style & FSF_ITALIC)
                          printf ("ITALIC ");

                        if (TextAttr->ta_Style & FSF_EXTENDED)
                          printf ("EXTENDED ");
                      }
                     }
                 }
                 rtFreeRequest (requester);
               }
                else
               {
                 /* Unable to allocate request structure */
                 retval = 20;
               }
                CloseLibrary (ReqToolsBase);
              }
            else
              {
                /* Unable to open reqtools.library */
                fprintf (stderr, "rtGetString: Unable to open reqtools.library.\n");
                retval = 20;
              }
            FreeArgs (myrda);
          }
           else
          {
            /*
             * Something went wrong in the parse
             */

            if (result[OPT_TITLE] == NULL)
              {
                fprintf (stderr, "rtFontRequest: Required argument missing.\n");
              }
            else
              {
                /* something else is wrong */
                fprintf (stderr, "rtFontRequest: Command syntax error.\n");
              }

            fprintf (stderr, "Try - rtFontRequest help.\n");

            retval = 20;
          }
           FreeDosObject (DOS_RDARGS, myrda);
         }
       else
         {
           /* Unable to alloc readargs structure */
           retval = 20;
         }
     }
    }
  else
    {
      /* launched from workbench */
    }

  return (retval);
}
