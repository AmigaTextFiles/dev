-- Demonstration eines rekursiven Algorhitmus
-- Norman Walter, Universität Stuttgart
-- 22.11.2000

with text_io,ada.integer_text_io;
use text_io,ada.integer_text_io;

procedure fakultaet is

n: integer;

function fak(n: in  integer) return integer is

 begin
   if (n=1) then return 1 ;  -- Ausstiegsbedingung
   else return n*fak(n-1);   -- Rekursion: Funktion ruft sich selbst auf.
   end if;
end fak;

begin

 put("Geben Sie eine Zahl ein : ");
 get(n);
 put("Fakultaet : ");Put(fak(n),1);


end fakultaet;
