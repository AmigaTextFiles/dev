/* -- --------------------------------------------------------------- -- *
 * -- Autor..............: Daniel Kasmeroglu (Gideon)                 -- *
 * -- Programmname.......: UseIFFImageClass.e                         -- *
 * -- Original von.......: Holger Engels                              -- *
 * -- Version............: 0.1                                        -- *
 * -- --                                                           -- -- *
 * -- History............:                                            -- *
 * --     0.1            - Die erste Version !                        -- *
 * --                      (24.03.1996)                               -- *
 * -- --------------------------------------------------------------- -- */

/* -- --------------------------------------------------------------- -- *
 * -- ACHTUNG: Die Datei "Projectbrushes" muß sich im Verzeichniss    -- *
 * --          "Ram Disk:" befinden um dieses Testprogramm starten zu -- *
 * --          können.                                                -- *
 * -- --------------------------------------------------------------- -- */


     /* -- ------------------------------------------------- -- *
      * --                  Compiler-Optionen                -- *
      * -- ------------------------------------------------- -- */

OPT OSVERSION = 37             ->: BOOPSI gibt es erst ab Amiga OS 2.04
OPT REG = 5                    ->: Register-Optimierung einschalten
OPT PREPROCESS                 ->: Präprozessor aktivieren


     /* -- ------------------------------------------------- -- *
      * --                      E-Module                     -- *
      * -- ------------------------------------------------- -- */
 
MODULE 'intuition/intuition',
       'intuition/screens',
       'intuition/classes',
       'intuition/classusr',
       'intuition/imageclass',
       'intuition/gadgetclass',
       'exec/ports',
       'exec/lists',
       'exec/nodes',
       'graphics/text',
       'libraries/iffparse',
       'utility/tagitem',
       'tools/ilbmdefs',
       'utility',
       'iffparse',
       'gadtools',
       '*iffimageclass'


     /* -- ------------------------------------------------- -- *
      * --                       Konstanten                  -- *
      * -- ------------------------------------------------- -- */

CONST ID_ILBM = "ILBM",    ->: Chunk ID's
      ID_NAME = "NAME",
      ID_BMHD = "BMHD",
      ID_BODY = "BODY"


ENUM GADGET_NEW = 1,       ->: Schalter-Codes
     GADGET_OPEN,
     GADGET_SAVE,
     GADGET_PRINT,
     GADGET_CUT,
     GADGET_COPY,
     GADGET_PASTE,
     GADGET_DELETE



     /* -- ------------------------------------------------- -- *
      * --                   Globale Variablen               -- *
      * -- ------------------------------------------------- -- */

DEF glo_screen   : PTR TO screen
DEF glo_window   : PTR TO window
DEF glo_drinfo   : PTR TO drawinfo
DEF glo_ifficl   : PTR TO iclass        ->: unsere private Klasse

DEF glo_imnew    : PTR TO image         ->: die IFF-Images
DEF glo_imopen   : PTR TO image
DEF glo_imsave   : PTR TO image
DEF glo_imprint  : PTR TO image
DEF glo_imcut    : PTR TO image
DEF glo_imcopy   : PTR TO image
DEF glo_impaste  : PTR TO image
DEF glo_imdelete : PTR TO image

DEF glo_ganew    : PTR TO gadget        ->: Schalter
DEF glo_gaopen   : PTR TO gadget
DEF glo_gasave   : PTR TO gadget
DEF glo_gaprint  : PTR TO gadget
DEF glo_gacut    : PTR TO gadget
DEF glo_gacopy   : PTR TO gadget
DEF glo_gapaste  : PTR TO gadget
DEF glo_gadelete : PTR TO gadget

DEF glo_visual


     /* -- ------------------------------------------------- -- *
      * --                    Hauptprogramm                  -- *
      * -- ------------------------------------------------- -- */

PROC main() HANDLE

  ->: alles öffnen und initialisieren

  glo_visual   := NIL
  gadtoolsbase := OpenLibrary('gadtools.library',37)
  utilitybase  := OpenLibrary('utility.library',37)
  iffparsebase := OpenLibrary('iffparse.library',37)
  glo_screen   := LockPubScreen(NIL)
  glo_visual   := GetVisualInfoA(glo_screen,TAG_DONE)
  glo_drinfo   := GetScreenDrawInfo(glo_screen)
  glo_window   := OpenWindowTagList(NIL,
  [WA_LEFT,                           0,
   WA_TOP,      glo_screen.wbortop + glo_screen.font.ysize + 1,
   WA_WIDTH,                        300,
   WA_HEIGHT,                       200,
   WA_AUTOADJUST,                  TRUE,
   WA_FLAGS,      WFLG_SIZEGADGET OR WFLG_SIZEBRIGHT OR WFLG_SIZEBBOTTOM OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH,
   WA_IDCMP,          IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP,
   WA_ACTIVATE,                    TRUE,
   WA_TITLE,            'Solution Test',
   WA_SCREENTITLE,      'Solution Test',
   WA_PUBSCREEN,             glo_screen,
   TAG_DONE,                   TAG_DONE])

  use_DisplayImage()  ->: unsere Testroutine

EXCEPT DO

  IF glo_window   <> NIL THEN CloseWindow(glo_window)
  IF glo_drinfo   <> NIL THEN FreeScreenDrawInfo(glo_screen,glo_drinfo)
  IF glo_visual   <> NIL THEN FreeVisualInfo(glo_visual)
  IF glo_screen   <> NIL THEN UnlockPubScreen(NIL,glo_screen)
  IF iffparsebase <> NIL THEN CloseLibrary(iffparsebase)
  IF utilitybase  <> NIL THEN CloseLibrary(utilitybase)
  IF gadtoolsbase <> NIL THEN CloseLibrary(gadtoolsbase)

ENDPROC


->: Kleine Prozedur, die auf ein Intuition-Event wartet
PROC use_HandleMessages()
DEF han_msg : PTR TO intuimessage
DEF han_gad : PTR TO gadget
DEF han_class,han_state

  han_state := FALSE
  REPEAT

    WaitPort(glo_window.userport)
    han_msg   := GetMsg(glo_window.userport)
    han_class := han_msg.class
    han_gad   := han_msg.iaddress
    ReplyMsg(han_msg)

    SELECT han_class
      CASE IDCMP_CLOSEWINDOW ; han_state := TRUE
      CASE IDCMP_GADGETUP    ; WriteF('Gadget ID.: \d\n',han_gad.gadgetid)
    ENDSELECT

  UNTIL han_state = TRUE

ENDPROC



PROC use_DisplayImage()
DEF dis_ifflist : PTR TO lh

  ->: die Klasse erstellen
  glo_ifficl := iff_InitIFFIMAGEClass()
  IF glo_ifficl <> NIL

    ->: die CATENATION-Datei laden
    dis_ifflist := iff_InitIFFList('ram:projectbrushes2')
    IF dis_ifflist <> NIL

      ->: die Image-Objekte erzeugen
      glo_imnew := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,            dis_ifflist,
       ISD_NORMAL,                     'New',
       ISD_SELECTED,                'NewSel',
       TAG_END,                      TAG_END])

      IF glo_imnew = NIL THEN WriteF('no image!\n')

      glo_imopen := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,             dis_ifflist,
       ISD_NORMAL,                     'Open', 
       ISD_SELECTED,                'OpenSel',
       TAG_END,                       TAG_END])

      IF glo_imopen = NIL THEN WriteF('no image !\n')

      glo_imsave := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,             dis_ifflist,
       ISD_NORMAL,                     'Save',
       ISD_SELECTED,                'SaveSel',
       TAG_END,                       TAG_END])

      IF glo_imsave = NIL THEN WriteF('no image !\n')

      glo_imprint := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,              dis_ifflist,
       ISD_NORMAL,                     'Print',
       ISD_SELECTED,                'PrintSel',
       TAG_END,                        TAG_END])

      IF glo_imprint = NIL THEN WriteF('no image !\n')

      glo_imcut := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,            dis_ifflist,
       ISD_NORMAL,                     'Cut',
       ISD_SELECTED,                'CutSel',
       TAG_END,                      TAG_END])

      IF glo_imcut = NIL THEN WriteF('no image !\n')

      glo_imcopy := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,             dis_ifflist,
       ISD_NORMAL,                     'Copy',
       ISD_SELECTED,                'CopySel',
       TAG_END,                       TAG_END])

      IF glo_imcopy = NIL THEN WriteF('no image !\n')
  
      glo_impaste := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,              dis_ifflist,
       ISD_NORMAL,                     'Paste',
       ISD_SELECTED,                'PasteSel',
       TAG_END,                        TAG_END])

      IF glo_impaste = NIL THEN WriteF('no image !\n')

      glo_imdelete := NewObjectA(glo_ifficl,NIL,
      [IFFIM_IFFLIST,               dis_ifflist,
       ISD_NORMAL,                     'Delete',
       ISD_SELECTED,                'DeleteSel',
       TAG_END,                         TAG_END])
 
      IF glo_imdelete = NIL THEN WriteF('no image !\n')

      ->: Images können wieder freigegeben werden
      iff_FreeIFFList(dis_ifflist)


      ->: Zur Veranschaulichung des Nutzens, werden
      ->: die Images gleich im Zusammenhang mit
      ->: Schaltern benutzt

      glo_ganew := NewObjectA(NIL,BUTTONGCLASS,
      [GA_LEFT,                             10,
       GA_TOP,                              30,
       GA_RELVERIFY,                      TRUE,
       GA_IMAGE,                     glo_imnew,
       GA_ID,                       GADGET_NEW,
       TAG_END,                        TAG_END])

      glo_gaopen := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                   glo_ganew,
       GA_LEFT,                              40,
       GA_TOP,                               30,
       GA_RELVERIFY,                       TRUE,
       GA_IMAGE,                     glo_imopen,
       GA_ID,                       GADGET_OPEN,
       TAG_END,                         TAG_END])

      glo_gasave := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                  glo_gaopen,
       GA_LEFT,                              70,
       GA_TOP,                               30,
       GA_RELVERIFY,                       TRUE,
       GA_IMAGE,                     glo_imsave,
       GA_ID,                       GADGET_SAVE,
       TAG_END,                         TAG_END])

      glo_gaprint := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                   glo_gasave,
       GA_LEFT,                              100,
       GA_TOP,                                30,
       GA_RELVERIFY,                        TRUE,
       GA_IMAGE,                     glo_imprint,
       GA_ID,                       GADGET_PRINT,
       TAG_END,                          TAG_END])

      glo_gacut := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                glo_gaprint,
       GA_LEFT,                            130,
       GA_TOP,                              30,
       GA_RELVERIFY,                      TRUE,
       GA_IMAGE,                     glo_imcut,
       GA_ID,                       GADGET_CUT,
       TAG_END,                        TAG_END])

      glo_gacopy := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                   glo_gacut,
       GA_LEFT,                             160,
       GA_TOP,                               30,
       GA_RELVERIFY,                       TRUE,
       GA_IMAGE,                     glo_imcopy,
       GA_ID,                       GADGET_COPY,
       TAG_END,                         TAG_END])

      glo_gapaste := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                   glo_gacopy,
       GA_LEFT,                              190,
       GA_TOP,                                30,
       GA_RELVERIFY,                        TRUE,
       GA_IMAGE,                     glo_impaste,
       GA_ID,                       GADGET_PASTE,
       TAG_END,                          TAG_END])

      glo_gadelete := NewObjectA(NIL,BUTTONGCLASS,
      [GA_PREVIOUS,                   glo_gapaste,
       GA_LEFT,                               220,
       GA_TOP,                                 30,
       GA_RELVERIFY,                         TRUE,
       GA_IMAGE,                     glo_imdelete,
       GA_ID,                       GADGET_DELETE,
       TAG_END,                           TAG_END])

      ->: Schalter ins Fenster "einhängen"
      AddGList(glo_window,glo_ganew,-1,-1,NIL)
      RefreshGadgets(glo_ganew,glo_window,NIL)

      ->: auf Nachrichten warten bzw. reagieren
      use_HandleMessages()

      ->: Schalter wieder aushängen
      RemoveGList(glo_window,glo_ganew,-1)

      ->: Objekt auflösen
      IF glo_ganew    <> NIL THEN DisposeObject(glo_ganew)
      IF glo_gaopen   <> NIL THEN DisposeObject(glo_gaopen)
      IF glo_gasave   <> NIL THEN DisposeObject(glo_gasave)
      IF glo_gaprint  <> NIL THEN DisposeObject(glo_gaprint)
      IF glo_gacut    <> NIL THEN DisposeObject(glo_gacut)
      IF glo_gacopy   <> NIL THEN DisposeObject(glo_gacopy)
      IF glo_gapaste  <> NIL THEN DisposeObject(glo_gapaste)
      IF glo_gadelete <> NIL THEN DisposeObject(glo_gadelete)

      IF glo_imnew    <> NIL THEN DisposeObject(glo_imnew)
      IF glo_imopen   <> NIL THEN DisposeObject(glo_imopen)
      IF glo_imsave   <> NIL THEN DisposeObject(glo_imsave)
      IF glo_imprint  <> NIL THEN DisposeObject(glo_imprint)
      IF glo_imcut    <> NIL THEN DisposeObject(glo_imcut)
      IF glo_imcopy   <> NIL THEN DisposeObject(glo_imcopy)
      IF glo_impaste  <> NIL THEN DisposeObject(glo_impaste)
      IF glo_imdelete <> NIL THEN DisposeObject(glo_imdelete)

    ENDIF

    ->: Private Klasse wieder freigeben
    iff_FreeIFFIMAGEClass(glo_ifficl)

  ELSE
    WriteF('no class !\n')
  ENDIF

ENDPROC
