--
--  Elementare Sortieralgorithmen in Ada
--  Norman Walter, Universität Stuttgart
--  Datum: 25.8.2001
--

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

package body Sort is

Procedure Display (A: in Feld_Typ) is
-- Gibt komplettes Array aus

begin

   for i in A'First..A'Last loop
     put(character'val(A(i))&" ");
     -- Die Integer Werte werden hier als ASCII Zeichen ausgegeben
   end loop;
   New_Line;

end Display;

Procedure Swap (A,B: in out Element_Typ) is
-- Vertauscht zwei Elemente
T: Element_Typ := A;
begin
    A:=B;
    B:=T;
end Swap;

Procedure Bubble_Sort (Sort_Array: in out Feld_Typ) is

 --  Bubble Sort Algorithmus
 --  Eigenschaften: Bubble Sort benötigt im Durchschnitt
 --  und im ungünstigsten Fall ungefähr N^2/2 Vergleiche
 --  und N^2/2 Austauschoperationen.

begin

    for Unsorted in reverse Sort_Array'First .. Sort_Array'Last - 1 loop
            for j in Sort_Array'First .. Unsorted loop
                if Sort_Array (j) > Sort_Array (j+1) then
                    -- Sortieren durch direktes Austauschen
                    Swap (Sort_Array (j), Sort_Array (j+1));
                    Display(Sort_Array);
               end if;
            end loop;
      end loop;

end Bubble_Sort;

Procedure Selection_Sort (Sort_Array: in out Feld_Typ) is

 --  Eigenschaften: Selection Sort benötigt ungefähr
 --  N^2/2 Vergleiche und N Austauschoperationen.
 --  Für Dateien mit großen Datensätzen und kleinen
 --  Schlüsseln ist Selection Sort linear.

  Min : Index_Typ; -- Zur Suche nach dem Minimum

begin

   for I in Sort_Array'First .. Sort_Array'Last - 1 loop
     -- I gibt an, wohin das gefundene Minimum getauscht werden soll
     Min := I;
     for J in I+1 .. Sort_Array'Last loop
       if Sort_Array (J) < Sort_Array (Min) then
          Min := J; -- Neues Minimum gefunden
       end if;
     end loop;
     Swap (Sort_Array (Min), Sort_Array (I));
     Display(Sort_Array);
   end loop;

end Selection_Sort;

end Sort;
