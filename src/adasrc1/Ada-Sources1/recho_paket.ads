-- Def-modul   : REcho_Paket.ads
-- Paketname   : REcho_Paket
-- Source      : REcho_Paket.adb
-- Zweck       : Demonstration eines rekursiven Algorhitmus
-- Autor       : Norman Walter, Universität Stuttgart
-- Datum       : 24.11.2000 WS 00/01

package REcho_Paket is
-- stellt die Prozedur REcho bereit

Procedure REcho(c: in string; n: in natural);
-- Rekursiver Algorhitmus:
-- Uebernimmt den String c und die Laenge n des Strings
-- vom Hauptprogramm, gibt anschliessend den String
-- in umgekehrter Reihenfolge wieder aus.

end REcho_Paket;
