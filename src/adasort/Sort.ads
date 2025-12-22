--
--  Elementare Sortieralgorithmen in Ada
--  Norman Walter, Universität Stuttgart
--  Datum: 25.8.2001
--

with text_io,ada.integer_text_io;
use  text_io,ada.integer_text_io;

package Sort is

 subtype Index_Typ is Natural;

 type Element_Typ is new Integer;
 -- Oder anderer Typ mit Ordnungsrelation

 type Feld_Typ is array(Index_Typ range <>) of Element_Typ;

Procedure Display (A: in Feld_Typ);
-- Gibt komplettes Array aus

Procedure Swap (A,B: in out Element_Typ);
-- Vertauscht zwei Elemente

Procedure Bubble_Sort (Sort_Array: in out Feld_Typ);
-- Bubble Sort Algorithmus

Procedure Selection_Sort (Sort_Array: in out Feld_Typ);
-- Selection Sort Algorithmus

end Sort;

