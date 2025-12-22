-- Programmname : Euler.adb
-- Zweck        : Berechnet den Wert der Eulerschen Funktion
-- Aut0r        : Norman Walter, Universität Stuttgart
-- Version      : 1.1 (12.12.2000)

with text_io,ada.integer_text_io,teiler;
use  text_io,ada.integer_text_io,teiler;

procedure euler is

n,m: integer;

function phi (n,i,m: integer) return integer is

begin

 if n>1 then
    if i>0 then -- Ausstiegsbedingung für Rekursion
      return phi(n,i-1,m+teilerfremd(i,n)); -- Rekursion
      else return m; -- Rückgabe des Wertes nach Rekursion
    end if;
  else return 0; -- phi(1)=0
 end if;

end phi;

-- Hauptprogramm

begin

 put("Berechnet den Wert der Eulerschen Funktion");
 new_line;
 put("Geben Sie eine Zahl ein : ");
 get(n);
 m:=phi(n,n,0);
 put("phi(");put(n,1);put(")=");put(m,1);

end euler;

