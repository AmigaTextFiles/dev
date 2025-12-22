-- Paketname   : REcho_Paket
-- Source      : REcho_Paket.adb
-- Zweck       : Demonstration eines rekursiven Algorithmus
-- Autor       : Norman Walter, Universität Stuttgart
-- e-mail      : walternn@rupert.informatik.uni-stuttgart.de
-- Datum       : 24.11.2000 WS 00/01

with text_io;
use  text_io;

package body REcho_Paket is

Procedure REcho(c: in string; n: in natural) is
-- Rekursiver Algorithmus:
-- Uebernimmt den String und die Laenge des Strings
-- vom Hauptprogramm, gibt anschliessend den String
-- in umgekehrter Reihenfolge wieder aus.

 begin
  if n>0 then      -- Verhindert CONSTRAINT_ERROR, wenn Leereingabe
   put(c(n..n));   -- Ausgabe des Strings c im Bereich von n nach n
   if n>1 then     -- Ausstiegsbedingung
     REcho(c,n-1); -- Rekursion: Hier ruft sich die Prozedur selbst auf
   end if;
  end if;
end REcho;

end REcho_Paket;
