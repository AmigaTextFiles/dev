/*
 * CPump.c:  An Amiga Intuition-based C development environment.
 * © Copyright 1992, 1993, David A. Faught,  All rights reserved.
 * This information is provided "as is"; no warranties are made.
 * All use is at your own risk. No liability or responsibility is assumed.
 * Version 1.7
 */

#define INTUITION_IOBSOLETE_H

#include <workbench/startup.h>
#include <intuition/screens.h>
#include <graphics/displayinfo.h>
#include <exec/libraries.h>
#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <dos/dostags.h>
#include <dos/var.h>

#ifndef pdc
#ifndef __GNUC__
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/asl_protos.h>
#include <clib/alib_stdio_protos.h>
#endif
#endif

#ifdef __GNUC__
#include <tagdefs.h>
#endif

void exit ();
void main ();
void leave ();
void AddToCommand (), InitCommand ();
void MakeFileName (), GetFiles ();
void InEnv (), OutEnv ();
int GoRunCommand (), ZipRunCommand ();
void HandleButton1 (), HandleButton2 (), HandleButton3 ();
void HandleButton4 (), HandleButton5 (), HandleList1 ();
BOOL HandleGadgetEvent ();
BOOL HandleVanillaKey ();
struct Gadget *CreateAllGadgets ();

#define GAD_BUTTON1  1
#define GAD_CYCLE1   2
#define GAD_BUTTON2  3
#define GAD_CYCLE2   4
#define GAD_BUTTON3  5
#define GAD_CYCLE3   6
#define GAD_CHECK1   7
#define GAD_CHECK2   8
#define GAD_CHECK3   9
#define GAD_BUTTON4  10
#define GAD_CYCLE4   11
#define GAD_BUTTON5  12
#define GAD_STRING1  13
#define GAD_LISTVIEW1 14

#define EOS '\000'

struct TextAttr Topaz80 =
{
   "topaz.font",
   8,
   0,
   0,
};

UBYTE *vers = "$VER: CPump 1.7 (" __DATE__ ")";

extern struct Library *SysBase;
struct GfxBase *GfxBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library *GadToolsBase = NULL;
struct TextFont *font = NULL;
struct Screen *mysc = NULL;
struct Gadget *glist = NULL;
struct Window *mywin = NULL;
void *vi = NULL;
struct Library *AslBase;
struct WBArg *wbargs;
struct FileRequester *fr;

STRPTR OpenDests[] =
{
   "RAM:",
   "RAD:",
   NULL,
};
STRPTR Editors[] =
{
   "ED",
   "DME",
   "MEmacs",
   "Textra",
   NULL,
};
STRPTR CCTypes[] =
{
   "DICE",
   "PDC",
   "LC",
   "GCC",
   "EC",
   NULL,
};
STRPTR TestTypes[] =
{
   "RUN",
   "Debug",
   "RX Debug",
   NULL,
};

struct MinList ListView1List =
{
   (struct Node *) 0l, (struct Node *) 0l, (struct Node *) 0l };

struct Node ListView1Nodes[] =
{
   &ListView1Nodes[1], (struct Node *) & ListView1List.mlh_Head,
   0, 0, "MuchMore",
   &ListView1Nodes[2], &ListView1Nodes[0], 0, 0,   "EdTag Bld",
   &ListView1Nodes[3], &ListView1Nodes[1], 0, 0,   "EdTag Cnt",
   &ListView1Nodes[4], &ListView1Nodes[2], 0, 0,   "EdErr",
   &ListView1Nodes[5], &ListView1Nodes[3], 0, 0,   "Delete",
   &ListView1Nodes[6], &ListView1Nodes[4], 0, 0,   "(ADocs)",
   &ListView1Nodes[7], &ListView1Nodes[5], 0, 0,   "Make",
   &ListView1Nodes[8], &ListView1Nodes[6], 0, 0,   "Make clean",
   &ListView1Nodes[9], &ListView1Nodes[7], 0, 0,   "Makemake #?.c",
   &ListView1Nodes[10], &ListView1Nodes[8], 0, 0,  "DW",
   &ListView1Nodes[11], &ListView1Nodes[9], 0, 0,  "Cref >Cref.lst",
   &ListView1Nodes[12], &ListView1Nodes[10], 0, 0, "Calls >Calls.lst",
   &ListView1Nodes[13], &ListView1Nodes[11], 0, 0, "Indent",
   (struct Node *) & ListView1List.mlh_Tail, &ListView1Nodes[12],
       0, 0, "Touch"};

ULONG x;
UWORD code1 = 0, code2 = 0, code3 = 0, code4 = 0, code5 = 0;
UWORD altsize[4] =
{510, 10, 130, 10};
char Command[200];
char *EndCommand = Command;
char filename[255], dirname[255] = "DF0:";
char retcode[10], envbuff[60];
BOOL terminated = FALSE;
BOOL Vchecked = FALSE, Cchecked = FALSE, Schecked = FALSE;
struct Gadget *cycle1, *cycle2, *cycle3, *cycle4;
struct Gadget *check1, *check2, *check3, *string1;
struct Gadget *text1, *text2;

void
main (void)
{
   struct IntuiMessage *imsg;
   struct Gadget *gad;
   ULONG imsgClass;
   UWORD imsgCode;
   UWORD topborder;

   if (!(AslBase = OpenLibrary ("asl.library", 36L)))
      leave (20, "Requires V36 asl.library");

   if (!(GfxBase = (struct GfxBase *)
         OpenLibrary ("graphics.library", 36L)))
      leave (20, "Requires V36 graphics.library");

   if (!(IntuitionBase = (struct IntuitionBase *)
         OpenLibrary ("intuition.library", 36L)))
      leave (20, "Requires V36 intuition.library");

   if (!(GadToolsBase = OpenLibrary ("gadtools.library", 36L)))
      leave (20, "Requires V36 gadtools.library");

   if (!(font = OpenFont (&Topaz80)))
      leave (20, "Failed to open Topaz 80");

   if (!(mysc = LockPubScreen (NULL)))
      leave (20, "Couldn't lock default public screen");

   if (!(vi = GetVisualInfo (mysc,
              TAG_DONE)))
      leave (20, "GetVisualInfo() failed");

   InEnv ();

   topborder = mysc->WBorTop + (mysc->Font->ta_YSize + 1);

   ListView1List.mlh_Head = &ListView1Nodes[0];
   ListView1List.mlh_TailPred = &ListView1Nodes[13];

   if (!CreateAllGadgets (&glist, vi, topborder))
     {
        leave (20, "CreateAllGadgets() failed");
     }
   if (!(mywin = OpenWindowTags (NULL,
                  WA_Left, 220,
                  WA_Width, 420,
                  WA_InnerHeight, 72,
                  WA_Activate, TRUE,
                  WA_DragBar, TRUE,
                  WA_DepthGadget, TRUE,
                  WA_CloseGadget, TRUE,
                  WA_SizeGadget, FALSE,
                  WA_SimpleRefresh, TRUE,
                  WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_REFRESHWINDOW | \
                    IDCMP_VANILLAKEY | BUTTONIDCMP | LISTVIEWIDCMP,
                  WA_MinWidth, 0,
                  WA_MinHeight, 0,
                  WA_MaxWidth, 0,
                  WA_MaxHeight, 0,
                  WA_Zoom, altsize,
                  WA_Title, "CPump 1.7, ©1992-4 David A. Faught",
                  WA_Gadgets, glist,
                  TAG_DONE)))
      leave (20, "OpenWindow() failed");

   GT_RefreshWindow (mywin, NULL);

   if (!(fr = (struct FileRequester *)
         AllocAslRequestTags (ASL_FileRequest,
               ASL_TopEdge, 0L, ASL_LeftEdge, 0L,
               ASL_Height, 200L, ASL_Width, 320L,
               ASL_Hail, (ULONG) "CPump",
               ASL_Dir, (ULONG) dirname,
               ASL_File, (ULONG) "source.c",
               ASL_Pattern, (ULONG) "#?",
               ASL_FuncFlags, FILF_MULTISELECT | FILF_PATGAD,
               ASL_Window, mywin,
               TAG_DONE)))
      leave (20, "AllocAslRequestTags() failed");

   while (!terminated)
     {
        Wait (1 << mywin->UserPort->mp_SigBit);
        while ((!terminated) && (imsg = GT_GetIMsg (mywin->UserPort)))
          {
             imsgClass = imsg->Class;
             imsgCode = imsg->Code;
             gad = (struct Gadget *) imsg->IAddress;
             GT_ReplyIMsg (imsg);
             switch (imsgClass)
               {
               case IDCMP_GADGETDOWN:
               case IDCMP_MOUSEMOVE:
               case IDCMP_GADGETUP:
                  terminated = HandleGadgetEvent (mywin, gad, imsgCode);
                  break;

               case IDCMP_VANILLAKEY:
                  terminated = HandleVanillaKey (mywin, imsgCode);
                  break;

               case IDCMP_CLOSEWINDOW:
                  terminated = TRUE;
                  break;

               case IDCMP_REFRESHWINDOW:
                  GT_BeginRefresh (mywin);
                  GT_EndRefresh (mywin, TRUE);
                  break;
               }
          }
     }
   OutEnv ();
   leave (0, NULL);
}

void
leave (code, error)
     int code;
     STRPTR error;

{
   if (fr)
     {
        FreeAslRequest (fr);
     }
   if (mywin)
     {
        CloseWindow (mywin);
     }
   if (GadToolsBase)
     {
        FreeVisualInfo (vi);
        FreeGadgets (glist);
        CloseLibrary (GadToolsBase);
     }
   if (mysc)
     {
        UnlockPubScreen (NULL, mysc);
     }
   if (font)
     {
        CloseFont (font);
     }
   if (IntuitionBase)
     {
        CloseLibrary (IntuitionBase);
     }
   if (GfxBase)
     {
        CloseLibrary (GfxBase);
     }
   if (AslBase)
     {
        CloseLibrary (AslBase);
     }
   if (error)
     {
        printf ("Error: %s\n", error);
     }
   exit (code);
}

BOOL
HandleGadgetEvent (win, gad, code)
     struct Window *win;
     struct Gadget *gad;
     UWORD code;

{
   BOOL terminated = FALSE;

   switch (gad->GadgetID)
     {
     case GAD_BUTTON1:
        HandleButton1 ();
        break;
     case GAD_CYCLE1:
        code1 = code;
        GT_SetGadgetAttrs (cycle1, mywin, NULL,
                 GTCY_Active, code,
                 TAG_DONE);
        break;
     case GAD_BUTTON2:
        HandleButton2 ();
        break;
     case GAD_CYCLE2:
        code2 = code;
        GT_SetGadgetAttrs (cycle2, mywin, NULL,
                 GTCY_Active, code,
                 TAG_DONE);
        break;
     case GAD_BUTTON3:
        HandleButton3 ();
        break;
     case GAD_CYCLE3:
        code3 = code;
        GT_SetGadgetAttrs (cycle3, mywin, NULL,
                 GTCY_Active, code,
                 TAG_DONE);
        break;
     case GAD_CHECK1:
        if (!(gad->Flags & GFLG_SELECTED))
          {
             Vchecked = FALSE;
          }
        else
          {
             Vchecked = TRUE;
          }
        break;
     case GAD_CHECK2:
        if (!(gad->Flags & GFLG_SELECTED))
          {
             Schecked = FALSE;
          }
        else
          {
             Schecked = TRUE;
          }
        break;
     case GAD_CHECK3:
        if (!(gad->Flags & GFLG_SELECTED))
          {
             Cchecked = FALSE;
          }
        else
          {
             Cchecked = TRUE;
          }
        break;
     case GAD_BUTTON4:
        HandleButton4 ();
        break;
     case GAD_CYCLE4:
        code4 = code;
        GT_SetGadgetAttrs (cycle4, mywin, NULL,
                 GTCY_Active, code,
                 TAG_DONE);
        break;
     case GAD_BUTTON5:
        HandleButton5 ();
        break;
     case GAD_STRING1:
        strcpy (dirname, ((struct StringInfo *) gad->SpecialInfo)->Buffer);
        break;
     case GAD_LISTVIEW1:
        code5 = code;
        HandleList1 ();
        break;

     }
   return (terminated);
}

BOOL
HandleVanillaKey (win, code)
     struct Window *win;
     UWORD code;
{
   switch (code)
     {
     case 'o':
     case 'O':
        HandleButton1 ();
        break;
     case 'e':
     case 'E':
        HandleButton2 ();
        break;
     case 'c':
     case 'C':
        HandleButton3 ();
        break;
     case 't':
     case 'T':
        HandleButton4 ();
        break;
     case 's':
     case 'S':
        HandleButton5 ();
        break;
     }
   return (FALSE);
}

void
OutEnv ()
{
   ULONG flags = GVF_GLOBAL_ONLY;

   sprintf (envbuff, "%d,%d,%d,%d,%s", code1, code2, code3, code4, dirname);
   if (!(SetVar ("CPump.env", envbuff, -1L, flags)))
      leave (10, "SetVar() failed");
}

void
InEnv ()
{
   LONG len, flds;
   LONG c1, c2, c3, c4;
   char tempname[60];
   len = GetVar ("CPump.env", envbuff, 60, NULL);
   if (len <= 0)
      printf ("%s%d\n", "GetVar for CPump.env failed code ", len);
   else
     {
        /* This is a little bit of a kludge because apparently DICE */
        /* doesn't understand %h for short integers.                */
        flds = sscanf (envbuff, "%d,%d,%d,%d,%s", &c1, &c2, &c3, &c4, tempname);
        if (flds == 5L)
          {
             code1 = c1;
             code2 = c2;
             code3 = c3;
             code4 = c4;
             (void) strcpy (dirname, tempname);
          }
        else
           printf ("%s\n", "CPump.env is invalid and was ignored");
     }
}

int
ZipRunCommand ()
{
   int success;

   ZipWindow (mywin);
   success = GoRunCommand ();
   ZipWindow (mywin);
   return (success);
}

int
GoRunCommand ()
{
   struct TagItem stags[3];
   int success;

   if (Vchecked)
      printf ("%s\n", Command);
   GT_SetGadgetAttrs (text1, mywin, NULL,
            GTTX_Text, "   Running",
            TAG_DONE);

   stags[0].ti_Tag = SYS_Input;
   stags[0].ti_Data = Input ();
   stags[1].ti_Tag = SYS_Output;
   stags[1].ti_Data = Output ();
   stags[2].ti_Tag = TAG_DONE;
   success = System (Command, stags);

   GT_SetGadgetAttrs (text1, mywin, NULL,
            GTTX_Text, "   Waiting",
            TAG_DONE);
   (void) sprintf (retcode, "   RC %i", success);
   GT_SetGadgetAttrs (text2, mywin, NULL,
            GTTX_Text, retcode,
            TAG_DONE);

   if (Vchecked)
      printf ("Command returned %i\n", success);
   return (success);
}

void
HandleButton1 ()
{
   if (AslRequestTags (fr,
             ASL_Hail, (ULONG) "OPEN From",
             ASL_Dir, (ULONG) dirname,
             ASL_Pattern, (ULONG) "#?",
             ASL_FuncFlags, FILF_MULTISELECT | FILF_PATGAD,
             TAG_DONE))
     {
        if (fr->rf_NumArgs)
          {
             wbargs = fr->rf_ArgList;
             for (x = 0; x < fr->rf_NumArgs; x++)
               {
                  MakeFileName (fr->rf_Dir, wbargs[x].wa_Name);
                  InitCommand ();
                  AddToCommand (" COPY %s", filename);
                  AddToCommand (" TO %s", OpenDests[code1]);
                  (void) GoRunCommand ();
               }
          }
        else
          {
             MakeFileName (fr->rf_Dir, fr->rf_File);
             InitCommand ();
             AddToCommand (" COPY %s", filename);
             AddToCommand (" TO %s", OpenDests[code1]);
             (void) GoRunCommand ();
          }
        strcpy (dirname, fr->rf_Dir);
        GT_SetGadgetAttrs (string1, mywin, NULL,
                 GTST_String, dirname,
                 TAG_DONE);
     }
}

void
HandleButton2 ()
{
   InitCommand ();
   /* all editors need a filename argument */
   if (AslRequestTags (fr,
             ASL_Hail, (ULONG) "Edit",
             ASL_Dir, (ULONG) OpenDests[code1],
             ASL_Pattern, (ULONG) "#?",
             ASL_FuncFlags, FILF_PATGAD,
             TAG_DONE))
     {
        AddToCommand (" RUN %s", Editors[code2]);
        MakeFileName (fr->rf_Dir, fr->rf_File);
        AddToCommand (" %s", filename);
        (void) GoRunCommand ();
     }
}

void
HandleButton3 ()
{
   char basename[255], *split;

   if (AslRequestTags (fr,
             ASL_Hail, (ULONG) "Compile",
             ASL_Dir, (ULONG) OpenDests[code1],
             ASL_Pattern, (ULONG) "#?",
             ASL_FuncFlags, FILF_PATGAD,
             TAG_DONE))
     {
        InitCommand ();
        switch (code3)
          {
          case 0:
             MakeFileName (fr->rf_Dir, fr->rf_File);
             AddToCommand (" DCC %s", filename);
             (void) strcpy (basename, filename);
             if ((split = strrchr (basename, '.')) == NULL)
                (void) strcat (basename, ".exe");
             else
                *split = EOS;
             AddToCommand (" -o %s", basename);
             AddToCommand (" -E %s.err", basename);
             if (Vchecked)
                AddToCommand (" %s", "-v");
             if (Schecked)
                AddToCommand (" %s", "-s");
             if (Cchecked)
                AddToCommand (" %s", "-c");
             break;
          case 1:
             MakeFileName (fr->rf_Dir, fr->rf_File);
             AddToCommand (" %s", "CCX");
             if (Vchecked)
                AddToCommand (" %s", "-V");
             if (Schecked)
                AddToCommand (" %s", "-g");
             if (Cchecked)
                AddToCommand (" %s", "-c");
             AddToCommand (" %s", filename);
             break;
          case 2:
             MakeFileName (fr->rf_Dir, fr->rf_File);
             AddToCommand (" %s", "LC");
             if (Schecked)
                AddToCommand (" %s", "-d");
             if (!Cchecked)
                AddToCommand (" %s", "-L");
             AddToCommand (" %s", filename);
             break;
          case 3:
             MakeFileName (fr->rf_Dir, fr->rf_File);
             AddToCommand (" %s", "GCC");
             if (Vchecked)
                AddToCommand (" %s", "-v");
             if (Schecked)
                AddToCommand (" %s", "-g");
             if (Cchecked)
                AddToCommand (" %s", "-c");
             AddToCommand (" %s", filename);
             (void) strcpy (basename, filename);
             if ((split = strrchr (basename, '.')) == NULL)
                (void) strcat (basename, ".exe");
             else {
               if ((strcmp(split,".cc") == NULL) ||
                   (strcmp(split,".cxx") == NULL))
                  AddToCommand (" %s", "-lg++");
               *split = EOS;
               } 
             AddToCommand (" -o %s", basename);
             break;
          case 4:
             MakeFileName (fr->rf_Dir, fr->rf_File);
             (void) strcpy (basename, filename);
             if ((split = strrchr (basename, '.')) != NULL)
                *split = EOS;
             AddToCommand (" %s", "EC");
             if (Cchecked)
                AddToCommand (" %s", "-s");
             AddToCommand (" %s", basename);
             break;
          }
        (void) ZipRunCommand ();
     }
}

void
HandleButton4 ()
{
   if (AslRequestTags (fr,
             ASL_Hail, (ULONG) "Test",
             ASL_Dir, (ULONG) OpenDests[code1],
             ASL_Pattern, (ULONG) "#?",
             ASL_FuncFlags, FILF_PATGAD,
             TAG_DONE))
     {
        InitCommand ();
        AddToCommand (" %s", TestTypes[code4]);
        MakeFileName (fr->rf_Dir, fr->rf_File);
        AddToCommand (" %s", filename);
        (void) ZipRunCommand ();
     }
}

void
HandleList1 ()
{
   char basename[255], *split;
   int fileok;

   InitCommand ();
   fileok = TRUE;
   switch (code5)    /* do filerequester for those that need it */
     {
     case 0:
     case 3:
     case 4:
     case 6:
     case 7:
     case 10:
     case 11:
     case 12:
     case 13:
        fileok = AslRequestTags (fr,
                  ASL_Hail, (ULONG) "Utility",
                  ASL_Dir, (ULONG) OpenDests[code1],
                  ASL_Pattern, (ULONG) "#?",
                  ASL_FuncFlags, NULL,
                  TAG_DONE);
        if (fileok)
           MakeFileName (fr->rf_Dir, fr->rf_File);
        break;
     }
   if (fileok)    /* if everything is still ok */
     {
        switch (code5)/* format the command and run it */
          {
          case 1: /* Edtag Bld */
          case 2: /* Edtag Cnt */
             AddToCommand (" rx %s %s", ListView1Nodes[code5].ln_Name,
                 Editors[code2]);
             (void) GoRunCommand ();
             break;
          case 3: /* EdErr */
             AddToCommand (" rx %s %s", ListView1Nodes[code5].ln_Name, filename);
             (void) ZipRunCommand ();
             break;
          case 5: /* (ADocs) */
             AddToCommand (" %s", "run AmigaGuide AutoDocs");
             (void) GoRunCommand ();
             break;
          case 6: /* Make */
             if (code3 == 0)  /* the zeroth compiler is "Dice" */
                AddToCommand (" Dmake -f %s", filename);
             else
                AddToCommand (" Make -f %s", filename);
             (void) ZipRunCommand ();
             break;
          case 7: /* Make clean */
             if (code3 == 0)  /* the zeroth compiler is "Dice" */
                AddToCommand (" Dmake -f %s clean", filename);
             else
                AddToCommand (" Make -f %s clean", filename);
             (void) ZipRunCommand ();
             break;
          case 8: /* Makemake */
          case 9: /* DW */
             AddToCommand (" %s", ListView1Nodes[code5].ln_Name);
             (void) ZipRunCommand ();
             break;
          default:
             AddToCommand (" %s %s", ListView1Nodes[code5].ln_Name, filename);
             (void) ZipRunCommand ();
          }
     }
}

void
HandleButton5 ()
{
   if (AslRequestTags (fr,
             ASL_Hail, (ULONG) "SAVE From",
             ASL_Dir, (ULONG) "RAM:",
             ASL_Pattern, (ULONG) "#?",
             ASL_FuncFlags, FILF_MULTISELECT,
             TAG_DONE))
     {
        if (fr->rf_NumArgs)
          {
             wbargs = fr->rf_ArgList;
             for (x = 0; x < fr->rf_NumArgs; x++)
               {
                  MakeFileName (fr->rf_Dir, wbargs[x].wa_Name);
                  InitCommand ();
                  AddToCommand (" COPY %s", filename);
                  AddToCommand (" TO %s", dirname);
                  (void) GoRunCommand ();
               }
          }
        else
          {
             MakeFileName (fr->rf_Dir, fr->rf_File);
             InitCommand ();
             AddToCommand (" COPY %s", filename);
             AddToCommand (" TO %s", dirname);
             (void) GoRunCommand ();
          }
     }
}

void
InitCommand ()
{
   Command[0] = EOS;
   EndCommand = &Command[0];
}

void
AddToCommand (fmt, arg1, arg2, arg3)
     char *fmt;
     char *arg1, *arg2, *arg3;
{
   register int length;
   register char *s;
   auto char buffer[255];
   auto char word[64];

   (void) sprintf (buffer, fmt, arg1, arg2, arg3);
   length = strlen (buffer);
   if ((EndCommand - Command) + length >= sizeof (Command))
      leave (20, "Command line too long");

   else
     {
        (void) strcat (EndCommand, buffer);
        EndCommand += length;
     }
}

void
MakeFileName (arg1, arg2)
     char *arg1, *arg2;
{
   UWORD lastchr;
   lastchr = strlen (arg1) - 1;
   if (arg1[lastchr] == ':')
      (void) sprintf (filename, "%s%s", arg1, arg2);
   else
      (void) sprintf (filename, "%s/%s", arg1, arg2);
}

struct Gadget *
CreateAllGadgets (glistptr, vi, topborder)
     struct Gadget **glistptr;
     void *vi;
     UWORD topborder;

{
   struct NewGadget ng;
   struct Gadget *gad;

   gad = CreateContext (glistptr);

   ng.ng_TextAttr = &Topaz80;
   ng.ng_VisualInfo = vi;

   ng.ng_LeftEdge = 4;
   ng.ng_TopEdge = topborder;
   ng.ng_Width = 70;
   ng.ng_Height = 12;
   ng.ng_GadgetText = "_Open";
   ng.ng_GadgetID = GAD_BUTTON1;
   ng.ng_Flags = 0;
   gad = CreateGadget (BUTTON_KIND, gad, &ng,
             GT_Underscore, '_',
             TAG_DONE);

   ng.ng_LeftEdge += 120;
   ng.ng_Width = 100;
   ng.ng_GadgetText = "To";
   ng.ng_GadgetID = GAD_CYCLE1;
   ng.ng_Flags = NG_HIGHLABEL;
   cycle1 = gad = CreateGadget (CYCLE_KIND, gad, &ng,
                 GTCY_Labels, OpenDests,
                 GTCY_Active, code1,
                 TAG_DONE);

   ng.ng_LeftEdge = 4;
   ng.ng_TopEdge += 12;
   ng.ng_Width = 70;
   ng.ng_GadgetText = "_Edit";
   ng.ng_GadgetID = GAD_BUTTON2;
   ng.ng_Flags = 0;
   gad = CreateGadget (BUTTON_KIND, gad, &ng,
             GT_Underscore, '_',
             TAG_DONE);

   ng.ng_LeftEdge += 120;
   ng.ng_Width = 100;
   ng.ng_GadgetText = "With";
   ng.ng_GadgetID = GAD_CYCLE2;
   ng.ng_Flags = NG_HIGHLABEL;
   cycle2 = gad = CreateGadget (CYCLE_KIND, gad, &ng,
                 GTCY_Labels, Editors,
                 GTCY_Active, code2,
                 TAG_DONE);

   ng.ng_LeftEdge += 100;
   ng.ng_GadgetText = "Status";
   ng.ng_Flags = PLACETEXT_ABOVE | NG_HIGHLABEL;
   text1 = gad = CreateGadget (TEXT_KIND, gad, &ng,
                GTTX_Text, "   Waiting",
                TAG_DONE);

   ng.ng_LeftEdge += 92;
   ng.ng_Width = 100;
   ng.ng_Height = 60;
   ng.ng_GadgetText = "Utilities";
   ng.ng_GadgetID = GAD_LISTVIEW1;
   ng.ng_Flags = PLACETEXT_ABOVE | NG_HIGHLABEL;
   gad = CreateGadget (LISTVIEW_KIND, gad, &ng,
             GTLV_Labels, &ListView1List, TAG_DONE);

   ng.ng_LeftEdge = 4;
   ng.ng_TopEdge += 12;
   ng.ng_Width = 70;
   ng.ng_Height = 12;
   ng.ng_GadgetText = "_Compile";
   ng.ng_GadgetID = GAD_BUTTON3;
   ng.ng_Flags = 0;
   gad = CreateGadget (BUTTON_KIND, gad, &ng,
             GT_Underscore, '_',
             TAG_DONE);

   ng.ng_LeftEdge += 120;
   ng.ng_Width = 100;
   ng.ng_GadgetText = "With";
   ng.ng_GadgetID = GAD_CYCLE3;
   ng.ng_Flags = NG_HIGHLABEL;
   cycle3 = gad = CreateGadget (CYCLE_KIND, gad, &ng,
                 GTCY_Labels, CCTypes,
                 GTCY_Active, code3,
                 TAG_DONE);

   ng.ng_LeftEdge += 100;
   ng.ng_GadgetText = "";
   ng.ng_Flags = 0;
   text2 = gad = CreateGadget (TEXT_KIND, gad, &ng,
                GTTX_Text, "   00",
                TAG_DONE);

   ng.ng_TopEdge += 12;
   ng.ng_LeftEdge = 70;
   ng.ng_GadgetText = "Verbose";
   ng.ng_GadgetID = GAD_CHECK1;
   ng.ng_Flags = NG_HIGHLABEL;
   check1 = gad = CreateGadget (CHECKBOX_KIND, gad, &ng,
                 GTCB_Checked, Vchecked,
                 TAG_DONE);

   ng.ng_LeftEdge += 120;
   ng.ng_GadgetText = "DbugInfo";
   ng.ng_GadgetID = GAD_CHECK2;
   check2 = gad = CreateGadget (CHECKBOX_KIND, gad, &ng,
                 GTCB_Checked, Schecked,
                 TAG_DONE);

   ng.ng_LeftEdge += 100;
   ng.ng_GadgetText = "NoLink";
   ng.ng_GadgetID = GAD_CHECK3;
   check2 = gad = CreateGadget (CHECKBOX_KIND, gad, &ng,
                 GTCB_Checked, Cchecked,
                 TAG_DONE);

   ng.ng_LeftEdge = 4;
   ng.ng_TopEdge += 11;
   ng.ng_Width = 70;
   ng.ng_GadgetText = "_Test";
   ng.ng_GadgetID = GAD_BUTTON4;
   ng.ng_Flags = 0;
   gad = CreateGadget (BUTTON_KIND, gad, &ng,
             GT_Underscore, '_',
             TAG_DONE);

   ng.ng_LeftEdge += 120;
   ng.ng_Width = 100;
   ng.ng_GadgetText = "With";
   ng.ng_GadgetID = GAD_CYCLE4;
   ng.ng_Flags = NG_HIGHLABEL;
   cycle4 = gad = CreateGadget (CYCLE_KIND, gad, &ng,
                 GTCY_Labels, TestTypes,
                 GTCY_Active, code4,
                 TAG_DONE);

   ng.ng_LeftEdge = 4;
   ng.ng_TopEdge += 12;
   ng.ng_Width = 70;
   ng.ng_Height = 13;
   ng.ng_GadgetText = "_Save";
   ng.ng_GadgetID = GAD_BUTTON5;
   ng.ng_Flags = 0;
   gad = CreateGadget (BUTTON_KIND, gad, &ng,
             GT_Underscore, '_',
             TAG_DONE);

   ng.ng_LeftEdge += 120;
   ng.ng_Width = 191;
   ng.ng_Height = 13;
   ng.ng_GadgetText = "To";
   ng.ng_GadgetID = GAD_STRING1;
   ng.ng_Flags = NG_HIGHLABEL;
   string1 = gad = CreateGadget (STRING_KIND, gad, &ng,
                  GTST_String, dirname,
                  GTST_MaxChars, 50,
                  TAG_DONE);

   return (gad);
}
