-- Programmname : xmastree
-- Source       : xmastree.adb
-- Zweck        : Gibt einen ASCII-Christbaum abhängig von einem
--              : Parameter n aus.
-- Autor        : Norman Walter, Universität Stuttgart
-- e-mail       : walternn@rupert.informatik.uni-stuttgart.de
-- Version      : 1.0 (15.01.2001)

with text_io, ada.integer_text_io;
use  text_io, ada.integer_text_io;

procedure xmastree is

xs,ys,l,r,y,n,e: natural;
-- array für Bildschirmpuffer definieren
screen: array(1..80,1..25) of character;

 begin

  -- Begrüßung des Benutzers und Einlesen von Parameter n
  new_line;
  put("Gibt Christbäume abhängig von einem Parameter n aus.");
  new_line(2);
  put("Geben Sie Parameter n für die gewünschte Größe ein : ");
  get(n);
  new_line;

  -- gesamten Bildschrimpuffer mit Leerzeichen füllen
  for zeichen in 1..80 loop
   for zeile in 1..25 loop
     screen(zeichen,zeile):=' ';
   end loop;
  end loop;

  xs:=13; ys:=1; -- Startkoordinaten initialisieren
  l:=xs; r:=xs; -- linke und rechte Grenze
  y:=ys; -- in der 1. Zeile beginnen (y Koordinate)
  e:=1;

  screen(xs,ys):='*'; -- Spitze des Baums

  for zeile in 1..n loop
   for etage in 1..e loop
    l:=l-1; r:=r+1; -- Grenzen nach außen wandern lassen
    y:=y+1; -- eine Zeile nach unten springen
    -- Textzeichen in Puffer schreiben
    screen(l,y):='/';screen(r,y):='\';
   end loop;
     -- unteren Rand der Etage von links nach rechts ziehen
     for rand in l+1..r-1 loop
      screen(rand,y):='_';
     end loop;
    l:=xs; r:=xs; -- Ränder wieder in die Mitte holen
    e:=e+1; -- Zähler für die Etage erhöhen
  end loop;

  y:=y+1;
  screen(xs,y):='|'; -- Baummstamm setzen

  -- Ausgabe des Bildschirmpuffers

  -- Schleife für Zeilen
  for zeile in 1..y loop
   -- Schleife für Ausgabe der Zeichen von links nach rechts
   for zeichen in 1..80 loop
     put(screen(zeichen,zeile)); -- Zeichen aus array holen
   end loop;
   new_line; -- Neue Zeile
  end loop;


end xmastree;
