/* -- --------------------------------------------------------------- -- *
 * -- Autor..............: Daniel Kasmeroglu (Gideon)                 -- *
 * -- Programmname.......: UseGaugeGClass.e                           -- *
 * -- Original von.......: Holger Engels                              -- *
 * -- Version............: 0.1                                        -- *
 * -- --                                                           -- -- *
 * -- History............:                                            -- *
 * --     0.1            - Die erste Version !                        -- *
 * --                      (24.03.1996)                               -- *
 * -- --------------------------------------------------------------- -- */

 
     /* -- ------------------------------------------------- -- *
      * --                  Compiler-Optionen                -- *
      * -- ------------------------------------------------- -- */

OPT OSVERSION = 37            ->: BOOPSI gibt es erst ab Amiga OS 2.04
OPT REG = 5                   ->: Register-Optimierung einschalten
OPT PREPROCESS                ->: Präprozessor einschalten


     /* -- ------------------------------------------------- -- *
      * --                     E-Module                      -- *
      * -- ------------------------------------------------- -- */

MODULE 'intuition/intuition',
       'intuition/intuitionbase',
       'intuition/classusr',
       'intuition/gadgetclass',
       'intuition/imageclass',
       'intuition/classes',
       'intuition/icclass',
       'intuition/cghooks',
       'intuition/screens',
       'graphics/displayinfo',
       'graphics/text',
       'utility/tagitem',
       'libraries/gadtools',
       'gadtools',
       'utility',
       '*ram:gaugegclass'


     /* -- ------------------------------------------------- -- *
      * --             Exception-Handler benutzen            -- *
      * -- ------------------------------------------------- -- */

RAISE "OLIB" IF OpenLibrary()       = NIL,
      "LPUB" IF LockPubScreen()     = NIL,
      "VISU" IF GetVisualInfoA()    = NIL,
      "DRIN" IF GetScreenDrawInfo() = NIL,
      "OWIN" IF OpenWindowTagList() = NIL


ENUM PARTOFALL,
     PERCENT


     /* -- ------------------------------------------------- -- *
      * --                  Globale Variablen                -- *
      * -- ------------------------------------------------- -- */

DEF glo_screen        : PTR TO screen    
DEF glo_window        : PTR TO window    ->: unser Fenster
DEF glo_drawinfo      : PTR TO drawinfo
DEF glo_gadgetpart    : PTR TO gadget
DEF glo_gadgetpercent : PTR TO gadget
DEF glo_gaugegcl      : PTR TO iclass    ->: unsere private Klasse
DEF glo_visual


     /* -- ------------------------------------------------- -- *
      * --                    Hauptprogramm                  -- *
      * -- ------------------------------------------------- -- */

PROC main() HANDLE
DEF ma_top,ma_flags,ma_wtitle,ma_stitle

  ma_wtitle    := String(30)
  ma_stitle    := String(100)

  StrCopy(ma_wtitle,'GaugeGClass Test',ALL)
  StrCopy(ma_stitle,'GaugeGClass - Public Domain -',ALL)

  ->: Fenster-Flags
  ma_flags     := WFLG_DRAGBAR + WFLG_DEPTHGADGET + WFLG_CLOSEGADGET

  ->: alles was nötig ist, öffnen
  gadtoolsbase := OpenLibrary('gadtools.library',37)
  utilitybase  := OpenLibrary('utility.library',37)

  glo_screen   := LockPubScreen(NIL)
  ma_top       := glo_screen.wbortop + glo_screen.font.ysize + 1
  glo_visual   := GetVisualInfoA(glo_screen,TAG_DONE)
  glo_drawinfo := GetScreenDrawInfo(glo_screen)

  glo_window   := OpenWindowTagList(NIL,
  [WA_LEFT,                         200,
   WA_TOP,                       ma_top,
   WA_WIDTH,                        300,
   WA_HEIGHT,                       200,
   WA_AUTOADJUST,                  TRUE,
   WA_IDCMP,          IDCMP_CLOSEWINDOW,
   WA_FLAGS,                   ma_flags,
   WA_ACTIVATE,                    TRUE,
   WA_TITLE,                  ma_wtitle,
   WA_SCREENTITLE,            ma_stitle,
   WA_PUBSCREEN,             glo_screen,
   TAG_DONE,                   TAG_DONE])

  demonstrategauge()  ->: Aufruf der eigentlichen Testroutine
                                       
EXCEPT DO

  IF glo_window   <> NIL THEN CloseWindow(glo_window)
  IF glo_drawinfo <> NIL THEN FreeScreenDrawInfo(glo_screen,glo_drawinfo)
  IF glo_visual   <> NIL THEN FreeVisualInfo(glo_visual)
  IF glo_screen   <> NIL THEN UnlockPubScreen(NIL,glo_screen)
  IF utilitybase  <> NIL THEN CloseLibrary(utilitybase)
  IF gadtoolsbase <> NIL THEN CloseLibrary(gadtoolsbase)

ENDPROC


PROC demonstrategauge()
DEF t
   
  ->: installieren unserer privaten GaugeGClass
  glo_gaugegcl := gau_InitGAUGEClass()
  IF glo_gaugegcl

    ->: erstellen von zwei GaugeGadgets
    glo_gadgetpart := NewObjectA(glo_gaugegcl,NIL,
    [GA_LEFT,                                   9,
     GA_TOP,                                   21,
     GA_WIDTH,                                120,
     GA_HEIGHT,                                15,
     GA_ID,                             PARTOFALL,
     GAUGE_PART,                                0,
     GAUGE_FULL,                               12,
     GAUGE_PARTOFALL,                        TRUE,
     TAG_DONE,                           TAG_DONE])
    
    glo_gadgetpercent := NewObjectA(glo_gaugegcl,NIL,
    [GA_PREVIOUS,                     glo_gadgetpart,
     GA_LEFT,                                      9,
     GA_TOP,                                      45,
     GA_WIDTH,                                   120,
     GA_HEIGHT,                                   15,
     GA_ID,                                  PERCENT,
     GAUGE_PART,                                   0,
     GAUGE_FULL,                                  12,
     GAUGE_PERCENTAGE,                          TRUE,
     TAG_DONE,                              TAG_DONE])
         
    ->: Gadgets werden ans Fenster gehängt und aufgefordert, sich darzustellen
    AddGList(glo_window,glo_gadgetpart,-1,-1,NIL)

    RefreshGadgets(glo_gadgetpart,glo_window,NIL)
         
    FOR t := 1 TO 12
      Delay(50)
      ->: Ein paar Werte an die Schalter senden
      SetGadgetAttrsA(glo_gadgetpart,   glo_window,NIL,[GAUGE_PART,t,TAG_DONE])
      SetGadgetAttrsA(glo_gadgetpercent,glo_window,NIL,[GAUGE_PART,t,TAG_DONE])
    ENDFOR
    
    ->: auf ein Intuition-Event warten
    WaitPort(glo_window.userport)
         
    ->: Schalter entfernen
    RemoveGList(glo_window,glo_gadgetpart,-1)
        
    ->: GadgetObjects werden aufgerufen, sich zu terminieren
    IF glo_gadgetpart    <> NIL THEN DisposeObject(glo_gadgetpart)
    IF glo_gadgetpercent <> NIL THEN DisposeObject(glo_gadgetpercent)
            
    ->: private Klassen müsen nach ihrer Nutzung wieder entfernt werden
    gau_FreeGAUGEClass(glo_gaugegcl)

  ELSE
    WriteF('Klasse konnte nicht erstellt werden !\n')
  ENDIF

ENDPROC
