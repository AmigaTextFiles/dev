/*
 *  MonIDCMP.C  -  Monitor the IDCMP port for any window.    26-May-1987
 *
 *  Copyright (c) 1987 by Davide P. Cervone
 *  You may use this code provided this copyright notice is kept intact.
 */

#include <intuition/intuitionbase.h>
#include <libraries/dos.h>
#include <devices/inputevent.h>
#include <stdio.h>

#define USAGE    "MonIDCMP [MASK <mask>] <WindowTitle> [<ScreenTitle>]\n"

#define INTUITION_REV   0
#define ONE             1L
#define SHOWN_FLAG      0x80        /* flag used to tell if a message has */
                                    /* already been seen by the monitor */

#define SHOW_USAGE      0
#define LIST_WINDOWS    1
#define MONITOR_WINDOW  2

#define ARGMATCH(s,n)      (stricmp(s,argv[n]) == 0)
#define NO_MATCH(s1,s2)    (stricmp(s1,s2) != 0)

extern struct Task *FindTask();
extern LONG AllocSignal();

struct IntuitionBase *IntuitionBase = NULL;
struct Task          *theTask;              /* the monitor task */
struct MsgPort       *thePort;              /* the IDCMP port being viewed */
struct List          *theMsgList;           /* the Message List for thePort */
struct Window        *theWindow = NULL;     /* the IDCMP window */
LONG                 theSignal;             /* IDCMP message signal bit */
LONG                 theMask;               /*  and mask */
BYTE                 oldPri;                /* our old priority */
struct Task          *oldTask = NULL;       /* the monitored task */
int                  NotDone = TRUE;        /* not done monitoring? */
int                  GotSignal = FALSE;     /* did AllocSignal succeed? */
char                 *WindowTitle = "";     /* the name of the IDCMP window */
char                 *ScreenTitle = "Workbench Screen";   /* the Screen Title */
ULONG                EventMask = 0xFFFFFFFF;   /* the IntuiMessage classes */
                                               /* that we want to see */

char *version = "MonIDCMP v1.0 (May 1987)";
char *author  = "Copyright (c) 1987 by Davide P. Cervone";


/*
 *  Ctrl_C()
 *
 *  Do nothing routine for Lattice control-C trapping (we do our own).
 */

#ifdef LATTICE
Ctrl_C()
{
   return(0);
}
#endif


/*
 *  DoExit()
 *
 *  General clean-up-and-exit routine.  If the string 's' is not a null
 *  pointer, then print the message that it points to (it can take up to
 *  three optional arguments).  Close the Intuition library if it is open.
 */

void DoExit(s,x1,x2,x3)
char *s, *x1, *x2, *x3;
{
   LONG status = 0;

   if (s != NULL)
   {
      printf(s,x1,x2,x3);
      printf("\n");
      status = RETURN_ERROR;
   }
   if (IntuitionBase != NULL) CloseLibrary(IntuitionBase);
   exit(status);
}


/*
 *  CheckLibOpen()
 *
 *  General library open routine.  It opens a library and sets a pointer
 *  to it.  It checks that the library was openned successfully.
 */

void CheckLibOpen(lib,name,rev)
APTR *lib;
char *name;
int rev;
{
   extern APTR OpenLibrary();

   if ((*lib = OpenLibrary(name,(LONG)rev)) == NULL)
      DoExit("Can't open %s\n",name);
}


/*
 *  ParseArguments()
 *
 *  Parse the command-line arguments and return a function-code that
 *  tells the main program what to do.  The valid options are:  the
 *  words "LIST WINDOWS", which causes MonIDCMP to print a list of all
 *  the screens and their associated windows; or, a window title followed
 *  by an optional screen title (if none is supplied, "Workbench Screen" 
 *  is assumed).  The window title can be preceeded optionally by the word
 *  "MASK" followed by a HEX mask value that represents the IDCMP classes
 *  that should be reported.  Only those messages that match a bit in the
 *  mask value (and in the windows IDCMPFlags field) will be reported.  
 *  For instance, a mask of 2C will allow all GADGETDOWN, MOUSEBUTTONS and
 *  REFRESHWINDOW messages to be reported.
 *
 *  If the arguments do not match one of these templates, then the USAGE
 *  function is performed.
 */

int ParseArguments(argc,argv)
int argc;
char *argv[];
{
   int function = SHOW_USAGE;
   ULONG eMask;
   
   if (argc >=2 && argc <= 5)
   {
      if (argc > 3 && ARGMATCH("MASK",1))
      {
         if (sscanf(argv[2],"%lx",&eMask) != 1)
            DoExit("Bad mask value - '%s'",argv[2]);
         argc -= 2;
         argv += 2;
         EventMask = eMask;
      }
      if (argc == 3 && ARGMATCH("LIST",1) && ARGMATCH("WINDOWS",2))
      {
         function = LIST_WINDOWS;
      } else {
         if (argc <= 3)
         {
            WindowTitle = argv[1];
            if (argc == 3)
               ScreenTitle = argv[2];
            function = MONITOR_WINDOW;
         }
      }
   }
   return(function);
}


/*
 *  ListWindows()
 *
 *  List all the screens and their associated windows.  The first screen
 *  is found in the IntuitionBase structure; subsequent screens are found
 *  from the NextScreen field of the preceeding screen.  The windows for
 *  each screen are linked in a similar fashion.  Forbid() and Permit()
 *  are used to insure that the IntuitionBase lists won't change while 
 *  we're looking at them.  These should be LockIBase() and UnlockIBase(),
 *  but I don't have the documentation for these, so I can't use them.
 */

void ListWindows()
{
   struct Window       *theWindow;
   struct Screen       *theScreen;

   Forbid();
   for (theScreen = IntuitionBase->FirstScreen; theScreen;
      theScreen = theScreen->NextScreen)
   {
      if (theScreen->DefaultTitle)
         printf("\n'%s' [Screen]\n",theScreen->DefaultTitle);
        else
         printf("\n[No Screen Title]\n");
      for (theWindow = theScreen->FirstWindow; theWindow;
         theWindow = theWindow->NextWindow)
      {
         if (theWindow->Title)
            printf("   '%s'\n",theWindow->Title);
           else
            printf("   [No Window Title]\n");
      }
   }
   Permit();
   printf("\n");
}


/*
 *  FindWindow()
 *
 *  Look through the IntuitionBase pointers to find the screen and
 *  window that the user supplied and report an error if they don't
 *  exist.  The titles are matched with a case-insensative compare 
 *  funtion (stricmp).  Forbid() and Permit() are used to be sure that
 *  the Intuition lists don't change while we're looking.  These should
 *  really be LockIBase() and UnlockIBase(), but I don't have the 
 *  documentation for these, so I can't use them.
 */

void FindWindow()
{
   struct Screen *theScreen;
   
   Forbid();

   for (theScreen = IntuitionBase->FirstScreen;
        theScreen && NO_MATCH(ScreenTitle,theScreen->DefaultTitle);
        theScreen = theScreen->NextScreen);

   if (theScreen)
      for (theWindow = theScreen->FirstWindow;
           theWindow && NO_MATCH(WindowTitle,theWindow->Title);
           theWindow = theWindow->NextWindow);

   Permit();

   if (theScreen == NULL)
      DoExit("Screen '%s' not found",ScreenTitle);
   if (theWindow == NULL)
      DoExit("Window '%s' not found on Screen '%s'",WindowTitle,ScreenTitle);
}


/*
 *  SetupMsgPort()
 *
 *  Here's the trick that makes it all work:  the UserPort of the window is
 *  an Exec message port (MsgPort), which contains (among other things) a
 *  pointer to a task to signal when new messages arrive at the port.
 *  We save the old task pointer and insert a pointer to our own task 
 *  in the message port so that we will be signalled instead of the owner
 *  of the window (later, when we have finished printing the messages, we will 
 *  signal the original process "by hand").
 *
 *  We can't use GetMsg() to look at the IntuiMessages since this would
 *  remove them from the port.  Instead, we look through the mp_MsgList
 *  (an Exec List of Exec Node structures) and extract the pointers to 
 *  the IntuiMessages directly, leaving the message port intact.  When we are
 *  done looking, we Signal() the original task that the messages have
 *  arrived.
 *
 *  Once we signal the other process, it uses GetMsg() to remove the messages
 *  from the list.  If new messages arrive while the original process is 
 *  getting message from the port, it could  remove those messages before we 
 *  get the chance to see them.  To overcome this problem, we must run at a 
 *  higher priority than the monitored task.  That way, when a new message 
 *  arrives and we are signalled, we pre-empt the monitored task (i.e., we 
 *  interupt whatever it is doing), and can look through the message list for 
 *  new messages before we let it go any further with the list.  Since most 
 *  of what we do is Wait() for the signal from the message port, we should 
 *  not interfere with the normal functions of the monitored task.
 *
 *  We don't need to ReplyMsg() any messages, since the monitored process
 *  should be doing this itself.
 */
 
void SetupMsgPort()
{
   Forbid();
   thePort    = theWindow->UserPort;
   theMsgList = &(thePort->mp_MsgList);
   theSignal  = thePort->mp_SigBit;
   theMask    = ONE << theSignal;
   oldTask    = thePort->mp_SigTask;
   thePort->mp_SigTask = theTask;
   Permit();
   
   oldPri = SetTaskPri(theTask,(ULONG)(oldTask->tc_Node.ln_Pri + 1));
}


/*
 *  ResetMsgPort()
 *
 *  Put the window's UserPort back the way it was and reset our own 
 *  priority.  Since it is possible that the window was closed (and its
 *  associated memory freed) without our knowing about it, we only reset
 *  the port variables if they still are what we set them to originally.
 *  This avoids unwanted system crashes.
 */

void ResetMsgPort()
{
   Forbid();
   if (thePort->mp_SigBit == theSignal && thePort->mp_SigTask == theTask)
      thePort->mp_SigTask = oldTask;
   Permit();
   
   SetTaskPri(theTask,(ULONG)oldPri);
}


/*
 *  GetSignal()
 *
 *  Try to allocate the same signal that the UserPort is using (this saves
 *  a lot of trouble when we want to signal the original process).  If the
 *  signal is already in use, we give the user the option of aborting or
 *  re-using the signal (we may be signalled at the wrong times if we do).
 *  GotSignal is used when we want to free the signal later.
 */

void GetSignal()
{
   char c;

   if (AllocSignal(theSignal) != theSignal)
   {
      printf("Signal %ld already in use - continue anyway?  ",theSignal);
      c = getchar();
      if (c != 'y' && c != 'Y')
      {
         ResetMsgPort();
         DoExit("Monitor aborted");
      }
   } else {
      GotSignal = TRUE;
   }
}


/*
 *  These macros are helpful in printing the Qualifier fields of the
 *  IntuiMessage that we received
 */

#define CODE            (Code & ~IECODE_UP_PREFIX)
#define QUAL(x)         (Qualifier & (x))
#define ADDQUAL(n)      s = AddQual(s,n)
#define ADDCHAR(c)      *s++ = c;
#define ADDLETTER(q,c)  if (QUAL(q)) ADDCHAR(c);

/*
 *  These are shorhands for the InputEvent qualifier flags
 */

#define LSHIFT          IEQUALIFIER_LSHIFT
#define RSHIFT          IEQUALIFIER_RSHIFT
#define LOCK            IEQUALIFIER_CAPSLOCK
#define SHIFT           (LSHIFT | RSHIFT | LOCK)
#define CONTROL         IEQUALIFIER_CONTROL
#define LALT            IEQUALIFIER_LALT
#define RALT            IEQUALIFIER_RALT
#define ALT             (LALT | RALT)
#define LAMIGA          IEQUALIFIER_LCOMMAND
#define RAMIGA          IEQUALIFIER_RCOMMAND
#define AMIGAS          (LAMIGA | RAMIGA)
#define NUMPAD          IEQUALIFIER_NUMERICPAD
#define REPEAT          IEQUALIFIER_REPEAT
#define MBUTTON         IEQUALIFIER_MIDBUTTON
#define RBUTTON         IEQUALIFIER_RBUTTON
#define LBUTTON         IEQUALIFIER_LEFTBUTTON
#define ANYBUTTON       (LBUTTON | RBUTTON | MBUTTON)
#define RELMOUSE        IEQUALIFIER_RELATIVEMOUSE

/*
 *  AddQual()
 *
 *  Add a comma and a qualifier name to a string and return a pointer
 *  to the character after the end of the added name.
 */

char *AddQual(s,name)
char *s, *name;
{
   *s++ = ',';
   strcpy(s,name);
   return(s + strlen(s));
}


/*
 *  ShowQual()
 *
 *  Display the type of IntuiMessage that we received together with
 *  the mouse position and qualifier flags (if any).  Buttons, shift,
 *  ALT, and Amiga keys are listed with L for left, R for right, M for
 *  middle (button, for future compatibility), and C for CapsLock.
 *
 *  If the event occured in a window other than the monitored one (but
 *  that uses the same UserPort as the monitored window), the window
 *  name is displayed as well (in square brackets).
 */

void ShowQual(name,theMessage)
char *name;
struct IntuiMessage *theMessage;
{
   USHORT Qualifier = theMessage->Qualifier;
   char qual[85];
   char *s = &qual[0];
   int len = 26;

   printf("%-17s (%03d,%03d)",name,theMessage->MouseX,theMessage->MouseY);
   if (Qualifier)
   {
      printf(" %04X",Qualifier); len += 5;
      if (QUAL(ANYBUTTON))
      {
         ADDQUAL("Button(");
         ADDLETTER(LBUTTON,'L');
         ADDLETTER(RBUTTON,'R');
         ADDLETTER(MBUTTON,'M');
         ADDCHAR(')');
      }
      if (QUAL(REPEAT)) ADDQUAL("Repeat");
      if (QUAL(NUMPAD)) ADDQUAL("NumPad");
      if (QUAL(AMIGAS))
      {
         ADDQUAL("Amiga(");
         ADDLETTER(LAMIGA,'L');
         ADDLETTER(RAMIGA,'R');
         ADDCHAR(')');
      }
      if (QUAL(ALT))
      {
         ADDQUAL("ALT(");
         ADDLETTER(LALT,'L');
         ADDLETTER(RALT,'R');
         ADDCHAR(')');
      }
      if (QUAL(CONTROL)) ADDQUAL("CTRL");
      if (QUAL(SHIFT))
      {
         ADDQUAL("Shift(");
         ADDLETTER(LSHIFT,'L');
         ADDLETTER(RSHIFT,'R');
         ADDLETTER(LOCK,  'C');
         ADDCHAR(')');
      }
      ADDCHAR('\0');
      if (qual[0] != '\0')
      {
         qual[0] = ' ';
         len += strlen(qual);
         if (len > 76)
         {
            printf("\n"); len -= 31;
         }
         printf(qual);
      }
   }
   if (theMessage->IDCMPWindow != theWindow)
   {
      if (len + strlen(theMessage->IDCMPWindow->Title) > 72) printf("\n");
      printf(" [%s]",theMessage->IDCMPWindow->Title);
   }
}


/*
 *  ShowMouse()
 *
 *  Display a mouse button code.  We use the constants as defined in
 *  Intuition.h
 */

void ShowMouse(Code)
int Code;
{
   if (Code == SELECTUP)   printf("\n SELECTUP");
   if (Code == SELECTDOWN) printf("\n SELECTDOWN");
   if (Code == MENUUP)     printf("\n MENUUP");
   if (Code == MENUDOWN)   printf("\n MENUDOWN");
}

/*
 *  Macros for Gadget fields
*/

#define GFLAG(f)    (theGadget->Flags & (f))
#define GTYPEF(t)   ((theGadget->GadgetType & GADGETTYPE) & (t))
#define GTYPE(t)    ((theGadget->GadgetType & ~GADGETTYPE) == (t))


/*
 *  ShowGadget()
 *
 *  Display information about gadget messages:  the GadgetID field,
 *  the GadgetText (if non-NULL), the GadgetType, and the GadgetFlags 
 *  (as a HEX value).  If the gadget is a STRGADGET, the contents of the
 *  StringInfo buffer is displayed.  If the gadget is a PROPGADGET, the
 *  values of the Pot and Body fields of the PropInfo structure are shown
 *  (for the directions that the gadget moves), and the status of the KNOBHIT
 *  flag is printed.
 */

void ShowGadget(theGadget)
struct Gadget *theGadget;
{
   int special = (GTYPE(STRGADGET) || GTYPE(PROPGADGET));
   struct StringInfo *SI = (struct StringInfo *) theGadget->SpecialInfo;
   struct PropInfo   *PI = (struct PropInfo *)   theGadget->SpecialInfo;

   printf("\n ID = %d,",theGadget->GadgetID);
   if (theGadget->GadgetText && theGadget->GadgetText->IText)
      printf(" '%s'",theGadget->GadgetText->IText);
   if (GTYPE(STRGADGET))  printf(" STRGADGET");
   if (GTYPE(BOOLGADGET)) printf(" BOOLGADGET");
   if (GTYPE(PROPGADGET)) printf(" PROPGADGET");
   if (GTYPEF(REQGADGET)) printf("+REQGADGET");
   if (GFLAG(SELECTED))   printf(" (SELECTED)");
   printf(", Flags = %04X",theGadget->Flags);
   if (special)
   {
      printf("\n");
      if (GTYPE(STRGADGET))
      {
         if (SI->Buffer) printf(" Buffer = '%s'",SI->Buffer);
      } else {
         if (PI->Flags & FREEHORIZ)
            printf(" HPot = %5d, HBody = %5d,",PI->HorizPot,PI->HorizBody);
         if (PI->Flags & FREEVERT)
            printf(" VPot = %5d, VBody = %5d,",PI->VertPot,PI->VertBody);
         if (PI->Flags & KNOBHIT)
            printf(" KNOBHIT");
           else
            printf(" Knob not hit");
      }
   }
}


/*
 *  Macros for menu fields
 */
#define ITEXT(p)    (((struct IntuiText *)((p)->ItemFill))->IText)
#define MFLAG(f)    (theMItem->Flags & (f))


/*
 *  ShowMenu()
 *
 *  Display the message's Code field and translate it into the menu number,
 *  the item number and the sub-item number.  Then look through the
 *  window's MenuStrip for each of these items (ItemAddress only gives us the
 *  final address, so we look though the MenuStrip by hand), and print their
 *  menu text (if they are text items).  Finally, if the menu item is checked,
 *  we report that.
 *
 *  Since the Amiga allows multiple menu items to be picked within the same
 *  MENUPICK message, we follow the NextSelect field and print out the
 *  data for each additional menu item that was picked.
 */

void ShowMenu(Code,theWindow)
int Code;
struct Window *theWindow;
{
   int menu,item,sub;
   struct Menu *theMenu;
   struct MenuItem *theMItem;
   extern struct MenuItem *ItemAddress();

   do
   {
      if (Code == MENUNULL)
      {
         printf("\n Code = MENUNULL (NOMENU,NOITEM,NOSUB)");
      } else {
         menu = MENUNUM(Code);
         item = ITEMNUM(Code);
         sub  = SUBNUM(Code);
         printf("\n Code = %4X (%d",Code,menu);
         if (item == NOITEM) printf(",NOITEM"); else printf(",%d",item);
         if (sub == NOSUB) printf(",NOSUB)"); else printf(",%d)",sub);

         for(theMenu = theWindow->MenuStrip; menu; menu--)
            theMenu = theMenu->NextMenu;
         printf("  %s",(theMenu->MenuName)? theMenu->MenuName: "[NONAME]");

         for (theMItem = theMenu->FirstItem; item; item--)
            theMItem = theMItem->NextItem;
         if (MFLAG(ITEMTEXT) && theMItem->ItemFill && ITEXT(theMItem))
            printf(", %s",ITEXT(theMItem)); else printf(", [NONAME]");

         if (sub != NOSUB)
         {
            for (theMItem = theMItem->SubItem; sub; sub--)
               theMItem = theMItem->NextItem;
            if (MFLAG(ITEMTEXT) && theMItem->ItemFill && ITEXT(theMItem))
               printf(", %s",ITEXT(theMItem)); else printf(", [NONAME]");
         }

         if (MFLAG(CHECKED)) printf(" (CHECKED)");
         Code = (ItemAddress(theWindow->MenuStrip,(ULONG)Code))->NextSelect;
      }
   } while (Code != MENUNULL);
}


/*
 *  Cheap translation of RAWKEY key codes to their keyboard equivalents.
 *  I could have used RawKeyConvert, but that requires a console device
 *  to be opened, but I didn't want to bother with that.
 */

char Keys[] =
{
 '`','1','2','3','4','5','6','7','8','9','0','-','=','\\',NULL,'\012',
 'Q','W','E','R','T','Y','U','I','O','P','[',']',NULL,'\001','\002','\003',  
 'A','S','D','F','G','H','J','K','L',';','"',NULL,NULL,'\004','\005','\006',
 NULL,'Z','X','C','V','B','N','M',',','.','/',NULL,'\013','\007','\010','\011'
};

/*
 *  Names for non-printing keys
 */

char *KNames[] =
{
   "UNDEFINED", "SPACE", "BACKSPACE", "TAB", "ENTER", "RETURN", "ESC",
   "DEL", NULL, NULL, NULL, "KeyPad -", NULL, "UP ARROW", "DOWN ARROW", 
   "RIGHT ARROW", "LEFT ARROW", "F1", "F2", "F3", "F4", "F5", "F6", "F7",
   "F8", "F9", "F10", NULL, NULL, NULL, NULL, NULL, "HELP", "LEFT SHIFT",
   "RIGHT SHIFT", "CAPS LOCK", "CTRL", "LEFT ALT", "RIGHT ALT", "LEFT AMIGA",
   "RIGHT AMIGA", "LEFT BUTTON", "RIGHT BUTTON", "MIDDLE BUTTON"
};

/*
 *  Error conditions (just to be complete; I don't even know how to
 *  generate these, so I couldn't test that they worked)
 */

char *KErrs[] =
{
   "LAST WAS BAD", "BUFFER OVERFLOW", "CATASTROPHE", "TEST FAILED",
   "POWERUP START", "POWERUP END", "MOUSE MOVE"
};

#define FIRST_NAME      0x40
#define FIRST_ERROR     0xF9
#define KEYCODEMASK     (~IECODE_UP_PREFIX)


/*
 *  ShowKey()
 *
 *  Display the RAWKEY code and which keyboard key produced it.  The
 *  IntuiMessage IAddress field points to the previous key pressed so that
 *  Dead Keys (ones that produce diacritical markings) can be implemented.
 *  See the Enhancer documentation (pp 65-66) for more information.  I used
 *  trial-and-error to figure out what they were pointing at.  It looks like
 *  additional previous keystrokes are stored farther along, but I don't
 *  know how long they are valid.
 */

void ShowKey(Code,PrevKey)
int Code;
unsigned char *PrevKey;
{
   unsigned char c = Code & KEYCODEMASK;
   unsigned char c1, *s;

   printf("\n Key %02X %s",c,(Code & IECODE_UP_PREFIX)? "UP  ": "DOWN");
   if (c < FIRST_NAME)
   {
      c1 = Keys[c];
      if (c1 > ' ')
      {
         printf(" (%c)",c1);
      } else {
         if (c1 == '\013')
            printf(" (KeyPad .)");
           else
            printf(" (KeyPad %c)",(c1 % 10) + '0');
      }
   } else {
      if (Code >= FIRST_ERROR)
      {
         printf(" (%s)",KErrs[Code-FIRST_ERROR]);
      } else {
         s = KNames[c - FIRST_NAME + 1];
         if (s == NULL) s = KNames[0];
         printf(" (%s)",s);
      }
   }
   if (PrevKey && *PrevKey)
   {
      printf(" Previous = %02X",*PrevKey++);
      if (*PrevKey) printf(" Qualifiers = %02X",*PrevKey);
   }
}


/*
 *  ShowVanilla()
 *
 *  Display the ASCII key that was reported.  Non-printing characters
 *  are shown in a semi-reasonable fashion (I don't really like the
 *  "META" stuff).
 */

void ShowVanilla(Code)
int Code;
{
   unsigned char c = Code & 0x7F;

   printf("\n ASCII = %02X",Code);
   if (c >= ' ' && c < 0x7F)
   {
      printf("  (%c",Code);
      if (Code > 0x7F) printf(" = META-%c",c);
      printf(")");
   } else {
      if (c < ' ')
         printf("  (CTRL-%s%c)",(Code > 0x7F)? "META-" :"",c+'@');
        else
         printf("  (%sDEL)",(Code > 0x7F)? "META-" :"");
   }
}


/*
 *  PrintMessage()
 *
 *  Call the right routines for each message class.  Only those that were
 *  specified in the MASK on the command line (default is all messages) are
 *  shown.  Note that only those messages that are actually POSTED to the
 *  UserPort are received by the monitor, so only those classes that appear
 *  in both the MASK and in the window's IDCMPFlags field are shown.  That is
 *  to say, we do NOT perform a ModifyIDCMP() call to include any classes that
 *  are not in the IDCMPFlags field of the window.
 *
 *  If a CLOSEWINDOW event is received for the monitored window, the monitor
 *  assumes that the window is about to be closed and the UserPort freed so
 *  it stops monitoring the window.  If another window using the same port is
 *  closed, however, the monitor does not shut down.
 */

void PrintMessage(theMessage)
struct IntuiMessage *theMessage;
{
   ULONG  Class = theMessage->Class;
   USHORT Code  = theMessage->Code;

   if (EventMask & Class)
   {
      switch(Class)
      {
         case SIZEVERIFY:
            ShowQual("Size Verify",theMessage);
            break;

         case NEWSIZE:
            ShowQual("New Size",theMessage);
            break;

         case REFRESHWINDOW:
            ShowQual("Refresh Window",theMessage);
            break;

         case MOUSEBUTTONS:
            ShowQual("Mouse Button",theMessage);
            ShowMouse(Code);
            break;
   
         case MOUSEMOVE:
            ShowQual("Mouse move",theMessage);
            break;

         case GADGETDOWN:
            ShowQual("Gadget Down",theMessage);
            ShowGadget(theMessage->IAddress);
            break;

         case GADGETUP:
            ShowQual("Gadget Up",theMessage);
            ShowGadget(theMessage->IAddress);
            break;

         case REQSET:
            ShowQual("Requester Set",theMessage);
            break;

         case MENUPICK:
            ShowQual("Menu Pick",theMessage);
            ShowMenu(Code,theMessage->IDCMPWindow);
            break;

         case CLOSEWINDOW:
            ShowQual("Close Window",theMessage);
            break;

         case RAWKEY:
            ShowQual("Raw Key",theMessage);
            ShowKey(Code,theMessage->IAddress);
            break;

         case REQVERIFY:
            ShowQual("Requester Verify",theMessage);
            break;

         case REQCLEAR:
            ShowQual("Requester Clear",theMessage);
            break;

         case MENUVERIFY:
            ShowQual("Menu Verify",theMessage);
            break;

         case NEWPREFS:
            ShowQual("New Preferences",theMessage);
            break;

         case DISKINSERTED:
            ShowQual("Disk Inserted",theMessage);
            break;

         case DISKREMOVED:
            ShowQual("Disk Removed",theMessage);
            break;

         case WBENCHMESSAGE:
            ShowQual("WorkBench Message",theMessage);
            if (Code == WBENCHOPEN)  printf("\n Code = WBENCHOPEN");
            if (Code == WBENCHCLOSE) printf("\n Code = WBENCHCLOSE");
            break;

         case ACTIVEWINDOW:
            ShowQual("Activate Window",theMessage);
            break;

         case INACTIVEWINDOW:
            ShowQual("Inactivate Window",theMessage);
            break;

         case VANILLAKEY:
            ShowQual("Vanilla Key",theMessage);
            ShowVanilla(Code);
            break;

         case INTUITICKS:
            ShowQual("IntuiTicks",theMessage);
            break;

         default:
            printf("Unknown Class:  %04X",theMessage->Class);
            if (theMessage->IDCMPWindow != theWindow)
               printf("   (%s)",theMessage->IDCMPWindow->Title);
            break;
      }
      printf("\n");
   }
   if (Class == CLOSEWINDOW && theMessage->IDCMPWindow == theWindow)
      NotDone = FALSE;
}


/*
 *  MonitorIDCMP()
 *
 *  This is the main loop for the monitor process.  It calls Wait() to
 *  wait for either a message to arrive in the UserPort or for a CTRL-C
 *  to be pressed.  CTRL-C tells MonIDCMP to stop monitoring and clean things
 *  up.
 *
 *  When a message appears in the UserPort, we look through the message list
 *  structure (an Exec List of Exec Node structures), which contains the
 *  pointers to the IntuiMessages posted to the UserPort by Intuition.
 *  Forbid() and Permit() are used so that the list doesn't change while we're 
 *  looking at it.  These should be LockIBase() and UnlockIBase(), but I don't
 *  have the documentation for these, so I can't use them.
 *
 *  For each message in the list we check to see if we've seen it already
 *  and if not, we print it and mark it as seen.  Since Intuition may post
 *  messages to the UserPort at any time (e.g., after we have signalled the
 *  monitored process that new messages have arrived, but before it has had 
 *  a chance to GetMsg() all of them), we have to know which messages we've
 *  already printed and which are new, so when Intuition signals us we don't
 *  reprint messages that are still in the message list.  To do this, we use
 *  a bit of a kludge:  we alter the message's ln_Type field (which should be
 *  NT_MESSAGE) by setting the high bit.  The monitored process doesn't usually
 *  use this field, and it doesn't seem to annoy GetMsg() or ReplyMsg(), so 
 *  I think it works.  The key is that when Intuition re-uses the message, it 
 *  resets this field (actually, I suspect PutMsg() does this), so we can tell
 *  new messages from old messages.  I tried using the ln_Pri and other un-used
 *  Node fields, but these were not reset, so were not useful for this function.
 *  Take note, however, that this DOES alter the contents of the message, and
 *  may cause some programs to malfucntion.
 *
 *  Another approach would have been to take over the ReplyPort for the
 *  messages and keep track of which ones have come back, but this seemed
 *  needlessly complicated and caused other problems instead,
 *
 *  Once we are through printing the new messages, we Permit() and then
 *  Signal() the monitored process that new messages have arrived.  It then
 *  processes them normally, and calls ReplyMsg() itself.
 *
 *  We rely on the fact that we are running at a higher priority than the
 *  monitored process in order to get ALL the messages, even ones that come
 *  while that process is running (i.e., not in a Wait() call).  If the
 *  monitored process calls Forbid() or changes it's priority, however, we
 *  are likely to miss messages, particularly ones that come in groups
 *  (INACTIVEWINDOW/ACTIVEWINDOW, MENUUP/MENUPICK, etc.).
 *
 *  WARNING:  since we print the contents of the messages BEFORE the 
 *  monitored process gets them, this can cause deadlock situations.  For 
 *  instnace, suppose the monitored process has locked the screen layers and
 *  is waiting for mouse moves or button releases.  When these arrive, MonIDCMP
 *  tries to print them, but the layers are locked, so it waits for them to
 *  become unlocked; but this never happens, since the monitored process is
 *  waiting for MonIDCMP to signal the messages.  This appears to be what 
 *  happens when you monitor the WorkBench window and try to move a disk icon, 
 *  for example.  To solve this problem, you can re-direct the output from 
 *  MonIDCMP to a file rather than to the screen.
 *
 *  Note that this method of monitoring a port is not resticted to the
 *  IDCMP ports.  It can be used on ANY port, provided you know where to 
 *  look for it, and what it's contents are supposed to look like.
 */

void MonitorIDCMP()
{
   struct Node *theNode;
   UBYTE theType;
   
   while (NotDone)
   {
      if (Wait(theMask | SIGBREAKF_CTRL_C) & SIGBREAKF_CTRL_C)
      {
         printf("Cancelling...");
         NotDone = FALSE;
      } else {
         if (theMsgList->lh_TailPred != (struct Node *) theMsgList)
         {
            Forbid();
            for (theNode = theMsgList->lh_Head; theNode->ln_Succ;
               theNode = theNode->ln_Succ)
            {
               if (((theType = theNode->ln_Type) & SHOWN_FLAG) == 0)
               {
                  if (theType != NT_MESSAGE) printf("Type: 0x%X - ",theType);
                  PrintMessage(theNode);
                  theNode->ln_Type |= SHOWN_FLAG;
               }
            }
            Permit();
         }
         Signal(oldTask,theMask);
      }
   }
}


/*
 *  MonitorWindow()
 *
 *  Get the pointer to the window that the user has specified and set up
 *  the MsgPort so that we are signalled when messages arrive in it.  Once
 *  this is done, identify the program, and start the monitoring.  When
 *  the user presses CTRL-C (or closes the monitored window), we are done, so
 *  we clean up the MsgPort and free the signal, then quit.
 */

void MonitorWindow()
{
   theTask = FindTask(NULL);

   FindWindow();
   #ifdef LATTICE
      onbreak(Ctrl_C);
   #endif
   SetupMsgPort();
   GetSignal();

   printf("%s - IDCMP Monitor Program\n",version);
   printf("Monitor Installed - press CTRL-C to cancel\n");

   MonitorIDCMP();

   ResetMsgPort();
   if (GotSignal) FreeSignal(theSignal);
   printf("Monitor Removed\n");
}


/*
 *  main()
 *
 *  Open Intuition and then parse the command-line options to find out what
 *  action the user wants to do.  Either print the usage information or
 *  call the proper routine.  When we're done, exit with no message.
 */

void main(argc,argv)
int argc;
char *argv[];
{
   CheckLibOpen(&IntuitionBase,"intuition.library",INTUITION_REV);

   switch(ParseArguments(argc,argv))
   {
      case SHOW_USAGE:
         printf("Usage:  %s",USAGE);
         printf("   or   MonIDCMP LIST WINDOWS\n");
         break;

      case LIST_WINDOWS:
         ListWindows();
         break;

      case MONITOR_WINDOW:
         MonitorWindow();
         break;
   }
   DoExit(NULL);
}
