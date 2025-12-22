/*
 * Programm: Boopsi.c
 * Es demonstriert die Kommunikations-
 * möglichkeiten zwischen zwei BOOPSI-Objekten,
 * ohne daß unser Programm die Steuerung übernehmen
 * muß.
 * Compiler: SAS-C
 * Aufruf:   lc -L boopsi.c
 */

#include <exec/types.h>
#include <utility/tagitem.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>

struct Library *IntuitionBase;
struct Window  *MyWindow;
struct IntuiMessage *IMsg;
struct Gadget *Prop, *Integer;

/*
 * Teilt dem Prop-Gadget mit, sein Attribut
 * PGA_Top in STRINGA_LongVal zu konvertieren
 */
struct TagItem Prop_To_Int[] =
{
  PGA_Top, STRINGA_LongVal,
  TAG_END,0
};

/*
 * Teilt dem String-Gadget mit, sein Attribut
 * STRINGA_LongVal in PGA_Top zu konvertieren
 */
struct TagItem Int_To_Prop[] =
{
  STRINGA_LongVal, PGA_Top,
  TAG_END,0
};

/* Parameter fürs Öffnen des Fensters */
struct TagItem WindowTags[] =
{
  WA_Flags, WFLG_DEPTHGADGET | WFLG_DRAGBAR |
            WFLG_CLOSEGADGET,
  WA_IDCMP, IDCMP_CLOSEWINDOW,
  WA_Height, 200, WA_Width, 300,
  WA_Title, (ULONG)"BOOSPI-Test",
  TAG_END,0
};

void main(void)
{
  BOOL Fertig = FALSE; /* Für die Message-Schleife */

  /*
   * Öffnen der Library (mind. V37, also OS 2.0 und
   * höher
   */
  IntuitionBase = OpenLibrary("intuition.library", 37);

  if( IntuitionBase )
  {
    MyWindow = OpenWindowTagList(NULL,WindowTags);

    if( MyWindow )
    {
      /* Erzeugen eines propgclass-Objekts */
      Prop=(struct Gadget *)NewObject(NULL,"propgclass",
          GA_ID,     1, /* ID-Nummer des Gadgets /*
          GA_Width,  10, /* Gadget-Breite */
          GA_Height, 80, /* Gadget-Höhe   */
          GA_Top,    (MyWindow->BorderTop) + 2,
          GA_Left,   (MyWindow->BorderLeft) + 2,
          /* Zeiger auf die Konvertierungs-Tags */
          ICA_MAP,   Prop_To_Int,
          PGA_Total, 100, /* 100 mögliche Positionen */
          PGA_Top,   10,  /* Startposition */
          PGA_Visible, 10, /* Sichtbare Größe des
                              Gadgetsknopfs */
          PGA_NewLook, TRUE,
          TAG_END);

      if( Prop )
      {
        /* Erzeugen eines Integer-String-Objekts */
        Integer=(struct Gadget *)
                         NewObject(NULL,"strgclass",
            GA_ID,2,  /* ID-Nummer des Gadgets */
            GA_Width,  100, /* Gadget-Breite */
            GA_Height, 20,  /* Gadget-Höhe   */
            GA_Top,  (MyWindow->BorderTop) + 5,
            GA_Left, (MyWindow->BorderLeft) + 20,
            ICA_MAP, Int_To_Prop,

            /* Das Objekt ist zu benachrichtigen */
            ICA_TARGET, Prop,

            /* Vorgänger dieses Gadgets */
            GA_Previous, Prop,

            STRINGA_LongVal,  10, /* Startwert */
            STRINGA_MaxChars, 3,  /* Max. Zeichen */
            TAG_END);

        if( Integer )
        {
          /* Da während der Initialisierung des   */
          /* Prop-Gadgets das Integer-Gadget noch */
          /* nicht exisitiert, muß das Ziel (ICA_ */
          /* TARGET) jetzt übergeben werden.      */
          SetGadgetAttrs(Prop, MyWindow, NULL,
              ICA_TARGET, Integer, TAG_END);

          /* Gadgets ans Fenster anhängen und an- */
          /* zeigen.                              */
          AddGList(MyWindow, Prop, -1, -1, NULL);
          RefreshGList(Prop, MyWindow, NULL, -1);

          while (Fertig == FALSE)
          {
            /* Auf die CLOSEWINDOW-Message warten */
            WaitPort(MyWindow->UserPort);

            while (IMsg = GetMsg(MyWindow->UserPort))
            {
              if (IMsg->Class == IDCMP_CLOSEWINDOW)
                Fertig = TRUE;
              ReplyMsg(IMsg);
            }
          }
          RemoveGList(MyWindow, Prop, -1);
          DisposeObject(Integer);
        }
        DisposeObject(Prop);
      }
      CloseWindow(MyWindow);
    }
    CloseLibrary(IntuitionBase);
  }
}

