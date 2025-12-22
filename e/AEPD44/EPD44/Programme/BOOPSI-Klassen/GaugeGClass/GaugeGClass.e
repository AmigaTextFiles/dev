/* -- --------------------------------------------------------------- -- *
 * -- Autor.........: Daniel Kasmeroglu alias Gideon                  -- *
 * -- Programm......: BOOPSI-Klasse "GaugeGClass"                     -- *
 * -- Original von..: Holger Engels                                   -- *
 * -- Version.......: 0.1                                             -- *
 * -- --                                                           -- -- *
 * -- History.......:                                                 -- *
 * --    0.1      - Die erste Version ;-)                             -- *
 * --               (02.02.1996)                                      -- *
 * -- --------------------------------------------------------------- -- */

  
     /* -- ------------------------------------------------- -- *
      * --                  Compiler-Optionen                -- *
      * -- ------------------------------------------------- -- */

OPT OSVERSION = 37         ->: BOOPSI gibt es erst ab Amiga OS 2.04
OPT REG = 5                ->: Register-Optimierung einschalten
OPT PREPROCESS             ->: Präprozessor aktivieren
OPT MODULE                 ->: E-Modul generieren
 

     /* -- ------------------------------------------------ -- *
      * --                benötigte Module                  -- *
      * -- ------------------------------------------------ -- */

MODULE 'amigalib/boopsi',
       'tools/installhook',
       'intuition/classes',
       'intuition/classusr',
       'intuition/intuition',
       'intuition/gadgetclass',
       'intuition/cghooks',
       'intuition/screens',
       'graphics/rastport',
       'graphics/text',
       'utility/tagitem',
       'utility/hooks',
       'utility'


     /* -- ------------------------------------------------ -- *
      * --           Methoden-IDs und Konstanten            -- *
      * -- ------------------------------------------------ -- */

EXPORT ENUM GAUGE_DUMMY = TAG_USER,
            GAUGE_PART,
            GAUGE_FULL,
            GAUGE_PERCENTAGE,
            GAUGE_PARTOFALL,
            GAUGE_FONT


ENUM PERCENT,
     PARTOFALL


     /* -- ------------------------------------------------ -- *
      * --        Datenstruktur des BOOPSI-Objektes         -- *
      * -- ------------------------------------------------ -- */

OBJECT gaugedata
  font       : PTR TO textfont
  full       : LONG
  part       : LONG
  shownumber : CHAR
ENDOBJECT


     /* -- ------------------------------------------------ -- *
      * --              die BOOPSI-Methoden                 -- *
      * -- ------------------------------------------------ -- */

->: Erstellen einer privaten Klasse
EXPORT PROC gau_InitGAUGEClass()
DEF ini_class : PTR TO iclass

  ini_class := MakeClass(NIL,GADGETCLASS,NIL,SIZEOF gaugedata,0)
  IF ini_class <> NIL THEN installhook(ini_class.dispatcher,{gau_DispatchGAUGEClass})

ENDPROC ini_class


->: Freigeben einer privaten Klasse
EXPORT PROC gau_FreeGAUGEClass(fre_class : PTR TO iclass) IS FreeClass(fre_class)


->: der Dispatcher (Verteiler bzw. Kern der Klasse)
PROC gau_DispatchGAUGEClass(dis_class : PTR TO iclass,dis_object : PTR TO object,dis_msg : PTR TO msg)
DEF dis_iid   : PTR TO gaugedata
DEF dis_rport : PTR TO rastport
DEF dis_ti    : PTR TO LONG
DEF dis_state : PTR TO LONG
DEF dis_retval,dis_mid,dis_tag,dis_tempo

  dis_retval := NIL
  dis_mid    := dis_msg.methodid

  ->: Beide Methoden sind gleich zu behandeln
  IF dis_mid = OM_SET THEN dis_mid := OM_UPDATE

  SELECT dis_mid
    CASE OM_NEW
  
      ->: Speicher für neue Datenstruktur mittels Superklasse anfordern
      ->: (wird bis zur ROOTCLASS weitergegeben)
      dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)

      IF dis_retval <> NIL
        
        ->: Struktur holen und mit Werten füllen
        dis_iid      := INST_DATA(dis_class,dis_retval)
        dis_iid.font := GetTagData(GAUGE_FONT,NIL,dis_msg::opset.attrlist)
        dis_iid.full := GetTagData(GAUGE_FULL,100,dis_msg::opset.attrlist)
        dis_iid.part := GetTagData(GAUGE_PART,0,dis_msg::opset.attrlist)
        IF GetTagData(GAUGE_PERCENTAGE,FALSE,dis_msg::opset.attrlist) = TRUE
          dis_iid.shownumber := PERCENT
        ELSE
          dis_iid.shownumber := PARTOFALL
        ENDIF
      ENDIF

    CASE OM_UPDATE
 
      ->: Struktur holen
      dis_iid    := INST_DATA(dis_class,dis_object)

      ->: Super-Klasse soll Attributliste durchlaufen
      dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)

      dis_ti     := dis_msg::opset.attrlist
      dis_state  := dis_ti

      ->: bekannte Attribute auswerten         
      WHILE (dis_ti := NextTagItem({dis_state})) <> NIL

        dis_tag := dis_ti[0] 
        SELECT dis_tag
          CASE GAUGE_FULL ; dis_iid.full := dis_ti[1]
          CASE GAUGE_PART
            dis_iid.part := dis_ti[1]
            IF dis_iid.part > dis_iid.full THEN dis_iid.part := dis_iid.full
        ENDSELECT

        ->: Raster-Port zum Zeichnen beschaffen
        dis_rport := ObtainGIRPort(dis_msg::opset.ginfo)
        IF dis_rport <> NIL

          doMethodA(dis_object,[GM_RENDER, dis_msg::opset.ginfo,dis_rport,GREDRAW_UPDATE]:gprender)
          ReleaseGIRPort(dis_rport)

        ENDIF
      
      ENDWHILE

    CASE OM_GET

      ->: Diese Methode erlaubt das Auslesen von Daten-Komponenten

      ->: Struktur holen
      dis_iid    := INST_DATA(dis_class,dis_object)

      /* GetAttr() - eventuell bekanntes Attr nach Storage schreiben */
      dis_tempo  := dis_msg::opget.attrid

      dis_retval := TRUE
      SELECT dis_tempo  
        CASE GAUGE_FULL ; dis_msg::opget.storage := dis_iid.full
        CASE GAUGE_PART ; dis_msg::opget.storage := dis_iid.part
      DEFAULT
        ->: keine Information unserer privaten Klasse, also an
        ->: Superklasse weitergeben
        dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)
      ENDSELECT
      
    CASE GM_HITTEST
      ->: unser Gadget hat genau die Dimensionen, die in der GadgetStruktur stehen
      dis_retval := GMR_GADGETHIT
    CASE GM_GOACTIVE
      ->: unser Gadget kann nicht aktiviert werden
      dis_retval := GMR_NOREUSE
    CASE GM_RENDER
      ->: Es gibt was zu malen
      dis_retval := gau_RenderGAUGEClass(dis_class,dis_object,dis_msg)
  DEFAULT
    ->: die Methode ist "uns" unbekannt und wird an die Superklasse zur
    ->: weiteren Bearbeitung übergeben
    dis_retval := doSuperMethodA(dis_class,dis_object,dis_msg)
  ENDSELECT

ENDPROC dis_retval


PROC gau_RenderGAUGEClass(ren_class : PTR TO iclass,ren_gadget : PTR TO gadget,ren_msg : PTR TO gprender)
DEF ren_string[12] : STRING
DEF ren_font       : PTR TO textfont
DEF ren_rport      : PTR TO rastport
DEF ren_iid        : PTR TO gaugedata
DEF ren_pens       : PTR TO INT
DEF ren_retval,ren_tempo

  ->: Struktur mit den Informationen holen
  ren_iid    := INST_DATA(ren_class,ren_gadget)
  ren_font   := ren_msg.ginfo.drinfo.font
  ren_pens   := ren_msg.ginfo.drinfo.pens
  ren_retval := FALSE

  ->: sollte uns kein RastPort zur Vefügung gestellt werden, müssen wir uns eben
  ->: einen besorgen (GM_RENDER Methods stellen immer einen zur Verfügung!)

  IF ren_msg.methodid = GM_RENDER
    ren_rport := ren_msg.rport
  ELSE
    ren_rport := ObtainGIRPort(ren_msg.ginfo)
  ENDIF

  IF ren_rport <> NIL

    ->: anderer, als der StandardFont
    IF ren_iid.font <> NIL
      SetFont(ren_rport,ren_iid.font)
      ren_font := ren_iid.font
    ENDIF

    SetDrMd(ren_rport,RP_JAM1)
    ren_tempo := ren_msg.redraw

    SELECT ren_tempo
      CASE GREDRAW_REDRAW
        ->: Ganzes Gadget neu malen, mitsammt Umrandung
        SetAPen(ren_rport,ren_pens[SHADOWPEN])
        Move(ren_rport,ren_gadget.leftedge + 1,ren_gadget.topedge + ren_gadget.height - 1)
        Draw(ren_rport,ren_gadget.leftedge + 1,ren_gadget.topedge + 1)
        Move(ren_rport,ren_gadget.leftedge,ren_gadget.topedge + ren_gadget.height)
        Draw(ren_rport,ren_gadget.leftedge,ren_gadget.topedge)
        Draw(ren_rport,ren_gadget.leftedge + ren_gadget.width,ren_gadget.topedge)

        SetAPen(ren_rport,ren_pens[SHINEPEN])
        Draw(ren_rport,ren_gadget.leftedge + ren_gadget.width,ren_gadget.topedge + ren_gadget.height)
        Draw(ren_rport,ren_gadget.leftedge + 1,ren_gadget.topedge + ren_gadget.height)
        Move(ren_rport,ren_gadget.leftedge + ren_gadget.width - 1,ren_gadget.topedge + ren_gadget.height - 1)
        Draw(ren_rport,ren_gadget.leftedge + ren_gadget.width - 1,ren_gadget.topedge + 1)
        ren_retval := TRUE  /* es wurde was gemalt */

      CASE GREDRAW_UPDATE

        ->: nur an aktuelle Werte anpassen
        IF ren_iid.full <> 0
          SetAPen(ren_rport,ren_pens[FILLPEN])
          RectFill(ren_rport,ren_gadget.leftedge + 2,
          ren_gadget.topedge + 1,
          ((ren_gadget.width - 4) * ren_iid.part/ren_iid.full) + ren_gadget.leftedge + 2,
          ren_gadget.topedge + ren_gadget.height - 1)
          ren_retval := TRUE
          SetAPen(ren_rport,ren_pens[BACKGROUNDPEN])

          IF ren_iid.part <> ren_iid.full

            RectFill(ren_rport,ren_gadget.leftedge + 2 + ((ren_gadget.width - 4) * ren_iid.part/ren_iid.full),
            ren_gadget.topedge + 1,
            ren_gadget.leftedge + ren_gadget.width - 2,
            ren_gadget.topedge + ren_gadget.height - 1)
               
          ENDIF

          ->: den Inhalt in Form eines Textes ausgeben
          ren_tempo := ren_iid.shownumber
          SELECT ren_tempo 
            CASE PARTOFALL ; StringF(ren_string,'\r\d[3]/\l\d[3]',ren_iid.part,ren_iid.full)
            CASE PERCENT   ; IF ren_iid.full <> 0 THEN StringF(ren_string,'\r\d[3]%',ren_iid.part * 100/ren_iid.full)
          DEFAULT
            ren_string[0] := 0
          ENDSELECT

          IF ren_string[0] <> 0

            ren_tempo := StrLen(ren_string)

            ->: Text schreiben
            SetDrMd(ren_rport,RP_JAM1)
            SetAPen(ren_rport,ren_pens[TEXTPEN])
            Move(ren_rport,ren_gadget.leftedge + (ren_gadget.width/2) - ((ren_tempo * ren_font.xsize)/2),
            ren_gadget.topedge + (ren_gadget.height/2) + (ren_font.baseline/2))
            Text(ren_rport,ren_string,ren_tempo)
            
          ENDIF

        ENDIF

    ENDSELECT

    ->: Selbstbeschafften Raster-Port auch selbst wieder freigeben
    IF ren_msg.methodid <> GM_RENDER THEN ReleaseGIRPort(ren_rport)

  ENDIF

ENDPROC ren_retval
