/*-----------------------------------------------------------
--  Programm: PropGad.c
--     Autor: Intuition Ed 
--     Datum: Tue Apr  3
--  Funktion: Example of a two-dimensions Propartionalgadget.
              written by Intuition Ed
              (main function changed) 
------------------------------------------------------------/*


/*-------------------
--  Include  :     --
-------------------*/

#include <intuition/intuition.h>


/*-------------------
--  Define   :     --
-------------------*/

#define GADGET1_GAD                              0

#define HORIZGADGET1_POS   (MAXBODY/100)
#define VERTGADGET1_POS   (MAXBODY/200)

/*-------------------
--  Functions   :  --
-------------------*/

void                   Open_All() ;
void                   Close_All();

/*-------------------
--  extern         --
--  Variables  :   --
-------------------*/

struct IntuitionBase  *IntuitionBase;
struct Window         *Window1;


/*-------------------
--  Structures  :  --
-------------------*/


struct Image    Gadget1Image;
struct PropInfo Gadget1PropInfo =
{
 FREEHORIZ                                /* Flags                     */
 | AUTOKNOB
 | FREEVERT,
 HORIZGADGET1_POS * 50,                   /* HorizPot                  */
 VERTGADGET1_POS * 100,                   /* VertPot                   */
 HORIZGADGET1_POS * 10,                   /* HorizBody                 */
 VERTGADGET1_POS * 20,                    /* VertBody                  */
 0,                                       /* CWidth                    */
 0,                                       /* CHeight                   */
 0,                                       /* HPotRes                   */
 0,                                       /* VPotRes                   */
 0,                                       /* LeftBorder                */
 0,                                       /* TopBorder                 */
};

struct Gadget Gadget1 =
{
 NULL,                                    /* Last Gadget               */
  50, 25,                                 /* LeftEdge , TopEdge        */
 100,100,                                 /* Width , Height            */
 GADGHCOMP,                               /* Flags                     */
 RELVERIFY,                               /* Activation                */
 PROPGADGET,                              /* Gadget Type               */
 (APTR)&Gadget1Image,                     /* Gadget Render             */
 NULL,                                    /* No Selected Render        */
 NULL,                                    /* No Gadget Text            */
 NULL,                                    /* Mutual Exclude            */
 (APTR)&Gadget1PropInfo,                  /* SpecialInfo               */
 GADGET1_GAD,                             /* Gadget ID                 */
 NULL,                                    /* User Data                 */
};

/*-  NewWindow  :   ---
---  Window1        -*/

struct NewWindow NewWindow1 =
{
  20, 10,                                 /* LeftEdge , TopEdge        */
 200,150,                                 /* Width , Height            */
   0,  1,                                 /* DetailPen , BlockPen      */
 GADGETDOWN                               /* IDCMP Flags               */
 | GADGETUP
 | CLOSEWINDOW,
 WINDOWSIZING                             /* Flags                     */
 | WINDOWCLOSE
 | WINDOWDRAG
 | WINDOWDEPTH
 | SMART_REFRESH
 | ACTIVATE,
 &Gadget1,                                /* First Gadget              */
 NULL,                                    /* Check Mark                */
 NULL,                                    /* No Title                  */
 NULL,                                    /* Screen                    */
 NULL,                                    /* BitMap                    */
  80, 30,                                 /* MinWidth , MinHeight      */
 640,256,                                 /* MaxWidth , MaxHeight      */
 WBENCHSCREEN,                            /* ScreenType                */
};

/*-----------------------------------------------------------
--  Functionname: main
--   Returnvalue:  --
--        Remark: Calls Open_All and Close_All .
------------------------------------------------------------*/

void main()
{
 struct IntuiMessage  *message;
 struct Message       *GetMsg();

 Open_All();
   
 FOREVER
 {
  if (NOT(message = (struct IntuiMessage *)
        GetMsg(Window1->UserPort)))
  {
   Wait(1L << Window1->UserPort->mp_SigBit);
   continue;
  }
  ReplyMsg(message);

  switch (message->Class)
  {
   case GADGETUP    : printf(" Vert.Position: %u\n"   ,(int)(Gadget1PropInfo.VertPot/VERTGADGET1_POS));
                      printf("Horiz.Position: %u\n\n",(int)(Gadget1PropInfo.HorizPot/HORIZGADGET1_POS));
                      break;
         
   case CLOSEWINDOW : Close_All();
                      exit(TRUE);
         
  }
 }
}

/*-----------------------------------------------------------
--  Functionname: Open_All
--          Task: Opens Intuitionlibrary,
--                and structures.
--  Required variables
--              :  --
--    Returntask:  --
--        Remark: Calls Cose_All in case of trubble.
------------------------------------------------------------*/


void Open_All()
{
 struct Window        *OpenWindow();
 void                 *OpenLibrary();

 if (NOT(IntuitionBase = (struct IntuitionBase*)
       OpenLibrary ("intuition.library", 0L)))
 {
  printf("No Intuition Library !!");
  Close_All();
  exit(FALSE);
 }

 if (NOT(Window1 = (struct Window *)
       OpenWindow (&NewWindow1 )))
 {
  printf("Window1 -  WB-Window can't be opend.\n");
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
