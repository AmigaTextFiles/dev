-- Schlangentest
-- Norman Walter
-- Datum: 2.2.2002

-- Testprogramm für das generische Schlangenpaket (FIFO)

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

with schlangenpaket;

procedure schlangentest is

   -- Der konkrete Datentyp für unsere Schlange sei Integer
   package int_schlange is new schlangenpaket(integer);
   use int_schlange;

   fifo_info: schlangen_infos;
   eintrag: integer;

begin

   put("Lege den Wert 2 auf den Stack");
   new_line;
   push(fifo_info,2);

   put("Lege den Wert 3 auf den Stack");
   new_line;
   push(fifo_info,3);

   put("Lege den Wert 5 auf den Stack");
   new_line;
   push(fifo_info,5);

   for i in 1..3 loop

     put("Nehme ersten Eintrag vom Stack ab");
     new_line;
     pop(fifo_info,eintrag);
     put("Wert=");put(eintrag,0);
     new_line;

   end loop;

   if schlange_leer(fifo_info) then
      put("Stack ist leer");
      new_line;
   end if;

   put("Alles OK");

end schlangentest;
