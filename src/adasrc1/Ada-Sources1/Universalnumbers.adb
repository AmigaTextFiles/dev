-- Programmname      : Universalnumbers
-- Source            : Universalnumbers.adb
-- Version           : 1.01 (4.12.2000)
-- Autor             : Norman Walter, Universität Stuttgart
-- Mehr Infos unter  : http://rupert.informatik.uni-stuttgart.de/~walternn/
-- Maschine          : A1200
-- CPU               : Motorola XC68060
-- Zweck             : Ließt eine Zahl an einer Basis ein,
--                     gibt sie in Dezimaldarstellung wieder.

-- Compiliert und getestet mit GNU GNAT, dem freie verfügbaren Ada Compiler,
-- Version 3.10 von der GeekGadgets May 98 Snapshoot CD-ROM

with text_io,ada.integer_text_io,getanynumber;
use  text_io,ada.integer_text_io,getanynumber;

procedure universalnumbers is

 num,base: natural;

 begin

  New_Line;
  put("Ließt eine Basis und eine Zahl ein, gibt sie in Dezimaldarstellung aus.");
  New_Line;

 loop

   New_Line;
   put("Basis (0=Ende) : "); get(base);
   exit when (base=0);    -- Eingabe von 0 beendet die Eingabe
   put("Zahl : ");
   GetANumber(num,base);  -- Benutzt GetANumber Prozedur aus dem Paket GetAnyNumber

   Put("Dezimaldarstellung : ");put(num,1);
   New_Line;

 end loop;

end universalnumbers;
