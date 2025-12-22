/*-----------------------------------------------------------
--   Program: DiskFont.c
--    Author: Intuition Ed 
--      Date: Thu May 24
--  Funktion: Example of how to display a DiskFont.
--            A 'ruby.font' is opend.
--            Therefore it must be in the current Font directory.
------------------------------------------------------------*/


#include <intuition/intuition.h>



void                   Open_All() ;
void                   Close_All();


struct IntuitionBase  *IntuitionBase;
struct GfxBase        *GfxBase;
ULONG                 *DiskfontBase;
struct Window         *Window;
struct Font           *Text1Font;


struct TextAttr Text1TextAttr =
{
 (STRPTR) "ruby.font",                    /* ta_Name                   */
  15,                                     /* ta_YSize                  */
 NULL,                                    /* ta_Style                  */
 FPF_DISKFONT ,                           /* ta_Flags                  */
};

struct IntuiText Text1 =
{
  -1, -1,                                 /* FrontPen , BackPen        */
 JAM1,                                    /* DrawMode                  */
  20, 20,                                 /* LeftEdge , TopEdge        */
 &Text1TextAttr ,                         /* TextAttr                  */
 (UBYTE *) "ruby.font   (15)",            /* Text                      */
 NULL,                                    /* Last Text !               */
};

struct NewWindow NewWindow =
{
  10, 20,                                 /* LeftEdge , TopEdge        */
 300, 50,                                 /* Width , Height            */
   0,  1,                                 /* DetailPen , BlockPen      */
 NULL,                                    /* IDCMP Flags               */
 WINDOWSIZING                             /* Flags                     */
 | WINDOWDRAG | WINDOWDEPTH | SMART_REFRESH | ACTIVATE,
 NULL,                                    /* No Gadget                 */
 NULL,                                    /* Check Mark                */
 (UBYTE *) "Example of a DiskFont :",     /* Title                     */
 NULL,                                    /* Screen                    */
 NULL,                                    /* BitMap                    */
 100, 20,                                 /* MinWidth , MinHeight      */
 640,256,                                 /* MaxWidth , MaxHeight      */
 WBENCHSCREEN,                            /* ScreenType                */
};


void main()
{
Open_All();
Delay(1000L);
Close_All();
}


void Open_All()
{
 void                  PrintIText();
 struct Window        *OpenWindow();
 struct Font          *OpenDiskFont();
 void                 *OpenLibrary();

 if (NOT(IntuitionBase = (struct IntuitionBase *)
       OpenLibrary ("intuition.library", 0L)))
 {
  printf("Where is my Intuition Library ??");
  Close_All();
  exit(FALSE);
 }

 if (NOT(GfxBase = (struct GfxBase *)
    OpenLibrary("graphics.library",0L)))
 {
  printf("No Grafik Library found.");
  Close_All();
  exit(FALSE);
 }

 if (NOT(DiskfontBase = (ULONG *)
    OpenLibrary("diskfont.library",0L)))
 {
  printf("No DiskFont Library found.");
  Close_All();
  exit(FALSE);
 }

 if (NOT(Window = (struct Window *)
       OpenWindow (&NewWindow )))
 {
  printf("Window -  WB-Window can't be displayed.\n");
  Close_All();
  exit(FALSE);
 }

 if (NOT(Text1Font = (struct Font *)
   OpenDiskFont (&Text1TextAttr)))
 {
  printf("The DiskFont Text1Font can't be opend.\n");
  Close_All();
  exit(FALSE);
 }

 SetFont (Window->RPort,Text1Font);

 PrintIText (Window->RPort,&Text1,0L,0L);
}


void Close_All()
{
 void                  CloseWindow();
 void                  CloseLibrary();

 if (Text1Font)  CloseFont(Text1Font);
 if (Window)   CloseWindow (Window) ;

 if (GfxBase)           CloseLibrary(GfxBase);
 if (DiskfontBase)      CloseLibrary(DiskfontBase);
 if (IntuitionBase)     CloseLibrary(IntuitionBase);
}
