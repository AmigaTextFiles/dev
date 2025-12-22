-- Paketname : HexChar
--             Einlesen von natürlichen Zahlen in beliebiger Reräsentierung
-- Source    : HexChar.adb
-- Def.Modul : HexChar.ads
-- Autor     : Norman Walter, Universität Stuttgart
-- Datum     : 2.12.2000

with text_io,ada.integer_text_io,ada.characters.handling;
use  text_io,ada.integer_text_io,ada.characters.handling;

package body Hexchar is

c: character;
n: natural;

function IsValidVal(n: natural; base: natural) return boolean is
 -- Liefert TRUE, falls 'n' ein gültiger Ziffernwert in der Basis 'base' ist.
 -- Zulässige Werte sind z.B.
 -- im Binärsystem       (Basis 2)  die Ziffernwerte 0 und 1
 -- im Oktalsystem       (Basis 8)  die Ziffernwerte 0 bis 7
 -- im Dezimalsystem     (Basis 10) die Ziffernwerte 0 bis 9
 -- im Hexadezimalsystem (Basis 16) die Ziffernwerte 0 bis 15

 begin
  return n<base;

end IsValidVal;

function HexDigit (n: natural) return character is
-- Wandelt dezimalen Ziffernwert (0-15) in Hexziffern (0-F) um.

 begin
  if n<16 then
   if n<10 then  -- Liegt im Dezimal darstellbaren bereich
    c:=character'val(n+48); -- ASCII.0 beginnt bei 48
    else
   c:=character'val(n+55);  -- character'val sucht das zum Wert passende ASCII-Zeichen
  end if;
 end if;
 return c;

end HexDigit;

function HexValue (c: character ) return natural is
-- Wandelt Hexziffer (0-F) in Dezimalwert (0-15) um.

 begin

  if Is_Digit(c) then            -- Ziffernwert liegt im Dezimalbereich
   n:=character'pos(c)-48;       -- ASCII.0 beginnt bei 48
   elsif
   Is_Hexadecimal_Digit(c) then  -- Ziffernwert liegt im Hexadezimalbereich
     n:=character'pos(to_upper(c))-55; -- ASCII.A (entspricht Hexadezimalwert 10) ist 65
    else
     n:=0;
  end if;
  return n;

end HexValue;

function IsValidChar (c: character; base: natural) return boolean is
-- liefert TRUE, falls 'c' eine gültige Ziffer (als Character)
-- in der Basis 'base' ist, sonst FALSE

begin
 return HexValue(c)<base;

end IsValidChar;


end HexChar;

