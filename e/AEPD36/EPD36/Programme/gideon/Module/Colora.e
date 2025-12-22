/* -- ------------------------------------------------------------ -- *
 * -- Modul......: Farben                                          -- *
 * -- Autor......: Daniel Kasmeroglu (Gideon)                      -- * 
 * -- Version....: 2.0                                             -- *
 * -- ------------------------------------------------------------ -- */

OPT MODULE

MODULE 'graphics/view',
       'intuition/screens',
       'exec/memory'


EXPORT CONST COL_ZYKLUS = 1,   -> die ganze Farbpalette
             COL_FARBE  = 2    -> nur eine Farbe


EXPORT OBJECT colora PRIVATE
  viewport : PTR TO viewport   -> Zeiger auf den Viewport eines Screens
  alte     : PTR TO INT        -> Liste um alte Farbwerte zu speichern
  laenge   : INT               -> Speicherbedarf festhalten
  anzahl   : CHAR              -> Anzahl der Farben
  allo     : CHAR              -> Schutzflag
ENDOBJECT


-> -- ---------------------------------------------------------------
-> -- Konstruktor:

PROC col_InitColora(col_screen:PTR TO screen) OF colora
DEF col_drinfo : PTR TO drawinfo
DEF col_num

  -> erst einmal in Erfahrung bringen wieviel Farben der Screen hat
  col_drinfo      := GetScreenDrawInfo(col_screen)
  col_num         := col_drinfo.depth
  FreeScreenDrawInfo(col_screen,col_drinfo)

  -> maximal 32 Farben (werde die Farbzahl später erweiteren)
  SELECT col_num
    CASE 1   ; self.anzahl := 2
    CASE 2   ; self.anzahl := 4
    CASE 3   ; self.anzahl := 8
    CASE 4   ; self.anzahl := 16
    CASE 5   ; self.anzahl := 32
  ENDSELECT

  self.laenge     := self.anzahl * 2
  self.viewport   := col_screen.viewport

  -> Speicher beschaffen
  self.alte       := AllocMem(self.laenge,MEMF_PUBLIC)
  IF self.alte <> NIL 
    self.allo := TRUE 
    CopyMemQuick(self.viewport.colormap.colortable,self.alte,self.laenge)
  ELSE 
    self.allo := FALSE
  ENDIF

ENDPROC


-> -- ---------------------------------------------------------------
-> -- Boolesche Methode:

-> existiert eine Liste der alten Farbwerte
PROC col_ColoraExist() OF colora IS self.allo = 255 -> = TRUE für CHARs


-> -- ---------------------------------------------------------------
-> -- Methode zur Freigabe des Speichers:

PROC col_FreeColora() OF colora

  -> wenn Liste existiert, alles Löschen
  IF self.col_ColoraExist() = TRUE
    FreeMem(self.alte,self.laenge)
    self.allo := FALSE
  ENDIF

ENDPROC


-> -- ---------------------------------------------------------------
-> -- Methode zur Wiederherstellung der alten Palette:

PROC col_Restore() OF colora

  -> hiermit kann man die alten Farben des Screens wiederherstellen,
  -> sofern vom Programmierer erwünscht
  IF self.col_ColoraExist() = TRUE
    LoadRGB4(self.viewport,self.alte,self.anzahl)
  ENDIF

ENDPROC


-> -- ---------------------------------------------------------------
-> -- Methoden zur Rotation der Farben:

PROC col_ShiftOne() OF colora

-> Scheiße, ich will endlich Methoden verstecken können
-> Diese Methode ist nur eine Hilfsprozedur

DEF col_ptr : PTR TO INT
DEF col_col

  -> Tabellen-Zeiger [muß man nicht benutzen]
  col_ptr   := self.viewport.colormap.colortable

  -> 1. Farbwert speichern
  col_col   := col_ptr[0]

  -> alle nachfolgenden Farbwerte um ein Feld zurückkopieren
  -> ACHTUNG: CopyMemQuick funktioniert hier nicht [Mod(x,4)=0 :-2]
  CopyMem(col_ptr+2,col_ptr,self.laenge-2)

  -> Letzter Eintrag erhält den "ehemaligen" ersten Farbwert
  col_ptr[self.anzahl-1] := col_col

  -> Farben aktualisieren
  LoadRGB4(self.viewport,col_ptr,self.anzahl)

ENDPROC


PROC col_Shift(anz,mod=COL_ZYKLUS,delay=0) OF colora
-> Das ist das Zentrum allen Übels ;-)

DEF col_lauf1,col_lauf2

  -> muß natürlich existieren
  IF self.col_ColoraExist() = FALSE THEN RETURN FALSE


  IF mod = COL_FARBE

    -> nur <anz> Farben verschieben
    FOR col_lauf1 := 1 TO anz
      self.col_ShiftOne()
      Delay(delay)
    ENDFOR

  ELSE

    -> <anz> Zyklen durchlaufen
    FOR col_lauf1 := 1 TO anz

      -> ein Zyklus = alle Farben
      FOR col_lauf2 := 1 TO self.anzahl
        self.col_ShiftOne()
        Delay(delay)
      ENDFOR

    ENDFOR

  ENDIF

ENDPROC


-> -- ---------------------------------------------------------------
-> -- Methode zum Setzen von Farben:

PROC col_SetCols(fun_r:PTR TO LONG,fun_g:PTR TO LONG,fun_b:PTR TO LONG) OF colora

-> Mit dieser Methode kann man Farben berechnen lassen.
-> Einfach Formeln mit den Indices übergeben.

DEF col_ptr : PTR TO INT
DEF col_wert,col_lauf,col_ende

  -> ohne Palettenkopie geht hier gar nichts
  IF self.col_ColoraExist() = FALSE THEN RETURN

  col_ptr  := self.viewport.colormap.colortable
  col_ende := self.anzahl-1

  FOR col_lauf := 0 TO col_ende
    -> Berechnung des Farbwerts
    col_wert := (fun_r(col_lauf)*256) + (fun_g(col_lauf)*16) + fun_b(col_lauf)
    col_ptr[col_lauf] := col_wert
  ENDFOR
  LoadRGB4(self.viewport,col_ptr,self.anzahl)

ENDPROC


-> -- ---------------------------------------------------------------
-> -- Destruktor:

PROC end() OF colora                 -> Destructor
  self.col_FreeColora()
ENDPROC


CHAR '$VER: Colora.M (E-Modul) v2.0 (c) Copyrights by Daniel Kasmeroglu',0
