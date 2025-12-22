/* -- --------------------------------------------------------------- -- *
 * -- Modul.......: Basismodul für GadToolsBox-Projekte               -- *
 * -- Autor.......: Daniel Kasmeroglu (alias Gideon)                  -- *
 * -- Version.....: 0.2                                               -- *
 * -- --                                                              -- *
 * -- History.....:                                                   -- *
 * --   0.1       - Die erste Version !                               -- *
 * --               (12.01.1996)                                      -- *
 * --   0.2       - Einige Verbesserungen zur leichteren Benutzung.   -- *
 * --               (24.01.1996)                                      -- *
 * -- --------------------------------------------------------------- -- */

OPT MODULE


MODULE 'intuition/screens',
       'intuition/intuition',
       'graphics/text',
       'graphics/rastport',
       'exec/memory',
       'exec/lists',
       'exec/nodes',
       'gadtools'


-> -- ---------------------------------------------------------------
-> -- Fehlerkonstanten:

EXPORT ENUM ERR_OKAY,          ->: Alles in Ordnung
            ERR_MEMORY,        ->: Zu wenig Speicher
            ERR_SCREEN,        ->: kein Bildschirm
            ERR_VISUAL,        ->: kein visuellen Infos
            ERR_WINDOW,        ->: kein Fenster
            ERR_MENUS          ->: keine Menüs



-> -- ---------------------------------------------------------------
-> -- weitere Konstanten:

EXPORT CONST ASCII_ESCAPE    = 27,  ->: ASCII-Code der Escape-Taste
             ASCII_RETURN    = 13,
             ASCII_BACKSPACE = 8,
             ASCII_DELETE    = 127,
             ASCII_TABULATOR = 9,
             PLACETEXT_NONE  = 0,   ->: sieht besser aus als "nur" 0
             CTRUE           = 255, ->: Boolesche Konstanten, da deren
             CFALSE          = 0    ->: Entsprechungen nicht mit CHARs funktionieren

-> -- ---------------------------------------------------------------
-> -- Globale Variablen:

EXPORT DEF glo_screen : PTR TO screen
EXPORT DEF glo_tattr  : PTR TO textattr
EXPORT DEF glo_offx,glo_offy,glo_visual

DEF mod_fontx,mod_fonty


-> -- ---------------------------------------------------------------
-> -- Basis-Prozeduren:

EXPORT PROC gts_Not(not_val) IS IF not_val = CFALSE THEN CTRUE ELSE CFALSE


EXPORT PROC gts_SetupScreen(set_screenname = -1)
 
  glo_tattr     := AllocVec(SIZEOF textattr,MEMF_PUBLIC)
  IF glo_tattr = NIL THEN Raise("MEM")

  IF set_screenname = -1
    glo_screen := LockPubScreen('Workbench')
  ELSE
    glo_screen := LockPubScreen(set_screenname)
  ENDIF
  IF glo_screen = NIL THEN RETURN ERR_SCREEN

  glo_visual   := GetVisualInfoA(glo_screen,NIL)
  IF glo_visual = NIL THEN RETURN ERR_VISUAL

  gts_ComputeFont(0,0)

ENDPROC ERR_OKAY


EXPORT PROC gts_CloseScreen()

  IF glo_visual <> NIL 
    FreeVisualInfo(glo_visual)
    glo_visual := NIL
  ENDIF
  IF glo_screen <> NIL
    UnlockPubScreen(NIL,glo_screen)
    glo_screen <> NIL
  ENDIF
  FreeVec(glo_tattr)
  glo_tattr := NIL

ENDPROC


-> -- ---------------------------------------------------------------
-> -- Fehlermeldungen:

EXPORT PROC gts_ReportERR(rep_code)
DEF rep_erlist : PTR TO LONG

  IF (rep_code > ERR_OKAY) AND (rep_code <= ERR_MENUS)
    rep_erlist := ['Nicht genügend Speicher vorhanden !',
                   'Es steht kein Bildschirm zur Verfügung !',
                   'Keine visuellen Informationen !',
                   'Fenster konnte nicht geöffnet werden !',
                   'Es konnten keine Menüs erstellt werden !']

    EasyRequestArgs(0,[20,0,0,'\s','OK|OK'],0,[rep_erlist[rep_code - 1]])
  ENDIF

ENDPROC rep_code


-> -- ---------------------------------------------------------------
-> -- Zeichensatz-Unterstützung:

EXPORT PROC gts_ComputeX(com_value) IS Div(Mul(mod_fontx,com_value) + 4,8)
EXPORT PROC gts_ComputeY(com_value) IS Div(Mul(mod_fonty,com_value) + 4,8)

EXPORT PROC gts_ComputeFont(com_w,com_h)


  glo_tattr.name  := String(100)
  StrCopy(glo_tattr.name,glo_screen.rastport.font::ln.name,ALL)
  mod_fonty       := glo_screen.rastport.font.ysize
  glo_tattr.ysize := mod_fonty
  mod_fontx       := glo_screen.rastport.font.xsize

  glo_offx        := glo_screen.wborleft
  glo_offy        := glo_screen.rastport.txheight + glo_screen.wbortop + 1
  
  IF (com_w AND com_h) <> NIL
    IF ((gts_ComputeX(com_w) + glo_offx + glo_screen.wborright) > glo_screen.width) OR
       ((gts_ComputeY(com_h) + glo_offy + glo_screen.wborbottom) > glo_screen.height)
    
      StrCopy(glo_tattr.name,'topaz.font',ALL)
      mod_fonty       := 8
      mod_fontx       := 8
      glo_tattr.ysize := mod_fonty

    ENDIF
  ENDIF

  glo_tattr.style := 0
  glo_tattr.flags := 0

ENDPROC


EXPORT PROC gts_FontX() IS mod_fontx
EXPORT PROC gts_FontY() IS mod_fonty
