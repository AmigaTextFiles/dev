-- Programmname: kauderwelsch
-- Source      : kauderwelsch.adb
-- Autor       : Norman Walter (walternn@rupert.informatik.uni-stuttgart.de)
-- Version     : 1.0
-- Datum       : 24.11.2000
-- Maschine    : A1200
-- CPU         : Motorola XC68060

with text_io,recho_paket;
use  text_io,recho_paket;

procedure kauderwelsch is
-- Gibt eingegebenen Text in umgekehrter Reihenfolge wieder aus.

n: natural;
c: string(1..256); -- Fuer einen String muss in Ada ein 1-dimensionales Array festgelegt werden

begin
 put("Geben Sie einen Text ein : ");
 get_line(c,n);  -- String c mit Laenge n holen
 put("Umkehr : ");
 REcho(c,n);     -- Benutzt Prozedur REcho aus dem Paket REcho_Paket
end kauderwelsch;
