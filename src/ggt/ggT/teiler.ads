-- Def-Modult: Teiler.ads
-- Autor:      Norman Walter
-- Zweck:      Berechnet größten gemeinsamen Teiler zweier Zahlen

with schlangenpaket;

package Teiler is

function ggt (a,b: integer) return integer;
 -- Ließt integer-Variablen a und b ein,
 -- gibt den größten gemeinsamen Teiler
 -- als integer zurück.

function teilerfremd (m,n: integer) return integer;
-- liefert 1, falls m,n teilerfremd, sonst 0

end Teiler;




