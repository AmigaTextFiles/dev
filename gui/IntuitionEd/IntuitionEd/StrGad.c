/*-----------------------------------------------------------
--      Name: StrGad.c
--    Author: Intuition Ed 
--      Date: Wed Sep  5
--      Task: 
------------------------------------------------------------/*


/*-------------------
--  Include   :    --
-------------------*/

#include <intuition/intuition.h>


/*-------------------
--  Define   :     --
-------------------*/

/*
 This is a stringgadget demo
 to show Intuition Ed's possibilities.
 It's written by the complete vesion of Intuition Ed.
*/


#define STRGAD4_GAD		0
#define STRGAD3_GAD		1
#define STRGAD2_GAD		2
#define STRGAD1_GAD		3

/*-------------------
--   Functions  :  --
-------------------*/

void                   Open_All() ;
void                   Close_All();

/*-------------------
--  extern         --
--  Variables  :   --
-------------------*/

struct IntuitionBase  *IntuitionBase;
struct Window         *Window1;

UBYTE StrGad4Buffer[21] = "-.-.-.-.-.-.";
UBYTE StrGad4UndoBuffer[21];

UBYTE StrGad3Buffer[21] = "-.-.-.-.-.-.";
UBYTE StrGad3UndoBuffer[21];

UBYTE StrGad2Buffer[301] = "This demo program is written by Intuition Ed with my inputs.";
UBYTE StrGad2UndoBuffer[301];

UBYTE StrGad1Buffer[301] = "You  need the entire version of Intuition Ed to create gadgets.";
UBYTE StrGad1UndoBuffer[301];

/*-------------------
--  Structures  :  --
-------------------*/


SHORT Border3Pairs [] =
{
  -1,-1,  -1,12,  145,12,  145,-1,  -1,-1,
};

struct Border Border3 =
{
  -1, -1,                                 /* LeftEdge , TopEdge        */
   3,  0,                                 /* FrontPen , BackPen        */
 JAM1,                                    /* Draw Mode                 */
   5,                                     /* Count                     */
 Border3Pairs ,                           /* * X Y                     */
 NULL,                                    /* Last Border               */
};

struct StringInfo StrGad4StringInfo =
{
 StrGad4Buffer,                           /* Buffer                    */
 StrGad4UndoBuffer,                       /* UndoBuffer                */
   0,                                     /* BufferPos                 */
  21,                                     /* BufferSize                */
   0,  0,                                 /* DispPos , UndoPos         */
   0,                                     /* Numchars                  */
   0,                                     /* DispCount                 */
   0,  0,                                 /* CLeft , CTop              */
 NULL,                                    /* LayerPtr                  */
 NULL,                                    /* LongInt                   */
 NULL,                                    /* AltKeyMap                 */
};

struct Gadget StrGad4 =
{
 NULL,                                    /* Last Gadget               */
 175, 60,                                 /* LeftEdge , TopEdge        */
 145, 12,                                 /* Width , Height            */
 GADGHCOMP,                               /* Flags                     */
 STRINGRIGHT,                             /* Activation                */
 STRGADGET,                               /* Gadget Type               */
 (APTR)&Border3,                          /* Gadget Render             */
 NULL,                                    /* No Selected Render        */
 NULL,                                    /* No Gadget Text            */
 NULL,                                    /* Mutual Exclude            */
 (APTR)&StrGad4StringInfo,                /* Special Info              */
 STRGAD4_GAD,                             /* Gadget ID                 */
 NULL,                                    /* User Data                 */
};

struct StringInfo StrGad3StringInfo =
{
 StrGad3Buffer,                           /* Buffer                    */
 StrGad3UndoBuffer,                       /* UndoBuffer                */
   0,                                     /* BufferPos                 */
  21,                                     /* BufferSize                */
   0,  0,                                 /* DispPos , UndoPos         */
   0,                                     /* Numchars                  */
   0,                                     /* DispCount                 */
   0,  0,                                 /* CLeft , CTop              */
 NULL,                                    /* LayerPtr                  */
 NULL,                                    /* LongInt                   */
 NULL,                                    /* AltKeyMap                 */
};

struct Gadget StrGad3 =
{
 &StrGad4,                                /* Next Gadget               */
  10, 60,                                 /* LeftEdge , TopEdge        */
 145, 12,                                 /* Width , Height            */
 GADGHCOMP,                               /* Flags                     */
 NULL,                                    /* Activation                */
 STRGADGET,                               /* Gadget Type               */
 (APTR)&Border3,                          /* Gadget Render             */
 NULL,                                    /* No Selected Render        */
 NULL,                                    /* No Gadget Text            */
 NULL,                                    /* Mutual Exclude            */
 (APTR)&StrGad3StringInfo,                /* Special Info              */
 STRGAD3_GAD,                             /* Gadget ID                 */
 NULL,                                    /* User Data                 */
};

SHORT Border2Pairs [] =
{
  -1,-1,  -1,12,  300,12,  300,-1,  -1,-1,
};

struct Border Border2 =
{
  -1, -1,                                 /* LeftEdge , TopEdge        */
   2,  0,                                 /* FrontPen , BackPen        */
 JAM1,                                    /* Draw Mode                 */
   5,                                     /* Count                     */
 Border2Pairs ,                           /* * X Y                     */
 NULL,                                    /* Last Border               */
};

struct StringInfo StrGad2StringInfo =
{
 StrGad2Buffer,                           /* Buffer                    */
 StrGad2UndoBuffer,                       /* UndoBuffer                */
  38,                                     /* BufferPos                 */
 301,                                     /* BufferSize                */
   0,  0,                                 /* DispPos , UndoPos         */
   0,                                     /* Numchars                  */
   0,                                     /* DispCount                 */
   0,  0,                                 /* CLeft , CTop              */
 NULL,                                    /* LayerPtr                  */
 NULL,                                    /* LongInt                   */
 NULL,                                    /* AltKeyMap                 */
};

struct Gadget StrGad2 =
{
 &StrGad3,                                /* Next Gadget               */
  20, 40,                                 /* LeftEdge , TopEdge        */
 300, 12,                                 /* Width , Height            */
 GADGHCOMP,                               /* Flags                     */
 STRINGCENTER,                            /* Activation                */
 STRGADGET,                               /* Gadget Type               */
 (APTR)&Border2,                          /* Gadget Render             */
 NULL,                                    /* No Selected Render        */
 NULL,                                    /* No Gadget Text            */
 NULL,                                    /* Mutual Exclude            */
 (APTR)&StrGad2StringInfo,                /* Special Info              */
 STRGAD2_GAD,                             /* Gadget ID                 */
 NULL,                                    /* User Data                 */
};

SHORT Border1Pairs [] =
{
  -1,-1,  -1,12,  300,12,  300,-1,  -1,-1,
};

struct Border Border1 =
{
  -1, -1,                                 /* LeftEdge , TopEdge        */
   1,  0,                                 /* FrontPen , BackPen        */
 JAM1,                                    /* Draw Mode                 */
   5,                                     /* Count                     */
 Border1Pairs ,                           /* * X Y                     */
 NULL,                                    /* Last Border               */
};

struct StringInfo StrGad1StringInfo =
{
 StrGad1Buffer,                           /* Buffer                    */
 StrGad1UndoBuffer,                       /* UndoBuffer                */
  38,                                     /* BufferPos                 */
 301,                                     /* BufferSize                */
   0,  0,                                 /* DispPos , UndoPos         */
   0,                                     /* Numchars                  */
   0,                                     /* DispCount                 */
   0,  0,                                 /* CLeft , CTop              */
 NULL,                                    /* LayerPtr                  */
 NULL,                                    /* LongInt                   */
 NULL,                                    /* AltKeyMap                 */
};

struct Gadget StrGad1 =
{
 &StrGad2,                                /* Next Gadget               */
  10, 20,                                 /* LeftEdge , TopEdge        */
 300, 12,                                 /* Width , Height            */
 GADGHCOMP,                               /* Flags                     */
 STRINGCENTER,                            /* Activation                */
 STRGADGET,                               /* Gadget Type               */
 (APTR)&Border1,                          /* Gadget Render             */
 NULL,                                    /* No Selected Render        */
 NULL,                                    /* No Gadget Text            */
 NULL,                                    /* Mutual Exclude            */
 (APTR)&StrGad1StringInfo,                /* Special Info              */
 STRGAD1_GAD,                             /* Gadget ID                 */
 NULL,                                    /* User Data                 */
};

/*-  NewWindow  :   ---
---  Window1        -*/

struct NewWindow NewWindow1 =
{
  50, 50,                                 /* LeftEdge , TopEdge        */
 350, 80,                                 /* Width , Height            */
   0,  1,                                 /* DetailPen , BlockPen      */
 NULL,                                    /* IDCMP Flags               */
 WINDOWSIZING                             /* Flags                     */
 | WINDOWDRAG | WINDOWDEPTH | SMART_REFRESH | ACTIVATE,
 &StrGad1,                                /* First Gadget              */
 NULL,                                    /* Check Mark                */
 (UBYTE *) "String gadget example :",     /* Title                     */
 NULL,                                    /* Screen                    */
 NULL,                                    /* BitMap                    */
 100, 20,                                 /* MinWidth , MinHeight      */
 640,256,                                 /* MaxWidth , MaxHeight      */
 WBENCHSCREEN,                            /* ScreenType                */
};

/*-----------------------------------------------------------
--  Functionname: main
--  Required variables
--              :  --
--   Returnvalue:  --
--        Remark: Calls Open_All and Close_All.
------------------------------------------------------------*/

void main()
{
Open_All();
Delay(1000L);
Close_All();
}

/*-----------------------------------------------------------
--  Functionname: Open_All
--          Task: Opens Intuitionlibrary
--                and structures.
--  Required variables
--              :  --
--   Returnvalue:  --
--        Remark: Calls Close_All in case of difficulties.
------------------------------------------------------------*/


void Open_All()
{
 void                 *OpenLibrary();
 struct Window        *OpenWindow();

 if (NOT(IntuitionBase = (struct IntuitionBase *)
       OpenLibrary ("intuition.library", 0L)))
 {
  printf("No Intuition Library !!");
  Close_All();
  exit(FALSE);
 }

 if (NOT(Window1 = (struct Window *)
       OpenWindow (&NewWindow1 )))
 {
  printf("Can't open Window1 -  WB-Window .\n");
  Close_All();
  exit(FALSE);
 }

}

/*-----------------------------------------------------------
--  Functionname: Close_All
--          Task: Closes Intuitionlibrary
--                and structures.
--  Required variables
--              :  --
--   Returnvalue:  --
--        Remark:  --
------------------------------------------------------------*/

void Close_All()
{
 void                  CloseWindow();
 void                  CloseLibrary();

 if (Window1)   CloseWindow (Window1) ;
 if (IntuitionBase)     CloseLibrary(IntuitionBase);
}
