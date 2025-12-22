-- Paket     : GetAnyNumber
-- Source    : GetAnyNumber.adb
-- Def.Modul : GetAnyNumber.ads
-- Autor     : Norman Walter
-- Version   : 1.01 (4.12.2000)
-- Zweck     : Einlesen von natürlichen Zahlen in beliebiger Repräsentierung

with text_io,ada.integer_text_io,hexchar;
use  text_io,ada.integer_text_io,hexchar;

package body GetAnyNumber is

procedure GetANumber (num: out natural; base: in natural) is

kette                  : string(1..256);
laenge                 : natural;
zeichen                : character;
wert,exponent          : natural;

begin

 skip_line; -- Wagenrücklauf aus Puffer entfernen

 get_line(kette,laenge);

 num:=0; exponent:=0;  -- Ziffernwert rücksetzen, Exponenten auf 0

 for zeiger in reverse 1..laenge loop
  -- Schleife durchkämmt die Zahl iterativ von hinten nach vorne.
  -- Die Anzahl der Ziffern wird durch die Länge des Strings ermittelt.
  zeichen:=kette(zeiger);  -- Holt sich einen Character aus dem String
  if IsValidChar(zeichen,base)=true then -- Gilt Zeichen in der Basis?
    wert:=hexvalue(zeichen); -- Zahlenwert des Characters
    num:=num+wert*base**exponent; -- Ziffernwert aktueller Stelle ermitteln
    exponent:=exponent+1;  -- Wert für den Exponenten erhöhen
  end if;
 end loop;

end GetANumber;

end GetAnyNumber;


