/**********************************************************************
:Program.    RequesterDemo.c
:Contents.   guitools.library demonstration: using requesters
:Author.     Carsten Ziegeler
:Address.    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany
:Copyright.  Freeware, refer to documentation
:Language.   Modula-2
:Translator. M2Amiga V4.1
:Remark.     OS 2.0 required
:Remark.     requires guitools.library V38.1
:History.    v1.0  Carsten Ziegeler  24-APR-94
***********************************************************************/

/* ATTENTION: This modul is a straight translation of the modula2-demo.
              It may not take in some cases the easiest way to achive
              things, but it works ! */

/* This example shows all available requesters on the public screen.
   The requesters are not redirected ! The pr_WindowPtr field of the
   process structure is used ! (Usually this is NULL) */

#include <exec/types.h>
#include <exec/libraries.h>
#include <string.h>
#include <proto/exec.h>

#include "guitools.h"

UBYTE *vers = "\0$VER: RequesterDemo 1.0 (24.04.94)";

struct Library *GUIToolsBase;

LONG choose;
char file[256], dir[256];

APTR args[5]; /* for the arguments */

/* Libraries will be opened by the auto init code ! Except GUITools !!*/

void main(void)
{

  /* open GUITools.library */

  GUIToolsBase = OpenLibrary(GUIToolsName, 38);

  if ((GUIToolsBase == NULL) || (GUIToolsBase->lib_Version < 38) ||
     ((GUIToolsBase->lib_Version == 38) && (GUIToolsBase->lib_Revision == 0)))
    SimpleReq("You need at least the guitools.library V38.1 !", okReqKind);
  else
  {

    /* No return value, ok requester */
    ShowRequester(NULL, "This is the requester demo !\nEnjoy it !",
                  okReqKind, NULL);

    /* doitReqKind */
    while (ShowRequester(NULL, "Do you want to see this requester again ?",
                         doitReqKind, NULL) == reqDo) ;


    /* Yes/no/cancel  requester */
    choose = ShowRequester(NULL, "Do you want to see some asl requesters ?",
                           yncReqKind, NULL);
    if (choose == reqYes)

    {
      /* And now the asl requesters provided by GUITools */

      strcpy(file, "guitools.library");
      strcpy(dir,  "sys:libs");
      /* First a requester to choose the best library ! */
      if (ShowRequester(NULL, "Choose the best library", fileReqKind,
                        SR_AslPattern, "#?.library",
                        SR_AslFileBuffer, &file,
                        SR_AslDirBuffer, &dir, NULL) == reqAslOK)
      {
        args[0] = &dir;
        args[1] = &file;
        ShowRequester(NULL, "You choice was:\ndir :%s\nfile:%s",
                      okReqKind, SR_Args, &args, NULL);
      }
      else
        ShowRequester(NULL, "You cancelled it ! (Sniff..)",
                      okReqKind, NULL);


      /* And now a save dir requester with no pattern gadget */
      strcpy(dir, "ram:t");
      if (ShowRequester(NULL, "Choose directory to save something...",
                        dirReqKind, SR_AslNameBuffer, &dir,
                                    SR_AslPattern, NULL,
                                    SR_AslSave, 1, NULL) == reqAslOK)
      {
        args[0] = &dir;
        ShowRequester(NULL, "You selected directory:\n%s",
                      okReqKind, SR_Args, &args, NULL);
      }
      else
        ShowRequester(NULL, "You cancelled it ! (Snuff..)",
                      okReqKind, NULL);
    }
    else
    {
      if (choose == reqNo)
        ShowRequester(NULL, "Click OK to quit !", okReqKind, NULL);
    }
  }
}
