/*
 *  Mandelbrot Fraktal
 *
 *  Autor: Norman Walter
 *
 */

#include <exec/types.h>
#include <exec/exec.h>
#include <intuition/intuition.h>
#include <graphics/gfx.h>
#include <dos/dos.h>

#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/exec.h>

// Unsere Header-Datei mit dem Array Colors
#include "Farben.h"

// Platz für 64 Pen-Nummern
LONG Pens[64];

struct IntuitionBase *IntuitionBase;  // Zeiger auf IntuitionBase-Struktur
struct GfxBase *GfxBase;              // Zeiger auf GfxBase-Struktur

/*  InitPens Initialisiert unser Array Pens
 *  Dazu werden die zu den Einträgen im Array Colors
 *  am besten passenden Pens der ColorMap cm herausgesucht
 *  und deren Nummern im Array Pens abgelegt.
 */
void InitPens(struct ColorMap *cm)
{
   int i,j;
   j=0;

   // Gehe alle Einträge vom Array Colors durch
   for(i=0;i<64*3;i+=3)
   {
       Pens[j] = ObtainBestPen(cm,
                               Colors[i],    // Rotanteil
                               Colors[i+1],  // Grünanteil
                               Colors[i+2],  // Blauanteil
                               OBP_Precision, PRECISION_EXACT,
                               OBP_FailIfBad, FALSE,
                               TAG_DONE);
       j++;
   }
}

/* Pens wieder freigeben */
void FreePens(struct ColorMap *cm)
{
   int i;

   for(i=0;i<64;i++) ReleasePen(cm,Pens[i]);
}

/*  Berechnet Parameter n für das Mandelbrot Fraktal
 *  abhängig von cx,cy.
 */
UBYTE Berechne_n(double cx, double cy)
{
  double x,y,tx,ty;
  UBYTE n = 0;

  x = 0.0;
  y = 0.0;

  do
  {
      tx = x*x - y*y + cx;
      ty = 2.0 * x * y + cy;
      x = tx;
      y = ty;

      n++;
  }
  while((x*x + y*y <= 4.0) && (n < 100));

  return n;
}

/* Zeichnet Mandelbrot Fraktal in das Fenster */
void Mandelbrot(struct Window *Win, double x_offset, double y_offset, double zoomfaktor)
{
  int x,y,xmin,xmax,ymin,ymax;
  UBYTE n;
  int w,h;
  double zoom;

  struct RastPort *rp;
  rp=Win->RPort;

  w = Win->GZZWidth;   // Breite des Fensters
  h = Win->GZZHeight;  // Höhe des Fensters

  zoom = w*zoomfaktor;

  xmin=-w/2;
  ymin=-h/2;
  xmax=w/2;
  ymax=h/2;

  x=xmin;
  y=ymin;

  /* Busy Pointer setzen */
  SetWindowPointer(Win, WA_BusyPointer, TRUE, TAG_DONE);

  /* Schleife für Zeilen */
  for (x=xmin;x<=xmax;x++)
  {
     /* Schleife für Spalten */
     for(y=ymin;y<=ymax;y++)
     {
        /* Farbwert hängt vom Parameter n ab */
        n = Berechne_n((double)(x+x_offset)/zoom,(double)(y+y_offset)/zoom);

        if (n>=100) SetAPen(rp,Pens[0]);
        else SetAPen(rp,Pens[n%64]);

        WritePixel(rp,x+xmax,y+ymax);
      }
  }

  /* Normaler Mousepointer */
  SetWindowPointer(Win, TAG_DONE);

}


int main(void)
{
  struct Window *Fenster;               // Zeiger auf Window-Struktur

  /* Zeiger auf die ColorMap, die wir verändern möchten */
  struct ColorMap *cm;

  /* Variablen zur Message-Bearbeitung */
  struct MsgPort *Port;             // Zeiger auf Message Port Struktur
  struct IntuiMessage *Nachricht;   // Zeiger auf Intuition Message Struktur
  ULONG  klasse;
  USHORT code;

  double zoom;                      // Zoom für Mandelbrot Fraktal
  double x_offset,y_offset;

  BOOL Weiter=TRUE;                 // Boolsche Variable: Programmende?

  // Intuition Library öffnen
  IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library",36L);

  if (IntuitionBase != NULL)
  {
    // Graphics Library öffnen
    GfxBase = (struct GfxBase *) OpenLibrary("graphics.library",0L);

    if (GfxBase != NULL)
    {
      // Fenster mittels Tags öffnen
      Fenster = OpenWindowTags(NULL,
                               WA_Left, 100,    // Abstand vom linken Rand
                               WA_Top, 100,     // Abstand vom oberen Rand
                               WA_Width, 480,   // Breite
                               WA_Height, 480,  // Höhe
                               WA_Title, "Mandelbrot",         // Fenstertitel
                               WA_CloseGadget, TRUE,           // Close-Gadget
                               WA_DragBar, TRUE,               // Ziehleiste
                               WA_DepthGadget, TRUE,           // Depth-Gadget
                               WA_SizeGadget, TRUE,
                               WA_GimmeZeroZero, TRUE,         // Ursprung 0/0
                               WA_IDCMP,                       // IDCMP Flags
                               IDCMP_CLOSEWINDOW | IDCMP_VANILLAKEY | IDCMP_NEWSIZE | IDCMP_RAWKEY,
                               WA_Activate, TRUE,              // Fenster aktivieren
                               WA_MinWidth, 100,               // minimale Breite
                               WA_MinHeight, 100,              // minimale Breite
                               WA_MaxWidth, 1024,              // maximale Breite
                               WA_MaxHeight, 768,             // maximale Höhe
                               TAG_DONE);

      if (Fenster != NULL)
      {
        /*  Zeiger auf die ColorMap des Screens,
         *  auf dem sich unser Fenster befindet
         */
         cm = Fenster->WScreen->ViewPort.ColorMap;

         zoom=0.3;
         x_offset=-zoom*Fenster->GZZWidth/2.0;
         y_offset=0.0;

         /* Jetzt initialisieren wir unser Array Pens */
         InitPens(cm);

         /* Unser Port ist der UserPort unseres Fensters */
         Port = Fenster->UserPort;

         /* Mandelbrot Fraktal zeichnen */
         Mandelbrot(Fenster,x_offset,y_offset,zoom);

         /*  Schleife läuft so lange, bis das Programm
          *  durch anclicken des Close-Gadgets beedet wird.
          */
          while (Weiter)
            {
             /* Auf ankommende Nachricht warten */
             WaitPort(Port);

             /* Schleife läuft bis alle Ereignisse
              * abgearbeitet sind.
              */
                while(Nachricht = (struct IntuiMessage *) GetMsg(Port))
                {
                  klasse = Nachricht->Class;
                  code =  Nachricht->Code;

               /* Welches Ereignis ist eingetreten? */
                  switch(klasse)
                  {
                     /*  Ein Klick auf das CloseGadget
                      *  beendet das Programm
                      */
                  case CLOSEWINDOW:
                       Weiter=FALSE;
                       break;

                  /*  Mit den Tasten + und - kann man
                   *  in das Fraktal zoomen.
                   */
                  case VANILLAKEY:
                       if (code == '+')
                       {
                         zoom += 0.05;
                         Mandelbrot(Fenster,x_offset,y_offset,zoom);
                       }
                       if (code == '-')
                       {
                         zoom -= 0.05;
                         Mandelbrot(Fenster,x_offset,y_offset,zoom);
                       }
                       break;

                  /*  Sondertaste wurde gedrückt
                   */
                  case RAWKEY:
                       switch (code)
                       {
                          // Es war die Escape-Taste
                          case 0x45:
                               Weiter=FALSE;
                               break;

                          // Pfeiltaste links
                          case 0x4F:
                               x_offset += 10.0;
                               Mandelbrot(Fenster,x_offset,y_offset,zoom);
                               break;

                          // Pfeiltaste rechts
                          case 0x4E:
                               x_offset -= 10.0;
                               Mandelbrot(Fenster,x_offset,y_offset,zoom);
                               break;

                          // Pfeiltaste oben
                          case 0x4C:
                               y_offset += 10.0;
                               Mandelbrot(Fenster,x_offset,y_offset,zoom);
                               break;

                          // Pfeilteste unten
                          case 0x4D:
                               y_offset -= 10.0;
                               Mandelbrot(Fenster,x_offset,y_offset,zoom);
                               break;

                       }
                       break;

                  /*  Wenn der Benutzer die Fenstergröße ändert,
                   *  muß der Inhalt des Fensters neu gezeichnet
                   *  werden.
                   */
                  case NEWSIZE:
                       Mandelbrot(Fenster,x_offset,y_offset,zoom);
                       break;

                 } // Ende der switch-Verzweigung

               ReplyMsg((struct Message *)Nachricht);

             } // Ende der inneren while-Schleife
        } // Ende der äußeren while-Schleife

         /* Alle Pens aus dem Array wieder freigeben */
         FreePens(cm);

         CloseWindow(Fenster);   // Fenster schließen
      } // end if

    } // end if

  } // end if

  // Libraries schließen
  if (GfxBase != NULL) CloseLibrary((struct Library *)GfxBase);
  if (IntuitionBase != NULL) CloseLibrary((struct Library *)IntuitionBase);

  return 0;
}
