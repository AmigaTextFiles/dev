-- Programmname : springer
-- Source       : springer.adb
-- Zweck        : Berechnet mögliche Koordinaten,
--                welche die Schachfigur Springer
--                in n Schritten erreichen kann.
-- Version      : 2.0 (mit Memoisierung)               
-- Autor        : Norman Walter, Universität Stuttgart

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

procedure springer is

z,i:     natural;
x,y:     array(0..8) of integer;
feld:    array(1..8,1..8) of integer;

 procedure calc is
 -- Berechnet 8 mögliche Koordinaten
 -- relativ zu x(0),y(0)

  begin

   -- Alle 8 möglichen Koordinaten berechnen
   -- und Marker eintragen, falls innerhalb
   -- des Felds.

   if x(0)+2 in 1..8 and y(0)+1 in 1..8 then
      feld(x(0)+2,y(0)+1):=i;
   end if;

   if x(0)+2 in 1..8 and y(0)-1 in 1..8 then
      feld(x(0)+2,y(0)-1):=i;
   end if;

   if x(0)-2 in 1..8 and y(0)+1 in 1..8 then
      feld(x(0)-2,y(0)+1):=i;
   end if;

   if x(0)-2 in 1..8 and y(0)-1 in 1..8 then
      feld(x(0)-2,y(0)-1):=i;
   end if;

   if x(0)+1 in 1..8 and y(0)+2 in 1..8 then
      feld(x(0)+1,y(0)+2):=i;
   end if;

   if x(0)+1 in 1..8 and y(0)-2 in 1..8 then
      feld(x(0)+1,y(0)-2):=i;
   end if;

   if x(0)-1 in 1..8 and y(0)+2 in 1..8 then
      feld(x(0)-1,y(0)+2):=i;
   end if;

   if x(0)-1 in 1..8 and y(0)-2 in 1..8 then
      feld(x(0)-1,y(0)-2):=i;
   end if;

 end calc;

 -- Hauptprogramm
 begin

 put("Berechnet Felder, die ein Springer in n Zügen erreichen kann");
 new_line(2);
 put("Geben Sie die Startcoordinaten ein : ");
 new_line;
 put("x : ");get(x(0));
 put("y : ");get(y(0));
 new_line;
 put("Geben Sie die Anzahl der Züge ein : ");
 get(z);

 -- Feldmarker rücksetzen

 for xi in 1..8 loop
  for yi in 1..8 loop
    feld(xi,yi):=-1;
  end loop;
 end loop;

 -- Startposition markieren
 feld(x(0),y(0)):=1;

-- Schleife für Züge
for n in 1..z loop

-- Zähler für Feldmarker anpassen
i:=n+1;

-- Schleife zum durchsuchen von 8 mal 8 Koordinaten

 for a in 1..8 loop
  for b in 1..8 loop
   -- Wurde ein neuer Marker erkannt?
   if feld(a,b)=n then
    -- Bezugskoordinaten anpassen
    x(0):=a; y(0):=b;
    -- 8 neue Koordinaten berechnen
    -- und Marker setzen
    calc;
   end if;

  end loop;
 end loop;

end loop;

-- Schleife für Ausgabe relevanter Koordinaten

for a in 1..8 loop
 for b in 1..8 loop
  -- Eintrag vorhanden?
  if feld(a,b)>0 then
  -- Text ausgeben
   put(a,1);put("/");put(b,1);
   new_line;
  end if;

 end loop;
end loop;


end springer;
