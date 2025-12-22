-- Paket: Teiler.adb
-- Autor: Norman Walter

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

package body Teiler is

function ggt (a,b: integer) return integer is
-- Berechnet größten gemeinsamen Teiler von a und b

 begin
  if a=b then return a;
    elsif a>b then return ggt(a-b,b);
    else return ggt(b-a,a);
  end if;
end ggt;


function teilerfremd (m,n: integer) return integer is
 -- liefert 1, falls m,n teilerfremd, sonst 0 (als integer)
 begin
  if ggt(m,n)=1 then return 1;
    else return 0;
  end if;
end teilerfremd;

end Teiler;



