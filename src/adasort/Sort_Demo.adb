-- Demo für Sortieralgorithmus
-- Norman Walter, Universität Stuttgart
-- Datum: 25.8.2001

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

with Sort;
use  Sort;

procedure Sort_Demo is

 -- Demo Array auffüllen;
 -- Die Zahlen sind hier ASCII-Werte.

 wahl: integer;

 Demo_Array: Feld_Typ := (65,83,79,82,84,73,78,71,69,88,65,77,80,76,69);

 begin

   New_Line;
   put_line("Demonstration elementarer Sortieralgorithmen");

   Auswahl: loop

   Demo_Array := (65,83,79,82,84,73,78,71,69,88,65,77,80,76,69);

   New_Line;

   put_line("[1] Bubble Sort");
   put_line("[2] Selection Sort");
   put_line("[0] Ende");
   New_Line;
   put("Bitte wählen: ");
   get(wahl);

   New_Line;

   case wahl is

     when 1 => put_line("Bubble Sort Algorithmus");
               New_Line;
               Display(Demo_Array);
               Bubble_Sort(Demo_Array);

     when 2 => put_line("Selection Sort Algorithmus");
               New_Line;
               Display(Demo_Array);
               Selection_Sort(Demo_Array);

     when 0 => exit Auswahl;

     when others => put_line("Fehlerhafte Eingabe");

   end case;

   end loop Auswahl;

end Sort_Demo;
